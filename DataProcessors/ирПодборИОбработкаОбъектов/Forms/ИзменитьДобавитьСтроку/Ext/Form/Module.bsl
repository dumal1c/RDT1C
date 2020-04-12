﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
Перем мТипыОбрабатываемыхОбъектов Экспорт;
Перем мПоляТаблицыБД Экспорт;
Перем мИменаПредставления;
Перем мНастройка;
Перем мОбъектМД;
Перем мИмяТаблицы;

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	//Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
	//	Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	//КонецЕсли;
	Если ЭлементыФормы.ТекущаяНастройка.Значение = мИмяНастройкиПоУмолчанию Или Не ЗначениеЗаполнено(ЭлементыФормы.ТекущаяНастройка.Значение) Тогда
		АвтоИмяНастройки = "";
		Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
			Если АвтоИмяНастройки <> "" Тогда
				АвтоИмяНастройки = АвтоИмяНастройки + ", ";
			КонецЕсли;
			АвтоИмяНастройки = АвтоИмяНастройки + СтрокаРеквизита.Синоним + " = " + СтрокаРеквизита.Значение;
		КонецЦикла;
		Если ЗначениеЗаполнено(АвтоИмяНастройки) Тогда
			вУстановитьИмяНастройки(АвтоИмяНастройки);
		КонецЕсли; 
	КонецЕсли; 
    НоваяНастройка = ПолучитьНастройкуЛкс();
	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		НоваяСтрока = ТекущаяНастройка.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
	ИначеЕсли НЕ ТекущаяНастройка.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение Тогда
		НоваяСтрока           = ТекущаяНастройка.Родитель.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка      = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	ТекущаяНастройка.Настройка = НоваяНастройка;
	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры

Функция ПолучитьНастройкуЛкс()
	
	НоваяНастройка = Новый Структура();
	РеквизитыДляСохранения = ЗначенияРеквизитов.Выгрузить(Новый Структура("Пометка", Истина));
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;
	Возврат НоваяНастройка;

КонецФункции // вСохранитьНастройку()

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
		Если ТекущаяНастройка.Настройка <> Неопределено Тогда
			ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ТекущаяНастройка.Настройка, мНастройка);
		КонецЕсли;
	КонецЕсли;

	ЗначенияРеквизитов.Очистить();
	Для каждого РеквизитНастройки из мНастройка Цикл
		Значение = мНастройка[РеквизитНастройки.Ключ];
		Если НЕ Значение = Неопределено Тогда
			Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
		КонецЕсли;
	КонецЦикла;

	Если РеквизитыДляСохранения.Количество() > 0 Тогда
		ЗначенияРеквизитов.Загрузить(РеквизитыДляСохранения);
	КонецЕсли;
	ОбновитьТаблицуРеквизитов();
	
КонецПроцедуры //вЗагрузитьНастройку()

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

// Позволяет создать описание типов на основании строкового представления типа.
//
// Параметры: 
//  ТипСтрокой     - Строковое представление типа.
//
// Возвращаемое значение:
//  Описание типов.
//
Функция вОписаниеТипа(ТипСтрокой) Экспорт

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ТипСтрокой));
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);

	Возврат ОписаниеТипов;

КонецФункции // вОписаниеТипа()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Если мИспользоватьНастройки Тогда
		вУстановитьИмяНастройки();
		вЗагрузитьНастройку();
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Доступность = Ложь;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.СохранитьНастройку.Доступность = Ложь;
		ОбновитьТаблицуРеквизитов();
	КонецЕсли;
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.Использование.Видимость = Истина
		И мОбъектМД <> Неопределено
		И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(мОбъектМД);
	ОбновитьКолонки();
	
	ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(ОбластьПоиска);
	ЭлементыФормы.КоманднаяПанельРеквизиты.Кнопки.ЗагрузитьИзОбъекта.Доступность = Ложь
		Или ТипТаблицы = "ТабличнаяЧасть"
		Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицы)
		Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы);

КонецПроцедуры // ПередОткрытием()

Процедура ОбновитьТаблицуРеквизитов()

	Если ВладелецФормы <> Неопределено Тогда
		ИскомыйОбъект = ВладелецФормы.мИскомыйОбъект;
	КонецЕсли; 
	мИмяТаблицы = "";
	ОписаниеТиповОбъекта = ПолучитьОписаниеТиповОбрабатываемогоЭлементаИлиОбъекта(ИскомыйОбъект,, мИмяТаблицы);
	Типы = ОписаниеТиповОбъекта.Типы();
	Если Типы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	мОбъектМД = Метаданные.НайтиПоТипу(Типы[0]);
	Если Не ЗначениеЗаполнено(мИмяТаблицы) Тогда
		мИмяТаблицы = ирОбщий.ИмяТаблицыИзМетаданныхЛкс(мОбъектМД);
	КонецЕсли; 
	СписокВыбораТЧ = ЭлементыФормы.ИмяТабличнойЧасти.СписокВыбора;
	СписокВыбораТЧ.Очистить();
	ТабличныеЧастиОбъекта = ирОбщий.ТабличныеЧастиОбъектаЛкс(мОбъектМД);
	Для Каждого КлючИЗначение Из ТабличныеЧастиОбъекта Цикл
		СписокВыбораТЧ.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	Если СписокВыбораТЧ.НайтиПоЗначению(ИмяТабличнойЧасти) = Неопределено Тогда
		ЭтаФорма.ИмяТабличнойЧасти = "";
	КонецЕсли; 
	Если ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		мИмяТаблицы = мИмяТаблицы + "." + ИмяТабличнойЧасти;
	КонецЕсли; 
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.КлючПоиска.ТолькоПросмотр = Не ЗначениеЗаполнено(ИмяТабличнойЧасти); 
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.КлючПоиска.Видимость = ЗначениеЗаполнено(ИмяТабличнойЧасти); 
	ЭлементыФормы.ОбрабатыватьСуществующую.Доступность = ЗначениеЗаполнено(ИмяТабличнойЧасти);
	
	СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(мИмяТаблицы);
	мПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(мИмяТаблицы);
	#Если Сервер И Не Сервер Тогда
		мПоляТаблицыБД = НайтиПоСсылкам().Колонки;
	#КонецЕсли
	Для Каждого ПолеТаблицыБД Из мПоляТаблицыБД Цикл
		Если ПолеТаблицыБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			Продолжить;
		КонецЕсли;
		Если СтруктураКлюча.Свойство(ПолеТаблицыБД.Имя) Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаРеквизита = ЗначенияРеквизитов.Найти(ПолеТаблицыБД.Имя, "Идентификатор");
		Если СтрокаРеквизита = Неопределено Тогда
			СтрокаРеквизита = ЗначенияРеквизитов.Добавить();
			СтрокаРеквизита.Идентификатор = ПолеТаблицыБД.Имя;
			СтрокаРеквизита.Значение = ПолеТаблицыБД.ТипЗначения.ПривестиЗначение();
			СтрокаРеквизита.ТипИзменения = "УстановитьЗначение";
		КонецЕсли; 
		СтрокаРеквизита.Синоним = ПолеТаблицыБД.Заголовок;
		Если ирОбщий.ЛиКорневойТипКонстантыЛкс(ИскомыйОбъект.ТипТаблицы) Тогда
			СтрокаРеквизита.Синоним = "Значение";
		КонецЕсли; 
		СтрокаРеквизита.Использование = ирОбщий.ПеревестиВРусский(Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппыИЭлемента);
		Если мОбъектМД <> Неопределено И Не ЗначениеЗаполнено(ИмяТабличнойЧасти)  Тогда
			Если ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(мОбъектМД) Тогда
				МетаРеквизит = мОбъектМД.Реквизиты.Найти(СтрокаРеквизита.Идентификатор);
				//Если МетаРеквизит = Неопределено Тогда
				//	МетаРеквизит = Метаданные.ОбщиеРеквизиты.Найти(СтрокаРеквизита.Идентификатор);
				//КонецЕсли;
				Если МетаРеквизит <> Неопределено Тогда
					СтрокаРеквизита.Использование = ирОбщий.ПеревестиВРусский(МетаРеквизит.Использование);
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
		МетаРеквизит = ПолеТаблицыБД.Метаданные;
		Если МетаРеквизит <> Неопределено Тогда
			СтрокаРеквизита.СвязиПараметровВыбора = ирОбщий.ПредставлениеСвязейПараметровВыбораЛкс(МетаРеквизит.СвязиПараметровВыбора);
		КонецЕсли;
	КонецЦикла;
	МассивКУдалению = Новый Массив();
	Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
		ПолеТаблицыБД = мПоляТаблицыБД.Найти(СтрокаРеквизита.Идентификатор, "Имя");
		Если ПолеТаблицыБД <> Неопределено Тогда
			Если СтруктураКлюча.Свойство(ПолеТаблицыБД.Имя) Тогда
				ПолеТаблицыБД = Неопределено;
			КонецЕсли;
		КонецЕсли; 
		СтрокаРеквизита.Сопоставлен = ПолеТаблицыБД <> Неопределено;
		Если Не СтрокаРеквизита.Сопоставлен Тогда
			СтрокаРеквизита.Использование = "ОтсутствуетВДанных";
		КонецЕсли; 
		Если Не СтрокаРеквизита.Сопоставлен Тогда
			СтрокаРеквизита.Пометка = Ложь;
		КонецЕсли; 
		ОбновитьТипЗначенияВСтрокеТаблицы(СтрокаРеквизита);
	КонецЦикла;
	Если Истина
		И ирКэш.НомерВерсииБСПЛкс() > 200 
		И Не ирКэш.ЛиПортативныйРежимЛкс()
		И ирОбщий.ЛиСсылочныйОбъектМетаданных(мОбъектМД, Ложь) 
		И Метаданные.ОбщиеМодули.Найти("УправлениеСвойствами") <> Неопределено 
		И мОбъектМД.ТабличныеЧасти.Найти("ДополнительныеРеквизиты") <> Неопределено
		И Метаданные.ОпределяемыеТипы.ВладелецДополнительныхСведений.Тип.СодержитТип(ТипЗнч(НайденныеОбъекты[0].Ссылка)) 
	Тогда
		СписокСвойств = ирСервер.СписокДопСвойствОбъектаБСПЛкс(НайденныеОбъекты[0].Ссылка);
		Для Каждого Свойство Из СписокСвойств Цикл
			#Если Сервер И Не Сервер Тогда
				Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПустаяСсылка();
			#КонецЕсли
			СтрокаРеквизита = ЗначенияРеквизитов.Добавить();
			СтрокаРеквизита.ТипЗначения = Свойство.ТипЗначения;
			СтрокаРеквизита.Значение = Свойство.ТипЗначения.ПривестиЗначение();
			СтрокаРеквизита.ТипИзменения = "УстановитьЗначение";
			СтрокаРеквизита.Синоним = Свойство.Наименование;
			СтрокаРеквизита.Использование = ирОбщий.ПеревестиВРусский(Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппыИЭлемента);
			СтрокаРеквизита.Сопоставлен = Истина;
			СтрокаРеквизита.ДопРеквизит = Свойство;
		КонецЦикла;
	КонецЕсли; 
	ЗначенияРеквизитов.Сортировать("Сопоставлен Убыв, " + ПолучитьИмяКолонкиПредставления());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

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

	вВыполнитьОбработку();

КонецПроцедуры

Процедура вВыполнитьОбработку() Экспорт 
	
	Если РежимОбходаДанных = "Строки" И Не ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		Для каждого СтрокаРеквизита из ЗначенияРеквизитов Цикл
			Если Истина
				И СтрокаРеквизита.Пометка 
				И НайденныеОбъекты.Колонки.Найти(СтрокаРеквизита.Идентификатор) = Неопределено
			Тогда
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ЭтаФорма.ВладелецФормы.Компоновщик.Настройки.Выбор, СтрокаРеквизита.Идентификатор);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	ОбщиеПараметрыОбработки = ОбщиеПараметрыОбработки();
	ирОбщий.ПодборИОбработкаОбъектов_ВыполнитьОбработкуЛкс("ИзменитьДобавитьСтроку", ОбщиеПараметрыОбработки, ПолучитьНастройкуЛкс(),, ЭтаФорма);
	ВернутьПараметрыПослеОбработки(ОбщиеПараметрыОбработки);

КонецПроцедуры // ОсновныеДействияФормыВыполнить()

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

// Обработчик действия "НачалоВыбора" поля ввода "Значение" табличного поля "Реквизиты".
//
Процедура РеквизитыЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)

	ТипыФильтра = ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Тип;
	МассивТипов = ТипыФильтра.Типы();
	Если МассивТипов.Количество() = 1 Тогда
		Элемент.ВыбиратьТип = Ложь;
	Иначе
		Элемент.ОграничениеТипа = ТипыФильтра;
		Элемент.ВыбиратьТип = Истина;
	КонецЕсли;

