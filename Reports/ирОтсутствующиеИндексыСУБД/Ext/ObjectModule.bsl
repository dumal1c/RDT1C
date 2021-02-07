﻿Перем РежимОтладки Экспорт;

Функция СоздатьИндексноеВыражение(ИмяТаблицыСУБД, ТекстПоляПоиска, ТекстПоляСравнения, РассчитыватьСелективность = Ложь)
	
	//СтруктураИмениТаблицыСУБД = ПолучитьСтруктуруИмениТаблицыСУБД(УдалитьКвадратныеСкобки(ИмяТаблицыСУБД)).Имя;
	ТаблицаИндексногоВыражения = Новый ТаблицаЗначений;
	ТаблицаИндексногоВыражения.Колонки.Добавить("ИмяПоляХранения");
	ТаблицаИндексногоВыражения.Колонки.Добавить("Приоритет");
	ТаблицаИндексногоВыражения.Колонки.Добавить("Селективность");
	ПоляПоиска = ирОбщий.СтрРазделитьЛкс(УдалитьКвадратныеСкобки(ТекстПоляПоиска), ",", Истина);
	Для каждого ПолеПоиска Из ПоляПоиска Цикл
		строкаПоляИндексногоВыражения = ТаблицаИндексногоВыражения.Добавить();
		строкаПоляИндексногоВыражения.ИмяПоляХранения = ПолеПоиска;
		строкаПоляИндексногоВыражения.Приоритет = 1;
		строкаПоляИндексногоВыражения.Селективность = ?(РассчитыватьСелективность, РассчитатьСелективностьПоля(ИмяТаблицыСУБД, ПолеПоиска), 1);
	КонецЦикла;
	ПоляСравнения = ирОбщий.СтрРазделитьЛкс(УдалитьКвадратныеСкобки(ТекстПоляСравнения), ",", Истина);
	Для каждого ПолеСравнения Из ПоляСравнения Цикл
		строкаПоляИндексногоВыражения = ТаблицаИндексногоВыражения.Добавить();
		строкаПоляИндексногоВыражения.ИмяПоляХранения = ПолеСравнения;
		строкаПоляИндексногоВыражения.Приоритет = 2;
		строкаПоляИндексногоВыражения.Селективность = ?(РассчитыватьСелективность, РассчитатьСелективностьПоля(ИмяТаблицыСУБД, ПолеСравнения), 1);
	КонецЦикла;
	ТаблицаИндексногоВыражения.Сортировать("Приоритет Возр, Селективность Убыв");
	ТаблицаИндексногоВыражения.Свернуть("ИмяПоляХранения");
	Результат = ирОбщий.СтрСоединитьЛкс(ТаблицаИндексногоВыражения.ВыгрузитьКолонку("ИмяПоляХранения"), ",");
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСтруктуруИмениТаблицыСУБД(ИмяТаблицыСУБД) Экспорт
	
	СтруктураИмени = Новый Структура("База, Имя, ПолноеИмя");
	ИмяТаблицыСУБДБезКвадратныхСкобок = УдалитьКвадратныеСкобки(ИмяТаблицыСУБД);
	ФрагментыИмени = ирОбщий.СтрРазделитьЛкс(ИмяТаблицыСУБДБезКвадратныхСкобок, ".");
	Если ФрагментыИмени.Количество() = 3 Тогда
		СтруктураИмени.База = ФрагментыИмени[0];
		СтруктураИмени.Имя = ФрагментыИмени[2];
		СтруктураИмени.ПолноеИмя = ИмяТаблицыСУБДБезКвадратныхСкобок;
	Иначе
		СтруктураИмени.Имя = ИмяТаблицыСУБД;
	КонецЕсли;
	Возврат СтруктураИмени;
	
КонецФункции

