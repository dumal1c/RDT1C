﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ
Перем ТаблицаСсылок;

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ

// Устанавливает доступность элементов управления в зависимости от режима
//
Процедура вДоступностьКнопок() 
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Контроль.Доступность = УдаляемыеОбъекты.Количество() > 0;
	ЕстьУдаляемые = УдаляемыеОбъекты.Найти(Истина, "Удаляется") <> Неопределено;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить.Доступность = ЕстьУдаляемые;
	
КонецПроцедуры

// Выполняет поиск помеченных на удаление объектов
// и заполняет ими таблицу УдаляемыеОбъекты
//
Функция вОбновитьПомеченныеНаУдаление()
	
	НачальноеЗначениеВыбора = ТипыДляЗаполненияКандидатов.ВыгрузитьЗначения();
	мПлатформа = ирКэш.Получить();
	Форма = мПлатформа.ПолучитьФорму("ВыборОбъектаМетаданных");
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", НачальноеЗначениеВыбора);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	МассивРазрешенныхТипов = Форма.ОткрытьМодально();
	#Если _ Тогда
	    МассивРазрешенныхТипов = Новый Массив;
	#КонецЕсли
	Если МассивРазрешенныхТипов = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	ТипыДляЗаполненияКандидатов.ЗагрузитьЗначения(МассивРазрешенныхТипов);
	
	ДатаНачала = ТекущаяДата();
	Состояние("Выполняется поиск объектов, помеченных на удаление...");
	СсылкиНаКандидата.Очистить();
	УдаляемыеОбъекты.Очистить();
	ПослеИзмененияСоставаКонтролируемыхОбъектов();
	СоответствиеТипаКМетаданному = Новый Соответствие;
	Попытка
		//Если мПлатформа.ИДВерсииПлатформы = "83" Тогда
		//	// Баг платформы 8.3 https://partners.v8.1c.ru/forum/t/1438019/m/1438019
		//	ПомеченныеОбъекты = НайтиПомеченныеНаУдаление(, ЗначениеВыбора);
		//Иначе
			ПомеченныеОбъекты = НайтиПомеченныеНаУдаление();
		//КонецЕсли; 
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	Если МассивРазрешенныхТипов.Количество() > 0 Тогда
		РазрешенныеТипы = Новый Соответствие;
		Для Каждого ПолноеИмяМД Из МассивРазрешенныхТипов Цикл
			РазрешенныеТипы[Тип(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(ПолноеИмяМД))] = 1;
		КонецЦикла;
		МассивКУдалению = Новый Массив;
		Для Каждого ПомеченныйОбъект Из ПомеченныеОбъекты Цикл
			Если РазрешенныеТипы[ТипЗнч(ПомеченныйОбъект)] = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			МассивКУдалению.Добавить(ПомеченныйОбъект);
		КонецЦикла;
	Иначе
		МассивКУдалению = ПомеченныеОбъекты;
	КонецЕсли; 
	Длительность = ТекущаяДата() - ДатаНачала;
	Если Длительность > 60 Тогда
		Сообщить("Поиск ссылок выполнен за " + XMLСтрока(Длительность) + "с. Найдено " + XMLСтрока(МассивКУдалению.Количество()) + " ссылок.");
	КонецЕсли; 
	ДобавитьМассивОбъектовВУдаляемыеОбъекты(МассивКУдалению, ЭтаФорма, Истина);
	ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок.Сбросить();
	вДоступностьКнопок();
	ПослеИзмененияСоставаКандидатов();
	Возврат Истина;
	
КонецФункции

// Выполняет поиск ссылок на помеченные на удаление объекты,
// заполняет ими таблицу значений "ТаблицаСсылок",
// производит контроль на возможность удаления
//
Процедура вКонтроль()
	
	ТаблицаСсылок = КонтролироватьСсылкиНаКандидаты(ЭтаФорма);
	ЭтаФорма.НеобходимоВыполнитьКонтроль = Ложь;
	вДоступностьКнопок();
	вПодсчитатьИтогУдаляемыеОбъекты();
	вПоказатьСсылкиНаУдаляемыйОбъект();
	
КонецПроцедуры

