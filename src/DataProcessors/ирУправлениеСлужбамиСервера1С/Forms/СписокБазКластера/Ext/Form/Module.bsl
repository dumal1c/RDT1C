﻿Перем КонсольЗапросов;

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	//ирКлиент.УстановитьДоступностьВыполненияНаСервереЛкс(ЭтаФорма);
	ОбновитьСписок();
	ЭлементыФормы.ДействияФормы.Кнопки.ВыгрузитьБД.Доступность = ИсполняемыйФайлаАвтономногоСервера().Существует();
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуБазИзФайловКластера(КаталогКластера, ВычислятьРазмеры = Истина) Экспорт 
	
	БазыКластера.Очистить();
	ИмяФайлаКонфигурацииКластера = КаталогКластера + "\1CV8Clst.lst"; // Новый формат
	ФайлКонфигурацииКластера = Новый Файл(ИмяФайлаКонфигурацииКластера);
	Если Не ФайлКонфигурацииКластера.Существует() Тогда
		ИмяФайлаКонфигурацииКластера = КаталогКластера + "\1CV8Reg.lst"; // Старый формат
		ФайлКонфигурацииКластера = Новый Файл(ИмяФайлаКонфигурацииКластера);
		Если Не ФайлКонфигурацииКластера.Существует() Тогда
			ВызватьИсключение "Не обнаружен файл настроек (1CV8Clst.lst или 1CV8Reg.lst) кластера (" + КластерИмя + ")";
		КонецЕсли; 
	КонецЕсли; 
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайлаКонфигурацииКластера);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	ДокументDOM = ирОбщий.ДокументDOMИзСтрокиВнутрЛкс(ТекстФайла);
	РазыменовательПИ = Новый РазыменовательПространствИменDOM(ДокументDOM);
	ИмяЭлемента = "/elem/elem[2]/elem";
	РезультатXPath = ДокументDOM.ВычислитьВыражениеXPath(ИмяЭлемента, ДокументDOM, РазыменовательПИ, ТипРезультатаDOMXPath.УпорядоченныйИтераторУзлов);
	Пока 1 = 1 Цикл
		Узел = РезультатXPath.ПолучитьСледующий();
		Если Узел = Неопределено Тогда
			Прервать;
		КонецЕсли;
		ДочерниеУзлы = Узел.ДочерниеУзлы;
		//data1   "godBase"
		//data2   "смещение дат: 2000"
		//data3   "MSSQLServer"
		//data4   "srv1"
		//data5   "godBaseSQL"
		//data6   ""
		//data7   "OxVMlMou/iAmgzxunhUeaA=="
		//data8   "CrSQLDB=Y;DB=godBaseSQL;DBMS=MSSQLServer;
		//data9   0
		//elem   
		//    data  0
		//    data  00010101000000
		//    data  00010101000000
		//    data  ""
		//    data  ""
		//    data  ""
		//data   0
		//data   1
		ОписаниеБазы = БазыКластера.Добавить();
		ОписаниеБазы.Идентификатор = ДочерниеУзлы[0].ТекстовоеСодержимое;
		ОписаниеБазы.Имя = ирОбщий.ТекстИзВыраженияВстроенногоЯзыкаЛкс(ДочерниеУзлы[1].ТекстовоеСодержимое);
		ОписаниеБазы.ТипСУБД = ирОбщий.ТекстИзВыраженияВстроенногоЯзыкаЛкс(ДочерниеУзлы[3].ТекстовоеСодержимое);
		ОписаниеБазы.СерверСУБД = ирОбщий.ТекстИзВыраженияВстроенногоЯзыкаЛкс(ДочерниеУзлы[4].ТекстовоеСодержимое);
		ОписаниеБазы.БазаСУБД = ирОбщий.ТекстИзВыраженияВстроенногоЯзыкаЛкс(ДочерниеУзлы[5].ТекстовоеСодержимое);
		Попытка
			ОписаниеБазы.Описание = Вычислить(ДочерниеУзлы[2].ТекстовоеСодержимое);
		Исключение
			// Если там попадется спец. символ, то парсинг мог пройти некорректно в этом узле
			ОписаниеБазы.Описание = ДочерниеУзлы[2].ТекстовоеСодержимое;
		КонецПопытки;
	КонецЦикла;
	// Отсутствующие в реестре кластера базы
	Файлы = НайтиФайлы(КаталогКластера, "*.*");
	Для Каждого Файл Из Файлы Цикл
		Если Ложь
			Или Не Файл.ЭтоКаталог()
			Или Найти(НРег(Файл.Имя), "snccntx") = 1
		Тогда
			Продолжить;
		КонецЕсли; 
		ИдентификаторБазы = Файл.Имя;
		ОписаниеБазы = БазыКластера.Найти(ИдентификаторБазы, "Идентификатор");
		Если ИдентификаторБазы <> Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		ОписаниеБазы = БазыКластера.Добавить();
		ОписаниеБазы.Идентификатор = ИдентификаторБазы;
	КонецЦикла;
	Если ВычислятьРазмеры Тогда
		Для Каждого СтрокаБазы Из БазыКластера Цикл
			КаталогИнфобазы = КаталогКластера + "\" + СтрокаБазы.Идентификатор + "\";
			ФайлНовогоФорматаЖурнала = Новый Файл(КаталогИнфобазы + "1Cv8Log\1Cv8.lgd");
			ФайлСтарогоФорматаЖурнала = Новый Файл(КаталогИнфобазы + "1Cv8Log\1Cv8.lgf");
			СтрокаБазы.НовыйФорматЖурнала = Истина
				И ФайлНовогоФорматаЖурнала.Существует()
				И (Ложь
					Или Не ФайлСтарогоФорматаЖурнала.Существует()
					Или ФайлНовогоФорматаЖурнала.ПолучитьВремяИзменения() > ФайлСтарогоФорматаЖурнала.ПолучитьВремяИзменения());
			СтрокаБазы.РазмерЖурналаРегистрацииМБ = ирОбщий.ВычислитьРазмерКаталогаЛкс(КаталогИнфобазы + "1Cv8Log") / 1024 / 1024;
			СтрокаБазы.РазмерИндексаПоискаМБ = ирОбщий.ВычислитьРазмерКаталогаЛкс(КаталогИнфобазы + "1Cv8FTxt") / 1024 / 1024;
			СтрокаБазы.РазмерОбщийМБ = СтрокаБазы.РазмерЖурналаРегистрацииМБ + СтрокаБазы.РазмерИндексаПоискаМБ;
		КонецЦикла;
		СерверыMSSQL = ирОбщий.РазличныеЗначенияКолонкиТаблицыЛкс(БазыКластера, "СерверСУБД", Новый Структура("ТипСУБД", "MSSQLServer"));
		Для Каждого СерверMSSQL Из СерверыMSSQL Цикл
			СоединениеADO = СоединениеADO(СерверMSSQL);
			Если СоединениеADO = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			БазыСУБД = ВыполнитьЗапросADO(СоединениеADO, "sp_helpdb"); // status, owner, db_size, created
			РазмерыБазДанных = ВыполнитьЗапросADO(СоединениеADO, "sp_databases"); // DATABASE_SIZE
			ЖурналыБаз = ВыполнитьЗапросADO(СоединениеADO, "DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS"); // _LogSize_MB_ , _LogSpaceUsed___
			ЖурналыБаз.Колонки[0].Имя = "_DatabaseName"; // Почему то первый раз возвращается DatabaseName, а потом уже _DatabaseName
			Для Каждого СтрокаСУБД Из БазыСУБД Цикл
				СтрокаБазы = БазыКластера.НайтиСтроки(Новый Структура("СерверСУБД, БазаСУБД", СерверMSSQL, СтрокаСУБД.name));
				Если СтрокаБазы.Количество() > 0 Тогда
					СтрокаБазы[0].СозданаСУБД = СтрокаСУБД.created;
					СтрокаБазы[0].СтатусСУБД = СтрокаСУБД.status;
					СтрокаБазы[0].МодельСУБД = ирОбщий.СтрокаМеждуМаркерамиЛкс(НРег(СтрокаСУБД.status), "recovery=", ",");
				КонецЕсли; 
			КонецЦикла;
			Для Каждого СтрокаРазмера Из РазмерыБазДанных Цикл
				СтрокаБазы = БазыКластера.НайтиСтроки(Новый Структура("СерверСУБД, БазаСУБД", СерверMSSQL, СтрокаРазмера.DATABASE_NAME));
				Если СтрокаБазы.Количество() > 0 Тогда
					СтрокаБазы[0].РазмерСУБДОбщийМБ = СтрокаРазмера.DATABASE_SIZE / 1024;
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьСписок()
	
	СостояниеСтрок = ирКлиент.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.БазыКластера, "Идентификатор");
	ЗаполнитьТаблицуБазИзФайловКластера(КаталогКластера, ВычислятьРазмеры);
	БазыКластера.Сортировать("Имя, Идентификатор");
	ирКлиент.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.БазыКластера, СостояниеСтрок);