Функция РассчитатьСелективностьПоля(ИмяТаблицы, ИмяПоля)
	
	ТекстЗапроса = "
	|SELECT SUM(CAST(UniquiFieldCount as float))/SUM(CASE WHEN FullCount = 0 THEN 1 ELSE FullCount END) as Selectivity  FROM (
	|SELECT 
	|	  'selectivity' as RowType,
	|	  COUNT(DISTINCT <<ИмяПоля>>) as UniquiFieldCount
	|	  , 0 as FullCount
	|FROM <<ИмяТаблицы>> (NOLOCK)
	|UNION ALL
	|SELECT 
	|  'selectivity',
	|  0
	|  ,SUM(pa.rows) as FullCount
	|FROM sys.tables ta
	|	INNER JOIN sys.partitions pa
	|		ON pa.OBJECT_ID = ta.OBJECT_ID
	|	INNER JOIN sys.schemas sc
	|		ON ta.schema_id = sc.schema_id
	|WHERE ta.name = '<<ИмяТаблицы>>'
	|GROUP BY sc.name,ta.name
	|) as FieldSelectivityData
	|GROUP BY RowType";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"<<ИмяПоля>>", ИмяПоля);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"<<ИмяТаблицы>>", ИмяТаблицы); // тут возможно ошибка 
	Попытка
		ТаблицаРезультата = ирОбщий.ВыполнитьЗапросКЭтойБазеЧерезADOЛкс(ТекстЗапроса);
	Исключение
		ТаблицаРезультата = Неопределено;
	КонецПопытки;
	Если ТаблицаРезультата <> Неопределено Тогда
		Если ТаблицаРезультата.Количество() > 0 Тогда
			Возврат ТаблицаРезультата[0].Selectivity;
		КонецЕсли; 
	КонецЕсли;
	Возврат 0;
	
КонецФункции

Функция УдалитьКвадратныеСкобки(Строка) Экспорт
	
	Результат = СтрЗаменить(СтрЗаменить(Строка,"[",""),"]","");
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИмяИндекса1С(СтрокаПолейSQL, строкаМетаданного)
	
	СтрокаПолейSQL = УдалитьКвадратныеСкобки(СтрокаПолейSQL);
	Если ПустаяСтрока(СтрокаПолейSQL) Тогда 
		Возврат ""; 
	КонецЕсли;
	массивПолей = ирОбщий.СтрРазделитьЛкс(СтрокаПолейSQL, ",", Истина);
	ПоляИндекса = Новый ТаблицаЗначений;
	ПоляИндекса.Колонки.Добавить("ИмяПоля");
	метаданныеПолей1С = строкаМетаданного.Поля;
	метаданныеПолей1С.Индексы.Добавить("ИмяПоляХранения");
	Для каждого полеSQL из массивПолей Цикл
		Если Не ЗначениеЗаполнено(полеSQL) Тогда
			Продолжить;
		КонецЕсли; 
		строкаОписанияПоля = метаданныеПолей1С.Найти(полеSQL, "ИмяПоляХранения");
		Если строкаОписанияПоля = Неопределено Тогда
			ирОбщий.СообщитьЛкс("У объекта " + строкаМетаданного.Метаданные + " не найдено определение поля " + полеSQL, СтатусСообщения.Внимание);
		Иначе
			Если ПустаяСтрока(строкаОписанияПоля.ИмяПоля) Тогда
				строкаПоля = ПоляИндекса.Добавить();
				строкаПоля.ИмяПоля = ОпределитьСистемноеПоле(строкаОписанияПоля.ИмяПоляХранения); //сохраняем исходное имя
			Иначе
				ЗаполнитьЗначенияСвойств(ПоляИндекса.Добавить(),строкаОписанияПоля);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ПоляИндекса.Свернуть("ИмяПоля");
	итоваяСтрока = ирОбщий.СтрСоединитьЛкс(ПоляИндекса.ВыгрузитьКолонку("ИмяПоля"));
	Возврат итоваяСтрока;
	
КонецФункции        