// Подсчитывает количество Помеченных, Выбранных, Удаляемых и НеУдаляемых объектов
//
Процедура вПодсчитатьИтогУдаляемыеОбъекты()
	
	ТекстНадписи =  "Без учета отбора Всего: " + УдаляемыеОбъекты.Количество() +",  Разрешено удалять: " + УдаляемыеОбъекты.Итог("Разрешен");
	Если ТаблицаСсылок <> Неопределено Тогда
		КоличествоУдаляемых = УдаляемыеОбъекты.НайтиСтроки(Новый Структура("Удаляется", Истина)).Количество();
		ТекстНадписи = ТекстНадписи + ",  Возможно удалить: " + КоличествоУдаляемых + ",  Невозможно удалить: " + (УдаляемыеОбъекты.Количество() - КоличествоУдаляемых);
	КонецЕсли;
	ЭлементыФормы.НадписьОбъекты.Значение = ТекстНадписи;
	
КонецПроцедуры

Процедура ПослеИзмененияСоставаКонтролируемыхОбъектов()
	
	ЭтаФорма.НеобходимоВыполнитьКонтроль = Истина;
	вДоступностьКнопок();
	вПодсчитатьИтогУдаляемыеОбъекты();
	
КонецПроцедуры

Процедура ПослеИзмененияСоставаКандидатов()
	
	УдаляемыеОбъекты.Сортировать("Метаданные, Представление");
	ПослеИзмененияСоставаКонтролируемыхОбъектов();

КонецПроцедуры

// Подсчитывает количество Найденных, Удаляемых и НеУдаляемых ссылок на текущий объектов
//
Процедура вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты()
	
	СтрокаУдаляемыхОбъектов = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные;
	Если СтрокаУдаляемыхОбъектов = Неопределено или ТаблицаСсылок = Неопределено Тогда
		ЭлементыФормы.НадписьСсылки.Значение = "";
	Иначе
		ЭлементыФормы.НадписьСсылки.Значение = "Найдено: " + СтрокаУдаляемыхОбъектов.Ссылок
		+ ",   Удаляемых: " + (СтрокаУдаляемыхОбъектов.Ссылок - СтрокаУдаляемыхОбъектов.НеУдаляемыхСсылок)
		+ ",   Неудаляемых: " + СтрокаУдаляемыхОбъектов.НеУдаляемыхСсылок;
	КонецЕсли;
	
КонецПроцедуры

// Показывает ссылки в таблице СсылкиНаУдаляемыеОбъекты
// на текущий удаляемый объект из таблицы УдаляемыеОбъекты
//
Процедура вПоказатьСсылкиНаУдаляемыйОбъект()
	
	СтрокаУдаляемыхОбъектов = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные;
	СсылкиНаКандидата.Очистить();
	Если ТаблицаСсылок = Неопределено или СтрокаУдаляемыхОбъектов = Неопределено Тогда
		
	Иначе
		МассивСсылок = ТаблицаСсылок.НайтиСтроки(Новый Структура("Ссылка",СтрокаУдаляемыхОбъектов.Ссылка));
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МассивСсылок.Количество(), "Загрузка ссылающихся объектов");
		Для каждого Строка Из МассивСсылок Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			НоваяСтрока = СсылкиНаКандидата.Добавить();
			НоваяСтрока.Ссылка = Строка.Ссылка;
			НоваяСтрока.Данные = Строка.Данные;
			НоваяСтрока.Метаданные = Строка.Метаданные.ПолноеИмя();
			НоваяСтрока.ИндексКартинки = Строка.ИндексКартинки;
			НоваяСтрока.ЕстьВКандидатах = УдаляемыеОбъекты.Найти(НоваяСтрока.Данные, "Ссылка") <> Неопределено;
			НоваяСтрока.Блокирует = Не Строка.Удаляется И НеблокирующиеТипы.Найти(НоваяСтрока.Метаданные, "Метаданные") = Неопределено;
			Если Не СтандартныйПоискСсылок Тогда
				НоваяСтрока.уваОбъектСвязи = Строка.ОбъектСвязи;
			КонецЕсли; 
			НоваяСтрока.ГлобальныйИндексСсылки = ТаблицаСсылок.Индекс(Строка);
		КонецЦикла; 
		СсылкиНаКандидата.Сортировать("Метаданные");
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли; 
	вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты();
	
