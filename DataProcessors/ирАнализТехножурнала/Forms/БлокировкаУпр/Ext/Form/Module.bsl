﻿Перем ШаблонПоля;
Перем ШаблонЭлемента;
Перем ШаблонОбласти;

Процедура ПриОткрытии()
	
	СтрокаБлокировки = ЭтотОбъект.ТаблицаЖурнала.Найти(ЭтаФорма.КлючУникальности, "МоментВремени");
	Если СтрокаБлокировки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " - " + Формат(СтрокаБлокировки.МоментВремени, "ЧГ=");
	ЭтаФорма.Инфобаза = СтрокаБлокировки.Инфобаза;
	ЭтаФорма.Соединение = СтрокаБлокировки.Соединение_;
	ЭтаФорма.TCPСоединение = СтрокаБлокировки.TCPСоединение;
	ЭтаФорма.Сеанс = СтрокаБлокировки.Сеанс;
	ЭтаФорма.Пользователь = СтрокаБлокировки.Пользователь;
	ЭтаФорма.Длительность = СтрокаБлокировки.Длительность;
	ЭтаФорма.Пространства = СтрокаБлокировки.Regions;
	ЭтаФорма.ПространстваМета = СтрокаБлокировки.RegionsМета;
	ЭтаФорма.СтрокаМодуля = СтрокаБлокировки.СтрокаМодуля;
	ЭтаФорма.Дата = СтрокаБлокировки.Дата;
	ЭтаФорма.ДатаНачала = СтрокаБлокировки.ДатаНачала;
	ЭтаФорма.МоментВремени = СтрокаБлокировки.МоментВремени;
	ЭтаФорма.МоментВремениНачала = СтрокаБлокировки.МоментВремениНачала;
	МассивСоединенийБлокираторов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(СтрокаБлокировки.Блокираторы,,, Ложь);
	Счетчик = 1;
	Для Каждого БлокировавшееСоединение Из МассивСоединенийБлокираторов Цикл
		СтрокаБлокиратора = БлокировавшиеСоединения.Добавить();
		СтрокаБлокиратора.TCPСоединение = БлокировавшееСоединение;
		СтрокаБлокиратора.Порядок = Счетчик;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	ПоляОбластиБлокировки.Очистить();
	ОписаниеБлокировкиМета = ПолучитьОписаниеБлокировкиМета(СтрокаБлокировки);
	ЗагрузитьОбластиБлокировки(ОбластиБлокировки, СтрокаБлокировки.Locks, ОписаниеБлокировкиМета);
	ЭтаФорма.КоличествоЭлементов = ОбластиБлокировки.Количество();
	
КонецПроцедуры

Функция ПолучитьОписаниеБлокировкиМета(Знач СтрокаБлокировки)
	
	ОписаниеБлокировкиМета = СтрокаБлокировки.LocksМета;
	Если ирОбщий.СтрокиРавныЛкс(ОписаниеБлокировкиМета, РезультатПереводаСлишкомБольшогоТекста()) Тогда
		Состояние("Перевод в термины метаданных...");
		ОписаниеБлокировкиМета = ПеревестиТекстБДВТерминыМетаданных(СтрокаБлокировки.Locks,,,,, 0);
		СтрокаБлокировки.LocksМета = ОписаниеБлокировкиМета;
		Состояние("");
	КонецЕсли;
	Возврат ОписаниеБлокировкиМета;
	
КонецФункции

