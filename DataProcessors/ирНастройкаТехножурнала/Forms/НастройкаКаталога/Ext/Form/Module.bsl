﻿Перем мТекущийИндексУзлаСобытия;
Перем мТекущийНомерУзлаСвойства;
Перем мДобавлениеНовыхАтрибутов;

// Окрыть форму редактирования условий
//
Процедура ОткрытьФормуРедактированияУсловий(ИмяФормы, Элемент, ТекущееСвойство = "")
	
	ФормаРедактированияУсловий = ОбработкаОбъект.ПолучитьФорму(ИмяФормы);
	Если Элемент.Имя = "ТабличноеПолеСписокСвойств" Тогда
		УзелСобытий = ПолучитьУзелСвойства(ТекущийЖурнал, Элемент.ТекущаяСтрока.НомерСвойства);
		ИмяСвойства = Элемент.ТекущаяСтрока.ИмяСвойства;
		Если УзелСобытий <> Неопределено Тогда
			УзелСобытий = УзелСобытий.ПервыйДочерний;
		КонецЕсли;
	Иначе
		УзелСобытий = ПолучитьУзелСобытия(ТекущийЖурнал, Элемент.ТекущаяСтрока.НомерСобытия);
	КонецЕсли;
	
	ФормаРедактированияУсловий.ТекущееСвойство = ТекущееСвойство;
	Результат = ФормаРедактированияУсловий.ОткрытьМодально();
	
	Если Результат = "ОК" Тогда
		Если Элемент.Имя = "ТабличноеПолеСписокСобытий" Тогда
			//ТабЗнач = ФормаРедактированияУсловий.ЭтаФорма.РедактированиеУсловийСобытия;
			//УстановитьЭлементОтбораСобытий(ТабЗнач, мТекущийНомерУзлаСобытия, Элемент.ТекущаяСтрока);
		Иначе
			ТабЗнач = ФормаРедактированияУсловий.ЭтаФорма.РедактированиеУсловийСвойства;
			УзелСвойства = ДобавитьСвойствоВЖурнал(ФормаРедактированияУсловий.ВыборИмениСвойства);
			УзелEvent = Неопределено;
			Для Каждого Строка Из ТабЗнач Цикл
				Если УзелEvent = Неопределено Тогда
					ЭлементEvent = СоздатьЭлементДОМ("event");
					УзелEvent = УзелСвойства.ДобавитьДочерний(ЭлементEvent);
				КонецЕсли;
				ЭлементДОМ = СоздатьЭлементДОМ(Строка.Сравнение);
				ЭлементДОМ.УстановитьАтрибут("property", ЗаменитьСимвол(Строка.Свойство, "_", ":"));
				ЭлементДОМ.УстановитьАтрибут("value", Строка.Значение);
				УзелEvent.ДобавитьДочерний(ЭлементДОМ);
			КонецЦикла;
			Элемент.ТекущаяСтрока.ИмяСвойства = ЗаменитьСимвол(ФормаРедактированияУсловий.ВыборИмениСвойства, "_", ":");
			ТабличноеПолеСписокСвойствПриАктивизацииСтроки(Элемент);
		КонецЕсли;
		
	Иначе 
		Если Результат = "Отмена" ИЛИ Результат = Неопределено Тогда
			Если мДобавлениеНовыхАтрибутов Тогда
				Если Элемент.Имя = "ТабличноеПолеСписокСобытий" Тогда
					ТабличноеПолеСписокСобытий.Удалить(ТабличноеПолеСписокСобытий.Количество() - 1);
				Иначе
					ТабличноеПолеСписокСвойств.Удалить(ТабличноеПолеСписокСвойств.Количество() - 1);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ОбновитьПометкиВПростомСпискеСобытий();
	ОбновитьПредставлениеОтбораСвойств();
	
КонецПроцедуры

Процедура УстановитьЭлементОтбораСобытий(ТабЗнач, ТекущийИндексУзлаСобытия = 0, СтрокаТаблицыОтбораСобытий = Неопределено)
 
	УзелСобытий = ПолучитьУзелСобытия(ТекущийЖурнал, ТекущийИндексУзлаСобытия);
	Если УзелСобытий <> Неопределено Тогда
		УзелУсловий = УзелСобытий.ПервыйДочерний;                
		Для Инд = 1 По УзелСобытий.ДочерниеУзлы.Количество() Цикл
			УзелСобытий.УдалитьДочерний(УзелУсловий);
			УзелУсловий = УзелСобытий.ПервыйДочерний;                
		КонецЦикла;
	КонецЕсли;
	Если УзелСобытий = Неопределено Тогда
		ЭлементEvent = СоздатьЭлементДОМ("event");
		УзелСобытий = ПолучитьУзелЖурнала(ТекущийЖурнал).ДобавитьДочерний(ЭлементEvent);
	КонецЕсли; 
	УзелEvent = Неопределено;
	ДокументДом = ДокументДОМ();
	Для Каждого Строка Из ТабЗнач Цикл
		ЭлементДОМ = СоздатьЭлементДОМ(Строка.Сравнение);
		ЗаменимПодчеркивание = Строка.Свойство;
		ЗаменимПодчеркивание = СтрЗаменить(ЗаменимПодчеркивание, "_", ":");
		ЭлементДОМ.УстановитьАтрибут("property", ЗаменимПодчеркивание);
		ЭлементДОМ.УстановитьАтрибут("value", Строка.Значение);
		УзелСобытий.ДобавитьДочерний(ЭлементДОМ);
	КонецЦикла;
	ДокументДом.НормализоватьДокумент();
	Если СтрокаТаблицыОтбораСобытий = Неопределено Тогда
		СтрокаТаблицыОтбораСобытий = ТабличноеПолеСписокСобытий.Добавить();
		СтрокаТаблицыОтбораСобытий.НомерСобытия = ТабличноеПолеСписокСобытий.Количество();
		ЭлементыФормы.ТабличноеПолеСписокСобытий.ТекущаяСтрока = СтрокаТаблицыОтбораСобытий;
	КонецЕсли; 
	ОбновитьПредставлениеСобытияВСтрокеГруппыИли(СтрокаТаблицыОтбораСобытий);
	ОбновитьПометкиВПростомСпискеСобытий();
	//ТабличноеПолеСписокСобытийПриАктивизацииСтроки(ЭлементыФормы.ТабличноеПолеСписокСобытий);

КонецПроцедуры

Процедура ОбновитьПредставлениеСобытияВСтрокеГруппыИли(СтрокаТаблицыОтбораСобытий)

	СтрокаПредставления = ПолучитьПредставлениеЭлементаОтбораСобытий(ТекущийЖурнал, СтрокаТаблицыОтбораСобытий.НомерСобытия - 1);
	СтрокаТаблицыОтбораСобытий.Событие = СтрокаПредставления;

