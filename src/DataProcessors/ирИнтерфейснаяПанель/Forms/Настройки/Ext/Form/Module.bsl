﻿
Процедура КнопкаОКНажатие(Кнопка)
	Закрыть(Истина);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриОткрытии()
	
	СписокВыбора = ЭлементыФормы.ИсторияКоманд.СписокВыбора;
	СписокВыбора.Добавить(20);
	СписокВыбора.Добавить(50);
	СписокВыбора.Добавить(100);
	ЭлементыФормы.ПоискЧерезРегулярныеВыражения.Доступность = ирКэш.ДоступныРегВыраженияЛкс();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирИнтерфейснаяПанель.Форма.Настройки");