Процедура ЗагрузитьОбластиБлокировки(ТаблицаОбластейБлокировки, ОписаниеБлокировки, ОписаниеБлокировкиМета)
	
	ТаблицаОбластейБлокировки.Очистить();
	RegExpЭлементов = мПлатформа.RegExp;
	RegExpЭлементов.Global = Истина;
	RegExpЭлементов.Pattern = ШаблонЭлемента;
	RegExpОбластей = мПлатформа.RegExp2;
	RegExpОбластей.Global = Истина;
	RegExpОбластей.Pattern = ШаблонОбласти;
	ВхожденияЭлементов = RegExpЭлементов.Execute(ОписаниеБлокировки);
	ВхожденияЭлементовМета = RegExpЭлементов.Execute(ОписаниеБлокировкиМета);
	ИндикаторПространств = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВхожденияЭлементов.Count, "Пространства");
	Для ИндексЭлемента = 0 По ВхожденияЭлементов.Count - 1 Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторПространств);
		ВхождениеЭлемента = ВхожденияЭлементов.Item(ИндексЭлемента);
		ВхождениеЭлементаМета = ВхожденияЭлементовМета.Item(ИндексЭлемента);
		Пространство = ВхождениеЭлемента.SubMatches(0);
		ПространствоМета = ВхождениеЭлементаМета.SubMatches(0);
		ТипБлокировки = ВхождениеЭлемента.SubMatches(1);
		ВхожденияОбластей = RegExpОбластей.Execute(ВхождениеЭлемента.SubMatches(2));
		ВхожденияОбластейМета = RegExpОбластей.Execute(ВхождениеЭлементаМета.SubMatches(2));
		ИндикаторОбласти = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВхожденияОбластей.Count, "Области");
		Для ИндексОбласти = 0 По ВхожденияОбластей.Count - 1 Цикл
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторОбласти);
			ВхождениеОбласти = ВхожденияОбластей.Item(ИндексОбласти);
			ВхождениеОбластиМета = ВхожденияОбластейМета.Item(ИндексОбласти);
			СтрокаОбластиБлокировки = ТаблицаОбластейБлокировки.Добавить();
			СтрокаОбластиБлокировки.Пространство = Пространство;
			СтрокаОбластиБлокировки.ПространствоМета = ПространствоМета;
			СтрокаОбластиБлокировки.ТипБлокировки = ТипБлокировки;
			СтрокаОбластиБлокировки.Область = СокрЛП(ВхождениеОбласти.SubMatches(0));
			СтрокаОбластиБлокировки.ОбластьМета = СокрЛП(ВхождениеОбластиМета.SubMatches(0));
		КонецЦикла; 
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ТаблицаОбластейБлокировки.Сортировать("ПространствоМета, ТипБлокировки, Область");

КонецПроцедуры

Процедура ЗагрузитьПоляЭлементаБлокировки(ТаблицаПолейЭлементаБлокировки, ОписаниеПолей, ОписаниеПолейМета)
    
	ТаблицаПолейЭлементаБлокировки.Очистить();
	RegExp = мПлатформа.RegExp;
	RegExp.Global = Истина;
	// ШаблонПоля = "(\w+)=(?:(\d+\:\w+)|(\d+)|T""(\d+)""|(\w+)|(""""""\w*"""""")|(\[(?:(\d+)|T""(\d+)""|(\+))\:(?:(\d+)|T""(\d+)""|(\+))\]))"; // Справочно
	RegExp.Pattern = ШаблонПоля;
	Вхождения = RegExp.Execute(ОписаниеПолей);
	ВхожденияМета = RegExp.Execute(ОписаниеПолейМета);
	Для ИндексЭлемента = 0 По Вхождения.Count - 1 Цикл
		Вхождение = Вхождения.Item(ИндексЭлемента);
		ВхождениеМета = ВхожденияМета.Item(ИндексЭлемента);
		СтрокаПоля = ТаблицаПолейЭлементаБлокировки.Добавить();
		СтрокаПоля.Поле = Вхождение.SubMatches(0);
		СтрокаПоля.ПолеМета = ВхождениеМета.SubMatches(0);
		Если Вхождение.SubMatches(1) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(1);
			СтрокаПоля.Значение = ирОбщий.ПреобразоватьЗначениеИзSDBLЛкс(СтрокаПоля.ЗначениеSDBL, мПлатформа.ЧужаяСхемаБД <> Неопределено);
			Если ТипЗнч(СтрокаПоля.Значение) <> Тип("Строка") Тогда
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
			КонецЕсли; 
		ИначеЕсли Вхождение.SubMatches(2) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(2);
			СтрокаПоля.Значение = Число(СтрокаПоля.ЗначениеSDBL);
			СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
		ИначеЕсли Вхождение.SubMatches(3) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(3);
			СтрокаПоля.Значение = Дата(СтрокаПоля.ЗначениеSDBL);
			СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
		ИначеЕсли Вхождение.SubMatches(4) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(4);
			//СтрокаПоля.Значение = Вычислить(СтрокаПоля.ЗначениеSDBL);
			СтрокаПоля.Значение = "<" + СтрокаПоля.ЗначениеSDBL + ">";
		ИначеЕсли Вхождение.SubMatches(5) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(5);
			Попытка
				ЗначениеСтроки = Вычислить(СтрокаПоля.ЗначениеSDBL);
			Исключение
				Сообщить("Ошибка преобразования строкового значения из SDBL строки " + СтрокаПоля.ЗначениеSDBL);
			КонецПопытки; 
			СтрокаПоля.Значение = ЗначениеСтроки;
			СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
		ИначеЕсли Вхождение.SubMatches(6) <> Неопределено Тогда
			// Диапазон
			Если Вхождение.SubMatches(7) <> Неопределено Тогда
				СтрокаПоля.ЗначениеС = Число(Вхождение.SubMatches(7));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеС);
			ИначеЕсли Вхождение.SubMatches(8) <> Неопределено Тогда
				СтрокаПоля.ЗначениеС = Дата(Вхождение.SubMatches(8));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеС);
			Иначе
				СтрокаПоля.ЗначениеC = "<+>";
			КонецЕсли; 
			Если Вхождение.SubMatches(10) <> Неопределено Тогда
				СтрокаПоля.ЗначениеПо = Число(Вхождение.SubMatches(10));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеПо);
			ИначеЕсли Вхождение.SubMatches(11) <> Неопределено Тогда
				СтрокаПоля.ЗначениеПо = Дата(Вхождение.SubMatches(11));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеПо);
			Иначе
				СтрокаПоля.ЗначениеПо = "<+>";
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	ТаблицаПолейЭлементаБлокировки.Сортировать("ПолеМета");