КонецПроцедуры // () 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура вызывается при нажатии кнопки "Контроль" Основных действий формы,
//
Процедура ОсновныеДействияФормыКонтроль(Кнопка)
	
	Ответ = Вопрос("Выполнить после контроля удаление объектов, которые возможно удалить?", РежимДиалогаВопрос.ДаНетОтмена);
	Если Ответ <>  КодВозвратаДиалога.Отмена Тогда
		ПодключитьОбработчикОжидания("СброситьКолонкуУдаляется", 0.1, Истина);
		вКонтроль();
		ОтключитьОбработчикОжидания("СброситьКолонкуУдаляется");
		Если Истина
			И Не НеобходимоВыполнитьКонтроль
			И Ответ = КодВозвратаДиалога.Да
			И ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить.Доступность
		Тогда 
			ОсновныеДействияФормыУдалить();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура СброситьКолонкуУдаляется()
	
	Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
		СтрокаУдаляемогоОбъекта.Удаляется = Ложь;
	КонецЦикла;

КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Удалить" Основных действий формы,
//
Процедура ОсновныеДействияФормыУдалить(Кнопка = Неопределено)
	
	УдалитьОбъектыЛкс();
	вДоступностьКнопок();
	вПодсчитатьИтогУдаляемыеОбъекты();
	
КонецПроцедуры

// Процедура вызывается при изменении флажков:
//	ПоказыватьОбъектыКоторыеМожноУдалить,ПоказыватьОбъектыКоторыеНельзяУдалить
//
Процедура ПоказыватьОбъектыПриИзменении(Элемент)
	
	Если Истина
		И Не ПоказыватьОбъектыКоторыеМожноУдалить
		И Не ПоказыватьОбъектыКоторыеНельзяУдалить
	Тогда
		Если Элемент = ЭлементыФормы.ПоказыватьОбъектыКоторыеМожноУдалить Тогда
			ЭтаФорма.ПоказыватьОбъектыКоторыеНельзяУдалить = Истина;
		Иначе
			ЭтаФорма.ПоказыватьОбъектыКоторыеМожноУдалить = Истина;
		КонецЕсли; 
	КонецЕсли; 
	ОтборСтрок = ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок;
	Если ПоказыватьОбъектыКоторыеМожноУдалить И ПоказыватьОбъектыКоторыеНельзяУдалить тогда
		ОтборСтрок.Удаляется.Использование = Ложь;
		ОтборСтрок.Разрешен.Использование = Ложь;
	ИначеЕсли ПоказыватьОбъектыКоторыеНельзяУдалить тогда
		ОтборСтрок.Удаляется.Установить(Ложь, Истина);
		ОтборСтрок.Разрешен.Использование = Ложь;
	Иначе
		ОтборСтрок.Удаляется.Установить(Истина, Истина);
		ОтборСтрок.Разрешен.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается при изменении флажков:
//	ПоказыватьСсылкиУдаляемых,ПоказыватьСсылкиНеудаляемых
//
Процедура ПоказыватьСсылкиПриИзменении(Элемент)
	
	Если Истина
		И Не ПоказыватьСсылкиУдаляемых
		И Не ПоказыватьСсылкиНеудаляемых
	Тогда
		Если Элемент = ЭлементыФормы.ПоказыватьСсылкиНеудаляемых Тогда
			ЭтаФорма.ПоказыватьСсылкиУдаляемых = Истина;
		Иначе
			ЭтаФорма.ПоказыватьСсылкиНеудаляемых = Истина;
		КонецЕсли; 
	КонецЕсли; 
	Если Истина
		И ПоказыватьСсылкиУдаляемых
		И ПоказыватьСсылкиНеудаляемых
	Тогда
		ЭлементыФормы.СсылкиНаКандидата.ОтборСтрок.Блокирует.Использование = Ложь;
	Иначе 
		ЭлементыФормы.СсылкиНаКандидата.ОтборСтрок.Блокирует.Установить(Не ПоказыватьСсылкиУдаляемых, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ "КоманднаяПанельУдаляемыхОбъектов"

// Процедура вызывается при нажатии кнопки "Обновить" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовОбновить(Кнопка)
	вОбновитьПомеченныеНаУдаление();
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Установить Флажки" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Разрешен", Истина);
	ПослеИзмененияСоставаКонтролируемыхОбъектов();
	
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Снять Флажки" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовСнятьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Разрешен", Ложь);
	ПослеИзмененияСоставаКонтролируемыхОбъектов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОЙ ЧАСТИ "Удаляемые Объекты"

// Процедура вызывается при активизации строки табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриАктивизацииСтроки(Элемент)
	вПоказатьСсылкиНаУдаляемыйОбъект();
КонецПроцедуры

