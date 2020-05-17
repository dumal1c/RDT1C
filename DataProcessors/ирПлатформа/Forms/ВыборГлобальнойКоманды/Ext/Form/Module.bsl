﻿Процедура ПриОткрытии()
	
	Команды.Добавить("РедактироватьОбъектИзАктивнойФормыЛкс", "Передать объект из активной формы в редактор объекта БД",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД"));
	Команды.Добавить("ОбработатьОбъектыИзАктивнойФормыЛкс", "Передать объекты из активной формы в подбор и обработку объектов БД",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирПодборИОбработкаОбъектов"));
	Команды.Добавить("ОткрытьСтруктуруАктивнойФормыЛкс", "Открыть структуру активной формы",, ирКэш.КартинкаИнструментаЛкс("Обработка.ирПлатформа.Форма.СтруктураФормы"));
	ЭлементыФормы.Команды.ТекущаяСтрока = Команды[0];
	ВыбраннаяГлобальнаяКоманда = ирОбщий.ВосстановитьЗначениеЛкс("ВыбраннаяГлобальнаяКоманда");
	Если ВыбраннаяГлобальнаяКоманда <> Неопределено Тогда
		НовыйТекущийЭлемент = Команды.НайтиПоЗначению(ВыбраннаяГлобальнаяКоманда);
		Если НовыйТекущийЭлемент <> Неопределено Тогда
			ЭлементыФормы.Команды.ТекущаяСтрока = НовыйТекущийЭлемент;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	ЗакрытьФорму();
	//Выполнить(ЭлементыФормы.Команды.ТекущаяСтрока.Значение + "()"); // Так окно откроется в режиме блокирования владельца
	ирОбщий.ПодключитьГлобальныйОбработчикОжиданияЛкс(ЭлементыФормы.Команды.ТекущаяСтрока.Значение,, Истина); 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыВыполнитьОтложенно(Кнопка = Неопределено)
	
	ирОбщий.ПодключитьГлобальныйОбработчикОжиданияЛкс(ЭлементыФормы.Команды.ТекущаяСтрока.Значение, 5, Истина);
	ЗакрытьФорму();

КонецПроцедуры

Процедура ЗакрытьФорму()
	ВыбраннаяГлобальнаяКоманда = ЭлементыФормы.Команды.ТекущаяСтрока.Значение;
	ирОбщий.СохранитьЗначениеЛкс("ВыбраннаяГлобальнаяКоманда", ВыбраннаяГлобальнаяКоманда);
	Закрыть(ВыбраннаяГлобальнаяКоманда);
КонецПроцедуры

Процедура КомандыВыбор(Элемент, ЭлементСписка)
	
	ОсновныеДействияФормыОК();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборГлобальнойКоманды");