КонецПроцедуры

Процедура БлокировавшиеСоединенияПриАктивизацииСтроки(Элемент)
	
	ВозможныеБлокираторы.Очистить();
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(Элемент.ТекущаяСтрока.Сеанс) Тогда
		ВременнныйПостроительЗапроса = Новый ПостроительЗапроса;
		ВременнныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЖурнала);
		#Если Сервер И Не Сервер Тогда
			ВременнныйПостроительЗапроса = Новый ПостроительЗапроса;
		#КонецЕсли
		ВременнныйПостроительЗапроса.Отбор.Добавить("Инфобаза").Установить(Инфобаза);
		ВременнныйПостроительЗапроса.Отбор.Добавить("Событие").Установить("SDBL");
		ВременнныйПостроительЗапроса.Отбор.Добавить("TCPСоединение").Установить(Элемент.ТекущаяСтрока.TCPСоединение);
		ЭлементОтбораМоментВремени = ВременнныйПостроительЗапроса.Отбор.Добавить("МоментВремени");
		ЭлементОтбораМоментВремени.Использование = Истина;
		ЭлементОтбораДействие = ВременнныйПостроительЗапроса.Отбор.Добавить("Действие");
		
		// Ищем начало транзакции
		ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.МеньшеИлиРавно; 
		ЭлементОтбораМоментВремени.Значение = МоментВремениНачала;
		ЭлементОтбораДействие.Установить("BeginTransaction");
		ВременнныйПостроительЗапроса.Порядок.Установить("МоментВремени Убыв");
		НайденныеНачала = ВременнныйПостроительЗапроса.Результат.Выгрузить();
		Если НайденныеНачала.Количество() > 0 Тогда
			Элемент.ТекущаяСтрока.НачалоТранзакции = НайденныеНачала[0].МоментВремени;
		Иначе
			ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.ИнтервалВключаяГраницы; 
			ЭлементОтбораМоментВремени.ЗначениеС = МоментВремениНачала;
			ЭлементОтбораМоментВремени.ЗначениеПо = МоментВремени;
			ВременнныйПостроительЗапроса.Порядок.Установить("МоментВремени Возр");
			НайденныеНачала = ВременнныйПостроительЗапроса.Результат.Выгрузить();
			Если НайденныеНачала.Количество() > 0 Тогда
				Элемент.ТекущаяСтрока.НачалоТранзакции = НайденныеНачала[0].МоментВремени;
			КонецЕсли; 
		КонецЕсли; 
		Если ЗначениеЗаполнено(Элемент.ТекущаяСтрока.НачалоТранзакции) Тогда
			Элемент.ТекущаяСтрока.Возраст = РазностьМоментовВремени(МоментВремениНачала, Элемент.ТекущаяСтрока.НачалоТранзакции) / 1000;
		КонецЕсли; 
		
		//// Ищем конец транзакции
		//ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.БольшеИлиРавно; 
		//ЭлементОтбораМоментВремени.Значение = МоментВремениНачала;
		//ЭлементОтбораДействие.ВидСравнения = ВидСравнения.ВСписке;
		//ЭлементОтбораДействие.Использование = Истина;
		//СписокДействий = Новый СписокЗначений;
		//СписокДействий.Добавить("CommitTransaction");
		//СписокДействий.Добавить("RollbackTransaction");
		//ЭлементОтбораДействие.Значение = СписокДействий;;
		//ВременнныйПостроительЗапроса.Порядок.Установить("МоментВремени Возр");
		//НайденныеКонцы = ВременнныйПостроительЗапроса.Результат.Выгрузить();
		//Если НайденныеКонцы.Количество() > 0 Тогда
		//	Элемент.ТекущаяСтрока.КонецТранзакции = НайденныеКонцы[0].МоментВремени;
		//КонецЕсли; 
	КонецЕсли;
	
	ВременнныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременнныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЖурнала);
	ВременнныйПостроительЗапроса.Отбор.Добавить("Инфобаза").Установить(Инфобаза);
	ВременнныйПостроительЗапроса.Отбор.Добавить("Событие").Установить("TLOCK");
	ВременнныйПостроительЗапроса.Отбор.Добавить("TCPСоединение").Установить(Элемент.ТекущаяСтрока.TCPСоединение);
	Если Найти(Пространства, ",") = 0 Тогда
		ЭлементОтбораПространства = ВременнныйПостроительЗапроса.Отбор.Добавить("Regions");
		ЭлементОтбораПространства.Установить(Пространства);
		ЭлементОтбораПространства.ВидСравнения = ВидСравнения.Содержит;
	КонецЕсли; 
	ВременнныйПостроительЗапроса.Порядок.Установить("МоментВремени Возр");
	ЭлементОтбораМоментВремени = ВременнныйПостроительЗапроса.Отбор.Добавить("МоментВремени");
	ЭлементОтбораМоментВремени.Использование = Истина;
	//Если Элемент.ТекущаяСтрока.Порядок = 1 Тогда
	//	МоментВремениКонцаБлокираторов = МоментВремениНачала;
	//Иначе
	//	МоментВремениКонцаБлокираторов = МоментВремени;
	//КонецЕсли; 
	//Если Истина
	//	И ЗначениеЗаполнено(Элемент.ТекущаяСтрока.КонецТранзакции) 
	//	И ЗначениеЗаполнено(Элемент.ТекущаяСтрока.НачалоТранзакции) 
	//Тогда
	//	ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.ИнтервалВключаяГраницы; 
	//	ЭлементОтбораМоментВремени.ЗначениеС = Элемент.ТекущаяСтрока.НачалоТранзакции;
	//	ЭлементОтбораМоментВремени.ЗначениеПо = Элемент.ТекущаяСтрока.КонецТранзакции;
	//Иначе
	Если ЗначениеЗаполнено(Элемент.ТекущаяСтрока.НачалоТранзакции) Тогда 
		ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.ИнтервалВключаяГраницы; 
		ЭлементОтбораМоментВремени.ЗначениеС = Элемент.ТекущаяСтрока.НачалоТранзакции;
		ЭлементОтбораМоментВремени.ЗначениеПо = МоментВремени;
	//ИначеЕсли ЗначениеЗаполнено(Элемент.ТекущаяСтрока.КонецТранзакции) Тогда 
	//	ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.МеньшеИлиРавно; 
	//	ЭлементОтбораМоментВремени.Значение = Элемент.ТекущаяСтрока.КонецТранзакции;
	Иначе
		ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.МеньшеИлиРавно; 
		ЭлементОтбораМоментВремени.Значение = МоментВремени;
	КонецЕсли; 
	лВозможныеБлокираторы = ВременнныйПостроительЗапроса.Результат.Выгрузить();
	Если лВозможныеБлокираторы.Количество() > 0 Тогда
		Для Каждого лВозможныйБлокиратор Из лВозможныеБлокираторы Цикл
			ЗаполнитьСвойстваСИменамиМетаданных(лВозможныйБлокиратор);
		КонецЦикла;
		ПоследнийВозможныйБлокиратор = лВозможныеБлокираторы[лВозможныеБлокираторы.Количество() - 1];
		Элемент.ТекущаяСтрока.Сеанс = ПоследнийВозможныйБлокиратор.Сеанс;
		Элемент.ТекущаяСтрока.Соединение = ПоследнийВозможныйБлокиратор.Соединение_;
		Элемент.ТекущаяСтрока.Пользователь = ПоследнийВозможныйБлокиратор.Пользователь;
		// На случай, если начала транзакции не нашли и номер соединения был использован разными сеансами
		ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(лВозможныеБлокираторы.Скопировать(Новый Структура("Сеанс", ПоследнийВозможныйБлокиратор.Сеанс)), ВозможныеБлокираторы);
		ЭтаФорма.КоличествоВозможныхБлокираторов = ВозможныеБлокираторы.Количество();
		RegExp = мПлатформа.RegExp;
		RegExp.Global = Истина;
		RegExp.Pattern = ШаблонОбласти;
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс("Вычисление количества областей");
		Для Каждого СтрокаБлокиратора Из ВозможныеБлокираторы Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			Вхождения = RegExp.Execute(СтрокаБлокиратора.Locks);
			СтрокаБлокиратора.Количество = Вхождения.Count;
			СтрокаБлокиратора.Возраст = РазностьМоментовВремени(МоментВремениНачала, СтрокаБлокиратора.МоментВремени) / 1000;
		КонецЦикла; 
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		ЭлементыФормы.ВозможныеБлокираторы.ТекущаяСтрока = ВозможныеБлокираторы[0];
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьНажатие(Элемент)
	
	ФормаСобытия = ПолучитьФорму("Событие", , МоментВремени);
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ТаблицаЖурналаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ФормаСобытия = ПолучитьФорму("Событие", , ВыбраннаяСтрока.МоментВремени);
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ТаблицаЖурналаПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	//Если Элемент.ТекущаяСтрока.LocksМета = РезультатПереводаСлишкомБольшогоТекста() Тогда
	//	Элемент.ТекущаяСтрока.LocksМета = ПеревестиТекстБДВТерминыМетаданных(Элемент.ТекущаяСтрока.Locks, , , ,, 0);
	//КонецЕсли; 
	ОписаниеБлокировкиМета = ПолучитьОписаниеБлокировкиМета(Элемент.ТекущаяСтрока);
	ЗагрузитьОбластиБлокировки(ОбластиБлокировкиБлокиратора, Элемент.ТекущаяСтрока.Locks, ОписаниеБлокировкиМета);
	