Функция ОпределитьСистемноеПоле(имяПоляSQL)
	
	итоговоеИмяПоля = имяПоляSQL;
	соответствиеСистемныхПолей = Новый Соответствие;
	соответствиеСистемныхПолей.Вставить("_RecordKind", "ВидДвиженияРегистра");
	соответствиеСистемныхПолей.Вставить("_Period", "Период");
	соответствиеСистемныхПолей.Вставить("_KeyField", "КлючевоеПолеТабличнойЧасти");
	системноеСоответствие = соответствиеСистемныхПолей.Получить(имяПоляSQL);
	Если системноеСоответствие <> Неопределено Тогда
		итоговоеИмяПоля = системноеСоответствие;
	Иначе
		//Очень грязный хак для определения системного поля
		массивПоля = ирОбщий.СтрРазделитьЛкс(имяПоляSQL, "_");
		Если Истина
			И массивПоля.Количество() = 3
			И СтрЧислоВхождений(массивПоля[1], "Document") = 1 
			И массивПоля[2] = "IDRRef" 
		Тогда
			итоговоеИмяПоля = "СсылкаДокументВладелец";
		КонецЕсли;
	КонецЕсли;
	Возврат итоговоеИмяПоля;
	
КонецФункции

///////////////////////АНАЛИТИКА ИНДЕКСАЦИИ ////////////////////////////////////////////

Функция ПолучитьНеобходимыеРеквизитыДляИндексации(строкаОтсутствующегоИндекса)
	
	путьМетаданного = ирОбщий.СтрРазделитьЛкс(строкаОтсутствующегоИндекса.ОбъектМетаданных, ".");
	Если путьМетаданного.Количество() < 2 Тогда
		ирОбщий.СообщитьЛкс("Ошибка разбора метаданных объекта " + строкаОтсутствующегоИндекса.ОбъектМетаданных + " неверное имя самого объекта", СтатусСообщения.Внимание);
	КонецЕсли;
	Если путьМетаданного[0] = "Системные" Тогда 
		Возврат ""; 
	КонецЕсли;
	Попытка
		Если путьМетаданного[0] = "ЖурналДокументов" Тогда
			Результат = АнализИндексовЖурнала(строкаОтсутствующегоИндекса);
		ИначеЕсли путьМетаданного[0] = "РегистрНакопления" Тогда
			Результат = АнализИндексовРегистров(строкаОтсутствующегоИндекса);
		ИначеЕсли путьМетаданного[0] = "РегистрРасчета" Тогда
			Результат = АнализИндексовРегистров(строкаОтсутствующегоИндекса);
		ИначеЕсли путьМетаданного[0] = "РегистрБухгалтерии" Тогда
			Результат = АнализИндексовРегистров(строкаОтсутствующегоИндекса);
		ИначеЕсли путьМетаданного[0] = "РегистрСведений" Тогда
			Результат = АнализИндексовРегистровСведений(строкаОтсутствующегоИндекса);
		Иначе
			Результат = АнализИндексов(строкаОтсутствующегоИндекса);
		КонецЕсли; 
	Исключение
		Результат = Неопределено;
		ирОбщий.СообщитьЛкс("Ошибка анализа индекса для объекта " + строкаОтсутствующегоИндекса.ОбъектМетаданных + ": " + ОписаниеОшибки(), СтатусСообщения.Внимание);                                   
	КонецПопытки;
	Возврат Результат;
	
КонецФункции

