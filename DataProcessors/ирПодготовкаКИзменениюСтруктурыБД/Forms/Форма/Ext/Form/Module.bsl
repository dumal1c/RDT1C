﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяГруппа;
Перем мТекущийРегистр;
Перем мТекущийПВХ;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ВыполнятьВТранзакции, Реквизит.ИзменяемыеИзмерения, Реквизит.УдаляемыеТипы";
	Возврат Неопределено;
КонецФункции

Процедура УстановитьТолькоПросмотрКолонок(ТабличноеПоле)

	Для Каждого Колонка Из ТабличноеПоле.Колонки Цикл
		Колонка.ТолькоПросмотр = Истина;
	КонецЦикла;

КонецПроцедуры // УстановитьТолькоПросмотрКолонок()

Процедура ВывестиСоставРегистра(НовыйТекущийРегистр = Неопределено)
	
	Если НовыйТекущийРегистр <> Неопределено Тогда
		мТекущийРегистр = НовыйТекущийРегистр;
	КонецЕсли;
	ГруппыТекущегоРегистра.Очистить();
	//ЭлементыФормы.ГруппыТекущегоРегистра.ТолькоПросмотр = (мТекущийРегистр = Неопределено);
	Если мТекущийРегистр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мЗапрос.Текст = "ВЫБРАТЬ * ИЗ " + мТекущийРегистр.Имя;
	ГруппыТекущегоРегистра = мЗапрос.Выполнить().Выгрузить();
	ЭлементыФормы.ПроблемныеРегистры.ТекущаяСтрока = мТекущийРегистр;
	Если ГруппыТекущегоРегистра.Колонки.Найти("НомерГруппы") = Неопределено Тогда
		ГруппыТекущегоРегистра.Колонки.Вставить(0, "НомерГруппы");
	КонецЕсли; 
	
	МетаРегистр = Метаданные.РегистрыСведений[мТекущийРегистр.Имя];
	ПоляБД = ирОбщий.ПоляТаблицыМДЛкс(МетаРегистр.ПолноеИмя());
	Для Каждого ПолеБД Из ПоляБД Цикл
		мСтруктураПредставлений.Вставить(ПолеБД.Имя, ПолеБД.Заголовок);
	КонецЦикла;
	
	УстановитьПредставленияКолонок(ГруппыТекущегоРегистра);
	Для Счетчик = 1 По ГруппыТекущегоРегистра.Количество() Цикл
		ГруппыТекущегоРегистра[Счетчик - 1].НомерГруппы = Счетчик;
	КонецЦикла;
		
	ЭлементыФормы.ГруппыТекущегоРегистра.СоздатьКолонки();
	УстановитьТолькоПросмотрКолонок(ЭлементыФормы.ГруппыТекущегоРегистра);
	Если ГруппыТекущегоРегистра.Количество() > 0 Тогда
		ВывестиСоставГруппы(ГруппыТекущегоРегистра[0]);
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыГруппыТекущегоРегистра.Заголовок, , 
		Строка(ГруппыТекущегоРегистра.Количество()) + ")", "(");
		
КонецПроцедуры

Процедура ВывестиСоставПВХ(НовыйТекущийПВХ = Неопределено)
	
	Если НовыйТекущийПВХ <> Неопределено Тогда
		мТекущийПВХ = НовыйТекущийПВХ;
	КонецЕсли;
	ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.Очистить();
	Если мТекущийПВХ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст = "
	|ВЫБРАТЬ 
	|	* 
	|ИЗ 
	|	ПланВидовХарактеристик." + мТекущийПВХ.Имя + " КАК _Таблица_ 
	|	ГДЕ 
	|	_Таблица_.Ссылка В (&СписокОтбора)";
	ПостроительЗапроса.ЗаполнитьНастройки();
	ОтобранныеСсылки = мЗатронутыеЭлементыПВХ.Скопировать(Новый Структура("Имя", мТекущийПВХ.Имя)).ВыгрузитьКолонку("Ссылка");
	ПостроительЗапроса.Параметры.Вставить("СписокОтбора", ОтобранныеСсылки);
	ПостроительЗапроса.Выполнить();
	ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик = ПостроительЗапроса.Результат.Выгрузить();
	ЭлементыФормы.ПроблемныеПланыВидовХарактеристик.ТекущаяСтрока = мТекущийПВХ;
	ЭлементыФормы.ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.СоздатьКолонки();
	УстановитьТолькоПросмотрКолонок(ЭлементыФормы.ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик);
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.Заголовок, ,
		Строка(ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.Количество()) + ")", "(");
	
