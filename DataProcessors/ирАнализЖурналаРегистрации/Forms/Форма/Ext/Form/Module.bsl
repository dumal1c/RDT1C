﻿Перем МассивУровнейЖурнала;
Перем СтруктураКолонокБезОтбора;

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НачалоПериода, ?(КонецПериода='0001-01-01', КонецПериода, КонецДня(КонецПериода)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		НачалоПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонецПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;

КонецПроцедуры

Процедура ТаблицаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Уровень.ОтображатьКартинку = Истина;
	ИндексКартинки = -1;
	//Если ДанныеСтроки.СтатусТранзакции = "" + СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена тогда
	//	ИндексКартинки = 0;
	//Иначе
		ИндексКартинки = МассивУровнейЖурнала.Найти("" + ДанныеСтроки.Уровень);
		ИндексКартинки = ?(ИндексКартинки <> Неопределено, ИндексКартинки, -1);
	//КонецЕсли;
	Если ИндексКартинки >= 0 тогда
		ОформлениеСтроки.Ячейки.Уровень.ИндексКартинки = ИндексКартинки;
	КонецЕсли;
	Если ДанныеСтроки.Сеанс = НомерСеансаИнформационнойБазы() Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(240, 255, 240);
	КонецЕсли; 
	//Если ДанныеСтроки.Данные = ВыбОбъект Тогда
	//	ОформлениеСтроки.ЦветФона = Новый Цвет(255, 250, 250);
	//КонецЕсли;
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ДанныеСтроки.ПорядокСтроки, "ПорядокСтроки");
	Если СтрокаТаблицыЗначений <> Неопределено Тогда
		Если ТаблицаЗначенийЖурнала.Колонки.Найти("РазделениеДанныхСеанса") <> Неопределено Тогда
			ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.РазделениеДанныхСеанса, СтрокаТаблицыЗначений.РазделениеДанныхСеанса, Элемент.Колонки.РазделениеДанныхСеанса);
		КонецЕсли; 
		ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Метаданные, СтрокаТаблицыЗначений.Метаданные, Элемент.Колонки.Метаданные);
		ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Данные, СтрокаТаблицыЗначений.Данные, Элемент.Колонки.Данные);
		ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки,,,,, СтрокаТаблицыЗначений);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	//ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, СтрокаТаблицыЗначений[Колонка.Данные]);
	ФормаСобытия = ПолучитьФорму("ФормаСобытия",, ВыбраннаяСтрока.ПорядокСтроки);
	ФормаСобытия.НачальноеЗначениеВыбора = ВыбраннаяСтрока;
	ФормаСобытия.СтрокаТаблицыЗначений = СтрокаТаблицыЗначений;
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ОбновитьТаблицуЖурнала() Экспорт
	
	Если ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> Неопределено Тогда
		КлючТекущейСтроки = Новый Структура();
		Для Каждого Колонка Из Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты Цикл
			Если Колонка.Имя = "ПорядокСтроки" Тогда
				Продолжить;
			КонецЕсли; 
			КлючТекущейСтроки.Вставить(Колонка.Имя, ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока[Колонка.Имя]);
		КонецЦикла;
	КонецЕсли; 
	ЗагрузитьДанныеЖурнала();
	
	ТекущаяСтрокаУстановлена = Ложь;
	Если КлючТекущейСтроки <> Неопределено Тогда
		НайденныеСтроки = ТаблицаЖурнала.НайтиСтроки(КлючТекущейСтроки);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = НайденныеСтроки[0];
			ТекущаяСтрокаУстановлена = Истина;
		КонецЕсли; 
	КонецЕсли; 
	Если Не ТекущаяСтрокаУстановлена Тогда
		Если ТаблицаЖурнала.Количество() > 0 Тогда
			ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = ТаблицаЖурнала[ТаблицаЖурнала.Количество() - 1];
		КонецЕсли; 
	КонецЕсли; 
	ЭлементыФормы.ТаблицаЖурнала.Колонки.РазделениеДанныхСеанса.Видимость = ТаблицаЗначенийЖурнала.Колонки.Найти("РазделениеДанныхСеанса") <> Неопределено;
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОбновить(Кнопка)
	
	ОбновитьТаблицуЖурнала();
	
КонецПроцедуры

