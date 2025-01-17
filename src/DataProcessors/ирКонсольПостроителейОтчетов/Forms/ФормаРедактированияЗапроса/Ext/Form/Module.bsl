﻿Перем ПолеТекстаПрограммы;

// @@@.КЛАСС.ПолеТекстаПрограммы
Функция КлсПолеТекстаПрограммыОбновитьКонтекст(Знач Компонента = Неопределено, Знач Кнопка = Неопределено) Экспорт 
КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаПрограммы.Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстаПрограммы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаПрограммы.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Процедура УправлениеКолонкамиПараметры()

	ЭлементыФормы.Параметры.Колонки.ЗначениеПоУмолчанию.ЭлементУправления.ВыбиратьТип = (ЭлементыФормы.Параметры.ТекущаяСтрока.ЭтоВыражение = Ложь);
	
КонецПроцедуры

// Сообщает об ошибке в тексте запроса и устанавливает выделение в тексте запроса на ошибочную строку, если это возможно.
//
// Параметры:
//  Нет.
//
Процедура ПоказатьОшибкуВЗапросе()

	// Баг платформы. Зависает приложение, если пытаемся установить выделение на невидимой странице.
	ТекущийЭлемент = ЭлементыФормы.ТекстЗапроса;
	
	ирКлиент.ПоказатьОшибкуВТекстеПрограммыЛкс(ЭлементыФормы.ТекстЗапроса, , , Истина, МодальныйРежим);
	
КонецПроцедуры

Процедура ПриОК(Элемент)
	
    Текст = ЭлементыФормы.ТекстЗапроса.ПолучитьТекст();
	ЗаполнитьПредставления();
	ЗаполнитьПараметры();
	Для Каждого СтрокаПараметра Из Параметры Цикл
		Если СтрокаПараметра.Служебный = Истина Тогда
			СтрокаПараметра.ЗначениеПараметра = Неопределено;
			Продолжить;
		КонецЕсли;
		НовоеЗначениеПараметра = СтрокаПараметра.ЗначениеПараметра;
		Если НовоеЗначениеПараметра = Неопределено Тогда 
			Если СтрокаПараметра.ЭтоВыражение = Истина Тогда 
				Попытка
					НовоеЗначениеПараметра = Вычислить(СтрокаПараметра.ЗначениеПоУмолчанию);
				Исключение
				КонецПопытки;
			Иначе
				НовоеЗначениеПараметра = СтрокаПараметра.ЗначениеПоУмолчанию;
			КонецЕсли;
		КонецЕсли;
		Если СтрокаПараметра.ЭтоВыражение = 2 Тогда
			Если ТипЗнч(НовоеЗначениеПараметра) = Тип("СписокЗначений") Тогда
				НовоеЗначениеПараметра.ТипЗначения = СтрокаПараметра.ТипЗначения;
			Иначе
				НовоеЗначениеПараметра = Новый СписокЗначений;
				НовоеЗначениеПараметра.ТипЗначения = СтрокаПараметра.ТипЗначения;
				НовоеЗначениеПараметра.Добавить(СтрокаПараметра.ТипЗначения.ПривестиЗначение(НовоеЗначениеПараметра));
			КонецЕсли;
		Иначе
			Если СтрокаПараметра.ТипЗначения <> Неопределено Тогда
				СтрокаПараметра.ЗначениеПараметра = СтрокаПараметра.ТипЗначения.ПривестиЗначение(НовоеЗначениеПараметра);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Закрыть();
	ОповеститьОВыборе(КлючУникальности);
	
КонецПроцедуры

Процедура ЗаполнитьПредставления()

	Представления.Очистить();
	ПостроительОтчетовВременный = Новый ПостроительОтчета;
	Попытка
		ПостроительОтчетовВременный.Текст = ЭлементыФормы.ТекстЗапроса.ПолучитьТекст();
	Исключение
		ПоказатьОшибкуВЗапросе();
		Возврат;
	КонецПопытки;
	Если АвтоЗаполнение Тогда 
		ПостроительОтчетовВременный.ЗаполнитьНастройки();
	КонецЕсли;

	КолВо = ПостроительОтчетовВременный.ДоступныеПоля.Количество();
	Для Каждого ДоступноеПоле Из ПостроительОтчетовВременный.ДоступныеПоля Цикл
		
		НоваяСтрока = Представления.Добавить();
		НоваяСтрока.Поле = ДоступноеПоле.Имя;
			
		Если ПредставленияДляИмен[ДоступноеПоле.Имя] <> Неопределено Тогда
			НоваяСтрока.Представление = ПредставленияДляИмен[ДоступноеПоле.Имя];
		Иначе
			НоваяСтрока.Представление = ирОбщий.ПредставлениеИзИдентификатораЛкс(ДоступноеПоле.Имя);
			ПредставленияДляИмен.Вставить(ДоступноеПоле.Имя, НоваяСтрока.Представление);
		КонецЕсли;
			
		Если ФорматыДляИмен[ДоступноеПоле.Имя] <> Неопределено Тогда
			НоваяСтрока.Формат = ФорматыДляИмен[ДоступноеПоле.Имя];
		ИначеЕсли ДоступноеПоле.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			НоваяСтрока.Формат = "ЧЦ=15; ЧДЦ=2";
			ФорматыДляИмен.Вставить(ДоступноеПоле.Имя, НоваяСтрока.Формат);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьПредставления()

Процедура ЗаполнитьПараметры(ЗаменятьТипы = Ложь)

	// Для совместимости со старыми версиями
	ДополнитьКолонкиТаблицыПараметров(Параметры);
	
	ТекстЗапроса = ЭлементыФормы.ТекстЗапроса.ПолучитьТекст();
	Запрос = Новый Запрос(ТекстЗапроса);
	Попытка
		ПараметрыЗапроса = Запрос.НайтиПараметры();
	Исключение
		ПоказатьОшибкуВЗапросе();
		Возврат;
	КонецПопытки;
	Для каждого ПараметрЗапроса Из ПараметрыЗапроса Цикл
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокаПараметров = Параметры.Найти(ИмяПараметра, "ИмяПараметра");
		Если СтрокаПараметров = Неопределено Тогда
			СтрокаПараметров = Параметры.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
			СтрокаПараметров.ЭтоВыражение = Ложь;
			СтрокаПараметров.ТипЗначения = ПараметрЗапроса.ТипЗначения;
		ИначеЕсли ЗаменятьТипы Тогда 
			СтрокаПараметров.ТипЗначения = ПараметрЗапроса.ТипЗначения;
		КонецЕсли;
		Если Ложь
			ИЛИ ПустаяСтрока(СтрокаПараметров.ПредставлениеПараметра)
			ИЛИ СтрокаПараметров.ИмяПараметра = СтрокаПараметров.ПредставлениеПараметра
		Тогда 
			СтрокаПараметров.ПредставлениеПараметра = ирОбщий.ПредставлениеИзИдентификатораЛкс(ИмяПараметра);
		КонецЕсли;
		Если СтрокаПараметров.ЭтоВыражение = Неопределено Тогда
			СтрокаПараметров.ЭтоВыражение = Ложь;
		КонецЕсли;
		Если СтрокаПараметров.ЭтоВыражение = Ложь Тогда
			СтрокаПараметров.ЗначениеПоУмолчанию = СтрокаПараметров.ТипЗначения.ПривестиЗначение(СтрокаПараметров.ЗначениеПоУмолчанию);
		ИначеЕсли СтрокаПараметров.ЭтоВыражение = Истина Тогда
			СтрокаПараметров.ЗначениеПоУмолчанию = Строка(СтрокаПараметров.ЗначениеПоУмолчанию);
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры // ЗаполнитьПараметры()

Процедура ПриОткрытии()
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаПрограммы = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаПрограммы = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаПрограммы.Инициализировать(, ЭтаФорма, ЭлементыФормы.ТекстЗапроса, ЭлементыФормы.КоманднаяПанель2, Истина,
		, Тип("ПостроительОтчета"));
	// ---.КЛАСС.ПолеТекстаПрограммы
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли; 
	
	ЭлементыФормы.ТекстЗапроса.УстановитьТекст(Текст);
	Если ПредставленияДляИмен = Неопределено Тогда
		ПредставленияДляИмен = Новый Соответствие;
	КонецЕсли;
	Если ФорматыДляИмен = Неопределено Тогда
		ФорматыДляИмен = Новый Соответствие;
	КонецЕсли;
	
	Если ОтчетРасшифровки <> Неопределено Тогда	
		ОтчетРасшифровкиРедактор = СтрЗаменить(ОтчетРасшифровки, Символы.ПС, "/");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыЭтоВыражениеПриИзменении(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.Параметры.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтоВыражение = Истина Тогда
		Если Не ТипЗнч(ТекущиеДанные.ЗначениеПоУмолчанию) = Тип("Строка") Тогда
			ТекущиеДанные.ЗначениеПоУмолчанию = "";
		КонецЕсли;
		
	ИначеЕсли ТекущиеДанные.ЭтоВыражение = Ложь Тогда
		Если ТекущиеДанные.ТипЗначения <> Неопределено Тогда
			ТекущиеДанные.ЗначениеПоУмолчанию = 
				ТекущиеДанные.ТипЗначения.ПривестиЗначение(ТекущиеДанные.ЗначениеПоУмолчанию);
		КонецЕсли;
			
	ИначеЕсли ТекущиеДанные.ЭтоВыражение = 2 Тогда
		Если Не ТипЗнч(ТекущиеДанные.ЗначениеПоУмолчанию) = Тип("СписокЗначений") Тогда
			ЗначениеПоУмолчанию = ТекущиеДанные.ЗначениеПоУмолчанию;
			ТекущиеДанные.ЗначениеПоУмолчанию = Новый СписокЗначений;
			Если ТекущиеДанные.ТипЗначения <> Неопределено Тогда
				ТекущиеДанные.ЗначениеПоУмолчанию.ТипЗначения = ТекущиеДанные.ТипЗначения;
			КонецЕсли;
			Если ЗначениеПоУмолчанию <> Неопределено Тогда
				ТекущиеДанные.ЗначениеПоУмолчанию.Добавить(ЗначениеПоУмолчанию);
			КонецЕсли;
		КонецЕсли; 
	Иначе
		Если ТипЗнч(ТекущиеДанные.ЗначениеПоУмолчанию) = Тип("СписокЗначений") Тогда
			Если ТекущиеДанные.ЗначениеПоУмолчанию.Количество() <> 0 Тогда
				ТекущиеДанные.ЗначениеПоУмолчанию = ТекущиеДанные.ЗначениеПоУмолчанию[0].Значение;
			Иначе
				ТекущиеДанные.ЗначениеПоУмолчанию = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	УправлениеКолонкамиПараметры();
	
КонецПроцедуры

Процедура ЗапросПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ЭлементыФормы.Запрос.ТекущаяСтраница = ЭлементыФормы.Запрос.Страницы.Представления Тогда
		ЗаполнитьПредставления();
	// Т.к. там используется Запрос, а не Построитель отчета.
	//ИначеЕсли ЭлементыФормы.Запрос.ТекущаяСтраница = ЭлементыФормы.Запрос.Страницы.Параметры Тогда
	//	ЗаполнитьПараметры();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредставленияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Элемент.ТекущаяСтрока.Представление <> "" Тогда
		ПредставленияДляИмен.Вставить(Элемент.ТекущаяСтрока.Поле, Элемент.ТекущаяСтрока.Представление);
	Иначе
		ПредставленияДляИмен.Удалить(Элемент.ТекущаяСтрока.Поле);
	КонецЕсли;
	
	Если Элемент.ТекущаяСтрока.Формат <> "" Тогда
		ФорматыДляИмен.Вставить(Элемент.ТекущаяСтрока.Поле, Элемент.ТекущаяСтрока.Формат);
	Иначе
		ФорматыДляИмен.Удалить(Элемент.ТекущаяСтрока.Поле);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтчетРасшифровкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	ФормаВыбораОтчета = ПолучитьФорму("ФормаВыбораОтчета", ВладелецФормы);
	ТС = НайтиСтрокуПоПути(ОтчетРасшифровки);
	Если ТС <> Неопределено Тогда
		ФормаВыбораОтчета.ЭлементыФормы.ДеревоОтчетов.ТекущаяСтрока = ТС;
	КонецЕсли;

	Если ФормаВыбораОтчета.ОткрытьМодально() = Истина Тогда
		ВыбранныйОтчет = ФормаВыбораОтчета.ЭлементыФормы.ДеревоОтчетов.ТекущаяСтрока;
		ОтчетРасшифровки = ПолучитьПутьСтроки(ВыбранныйОтчет);
		ОтчетРасшифровкиРедактор = СтрЗаменить(ОтчетРасшифровки, Символы.ПС, "/");
	КонецЕсли;
КонецПроцедуры

Процедура ПредставленияФорматНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Конструктор = Новый КонструкторФорматнойСтроки;
	Конструктор.Текст = Элемент.Значение;
	Если Конструктор.ОткрытьМодально() Тогда
		Элемент.Значение = Конструктор.Текст;
	КонецЕсли;
КонецПроцедуры

Процедура ПараметрыПриНачалеРедактирования(Элемент, НоваяСтрока)
	
	Если НоваяСтрока Тогда 
		Элемент.ТекущаяСтрока.ЭтоВыражение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	Перем ЭлементСписка;
	ЭлементСписка = Элемент.Колонки.ЭтоВыражение.ЭлементУправления.СписокВыбора.НайтиПоЗначению(ДанныеСтроки.ЭтоВыражение);
	
	Если ЭлементСписка <> Неопределено Тогда 
		ОформлениеСтроки.Ячейки.ЭтоВыражение.Текст = ЭлементСписка.Представление;
	КонецЕсли;
КонецПроцедуры

Процедура КоманднаяПанельПараметрыЗаполнить(Кнопка)
	
	ЗаполнитьПараметры(Истина);
	
КонецПроцедуры

Процедура ОтчетРасшифровкиРедакторОчистка(Элемент, СтандартнаяОбработка)

	ОтчетРасшифровки = ОтчетРасшифровкиРедактор;

КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	// Уничтожение всех экземпляров компоненты. Обязательный блок.
	ПолеТекстаПрограммы.Уничтожить();
	// ---.КЛАСС.ПолеТекстаПрограммы
	
КонецПроцедуры

Процедура КоманднаяПанельПараметрыОчистить(Кнопка)
	
	Параметры.Очистить();
	
КонецПроцедуры

Процедура ПараметрыИмяПараметраПриИзменении(Элемент)
	
	ЭлементыФормы.Параметры.ТекущиеДанные.ИмяПараметра = СокрЛП(ЭлементыФормы.Параметры.ТекущиеДанные.ИмяПараметра);
	Попытка
		Пустышка = Новый Структура(ЭлементыФормы.Параметры.ТекущиеДанные.ИмяПараметра);
	Исключение
		Пустышка = Новый Структура;
	КонецПопытки;
	Если Пустышка.Количество() = 0 Тогда 
		ЭлементыФормы.Параметры.ТекущиеДанные.ИмяПараметра = "Параметр" + Параметры.Индекс(ЭлементыФормы.Параметры.ТекущаяСтрока);
	КонецЕсли;
	Если ПустаяСтрока(ЭлементыФормы.Параметры.ТекущиеДанные.ПредставлениеПараметра) Тогда
		ЭлементыФормы.Параметры.ТекущиеДанные.ПредставлениеПараметра = ирОбщий.ПредставлениеИзИдентификатораЛкс(ЭлементыФормы.Параметры.ТекущиеДанные.ИмяПараметра);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыТипЗначенияПриИзменении(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.Параметры.ТекущиеДанные;
	Если ЭлементыФормы.Параметры.ТекущиеДанные.ЭтоВыражение = Ложь Тогда 
		ТекущиеДанные.ЗначениеПоУмолчанию = ТекущиеДанные.ТипЗначения.ПривестиЗначение(ЭлементыФормы.Параметры.ТекущиеДанные.ЗначениеПоУмолчанию); 
	ИначеЕсли ЭлементыФормы.Параметры.ТекущиеДанные.ЭтоВыражение = 2 Тогда
		ЭлементыФормы.Параметры.ТекущиеДанные.ЗначениеПоУмолчанию.ТипЗначения = ТекущиеДанные.ТипЗначения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыЗначениеПоУмолчаниюНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ЭлементыФормы.Параметры.ТекущаяСтрока.ЭтоВыражение = Истина Тогда
		ОбработкаВводаФормулы = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирВводВыраженияВстроенногоЯзыка");
		#Если Сервер И Не Сервер Тогда
		    ОбработкаВводаФормулы = Обработки.ирВводВыраженияВстроенногоЯзыка.Создать();
		#КонецЕсли
		ОбработкаВводаФормулы.Инициализировать(ЭтаФорма, ЭлементыФормы.Параметры.ТекущаяСтрока.ЗначениеПоУмолчанию,
			"ВычислитьЛокально", ВладелецФормы);
		ОбработкаВводаФормулы.Описание = "
		|Используйте функцию лПолучитьЗначениеПараметра(<ИмяПараметра>), чтобы обратиться к значению другого параметра.";
		ФормаВводаВыражения = ОбработкаВводаФормулы.ПолучитьФорму(, ЭтаФорма);
		ФормаВводаВыражения.Открыть();
		ФормаВводаВыражения.ОбработкаПолеТекстаПрограммы.ДобавитьСловоЛокальногоКонтекста(
			"лПолучитьЗначениеПараметра", "Метод", Новый ОписаниеТипов("Строка"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
		Если ЗначениеВыбора.Свойство("Формула") Тогда
			ЭлементыФормы.Параметры.ТекущаяСтрока.ЗначениеПоУмолчанию = ЗначениеВыбора.Формула;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПараметрыИмяПараметраПриИзменении(ЭлементыФормы.Параметры.Колонки.ИмяПараметра.ЭлементУправления);
	
КонецПроцедуры

Процедура ПараметрыЗначениеПоУмолчаниюОчистка(Элемент, СтандартнаяОбработка)
	
	Если ЭлементыФормы.Параметры.ТекущаяСтрока.ЭтоВыражение = 2 Тогда
		СтандартнаяОбработка = Ложь;
		ЭлементыФормы.Параметры.ТекущаяСтрока.ЗначениеПоУмолчанию.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПараметрыЭтоВыражениеОчистка(Элемент, СтандартнаяОбработка)
	
	Отказ = Истина;

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольПостроителейОтчетов.Форма.ФормаРедактированияЗапроса");