КонецПроцедуры

Процедура СписокБазПользователяПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	#Если Сервер И Не Сервер Тогда
		ДанныеСтроки = БазыКластера.Добавить();
	#КонецЕсли
	ОформлениеСтроки.Ячейки.СУБД.Видимость = Ложь;
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	//Если Ложь
	//	Или (Истина
	//		И ЗначениеЗаполнено(ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс())
	//		И ДанныеСтроки.КлючСтроки = НРег(ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс()))
	//	Или (Истина
	//		И Не ЗначениеЗаполнено(ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс())
	//		И ДанныеСтроки.НСтрокаСоединения = НРег(СтрокаСоединенияИнформационнойБазы()))
	//Тогда
	//	ОформлениеСтроки.ЦветФона = ирОбщий.ЦветФонаАкцентаЛкс(); 
	//КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ОбновитьСписок();
	
КонецПроцедуры

Процедура СписокБазПользователяВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущиеДанные = ЭлементыФормы.БазыКластера.ТекущиеДанные;
	ИдентификаторВКластере = ТекущиеДанные.Идентификатор;
	Если Колонка = ЭлементыФормы.БазыКластера.Колонки.РазмерЖурналаРегистрацииМБ Тогда
		ЗапуститьПриложение(КаталогКластера + "\" + ИдентификаторВКластере + "\1Cv8Log");
	ИначеЕсли Колонка = ЭлементыФормы.БазыКластера.Колонки.РазмерИндексаПоискаМБ Тогда
		ЗапуститьПриложение(КаталогКластера + "\" + ИдентификаторВКластере + "\1Cv8FTxt");
	ИначеЕсли Колонка = ЭлементыФормы.БазыКластера.Колонки.РазмерОбщийМБ Тогда
		ЗапуститьПриложение(КаталогКластера + "\" + ИдентификаторВКластере);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОткрытьФайлВПроводнике(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирКлиент.ОткрытьФайлВПроводникеЛкс(Элемент.Значение);
	
КонецПроцедуры

Процедура ДействияФормыИТС(Кнопка)
	
	ЗапуститьПриложение("https://its.1c.ru/db/v8314doc/bookmark/adm/TI000000120");
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка)
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СписокБазПользователяПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ВычислятьРазмерыПриИзменении(Элемент)
	
	ОбновитьСписок();
	
КонецПроцедуры

Процедура ДействияФормыОчиститьЖурнал(Кнопка)
	Ответ = Вопрос("Вы уверены что хотите очистить журнал регистрации базы (все файлы должны быть свободны)?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	ИмяПустогоФайлаДляСоздания = "";
	Ответ = Вопрос("Хотите после очистки журнала перевести его в старый формат (рекомендуется)?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ИмяПустогоФайлаДляСоздания = "1Cv8.lgf";
	КонецЕсли;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ЭлементыФормы.БазыКластера.ВыделенныеСтроки.Количество());
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.БазыКластера.ВыделенныеСтроки Цикл
		#Если Сервер И Не Сервер Тогда
			ВыделеннаяСтрока = БазыКластера.Добавить();
		#КонецЕсли
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		УдалитьФайлыБазыВКластере(ВыделеннаяСтрока.Идентификатор, "1Cv8Log", ИмяПустогоФайлаДляСоздания);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ОбновитьСписок();

КонецПроцедуры

Процедура ДействияФормыОчиститьИндексПоиска(Кнопка)
	Ответ = Вопрос("Вы уверены что хотите очистить индекс полнотекстового поиска инфобазы (все файлы должны быть свободны)?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ЭлементыФормы.БазыКластера.ВыделенныеСтроки.Количество());
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.БазыКластера.ВыделенныеСтроки Цикл
		#Если Сервер И Не Сервер Тогда
			ВыделеннаяСтрока = БазыКластера.Добавить();
		#КонецЕсли
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		УдалитьФайлыБазыВКластере(ВыделеннаяСтрока.Идентификатор, "1Cv8FTxt");
	КонецЦикла;  
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ОбновитьСписок();
КонецПроцедуры

Процедура УдалитьФайлыБазыВКластере(Идентификатор, Подкаталог, ИмяПустогоФайлаДляСоздания = "")
	
	ОчищаемыйКаталог = КаталогКластера + "\" + Идентификатор + "\" + Подкаталог;
	Попытка
		УдалитьФайлы(ОчищаемыйКаталог);
		УдалениеУспешно = Истина;
	Исключение
		Сообщить("Не удалось каталог инфобазы: " + ОписаниеОшибки());
		УдалениеУспешно = Ложь;
	КонецПопытки; 
	Если УдалениеУспешно Тогда 
		СоздатьКаталог(ОчищаемыйКаталог);
		Если ЗначениеЗаполнено(ИмяПустогоФайлаДляСоздания) Тогда
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Записать(ОчищаемыйКаталог + "\" + ИмяПустогоФайлаДляСоздания, КодировкаТекста.OEM);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КаталогКластераНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ирКлиент.ВыбратьКаталогВФормеЛкс(КаталогКластера) <> Неопределено Тогда 
		ОбновитьСписок();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыЗапуститьКлиентскоеПриложение(Кнопка)
	ЗапуститьПриложение1С(Ложь);
КонецПроцедуры

Процедура ДействияФормыЗапуститьКонфигуратор(Кнопка)
	ЗапуститьПриложение1С(Истина);
КонецПроцедуры

Процедура ЗапуститьПриложение1С(РежимКонфигуратора)
	ТекущаяСтрока = ЭлементыФормы.БазыКластера.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирКлиент.ЗапуститьПриложение1СЛкс(РежимКонфигуратора, "srvr=" + ИмяКомпьютера() + ":" + КластерИмя + ";Ref=" + ТекущаяСтрока.Имя + ";");
КонецПроцедуры

Процедура ДействияФормыСжатьБазуВСУБД(Кнопка)
	
	Если Ложь
		Или Кнопка = Неопределено
		Или Кнопка.Картинка <> ирКэш.КартинкаПоИмениЛкс("ирОстановить")
	Тогда
		ВыделенныеСтроки = ирКлиент.ВыделенныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.БазыКластера);
		ВыделенныеСтроки = БазыКластера.Выгрузить(ВыделенныеСтроки);
		Если ВыделенныеСтроки.Итог("РазмерСУБДОбщийМБ") > 10000 Тогда
			Ответ = Вопрос("Операция может быть долгой. Рекомендуется выполнять ее через средства администрирования СУБД. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ <> КодВозвратаДиалога.ОК Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ВыделенныеСтроки", ВыделенныеСтроки);
	#Если Сервер И Не Сервер Тогда
		СжатьБазуВСУБД();
		СжатьБазуВСУБДЗавершение();
	#КонецЕсли
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("СжатьБазуВСУБД", ПараметрыЗадания, ЭтаФорма,,, Кнопка, "СжатьБазуВСУБДЗавершение");
	
КонецПроцедуры

Процедура СжатьБазуВСУБДЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ОбновитьСписок();
	КонецЕсли; 

КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирКлиент.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура АнализЖурналаРегистрации(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.БазыКластера.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если Сервер И Не Сервер Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	ГлавныйФайлЖурнала = Новый файл(КаталогКластера + "\" + ТекущаяСтрока.Идентификатор + "\1Cv8Log\1Cv8.lgf"); 
	Если ГлавныйФайлЖурнала.Существует() Тогда
		НоваяФорма = АнализЖурналаРегистрации.ОткрытьДляФайла(ГлавныйФайлЖурнала.ПолноеИмя);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КаталогКластераОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
КонецПроцедуры

Процедура ДействияФормыВыгрузитьБД(Кнопка)

	ТекущаяСтрока = ЭлементыФормы.БазыКластера.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ФайлВыгрузки = ирКлиент.ВыбратьФайлЛкс(Ложь, "DT", "Выгрузка базы 1С",,,, "Выберите файл, в который выгружать базу");
	Если ФайлВыгрузки = Неопределено Тогда
		Возврат;
	КонецЕсли;     
	ИсполняемыйФайл = ИсполняемыйФайлаАвтономногоСервера();
	СтрокаКоманды = """" + ИсполняемыйФайл.ПолноеИмя + """ infobase dump --db-server=" + ТекущаяСтрока.СерверСУБД + " --dbms=" + ТекущаяСтрока.ТипСУБД + " --db-name=" + ТекущаяСтрока.БазаСУБД + " """ + ФайлВыгрузки + """";
	ПарольСУБДВрем = Неопределено;
    ПользовательСУБДВрем = Неопределено;
    ПользовательИПарольДляТекущейБазы(ТекущаяСтрока.СерверСУБД, ПользовательСУБДВрем, ПарольСУБДВрем);
	Если ЗначениеЗаполнено(ПользовательСУБДВрем) Тогда
		СтрокаКоманды = СтрокаКоманды + " --db-user=" + ПользовательСУБДВрем + " --db-pwd=" + ПарольСУБДВрем;
	КонецЕсли;
	ЗапуститьПриложение(СтрокаКоманды,, Ложь);

КонецПроцедуры

Процедура ПользовательСУБДПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПользовательСУБДНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеСлужбамиСервера1С.Форма.СписокБазКластера");
