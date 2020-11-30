﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПлатформа Экспорт;
Перем мСтруктураХраненияSDBL Экспорт;
Перем мСтруктураХраненияСУБД Экспорт;
Перем мКомпонентаCDDB;
Перем мИменаДополнительныхТаблиц Экспорт;

Процедура ОбновитьТаблицы(Знач РазрешитьМедленноеВычислениеРазмеров = Ложь) Экспорт 
	
	Таблицы.Очистить();
	Индексы.Очистить();
	Поля.Очистить();
	
	// Антибаг 8.3.7-8.3.8 https://partners.v8.1c.ru/forum/topic/1486259 Выполнение метода ПолучитьСтруктуруХраненияБазаДанных с фильтром, включающим строку "Константы", приводит к ошибке
	Если Истина
		И ОтборПоМетаданным <> Неопределено 
		И ирКэш.НомерВерсииПлатформыЛкс() > 803001 
		И Метаданные.РежимСовместимости = Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_2_13
	Тогда
		ИндексТаблицы = ОтборПоМетаданным.Найти("Константы");
		Если ИндексТаблицы <> Неопределено Тогда
			ОтборПоМетаданным.Удалить(ИндексТаблицы);
			Сообщить("Таблица Константы удалена из фильтра из-за ошибка платформы 8.3");
		КонецЕсли; 
	КонецЕсли; 

	Если ПоказыватьSDBL Тогда
		Если ОтборПоМетаданным = Неопределено Тогда
			мСтруктураХраненияSDBL = ирКэш.ПолучитьСтруктуруХраненияБДЛкс(Ложь);
		Иначе
			мСтруктураХраненияSDBL = ирОбщий.ПолучитьСтруктуруХраненияБДЛкс(ОтборПоМетаданным, Ложь);
		КонецЕсли; 
		ЗаполнитьТаблицыИзСтруктурыХранения(мСтруктураХраненияSDBL, Ложь);
	КонецЕсли; 
	Если ПоказыватьСУБД Тогда
		Если ОтборПоМетаданным = Неопределено Тогда
			мСтруктураХраненияСУБД = ирКэш.ПолучитьСтруктуруХраненияБДЛкс(Истина);
		Иначе
			мСтруктураХраненияСУБД = ирОбщий.ПолучитьСтруктуруХраненияБДЛкс(ОтборПоМетаданным, Истина);
		КонецЕсли; 
		ЗаполнитьТаблицыИзСтруктурыХранения(мСтруктураХраненияСУБД, Истина);
	КонецЕсли; 
	РезультирующееПоказыватьРазмеры = ПоказыватьРазмеры И ПоказыватьСУБД;
	Если РезультирующееПоказыватьРазмеры Тогда
		ВычислитьРазмерыТаблиц(РазрешитьМедленноеВычислениеРазмеров);
	КонецЕсли; 
	Таблицы.Сортировать("Метаданные, ИмяТаблицы, Назначение, ИмяТаблицыХранения, СУБД");
	Индексы.Сортировать("Метаданные, ИмяТаблицы, Назначение, ИмяТаблицыХранения, ИмяИндекса, ИмяИндексаХранения, СУБД");

КонецПроцедуры

Процедура ВычислитьРазмерыТаблиц(Знач РазрешитьМедленныйСпособ = Ложь) Экспорт 
	
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		РазмерыЗаполнены = ЗаполнитьРазмерыФайлойБазы();
	Иначе
		РазмерыЗаполнены = ЗаполнитьРазмерыБазыMSSQL();
	КонецЕсли; 
	Если Не РазмерыЗаполнены Тогда
		ирОбщий.СостояниеЛкс("Вычисление размеров таблиц...");
		ирОбщий.ВычислитьКоличествоСтрокТаблицВДеревеМетаданныхЛкс();
		Для Каждого СтрокаТаблицы Из Таблицы Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ИмяТаблицы) Тогда
				Продолжить;
			КонецЕсли; 
			ОписаниеТаблицы = ирОбщий.ОписаниеТаблицыБДЛкс(СтрокаТаблицы.ИмяТаблицы);
			Если Истина
				И ОписаниеТаблицы <> Неопределено
				И ОписаниеТаблицы.КоличествоСтрок <> Неопределено 
			Тогда
				СтрокаТаблицы.КоличествоСтрок = ОписаниеТаблицы.КоличествоСтрок;
			КонецЕсли; 
		КонецЦикла;
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Таблицы.Количество(), "Размеры таблиц");
		Для Каждого СтрокаТаблицы Из Таблицы Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ИмяТаблицы) Тогда
				Продолжить;
			КонецЕсли; 
			Если Истина
				И РазрешитьМедленныйСпособ
				И СтрокаТаблицы.Назначение = "Основная" // размер табличных частей включаются в размер основной таблицы
				И ирКэш.НомерВерсииПлатформыЛкс() >= 803015
			Тогда
				Массив = Новый Массив;
				Массив.Добавить(СтрокаТаблицы.Метаданные);
				#Если Сервер И Не Сервер Тогда
					ПолучитьРазмерДанныхБазыДанных(, Массив);
				#КонецЕсли
				//Попытка
					СтрокаТаблицы.РазмерДанные = Вычислить("ПолучитьРазмерДанныхБазыДанных(, Массив)") / 1024;
				//Исключение
				//	Пустышка = 0;
				//КонецПопытки; 
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли;