// Процедура вызывается при выоде строки табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Картинка;
	ЯчейкаКартинки.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
	ЯчейкаКартинки.ОтображатьКартинку = Истина;
	Если ТаблицаСсылок <> Неопределено и ДанныеСтроки.Разрешен Тогда
		//Если ДанныеСтроки.Удаляется Тогда
			ОформлениеСтроки.ЦветФона = Новый Цвет(240, 255, 240);
		//КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается перед началом изменения табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущаяКолонка.ДанныеФлажка <> "Разрешен" Тогда
		ФормаОбъекта = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные.ссылка.ПолучитьФорму(,,);
		ФормаОбъекта.Открыть();
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

// Процедура вызывается при изменении флажка табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриИзмененииФлажка(Элемент, Колонка)
	ПослеИзмененияСоставаКонтролируемыхОбъектов();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОЙ ЧАСТИ "Ссылки на удаляемые объекты"

// Процедура вызывается при выоде строки табличного поля "Ссылки на удаляемые объекты"
//
Процедура СсылкиНаУдаляемыеОбъектыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Ячейки = ОформлениеСтроки.Ячейки;
	Ячейки.Блокирует.ОтображатьТекст = Ложь;
	Если Не ДанныеСтроки.Блокирует Тогда
		Ячейки.Блокирует.УстановитьКартинку(ирОбщий.ПолучитьОбщуюКартинкуЛкс("ирТестирование"));
	Иначе
		Ячейки.Блокирует.УстановитьКартинку(ирОбщий.ПолучитьОбщуюКартинкуЛкс("ирИсключение"));
	КонецЕсли;
	Ячейки.Картинка.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
	Ячейки.Картинка.ОтображатьКартинку = Истина;
КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовПометитьУказанноеКоличество(Кнопка)
	
	Если ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
	// запрашивает сколько пометить и помечает от текущей строки
	Колво = 300;
	Если Не ВвестиЧисло(Колво,"Количество помечаемых", 6, 0) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаОтборанных = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(ЭлементыФормы.УдаляемыеОбъекты).Результат.Выгрузить();
	ТаблицаОтборанных.Индексы.Добавить("Ссылка");
	// бежим от текущей строки помечаем
	Для К = ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока.НомерСтроки ПО УдаляемыеОбъекты.Количество() Цикл
		СтрокаУдаляемогоОбъекта = УдаляемыеОбъекты[К-1];
		Если ТаблицаОтборанных.Найти(СтрокаУдаляемогоОбъекта.Ссылка, "Ссылка") <> Неопределено Тогда
			СтрокаУдаляемогоОбъекта.Разрешен = Истина;
			Колво = Колво - 1;
		КонецЕсли;
		Если Колво <= 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ПослеИзмененияСоставаКонтролируемыхОбъектов();
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыРедакторОбъектаБД(Кнопка = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.СсылкиНаКандидата.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	//ОткрытьСсылающийсяОбъектВРедактореОбъектаБД(ТекущаяСтрока);
	КлючОбъекта = ПолучитьКлючСсылающегосяОбъекта(ТекущаяСтрока);
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъекта, ТекущаяСтрока.Ссылка);

КонецПроцедуры

Функция ПолучитьКлючСсылающегосяОбъекта(Знач ТекущаяСтрока, НуженОбъект = Истина)
	
	ТипМетаданных = ирОбщий.ПолучитьПервыйФрагментЛкс(ТекущаяСтрока.Метаданные);
	Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипМетаданных) Тогда
		КлючОбъекта = ТекущаяСтрока.Данные;
	ИначеЕсли ирОбщий.ЛиКорневойТипКонстантыЛкс(ТипМетаданных) Тогда
		КлючОбъекта = Новый (СтрЗаменить(ТекущаяСтрока.Метаданные, ".", "МенеджерЗначения."));
	Иначе // Регистр сведений
		КлючОбъекта = ТаблицаСсылок[ТекущаяСтрока.ГлобальныйИндексСсылки].КлючЗаписиРегистраСведений;
		Если НуженОбъект Тогда
			КлючОбъекта = ирОбщий.ПолучитьНаборЗаписейПоКлючуЛкс(ТекущаяСтрока.Метаданные, КлючОбъекта);
		КонецЕсли; 
	КонецЕсли;
	Возврат КлючОбъекта;

КонецФункции

