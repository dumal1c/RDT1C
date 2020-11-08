﻿
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	СписокВыбора = ЭлементыФормы.ВнешнийИсточник.СписокВыбора;
	Для каждого ВнешнийИсточникМетаданные Из Метаданные.ВнешниеИсточникиДанных Цикл
		СписокВыбора.Добавить(ВнешнийИсточникМетаданные.Имя, ВнешнийИсточникМетаданные.Синоним);
	КонецЦикла;
	СписокВыбора.СортироватьПоПредставлению();
	СписокВыбора = ЭлементыФормы.СУБД.СписокВыбора;
	СписокВыбора.Добавить("MSSQLServer");
	СписокВыбора.Добавить("PostgreSQL");
	СписокВыбора.Добавить("IBMDB2");
	СписокВыбора.Добавить("OracleDatabase");
	СписокВыбора.Добавить("Прочее");
	ЭтаФорма.СУБД = "Прочее";
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыСохранитьПараметры(Кнопка)
	
	СохранитьПараметрыСоединения();
	
КонецПроцедуры

Процедура ДействияФормыПодключиться(Кнопка)
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		Возврат;
	КонецЕсли;
	ПодключитьсяКВнешнемуИсточникуСервер();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ДействияФормыОтключиться(Кнопка)
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОтключитьсяОтВнешнегоИсточникаСервер();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура СохранитьПараметрыСоединения()
	
	ПараметрыСоединенияТекущие = ПолучитьПараметрыСоединения();
	ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, "СУБД");
	ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, "АутентификацияСтандартная");
	ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, "ИмяПользователя");
	ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, "СтрокаСоединения");
	Если ПарольИзменен Тогда
		ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, "Пароль");
	КонецЕсли;
	Если ТипПараметровТекущий = 0 Тогда
		ВнешниеИсточникиДанных[ВнешнийИсточникТекущий].УстановитьОбщиеПараметрыСоединения(ПараметрыСоединенияТекущие);
	ИначеЕсли ТипПараметровТекущий = 1 Тогда
		ВнешниеИсточникиДанных[ВнешнийИсточникТекущий].УстановитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь(), ПараметрыСоединенияТекущие);
	Иначе
		ВнешниеИсточникиДанных[ВнешнийИсточникТекущий].УстановитьПараметрыСоединенияСеанса(ПараметрыСоединенияТекущие);
	КонецЕсли;
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, ИмяПараметра)
	
	Если ЭтаФорма[ИмяПараметра + "Использование"] Тогда
		
		ЗначениеПараметра = ЭтаФорма[ИмяПараметра];
		
		Если ИмяПараметра = "СУБД"
			И ЗначениеПараметра = "Прочее" Тогда
			
			ЗначениеПараметра = "";
			
		КонецЕсли;
		
		ПараметрыСоединенияТекущие[ИмяПараметра] = ЗначениеПараметра;
		
	Иначе
		
		ПараметрыСоединенияТекущие[ИмяПараметра] = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьсяКВнешнемуИсточникуСервер()
	
	СтароеСостояние = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьСостояние();
	Если СтароеСостояние = СостояниеВнешнегоИсточникаДанных.Подключен Тогда
		ИсточникПодключен = Истина;
		Возврат;
	КонецЕсли;
	Попытка
		ВнешниеИсточникиДанных[ВнешнийИсточник].УстановитьСоединение();
		ИсточникПодключен = Истина;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = "Не удалось установить соединение. Описание ошибки:" + Символы.ПС + ИнформацияОбОшибке.Причина.Описание;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтключитьсяОтВнешнегоИсточникаСервер()
	
	СтароеСостояние = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьСостояние();
	
	Если СтароеСостояние = СостояниеВнешнегоИсточникаДанных.Отключен Тогда
		
		ИсточникПодключен = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		ВнешниеИсточникиДанных[ВнешнийИсточник].РазорватьСоединение();
		ИсточникПодключен = Ложь;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = "Не удалось разорвать соединение. Описание ошибки:" + Символы.ПС + ИнформацияОбОшибке.Причина.Описание;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ИспользованиеПриИзменении(Элемент)
	
	СУБДИспользование						= Использование;
	АутентификацияСтандартнаяИспользование	= Использование;
	ИмяПользователяИспользование			= Использование;
	ПарольИспользование						= Использование;
	СтрокаСоединенияИспользование			= Использование;
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ВнешнийИсточникПриИзменении(Элемент)
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		ЭтаФорма.ВнешнийИсточник = ВнешнийИсточникТекущий;
		Возврат;
	КонецЕсли;
	ЭтаФорма.ВнешнийИсточникТекущий = ВнешнийИсточник;
	Модифицированность = Ложь;
	ПолучитьИнформациюОСоединении();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ТипПараметровПриИзменении(Элемент)
	
	ПриИзмененииТипаПараметров();
	
КонецПроцедуры

Процедура ТипПараметров1ПриИзменении(Элемент)
	
	ПриИзмененииТипаПараметров();
	
КонецПроцедуры

Процедура ТипПараметров2ПриИзменении(Элемент)
	
	ПриИзмененииТипаПараметров();
	
КонецПроцедуры

Процедура СУБДИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура АутентификацияСтандартнаяИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ИмяПользователяИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ПарольИспользованиеПриИзменении(Элемент)
	
	ПарольИзменен = Истина;
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура СтрокаСоединенияИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ПарольПриИзменении(Элемент)
	
	ПарольИзменен = Истина;
	