КонецПроцедуры

Функция ЗаполнитьРазмерыБазыMSSQL()

	Если Не ирОбщий.ПроверитьСоединениеADOЭтойБДЛкс() Тогда
		Возврат Ложь;
	КонецЕсли; 
	ирОбщий.СостояниеЛкс("Вычисление размеров таблиц...");
	ТекстЗапроса = ПолучитьМакет("ЗапросРазмеров").ПолучитьТекст();
	ТаблицаРезультата = ирОбщий.ВыполнитьЗапросКЭтойБазеЧерезADOЛкс(ТекстЗапроса,,,, Ложь);
	Если ОбщаяТаблицаИндексов Тогда
		Для Каждого СтрокаРезультата Из ТаблицаРезультата Цикл
			КлючПоиска = Новый Структура("НИмяТаблицыХранения, НИмяИндексаХранения", НРег(СтрокаРезультата.TableName), НРег(СтрокаРезультата.IndexName));
			СтрокиИндекса = Индексы.НайтиСтроки(КлючПоиска);
			Если СтрокиИндекса.Количество() = 0 Тогда
				Если ОтборПоМетаданным <> Неопределено Тогда
					Продолжить;
				КонецЕсли; 
				СтрокаИндекса = Индексы.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаИндекса, КлючПоиска); 
				СтрокаИндекса.ИмяИндексаХранения = СтрокаРезультата.IndexName;
				СтрокаИндекса.ИмяИндекса = СтрокаРезультата.IndexName;
				СтрокаИндекса.ИмяТаблицыХранения = СтрокаРезультата.TableName;
				СтрокаИндекса.ИмяТаблицы = мИменаДополнительныхТаблиц[ВРег(СтрокаРезультата.TableName)];
				Если Не ЗначениеЗаполнено(СтрокаИндекса.ИмяТаблицы) Тогда
					СтрокаИндекса.ИмяТаблицы = СтрокаРезультата.TableName;
				КонецЕсли; 
				СтрокаИндекса.Назначение = СтрокаИндекса.ИмяТаблицы;
				СтрокаИндекса.СУБД = Истина;
			Иначе
				СтрокаИндекса = СтрокиИндекса[0];
			КонецЕсли; 
			СтрокаИндекса.ТипИндекса = СтрокаРезультата.IndexType;
			СтрокаИндекса.РазмерИндексы = СтрокаРезультата.IndexKB;
			СтрокаИндекса.РазмерОбщий = СтрокаРезультата.ReservedKB;
		КонецЦикла;
	КонецЕсли; 
	ТаблицаРезультата.Свернуть("TableName", "IndexKB, ReservedKB, DataKB, Rows");
	Для Каждого СтрокаРезультата Из ТаблицаРезультата Цикл
		СтрокаТаблицы = Таблицы.Найти(НРег(СтрокаРезультата.TableName), "НИмяТаблицыХранения");
		Если СтрокаТаблицы = Неопределено Тогда
			Если ОтборПоМетаданным <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТаблицы = Таблицы.Добавить();
			СтрокаТаблицы.ИмяТаблицыХранения = СтрокаРезультата.TableName;
			СтрокаТаблицы.НИмяТаблицыХранения = НРег(СтрокаТаблицы.ИмяТаблицыХранения);
			СтрокаТаблицы.ИмяТаблицы = мИменаДополнительныхТаблиц[ВРег(СтрокаРезультата.TableName)];
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ИмяТаблицы) Тогда
				СтрокаТаблицы.ИмяТаблицы = СтрокаРезультата.TableName;
			КонецЕсли; 
			СтрокаТаблицы.Назначение = СтрокаТаблицы.ИмяТаблицы;
			СтрокаТаблицы.СУБД = Истина;
		КонецЕсли; 
		СтрокаТаблицы.РазмерИндексы = СтрокаРезультата.IndexKB;
		СтрокаТаблицы.РазмерОбщий = СтрокаРезультата.ReservedKB;
		СтрокаТаблицы.КоличествоСтрок = СтрокаРезультата.Rows;
		СтрокаТаблицы.РазмерДанные = СтрокаРезультата.DataKB;
	КонецЦикла; 
	Возврат Истина;