Процедура ОтборПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	Если Копирование Тогда
		Возврат;
	КонецЕсли; 
	СписокВыбора = Новый СписокЗначений;
	Для Каждого Колонка Из Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты Цикл
		Если Ложь
			Или Отбор.Найти(Колонка.Имя, "Поле") <> Неопределено 
			Или СтруктураКолонокБезОтбора.Свойство(Колонка.Имя)
		Тогда
			Продолжить;
		КонецЕсли; 
		СписокВыбора.Добавить(Колонка.Имя, Колонка.Представление());
	КонецЦикла;
	СписокВыбора.СортироватьПоЗначению();
	РезультатВыбора = СписокВыбора.ВыбратьЭлемент();
	Если РезультатВыбора <> Неопределено Тогда
		ПолеОтбора = РезультатВыбора.Значение;
		ТекущаяСтрока = ДобавитьЭлементОтбора(Отбор, ПолеОтбора);
		Элемент.ТекущаяСтрока = ТекущаяСтрока;
		//Элемент.ИзменитьСтроку();
		//ОтборЗначениеНачалоВыбора();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоДня(ТекущаяДата());
	КонецЕсли;
	ДействияФормыОткрытьФайлЖурнала();
	ЭтотОбъект.СохраненныеНастройки = ирОбщий.ВосстановитьЗначениеЛкс("ирАнализЖурналаРегистрации.СохраненныеНастройки");
	ЗагрузитьНастройкуПоУмолчанию();

КонецПроцедуры

Процедура ЗагрузитьНастройкуПоУмолчанию()
	
	НастройкаПоУмолчанию = ирОбщий.ПолучитьНастройкуПоУмолчаниюИзСпискаСохраненныхНастроекЛкс(СохраненныеНастройки);
	Если НастройкаПоУмолчанию.Значение <> Неопределено Тогда
		ЭтаФорма.ПоследняяНастройка = СохраненныеНастройки.Индекс(НастройкаПоУмолчанию);
		ЗагрузитьНастройкуВФорме(НастройкаПоУмолчанию.Значение);
	КонецЕсли;

КонецПроцедуры

Процедура СохранитьНастройкуПоУмолчанию()
	
	НастройкаПоУмолчанию = ирОбщий.ПолучитьНастройкуПоУмолчаниюИзСпискаСохраненныхНастроекЛкс(СохраненныеНастройки);
	НастройкаПоУмолчанию.Значение = ирОбщий.ПолучитьКопиюОбъектаЛкс(ОписаниеВариантаОтбора());

КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	СтрокаОтбора = ДанныеСтроки;
	ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора(СтрокаОтбора);
	Если ТипЗнч(ДанныеСтроки.Значение) = Тип("СписокЗначений") Тогда
		Если ДанныеСтроки.Значение.ТипЗначения.Типы().Количество() = 0 Тогда
			КоличествоПомеченных = Неопределено;
			ПредставлениеСтрокиОтбора = ПредставлениеСтрокиОтбора(ДанныеСтроки, КоличествоПомеченных);
			ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора И ЗначениеЗаполнено(ПредставлениеСтрокиОтбора);
			ОформлениеСтроки.Ячейки.Значение.УстановитьТекст("(" + КоличествоПомеченных + " из " + ДанныеСтроки.Значение.Количество() + ") " + ПредставлениеСтрокиОтбора);
		КонецЕсли;
	КонецЕсли; 
	Если ДанныеСтроки.Поле = "Данные" Тогда
		ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Значение,,, Истина);
	КонецЕсли; 
	Если Не ИспользованиеСтрокиОтбора Тогда
		ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	СохранитьНастройкиФормы();
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОтборЗначениеПриИзменении(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.Отбор.ТекущаяСтрока;
	ПолеОтбора = ТекущаяСтрока.Поле;
	БазовоеОписаниеТипов = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ПолеОтбора].Тип;
	ТекущаяСтрока.Использование = Истина;
	Если ТипЗнч(ТекущаяСтрока.Значение) = Тип("СписокЗначений") Тогда
		Если ПолеОтбора = "Сеанс" Тогда 
			ТекущаяСтрока.Значение.ТипЗначения = БазовоеОписаниеТипов;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, Знач ПарнаяДата, Знак)
	
	СимволЗнака = ?(Знак = 1, "+", "-");
	ИмяПарнойДаты = ?(Знак = 1, "Начало", "Конец");
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(1*60,          ИмяПарнойДаты + " " + СимволЗнака + " 1 минута");
	СписокВыбора.Добавить(10*60,       ИмяПарнойДаты + " " + СимволЗнака + " 10 минут");
	СписокВыбора.Добавить(2*60*60,       ИмяПарнойДаты + " " + СимволЗнака + " 2 часа");
	СписокВыбора.Добавить(1*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 1 день");
	СписокВыбора.Добавить(7*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 7 дней");
	СписокВыбора.Добавить(30*24*60*60,   ИмяПарнойДаты + " " + СимволЗнака + " 30 дней");
	РезультатВыбора = ЭтаФорма.ВыбратьИзСписка(СписокВыбора, Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Если Знак = -1 Тогда
			Если Не ЗначениеЗаполнено(ПарнаяДата) Тогда
				ПарнаяДата = ТекущаяДата();
			КонецЕсли; 
		КонецЕсли; 
		Элемент.Значение = ПарнаяДата + Знак * РезультатВыбора.Значение;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, НачалоПериода, 1);
	
КонецПроцедуры

Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, КонецПериода, -1);

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииКонсольКомпоновки(Кнопка)
	
	КонсольКомпоновокДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Отчет.ирКонсольКомпоновокДанных");
	#Если Сервер И Не Сервер Тогда
		КонсольКомпоновокДанных = Отчеты.ирКонсольКомпоновокДанных.Создать();
	#КонецЕсли
    КонсольКомпоновокДанных.ОткрытьПоТабличномуПолю(ЭлементыФормы.ТаблицаЖурнала);
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПолеОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ТаблицаЖурнала);
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ТаблицаЖурнала, ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СписокОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииНастроитьРегистрациюСобытия(Кнопка)
	
	Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирНастройкаЖурналаРегистрации.Форма");
	Форма.Открыть();
	ТекущаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ТекущаяСтрока.ПорядокСтроки, "ПорядокСтроки");
		лМетаданные = Неопределено;
		Если СтрокаТаблицыЗначений <> Неопределено Тогда
			лМетаданные = СтрокаТаблицыЗначений.Метаданные;
		КонецЕсли; 
		Форма.АктивизироватьСтрокуСобытия(ТекущаяСтрока.Событие, лМетаданные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФиксированныйСписокПриИзмененииФлажка(Элемент)
	
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	ЭлементыФормы.Отбор.ТекущиеДанные.Использование = Истина;
	
КонецПроцедуры

Процедура ОтборПриАктивизацииСтроки(Элемент)

	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущиеДанные = ЭлементыФормы.Отбор.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ЗначениеОтбора = Неопределено;
	Иначе
		ЗначениеОтбора = ТекущиеДанные.Значение;
	КонецЕсли; 
	ЭтоСписокЗначений = ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений");
	Элемент.Колонки.Значение.ТолькоПросмотр = ЭтоСписокЗначений;
	ЭлементыФормы.ФиксированныйСписок.Видимость = ЭтоСписокЗначений;
	ЭлементыФормы.КоманднаяПанельСписка.Видимость = ЭтоСписокЗначений;
	ЭлементыФормы.КоличествоЭлементовСписка.Видимость = ЭтоСписокЗначений;
	Если ЭтоСписокЗначений Тогда
		ЭтаФорма.КоличествоЭлементовСписка = ЗначениеОтбора.Количество();
	Иначе
		ЭтаФорма.КоличествоЭлементовСписка = 0;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСнятьФлажки(Кнопка)
	
	ЭлементыФормы.ФиксированныйСписок.Значение.ЗаполнитьПометки(Ложь);
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаУстановитьФлажки(Кнопка)
	
	ЭлементыФормы.ФиксированныйСписок.Значение.ЗаполнитьПометки(Истина);
	ЭлементыФормы.Отбор.ОбновитьСтроки();

КонецПроцедуры

Процедура ДействияФормыАнализТехножурнала(Кнопка)
	
	АнализТехножурнала = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
	#Если Сервер И Не Сервер Тогда
		АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
	#КонецЕсли
	АнализТехножурнала.ОткрытьСОтбором(НачалоПериода, КонецПериода);
	
КонецПроцедуры

Процедура ОтборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.ТекущиеДанные.Значение = Элемент.ТекущиеДанные.ОписаниеТипов.ПривестиЗначение(Элемент.ТекущиеДанные.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииНайтиВОтбореВыгрузки(Кнопка)
	
	ПолеОтбора = ЭлементыФормы.ТаблицаЖурнала.ТекущаяКолонка.Данные;
	Если СтруктураКолонокБезОтбора.Свойство(ПолеОтбора) Тогда
		Если ЗначениеЗаполнено(СтруктураКолонокБезОтбора[ПолеОтбора]) Тогда
			ПолеОтбора = СтруктураКолонокБезОтбора[ПолеОтбора];
		КонецЕсли; 
	КонецЕсли; 
	ЗначениеОтбора = Неопределено;
	Если ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> Неопределено Тогда
		ЗначениеОтбора = ЭлементыФормы.ТаблицаЖурнала.ТекущиеДанные[ПолеОтбора];
	КонецЕсли; 
	СтрокаОтбора = ДобавитьЭлементОтбора(Отбор, ПолеОтбора, ЗначениеОтбора);
	ЭлементыФормы.Отбор.ТекущаяСтрока = СтрокаОтбора;
	ТекущаяСтрокаСписка = ЭлементыФормы.ФиксированныйСписок.Значение.НайтиПоЗначению(ЗначениеОтбора);
	Если ТекущаяСтрокаСписка <> Неопределено Тогда
		ЭлементыФормы.ФиксированныйСписок.ТекущаяСтрока = ТекущаяСтрокаСписка;
	КонецЕсли; 
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельОтборТекущийСеанс(Кнопка)
	
	ДобавитьЭлементОтбора(Отбор, "Сеанс", НомерСеансаИнформационнойБазы(),, Истина, Ложь);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОтборЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	//ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, , Истина);
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ТаблицаЖурнала);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОтборЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Отбор, СтандартнаяОбработка, , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСортироватьПоВозрастанию(Кнопка)
	
	ЭлементыФормы.Отбор.ТекущиеДанные.Значение.СортироватьПоЗначению();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСортироватьПоУбыванию(Кнопка)
	
	ЭлементыФормы.Отбор.ТекущиеДанные.Значение.СортироватьПоЗначению(НаправлениеСортировки.Убыв);

КонецПроцедуры

Процедура ДействияФормыОткрытьФайлЖурнала(Кнопка = Неопределено)
	
	Если Кнопка <> Неопределено Тогда
		Если ЗначениеЗаполнено(ИмяФайла) Тогда
			Ответ = Вопрос("Хотите открыть текущий журнал регистрации?", РежимДиалогаВопрос.ДаНет);
		Иначе
			Ответ = КодВозвратаДиалога.Нет;
		КонецЕсли; 
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ИмяФайла = "";
		Иначе
			НовоеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "lgf",, ИмяФайла);
			Если НовоеИмяФайла <> Неопределено Тогда
				ИмяФайла = НовоеИмяФайла;
			Иначе
				Возврат;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	ЗаполнитьОтборВыгрузки();
	ТаблицаЖурнала.Очистить();
	
