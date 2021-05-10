﻿Процедура ВывестиСообщение(Знач ТекстСообщения) Экспорт 
	Открыть();
	ТекстовыйДокумент = ЭлементыФормы.Текст;
	НовыйТекст = ТекстСообщения;
	Текст = ТекстовыйДокумент.ПолучитьТекст();
	Если ЗначениеЗаполнено(Текст) Тогда
		НовыйТекст = Текст + Символы.ПС + НовыйТекст;
	КонецЕсли; 
	ТекстовыйДокумент.УстановитьТекст(НовыйТекст);
	СделанаОбрезка = Ложь;
	Пока ТекстовыйДокумент.КоличествоСтрок() > 30 Цикл
		ТекстовыйДокумент.УдалитьСтроку(1);
		СделанаОбрезка = Истина;
	КонецЦикла; 
	Если СделанаОбрезка Тогда
		ТекстовыйДокумент.ВставитьСтроку(1, "...");
	КонецЕсли; 
	НомерСтроки = Макс(1, ТекстовыйДокумент.КоличествоСтрок()); // https://www.hostedredmine.com/issues/891268
	ЭлементыФормы.Текст.УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 1);
КонецПроцедуры

Процедура ПриЗакрытии()
	ЭлементыФормы.Текст.УстановитьТекст("");
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
КонецПроцедуры

Процедура ПриОткрытии()
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма); 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, КлючУникальности, ": ");
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
КонецПроцедуры

Процедура НадписьСправкаНажатие(Элемент)
	
	ОткрытьСправкуФормы();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СообщенияМодальнойГруппы")

