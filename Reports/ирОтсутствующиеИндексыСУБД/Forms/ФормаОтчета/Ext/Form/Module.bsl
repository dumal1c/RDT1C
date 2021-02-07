﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.РассчитыватьСелективность, Форма.Авторасшифровка";
	Результат = Новый Структура;
	Результат.Вставить("НастройкаКомпоновки", КомпоновщикНастроек.ПолучитьНастройки());
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если НастройкаФормы <> Неопределено И НастройкаФормы.Свойство("НастройкаКомпоновки") Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаФормы.НастройкаКомпоновки);
	КонецЕсли; 

КонецПроцедуры

Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ирОбщий.ОтчетКомпоновкиОбработкаРасшифровкиЛкс(ЭтаФорма, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры, Элемент, ДанныеРасшифровки, Авторасшифровка);

КонецПроцедуры

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    ПараметрВыбранногоДействия = Новый Соответствие;
	#КонецЕсли
	Если ВыбранноеДействие = "ОткрытьОбъектМетаданных" Тогда
		ИмяВМетаданных = ПараметрВыбранногоДействия["ИмяВМетаданных"];
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(ирКэш.ОбъектМДПоПолномуИмениЛкс(ИмяВМетаданных));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаРасшифровки(ДанныеРасшифровки, ЭлементРасшифровки, ТабличныйДокумент, ДоступныеДействия, СписокДополнительныхДействий,
	РазрешитьАвтовыборДействия, ЗначенияВсехПолей) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[0];
		ТабличныйДокумент = Новый ТабличныйДокумент;
	#КонецЕсли
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	ЗначенияПолей = ЭлементРасшифровки.ПолучитьПоля();
	Если Ложь
		Или ЗначенияПолей.Найти("ИмяВМетаданных") <> Неопределено
	Тогда 
		СписокДополнительныхДействий.Добавить("ОткрытьОбъектМетаданных", "Открыть объект метаданных");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыПараметрыСУБД(Кнопка)
	
	ирОбщий.ОткрытьФормуСоединенияСУБДЛкс();
	
КонецПроцедуры

Функция ОтформатироватьТекстXML(ТекстXML) Экспорт 

	Если Не ЗначениеЗаполнено(ТекстXML) Тогда
		Возврат "";
	КонецЕсли; 
	Дом = ирОбщий.ПрочитатьТекстВДокументDOMЛкс("<_>" + ТекстXML + "</_>");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьДОМ = Новый ЗаписьDOM;
	ОтформатированныйТекст = "";
	Для Каждого ДочернийУзел Из ДОМ.ПервыйДочерний.ДочерниеУзлы Цикл
		ЗаписьXML.УстановитьСтроку();
		ЗаписьДОМ.Записать(ДочернийУзел, ЗаписьXML);
		Если ОтформатированныйТекст <> "" Тогда
			ОтформатированныйТекст = ОтформатированныйТекст + Символы.ПС;
		КонецЕсли;
		ОтформатированныйТекст = ОтформатированныйТекст + ЗаписьXML.Закрыть();
	КонецЦикла;
	Возврат ОтформатированныйТекст;

КонецФункции // ОтформатироватьТекстXML()

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда 
		Сообщить("Для использования инструмента необходима клиент-серверная база", СтатусСообщения.Внимание);
		//Панель.Доступность = Ложь;
	КонецЕсли;
	КнопкиПодменю = ЭлементыФормы.ДействияФормы.Кнопки.Варианты.Кнопки;
	Для Каждого ВариантНастроек Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Кнопка = КнопкиПодменю.Добавить();
		Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Действие;
		Кнопка.Имя = ВариантНастроек.Имя;
		Кнопка.Текст = ВариантНастроек.Представление;
		Кнопка.Действие = Новый Действие("КнопкаВариантаНастроек");
	КонецЦикла;
	Если ЗначениеЗаполнено(ПараметрКлючВарианта) Тогда
		ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек[ПараметрКлючВарианта];
		КомпоновщикНастроек.ЗагрузитьНастройки(ВариантНастроек.Настройки);
	КонецЕсли; 

КонецПроцедуры

Процедура КнопкаВариантаНастроек(Кнопка)
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[Кнопка.Имя].Настройки);
	
КонецПроцедуры

Процедура ДействияФормыСформировать(Кнопка = Неопределено) Экспорт 
	
	РежимОтладки = 0;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);
	
КонецПроцедуры

Процедура ДействияФормыКопия(Кнопка)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Вывести(ЭлементыФормы.ТабличныйДокумент);
	ЗаполнитьЗначенияСвойств(ТабличныйДокумент, ЭлементыФормы.ТабличныйДокумент); 
	Результат = ирОбщий.ОткрытьЗначениеЛкс(ТабличныйДокумент,,,, Ложь);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	РежимОтладки = 2;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ДействияФормыЗапросСтатистики(Кнопка)
	
	РежимОтладки = 1;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ПорядокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ТабличноеПолеПорядкаКомпоновкиВыборЛкс(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОписаниеИндексовБДИТС(Кнопка)
	
	ЗапуститьПриложение("https://its.1c.ru/db/metod8dev#content:1590:hdoc");
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Отчет.ирОтсутствующиеИндексыСУБД.Форма.ФормаОтчета");
ЭтаФорма.Авторасшифровка = Истина;

