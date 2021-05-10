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
		ВнешниеНаборыДанных = Новый Структура;
		ДокументРезультат = Новый ТабличныйДокумент;
	#КонецЕсли
	СтандартнаяОбработка = Ложь;
	ФайлЗамера = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ФайлЗамера")).Значение;
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Файл");
	Таблица.Колонки.Добавить("Модуль");
	Таблица.Колонки.Добавить("ИДМодуля");
	Таблица.Колонки.Добавить("Текст");
	Таблица.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("НомерПервойСтрокиМетода", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ВремяЧистое", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ВремяЧистоеСВложенными", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ВремяПроцент", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ВремяПроцентСВложенными", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("Клиент", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("Сервер", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("ОбработкаСервером", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("Метод", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("КоличествоВходов", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("КоличествоВыходов", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("СсылкаСтроки", Новый ОписаниеТипов("Строка"));
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	Попытка
		ТекстовыйДокумент.Прочитать(ФайлЗамера);
	Исключение
		Сообщить("Ошибка чтения файла замера: " + ОписаниеОшибки(), СтатусСообщения.Внимание);
		Возврат;
	КонецПопытки; 
	ТекстГдеИскать = ТекстовыйДокумент.ПолучитьТекст();
	// Пример
	// {{"",0},ada14b12-452d-4f85-9d71-99554e8fc6c0,a78d9ce3-4e0c-48d5-9863-ae7342eedf94,0,00000000-0000-0000-0000-000000000000,0,AAAAAAAAAAAAAAAAAAAAAAAAAAA=,""},"МодульОбычногоПриложения",515,"Если глЗначениеПеременной(""глОбработкаАвтоОбменДанными"") = Неопределено Тогда",1,0.00023340955344883218397869,0.000020323812104611060902992,0.000450628996772107550476536,0.000039237892896673637698585,1,0,0,aaff96cf-5e0a-4e93-aa3e-70ab34e49a77,
	
	// {ОписаниеРегулярногоВыражения.Начало} конструктор из подсистемы "Инструменты разработчика" (http://devtool1c.ucoz.ru)
	// Перем УИД, ЭкспЧисло, Число, Строка, Запятая, Файл, ИДМодуля, Модуль, НомерСтроки, Текст, Количество, ВремяЧистоеСВложенными, ВремяЧистое, ВремяПроцентСВложенными, ВремяПроцент, Клиент, Сервер, ОбработкаСервером, ШаблонЗаписи;
	// {Шаблон.Начало}
	// + <УИД> = \b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-Z0-9]{12}\b
	// + <ЭкспЧисло> = [-+]?(?:\b[0-9]+(?:\.[0-9]*)?|\.[0-9]+\b)(?:[eE][-+]?[0-9]+\b)?
	// + <Число> = (?:[\d]+)
	// + <Строка> = "(?:(?:"")|[^"])*"
	// + <Запятая> = \s*,\s*
	// + <Файл> = (<Строка>)
	// + <ИДМодуля> = (<УИД>)
	// + <Модуль> = (<Строка>)
	// + <НомерСтроки> = (<Число>)
	// + <Текст> = (<Строка>)
	// + <Количество> = (<Число>)
	// + <ВремяЧистоеСВложенными> = (<ЭкспЧисло>)
	// + <ВремяЧистое> = (<ЭкспЧисло>)
	// + <ВремяПроцентСВложенными> = (<ЭкспЧисло>)
	// + <ВремяПроцент> = (<ЭкспЧисло>)
	// + <Клиент> = (<Число>)
	// + <Сервер> = (<Число>)
	// + <ОбработкаСервером> = (<Число>)
	// + <ШаблонЗаписи> = {\s*{\s*<Файл><Запятая><Число>\s*}<Запятая><ИДМодуля><Запятая><ИДМодуля><Запятая><Число>\s*(?:<Запятая><УИД><Запятая><Число>(?:<Запятая>\w+=(?:<Запятая><Строка>)?)?)?}<Запятая><Модуль><Запятая><НомерСтроки><Запятая><Текст><Запятая><Количество><Запятая><ВремяЧистоеСВложенными><Запятая><ВремяЧистое><Запятая><ВремяПроцентСВложенными><Запятая><ВремяПроцент><Запятая><Клиент><Запятая><Сервер><Запятая><ОбработкаСервером><Запятая><УИД><Запятая>
	// {Шаблон.Конец}
	УИД = "\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-Z0-9]{12}\b";
	ЭкспЧисло = "[-+]?(?:\b[0-9]+(?:\.[0-9]*)?|\.[0-9]+\b)(?:[eE][-+]?[0-9]+\b)?";
	Число = "(?:[\d]+)";
	Строка = """(?:(?:"""")|[^""])*""";
	Запятая = "\s*,\s*";
	Файл = "(" + Строка + ")";
	ИДМодуля = "(" + УИД + ")";
	Модуль = "(" + Строка + ")";
	НомерСтроки = "(" + Число + ")";
	Текст = "(" + Строка + ")";
	Количество = "(" + Число + ")";
	ВремяЧистоеСВложенными = "(" + ЭкспЧисло + ")";
	ВремяЧистое = "(" + ЭкспЧисло + ")";
	ВремяПроцентСВложенными = "(" + ЭкспЧисло + ")";
	ВремяПроцент = "(" + ЭкспЧисло + ")";
	КлиентФрагмент = "(" + Число + ")";
	СерверФрагмент = "(" + Число + ")";
	ОбработкаСервером = "(" + Число + ")";
	ШаблонЗаписи = "{\s*{\s*" + Файл + "" + Запятая + "" + Число + "\s*}" + Запятая + "" + ИДМодуля + "" + Запятая + "" + ИДМодуля + "" + Запятая + "" + Число + "\s*(?:" + Запятая + "" + УИД + "" + Запятая + "" + Число 
		+ "(?:" + Запятая + "\w+=(?:" + Запятая + "" + Строка + ")?)?)?}" + Запятая + "" + Модуль + "" + Запятая + "" + НомерСтроки + "" + Запятая + "" + Текст + "" + Запятая + "" + Количество + "" + Запятая + "" 
		+ ВремяЧистоеСВложенными + "" + Запятая + "" + ВремяЧистое + "" + Запятая + "" + ВремяПроцентСВложенными + "" + Запятая + "" + ВремяПроцент + "" + Запятая + "" + КлиентФрагмент + "" + Запятая + "" 
		+ СерверФрагмент + "" + Запятая + "" + ОбработкаСервером + "" + Запятая + "" + УИД + "" + Запятая + "";
	// {ОписаниеРегулярногоВыражения.Конец}
	Вхождения = ирОбщий.НайтиРегулярноеВыражениеЛкс(ТекстГдеИскать, ШаблонЗаписи, 
		"Файл, ИДМодуля, ИДМодуля1, Модуль, НомерСтроки, Текст, Количество, ВремяЧистоеСВложенными, ВремяЧистое, ВремяПроцентСВложенными, ВремяПроцент, Клиент, Сервер, ОбработкаСервером");
		#Если СерверФрагмент И Не СерверФрагмент Тогда
		    Вхождения = Обработки.ирПлатформа.Создать().ВхожденияРегВыражения;
		#КонецЕсли
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Вхождения.Количество());
	Для Каждого Вхождение Из Вхождения Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		СтрокаЗамера = Таблица.Добавить();
		СтрокаЗамера.Файл = Вычислить(Вхождение.Файл);
		СтрокаЗамера.ИДМодуля = Вхождение.ИДМодуля + "," + Вхождение.ИДМодуля1;
		СтрокаЗамера.Модуль = Вычислить(Вхождение.Модуль);
		СтрокаЗамера.НомерСтроки = Число(Вхождение.НомерСтроки);
		СтрокаЗамера.Текст = Вычислить(Вхождение.Текст);
		СтрокаЗамера.Количество = Число(Вхождение.Количество);
		СтрокаЗамера.ВремяЧистоеСВложенными = Число(Вхождение.ВремяЧистоеСВложенными);
		СтрокаЗамера.ВремяЧистое = Число(Вхождение.ВремяЧистое);
		СтрокаЗамера.ВремяПроцентСВложенными = Число(Вхождение.ВремяПроцентСВложенными);
		СтрокаЗамера.ВремяПроцент = Число(Вхождение.ВремяПроцент);
		СтрокаЗамера.Клиент = Число(Вхождение.Клиент);
		СтрокаЗамера.Сервер = Число(Вхождение.Сервер);
		СтрокаЗамера.ОбработкаСервером = Число(Вхождение.ОбработкаСервером);
		Если НРег(ирОбщий.ПоследнийФрагментЛкс(СтрокаЗамера.Модуль)) <> "epf" Тогда
			СтрокаЗамера.СсылкаСтроки = "{" + СтрокаЗамера.Модуль + "(" + XMLСтрока(СтрокаЗамера.НомерСтроки) + ")}";
		КонецЕсли; 
	КонецЦикла;
	
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Таблица.Сортировать("ИДМодуля, НомерСтроки, Клиент");
	ПредыдущаяСтрока = Неопределено;
	НомерМетода = 0;
	Для Каждого СтрокаЗамера Из Таблица Цикл
		ЭтоНовыйМетод = ПредыдущаяСтрока = Неопределено;
		Если Истина
			И ПредыдущаяСтрока <> Неопределено
			И (Ложь
				Или Найти(НРег(ПредыдущаяСтрока.Текст), "конецпроцедуры") > 0
				Или Найти(НРег(ПредыдущаяСтрока.Текст), "конецфункции") > 0)
		Тогда
			ПредыдущаяСтрока.КоличествоВыходов = ПредыдущаяСтрока.Количество;
			Если ПредыдущаяСтрока.НомерСтроки <> СтрокаЗамера.НомерСтроки Тогда
				ЭтоНовыйМетод = Истина;
			КонецЕсли; 
		КонецЕсли;
		Если Истина
			И ПредыдущаяСтрока <> Неопределено 
			И ПредыдущаяСтрока.ИДМодуля <> СтрокаЗамера.ИДМодуля 
		Тогда 
			ЭтоНовыйМетод = Истина;
		КонецЕсли; 
		Если Ложь
			Или ЭтоНовыйМетод 
			Или (Истина
				И ПредыдущаяСтрока <> Неопределено
				И ПредыдущаяСтрока.КоличествоВходов > 0
				И ПредыдущаяСтрока.ИДМодуля = СтрокаЗамера.ИДМодуля
				И ПредыдущаяСтрока.НомерСтроки = СтрокаЗамера.НомерСтроки)
		Тогда
			СтрокаЗамера.КоличествоВходов = СтрокаЗамера.Количество;
			СтрокаЗамера.НомерПервойСтрокиМетода = СтрокаЗамера.НомерСтроки;
		КонецЕсли; 
		Если ЭтоНовыйМетод Тогда
			НомерМетода = НомерМетода + 1;
		КонецЕсли; 
		СтрокаЗамера.Метод = "Метод" + XMLСтрока(НомерМетода);
		ПредыдущаяСтрока = СтрокаЗамера;
	КонецЦикла;
	СтрокаЗамера.КоличествоВыходов = СтрокаЗамера.Количество;
	КонечнаяНастройка = КомпоновщикНастроек.Настройки;
	ВнешниеНаборыДанных = Новый Структура("Таблица", Таблица);
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