КонецФункции

Функция ЗаполнитьРазмерыФайлойБазы()
		
	//Если ирКэш.НомерВерсииПлатформыЛкс() > 803008 Тогда
	//	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	//	Каталог = Нстр(СтрокаСоединения, "File");
	//	ФайлБазы = Каталог + "\1Cv8.1CD";
	//	КомандаСистемы = """" + КаталогПрограммы() + "CNVDBFL.EXE"" -i """ + ФайлБазы + """";
	//	Текст = ирОбщий.ПолучитьТекстРезультатаКомандыОСЛкс(КомандаСистемы);
	//	Если Найти(Текст, "8.2.14") = 0 Тогда
	//		Сообщить(Текст + " Получения размеров файловой базы для текущего формата базы не поддерживается", СтатусСообщения.Внимание);
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли; 
	ирОбщий.СостояниеЛкс("Вычисление размеров таблиц...");
	ирОбщий.ВычислитьКоличествоСтрокТаблицВДеревеМетаданныхЛкс();
	Компонента1CD = мПлатформа.ПолучитьОбъектВнешнейКомпонентыИзМакета("_1CDLib", "T1CDLib.DB1CD", "T1CDLib", ТипВнешнейКомпоненты.Native);
	ПапкаОб = НСтр(СтрокаСоединенияИнформационнойБазы(), "File");
	ИмяЛога = ПапкаОб + "\logdb1cd.log";
	ИмяФайла = ПапкаОб + "\1cv8.1cd";
	мКомпонентаCDDB = Новый("AddIn.T1CDLib.DB1CD");
	мКомпонентаCDDB.LogLevel=0;
	мКомпонентаCDDB.FileOpeningMode=3;
	//FileDB.OpenLogFile(ИмяЛога);
	#Если Клиент Тогда
	Состояние("Чтение структуры файла");
	#КонецЕсли 
	мКомпонентаCDDB.Open1CDFile(ИмяФайла);
	мКомпонентаCDDB.OpenMetadata();
	ВерсияБД = мКомпонентаCDDB.BaseVersion;
	//Элементы.НадписьВерсияБД.Заголовок="Версия БД: "+ВерсияБД;
	ArrayPres = мКомпонентаCDDB.GetTablesArray(Ложь);
	TablesArray = ЗначениеИзСтрокиВнутр(ArrayPres);
	Для TabInd = 1 По TablesArray.Count() Цикл
		TableInfo = TablesArray[TabInd-1];
		СтрокаТаблицы = Таблицы.Найти(НРег(TableInfo.Name), "НИмяТаблицыХранения");
		Если СтрокаТаблицы = Неопределено Тогда
			Если ОтборПоМетаданным <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТаблицы = Таблицы.Добавить();
			//ТекСтр.НомерПП = TabInd;
			СтрокаТаблицы.ИмяТаблицыХранения = TableInfo.Name;
			СтрокаТаблицы.НИмяТаблицыХранения = НРег(СтрокаТаблицы.ИмяТаблицыХранения);
			СтрокаТаблицы.ИмяТаблицы = мИменаДополнительныхТаблиц[ВРег(TableInfo.Name)];
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ИмяТаблицы) Тогда
				СтрокаТаблицы.ИмяТаблицы = TableInfo.Name;
			КонецЕсли; 
			СтрокаТаблицы.Назначение = СтрокаТаблицы.ИмяТаблицы;
			СтрокаТаблицы.СУБД = Истина;
			//ТекСтр.НазначениеТаблицы = ПолучитьТипТаблицы(TableInfo.Name);
			//ТекСтр.ОписаниеТаблицы=TablePres;
		КонецЕсли; 
		СтрокаТаблицы.РазмерДанные = Окр(мКомпонентаCDDB.GetObjectSize(TableInfo.RecordsIndex) / 1024);
		СтрокаТаблицы.РазмерБлоб = Окр(мКомпонентаCDDB.GetObjectSize(TableInfo.BlobIndex) / 1024);
		СтрокаТаблицы.РазмерИндексы = Окр(мКомпонентаCDDB.GetObjectSize(TableInfo.IndexesIndex) / 1024);
		СтрокаТаблицы.РазмерОбщий = СтрокаТаблицы.РазмерДанные + СтрокаТаблицы.РазмерБлоб + СтрокаТаблицы.РазмерИндексы;
		Если ПоказыватьУдаленные Тогда
			ПолучитьРазмерУдалДанных(TableInfo.Name, СтрокаТаблицы);
		КонецЕсли;
		ОписаниеТаблицы = ирОбщий.ОписаниеТаблицыБДЛкс(СтрокаТаблицы.ИмяТаблицы);
		Если Истина
			И ОписаниеТаблицы <> Неопределено
			И ОписаниеТаблицы.КоличествоСтрок <> Неопределено 
		Тогда
			СтрокаТаблицы.КоличествоСтрок = ОписаниеТаблицы.КоличествоСтрок;
		Иначе
			Пустышка = 0; // Для отладки
		КонецЕсли; 
	КонецЦикла;
	мКомпонентаCDDB.CloseFile();
	мКомпонентаCDDB.CloseLogFile();
	Возврат Истина;