КонецПроцедуры

Процедура ПолучитьИнформациюОСоединении()
	
	ПараметрыСоединенияТекущие = ПолучитьПараметрыСоединения();
	Если ПустаяСтрока(ВнешнийИсточник) Тогда
		ИсточникПодключен = Ложь;
	Иначе
		СтароеСостояние = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьСостояние();
		Если СтароеСостояние = СостояниеВнешнегоИсточникаДанных.Подключен Тогда
			ИсточникПодключен = Истина;
		Иначе
			ИсточникПодключен = Ложь;
		КонецЕсли;
	КонецЕсли;
	ПарольИзменен = Ложь;
	Использование = Ложь;
	Пароль = "";
	ПарольИспользование = Ложь;
	ПараметрВЭлементФормы(ПараметрыСоединенияТекущие, "СУБД");
	ПараметрВЭлементФормы(ПараметрыСоединенияТекущие, "АутентификацияСтандартная");
	ПараметрВЭлементФормы(ПараметрыСоединенияТекущие, "ИмяПользователя");
	ПараметрВЭлементФормы(ПараметрыСоединенияТекущие, "СтрокаСоединения");
	Если ПараметрыСоединенияТекущие.ПарольУстановлен Тогда
		ПарольИспользование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПараметрыСоединения()
	
	Если ПустаяСтрока(ВнешнийИсточник) Тогда
		ПараметрыСоединенияТекущие = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	Иначе
		Если ТипПараметров = 0 Тогда
			ПараметрыСоединенияТекущие = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьОбщиеПараметрыСоединения();
		ИначеЕсли ТипПараметров = 1 Тогда
			ПараметрыСоединенияТекущие = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь());
		Иначе
			ПараметрыСоединенияТекущие = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьПараметрыСоединенияСеанса();
		КонецЕсли;
	КонецЕсли;
	Возврат ПараметрыСоединенияТекущие;
	
КонецФункции

Процедура ПараметрВЭлементФормы(ПараметрыСоединенияТекущие, ИмяПараметра)
	
	ЭтаФорма[ИмяПараметра] = ПараметрыСоединенияТекущие[ИмяПараметра];
	Если ИмяПараметра = "СУБД" И ЭтаФорма[ИмяПараметра] = "" Тогда
		ЭтаФорма[ИмяПараметра] = "Прочее";
	КонецЕсли;
	Если ПараметрыСоединенияТекущие[ИмяПараметра] = Неопределено Тогда
		ЭтаФорма[ИмяПараметра + "Использование"] = Ложь;
	Иначе
		ЭтаФорма[ИмяПараметра + "Использование"] = Истина;
		Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииТипаПараметров()
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		
		ТипПараметров = ТипПараметровТекущий;
		Возврат;
		
	КонецЕсли;
	
	ТипПараметровТекущий = ТипПараметров;
	
	Модифицированность = Ложь;
	ПолучитьИнформациюОСоединении();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ОбновитьВидимостьДоступность()
	
	ИсточникВыбран = Не ПустаяСтрока(ВнешнийИсточник);
	ЭлементыФормы.ДействияФормы.Доступность = ИсточникВыбран;
	ЭлементыФормы.Использование.Доступность								= ИсточникВыбран;
	ЭлементыФормы.СУБДИспользование.Доступность							= ИсточникВыбран;
	ЭлементыФормы.АутентификацияСтандартнаяИспользование.Доступность	= ИсточникВыбран;
	ЭлементыФормы.ИмяПользователяИспользование.Доступность				= ИсточникВыбран;
	ЭлементыФормы.ПарольИспользование.Доступность						= ИсточникВыбран;
	ЭлементыФормы.СтрокаСоединенияИспользование.Доступность				= ИсточникВыбран;
	ЭлементыФормы.СУБД.ТолькоПросмотр						= Не СУБДИспользование;
	ЭлементыФормы.АутентификацияСтандартная.Доступность		= АутентификацияСтандартнаяИспользование;
	ЭлементыФормы.ИмяПользователя.ТолькоПросмотр			= Не ИмяПользователяИспользование;
	ЭлементыФормы.Пароль.ТолькоПросмотр						= Не ПарольИспользование;
	ЭлементыФормы.СтрокаСоединения.ТолькоПросмотр			= Не СтрокаСоединенияИспользование;
	Если ИсточникПодключен Тогда
		ЭлементыФормы.ИсточникПодключен.ЦветТекста = WebЦвета.Синий;
	Иначе
		ЭлементыФормы.ИсточникПодключен.ЦветТекста = WebЦвета.Красный;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьИзменениеПараметров()
	
	Если Не Модифицированность Тогда
		Возврат Истина;
	КонецЕсли;
	Ответ = Вопрос("Параметры подключения были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена, 60);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьПараметрыСоединения();
		Возврат Истина;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтрокаСоединенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСтрокиСоединенияADODBНачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СУБДПриИзменении(Элемент)
	
	Если Истина
		И Элемент.Значение = "MSSQLServer"
		И Не ЗначениеЗаполнено(СтрокаСоединения) 
	Тогда
		СтрокаСоединения = "Driver={SQL Server}; Server=<ServerName>; DataBase=<DBName>;";
	КонецЕсли;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПодключениеВнешнихИсточниковДанных");
