﻿
Процедура ДействияФормыМенеджерТабличногоПоля(Кнопка)
	
	ирКлиент.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.СправочникСписок, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирКлиент.ОткрытьСправкуПоПодсистемеЛкс(ТипЗнч(СправочникСписок));
	
КонецПроцедуры

Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		Текст = Элемент.ТекущаяСтрока.ТекстАлгоритма;
	Иначе
		Текст = "";
	КонецЕсли; 
	ЭлементыФормы.ПолеТекста.УстановитьТекст(Текст);
	
КонецПроцедуры

Процедура ДействияФормыКонсольКода(Кнопка = Неопределено)
	
	Ссылка = ЭлементыФормы.СправочникСписок.ТекущаяСтрока;
	Если Ссылка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Справочники[Метаданные.НайтиПоТипу(ТипЗнч(ЭлементыФормы.СправочникСписок.Значение)).Имя].ОткрытьКонсольКодаДляАлгоритма(Ссылка);
	
КонецПроцедуры

Процедура ТекстАлгоритмаПриИзменении(Элемент)
	
	СправочникСписок.Отбор.ТекстАлгоритма.Использование = Истина;
	СправочникСписок.Отбор.ТекстАлгоритма.ВидСравнения = ВидСравнения.Содержит;
	
КонецПроцедуры

Процедура ОткрытьНастройкиАлгоритмов(Кнопка)
	
	ирКлиент.ОткрытьНастройкиАлгоритмовЛкс();
	
КонецПроцедуры

Процедура СправочникСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриОткрытии()
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Справочник.ирАлгоритмы.Форма.ФормаСписка");
Порядок.Установить("ДатаИзменения Убыв");