КонецФункции

Функция ПолучитьРазмерУдалДанных(TabName,ТекСтр)
	РазмерУдал=0;
	РазмерУдалБлоб=0;
	
	Если мКомпонентаCDDB.OpenTable(0,TabName) Тогда
		РазмерУдалБлоб=мКомпонентаCDDB.GetDelBlobDataLength(0);
		Рез=мКомпонентаCDDB.MoveToRecord(0,0);
		NextInd=мКомпонентаCDDB.GetNextDelRecordIndex(0);
		КолвоУдал=0;
		Пока Рез И (NextInd>0) Цикл
			КолвоУдал=КолвоУдал+1;
			Рез=мКомпонентаCDDB.MoveToRecord(0,NextInd);
			NextInd=мКомпонентаCDDB.GetNextDelRecordIndex(0);
		КонецЦикла;
		РазмерУдал=КолвоУдал*мКомпонентаCDDB.GetTableRecordLength(0);
	КонецЕсли;
	
	мКомпонентаCDDB.CloseTable(0);
	
	ТекСтр.РазмерУдаленЗаписи=РазмерУдал;
	ТекСтр.РазмерУдаленБлоб=РазмерУдалБлоб;
	ТекСтр.РазмерУдаленОбщий=ТекСтр.РазмерУдаленЗаписи+ТекСтр.РазмерУдаленБлоб;
	Возврат Истина;
КонецФункции

