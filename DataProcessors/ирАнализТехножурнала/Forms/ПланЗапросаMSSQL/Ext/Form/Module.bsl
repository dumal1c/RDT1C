﻿Перем мСловарьПланаЗапроса;
Перем мНомерСамойТяжелойОперации;

Процедура ПриОткрытии()
	
	мСловарьПланаЗапроса = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(ОбработкаОбъект.ПолучитьМакет("ОперацииПланаЗапросаMSSQL"));
	#Если Сервер И Не Сервер Тогда
	    мСловарьПланаЗапроса = Новый ТаблицаЗначений;
	#КонецЕсли
	мСловарьПланаЗапроса.Индексы.Добавить("Ключ");
	КолонкиПланаЗапроса = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(ОбработкаОбъект.ПолучитьМакет("КолонкиПланаЗапросаMSSQL"));
	#Если Сервер И Не Сервер Тогда
	    КолонкиПланаЗапроса = Новый ТаблицаЗначений;
	#КонецЕсли
	Для Каждого СтрокаКолонки Из КолонкиПланаЗапроса Цикл
		ЭлементыФормы.ДеревоПлана.Колонки[СтрокаКолонки.ИмяКолонки].ПодсказкаВШапке = СтрокаКолонки.Описание;
		ЭлементыФормы.ДеревоПлана.Колонки[СтрокаКолонки.ИмяКолонки].ТекстШапки = СтрокаКолонки.ЗаголовокКолонки;
		ЭлементыФормы.ТаблицаПлана.Колонки[СтрокаКолонки.ИмяКолонки].ПодсказкаВШапке = СтрокаКолонки.Описание;
		ЭлементыФормы.ТаблицаПлана.Колонки[СтрокаКолонки.ИмяКолонки].ТекстШапки = СтрокаКолонки.ЗаголовокКолонки;
	КонецЦикла;
	RegExp = ирКэш.Получить().RegExp;
	RegExp.Global = Истина;
	RegExp.Multiline = Ложь;
	ШаблонЧисла = "([^,_\n]*),";
	ШаблонНепечатного = "\s*";
	RegExp.Pattern = ""
		+ ШаблонЧисла + ШаблонНепечатного //1
		+ ШаблонЧисла + ШаблонНепечатного //2
		+ ШаблонЧисла + ШаблонНепечатного //3
		+ ШаблонЧисла + ШаблонНепечатного //4
		+ ШаблонЧисла + ШаблонНепечатного //5
		+ ШаблонЧисла + ШаблонНепечатного //6
		+ ШаблонЧисла + ШаблонНепечатного //7
		+ ШаблонЧисла                     //8
		+ "([^\n]*)(?:\n|$)";             //9
	РезультатПоиска = RegExp.Execute(Текст);
	МаркерИнструкции = "|--";
	НомерОперации = 1;
	ИндексПервойКолонкиПланаЗапрос = 1;
	Для Каждого Вхождение Из РезультатПоиска Цикл
		ТекстИнструкции = Вхождение.SubMatches(8);
		ПозицияПалки = Найти(ТекстИнструкции, МаркерИнструкции);
		Уровень = 0;
		Если ПозицияПалки > 0 Тогда
			Уровень = (ПозицияПалки - 4) / 5 + 1;
			ТекстИнструкции = Сред(ТекстИнструкции, ПозицияПалки + СтрДлина(МаркерИнструкции));
		Иначе
			ТекстИнструкции = СокрЛ(ТекстИнструкции);
		КонецЕсли; 
		СтрокаДерева = ДобавитьСтрокуДерева(Уровень);
		СтрокаДерева.Инструкция = ТекстИнструкции;
		СтрокаДерева.ОператорАнгл = ирОбщий.ПолучитьПервыйФрагментЛкс(СтрокаДерева.Инструкция, "(");
		СтрокаСловаря = мСловарьПланаЗапроса.Найти(СтрокаДерева.ОператорАнгл, "Ключ");
		Если СтрокаСловаря <> Неопределено Тогда
			СтрокаДерева.Оператор = СтрокаСловаря.Название;
		КонецЕсли; 
		СтрокаДерева.НомерОперации = НомерОперации;
		Для Индекс = 0 По 7 Цикл
			СтрокаЗначения = Вхождение.SubMatches(Индекс);
			ТипКолонки = ТипЗнч(СтрокаДерева[КолонкиПланаЗапроса[Индекс].ИмяКолонки]);
			Если ТипКолонки = Тип("Число") Тогда
				Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(СтрокаЗначения, "E");
				Если Фрагменты.Количество() > 1 Тогда
					СтрокаЗначения = Число(Фрагменты[0]) * pow(10, Число(Фрагменты[1]));
				КонецЕсли; 
			КонецЕсли; 
			СтрокаДерева[КолонкиПланаЗапроса[Индекс].ИмяКолонки] = СтрокаЗначения;
		КонецЦикла;
		НомерОперации = НомерОперации + 1;
	КонецЦикла;
	РасчитатьСтоимостьОпераций(ДеревоПлана.Строки);
	ВсеСтрокиДерева = ирОбщий.ВсеСтрокиДереваЗначенийЛкс(ДеревоПлана);
	ОператорыПланаЗапроса.Очистить();
	Если ДеревоПлана.Строки.Количество() > 0 Тогда
		ОбщаяСтоимость = ДеревоПлана.Строки[0].СтоимостьПоддерева;
		Для Каждого СтрокаДерева Из ВсеСтрокиДерева Цикл
			Если ОбщаяСтоимость = 0 Тогда
				СтрокаДерева.СтоимостьПоддереваПроцент = 0;
				СтрокаДерева.СтоимостьОперацииПроцент = 0;
			Иначе
				СтрокаДерева.СтоимостьПоддереваПроцент = СтрокаДерева.СтоимостьПоддерева / ОбщаяСтоимость * 100;
				СтрокаДерева.СтоимостьОперацииПроцент = СтрокаДерева.СтоимостьОперации / ОбщаяСтоимость * 100;
			КонецЕсли; 
			ЗаполнитьЗначенияСвойств(ОператорыПланаЗапроса.Добавить(), СтрокаДерева); 
		КонецЦикла;
		ОператорыПланаЗапроса.Сортировать("СтоимостьОперации убыв");
		мНомерСамойТяжелойОперации = ОператорыПланаЗапроса[0].НомерОперации;
	КонецЕсли; 
	
КонецПроцедуры

Функция РасчитатьСтоимостьОпераций(СтрокиДерева)
	
	Сумма = 0;
	Для каждого СтрокаДерева Из СтрокиДерева Цикл 
		АккумуляторСтоимости = 0;
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			АккумуляторСтоимости = РасчитатьСтоимостьОпераций(СтрокаДерева.Строки);
		КонецЕсли;
		СтоимостьОперации = СтрокаДерева.СтоимостьПоддерева - АккумуляторСтоимости;
		СтрокаДерева.СтоимостьОперации = ?(СтоимостьОперации < 0, 0, СтоимостьОперации);
		Сумма = Сумма + СтрокаДерева.СтоимостьПоддерева;
	КонецЦикла;
	Возврат Сумма;
	
КонецФункции

Функция ДобавитьСтрокуДерева(Уровень)
	
	СтрокиУровня = ДеревоПлана.Строки;
	Для Счетчик = 2 По Уровень Цикл
		Если СтрокиУровня.Количество() = 0 Тогда
			ВызватьИсключение "Некорректный план запроса. Уровень очередной строки больше уровня предыдущей строки на 2 или более";
		КонецЕсли; 
		СтрокиУровня = СтрокиУровня[СтрокиУровня.Количество() - 1].Строки;
	КонецЦикла;
	Результат = СтрокиУровня.Добавить();
	
	Возврат Результат;
	
КонецФункции

Процедура ДеревоПланаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	СтрокаСловаря = мСловарьПланаЗапроса.Найти(ДанныеСтроки.ОператорАнгл, "Ключ");
	Если ТипЗнч(СтрокаСловаря.Картинка) = Тип("Картинка") Тогда
		ОформлениеСтроки.Ячейки.Инструкция.УстановитьКартинку(СтрокаСловаря.Картинка);
	КонецЕсли; 
	Если ДанныеСтроки.НомерОперации = мНомерСамойТяжелойОперации Тогда
		ОформлениеСтроки.ЦветФона = ирОбщий.ПолучитьЦветСтиляЛкс("ирЦветФонаОшибки");
	КонецЕсли; 
	//ирОбщий.ОформитьФонТекущейСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ДеревоПланаПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		ЭтаФорма.ОписаниеОперации = "";
		ЭтаФорма.Инструкция = "";
		Возврат;
	КонецЕсли; 
	СтрокаСловаря = мСловарьПланаЗапроса.Найти(Элемент.ТекущаяСтрока.ОператорАнгл, "Ключ");
	ЭтаФорма.ОписаниеОперации = СтрокаСловаря.Описание;
	ЭтаФорма.Инструкция = Элемент.ТекущаяСтрока.Инструкция;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаПланаОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ТаблицаПлана, ЭтаФорма);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.ПланЗапросаMSSQL");
