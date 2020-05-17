﻿
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	НовоеЗначение = ПолучитьРезультат();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Функция ПолучитьРезультат()
	
	Возврат ЭлементыФормы.ПолеКартинки.Картинка;

КонецФункции

Процедура ПриОткрытии()
	
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("Картинка") Тогда
		НачальноеЗначениеВыбора = Новый Картинка;
	КонецЕсли; 
	ЭлементыФормы.ПолеКартинки.Картинка = НачальноеЗначениеВыбора;
	ЗначениеПриИзменении();

КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ЗначениеПриИзменении(Элемент = Неопределено)
	
	ЭтаФорма.Вид = ЭлементыФормы.ПолеКартинки.Картинка.Вид;
	ОбновитьРазмер();
	
КонецПроцедуры

Процедура ОбновитьРазмер()
	
	ЭтаФорма.Размер = ирОбщий.РазмерЗначенияЛкс(ЭлементыФормы.ПолеКартинки.Картинка);

КонецПроцедуры

Процедура ВыгрузитьВФайлНажатие(Элемент)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(Ложь);
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		ЭлементыФормы.ПолеКартинки.Картинка.Записать(ПолноеИмяФайла);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗагрузитьИзФайлаНажатие(Элемент)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(Истина);
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		ЭлементыФормы.ПолеКартинки.Картинка = Новый Картинка(ПолноеИмяФайла);
	КонецЕсли; 
	ЗначениеПриИзменении();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.Картинка");