КонецПроцедуры

Процедура ВывестиСоставГруппы(НоваяТекущаяГруппа = Неопределено)
	
	Если НоваяТекущаяГруппа <> Неопределено Тогда
		мТекущаяГруппа = НоваяТекущаяГруппа;
	КонецЕсли;
	ЭлементыТекущейГруппы.Очистить();
	//ЭлементыФормы.ЭлементыТекущейГруппы.ТолькоПросмотр = (мТекущаяГруппа = Неопределено);
	Если мТекущаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭлементыТекущейГруппы = ПолучитьПроблемныеЗаписиГруппыРегистра(мТекущийРегистр, мТекущаяГруппа);
	ЭлементыТекущейГруппы.Колонки.Вставить(0, "ОткрытьЗапись");
	
	ЭлементыФормы.ГруппыТекущегоРегистра.ТекущаяСтрока = мТекущаяГруппа;
	УстановитьПредставленияКолонок(ЭлементыТекущейГруппы);
	ЭлементыФормы.ЭлементыТекущейГруппы.СоздатьКолонки();
	УстановитьТолькоПросмотрКолонок(ЭлементыФормы.ЭлементыТекущейГруппы);
	
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыЭлементыГруппы.Заголовок, ,
		Строка(ЭлементыТекущейГруппы.Количество()) + ")", "(");
	
КонецПроцедуры

Процедура УстановитьПредставленияКолонок(Таблица)

	Для Каждого Колонка Из Таблица.Колонки Цикл
		Колонка.Заголовок = мСтруктураПредставлений[Колонка.Имя];
	КонецЦикла;

КонецПроцедуры // УстановитьПредставленияКолонок()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ОбновитьДанные()

	Успех = ВыполнитьАнализ();
	
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.ПанельОсновная.Страницы.РегистрыСведений.Заголовок, ,
		Строка(ПроблемныеРегистры.Количество()) + ")", "(");
		
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.ПанельОсновная.Страницы.ПланыВидовХарактеристик.Заголовок, ,
		Строка(ПроблемныеПланыВидовХарактеристик.Количество()) + ")", "(");
		
	Если ПроблемныеПланыВидовХарактеристик.Количество() > 0 Тогда
		ВывестиСоставПВХ(ПроблемныеПланыВидовХарактеристик[0]);
	КонецЕсли; 

	//ГруппыТекущегоРегистра.Сортировать(ирОбщий.ПолучитьСтрокуПорядкаЛкс(ПостроительОтчетаОтбора.Порядок));
	Если ПроблемныеРегистры.Количество() > 0 И ЭлементыФормы.ПроблемныеРегистры.ТекущаяСтрока = Неопределено Тогда
		ВывестиСоставРегистра(ПроблемныеРегистры[0]);
	КонецЕсли;
	
	Если Успех Тогда
		Предупреждение("Проблем не обнаружено");
	Иначе
		ЭлементыФормы.ПанельОсновная.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры // ОбновитьДанные()

Процедура КоманднаяПанельНастройкиОтчетаПоиск(Кнопка)
	
	ОбновитьДанные();

КонецПроцедуры

Процедура ЭлементыТекущейГруппыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.ОткрытьЗапись.УстановитьТекст(">>>");
	ОформлениеСтроки.Ячейки.ОткрытьЗапись.ЦветФона = WebЦвета.Аквамарин;
	
КонецПроцедуры

Процедура ГруппыТекущегоРегистраВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		ЗначениеЯчейки = Элемент.ТекущаяСтрока[Колонка.Имя];
		КорневойТипЗначения = ирОбщий.КорневойТипКонфигурацииЛкс(ЗначениеЯчейки);
		Если КорневойТипЗначения <> Неопределено Тогда
			ОткрытьЗначение(ЗначениеЯчейки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельЭлементыТекущейГруппыАвтоопределениеПравильных(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ГруппыТекущегоРегистраПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ГруппыТекущегоРегистраПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ГруппыТекущегоРегистраПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	КопияТаблицы = ГруппыТекущегоРегистра.Скопировать(, "НомерГруппы");
	КопияТаблицы.Сортировать("НомерГруппы Убыв");
	Если КопияТаблицы.Количество() > 1 Тогда
		ПоследнийНомер = КопияТаблицы[0].НомерГруппы;
	Иначе
		ПоследнийНомер = 0;
	КонецЕсли;
	Элемент.ТекущаяСтрока.НомерГруппы = ПоследнийНомер + 1;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыГруппыТекущегоРегистра.Заголовок, ,
		Строка(ГруппыТекущегоРегистра.Количество()) + ")", "(");
	ВывестиСоставГруппы(Элемент.ТекущаяСтрока);

КонецПроцедуры

Процедура ПроблемныеРегистрыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	ЗначениеЯчейки = ВыбраннаяСтрока[Колонка.Имя];
	КорневойТипЗначения = ирОбщий.КорневойТипКонфигурацииЛкс(ЗначениеЯчейки);
	Если КорневойТипЗначения <> Неопределено Тогда
		ОткрытьЗначение(ЗначениеЯчейки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЭлементыТекущейГруппыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка.Имя = "ОткрытьЗапись" Тогда 
		ПолноеИмяРегистра = "РегистрСведений." + мТекущийРегистр.Имя;
		ФормаСписка = ирОбщий.ПолучитьФормуСпискаЛкс(ПолноеИмяРегистра,,,,,, ирОбщий.КлючСтрокиТаблицыБДИзСтрокиТаблицыЗначенийЛкс(ПолноеИмяРегистра, ВыбраннаяСтрока));
		ФормаСписка.Открыть();
	Иначе
		ОткрытьЗначение(ВыбраннаяСтрока[Колонка.Имя]);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроблемныеПВХВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	ЗначениеЯчейки = ВыбраннаяСтрока[Колонка.Имя];
	КорневойТипЗначения = ирОбщий.КорневойТипКонфигурацииЛкс(ЗначениеЯчейки);
	Если КорневойТипЗначения <> Неопределено Тогда
		ОткрытьЗначение(ЗначениеЯчейки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЭлементыТекущегоПВХВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ОткрытьЗначение(ВыбраннаяСтрока[Колонка.Имя]);
		
КонецПроцедуры

Процедура КоманднаяПанельЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристикАвтоОчисткаТиповЗначений(Кнопка)
	
	фВыполнитьКоррекциюПВХ(ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик);
	ОбновитьДанные();
	 
КонецПроцедуры

Процедура КоманднаяПанельПроблемныеПланыВидовХарактеристикАвтоОчисткаТиповЗначений(Кнопка)

	Если мЗатронутыеЭлементыПВХ = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	фВыполнитьКоррекциюПВХ(мЗатронутыеЭлементыПВХ);
	ОбновитьДанные();
 
КонецПроцедуры

Процедура КоманднаяПанельЭлементыТекущейГруппыРегистраУдалить(Кнопка)
	
	ВыполнитьОчисткуГруппыРегистра(мТекущийРегистр, мТекущаяГруппа);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КоманднаяПанельРегистрыУдалить(Кнопка)
	
	ВыполнитьОчисткуРегистров();
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КоманднаяПанельГруппыТекущегоРегистраУдалить(Кнопка)
	
	ВыполнитьОчисткуРегистра(мТекущийРегистр);
	ОбновитьДанные();
	
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура фВыполнитьКоррекциюПВХ(ЭлементыПВХ) 

	Ответ = Вопрос("Вы уверены, что хотите удалить из типов значений ссылки на типы """ + УдаляемыеТипы + """?",
		РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ВыполнитьКоррекциюПВХ(ЭлементыПВХ);

КонецПроцедуры // мВыполнитьКоррекциюПВХ()

Процедура АвтокоррекцияНажатие(Элемент)
	
	Ответ = Вопрос("Удалить конфликтные строки всех регистров. В каждой группе оставить только одну. Из типов значений видов характеристик удалить ссылки на указанные типы."
		+ " Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	ВыполнитьКоррекциюПВХ(мЗатронутыеЭлементыПВХ);
	ВыполнитьОчисткуРегистров();
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КоманднаяПанельЗаполнитьУсекаемыеТипы(Кнопка, Таймаут = Неопределено)
	
	Если Таймаут = Неопределено Тогда
		Таймаут = 30;
	КонецЕсли; 
	Ответ = Вопрос("Хотите заполнить изменения структуры данных путем сравнения конфигурации БД с выбранным файлом конфигурации (Да),
	|иначе путем сравнения с основной конфигурацией (Нет)?", РежимДиалогаВопрос.ДаНет, Таймаут);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.Фильтр = ирОбщий.ПолучитьСтрокуФильтраДляВыбораФайлаЛкс("CF");
		ВыборФайла.Расширение = "CF";
		Если Не ВыборФайла.Выбрать() Тогда
			Возврат;
		КонецЕсли;
		ПолноеИмяФайлаКонфигурации = ВыборФайла.ПолноеИмяФайла;
		ЗаполнитьПоРазницеМеждуКонфигурациями(ПолноеИмяФайлаКонфигурации);
	Иначе
		Если Не КонфигурацияИзменена() Тогда
			ирОбщий.СообщитьЛкс("Конфигурация БД совпадает с основной конфигурацией", Таймаут);
			Возврат;
		КонецЕсли; 
		ЗаполнитьПоРазницеМеждуКонфигурациями();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ГруппыТекущегоРегистраПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		ВывестиСоставГруппы(Элемент.ТекущаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроблемныеРегистрыПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		ВывестиСоставРегистра(Элемент.ТекущаяСтрока);
	КонецЕсли; 

КонецПроцедуры

Процедура ПроблемныеПланыВидовХарактеристикПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		ВывестиСоставПВХ(Элемент.ТекущаяСтрока);
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельЭлементыТекущейГруппыРегистраРедакторОбъектаБДСтроки(Кнопка)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ЭлементыТекущейГруппы);
	
КонецПроцедуры

Процедура КоманднаяПанельЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристикРедакторОбъектаБДСтроки(Кнопка)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик, "ПланВидовХарактеристик." + ЭлементыФормы.ПроблемныеПланыВидовХарактеристик);
	
КонецПроцедуры

Процедура УдаляемыеТипыНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	//ирОбщий.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура КоманднаяПанельПараметрыЗаписи(Кнопка)
	
	ирОбщий.ОткрытьОбщиеПараметрыЗаписиЛкс();
	
КонецПроцедуры

Процедура ЭлементыТекущейГруппыПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристикПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристикПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ПроблемныеПланыВидовХарактеристикПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ГруппыТекущегоРегистраПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ИзмененныеИзмеренияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = ПолучитьФорму("ИзменяемыеИзмерения");
	ФормаВыбора.ОткрытьМодально();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ПроблемныеРегистрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодготовкаКИзменениюСтруктурыБД.Форма.Форма");
