﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.Авторасшифровка, Форма.ФайлЗамера, Форма.ИзвлекатьИменаМетодов";
	Результат = Новый Структура;
	Результат.Вставить("НастройкаКомпоновки", КомпоновщикНастроек.ПолучитьНастройки());
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если НастройкаФормы <> Неопределено И НастройкаФормы.Свойство("НастройкаКомпоновки") Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаФормы.НастройкаКомпоновки);
	КонецЕсли;
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ирОбщий.ОтчетКомпоновкиОбработкаРасшифровкиЛкс(ЭтаФорма, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры, Элемент, ДанныеРасшифровки, Авторасшифровка);
	
КонецПроцедуры

Процедура ОбработкаРасшифровки(ДанныеРасшифровки, ЭлементРасшифровки, ТабличныйДокумент, ДоступныеДействия, СписокДополнительныхДействий, РазрешитьАвтовыборДействия, ЗначенияВсехПолей) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[0];
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ДоступныеДействия = Новый Массив;
		СписокДополнительныхДействий = Новый СписокЗначений;
	#КонецЕсли
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Сгруппировать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	ЗначенияПолей = ЭлементРасшифровки.ПолучитьПоля();
	Если Ложь
		Или ЗначенияПолей.Найти("Модуль") <> Неопределено 
	Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьМетаданныеВФорме", "Открыть метаданные в форме",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирИнтерфейснаяПанель"));
	ИначеЕсли Ложь
		Или ЗначенияПолей.Найти("СсылкаСтроки") <> Неопределено 
	Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьСсылкуСтрокиМодуля", "Открыть ссылку строки модуля",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирКонфигуратор"));
	КонецЕсли;
	ЗначенияПолей = ирОбщий.ТаблицаКлючейИзТабличногоДокументаЛкс(ТабличныйДокумент, ДанныеРасшифровки, "Модуль,Метод", ТабличныйДокумент.Область("R" + XMLСтрока(ТабличныйДокумент.ТекущаяОбласть.Верх)));
	ЗначенияПолей = ЗначенияПолей[0];
	ПолноеИмяМодуля = ЗначенияПолей.Модуль;
	ИмяМетода = ЗначенияПолей.Метод;
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		ПодменюВызовов = Новый СписокЗначений;
		ТаблицаЗамера = мВнешниеНаборыДанных.Таблица;
		ЛокальныйВызов = ИмяМетода + "(";
		ВнешнийВызов = "";  
		Если Ложь
			Или ПолноеИмяМодуля = "МодульОбычногоПриложения" 
			Или ПолноеИмяМодуля = "МодульУправляемогоПриложения" 
			Или ПолноеИмяМодуля = "МодульСеансаПриложения" 
		Тогда
			ВнешнийВызов = ЛокальныйВызов;
		ИначеЕсли ирОбщий.СтрНачинаетсяСЛкс(ПолноеИмяМодуля, "ОбщийМодуль.") Тогда 
			ВнешнийВызов = ирОбщий.СтрРазделитьЛкс(ПолноеИмяМодуля)[1] + "." + ЛокальныйВызов; 
		Иначе
			ВнешнийВызов = "." + ЛокальныйВызов; 
		КонецЕсли; 
		ирОбщий.ДобавитьИндексВТаблицуЛкс(мВнешниеНаборыДанных.Таблица, "Модуль");
		ШаблонСимволаИдентификатора = ирОбщий.ШаблонСимволаИдентификатораЛкс();
		Для Счетчик = 1 По 2 Цикл
			Если Счетчик = 1 Тогда
				Если Не ЗначениеЗаполнено(ВнешнийВызов) Тогда
					Продолжить;
				КонецЕсли;
				СтрокиДляПровеки = мВнешниеНаборыДанных.Таблица;
				ИскомаяСтрока = ВнешнийВызов; 
			Иначе
				Если ВнешнийВызов = ЛокальныйВызов Тогда
					Прервать;
				КонецЕсли;
				СтрокиДляПровеки = мВнешниеНаборыДанных.Таблица.НайтиСтроки(Новый Структура("Модуль", ПолноеИмяМодуля));
				ИскомаяСтрока = ЛокальныйВызов; 
			КонецЕсли;
			Для Каждого СтрокаТаблицы Из СтрокиДляПровеки Цикл
				ПозицияВхождения = ирОбщий.СтрНайтиЛкс(СтрокаТаблицы.Текст, ИскомаяСтрока,,,, Ложь);
				Если ПозицияВхождения = 0 Тогда
					Продолжить;
				КонецЕсли;
				Если Лев(ИскомаяСтрока, 1) <> "." И Найти(ШаблонСимволаИдентификатора, Сред(СтрокаТаблицы.Текст, ПозицияВхождения - 1, 1)) > 0 Тогда
					Продолжить;
				КонецЕсли;
				КлючВызова = "Вызов." + СтрокаТаблицы.Модуль + "." + XMLСтрока(СтрокаТаблицы.НомерСтроки);
				Если ПодменюВызовов.НайтиПоЗначению(КлючВызова) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ПодменюВызовов.Добавить(КлючВызова,
					"" + СтрокаТаблицы.Количество + "; " + СтрокаТаблицы.ВремяЧистое + ": " + СтрокаТаблицы.Модуль + ":" + XMLСтрока(СтрокаТаблицы.НомерСтроки) + "." + СтрокаТаблицы.Метод 
					+ "():: " + ирОбщий.ПредставлениеЗначенияСОграничениемДлиныЛкс(СтрокаТаблицы.Текст));
			КонецЦикла;
		КонецЦикла;
		СписокДополнительныхДействий.Добавить(ПодменюВызовов, "Возможные вызовы " + ИмяМетода + "()",, ирКэш.КартинкаПоИмениЛкс("ирВходящий"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    ПараметрВыбранногоДействия = Новый Соответствие;
	#КонецЕсли
	Если ВыбранноеДействие = "ОткрытьМетаданныеВФорме" Тогда
		ирОбщий.ОткрытьОбъектМетаданныхПоИмениМодуляЛкс(ПараметрВыбранногоДействия["Модуль"]);
	ИначеЕсли ВыбранноеДействие = "ОткрытьСсылкуСтрокиМодуля" Тогда
		ирОбщий.ПоказатьСсылкуНаСтрокуМодуляЛкс(ПараметрВыбранногоДействия["СсылкаСтроки"]);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	КнопкиПодменю = ЭлементыФормы.ДействияФормы.Кнопки.Варианты.Кнопки;
	КнопкиПодменю.Очистить();
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
	
	Если Не ЗначениеЗаполнено(ФайлЗамера) Тогда
		Сообщить("Необходимо указать файл замера", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли; 
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ФайлЗамера", ФайлЗамера);
	РежимОтладки = 0;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	//ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);
	
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

Процедура ФайлЗамераНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	РезультатВыбора = ирОбщий.ВыбратьФайлЛкс(, "pff", "Замер производительности", ФайлЗамера);
	Если РезультатВыбора <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, РезультатВыбора);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФайлЗамераНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФайлЗамераПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

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
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДействияФормыСравнитьЧерезТаблицу(Кнопка)
	
	Результат = ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки,, ВнешниеНаборыДанных());
	ирОбщий.ДобавитьДокументВБуферСравненияЛкс(Результат,, "");
	
КонецПроцедуры

Процедура ИзвлекатьИменаМетодовПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	ЭлементыФормы.ВстроитьИменаМетодовВФайл.Доступность = ИзвлекатьИменаМетодов;
КонецПроцедуры

Процедура ДействияФормыКэшМодулей(Кнопка)
	
	Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирКлсПолеТекстаПрограммы.Форма.ФормаНастройки");
	Форма.Открыть();

КонецПроцедуры

Процедура ТабличныйДокументПриАктивизацииОбласти(Элемент)
	ПодключитьОбработчикОжидания("ОформитьТекущиеСтроки", 0.1, Истина);
КонецПроцедуры

Процедура ОформитьТекущиеСтроки()
	ирОбщий.ТабличныйДокументОформитьТеущиеСтрокиЛкс(ЭтаФорма, ЭлементыФормы.ТабличныйДокумент);
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Отчет.ирАнализЗамераПроизводительности.Форма.ФормаОтчета");
ЭтаФорма.Авторасшифровка = Истина;


