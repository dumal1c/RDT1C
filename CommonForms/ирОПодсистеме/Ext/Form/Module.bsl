﻿
Процедура ПриОткрытии()
	
	//Если Метаданные.РежимСовместимости = Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_1 Тогда
	//	Для Каждого Подсистема Из Объект.Метаданные().Подсистемы Цикл
	//		//Если Подсистема.Имя = "" Тогда
	//		//КонецЕсли; 
	//		Прервать;
	//	КонецЦикла;
	//	ОткрытьСправку(Подсистема);
	//Иначе
	//	МассивПодсистем = Новый Массив;
	//	МассивПодсистем.Добавить(Метаданные.Подсистемы.ИнструментыРазработчика.Подсистемы.КонтекстнаяПодсказка);
	//	МассивПодсистем.Добавить(Метаданные.Подсистемы.ИнструментыРазработчика);
	//	ОбъектМД = Объект.Метаданные();
	//	Для Каждого Подсистема Из МассивПодсистем Цикл
	//		Если Подсистема.Состав.Содержит(ОбъектМД) Тогда 
	//			ОткрытьСправку(Подсистема);
	//			Прервать;
	//		КонецЕсли; 
	//	КонецЦикла;
	//КонецЕсли; 
	ЭтаФорма.Версия = Метаданные.Подсистемы.ИнструментыРазработчика.Синоним;
	ЭлементыФормы.ПолеHTMLДокумента.УстановитьТекст(ПолучитьОбщийМакет("ирОПодсистеме").ПолучитьТекст());
	
КонецПроцедуры