КонецПроцедуры

Процедура КоманднаяПанельОтборОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Отбор, ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельОтборСохранитьНастройки(Кнопка)
	
	НастройкаФормы = ирОбщий.ПолучитьКопиюОбъектаЛкс(ОписаниеВариантаОтбора());
	НовоеНаименование = ПредставлениеВариантаОтбора(НастройкаФормы);
    ТекущиеДанные = ирОбщий.ВыбратьНастройкуДляСохраненияЛкс(СохраненныеНастройки, ПоследняяНастройка, НовоеНаименование);
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.Значение = НастройкаФормы;
	КонецЕсли;
	СохранитьНастройкиФормы();
	
КонецПроцедуры

Процедура КоманднаяПанельОтборЗагрузитьНастройки(Кнопка)
	
    ТекущиеДанные = ирОбщий.ВыбратьНастройкуДляЗагрузкиЛкс(СохраненныеНастройки, ПоследняяНастройка);
	Если ТекущиеДанные <> Неопределено Тогда
		ЗагрузитьНастройкуВФорме(ТекущиеДанные.Значение);
	КонецЕсли;
	СохранитьНастройкиФормы();

КонецПроцедуры

Процедура СохранитьНастройкиФормы()
	
	СохранитьНастройкуПоУмолчанию();
	ирОбщий.СохранитьЗначениеЛкс("ирАнализЖурналаРегистрации.СохраненныеНастройки", СохраненныеНастройки);

КонецПроцедуры