Функция ОбработатьСвойстваМетаданного(выхМассивНеобходимойИндексации, ПолноеИмяМД, ИмяКоллекцииСвойств, ИндексноеВыражение)
	
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ПолноеИмяМД);
	#Если Сервер И Не Сервер Тогда
		ОбъектМД = Метаданные.РегистрыСведений.КурсыВалют;
	#КонецЕсли
	ПоляИндексногоВыражения = ирОбщий.СтрРазделитьЛкс(ИндексноеВыражение, ",", Истина);
	Для каждого ИмяПоляИндексногоВыражения из ПоляИндексногоВыражения Цикл
		МетаСвойство = ОбъектМД[ИмяКоллекцииСвойств].Найти(ИмяПоляИндексногоВыражения);
		Если МетаСвойство = Неопределено Тогда
			Продолжить;
			//TODO - как обрабатывать такую ситуацию ???
			//_сообщитьОбОшибке("у объекта " + метаОбъект.ПолноеИмя() + " не найдено поля из индексного выражения " + ИмяПоляИндексногоВыражения);
		КонецЕсли;
		Если Истина
			И МетаСвойство.Индексирование = Метаданные.СвойстваОбъектов.Индексирование.НеИндексировать
			И (Ложь
				Или ИмяКоллекцииСвойств <> "Измерения"
				Или Не МетаСвойство.Ведущее 
				)
		Тогда
			 выхМассивНеобходимойИндексации.Добавить(ИмяПоляИндексногоВыражения);
		КонецЕсли;
	КонецЦикла;
	Возврат ПоляИндексногоВыражения;
	
КонецФункции

Функция АнализИндексов(строкаОтсутствующегоИндекса)
	
	НеобходимаИндексация = Новый Массив;
	поляИндексногоВыражения = ОбработатьСвойстваМетаданного(НеобходимаИндексация, строкаОтсутствующегоИндекса.ОбъектМетаданных, "Реквизиты", строкаОтсутствующегоИндекса.ИндексноеВыражение1С);
	строкаОтсутствующегоИндекса.ТипОшибки = ВыводОбОшибке(НеобходимаИндексация, поляИндексногоВыражения);
	Результат = ирОбщий.СтрСоединитьЛкс(НеобходимаИндексация);
	Возврат Результат;
	
КонецФункции

Функция АнализИндексовРегистров(строкаОтсутствующегоИндекса)
	
	НеобходимаИндексация = Новый Массив;
	ОбработатьСвойстваМетаданного(НеобходимаИндексация, строкаОтсутствующегоИндекса.ОбъектМетаданных, "Измерения", строкаОтсутствующегоИндекса.ИндексноеВыражение1С);
	поляИндексногоВыражения = ОбработатьСвойстваМетаданного(НеобходимаИндексация, строкаОтсутствующегоИндекса.ОбъектМетаданных, "Реквизиты", строкаОтсутствующегоИндекса.ИндексноеВыражение1С);
	строкаОтсутствующегоИндекса.ТипОшибки = ВыводОбОшибке(НеобходимаИндексация, поляИндексногоВыражения);
	Результат = ирОбщий.СтрСоединитьЛкс(НеобходимаИндексация);
	Возврат Результат;
	
КонецФункции

Функция АнализИндексовРегистровСведений(строкаОтсутствующегоИндекса)
	
	НеобходимаИндексация = Новый Массив;	
	ОбработатьСвойстваМетаданного(НеобходимаИндексация, строкаОтсутствующегоИндекса.ОбъектМетаданных, "Измерения", строкаОтсутствующегоИндекса.ИндексноеВыражение1С);
	поляИндексногоВыражения = ОбработатьСвойстваМетаданного(НеобходимаИндексация, строкаОтсутствующегоИндекса.ОбъектМетаданных, "Реквизиты", строкаОтсутствующегоИндекса.ИндексноеВыражение1С);
	строкаОтсутствующегоИндекса.ТипОшибки = ВыводОбОшибке(НеобходимаИндексация, поляИндексногоВыражения);
	Результат = ирОбщий.СтрСоединитьЛкс(НеобходимаИндексация);
	Возврат Результат;
	
КонецФункции

