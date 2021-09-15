﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем РежимОтладки Экспорт;

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	#Если _ Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		КонечнаяНастройка = Новый НастройкиКомпоновкиДанных;
		ДокументРезультат = Новый ТабличныйДокумент;
	#КонецЕсли
	СтандартнаяОбработка = Ложь;
	Если Не ирОбщий.ПроверитьСоединениеADOЭтойБДЛкс() Тогда
		Возврат;
	КонецЕсли; 
	ТекстЗапроса = ПолучитьМакет("ЗапросMSSQL").ПолучитьТекст();
	АнализТехножурнала = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
	#Если Сервер И Не Сервер Тогда
	    АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
	#КонецЕсли
	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	ПорядокЗапроса = ирОбщий.ВыражениеПорядкаКомпоновкиНаЯзыкеЗапросовЛкс(КонечнаяНастройка.Порядок,,, "MSSQL");
	Если Не ЗначениеЗаполнено(ПорядокЗапроса) Тогда
		ПорядокЗапроса = "TotIO desc";
	КонецЕсли; 
	СоединениеADO = Неопределено;
	Попытка
		ирОбщий.ВыполнитьЗапросКЭтойБазеЧерезADOЛкс("SET DATEFORMAT ymd;",,,,,, СоединениеADO);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки(); // для отладки
	КонецПопытки; 
	// http://devtrainingforum.v8.1c.ru/forum/thread.jsp?id=542796
	ТекущаяДата = ТекущаяДата();
	СмещениеВремени = ТекущаяДата - ирОбщий.ВыполнитьЗапросКЭтойБазеЧерезADOЛкс("select CURRENT_TIMESTAMP",,, 0, Ложь,, СоединениеADO)[0][0] - 1;
	
	КоличествоПервых = КонечнаяНастройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КоличествоПервых")).Значение;
	ПараметрПопавшиеВПоследниеМинут = КонечнаяНастройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПопавшиеВПоследниеМинут"));
	ПопавшиеВПоследниеМинут = 1000;
	Если ПараметрПопавшиеВПоследниеМинут.Использование Тогда
		ПопавшиеВПоследниеМинут = ПараметрПопавшиеВПоследниеМинут.Значение
	КонецЕсли; 
	ПараметрНачалоИнтервала = КонечнаяНастройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоИнтервала"));
	НачалоИнтервала = Дата(2000,1,1);
	Если ПараметрНачалоИнтервала.Использование И ЗначениеЗаполнено(ПараметрНачалоИнтервала.Значение) Тогда
		НачалоИнтервала = Дата(ПараметрНачалоИнтервала.Значение) - СмещениеВремени - 1;
	КонецЕсли; 
	ТекстЗапроса = ирОбщий.СтрЗаменитьЛкс(ТекстЗапроса, "1111-11-11 11:11:11", Формат(НачалоИнтервала, "ДФ=""yyyy-MM-dd HH:mm:ss"""));
	ПараметрКонецИнтервала = КонечнаяНастройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецИнтервала"));
	КонецИнтервала = Дата(2100,1,1);
	Если ПараметрКонецИнтервала.Использование И ЗначениеЗаполнено(ПараметрКонецИнтервала.Значение) Тогда
		КонецИнтервала = Дата(ПараметрКонецИнтервала.Значение) - СмещениеВремени + 1;
	КонецЕсли; 
	ТекстЗапроса = ирОбщий.СтрЗаменитьЛкс(ТекстЗапроса, "2222-22-22 22:22:22", Формат(КонецИнтервала, "ДФ=""yyyy-MM-dd HH:mm:ss"""));
	ТекстЗапроса = ирОбщий.СтрЗаменитьЛкс(ТекстЗапроса, "top 111", "top " + XMLСтрока(КоличествоПервых));
	ТекстЗапроса = ирОбщий.СтрЗаменитьЛкс(ТекстЗапроса, "333", XMLСтрока(ПопавшиеВПоследниеМинут));
	НенулевойВводВывод = ирОбщий.НайтиЭлементКоллекцииПоЗначениюСвойстваЛкс(КонечнаяНастройка.Отбор.Элементы, "Представление", "Ненулевой ввод/вывод");
	Если НенулевойВводВывод = Неопределено Или Не НенулевойВводВывод.Использование Тогда
		// Этот фрагмент сильно ускоряет запрос, но иногда будет отсекать полезные данные
		ТекстЗапроса = ирОбщий.СтрЗаменитьЛкс(ТекстЗапроса, "(total_logical_reads > 0 or total_logical_writes > 0)", "(1=1)"); 
	КонецЕсли; 
	ГруппаОтбора = ирОбщий.НайтиЭлементКоллекцииПоЗначениюСвойстваЛкс(КонечнаяНастройка.Отбор.Элементы, "Представление", "Не содержит служебных таблиц 1С");
	Если ГруппаОтбора <> Неопределено И ГруппаОтбора.Использование Тогда
		ОбработкаСтруктураХраненияБД = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирСтруктураХраненияБД");
		#Если Сервер И Не Сервер Тогда
		    ОбработкаСтруктураХраненияБД = обработки.ирСтруктураХраненияБД.Создать();
		#КонецЕсли
		Для Каждого ИмяСлужебнойТаблицы Из ОбработкаСтруктураХраненияБД.мИменаДополнительныхТаблиц Цикл
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаОтбора, "ТекстЗапроса", "FROM " + ИмяСлужебнойТаблицы.Ключ, ВидСравненияКомпоновкиДанных.НеСодержит,, Ложь);
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаОтбора, "ТекстЗапроса", "FROM dbo." + ИмяСлужебнойТаблицы.Ключ, ВидСравненияКомпоновкиДанных.НеСодержит,, Ложь);
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаОтбора, "ТекстЗапроса", "UPDATE " + ИмяСлужебнойТаблицы.Ключ, ВидСравненияКомпоновкиДанных.НеСодержит,, Ложь);
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаОтбора, "ТекстЗапроса", "UPDATE dbo." + ИмяСлужебнойТаблицы.Ключ, ВидСравненияКомпоновкиДанных.НеСодержит,, Ложь);
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаОтбора, "ТекстЗапроса", "INSERT " + ИмяСлужебнойТаблицы.Ключ, ВидСравненияКомпоновкиДанных.НеСодержит,, Ложь);
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ГруппаОтбора, "ТекстЗапроса", "INSERT dbo." + ИмяСлужебнойТаблицы.Ключ, ВидСравненияКомпоновкиДанных.НеСодержит,, Ложь);
		КонецЦикла; 
	КонецЕсли; 
	//ФормаПодключения = ирКэш.Получить().ПолучитьФорму("ПараметрыСоединенияСУБД");
	//ФормаПодключения.ЗаполнитьПараметры();
	//ТекстЗапроса = ирОбщий.СтрЗаменитьЛкс(ТекстЗапроса, "3333", ФормаПодключения.ИмяБД);
	ВсеВыбранныеПоля = ирОбщий.ВсеВыбранныеПоляГруппировкиКомпоновкиЛкс(КонечнаяНастройка.Выбор, Истина);
	ВыбранноеПолеПланЗапроса = ирОбщий.НайтиЭлементКоллекцииПоЗначениюСвойстваЛкс(ВсеВыбранныеПоля, "Поле", Новый ПолеКомпоновкиДанных("query_plan"));
	Если ВыбранноеПолеПланЗапроса = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "qp.query_plan", "NULL"); // получание планов запросов в XML занимает много времени
	КонецЕсли; 
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ORDER BY " + ПорядокЗапроса;
	Запросы = ирОбщий.ВыполнитьЗапросКЭтойБазеЧерезADOЛкс(ТекстЗапроса, РежимОтладки = 1, "Статистика MSSQL", 0, Ложь,, СоединениеADO);
	Если Запросы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Запросы.Колонки.Добавить("ТаблицыМетаданных");
	Запросы.Колонки.Добавить("ТекстЗапросаМета");
	ВыбранноеПолеТаблицыМетаданных = ирОбщий.НайтиЭлементКоллекцииПоЗначениюСвойстваЛкс(ВсеВыбранныеПоля, "Поле", Новый ПолеКомпоновкиДанных("ТаблицыМетаданных"));
	ВыбранноеПолеТекстЗапросаМета = ирОбщий.НайтиЭлементКоллекцииПоЗначениюСвойстваЛкс(ВсеВыбранныеПоля, "Поле", Новый ПолеКомпоновкиДанных("ТекстЗапросаМета"));
	Для Каждого СтрокаЗапроса Из Запросы Цикл
		Если Ложь
			Или ВыбранноеПолеТекстЗапросаМета <> Неопределено 
			Или ВыбранноеПолеТаблицыМетаданных <> Неопределено
		Тогда
			//Если ирОбщий.СтрокиРавныЛкс(СтрокаЗапроса.database_name,  ФормаПодключения.ИмяБД) Тогда
				НайденныеТаблицы = Новый ТаблицаЗначений;
				СтрокаЗапроса.ТекстЗапросаМета = АнализТехножурнала.ПеревестиТекстБДВТерминыМетаданных(СтрокаЗапроса.query_text,,, "DBMSSQL", НайденныеТаблицы,,,, Истина);
				Если НайденныеТаблицы.Количество() > 0 Тогда
					МассивИмен = НайденныеТаблицы.ВыгрузитьКолонку("ИмяМета");
					СтрокаЗапроса.ТаблицыМетаданных = ирОбщий.СтрСоединитьЛкс(МассивИмен);
				КонецЕсли; 
			//КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	#Если _ Тогда
	    Таблица = Новый ТаблицаЗначений;
	#КонецЕсли
	Запросы.Колонки.Добавить("ШаблонЗапроса", Новый ОписаниеТипов("Строка"));
	Для Каждого СтрокаТаблицы Из Запросы Цикл
		СтрокаТаблицы.ШаблонЗапроса = АнализТехножурнала.ПолучитьШаблонТекстаБД(СтрокаТаблицы.query_text);
	КонецЦикла;
	ВнешниеНаборыДанных = Новый Структура("Запросы", Запросы);
	Если РежимОтладки = 2 Тогда
		ирОбщий.ОтладитьЛкс(СхемаКомпоновкиДанных, , КонечнаяНастройка, ВнешниеНаборыДанных);
		Возврат;
	КонецЕсли; 
	ДокументРезультат.Очистить();
	ирОбщий.СкомпоноватьВТабличныйДокументЛкс(СхемаКомпоновкиДанных, КонечнаяНастройка, ДокументРезультат, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
КонецПроцедуры

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

РежимОтладки = 0;