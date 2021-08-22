﻿
Процедура ВладелецНажатие(Элемент)
	
	ВладелецФормы.Открыть();
	
КонецПроцедуры

Процедура ОбновитьСостояниеЗаданияБезПараметров() 
	Если Не Открыта() Тогда
		ПодключитьОбработчикОжидания("ОбновитьСостояниеЗаданияБезПараметров", 2, Истина);
	КонецЕсли; 
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОбновитьСостояниеЗадания(ФоновоеЗадание);
КонецПроцедуры

Процедура ОбновитьСостояниеЗадания(Знач ФоновоеЗадание) Экспорт 
	
	Конец = ФоновоеЗадание.Конец;
	Если Не ЗначениеЗаполнено(Конец) Тогда
		Конец = ирОбщий.ТекущаяДатаЛкс(Истина, Истина);
	КонецЕсли; 
	ЭтаФорма.Состояние = ирОбщий.ПредставлениеДлительностиЛкс(Конец - ФоновоеЗадание.Начало) + "с " + ФоновоеЗадание.Состояние;
	ИзменитьВидимостьПотоков();
	Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		ЭлементыФормы.Состояние.ЦветТекста = ирОбщий.ЦветТекстаАктивностиЛкс();
		ПодключитьОбработчикОжидания("ОбновитьСостояниеЗаданияБезПараметров", 2, Истина);
	Иначе
		ЭтаФорма.Заголовок = "Фоновое задание формы - " + КраткоеПредставление;
		ЭлементыФормы.Состояние.ЦветТекста = WebЦвета.ТемноЗеленый;
		ЭлементыФормы.Отменить.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура СостояниеНажатие(Элемент)
	
	ФормаФоновогоЗадания = ирОбщий.ПолучитьФормуЛкс("Обработка.ирКонсольЗаданий.Форма.ДиалогФоновогоЗадания",,, ИдентификаторЗадания);
	ФормаФоновогоЗадания.Идентификатор = ИдентификаторЗадания;
	ФормаФоновогоЗадания.Открыть();
	
КонецПроцедуры

Процедура ПриОткрытии()
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	#Если Сервер И Не Сервер Тогда
		ПоказатьПоследнююСтроку();
	#КонецЕсли
	ПодключитьОбработчикОжидания("ПоказатьПоследнююСтроку", 0.1, Истина); // Сразу после ПриОткрытии поле текстового документа устанавливает каретку в первую строку
КонецПроцедуры

Процедура ПоказатьПоследнююСтроку()
	ИзменитьВидимостьПотоков(Ложь);
	ПолеТекста = ирОбщий.ОболочкаПоляТекстаЛкс(ЭлементыФормы.ПолеТекста);
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ПолеТекста.ПоказатьПоследнююСтроку();
КонецПроцедуры

Процедура ИзменитьВидимостьПотоков(Знач НоваяВидимостьПотоков = Неопределено)
	
	Если Не Открыта() Тогда
		Возврат;
	КонецЕсли; 
	Если НоваяВидимостьПотоков = Неопределено Тогда
		Если Истина
			И ЭлементыФормы.Потоки.Свертка <> РежимСверткиЭлементаУправления.Нет 
			И Потоки.Количество() > 0
		Тогда 
			НоваяВидимостьПотоков = Истина;
		Иначе
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.ИзменитьСвернутостьЛкс(ЭтаФорма, НоваяВидимостьПотоков, ЭлементыФормы.Потоки, ЭлементыФормы.гРазделитель2, ЭтаФорма.Панель, "верх");

КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт 
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не Отказ Тогда
		ИзменитьВидимостьПотоков(Истина);
	КонецЕсли;
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ФоновоеЗаданиеФормы");
ЗакрыватьПриЗакрытииВладельца = Истина;
Потоки.Колонки.Добавить("НомерПотока");