Процедура КоманднаяПанельУдаляемыхОбъектовОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура УдаляемыеОбъектыСсылкаПриИзменении(Элемент)
	
	ОбновитьСтрокуУдаляемогоОбъекта(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.ЗаписьНаСервере.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс() Или ирПортативный.ЛиСерверныйМодульДоступенЛкс();
	ПослеИзмененияСоставаКандидатов();
	Если УдаляемыеОбъекты.Количество() = 0 Тогда
		Ответ = Вопрос("Поиск помеченных на удаление может занять продолжительное время!
		|Выполнить его сейчас?", РежимДиалогаВопрос.ДаНет, 10);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			вОбновитьПомеченныеНаУдаление();
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовПодбор(Кнопка)
	
	Если ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока <> Неопределено Тогда
		НачальноеЗначение = ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока.Ссылка;
	КонецЕсли; 
	ирОбщий.ОткрытьПодборСВыборомТипаЛкс(ЭлементыФормы.УдаляемыеОбъекты,, НачальноеЗначение);
	
КонецПроцедуры

Процедура УдаляемыеОбъектыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Массив = Новый Массив();
		Массив.Добавить(ВыбранноеЗначение);
		ВыбранноеЗначение = Массив;
	КонецЕсли;
	Если ДобавитьМассивОбъектовВУдаляемыеОбъекты(ВыбранноеЗначение, ЭтаФорма, Истина) Тогда 
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 

КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыДобавитьВКандидаты(Кнопка)
	
	МассивОбъектов = Новый Массив;
	Для Каждого ВыбраннаяСтрока Из ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки Цикл
		МассивОбъектов.Добавить(ВыбраннаяСтрока.Данные);
	КонецЦикла;
	ДобавитьМассивОбъектовВУдаляемыеОбъекты(МассивОбъектов, ЭтаФорма,, Истина);
	//Для Каждого ВыбраннаяСтрока Из ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки Цикл
	//	МассивОбъектов.Добавить(ВыбраннаяСтрока.Данные);
	//КонецЦикла;
	вПоказатьСсылкиНаУдаляемыйОбъект();
	ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки.Очистить();
	Для Каждого ВыделенныйОбъект Из МассивОбъектов Цикл
		СтрокаОбъекта = СсылкиНаКандидата.Найти(ВыделенныйОбъект, "Данные");
		Если СтрокаОбъекта <> Неопределено Тогда
			ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки.Добавить(СтрокаОбъекта);
			ЭлементыФормы.СсылкиНаКандидата.ТекущаяСтрока = СтрокаОбъекта;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыНайтиСсылкуВУдаляемыхОбъектах(Кнопка)
	
	Если ЭлементыФормы.СсылкиНаКандидата.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаУдаляемого = УдаляемыеОбъекты.Найти(ЭлементыФормы.СсылкиНаКандидата.ТекущаяСтрока.Данные, "Ссылка");
	Если СтрокаУдаляемого <> Неопределено Тогда
		ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока = СтрокаУдаляемого;
	Иначе
		Предупреждение("Данные не найдены в удаляемых объектах");
	КонецЕсли; 
	
КонецПроцедуры

Процедура СсылкиНаУдаляемыеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.Данные = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		КП_СсылкиНаУдаляемыеОбъектыРедакторОбъектаБД();
	Иначе
		//ФормаОбъекта = ВыбраннаяСтрока.Данные.ПолучитьФорму(,,);
		//ФормаОбъекта.Открыть();
		ОткрытьЗначение(ВыбраннаяСтрока.Данные);
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовРедакторОбъектаБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ТекущаяСтрока.Ссылка);
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыКонсольОбработки(Кнопка)
	
	МассивКлючей = Новый Массив;
	Для Каждого ВыбраннаяСтрока Из ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки Цикл
		МассивКлючей.Добавить(ПолучитьКлючСсылающегосяОбъекта(ВыбраннаяСтрока, Ложь));
	КонецЦикла;
	ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(МассивКлючей);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.УдаляемыеОбъекты);
	
КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.УдаляемыеОбъекты, ЭтаФорма);
	
КонецПроцедуры

Процедура НеблокирующиеТипыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	РедактироватьНеблокирующиеТипы();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура РедактироватьНеблокирующиеТипы()
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", , ЭтаФорма);
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", НеблокирующиеТипы.ВыгрузитьКолонку("Метаданные"));
	лСтруктураПараметров.Вставить("ОтображатьКонстанты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПоследовательности", Истина);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	РезультатФормы = Форма.ОткрытьМодально();
	Если ТипЗнч(РезультатФормы) = Тип("Массив") Тогда
		УстановитьНеблокирующиеТипы(РезультатФормы);
	КонецЕсли;

КонецПроцедуры

