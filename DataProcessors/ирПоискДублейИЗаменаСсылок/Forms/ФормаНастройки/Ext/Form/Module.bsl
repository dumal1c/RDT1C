﻿
Процедура ПриОткрытии()
	
	НастроитьЭлементыФормы();
	ЭлементыФормы.ВыполнятьНаСервере.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
	ирОбщий.НастроитьПоляВводаПараметровПотоковЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ИзменятьПоляПоСвязямПараметровВыбораПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.ОпределятьСвязьПоВладельцуПоДанным.Доступность = ИзменятьПоляПоСвязямПараметровВыбора;
	ДоступностьМногопоточности = ВыполнятьНаСервере И ЭлементыФормы.ВыполнятьНаСервере.Доступность И Не ирКэш.ЛиФайловаяБазаЛкс();
	ЭлементыФормы.КоличествоПотоков.Доступность = ДоступностьМногопоточности;
	ЭлементыФормы.КоличествоОбъектовВПорции.Доступность = КоличествоПотоков > 1 И ДоступностьМногопоточности;
	
КонецПроцедуры

Процедура КоличествоОбъектовВПорцииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = 1;

КонецПроцедуры

Процедура КоличествоПотоковОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = 1;

КонецПроцедуры

Процедура КоличествоПотоковПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура ВыполнятьНаСервереПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискДублейИЗаменаСсылок.Форма.ФормаНастройки");