КонецПроцедуры // РеквизитыЗначениеНачалоВыбора()

// Обработчик действия "ОбработкаВыбора" поля ввода "Значение" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ЭлементыФормы.ЗначенияРеквизитов.ТекущиеДанные.Пометка = Истина;

КонецПроцедуры // РеквизитыЗначениеОбработкаВыбора()

// Обработчик действия "ОкончаниеВводаТекста" поля ввода "Значение" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)

	ЭлементыФормы.ЗначенияРеквизитов.ТекущиеДанные.Пометка = Истина;

КонецПроцедуры

Функция ПолучитьОписаниеТиповРеквизита(СтрокаРеквизита)
	
	ПолеТаблицыБД = мПоляТаблицыБД.Найти(СтрокаРеквизита.Идентификатор, "Имя");
	Если ПолеТаблицыБД <> Неопределено Тогда
		Возврат ПолеТаблицыБД.ТипЗначения;
	КонецЕсли; 
	Возврат Новый ОписаниеТипов();
	
КонецФункции

// Обработчик действия "ПриНачалеРедактирования" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	#Если Сервер И Не Сервер Тогда
		Элемент = ЭлементыФормы.ЗначенияРеквизитов;
	#КонецЕсли
	ОписаниеТиповРеквизита = ПолучитьОписаниеТиповРеквизита(Элемент.ТекущаяСтрока);
	#Если Сервер И Не Сервер Тогда
	    ОписаниеТиповРеквизита = Новый ОписаниеТипов;
	#КонецЕсли
	Элемент.Колонки.ТипИзменения.ЭлементУправления.Доступность = Ложь
		Или ОписаниеТиповРеквизита.СодержитТип(Тип("Дата"))
		Или ОписаниеТиповРеквизита.СодержитТип(Тип("Булево"))
		Или (Истина
			И ОписаниеТиповРеквизита.СодержитТип(Тип("Число")) 
			И ОписаниеТиповРеквизита.КвалификаторыЧисла.РазрядностьДробнойЧасти > 0);
	КвалификаторыЧисла = ОписаниеТиповРеквизита.КвалификаторыЧисла;
	Если Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьВремя" Тогда 
		ОписаниеТипов = Новый ОписаниеТипов("Дата",,,,, Новый КвалификаторыДаты(ЧастиДаты.Время));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьДату" Тогда
		ОписаниеТипов = Новый ОписаниеТипов("Дата",,,,, Новый КвалификаторыДаты(ЧастиДаты.Дата));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьДробнуюЧасть" Тогда 
		ОписаниеТипов = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(0, КвалификаторыЧисла.РазрядностьДробнойЧасти, ДопустимыйЗнак.Неотрицательный));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьЦелуюЧасть" Тогда
		ОписаниеТипов = Новый ОписаниеТипов("Число",,, 
			Новый КвалификаторыЧисла(КвалификаторыЧисла.Разрядность - КвалификаторыЧисла.РазрядностьДробнойЧасти, 0, КвалификаторыЧисла.ДопустимыйЗнак));
	ИначеЕсли Элемент.ТекущаяСтрока.ТипИзменения = "УстановитьЗначение" Тогда
		ОписаниеТипов = ОписаниеТиповРеквизита;
	КонецЕсли;
	Если ОписаниеТипов <> Неопределено Тогда
		Элемент.Колонки.Значение.ЭлементУправления.ОграничениеТипа = ОписаниеТипов;
		Элемент.ТекущаяСтрока.Значение = ОписаниеТипов.ПривестиЗначение(Элемент.ТекущаяСтрока.Значение);
	КонецЕсли; 
	СписокВыбораТипаИзменения = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ТипИзменения.ЭлементУправления.СписокВыбора;
	#Если Сервер И Не Сервер Тогда
	    СписокВыбораТипаИзменения = Новый СписокЗначений;
	#КонецЕсли
	СписокВыбораТипаИзменения.Очистить();
	Если ОписаниеТиповРеквизита.СодержитТип(Тип("Дата")) Тогда
		СписокВыбораТипаИзменения.Добавить("УстановитьЗначение", "Установить значение");
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты = ЧастиДаты.ДатаВремя Тогда
			СписокВыбораТипаИзменения.Добавить("УстановитьВремя", "Установить только время");
			СписокВыбораТипаИзменения.Добавить("УстановитьДату", "Установить только дату");
		КонецЕсли; 
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты <> ЧастиДаты.Дата Тогда
			СписокВыбораТипаИзменения.Добавить("СдвинутьВКонецДня", "Сдвинуть в конец дня");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВНачалоДня", "Сдвинуть в начало дня");
		КонецЕсли; 
		Если ОписаниеТиповРеквизита.КвалификаторыДаты.ЧастиДаты <> ЧастиДаты.Время Тогда
			СписокВыбораТипаИзменения.Добавить("СдвинутьВКонецМесяца", "Сдвинуть в конец месяца");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВНачалоМесяца", "Сдвинуть в начало месяца");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВКонецГода", "Сдвинуть в конец года");
			СписокВыбораТипаИзменения.Добавить("СдвинутьВНачалоГода", "Сдвинуть в начало года");
		КонецЕсли;
	ИначеЕсли ОписаниеТиповРеквизита.СодержитТип(Тип("Булево")) Тогда
		СписокВыбораТипаИзменения.Добавить("УстановитьЗначение", "Установить значение");
		СписокВыбораТипаИзменения.Добавить("ИнвертироватьЗначение", "Инвертировать значение");
	ИначеЕсли ОписаниеТиповРеквизита.СодержитТип(Тип("Число")) Тогда
		СписокВыбораТипаИзменения.Добавить("УстановитьЗначение", "Установить значение");
		СписокВыбораТипаИзменения.Добавить("УстановитьДробнуюЧасть", "Установить дробную часть");
		СписокВыбораТипаИзменения.Добавить("УстановитьЦелуюЧасть", "Установить целую часть");
		СписокВыбораТипаИзменения.Добавить("Округлить", "Округлить");
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик действия "ПриВыводеСтроки" табличного поля "ЗначенияРеквизитов".
//
Процедура РеквизитыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Значение.ТолькоПросмотр = Истина
		И ДанныеСтроки.ТипИзменения <> "УстановитьЗначение"
		И ДанныеСтроки.ТипИзменения <> "УстановитьВремя"
		И ДанныеСтроки.ТипИзменения <> "УстановитьДату"
		И ДанныеСтроки.ТипИзменения <> "УстановитьДробнуюЧасть"
		И ДанныеСтроки.ТипИзменения <> "УстановитьЦелуюЧасть";
	ОформлениеСтроки.Ячейки.КлючПоиска.ТолькоПросмотр = Истина
		И ДанныеСтроки.ТипИзменения <> "УстановитьЗначение";
	//ОформлениеСтроки.Ячейки.Значение.Текст = Строка(ДанныеСтроки.Тип.ПривестиЗначение(ОформлениеСтроки.Ячейки.Значение.Значение));
	Если Не ДанныеСтроки.Сопоставлен Тогда
		ОформлениеСтроки.ЦветФона = WebЦвета.СветлоРозовый;
		ОформлениеСтроки.Ячейки.Пометка.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеСтроки.ДопРеквизит) Тогда
		ОформлениеСтроки.ЦветФона = WebЦвета.СветлоЗеленый;
	КонецЕсли;
	//ПредставлениеТипаИзменения = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ТипИзменения.ЭлементУправления.СписокВыбора.НайтиПоЗначению(ДанныеСтроки.ТипИзменения).Представление;
	//ОформлениеСтроки.Ячейки.ТипИзменения.УстановитьТекст(ПредставлениеТипаИзменения);
	ирОбщий.ТабличноеПоле_ОтобразитьФлажкиЛкс(ОформлениеСтроки, "Значение");
	ирОбщий.ТабличноеПоле_ОтобразитьПиктограммыТиповЛкс(ОформлениеСтроки, "Значение");
	ОписаниеТипов = ПолучитьОписаниеТиповРеквизита(ДанныеСтроки);
	ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ОписаниеТипов, ОписаниеТипов,, Ложь);