Функция АнализИндексовЖурнала(строкаОтсутствующегоИндекса)
	
	Возврат "<Графы журналов не поддерживаются>";
	//МетаданныеСсылка = КэшКонтекстаИис.ПолучитьСсылкуМетаданныхИис(строкаОтсутствующегоИндекса.Инфобаза.КонфигурацияМетаданных, строкаОтсутствующегоИндекса.ОбъектМетаданных);
	//Если МетаданныеСсылка = Неопределено Тогда
	//	Возврат "<Метаданные не найдены в справочнике>";
	//КонецЕсли; 
	//НеобходимаИндексация = Новый Массив;
	//поляИндексногоВыражения = ОбработатьРеквизитыОбъекта(НеобходимаИндексация, метаОбъект.Графы, строкаОтсутствующегоИндекса.ИндексноеВыражение1С);
	//строкаОтсутствующегоИндекса.ТипОшибки = ВыводОбОшибке(НеобходимаИндексация, поляИндексногоВыражения);
	//Результат = ирОбщий.СтрСоединитьЛкс(НеобходимаИндексация);
	//Возврат Результат;
	
КонецФункции

Функция ПолучитьОбъектМетаданных1С(ИмяТаблицыСУБД, выхСтрокаСтруктурыХранения)
	
	СтруктураИмениТаблицыСУБД = ПолучитьСтруктуруИмениТаблицыСУБД(ИмяТаблицыСУБД);
	СтруктураБД = ирКэш.СтруктураХраненияБДЛкс(Истина);
	СтрокаСтруктурыБД = СтруктураБД.Найти(СтруктураИмениТаблицыСУБД.Имя, "ИмяТаблицыХранения");
	ИмяОбъектаМетаданных = "<Неопределено>";
	Если СтрокаСтруктурыБД <> Неопределено Тогда
		ИмяОбъектаМетаданных = СтрокаСтруктурыБД.Метаданные;
		выхСтрокаСтруктурыХранения = СтрокаСтруктурыБД;
	Иначе
		// Сообщить об ошибке
	КонецЕсли;
	Возврат ИмяОбъектаМетаданных;
	
КонецФункции

