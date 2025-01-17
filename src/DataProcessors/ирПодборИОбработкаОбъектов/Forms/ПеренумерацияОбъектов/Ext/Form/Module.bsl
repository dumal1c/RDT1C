﻿#Если Сервер И Не Сервер Тогда
	ПеренумерацияОбъектов();
#КонецЕсли
//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;
Перем мНастройка;
Перем мТаблицаКолонокРазныхТаблиц;
Перем мТипНомера;
Перем мДлинаНомера;
Перем мИмяОсновногоНомера;
Перем мСписокВыбораРеквизита;

// Определяет и устанавливает Тип и Длинну номера объекта
//
// Параметры:
//  Нет.
//
Процедура ЗаполнитьДоступныеРеквизиты(Отказ)
	
	Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	ОбъектПоиска = ЭтаФорма.ВладелецФормы.мИскомыйОбъект;
	мМетаОбъект = ОбъектПоиска.МетаОбъект;
	КорневойТип = ЭтаФорма.ВладелецФормы.мИскомыйОбъект.КорневойТип;
	Если КорневойТип = "ЖурналДокументов" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	мСписокВыбораРеквизита = ЭлементыФормы.ИзменяемыйРеквизит.СписокВыбора;
	Если ИмяСиноним Тогда
		ПредставлениеРеквизита = "Имя";
	Иначе
		ПредставлениеРеквизита = "Заголовок";
	КонецЕсли;
	Если Ложь
		Или КорневойТип = "Задача"
		Или КорневойТип = "Документ"
		Или КорневойТип = "БизнесПроцесс"
	Тогда
		мИмяОсновногоНомера = "Номер";
	Иначе
		мИмяОсновногоНомера = "Код";
	КонецЕсли;
	мТаблицаКолонокРазныхТаблиц = Новый ТаблицаЗначений();
	мТаблицаКолонокРазныхТаблиц.Колонки.Добавить("Имя");
	мТаблицаКолонокРазныхТаблиц.Колонки.Добавить("Тип");
	мТаблицаКолонокРазныхТаблиц.Колонки.Добавить("Длина");
	Если ТипЗнч(мМетаОбъект) = Тип("Массив") Тогда
		МетаОбъекты = мМетаОбъект;
	Иначе
		МетаОбъекты = Новый Массив;
		МетаОбъекты.Добавить(мМетаОбъект);
	КонецЕсли;
	Для Каждого МетаОбъект Из МетаОбъекты Цикл
		#Если Сервер И Не Сервер Тогда
			МетаОбъект = Метаданные.Справочники.Валюты;
		#КонецЕсли
		ИмяТаблицы = ирКэш.ИмяТаблицыИзМетаданныхЛкс(МетаОбъект.ПолноеИмя());
		ПоляТаблицыБД = ирОбщий.ПоляТаблицыБДЛкс(ИмяТаблицы);
		#Если Сервер И Не Сервер Тогда
			ПоляТаблицыБД = НайтиПоСсылкам().Колонки;
		#КонецЕсли
		Для Каждого СтрокаПоля Из ПоляТаблицыБД Цикл
			ДлинаТипа = 0;
			Если СтрокаПоля.ТипЗначения.Типы().Количество() = 1 Тогда
				Если Истина
					И СтрокаПоля.ТипЗначения.СодержитТип(Тип("Число")) 
					И СтрокаПоля.ТипЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти = 0 
				Тогда
					ДлинаТипа = СтрокаПоля.ТипЗначения.КвалификаторыЧисла.Разрядность;
					ТипКолонки = СтрокаПоля.ТипЗначения.Типы()[0];
				ИначеЕсли Истина
					И мИмяОсновногоНомера = СтрокаПоля.Имя
					И СтрокаПоля.ТипЗначения.СодержитТип(Тип("Строка")) 
				Тогда
					ДлинаТипа = СтрокаПоля.ТипЗначения.КвалификаторыСтроки.Длина;
					ТипКолонки = СтрокаПоля.ТипЗначения.Типы()[0];
				КонецЕсли; 
			КонецЕсли; 
			Если ДлинаТипа = 0 Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаКолонки = мТаблицаКолонокРазныхТаблиц.Добавить();
			СтрокаКолонки.Имя = СтрокаПоля.Имя;
			СтрокаКолонки.Тип = ТипКолонки;
			СтрокаКолонки.Длина = ДлинаТипа;
		КонецЦикла;
	КонецЦикла;
	ИменаКолонок = ирОбщий.РазличныеЗначенияКолонкиТаблицыЛкс(мТаблицаКолонокРазныхТаблиц, "Имя");
	Для Каждого ИмяКолонки Из ИменаКолонок Цикл
		СтрокиКолонки = мТаблицаКолонокРазныхТаблиц.Скопировать(Новый Структура("Имя", ИмяКолонки));
		Если СтрокиКолонки.Количество() < МетаОбъекты.Количество() Тогда
			Продолжить;
		КонецЕсли; 
		СтрокиКолонки.Свернуть("Тип, Длина");
		Если СтрокиКолонки.Количество() = 1 Тогда
			СтрокаКолонки = ПоляТаблицыБД.Найти(ИмяКолонки, "Имя");
			мСписокВыбораРеквизита.Добавить(СтрокаКолонки.Имя, СтрокаКолонки[ПредставлениеРеквизита]);
		КонецЕсли; 
	КонецЦикла;
	Отказ = мСписокВыбораРеквизита.Количество() = 0;
	Если Не Отказ Тогда
		Если мСписокВыбораРеквизита.НайтиПоЗначению(ИзменяемыйРеквизит) = Неопределено Тогда 
			ЭтаФорма.ИзменяемыйРеквизит = Неопределено;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
