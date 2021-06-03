﻿Перем Колонки;
Перем ПолноеИмяТаблицыБД;
Перем СравнениеТаблиц;

Процедура ПриОткрытии()
	
	Если КлючУникальности = "Автотест" Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	СравнениеТаблиц = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирСравнениеТаблиц");
	ирОбщий.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(Этаформа);
	
КонецПроцедуры

Функция ОбновитьСоставСвойств()
	
	СостоянияСтрок = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.СвойстваОбъектов, "Имя");
	СвойстваОбъектов.Очистить();
	ТипОбъекта = "";
	ЗагрузитьСторонуСравнения(Объект1, 1, ТипОбъекта);
	Если СвойстваОбъектов.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли; 
	ЗагрузитьСторонуСравнения(Объект2, 2, ТипОбъекта);
	Для Каждого СтрокаСвойства Из СвойстваОбъектов Цикл
		Если СтрокаСвойства.ЗначениеУстановлено1 И Не СтрокаСвойства.ЗначениеУстановлено2 Тогда 
			СтрокаСвойства.ТипРазличия = "Только 1";
		ИначеЕсли СтрокаСвойства.ЗначениеУстановлено2 И Не СтрокаСвойства.ЗначениеУстановлено1 Тогда 
			СтрокаСвойства.ТипРазличия = "Только 2";
		Иначе
			СтрокаИзОбъекта1 = ирОбщий.ОбъектВСтрокуДляСравненияВнутрЛкс(СтрокаСвойства["Значение1"]);
			СтрокаИзОбъекта2 = ирОбщий.ОбъектВСтрокуДляСравненияВнутрЛкс(СтрокаСвойства["Значение2"]);
			Если Ложь
				Или (Истина
					//И Не ирОбщий.ЛиКоллекцияЛкс(СтрокаСвойства["Значение1"])
					И СтрокаСвойства["Значение1"] = СтрокаСвойства["Значение2"])
				Или (Истина
					И СтрокаИзОбъекта1 <> Неопределено
					И СтрокаИзОбъекта2 <> Неопределено
					И СтрокаИзОбъекта1 = СтрокаИзОбъекта2)
			Тогда
			Иначе
				СтрокаСвойства.ТипРазличия = "Изменено";
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	СвойстваОбъектов.Сортировать("Имя");
	Если ТолькоРазличия Тогда
		Для Каждого СтрокаРавныхЗначений Из СвойстваОбъектов.НайтиСтроки(Новый Структура("ТипРазличия", "")) Цикл
			СвойстваОбъектов.Удалить(СтрокаРавныхЗначений);
		КонецЦикла;
	КонецЕсли; 
	ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.СвойстваОбъектов, СостоянияСтрок);
	Если ЗначениеЗаполнено(ПараметрТекущееСвойство) Тогда
		СтрокаТаблицы = СвойстваОбъектов.Найти(ПараметрТекущееСвойство, "Имя");
		Если СтрокаТаблицы <> Неопределено Тогда
			ЭлементыФормы.СвойстваОбъектов.ТекущаяСтрока = СтрокаТаблицы;
		КонецЕсли; 
		ПараметрТекущееСвойство = "";
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок, , ТипОбъекта, ": ");
	КоличествоРазличий = СвойстваОбъектов.Количество() - СвойстваОбъектов.НайтиСтроки(Новый Структура("ТипРазличия", "")).Количество();
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.ДействияФормы.Кнопки.ТолькоРазличия.Текст, , "" + КоличествоРазличий + " шт", ": ");
	Возврат Истина;

КонецФункции

Процедура ЗагрузитьСторонуСравнения(Знач Объект, Знач НомерСтороны, ТипОбъекта = "")
	
	ПоляТаблицыБД = Неопределено;
	СтруктураОбъекта = ирОбщий.СтруктураИзОбъектаЛкс(Объект, ТипОбъекта, ПоляТаблицыБД);
	ЭтаФорма["ПредставлениеОбъекта" + НомерСтороны] = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(Объект,, Истина);
	Для Каждого КлючИЗначение Из СтруктураОбъекта Цикл
		СтрокаСвойства = СвойстваОбъектов.Найти(КлючИЗначение.Ключ, "Имя");
		Если СтрокаСвойства = Неопределено Тогда
			СтрокаСвойства = СвойстваОбъектов.Добавить();
			СтрокаСвойства.Имя = КлючИЗначение.Ключ;
			Если ПоляТаблицыБД <> Неопределено Тогда
				СтрокаПоля = ПоляТаблицыБД.Найти(КлючИЗначение.Ключ, "Имя");
				Если СтрокаПоля <> Неопределено Тогда
					СтрокаСвойства.Представление = СтрокаПоля.Заголовок;
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли; 
		ЗначениеСвойства = КлючИЗначение.Значение;
		СтрокаСвойства["ЗначениеУстановлено" + НомерСтороны] = Истина;
		СтрокаСвойства["Значение" + НомерСтороны] = ЗначениеСвойства;
		СтрокаСвойства["ПредставлениеЗначения" + НомерСтороны] = ЗначениеСвойства;
		ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаСвойства, "Значение" + НомерСтороны,, "ТипЗначения" + НомерСтороны, "ИмяТипаЗначения" + НомерСтороны,, ЗначениеСвойства);
	КонецЦикла;

КонецПроцедуры