Процедура ЗаполнитьТаблицыИзСтруктурыХранения(Знач СтруктураХранения, ЭтоСУБД)
	
	#Если Сервер И Не Сервер Тогда
	    СтруктураХранения = Новый ТаблицаЗначений;
	#КонецЕсли
	НуженПеревод = Неопределено;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СтруктураХранения.Количество(), "Структура " + ?(ЭтоСУБД, "СУБД", "SDBL"));
	Для Каждого СтрокаСтруктурыХранения Из СтруктураХранения Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		СтрокаТаблицы = Таблицы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаСтруктурыХранения); 
		СтрокаТаблицы.Поля = СтрокаСтруктурыХранения.Поля.Количество();
		СтрокаТаблицы.Индексы = СтрокаСтруктурыХранения.Индексы.Количество();
		СтрокаТаблицы.СУБД = ЭтоСУБД;
		СтрокаТаблицы.НИмяТаблицыХранения = НРег(СтрокаТаблицы.ИмяТаблицыХранения);
		СтрокаТаблицы.ШаблонИмениХранения = ШаблонИмениХранения(СтрокаТаблицы.ИмяТаблицыХранения);
		Если ОбщаяТаблицаИндексов Тогда
			//Если НуженПеревод <> Ложь Тогда
			//	ирОбщий.ПеревестиКолонкиСтруктурыХраненияБДИндексыЛкс(СтрокаСтруктурыХранения.Индексы, НуженПеревод);
			//КонецЕсли; 
			Для Каждого СтрокаХраненияИндекса Из СтрокаСтруктурыХранения.Индексы Цикл
				СтрокаИндекса = Индексы.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаИндекса, СтрокаТаблицы); 
				СтрокаИндекса.ИмяИндекса = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(СтрокаХраненияИндекса, СтрокаТаблицы.СУБД, СтрокаСтруктурыХранения);
				СтрокаИндекса.ИмяИндексаХранения = СтрокаХраненияИндекса.ИмяИндексаХранения;
				СтрокаИндекса.Поля = СтрокаХраненияИндекса.Поля.Количество();
				СтрокаИндекса.НИмяИндексаХранения = НРег(СтрокаИндекса.ИмяИндексаХранения);
				СтрокаИндекса.НИмяТаблицыХранения = НРег(СтрокаИндекса.ИмяТаблицыХранения);
				СтрокаИндекса.ШаблонИмениХранения = ШаблонИмениХранения(СтрокаИндекса.ИмяТаблицыХранения);
			КонецЦикла;
		КонецЕсли; 
		Если ОбщаяТаблицаПолей Тогда
			//Если НуженПеревод <> Ложь Тогда
			//	ирОбщий.ПеревестиКолонкиСтруктурыХраненияБДИндексыЛкс(СтрокаСтруктурыХранения.Индексы, НуженПеревод);
			//КонецЕсли; 
			Для Каждого СтрокаПоляХранения Из СтрокаСтруктурыХранения.Поля Цикл
				СтрокаПоля = Поля.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПоля, СтрокаТаблицы); 
				ЗаполнитьЗначенияСвойств(СтрокаПоля, СтрокаПоляХранения); 
				СтрокаПоля.ИмяПоля = ирОбщий.ПолучитьПредставлениеПоляБДЛкс(СтрокаПоляХранения, СтрокаТаблицы.СУБД, Найти(СтрокаТаблицы.Метаданные, "ТабличнаяЧасть.") > 0);
				СтрокаПоля.ШаблонИмениХранения = ШаблонИмениХранения(СтрокаПоля.ИмяТаблицыХранения);
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();

КонецПроцедуры

Функция ШаблонИмениХранения(Знач ИмяХранения)
	
	ИмяХранения = Лев(ИмяХранения, СтрДлина(ИмяХранения));
	Результат = "";
	ПоследнееИмяШаблона = "";
	КоличествоСимволов = 0;
	ПозицияЧисла = 0;
	Пока ирОбщий.НайтиЧислоВСтрокеЛкс(ИмяХранения, ПозицияЧисла, КоличествоСимволов) Цикл
		ПоследнееИмяШаблона = Лев(ИмяХранения, ПозицияЧисла - 1);
		Результат = Результат + ПоследнееИмяШаблона + "*";
		ИмяХранения = Прав(ИмяХранения, СтрДлина(ИмяХранения) - ПозицияЧисла - КоличествоСимволов + 1);
	КонецЦикла;
	Результат = Результат + ИмяХранения;
	Возврат Результат;
	
КонецФункции 

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

мПлатформа = ирКэш.Получить();
мИменаДополнительныхТаблиц = Новый Соответствие;
мИменаДополнительныхТаблиц.Вставить("CONFIG", "КонфигурацияБД");
мИменаДополнительныхТаблиц.Вставить("CONFIGSAVE", "СохранённаяКонфигурация");
мИменаДополнительныхТаблиц.Вставить("DBSCHEMA", "СхемаБД");
мИменаДополнительныхТаблиц.Вставить("DBCHANGES", "ИзмененияСхемыБД");
мИменаДополнительныхТаблиц.Вставить("FILES", "Файлы");
мИменаДополнительныхТаблиц.Вставить("PARAMS", "СлужебныеПараметры");
мИменаДополнительныхТаблиц.Вставить("V8USERS", "Пользователи");
мИменаДополнительныхТаблиц.Вставить("IBVERSION", "ВерсияИБ");
мИменаДополнительныхТаблиц.Вставить("DEPOTFILES", "НастройкиХранилищаКонфигурации");
мИменаДополнительныхТаблиц.Вставить("_YEAROFFSET", "СмещениеХраненияДатВГодах");
мИменаДополнительныхТаблиц.Вставить("CONFIGCAS", "СистемноеХранилищеКонфигурацийРасширений");
мИменаДополнительныхТаблиц.Вставить("CONFIGCASSAVE", "СохраненноеСистемноеХранилищеКонфигурацийРасширений");
