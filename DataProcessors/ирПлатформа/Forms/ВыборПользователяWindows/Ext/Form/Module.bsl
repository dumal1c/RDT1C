﻿
// Процедура заполняет дерево "ПользователиWindows" значениями из таблицы значений "мПользователиWindows"
//
Процедура ЗаполнитьПользователиWindows()
	
	ДеревоПользователейWindows.Строки.Очистить();
	ДеревоПользователиWindows = ПользователиWindows();
	
	Для Каждого СервераWindows Из ДеревоПользователиWindows Цикл
		
		СервераWindowsДерево = ДеревоПользователейWindows.Строки.Добавить();
		СервераWindowsДерево.Представление = "" + СервераWindows.ИмяДомена + "(" + СервераWindows.ИмяСервера + ")";
		СервераWindowsДерево.Значение = СервераWindows.ИмяДомена;
		
		Для Каждого ПользовательWindows Из СервераWindows.Пользователи Цикл
			
			ТекущиеДанные = СервераWindowsДерево.Строки.Добавить();
			ТекущиеДанные.Значение = ПользовательWindows;
			ТекущиеДанные.Представление = ПользовательWindows;
			Если "\\"+СервераWindowsДерево.Значение+"\"+ТекущиеДанные.Значение  = ВыбранныйПользовательWindows Тогда
				ЭлементыФормы.ПользователиWindows.ТекущаяСтрока = ТекущиеДанные;
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЦикла; 
	
КонецПроцедуры // () 

// Процедура - обаботчик события "ПриОткрытии" Формы
//
Процедура ПриОткрытии()
	
	ЗаполнитьПользователиWindows()
	
КонецПроцедуры

// Процедура - обаботчик события "ПриВыводеСтроки"  табличного поля "ПользователиWindows"
//
Процедура ПользователиWindowsПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Уровень() = 1 Тогда
		ОформлениеСтроки.Ячейки.Представление.Картинка = БиблиотекаКартинок.Пользователь;
		ОформлениеСтроки.Ячейки.Представление.ОтображатьКартинку = Истина;
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обаботчик события, при нажатии на кнопку "ОК" Командной панели "ОсновныеДействияФормы"
//
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.ПользователиWindows.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено или Не ТекущиеДанные.Уровень() = 1 Тогда
		Предупреждение("Выберите пользователя Windows");
	Иначе
		Закрыть("\\"+ТекущиеДанные.Родитель.Значение+"\"+ТекущиеДанные.Значение);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обаботчик события "Выбор"  табличного поля "ПользователиWindows"
//
Процедура ПользователиWindowsВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущиеДанные = ЭлементыФормы.ПользователиWindows.ТекущиеДанные;
	Если Не ТекущиеДанные = Неопределено и ТекущиеДанные.Уровень() = 1 Тогда
		Закрыть("\\"+ТекущиеДанные.Родитель.Значение+"\"+ТекущиеДанные.Значение);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обаботчик события, при нажатии на кнопку "Обновить" Командной панели "КоманднаяПанельПользователиWindows"
//
Процедура КоманднаяПанельПользователиWindowsОбновить(Кнопка)
	
	мПользователиWindows = ПользователиWindows();
	ЗаполнитьПользователиWindows();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборПользователяWindows");
ДеревоПользователейWindows.Колонки.Добавить("Значение");