КонецПроцедуры

// Обработчик действия "СнятьФлажки" командной панели "КоманднаяПанельРеквизиты".
//
Процедура КоманднаяПанельРеквизитыСнятьФлажки(Кнопка)

	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.ЗначенияРеквизитов, , Ложь);

КонецПроцедуры // КоманднаяПанельРеквизитыСнятьФлажки()

Процедура ЗначенияРеквизитовЗначениеПриИзменении(Элемент)
	
	Если ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Сопоставлен Тогда
		ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	КонецЕсли; 
	ОбновитьТипЗначенияВСтрокеТаблицы();
	
КонецПроцедуры

Процедура ОбновитьТипЗначенияВСтрокеТаблицы(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.ЗначенияРеквизитов.ТекущиеДанные;
	КонецЕсли; 
	ОписаниеТипов = ПолучитьОписаниеТиповРеквизита(СтрокаТаблицы);
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаТаблицы,, ОписаниеТипов,,, Метаданные().ТабличныеЧасти.ЗначенияРеквизитов.Реквизиты);

КонецПроцедуры

Процедура ОбновитьКолонки()
	
	СтараяТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.ТекущаяКолонка;
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.Синоним.Видимость = Не мИменаПредставления;
	ЭлементыФормы.ЗначенияРеквизитов.Колонки.Идентификатор.Видимость = мИменаПредставления;
	Если СтараяТекущаяКолонка <> Неопределено Тогда
		Если Не СтараяТекущаяКолонка.Видимость Тогда
			Если СтараяТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.Идентификатор Тогда
				ЭлементыФормы.ЗначенияРеквизитов.ТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.Синоним;
			Иначе
				ЭлементыФормы.ЗначенияРеквизитов.ТекущаяКолонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.Идентификатор;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Функция ПолучитьИмяКолонкиПредставления()

	Если Не мИменаПредставления Тогда
		Результат = "Синоним";
	Иначе
		Результат = "Идентификатор";
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Процедура КоманднаяПанельРеквизитыИменаПредставления(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	мИменаПредставления = Кнопка.Пометка;
	ОбновитьКолонки();
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыТолькоПомеченные(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементОтбора = ЭлементыФормы.ЗначенияРеквизитов.ОтборСтрок.Пометка;
	ЭлементОтбора.Значение = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
	ЭлементОтбора.Использование = Кнопка.Пометка;
	
КонецПроцедуры

Процедура ЗначенияРеквизитовПриИзмененииФлажка(Элемент, Колонка)
	
	Если Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.КлючПоиска И ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.КлючПоиска Тогда
		ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	КонецЕсли; 
	ирОбщий.ТабличноеПоле__ПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если СвязиИПараметрыВыбора Тогда
		СтрокаПоля = мПоляТаблицыБД.Найти(ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Идентификатор, "Имя");
		Если СтрокаПоля <> Неопределено Тогда
			МетаРеквизит = СтрокаПоля.Метаданные;
			СтруктураРеквизитов = Новый Структура;
			Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
				СтруктураРеквизитов.Вставить(СтрокаРеквизита.Идентификатор, СтрокаРеквизита.Значение);
			КонецЦикла;
			СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(СтруктураРеквизитов, МетаРеквизит);
		КонецЕсли; 
		ДопРеквизит = ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.ДопРеквизит;
		Если ЗначениеЗаполнено(ДопРеквизит) Тогда
			#Если Сервер И Не Сервер Тогда
				ДопРеквизит = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПустаяСсылка();
			#КонецЕсли
			СтруктураОтбора = Новый Структура("Владелец", ДопРеквизит);
		КонецЕсли; 
	КонецЕсли; 
	Если ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.ЗначенияРеквизитов, СтандартнаяОбработка, , Истина, СтруктураОтбора) Тогда 
		ОбновитьТипЗначенияВСтрокеТаблицы();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыЗагрузитьИзОбъекта(Кнопка)
	
	ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(ОбластьПоиска);
	Если ТипТаблицы = "ТабличнаяЧасть" Тогда
		ОбъектМДВыбораСсылки = мОбъектМД.Родитель();
		лИмяТабличнойЧасти = мОбъектМД.Имя;
	Иначе
		ОбъектМДВыбораСсылки = мОбъектМД;
		лИмяТабличнойЧасти = ИмяТабличнойЧасти;
	КонецЕсли; 
	НачальноеЗначениеСсылки = ВладелецФормы.ПолучитьКлючСтрокиДляОбработки();
	Ссылка = ирОбщий.ВыбратьСсылкуЛкс(ОбъектМДВыбораСсылки, НачальноеЗначениеСсылки);
	Если Ссылка = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(ОбластьПоиска,,, Ложь);
	ЗаполнитьЗначенияСвойств(СтруктураКлюча, Ссылка); 
	Если Ссылка <> Неопределено Тогда
		Если ЗначениеЗаполнено(лИмяТабличнойЧасти) Тогда
			СтрокаРезультата = ирОбщий.ВыбратьСтрокуТаблицыЗначенийЛкс(Ссылка[лИмяТабличнойЧасти].Выгрузить());
			Если СтрокаРезультата = Неопределено Тогда
				Возврат;
			КонецЕсли; 
		Иначе
			СтрокаРезультата = ирОбщий.СтрокаТаблицыБДПоКлючуЛкс(ирОбщий.ИмяТаблицыИзМетаданныхЛкс(ОбластьПоиска), СтруктураКлюча);
		КонецЕсли; 
		Для Каждого СтрокаРеквизита Из ЗначенияРеквизитов Цикл
			СтрокаРеквизита.Значение = СтрокаРезультата[СтрокаРеквизита.Идентификатор];
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	Если ирКэш.НомерВерсииБСПЛкс() < 200 Или Не ирОбщий.ЛиСсылочныйОбъектМетаданных(мОбъектМД) Тогда
		ЭлементыФормы.ЗначенияРеквизитов.Колонки.ДопРеквизит.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ЗначенияРеквизитовЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ИмяТабличнойЧастиПриИзменении(Элемент)
	
	ЗначенияРеквизитов.Очистить();
	ОбновитьТаблицуРеквизитов();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.ЗначенияРеквизитов, , Истина);

КонецПроцедуры

Процедура ЗначенияРеквизитовТипИзмененияПриИзменении(Элемент)
	
	ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Пометка = Истина;
	РеквизитыПриНачалеРедактирования(ЭлементыФормы.ЗначенияРеквизитов, Ложь, Ложь);

КонецПроцедуры

Процедура ЗначенияРеквизитовТипИзмененияОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.Значение = "УстановитьЗначение";
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ЗначенияРеквизитов, ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельРеквизитыРедакторОбъектаБД(Кнопка)
	
	Если ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЗначениеЯчейки = ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока.Значение;
	Если Не ирОбщий.ЛиСсылкаНаОбъектБДЛкс(ЗначениеЯчейки, Ложь) Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ЗначениеЯчейки);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ЗначенияРеквизитовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ДопРеквизит И ЗначениеЗаполнено(ВыбраннаяСтрока.ДопРеквизит) Тогда
		ОткрытьЗначение(ВыбраннаяСтрока.ДопРеквизит);
	ИначеЕсли Ложь
		Или Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.ОписаниеТипов
	Тогда
		ОписаниеТипов = ПолучитьОписаниеТиповРеквизита(ВыбраннаяСтрока);
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка, ОписаниеТипов);
	ИначеЕсли Колонка = ЭлементыФормы.ЗначенияРеквизитов.Колонки.СвязиПараметровВыбора Тогда 
		Если ЗначениеЗаполнено(ВыбраннаяСтрока.СвязиПараметровВыбора) Тогда
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.ЗагрузитьЗначения(ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ВыбраннаяСтрока.СвязиПараметровВыбора, ",", Истина));
			СписокВыбора.СортироватьПоЗначению();
			РезультатВыбора = СписокВыбора.ВыбратьЭлемент("Переход к влияющему реквизиту");
			Если РезультатВыбора <> Неопределено Тогда
				ЭлементыФормы.ЗначенияРеквизитов.ТекущаяСтрока = ЗначенияРеквизитов.Найти(РезультатВыбора.Значение, "Идентификатор");
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ИзменитьДобавитьСтроку");
мИспользоватьНастройки = Истина;
мИменаПредставления = Ложь;
СвязиИПараметрыВыбора = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("РеквизитыДляСохранения, ОбрабатыватьСуществующую, ПринудительнаяЗапись, ИмяТабличнойЧасти");
мТипыОбрабатываемыхОбъектов = Неопределено;