Процедура КПНеблокирующиеТипыИзменить(Кнопка)
	
	РедактироватьНеблокирующиеТипы();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыДобавитьВНеблокирующие(Кнопка)
	
	Ответ = Вопрос("Вы действитель хотите добавить типы выбранных объектов в неблокирующие типы?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	Для Каждого ВыбраннаяСтрока Из ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки Цикл
		Если НеблокирующиеТипы.Найти(ВыбраннаяСтрока.Метаданные) = Неопределено Тогда
			СтрокаНеблокурующегоТипа = НеблокирующиеТипы.Добавить();
			СтрокаНеблокурующегоТипа.Метаданные = ВыбраннаяСтрока.Метаданные;
		КонецЕсли;
	КонецЦикла;
	НеблокирующиеТипы.Сортировать("Метаданные");
	ПослеИзмененияСоставаКандидатов();
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиИзСтруктуры(СтруктураНастроек)
	
	УдаляемыеОбъекты.Очистить();
	ТаблицаКандидатов = ОбновитьДанныеКандидатов(СтруктураНастроек.УдаляемыеОбъекты);
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ТаблицаКандидатов, УдаляемыеОбъекты);
	ПослеИзмененияСоставаКандидатов();
	
КонецПроцедуры

Функция ПолучитьСтруктуруНастроекОбработки()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("УдаляемыеОбъекты", УдаляемыеОбъекты.Выгрузить());
	Возврат СтруктураНастроек;
	
КонецФункции

Процедура КоманднаяПанельУдаляемыхОбъектовОткрытьФайл(Кнопка)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Заголовок = "Выберите файл для загрузки настроек обработки";
	ДиалогВыбораФайла.Фильтр = ирОбщий.ПолучитьСтрокуФильтраДляВыбораФайлаЛкс("dor", "Файл удаления объектов с контролем ссылок");
	ДиалогВыбораФайла.Расширение = "dor";
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Поток = Новый ЧтениеXML;
		Поток.ОткрытьФайл(ДиалогВыбораФайла.ПолноеИмяФайла);
		Попытка
			СтруктураНастроек = СериализаторXDTO.ПрочитатьXML(Поток);
		Исключение
			Сообщить("Ошибка чтения настроек из файла: " + ОписаниеОшибки());
			Возврат;
		КонецПопытки; 
		Поток.Закрыть();
		ЗагрузитьНастройкиИзСтруктуры(СтруктураНастроек);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовСохранить(Кнопка)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.Заголовок = "Укажите файл для сохранения настроек обработки";
	ДиалогВыбораФайла.Фильтр = ирОбщий.ПолучитьСтрокуФильтраДляВыбораФайлаЛкс("dor", "Файл удаления объектов с контролем ссылок");
	ДиалогВыбораФайла.Расширение = "fdr";
	Если ДиалогВыбораФайла.Выбрать() Тогда
		СтруктураНастроек = ПолучитьСтруктуруНастроекОбработки();
		Поток = Новый ЗаписьXML;
		Поток.ОткрытьФайл(ДиалогВыбораФайла.ПолноеИмяФайла,);
		СериализаторXDTO.ЗаписатьXML(Поток, СтруктураНастроек);
		Поток.Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовОтобратьПоТипам(Кнопка)
	
	ирОбщий.ИзменитьОтборКлиентаПоМетаданнымЛкс(ЭлементыФормы.УдаляемыеОбъекты);
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.СсылкиНаКандидата, ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыОтобратьПоТипам(Кнопка)
	
	ирОбщий.ИзменитьОтборКлиентаПоМетаданнымЛкс(ЭлементыФормы.СсылкиНаКандидата);

КонецПроцедуры

Процедура НеблокирующиеТипыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Игнорировать.ТолькоПросмотр = ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(ДанныеСтроки.Метаданные));

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовОчистить(Кнопка)
	
	Ответ = Вопрос("Вы уверены, что хотите очистить список кандидатов?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		УдаляемыеОбъекты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовОбработкаОбъектов(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭтаФорма.ЭлементыФормы.УдаляемыеОбъекты, "Ссылка");
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУдалениеОбъектовСКонтролемСсылок.Форма.Форма");
ЭтаФорма.ПоказыватьОбъектыКоторыеМожноУдалить = Истина;
ЭтаФорма.ПоказыватьОбъектыКоторыеНельзяУдалить = Истина;
ЭтаФорма.ПоказыватьСсылкиУдаляемых = Истина;
ЭтаФорма.ПоказыватьСсылкиНеудаляемых = Истина;
ЭтаФорма.ВыводитьСообщения = Истина;