КонецПроцедуры

Функция ДобавитьСвойствоВЖурнал(лИмяСвойства)

	Если мТекущийНомерУзлаСвойства <> Неопределено Тогда
		УзелСвойства = ПолучитьУзелСвойства(ТекущийЖурнал, мТекущийНомерУзлаСвойства);
	КонецЕсли; 
	Если УзелСвойства <> Неопределено И УзелСвойства.ПервыйДочерний <> Неопределено Тогда
		УзелСвойства.УдалитьДочерний(УзелСвойства.ПервыйДочерний);
	КонецЕсли;
	Если УзелСвойства <> Неопределено Тогда
		УзелСвойства.Атрибуты.УдалитьИменованныйЭлемент("name");
		Атрибут = ДокументДОМ().СоздатьАтрибут("name");
		Атрибут.Значение = ЗаменитьСимвол(лИмяСвойства, "_", ":");
		УзелСвойства.Атрибуты.УстановитьИменованныйЭлемент(Атрибут);
	КонецЕсли;
	Если УзелСвойства = Неопределено Тогда
		ЭлементProperty = СоздатьЭлементДОМ("property");
		ЭлементProperty.УстановитьАтрибут("name", лИмяСвойства);
		УзелСвойства = ПолучитьУзелЖурнала(ТекущийЖурнал).ДобавитьДочерний(ЭлементProperty);
	КонецЕсли;
	Возврат УзелСвойства;

КонецФункции

// Инициализация событий
//
Процедура ИнициализацияСвойствИСобытий()
	
	мТекущийИндексУзлаСобытия = 0;
	мТекущийНомерУзлаСвойства = 0;
	Если ТекущийЖурнал = -1 Тогда
		Возврат;
	КонецЕсли; 
	СписокУзлов = ПолучитьСписокУзловЖурнала(ТекущийЖурнал);
	ТабличноеПолеСписокСобытий.Очистить();
	Для ИндексСобытия = 0 По СписокУзлов.Количество() - 1 Цикл
		Если Не ирОбщий.СтрокиРавныЛкс(СписокУзлов.Элемент(ИндексСобытия).РодительскийУзел.ЛокальноеИмя, "log") Тогда
			Продолжить;
		КонецЕсли;
		Если ирОбщий.СтрокиРавныЛкс(СписокУзлов.Элемент(ИндексСобытия).ЛокальноеИмя, "event") Тогда
			СтрокаСобытия = ТабличноеПолеСписокСобытий.Добавить();
			СтрокаСобытия.НомерСобытия = ТабличноеПолеСписокСобытий.Количество();
			СтрокаСобытия.Событие = ПолучитьПредставлениеЭлементаОтбораСобытий(ТекущийЖурнал, СтрокаСобытия.НомерСобытия - 1);
		ИначеЕсли ирОбщий.СтрокиРавныЛкс(СписокУзлов.Элемент(ИндексСобытия).ЛокальноеИмя, "property") Тогда
			СтрокаСвойства = ТабличноеПолеСписокСвойств.Добавить();
			СтрокаСвойства.ИмяСвойства = СписокУзлов.Элемент(ИндексСобытия).Атрибуты.ПолучитьИменованныйЭлемент("name").Значение;
			СтрокаСвойства.НомерСвойства = ТабличноеПолеСписокСвойств.Количество();
		Иначе
			// Например dbmslocks
		КонецЕсли; 
	КонецЦикла;
	
	// Возможно есть свойства (property) без вложеных событий (event)
	// их тоже надо показать
	УзелСвойств = ПолучитьСписокСвойств(ТекущийЖурнал);
	ТабличноеПолеСписокСвойств.Очистить();
	Для ИндСв = 0 По УзелСвойств.Количество() - 1 Цикл
		// Закомментирвано 24.09.2012
		//// Без вложенных событий не нужны, пропускаем
		//Если УзелСвойств.Элемент(ИндСв).ПервыйДочерний <> Неопределено Тогда
		//	Продолжить;
		//КонецЕсли;
		СтрокаСвойств = ТабличноеПолеСписокСвойств.Добавить();
		Попытка
			СтрокаСвойств.ИмяСвойства = УзелСвойств.Элемент(ИндСв).Атрибуты.ПолучитьИменованныйЭлемент("name").Значение;
		Исключение
		КонецПопытки;
		СтрокаСвойств.НомерСвойства = ТабличноеПолеСписокСвойств.Количество();
	КонецЦикла;
	ПрочитатьНастройкиЖурнала(ТекущийЖурнал, МестоположениеЖурнала, ВремяХраненияЖурнала,, СобиратьБлокировкиСУБД);
	ОбновитьПометкиВПростомСпискеСобытий();
	ОбновитьПредставлениеОтбораСвойств();
	
КонецПроцедуры

Процедура ОбновитьПометкиВПростомСпискеСобытий() Экспорт
	
	ПредставлениеСобытий = "";
	СписокУзловЖурнала = ПолучитьСписокУзловЖурнала(ТекущийЖурнал);
	Для Каждого СтрокаСобытия Из События Цикл
		СтрокаСобытия.Пометка = Ложь;
	КонецЦикла; 
	Для ИндексСобытия = 0 По СписокУзловЖурнала.Количество() - 1 Цикл
		ИмяСобытия = ПолучитьИмяСобытияЭлементаОтбораСобытийНаРавенство(СписокУзловЖурнала, ИндексСобытия);
		Если ИмяСобытия <> Неопределено Тогда
			ЭлементСписка = События.Найти(ВРег(ИмяСобытия), "Имя");
			Если ЭлементСписка <> Неопределено Тогда
				ЭлементСписка.Пометка = Истина;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	ОбновитьПредставлениеОтбораСобытий();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ВЫЗЫВАЕМЫЕ ИЗ ОБРАБОТЧИКОВ ЭЛЕМЕНТОВ ФОРМЫ

// Инициализация формы
//
Процедура ПриОткрытии()
	
	Если ЭтаФорма.ВладелецФормы <> Неопределено Тогда
		ЭтаФорма.ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли; 
	Если ДобавлениеНового Тогда
		ДокументДОМ().ПервыйДочерний.ДобавитьДочерний(НовыйЖурнал());
		ЭтотОбъект.ТекущийЖурнал = ОбработкаОбъект.ПолучитьФорму("НастройкаТехножурнала").ЭтаФорма.ТабличноеПолеЖурналы.Количество();
		ДобавитьСвойствоВЖурнал("all");
	КонецЕсли;
	ИнициализацияСвойствИСобытий();
	Если ДобавлениеНового Тогда
		Если ТекущийЖурнал = 0 Тогда
			Если Не ЗначениеЗаполнено(МестоположениеЖурнала) Тогда
				МестоположениеЖурнала = ОсновнойКаталогЖурнала;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	ДоступностьСпециальныхОтборов = Не ирКэш.Получить().ЭтоФайловаяБаза;
	Кнопки = Новый Массив();
	Кнопки.Добавить(ЭлементыФормы.КП_ДетальныйФильтрСобытий.Кнопки.ТекущаяБаза);
	//Кнопки.Добавить(ЭлементыФормы.КП_ДетальныйФильтрСобытий.Кнопки.ТекущийПользователь);
	Кнопки.Добавить(ЭлементыФормы.КП_ДетальныйФильтрСобытий.Кнопки.ТекущийСеанс);
	Для Каждого Кнопка Из Кнопки Цикл
		Кнопка.Доступность = ДоступностьСпециальныхОтборов;
		Если Не ДоступностьСпециальныхОтборов Тогда
			Кнопка.Подсказка = "Недоступно в файловой СУБД";
			Кнопка.Пояснение = Кнопка.Подсказка;
		КонецЕсли; 
	КонецЦикла;
	ЭлементыФормы.РедактированиеУсловийСобытия.Колонки.Свойство.ЭлементУправления.СписокВыбора = ПолучитьСписокСвойствСобытий();
	ЭлементыФормы.РедактированиеУсловийСобытия.Колонки.Сравнение.ЭлементУправления.СписокВыбора = ПолучитьСписокСравнения();
	ОбновитьОтборТаблицыСобытий();

КонецПроцедуры

// Закрытие формы с сохранением
//
Процедура КнопкаОКНажатие(Элемент)
	
	Если ТабличноеПолеСписокСобытий.Количество() = 0 Тогда
		Предупреждение("Необходимо выбрать хотя бы одно событие!");
		Возврат;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(МестоположениеЖурнала)  Тогда
		Предупреждение("Необходимо выбрать каталог файлов журнала!");
		Возврат;
	КонецЕсли; 
	ЭтаФорма.Закрыть("ОК");
	
КонецПроцедуры

// Выбор каталога размещения журнала
// 
Процедура МестоположениеЖурналаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура МестоположениеЖурналаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура МестоположениеЖурналаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

//
//
Процедура ТабличноеПолеСписокСобытийПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрокаУсловия = ЭлементыФормы.РедактированиеУсловийСобытия.ТекущаяСтрока;
	Если ТекущаяСтрокаУсловия <> Неопределено Тогда
		СтарыйИндекс = РедактированиеУсловийСобытия.Индекс(ТекущаяСтрокаУсловия);
	КонецЕсли; 
	РедактированиеУсловийСобытия.Очистить();
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мТекущийИндексУзлаСобытия = Элемент.ТекущаяСтрока.НомерСобытия - 1;
	УзелСобытий = ПолучитьУзелСобытия(ТекущийЖурнал, мТекущийИндексУзлаСобытия);
	
	Если УзелСобытий = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УзелУсловий = УзелСобытий.ПервыйДочерний;
	ИмяСобытия = Неопределено;
	Пока УзелУсловий <> Неопределено Цикл
		СтрокаУсловия = РедактированиеУсловийСобытия.Добавить();
		//СтрокаУсловия.ПредставлениеСравнения = ПолучитьСписокСравнения().НайтиПоЗначению(НРег(УзелУсловий.ЛокальноеИмя));
		СтрокаУсловия.Сравнение = УзелУсловий.ЛокальноеИмя;
		Для Каждого Атрибут Из УзелУсловий.Атрибуты Цикл
			Если Атрибут.ЛокальноеИмя = "property" Тогда
				СтрокаУсловия.Свойство = Атрибут.ЗначениеУзла;
			КонецЕсли;
			Если Атрибут.ЛокальноеИмя = "value" Тогда
				СтрокаУсловия.Значение = Атрибут.ЗначениеУзла;
			КонецЕсли;
		КонецЦикла;
		УзелУсловий = УзелУсловий.СледующийСоседний;
		Если ирОбщий.СтрокиРавныЛкс(СтрокаУсловия.Свойство, "Name") И СтрокаУсловия.Сравнение = "eq" Тогда
			Если Не ирОбщий.СтрокиРавныЛкс(ИмяСобытия, "ALL") Тогда 
				Если ПустаяСтрока(ИмяСобытия) Тогда
					ИмяСобытия = СтрокаУсловия.Значение;
				Иначе
					ИмяСобытия = "ALL";
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	Если СтарыйИндекс <> Неопределено Тогда
		Если РедактированиеУсловийСобытия.Количество() > СтарыйИндекс Тогда
			ЭлементыФормы.РедактированиеУсловийСобытия.ТекущаяСтрока = РедактированиеУсловийСобытия[СтарыйИндекс];
		КонецЕсли; 
	КонецЕсли; 
	ОбновитьОтборДоступныхСвойств(ИмяСобытия, Истина);

КонецПроцедуры

Процедура ОбновитьОтборДоступныхСвойств(ИмяСобытия, ВключатьКолонкуСобытия = Ложь)
	
	Если Не ЗначениеЗаполнено(ИмяСобытия) Или ирОбщий.СтрокиРавныЛкс(ИмяСобытия, "ALL") Тогда
		ЭлементыФормы.ДоступныеСвойства.ОтборСтрок.НИмя.Использование = Ложь;
	Иначе
		ЭлементыФормы.ДоступныеСвойства.ОтборСтрок.НИмя.Использование = Истина;
		ЭлементыФормы.ДоступныеСвойства.ОтборСтрок.НИмя.ВидСравнения = ВидСравнения.ВСписке;
		СтруктураСвойствСобытия = ПолучитьСтруктуруСвойствСобытия(ИмяСобытия, ВключатьКолонкуСобытия);
		Если СтруктураСвойствСобытия = Неопределено Тогда
			ВызватьИсключение "Состав свойств события """ + ИмяСобытия + """ техножурнала не найден";
		КонецЕсли; 
		СписокСвойствСобытия = Новый СписокЗначений;
		Для Каждого КлючИЗначение Из СтруктураСвойствСобытия Цикл
			СписокСвойствСобытия.Добавить(НРег(КлючИЗначение.Ключ));
		КонецЦикла;
		ЭлементыФормы.ДоступныеСвойства.ОтборСтрок.НИмя.Значение = СписокСвойствСобытия;
	КонецЕсли;

КонецПроцедуры

// Процедура обработки события начала редактирования
//
Процедура РедактированиеУсловийСобытияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ПриНачалеРедактированияЭлементаОтбора(ЭлементыФормы.РедактированиеУсловийСобытия, Элемент, НоваяСтрока, Копирование);

КонецПроцедуры

// Процедура обработки события изменения данных
//
Процедура РедактированиеУсловийСобытияСвойствоПриИзменении(Элемент)
	
	ПриИзмененииСвойства(ЭлементыФормы.РедактированиеУсловийСобытия, Элемент);
	
КонецПроцедуры

Процедура РедактированиеУсловийСобытияПриАктивизацииСтроки(Элемент)
	
	ОбновитьОписаниеСвойстваОтбораСобытия();
	
КонецПроцедуры

// Процедура обработки события ПриИзменении
//
Процедура РедактированиеУсловийСобытияСравнениеПриИзменении(Элемент)
	
	Если Элемент.Значение = "like" Тогда
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель1ВставитьШаблонДляВыбраннойТаблицы(Кнопка)
	
	ЛиИменаБД = Истина;
	ТекущаяСтрока = ЭлементыФормы.РедактированиеУсловийСобытия.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		Если ирОбщий.СтрокиРавныЛкс(ТекущаяСтрока.Свойство, "sdbl") Тогда
			ЛиИменаБД = Ложь;
		КонецЕсли; 
	КонецЕсли; 
	ИмяТаблицыХранения = СтрЗаменить(ТекущаяСтрока.Значение, "%", "");
	ФормаВыбора = ирОбщий.ПолучитьФормуВыбораТаблицыСтруктурыБДЛкс(ЛиИменаБД, ИмяТаблицыХранения);
	ИмяТаблицыХранения = ФормаВыбора.ОткрытьМодально();
	Если ИмяТаблицыХранения = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = ЭлементыФормы.РедактированиеУсловийСобытия.ДобавитьСтроку();
	Иначе
		ЭлементыФормы.РедактированиеУсловийСобытия.ИзменитьСтроку();
	КонецЕсли; 
	ТекущаяСтрока.Сравнение = "like";
	ТекущаяСтрока.Значение = "%" + ИмяТаблицыХранения + "%";
	//РедактированиеУсловийСобытияПриОкончанииРедактирования(ЭлементыФормы.РедактированиеУсловийСобытия,,);
	
КонецПроцедуры

//
//
Процедура ТабличноеПолеСписокСобытийПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		
		// Получим перед добавлением новой строки
		ТабЗнач = РедактированиеУсловийСобытия;
		ПредставлениеСобытия = ЭлементыФормы.ТабличноеПолеСписокСобытий.ТекущаяСтрока.Событие;
		
		УзелЖурнала = ПолучитьУзелЖурнала(ТекущийЖурнал);
		// Добавим параметры события
		УзелEvent = Неопределено;
		Для Каждого Строка Из ТабЗнач Цикл
			
			Элемент = Строка.Сравнение;
			Если ПустаяСтрока(Элемент) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементДОМ = СоздатьЭлементДОМ(Элемент);
			ЗаменимПодчеркивание = Строка.Свойство;
			ЗаменимПодчеркивание_ = СтрЗаменить(ЗаменимПодчеркивание, "_", ":");
			ЭлементДОМ.УстановитьАтрибут("property", ЗаменимПодчеркивание_);
			ЭлементДОМ.УстановитьАтрибут("value", Строка.Значение);
			
			Если УзелEvent = Неопределено Тогда
				ЭлементEvent = СоздатьЭлементДОМ("event");
				УзелEvent = УзелЖурнала.ДобавитьДочерний(ЭлементEvent);
			КонецЕсли;
			УзелEvent.ДобавитьДочерний(ЭлементДОМ);
					
		КонецЦикла;
		
		НоваяСтрока = ТабличноеПолеСписокСобытий.Добавить();
		НоваяСтрока.НомерСобытия = ТабличноеПолеСписокСобытий.Количество();
		НоваяСтрока.Событие = ПредставлениеСобытия;
		
		ЭлементыФормы.ТабличноеПолеСписокСобытий.ТекущаяСтрока = НоваяСтрока;
		ТабличноеПолеСписокСобытийПриАктивизацииСтроки(ЭлементыФормы.ТабличноеПолеСписокСобытий);
		ОбновитьПометкиВПростомСпискеСобытий();
		
	Иначе
		
		мДобавлениеНовыхАтрибутов = Истина;
		
		Строка = ТабличноеПолеСписокСобытий.Добавить();
		Строка.НомерСобытия = ТабличноеПолеСписокСобытий.Количество();
		
		Элемент.ТекущаяСтрока = Строка;
		УстановитьЭлементОтбораСобытий(РедактированиеУсловийСобытия, мТекущийИндексУзлаСобытия, Строка);
		//ОткрытьФормуРедактированияУсловий("УсловияЗаписиСобытия", Элемент);
		
	КонецЕсли;

КонецПроцедуры

//
//
Процедура ТабличноеПолеСписокСобытийПередУдалением(Элемент, Отказ)
	
	СтрокаЭлементаОтбора = Элемент.ТекущаяСтрока;
	УдалитьЭлементОтбораСобытий(СтрокаЭлементаОтбора);
	ОбновитьПредставлениеОтбораСобытий();
	
КонецПроцедуры

Процедура УдалитьЭлементОтбораСобытий(СтрокаЭлементаОтбора)
	
	Инд = ТабличноеПолеСписокСобытий.Индекс(СтрокаЭлементаОтбора);
	// Поменяем номера строк от удалямой до конца
	Для сч = Инд По ТабличноеПолеСписокСобытий.Количество() - 1 Цикл
		
		Строка = ТабличноеПолеСписокСобытий[сч];
		Строка.НомерСобытия = сч;
		
	КонецЦикла;
	
	УзелСобытий = ПолучитьУзелСобытия(ТекущийЖурнал, Инд);
	
	Если УзелСобытий <> Неопределено Тогда
		УзелСобытий.РодительскийУзел.УдалитьДочерний(УзелСобытий);
		ОбновитьПометкиВПростомСпискеСобытий();
	КонецЕсли;

КонецПроцедуры

//
//
Процедура ТабличноеПолеСписокСвойствПриАктивизацииСтроки(Элемент)
	
	СвойстваСобытия.Очистить();
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мТекущийНомерУзлаСвойства = Элемент.ТекущаяСтрока.НомерСвойства;
	УзелСвойств = ПолучитьУзелСвойства(ТекущийЖурнал, мТекущийНомерУзлаСвойства);
	
	Если УзелСвойств = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Только один элемент property, показывать больше ничего не надо
	Если УзелСвойств.ПервыйДочерний = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УзелУсловий = УзелСвойств.ПервыйДочерний.ПервыйДочерний;
	Пока УзелУсловий <> Неопределено Цикл
		СтрокаУсловия = СвойстваСобытия.Добавить();
		СтрокаУсловия.Сравнение = ПолучитьСписокСравнения().НайтиПоЗначению(НРег(УзелУсловий.ЛокальноеИмя));
		Для Каждого Атрибут Из УзелУсловий.Атрибуты Цикл
			Если Атрибут.ЛокальноеИмя = "property" Тогда
				СтрокаУсловия.Свойство = Атрибут.ЗначениеУзла;
			КонецЕсли;
			Если Атрибут.ЛокальноеИмя = "value" Тогда
				СтрокаУсловия.Значение = Атрибут.ЗначениеУзла;
			КонецЕсли;
		КонецЦикла;
		УзелУсловий = УзелУсловий.СледующийСоседний;
	КонецЦикла;
	
КонецПроцедуры

//
//
Процедура ТабличноеПолеСписокСвойствПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	мДобавлениеНовыхАтрибутов = Ложь;
	ОткрытьФормуРедактированияУсловий("УсловияЗаписиСвойства", Элемент);

КонецПроцедуры

//
//
Процедура ТабличноеПолеСписокСвойствПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
		
	Если Копирование Тогда
		
		// Получим перед добавлением новой строки
		ИмяСвойства = ЭлементыФормы.ТабличноеПолеСписокСвойств.ТекущаяСтрока.ИмяСвойства;
		ТабЗнач = СвойстваСобытия;
		
		// Добавим свойство
		УзелЖурнала = ПолучитьУзелЖурнала(ТекущийЖурнал);
		ЭлементProperty = СоздатьЭлементДОМ("property");
		ЭлементProperty.УстановитьАтрибут("name", ИмяСвойства);
		УзелСвойства = УзелЖурнала.ДобавитьДочерний(ЭлементProperty);
		
		УзелEvent = Неопределено;
		// Добавим параметры свойства
		Для Каждого Строка Из ТабЗнач Цикл
			
			Элемент = НайтиПоПредставлению(ПолучитьСписокСравнения(), Строка.Сравнение);
			Если ПустаяСтрока(Элемент) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементДОМ = СоздатьЭлементДОМ(Элемент);
			ЗаменимПодчеркивание = Строка.Свойство;
			ЗаменимПодчеркивание_ = СтрЗаменить(ЗаменимПодчеркивание, "_", ":");
			ЭлементДОМ.УстановитьАтрибут("property", ЗаменимПодчеркивание_);
			ЭлементДОМ.УстановитьАтрибут("value", Строка.Значение);
			
			Если УзелEvent = Неопределено Тогда
				ЭлементEvent = СоздатьЭлементДОМ("event");
				УзелEvent = УзелСвойства.ДобавитьДочерний(ЭлементEvent);
			КонецЕсли;
			УзелEvent.ДобавитьДочерний(ЭлементДОМ);
					
		КонецЦикла;
		
		НоваяСтрока = ТабличноеПолеСписокСвойств.Добавить();
		НоваяСтрока.НомерСвойства = ТабличноеПолеСписокСвойств.Количество();
		НоваяСтрока.ИмяСвойства = ИмяСвойства;
		
		ЭлементыФормы.ТабличноеПолеСписокСвойств.ТекущаяСтрока = НоваяСтрока;
		ТабличноеПолеСписокСвойствПриАктивизацииСтроки(ЭлементыФормы.ТабличноеПолеСписокСвойств);
		ОбновитьПредставлениеОтбораСвойств();
		
	Иначе
		
		мДобавлениеНовыхАтрибутов = Истина;
		
		Строка = ТабличноеПолеСписокСвойств.Добавить();
		Строка.НомерСвойства = ТабличноеПолеСписокСвойств.Количество();
			
		Элемент.ТекущаяСтрока = Строка;
		
		ОткрытьФормуРедактированияУсловий("УсловияЗаписиСвойства", Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

//
//
Процедура ТабличноеПолеСписокСвойствПередУдалением(Элемент, Отказ)
	
	Инд = ТабличноеПолеСписокСвойств.Индекс(Элемент.ТекущаяСтрока) + 1;
	УзелСвойства = ПолучитьУзелСвойства(ТекущийЖурнал, Инд);
	
	// Поменяем номера строк от удалямой до конца
	Для сч = Инд По ТабличноеПолеСписокСвойств.Количество() - 1 Цикл
		
		Строка = ТабличноеПолеСписокСвойств[сч];
		Строка.НомерСвойства = сч;
		
	КонецЦикла;
	
	Если УзелСвойства <> Неопределено Тогда
		УзелСвойства.РодительскийУзел.УдалитьДочерний(УзелСвойства);
	КонецЕсли;
	ОбновитьПредставлениеОтбораСвойств();
	
КонецПроцедуры

Процедура МестоположениеЖурналаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура МестоположениеЖурналаОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Элемент.Значение = ОсновнойКаталогЖурнала;
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ДокументДОМ() = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЗаписатьНастройкиЖурнала(ТекущийЖурнал, МестоположениеЖурнала, ВремяХраненияЖурнала, СобиратьБлокировкиСУБД);
	// Антибаг 8.2.16 http://partners.v8.1c.ru/forum/thread.jsp?id=1039155#1039155
	//ОсновнаяФорма = ОбработкаОбъект.ПолучитьФорму("НастройкаТехножурнала"); // Так в управляемом режиме получается новая форма вместо открытой
	ОсновнаяФорма = ЭтаФорма.ВладелецФормы;
	Если ОсновнаяФорма = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПрочитатьНастройкиЖурналов(ОсновнаяФорма.ТабличноеПолеЖурналы);
	Если ПустаяСтрока(ПредставлениеОтбораСобытий) Тогда
		ТаблицаСпискаЖурналов = ОсновнаяФорма.ТабличноеПолеЖурналы;
		СтрокиПустогоУсловия = ТаблицаСпискаЖурналов.НайтиСтроки(Новый Структура("События", ""));
		ДокументДОМ = ДокументДОМ();
		Для Каждого СтрокаПустогоУсловия Из СтрокиПустогоУсловия Цикл
			Инд = ТаблицаСпискаЖурналов.Индекс(СтрокаПустогоУсловия);
			УзелЖурнала = ПолучитьУзелЖурнала(Инд);
			Если УзелЖурнала <> Неопределено Тогда
				УзелКонфигурации = ДокументДОМ.ПервыйДочерний;
				УзелКонфигурации.УдалитьДочерний(УзелЖурнала);
			КонецЕсли;
			ТаблицаСпискаЖурналов.Удалить(СтрокаПустогоУсловия);
		КонецЦикла;
	Иначе
		//ОсновнаяФорма.ВычислитьРазмерыКаталогов(); // Может долго выполняться
		ОсновнаяФорма.Модифицированность = ОсновнаяФорма.Модифицированность Или ЭтаФорма.Модифицированность;
	КонецЕсли;
	Если ЭтаФорма.ВладелецФормы <> Неопределено Тогда
		ЭтаФорма.ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура СобытияПриИзмененииФлажка(Элемент, Колонка)
	
	ИмяСобытия = Элемент.ТекущаяСтрока.Имя;
	НовоеСостояние = Элемент.ТекущаяСтрока.Пометка = Истина;
	УстановитьРегистрациюСобытия(ИмяСобытия, НовоеСостояние);

КонецПроцедуры

Функция УстановитьРегистрациюСобытия(Знач ИмяСобытия, Знач НовоеСостояние) Экспорт 
    
	ПредставлениеСобытий = "";
	СписокУзловЖурнала = ПолучитьСписокУзловЖурнала(ТекущийЖурнал);
	УзелУсловийНайден = Ложь;
	ИндексСобытия = 0;
	Для ИндексУзла = 0 По СписокУзловЖурнала.Количество() - 1 Цикл
		УзелСобытия = СписокУзловЖурнала.Элемент(ИндексУзла);
		Если Истина
			И ирОбщий.СтрокиРавныЛкс(УзелСобытия.РодительскийУзел.ЛокальноеИмя, "log") 
			И ирОбщий.СтрокиРавныЛкс(УзелСобытия.ЛокальноеИмя, "event") 
		Тогда
			//
		Иначе
			Продолжить;
		КонецЕсли;
		УзелУсловий = УзелСобытия.ПервыйДочерний;
		Пока УзелУсловий <> Неопределено Цикл
			Если ВРег(ИмяСобытия) = "<ALL>" Тогда
				Если УзелУсловий.ЛокальноеИмя = "ne" Тогда
					АтрибутИмениСобытия = УзелУсловий.Атрибуты.ПолучитьИменованныйЭлемент("property");
					Если Истина
						И АтрибутИмениСобытия <> Неопределено 
						И НРег(АтрибутИмениСобытия.ЗначениеУзла) = "name"
					Тогда
						АтрибутЗначенияИмениСобытия = УзелУсловий.Атрибуты.ПолучитьИменованныйЭлемент("value");
						Если Истина
							И АтрибутЗначенияИмениСобытия <> Неопределено
							И АтрибутЗначенияИмениСобытия.ЗначениеУзла = ""
						Тогда
							УзелУсловийНайден = Истина;
							Прервать;
						КонецЕсли; 
					КонецЕсли; 
				КонецЕсли; 
			Иначе
				Если УзелУсловий.ЛокальноеИмя = "eq" Тогда
					АтрибутИмениСобытия = УзелУсловий.Атрибуты.ПолучитьИменованныйЭлемент("property");
					Если Истина
						И АтрибутИмениСобытия <> Неопределено 
						И НРег(АтрибутИмениСобытия.ЗначениеУзла) = "name"
					Тогда
						АтрибутЗначенияИмениСобытия = УзелУсловий.Атрибуты.ПолучитьИменованныйЭлемент("value");
						Если Истина
							И АтрибутЗначенияИмениСобытия <> Неопределено
							И НРег(АтрибутЗначенияИмениСобытия.ЗначениеУзла) = НРег(ИмяСобытия)
						Тогда
							УзелУсловийНайден = Истина;
							Прервать;
						КонецЕсли; 
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
			УзелУсловий = УзелУсловий.СледующийСоседний;
		КонецЦикла;
		Если УзелУсловийНайден Тогда
			Прервать;
		КонецЕсли; 
		ИндексСобытия = ИндексСобытия + 1;
	КонецЦикла;
	Если УзелУсловийНайден И Не НовоеСостояние Тогда
		//УзелУсловий.РодительскийУзел.УдалитьДочерний(УзелУсловий);
		УдалитьЭлементОтбораСобытий(ТабличноеПолеСписокСобытий[ИндексСобытия]);
		ТабличноеПолеСписокСобытий.Удалить(ТабличноеПолеСписокСобытий[ИндексСобытия]);
	ИначеЕсли Не УзелУсловийНайден И НовоеСостояние Тогда
		мДобавлениеНовыхАтрибутов = Истина;
		СтрокаСобытия = ТабличноеПолеСписокСобытий.Добавить();
		СтрокаСобытия.НомерСобытия = ТабличноеПолеСписокСобытий.Количество();
		ЭлементыФормы.ТабличноеПолеСписокСобытий.ТекущаяСтрока = СтрокаСобытия;
		ЭлементЭлементаОтбора = РедактированиеУсловийСобытия.Добавить();
		ЭлементЭлементаОтбора.Свойство = "name";
		Если ВРег(ИмяСобытия) = "<ALL>" Тогда
			ЭлементЭлементаОтбора.Сравнение = "ne";
			ЭлементЭлементаОтбора.Значение = "";
		Иначе
			ЭлементЭлементаОтбора.Сравнение = "eq";
			ЭлементЭлементаОтбора.Значение = ИмяСобытия;
		КонецЕсли; 
		УстановитьЭлементОтбораСобытий(РедактированиеУсловийСобытия, мТекущийИндексУзлаСобытия, ЭлементыФормы.ТабличноеПолеСписокСобытий.ТекущаяСтрока);
		Результат = ТабличноеПолеСписокСобытий[ТабличноеПолеСписокСобытий.Количество() - 1];
	ИначеЕсли УзелУсловийНайден Тогда
		Результат = ТабличноеПолеСписокСобытий[ИндексСобытия];
	КонецЕсли;
	ОбновитьПредставлениеОтбораСобытий();
	Возврат Результат;

КонецФункции

Процедура ОбновитьПредставлениеОтбораСобытий() 

	ЭтаФорма.ПредставлениеОтбораСобытий = ПолучитьПредставлениеОтбораСобытийЖурнала(ТекущийЖурнал);

КонецПроцедуры

Процедура ОбновитьПредставлениеОтбораСвойств() 

	ЭтаФорма.ПредставлениеОтбораСвойств = ПолучитьПредставлениеОтбораСвойствЖурнала(ТекущийЖурнал);

КонецПроцедуры

Процедура КоманднаяПанельСобытияТолькоПомеченные(Кнопка)
	
	ЛиТолькоПомеченныеСобытия = Не Кнопка.Пометка;
	ОбновитьОтборТаблицыСобытий();
	
КонецПроцедуры

Процедура УстановитьТекущуюСтрокуСобытия(Событие) Экспорт
	
	ЛиТолькоПомеченныеСобытия = Ложь;
	ОбновитьОтборТаблицыСобытий();
	ЭлементыФормы.События.ОтборСтрок.Сбросить();
	СтрокаСобытия = События.Найти(ВРег(Событие), "Имя");
	Если СтрокаСобытия <> Неопределено Тогда
		ЭлементыФормы.События.ТекущаяСтрока = СтрокаСобытия;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьОтборТаблицыСобытий()
	
	Если События.Найти(Истина, "Пометка") = Неопределено Тогда
		ЛиТолькоПомеченныеСобытия = Ложь;
	КонецЕсли; 
	ЭлементыФормы.События.ОтборСтрок.Пометка.Использование = ЛиТолькоПомеченныеСобытия;
	ЭлементыФормы.КоманднаяПанельСобытия.Кнопки.ТолькоПомеченные.Пометка = ЛиТолькоПомеченныеСобытия;
	
КонецПроцедуры

Процедура ОбновитьОписаниеСвойстваОтбораСобытия()
	
	Если ЭлементыФормы.РедактированиеУсловийСобытия.ТекущаяСтрока <> Неопределено Тогда
		СтрокаСвойства = Свойства.Найти(ЭлементыФормы.РедактированиеУсловийСобытия.ТекущаяСтрока.Свойство, "НИмя");
	КонецЕсли; 
	Если СтрокаСвойства <> Неопределено Тогда
		ЭлементыФормы.ДоступныеСвойства.ТекущаяСтрока = СтрокаСвойства;
	Иначе
		//ЭлементыФормы.ДоступныеСвойства.ТекущаяСтрока = Неопределено;
	КонецЕсли; 

КонецПроцедуры

Процедура РедактированиеУсловийСобытияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	//Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("ОбработкаТабличнаяЧастьСтрока.ирНастройкаТехножурнала.Свойства") Тогда // Нельзя из-за ошибки в портативной версии
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = ТипЗнч(Свойства[0]) Тогда
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура РедактированиеУсловийСобытияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	//Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("ОбработкаТабличнаяЧастьСтрока.ирНастройкаТехножурнала.Свойства") Тогда // Нельзя из-за ошибки в портативной версии
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = ТипЗнч(Свойства[0]) Тогда
		СтандартнаяОбработка = Ложь;
		Попытка
			ИмяСвойства = ПараметрыПеретаскивания.Значение.НИмя;
		Исключение
			Возврат;
		КонецПопытки; 
		ЭлементыФормы.РедактированиеУсловийСобытия.ДобавитьСтроку();
		ЭлементыФормы.РедактированиеУсловийСобытия.ТекущиеДанные.Свойство = ИмяСвойства;
		ПриИзмененииСвойства(ЭлементыФормы.РедактированиеУсловийСобытия, Элемент);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура обработки события показа строки
//
Процедура РедактированиеУсловийСобытияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура УсловияЗаписиСобытияПриАктивизацииСтроки(Элемент)
	
	ОбновитьОписаниеСвойстваОтбораСобытия();

КонецПроцедуры

Процедура УсловияЗаписиСобытияВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	////
	////мДобавлениеНовыхАтрибутов = Ложь;
	////ОткрытьФормуРедактированияУсловий("УсловияЗаписиСобытия", ЭлементыФормы.ТабличноеПолеСписокСобытий, ВыбраннаяСтрока.Свойство);
	
КонецПроцедуры

Процедура СвойстваСобытияВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	мДобавлениеНовыхАтрибутов = Ложь;
	ОткрытьФормуРедактированияУсловий("УсловияЗаписиСвойства", ЭлементыФормы.ТабличноеПолеСписокСвойств, ВыбраннаяСтрока.Свойство);
	
КонецПроцедуры

// Сравнение - Строка - во внутренних кодах (eq, gt и т.д.)
Процедура УстановитьЭлементОтбораВВыделенныхГруппахИ(Свойство, ЗначениеСвойства, Сравнение = "eq", СтрокиГрупп = Неопределено) Экспорт 
	
	ЭлементыФормы.ПанельОтборСобытий.ТекущаяСтраница = ЭлементыФормы.ПанельОтборСобытий.Страницы.Детальный;
	Если СтрокиГрупп = Неопределено Тогда
		Массив = ЭлементыФормы.ТабличноеПолеСписокСобытий.ВыделенныеСтроки;
	ИначеЕсли ТипЗнч(СтрокиГрупп) = Тип("СтрокаТаблицыЗначений") Тогда
		Массив = Новый Массив();
		Массив.Добавить(СтрокиГрупп);
	Иначе
		Массив = СтрокиГрупп;
	КонецЕсли; 
	СтруктураАтрибутов = Новый Структура("property, value", НРег(Свойство), ЗначениеСвойства);
	Для Каждого СтрокаГруппыИли Из Массив Цикл
		УзелГруппыИ = ПолучитьУзелСобытия(ТекущийЖурнал, ТабличноеПолеСписокСобытий.Индекс(СтрокаГруппыИли));
		УзелУсловия = Неопределено;
		Если Истина
			И Не ирОбщий.СтрокиРавныЛкс(Сравнение, "ne") 
			И Не ирОбщий.СтрокиРавныЛкс(Сравнение, "like")
		Тогда
			// Для сравнения на равенство имеет смысл проверять уникальность элемента отбора по имени свойства
			УзелУсловия = УзелГруппыИ.ПервыйДочерний;
			Пока УзелУсловия <> Неопределено Цикл
				Если ирОбщий.СтрокиРавныЛкс(Сравнение, УзелУсловия.ЛокальноеИмя) Тогда
					АтрибутИмениСобытия = УзелУсловия.Атрибуты.ПолучитьИменованныйЭлемент("property");
					Если Истина
						И АтрибутИмениСобытия <> Неопределено 
						И НРег(АтрибутИмениСобытия.ЗначениеУзла) = НРег(Свойство)
					Тогда
						Прервать;
					КонецЕсли; 
				КонецЕсли; 
				УзелУсловия = УзелУсловия.СледующийСоседний;
			КонецЦикла;
		КонецЕсли; 
		Если УзелУсловия = Неопределено Тогда
			НайтиДобавитьУзелСАтрибутами(Ложь, , УзелГруппыИ, Сравнение, СтруктураАтрибутов);
		Иначе
			Для каждого Атрибут Из СтруктураАтрибутов Цикл
				УзелУсловия.УстановитьАтрибут(Атрибут.Ключ, XMLСтрока(Атрибут.Значение));
			КонецЦикла;
		КонецЕсли; 
		ОбновитьПредставлениеСобытияВСтрокеГруппыИли(СтрокаГруппыИли);
		ЭтаФорма.Модифицированность = Истина;
	КонецЦикла;
	ОбновитьПредставлениеОтбораСобытий();
	ТабличноеПолеСписокСобытийПриАктивизацииСтроки(ЭлементыФормы.ТабличноеПолеСписокСобытий);
	
КонецПроцедуры

Процедура КП_ДетальныйФильтрСобытийТекущийСеанс(Кнопка = Неопределено) Экспорт
	
	УстановитьЭлементОтбораВВыделенныхГруппахИ("sessionID", НомерСеансаИнформационнойБазы());
	
КонецПроцедуры

Процедура КП_ДетальныйФильтрСобытийТекущийПользователь(Кнопка = Неопределено) Экспорт
	
	ИмяПользователя = ИмяПользователя();
	Если ЗначениеЗаполнено(ИмяПользователя) Тогда
		УстановитьЭлементОтбораВВыделенныхГруппахИ("usr", ИмяПользователя);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_ДетальныйФильтрСобытийТекущаяБаза(Кнопка = Неопределено) Экспорт
	
	ИмяБазы = НСтр(СтрокаСоединенияИнформационнойБазы(), "Ref");
	УстановитьЭлементОтбораВВыделенныхГруппахИ("p:processname", ИмяБазы);
	
КонецПроцедуры

Процедура ТабличноеПолеСписокСобытийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если ПараметрыПеретаскивания <> Неопределено Тогда
		Если Метаданные.НайтиПоТипу(ТипЗнч(ПараметрыПеретаскивания.Значение)) <> Неопределено Тогда
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
		Иначе
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
			ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.КопированиеИПеремещение;
		КонецЕсли; 
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТабличноеПолеСписокСобытийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если Строка <> Неопределено Тогда
		ЗначениеПеретаскивания = ПараметрыПеретаскивания.Значение;
		Если ЗначениеПеретаскивания <> Неопределено Тогда
			Если ТипЗнч(ЗначениеПеретаскивания) <> Тип("Массив") Тогда
				Массив = Новый Массив();
				Массив.Добавить(ЗначениеПеретаскивания);
			Иначе
				Массив = ЗначениеПеретаскивания;
			КонецЕсли; 
			Для Каждого ЭлементМассива Из Массив Цикл
				Если НРег(ЭлементМассива.Свойство) = "name" Тогда
					Продолжить;
				КонецЕсли; 
				УстановитьЭлементОтбораВВыделенныхГруппахИ(ЭлементМассива.Свойство, ЭлементМассива.Значение, ЭлементМассива.Сравнение, Строка);
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_ДетальныйФильтрСобытийДлительность(Кнопка)
	
	Длительность = 0;
	Если ВвестиЧисло(Длительность, "Миним. длительность в милисекундах") Тогда 
		УстановитьЭлементОтбораВВыделенныхГруппахИ("Duration", XMLСтрока(Длительность * 10), "gt");
	КонецЕсли;
	
КонецПроцедуры

Процедура РедактированиеУсловийСобытияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УстановитьЭлементОтбораСобытий(РедактированиеУсловийСобытия, мТекущийИндексУзлаСобытия, ЭлементыФормы.ТабличноеПолеСписокСобытий.ТекущаяСтрока);

КонецПроцедуры

Процедура СобытияПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.События.ТекущаяСтрока;
	ИмяСобытия = Неопределено;
	Если ТекущаяСтрока <> Неопределено Тогда 
		ИмяСобытия = ТекущаяСтрока.Имя;
	КонецЕсли; 
	ОбновитьОтборДоступныхСвойств(ИмяСобытия);
	
КонецПроцедуры

Процедура РедактированиеУсловийСобытияПослеУдаления(Элемент)
	
	УстановитьЭлементОтбораСобытий(РедактированиеУсловийСобытия, мТекущийИндексУзлаСобытия, ЭлементыФормы.ТабличноеПолеСписокСобытий.ТекущаяСтрока);
	
КонецПроцедуры

Процедура ИзменитьПометкиВыделенныхСтрокСобытий(НовоеЗначениеПометки = Истина) Экспорт 
	
	ИмяКолонкиПометки = "Пометка";
	ТабличноеПоле = ЭлементыФормы.События;
	ВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() < 2 Тогда
		ВыделенныеСтроки = ТабличноеПоле.Значение; 
		Попытка
			ОтборСтрок = ТабличноеПоле.ОтборСтрок;
		Исключение
		КонецПопытки; 
		Если ОтборСтрок <> Неопределено Тогда
			Построитель = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(ТабличноеПоле);
			#Если Сервер И Не Сервер Тогда
			    Построитель = Новый ПостроительЗапроса;
			#КонецЕсли
			Построитель.ВыбранныеПоля.Очистить();
			Построитель.ВыбранныеПоля.Добавить("НомерСтроки");
			НомераОтобранныхСтрок = Построитель.Результат.Выгрузить();
			НомераОтобранныхСтрок.Индексы.Добавить("НомерСтроки");
		КонецЕсли; 
	КонецЕсли; 
	Для каждого СтрокаТЧ из ВыделенныеСтроки Цикл
		Если Истина
			И НомераОтобранныхСтрок <> Неопределено
			И НомераОтобранныхСтрок.Найти(СтрокаТЧ.НомерСтроки, "НомерСтроки") = Неопределено
		Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаТЧ[ИмяКолонкиПометки] = НовоеЗначениеПометки;
		УстановитьРегистрациюСобытия(СтрокаТЧ.Имя, НовоеЗначениеПометки);
	КонецЦикла;
	
КонецПроцедуры

Процедура КоманднаяПанельСобытияУстановитьФлажки(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрокСобытий(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельСобытияСнятьФлажки(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрокСобытий(Ложь);

КонецПроцедуры

Процедура РедактированиеУсловийСобытияЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	НачалоВыбораЗначенияСвойства(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирНастройкаТехножурнала.Форма.НастройкаКаталога");
ЗаполнитьСписокВыбораСрокаХранения(ЭлементыФормы.ВремяХраненияЖурнала.СписокВыбора);
ЭлементыФормы.События.ОтборСтрок.Пометка.Значение = Истина;