Функция вВыполнитьОбработку(Кнопка = Неопределено) Экспорт
	
	Если Ложь
		Или Кнопка = Неопределено
		Или Кнопка.Картинка <> ирКэш.КартинкаПоИмениЛкс("ирОстановить")
	Тогда
		Если мСписокВыбораРеквизита = Неопределено Тогда 
			Отказ = Ложь;
			ЗаполнитьДоступныеРеквизиты(Отказ);
			Если Отказ Или Не ЗначениеЗаполнено(ИзменяемыйРеквизит) Тогда
				Возврат 0;
			КонецЕсли;
		КонецЕсли;
		НеИзменятьЧисловуюНумерацию = НеИзменятьЧисловуюНумерацию И мТипНомера = Тип("Строка");
		Если СпособОбработкиПрефиксов = 1 И НеИзменятьЧисловуюНумерацию Тогда
			Возврат 0;
		КонецЕсли;
		Если НачальныйНомер = 0 И Не НеИзменятьЧисловуюНумерацию Тогда
			Предупреждение("Измените начальный номер!");
			Возврат 0;
		КонецЕсли;
		ВыбранноеПоле = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Выбор, ИзменяемыйРеквизит);
		ВыбранноеПоле.Использование = Истина;
		ИзменяемыйРеквизитПриИзменении();
	КонецЕсли; 
	БлокируемыеЭлементыФормы = Новый Массив;
	БлокируемыеЭлементыФормы.Добавить(ЭтаФорма.ВладелецФормы.Панель);
	БлокируемыеЭлементыФормы.Добавить(ЭтаФорма.ЭлементыФормы.ТекущаяНастройка);
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяОбработки", ирОбщий.ПоследнийФрагментЛкс(ирОбщий.ПолноеИмяФормыЛкс(ЭтаФорма)));
	НастройкаВыполнения = ЭтаФорма.ПолучитьНастройкуЛкс();
	НастройкаВыполнения = ПолучитьНастройкуЛкс();
	НастройкаВыполнения.Вставить("ТипНомера", мТипНомера);
	НастройкаВыполнения.Вставить("ДлинаНомера", мДлинаНомера);
	ПараметрыЗадания.Вставить("НастройкаОбработки", НастройкаВыполнения);
	СтруктураЗапроса = Новый Структура("Текст, Параметры");
	Если мЗапрос <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтруктураЗапроса, мЗапрос); 
	КонецЕсли; 
	ПараметрыЗадания.Вставить("Запрос", СтруктураЗапроса);
	#Если Сервер И Не Сервер Тогда
		ПеренумерацияОбъектов();
	#КонецЕсли
	РезультатЗадания = ирОбщий.ВыполнитьЗаданиеФормыЛкс("ПеренумерацияОбъектов", ПараметрыЗадания, ЭтаФорма, "Перенумерация",,
		Кнопка, "ВыполнитьОбработкуЗавершение",, БлокируемыеЭлементыФормы, Истина);

КонецФункции

Процедура ВыполнитьОбработкуЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ВернутьПараметрыПослеОбработки(РезультатЗадания, ВладелецФормы);
	КонецЕсли; 
КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирКлиент.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;
	СохранитьНастройкуОбработки(ЭтаФорма);

КонецПроцедуры

Функция ПолучитьНастройкуЛкс() Экспорт 
	
    НоваяНастройка = Новый Структура();
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;
	Возврат НоваяНастройка;

КонецФункции

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьНастройку() Экспорт

	Если Ложь
		Или ТекущаяНастройка = Неопределено
		Или ТекущаяНастройка.Родитель = Неопределено 
	Тогда
		вУстановитьИмяНастройки(мИмяНастройкиПоУмолчанию);
	Иначе
        Если НЕ ТекущаяНастройка.Настройка = Неопределено Тогда
			ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ТекущаяНастройка.Настройка, мНастройка);
		КонецЕсли;
	КонецЕсли;
	Для каждого РеквизитНастройки из мНастройка Цикл
        Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	КонецЦикла;
	ЗаполнитьДоступныеРеквизиты(Ложь);
	СпособОбработкиПрефиксовПриИзменении("");
	НеИзменятьЧисловуюНумерациюПриИзменении("");
	ИзменяемыйРеквизитПриИзменении();