КонецПроцедуры

Процедура ОбластиБлокировкиБлокиратораПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПоляОбластиБлокировкиБлокиратора.Очистить();
	ЗагрузитьПоляЭлементаБлокировки(ПоляОбластиБлокировкиБлокиратора, Элемент.ТекущаяСтрока.Область, Элемент.ТекущаяСтрока.ОбластьМета);
	
КонецПроцедуры

Процедура ОбластиБлокировкиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЗагрузитьПоляЭлементаБлокировки(ПоляОбластиБлокировки, Элемент.ТекущаяСтрока.Область, Элемент.ТекущаяСтрока.ОбластьМета);
	
КонецПроцедуры

Процедура ПоляОбластиБлокировкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	Если Колонка.Имя = "Значение" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьЗначение(ВыбраннаяСтрока.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоляОбластиБлокировкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ЗначениеЗаполнено(ДанныеСтроки.ЗначениеSDBL) Тогда
		ОформлениеСтроки.Ячейки.ЗначениеС.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.ЗначениеПо.Видимость = Ложь;
	Иначе
		ОформлениеСтроки.Ячейки.Значение.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.ЗначениеSDBL.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанель1Сравнить(Кнопка)
	
	СравниваемыйДокумент1 = ирОбщий.ВывестиТабличноеПолеКоллекцииВТабличныйДокументЛкс(ЭлементыФормы.ОбластиБлокировки);
	СравниваемыйДокумент2 = ирОбщий.ВывестиТабличноеПолеКоллекцииВТабличныйДокументЛкс(ЭлементыФормы.ОбластиБлокировкиБлокиратора);
	ирОбщий.СравнитьЗначенияИнтерактивноЧерезXMLСтрокуЛкс(СравниваемыйДокумент1, СравниваемыйДокумент2, , "Заблокированный", "Блокиратор",, Ложь);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.БлокировкаУпр");
шИмя = "[" + мПлатформа.шБуква + "\d]+";
ШаблонПоля = "(" + шИмя + ")=(?:(\d+\:" + шИмя + ")|(-?\d+)|T""(\d+)""|(" + шИмя + ")|(""(?:(?:"""")*|[^""])*"")|(\[(?:(-?\d+)|T""(\d+)""|(\+))\:(?:(-?\d+)|T""(\d+)""|(\+))\]))";
ШаблонОбласти = "((?:\s+" + ШаблонПоля + ")+)\s*";
ШаблонЭлемента = "\s*(" + шИмя + "(?:\." + шИмя + ")+)\s+(" + шИмя + ")(" + ШаблонОбласти + "(,\s*" + ШаблонОбласти + ")*)?(?:,|$)";