Функция ВыводОбОшибке(НеобходимаИндексация, ПоляИндексногоВыражения)
	
	Если НеобходимаИндексация.Количество() = ПоляИндексногоВыражения.Количество() Тогда
		Возврат "Необходимо индексировать реквизиты";
	ИначеЕсли НеобходимаИндексация.Количество() = 0 Тогда
		Возврат "Неоптимальные запросы";
	Иначе
		Возврат "Необходимо индексировать реквизиты, Неоптимальные запросы";	
	КонецЕсли;
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	#Если _ Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	СтандартнаяОбработка = Ложь;
	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	ТекстЗапроса = ПолучитьМакет("ЗапросMSSQL").ПолучитьТекст();
	ТаблицаРезультата = ирОбщий.ВыполнитьЗапросКЭтойБазеЧерезADOЛкс(ТекстЗапроса, РежимОтладки = 1,, 0, Ложь);
	#Если _ Тогда
	    ТаблицаРезультата = Новый ТаблицаЗначений;
	#КонецЕсли
	ТаблицаРезультата.Колонки.Добавить("ОбъектМетаданных");
	ТаблицаРезультата.Колонки.Добавить("НеобходимаИндексацияРеквизитов");
	ТаблицаРезультата.Колонки.Добавить("ТипОшибки");
	ТаблицаРезультата.Колонки.Добавить("ИндексноеВыражениеСУБД");
	ТаблицаРезультата.Колонки.Добавить("ИндексноеВыражение1С");
	ТаблицаРезультата.Колонки.Добавить("ПоляПоиска1С");
	ТаблицаРезультата.Колонки.Добавить("НазначениеТаблицы");
	ТаблицаРезультата.Колонки.Добавить("ПоляСравнения1С");
	ТаблицаРезультата.Колонки.Добавить("НаиболееЗатратныеПоля1С");
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаРезультата.Количество(), "Анализ метаданных");
	Для Каждого СтрокаРезультата Из ТаблицаРезультата Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		//НайденныеТаблицы = Новый ТаблицаЗначений;
		//СтрокаРезультата.ТекстЗапросаМета = ирОбщий.ПеревестиТекстЗапросаСУБДВТерминыМетаданных(СтрокаРезультата.query_text, Истина,, НайденныеТаблицы);
		//Если НайденныеТаблицы.Количество() > 0 Тогда
		//	МассивИмен = НайденныеТаблицы.ВыгрузитьКолонку("ИмяМета");
		//	СтрокаРезультата.ТаблицыМетаданных = ирОбщий.СтрСоединитьЛкс(МассивИмен);
		//КонецЕсли; 
		//ИменаТаблиц = ПолучитьОписаниеТаблицХраненияИнфобазы(СтрокаРезультата.Инфобаза); //
		//представлениеСтруктуры = ЗначениеВСтрокуВнутр(ирОбщий.ПолучитьСтруктуруИзСтрокиТаблицыЗначений(СтрокаРезультата));
		//СтрокаРезультата.SQLСтруктура = представлениеСтруктуры;
		СтрокаСтруктурыХранения = Неопределено;
		ИмяТаблицыСУБД = СтрокаРезультата.ИмяТаблицыСУБД;
		СтрокаРезультата.ОбъектМетаданных = ПолучитьОбъектМетаданных1С(ИмяТаблицыСУБД, СтрокаСтруктурыХранения);
		Если СтрокаСтруктурыХранения <> Неопределено Тогда
			СтрокаРезультата.НазначениеТаблицы = СтрокаСтруктурыХранения.Назначение;
		КонецЕсли; 
		СтрокаРезультата.ИндексноеВыражениеСУБД = СоздатьИндексноеВыражение(ИмяТаблицыСУБД, СтрокаРезультата.ПоляПоискаСУБД, СтрокаРезультата.ПоляСравненияСУБД, РассчитыватьСелективность);
		Если СтрокаСтруктурыХранения <> Неопределено И СтрЧислоВхождений(СтрокаРезультата.ОбъектМетаданных, "Системные.") = 0 Тогда
			СтрокаРезультата.ПоляПоиска1С = ПолучитьИмяИндекса1С(СтрокаРезультата.ПоляПоискаСУБД, СтрокаСтруктурыХранения);
			СтрокаРезультата.ПоляСравнения1С = ПолучитьИмяИндекса1С(СтрокаРезультата.ПоляСравненияСУБД, СтрокаСтруктурыХранения);
			СтрокаРезультата.НаиболееЗатратныеПоля1С = ПолучитьИмяИндекса1С(СтрокаРезультата.НаиболееЗатратныеПоляСУБД, СтрокаСтруктурыХранения);
			СтрокаРезультата.ИндексноеВыражение1С = ПолучитьИмяИндекса1С(СтрокаРезультата.ИндексноеВыражениеСУБД, СтрокаСтруктурыХранения);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаРезультата.ОбъектМетаданных) Тогда
			СтрокаРезультата.НеобходимаИндексацияРеквизитов = ПолучитьНеобходимыеРеквизитыДляИндексации(СтрокаРезультата);
		КонецЕсли; 
		СтрокаРезультата.ИмяТаблицыСУБД = УдалитьКвадратныеСкобки(ирОбщий.ПоследнийФрагментЛкс(СтрокаРезультата.ИмяТаблицыСУБД));
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаРезультата);
	Если РежимОтладки = 2 Тогда
		ирОбщий.ОтладитьЛкс(СхемаКомпоновкиДанных, , КонечнаяНастройка, ВнешниеНаборыДанных);
		Возврат;
	КонецЕсли; 
	ДокументРезультат.Очистить();
	ирОбщий.СкомпоноватьВТабличныйДокументЛкс(СхемаКомпоновкиДанных, КонечнаяНастройка, ДокументРезультат, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
КонецПроцедуры