Процедура СвойстваОбъектовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	Если ДанныеСтроки.ТипРазличия = "Изменено" Тогда
		ОформлениеСтроки.ЦветФона = СравнениеТаблиц.ОтличаютсяЦветФона;
	ИначеЕсли ДанныеСтроки.ТипРазличия = "Только 1" Тогда
		ОформлениеСтроки.ЦветФона = СравнениеТаблиц.ТолькоВТаблице1ЦветФона;
	ИначеЕсли ДанныеСтроки.ТипРазличия = "Только 2" Тогда
		ОформлениеСтроки.ЦветФона = СравнениеТаблиц.ТолькоВТаблице2ЦветФона;
	КонецЕсли;
	ОформлениеСтроки.Ячейки.Объект1.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.Объект2.Видимость = Ложь;
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.ДействияФормы.Кнопки.Идентификаторы, "ПредставлениеЗначения1, ПредставлениеЗначения2",
		Новый Структура("ПредставлениеЗначения1, ПредставлениеЗначения2", "Значение1", "Значение2"));
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка = Неопределено)
	
	ЗагрузитьДанные();

КонецПроцедуры

Функция ЗагрузитьДанные()
	
	Успех = Истина;
	ЭлементыФормы.ДействияФормы.Кнопки.СравнитьКакКоллекции.Доступность = ирОбщий.ЛиКоллекцияЛкс(Объект1);
	Если Не ОбновитьСоставСвойств() Тогда 
		Успех = Ложь;
		Если ирОбщий.ЛиКоллекцияЛкс(Объект1) Тогда 
			ДействияФормыСравнитьКакКоллекции();
		Иначе
			ирОбщий.СравнитьЗначенияВФормеЧерезXMLЛкс(Объект1, Объект2);
		КонецЕсли; 
	КонецЕсли;
	Возврат Успех;

КонецФункции

Процедура СвойстваОбъектовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		ИЛи Колонка = ЭлементыФормы.СвойстваОбъектов.Колонки.ПредставлениеЗначения1 
		Или Колонка = ЭлементыФормы.СвойстваОбъектов.Колонки.ПредставлениеЗначения2
	Тогда 
		НомерСтороны = Прав(Колонка.Имя, 1);
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ВыбраннаяСтрока["Значение" + НомерСтороны]);
	ИначеЕсли ВыбраннаяСтрока.ТипРазличия = "Изменено" И Колонка = ЭлементыФормы.СвойстваОбъектов.Колонки.ТипРазличия Тогда  
		ирОбщий.СравнитьЗначенияВФормеЛкс(ВыбраннаяСтрока["Значение1"], ВыбраннаяСтрока["Значение2"],,,,,, Новый УникальныйИдентификатор);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СвойстваОбъектовПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыИсследовать(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.СвойстваОбъектов.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	МетаданныеПоля = МетаданныеПоля(ТекущаяСтрока);
	Если МетаданныеПоля = Неопределено Тогда
		МетаданныеПоля = ирОбщий.ОбъектМДПоПолномуИмениТаблицыБДЛкс(ИмяТаблицыБД);
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(МетаданныеПоля);
	
КонецПроцедуры

Функция МетаданныеПоля(Знач ТекущаяСтрока = Неопределено)
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = ЭлементыФормы.СвойстваОбъектов.ТекущаяСтрока;
	КонецЕсли; 
	ИмяТаблицыБДВсеПоля = ИмяТаблицыБД;
	Если ирОбщий.ЛиКорневойТипРегистраБухгалтерииЛкс(ирОбщий.ТипТаблицыБДЛкс(ИмяТаблицыБД)) Тогда
		ИмяТаблицыБДВсеПоля = ИмяТаблицыБДВсеПоля + ".ДвиженияССубконто";
	КонецЕсли; 
	ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыБДВсеПоля);
	ПолеТаблицы = ПоляТаблицыБД.Найти(ТекущаяСтрока.Имя);
	МетаданныеПоля = ПолеТаблицы.Метаданные;
	Возврат МетаданныеПоля;

КонецФункции

Процедура ДействияФормыАнализПравДоступа(Кнопка)
	
	Если ЭлементыФормы.СвойстваОбъектов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПолноеИмяПоляТаблицы = ИмяТаблицыБД + "." + ЭлементыФормы.СвойстваОбъектов.ТекущаяСтрока.Имя;
	Форма = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, "" + ПолноеИмяПоляТаблицы);
	Форма.НаборПолей.Добавить(ПолноеИмяПоляТаблицы);
	Форма.ВычислятьФункциональныеОпции = Истина;
	Форма.ПараметрКлючВарианта = "ПоПолямМетаданных";
	Форма.Открыть();
	
КонецПроцедуры

Процедура СвойстваОбъектовПриАктивизацииСтроки(Элемент)
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура ПредставлениеОбъекта1Открытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ИсследоватьЛкс(Объект1);
	
КонецПроцедуры

Процедура ПредставлениеОбъекта2Открытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ИсследоватьЛкс(Объект2);
	
КонецПроцедуры

Процедура ДействияФормыСравнитьКакКоллекции(Кнопка = Неопределено)
	
	ирОбщий.СравнитьЗначенияВФормеЛкс(Объект1, Объект2,,,,,,, Истина);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если КлючУникальности = "Автотест" Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗагрузитьДанные() Тогда 
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыТолькоРазличия(Кнопка)
	
	ТолькоРазличия = Не Кнопка.Пометка;
	Кнопка.Пометка = ТолькоРазличия;
	ОбновитьСоставСвойств();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СравнениеОбъектов");
СвойстваОбъектов.Колонки.Добавить("Значение1");
СвойстваОбъектов.Колонки.Добавить("Значение2");
СвойстваОбъектов.Колонки.Добавить("ЗначениеУстановлено1", Новый ОписаниеТипов("Булево"));
СвойстваОбъектов.Колонки.Добавить("ЗначениеУстановлено2", Новый ОписаниеТипов("Булево"));