КонецПроцедуры

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
Процедура вУстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ЭлементыФормы.ТекущаяНастройка.Значение = "";
		Иначе
			ЭлементыФормы.ТекущаяНастройка.Значение = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Значение = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Неуспех = Ложь;
	ЗаполнитьДоступныеРеквизиты(Отказ);
	Если Отказ Тогда
		Сообщить("Для этого типа объектов обработка неприменима");
		Возврат;
	КонецЕсли;
	Если мИспользоватьНастройки Тогда
		вУстановитьИмяНастройки();
		вЗагрузитьНастройку();
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Доступность = Ложь;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.СохранитьНастройку.Доступность = Ложь;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ИзменяемыйРеквизит) Тогда
		ЭтаФорма.ИзменяемыйРеквизит = мСписокВыбораРеквизита[0].Значение;
		ИзменяемыйРеквизитПриИзменении();
	КонецЕсли; 
	Если мСписокВыбораРеквизита.НайтиПоЗначению(ИзменяемыйРеквизит) = Неопределено Тогда 
		ЭтаФорма.ИзменяемыйРеквизит = Неопределено;
	КонецЕсли; 
	ЭлементыФормы.Шаг.СписокВыбора.Добавить(1);
	ЭлементыФормы.Шаг.СписокВыбора.Добавить(10);
	ЭлементыФормы.Шаг.СписокВыбора.Добавить(100);

КонецПроцедуры

// Обработчик действия "НачалоВыбораИзСписка" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	Элемент.СписокВыбора.Очистить();

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		КоллекцияСтрок = ТекущаяНастройка.Строки;
	Иначе
		КоллекцияСтрок = ТекущаяНастройка.Родитель.Строки;
	КонецЕсли;

	Для каждого Строка из КоллекцияСтрок Цикл
		Элемент.СписокВыбора.Добавить(Строка, Строка.Обработка);
	КонецЦикла;

КонецПроцедуры // ТекущаяНастройкаНачалоВыбораИзСписка()

// Обработчик действия "ОбработкаВыбора" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Истина
		И НЕ ТекущаяНастройка = ВыбранноеЗначение
		И Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено
	Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				вСохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		вУстановитьИмяНастройки();

		вЗагрузитьНастройку();

	КонецЕсли;

КонецПроцедуры // ТекущаяНастройкаОбработкаВыбора()

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	вВыполнитьОбработку(Кнопка);

КонецПроцедуры

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

// Обработчик события "ПриИзменении" элемена формы "НеИзменятьЧисловуюНумерацию"
//
Процедура НеИзменятьЧисловуюНумерациюПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.НачальныйНомер.Доступность = Не НеИзменятьЧисловуюНумерацию;
	ЭлементыФормы.Шаг.Доступность = Не НеИзменятьЧисловуюНумерацию;
	ЭлементыФормы.ПанельСтрока.Видимость = мТипНомера = Тип("Строка"); 
	ЭлементыФормы.НеИзменятьЧисловуюНумерацию.Видимость = мТипНомера = Тип("Строка");

КонецПроцедуры

// Обработчик события "ПриИзменении" элемена формы "СпособОбработкиПрефиксов"
//
Процедура СпособОбработкиПрефиксовПриИзменении(Элемент)

	Если СпособОбработкиПрефиксов = 1 Тогда 
		ЭлементыФормы.СтрокаПрефикса.Доступность      = Ложь;
		ЭлементыФормы.ЗаменяемаяПодстрока.Доступность = Ложь;
	ИначеЕсли СпособОбработкиПрефиксов = 5 Тогда 
		ЭлементыФормы.СтрокаПрефикса.Доступность      = Истина;
		ЭлементыФормы.ЗаменяемаяПодстрока.Доступность = Истина;
	Иначе
		ЭлементыФормы.СтрокаПрефикса.Доступность      = Истина;
		ЭлементыФормы.ЗаменяемаяПодстрока.Доступность = Ложь;
    КонецЕсли;

КонецПроцедуры

Процедура ИзменяемыйРеквизитПриИзменении(Элемент = Неопределено)
	
	Если ИзменяемыйРеквизит <> Неопределено Тогда
		ОписаниеКолонкиБД = мТаблицаКолонокРазныхТаблиц.Найти(ИзменяемыйРеквизит, "Имя");
		мДлинаНомера = ОписаниеКолонкиБД.Длина;
		мТипНомера = ОписаниеКолонкиБД.Тип;
	КонецЕсли; 
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		вСохранитьНастройку();
	КонецЕсли;

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ПеренумерацияОбъектов");
мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("НачальныйНомер,НеИзменятьЧисловуюНумерацию,СтрокаПрефикса,ЗаменяемаяПодстрока,СпособОбработкиПрефиксов,ИзменяемыйРеквизит,Шаг");
мНастройка.НачальныйНомер = 1;
мНастройка.НеИзменятьЧисловуюНумерацию = Ложь;
мНастройка.СпособОбработкиПрефиксов = 1;
мНастройка.Шаг = 1;