Процедура ЗагрузитьНастройкуВФорме(ВыбранныйВариант)
	
	Если ВыбранныйВариант.Свойство("НачалоПериода") Тогда
		ЭтотОбъект.НачалоПериода = ВыбранныйВариант.НачалоПериода;
		ЭтотОбъект.КонецПериода = ВыбранныйВариант.КонецПериода;
	КонецЕсли; 
	ЭтотОбъект.МаксимальныйРазмерВыгрузки = ВыбранныйВариант.МаксимальныйРазмерВыгрузки;
	Отбор.Очистить();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ВыбранныйВариант.Отбор, Отбор);
	
КонецПроцедуры

Процедура КоманднаяПанельОтборСнятьПометки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.Отбор, "Использование", Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииВывестиСтроки(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ЭлементыФормы.ТаблицаЖурнала);
	
КонецПроцедуры

Процедура КоманднаяПанельФормыОткрытьИТС(Кнопка)
	
	ирОбщий.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000000823");
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаРедактироватьЭлементОтбора(Кнопка = Неопределено)
	
	ФормаРедактора = ПолучитьФорму("РедакторСписка");
	ФормаРедактора.ПараметрСписок = ЭлементыФормы.Отбор.ТекущиеДанные.Значение;
	ФормаРедактора.ПараметрТекущаяСтрока = ЭлементыФормы.ФиксированныйСписок.ТекущаяСтрока;
	РезультатФормы = ФормаРедактора.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		ЭлементыФормы.Отбор.ТекущиеДанные.Использование = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтборВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если КоличествоЭлементовСписка > 0 И ЭлементыФормы.Отбор.Колонки.Значение = Колонка Тогда
		СтандартнаяОбработка = Ложь;
		КоманднаяПанельСпискаРедактироватьЭлементОтбора();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФиксированныйСписокВыбор(Элемент, ЭлементСписка)
	
	КоманднаяПанельСпискаРедактироватьЭлементОтбора();
	
КонецПроцедуры

Процедура ОтборПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура ТаблицаЖурналаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КоманднаяПанельФормыОтображатьОтбор(Кнопка)
	
	ПоказатьСвернутьОтбор(Не ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьОтбор.Пометка);
	
КонецПроцедуры

Процедура ПоказатьСвернутьОтбор(Видимость = Истина)
	
	ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьОтбор.Пометка = Видимость;
	ирОбщий.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.ПанельОтбор, ЭлементыФормы.РазделительГоризонтальныйПодОтбором, ЭтаФорма.Панель, "верх");
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не Отказ Тогда
		ПоказатьСвернутьОтбор();
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииАнализПравДоступа(Кнопка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	ПолноеИмяМД = ВыбратьОбъектМетаданных(СтрокаТаблицыЗначений);
	Если ПолноеИмяМД = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаОтчета = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, ПолноеИмяМД);
	ФормаОтчета.Пользователь = СтрокаТаблицыЗначений.ИмяПользователя;
	ФормаОтчета.ОбъектМетаданных = ПолноеИмяМД;
	ФормаОтчета.ПараметрКлючВарианта = "ПоПользователям";
	ФормаОтчета.Открыть();
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОткрытьОбъектМетаданных(Кнопка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	ПолноеИмяМД = ВыбратьОбъектМетаданных(СтрокаТаблицыЗначений);
	Если ПолноеИмяМД = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ПолноеИмяМД);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализЖурналаРегистрации.Форма.Форма");
СписокВыбора = ЭлементыФормы.МаксимальныйРазмерВыгрузки.СписокВыбора;
СписокВыбора.Добавить(100);
СписокВыбора.Добавить(1000);
СписокВыбора.Добавить(10000);
СписокВыбора.Добавить(50000);

СтруктураКолонокБезОтбора = Новый Структура();
СтруктураКолонокБезОтбора.Вставить("ПредставлениеПриложения", "ИмяПриложения");
СтруктураКолонокБезОтбора.Вставить("ПредставлениеСобытия", "Событие");
СтруктураКолонокБезОтбора.Вставить("ИмяПользователя", "Пользователь");
СтруктураКолонокБезОтбора.Вставить("Дата");
СтруктураКолонокБезОтбора.Вставить("Соединение");
СтруктураКолонокБезОтбора.Вставить("ПредставлениеМетаданных", "Метаданные");

МассивУровнейЖурнала = Новый Массив();
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Примечание);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Информация);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Предупреждение);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Ошибка);

