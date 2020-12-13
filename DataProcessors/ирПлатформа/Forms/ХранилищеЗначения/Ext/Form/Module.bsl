﻿
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	НовоеЗначение = ПолучитьРезультат();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Функция ПолучитьРезультат()
	
	Возврат Новый ХранилищеЗначения(Значение);

КонецФункции

Процедура ПриОткрытии()
	
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("ХранилищеЗначения") Тогда
		НачальноеЗначениеВыбора = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли; 
	Значение = НачальноеЗначениеВыбора.Получить();
	ЗначениеПриИзменении();
	ЭлементыФормы.Значение.ТипЗначения = ирОбщий.ОписаниеТиповВсеРедактируемыеТипыЛкс();
	ЭлементыФормы.Значение.Значение = Значение;
	ЭлементыФормы.Значение.КнопкаОткрытия = Истина;

КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ЗначениеПриИзменении(Элемент = Неопределено)
	
	Если Элемент <> Неопределено Тогда
		ЭтаФорма.Значение = ЭлементыФормы.Значение.Значение;
	КонецЕсли; 
	ЭтаФорма.ТипЗначения = ТипЗнч(Значение);
	ПодключитьОбработчикОжидания("ОбновитьРазмер", 0.1, Истина);
	
КонецПроцедуры

Процедура ОбновитьРазмер()
	
	ЭтаФорма.Размер = ирОбщий.РазмерЗначенияЛкс(Значение);

КонецПроцедуры

Процедура ЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ирОбщий.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка, Значение) Тогда 
		ЗначениеПриИзменении();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ОткрытьЗначениеЛкс(Значение, Ложь);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ХранилищеЗначения");

