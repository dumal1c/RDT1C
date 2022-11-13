﻿Перем мТаблицаИсточника;
Перем мСтруктураИсточника;
Перем мСхемаКомпоновки;
Перем мСтруктураКлюча;
перем мСтрокаПолейКлюча;
Перем мСтарыйСнимокНастройкиКомпоновки;
Перем мПоследняяВыбраннаяТаблицаБД;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ГруппироватьСразу, Форма.МинимальныйРазмерГруппы";
	выхИменаСвойств = выхИменаСвойств + ", Форма.АвтовидимостьКолонокСоставаГруппы";
	Результат = Новый Структура;
	Результат.Вставить("НастройкаКомпоновки", Компоновщик.ПолучитьНастройки());
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если НастройкаФормы.Свойство("НастройкаКомпоновки") Тогда
		Компоновщик.ЗагрузитьНастройки(НастройкаФормы.НастройкаКомпоновки);
	КонецЕсли;
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	ГруппироватьСразуПриИзменении();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	УстановитьИсточник();
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ВладелецФормы);
	Если ЗначениеЗаполнено(ДанныеКолонки) Тогда
		ДоступноеПолеТекущейКолонки = Компоновщик.Настройки.ДоступныеПоляПорядка.НайтиПоле(Новый ПолеКомпоновкиДанных(ДанныеКолонки));
		Если ДоступноеПолеТекущейКолонки <> Неопределено Тогда
			ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПолеТекущейКолонки;
			Если Не ЗначениеЗаполнено(ПараметрИменаКлючевыхКолонок) Тогда
				ПараметрИменаКлючевыхКолонок = ДанныеКолонки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если ВладелецФормы.ТекущаяСтрока <> Неопределено Тогда
		Если ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
			СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(ИмяТаблицыБД, Истина,, Ложь); 
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ВладелецФормы.ТекущаяСтрока);
			ДанныеСтаройТекущейСтроки = ирОбщий.СтрокаТаблицыБДПоКлючуЛкс(ИмяТаблицыБД, СтруктураКлюча);
		Иначе
			ДанныеСтаройТекущейСтроки = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ВладелецФормы);
		КонецЕсли;
	КонецЕсли;
	Если Компоновщик.Настройки.Отбор.Элементы.Количество() = 0 И ДанныеСтаройТекущейСтроки <> Неопределено Тогда
		Для Каждого ДоступноеПоле Из Компоновщик.Настройки.Отбор.ДоступныеПоляОтбора.Элементы Цикл
			Если ДоступноеПоле.Папка Тогда
				Продолжить;
			КонецЕсли;
			ИмяКолонкиИсточника = "" + ДоступноеПоле.Поле;
			Если мТаблицаИсточника.Колонки.Найти(ИмяКолонкиИсточника) = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, ДоступноеПоле.Поле, ДанныеСтаройТекущейСтроки[ИмяКолонкиИсточника],,,, Ложь);
		КонецЦикла;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПараметрИменаКлючевыхКолонок) Тогда
		ИменаКолонок = ирОбщий.СтрРазделитьЛкс(ПараметрИменаКлючевыхКолонок, "," , Истина, Ложь);
		Для Каждого ИмяКолонки Из ИменаКолонок Цикл
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, ИмяКолонки);
		КонецЦикла;
		МинимальныйРазмерГруппы = 2;
		КПКлючиСтрокВыполнить();
		Если Истина
			И КлючиСтрок.Колонки.Количество() > 0
			И ДанныеСтаройТекущейСтроки <> Неопределено 
		Тогда
			ТекущийКлюч = Новый Структура(ПараметрИменаКлючевыхКолонок);
			ЗаполнитьЗначенияСвойств(ТекущийКлюч, ДанныеСтаройТекущейСтроки); 
			ТекущаяСтрока = КлючиСтрок.НайтиСтроки(ТекущийКлюч);
			Если ТекущаяСтрока.Количество() > 0 Тогда
				ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = ТекущаяСтрока[0];
			КонецЕсли; 
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
			КПКлючиСтрокВыделитьВИсточнике();
			//ВладелецФормы.ТекущаяСтрока = СтараяТекущаяСтрока; // Так сбросится выделение строк группы
		КонецЕсли;
	Иначе
		ГруппироватьСразуПриИзменении();
	КонецЕсли; 
	
КонецПроцедуры

Функция УстановитьИсточник()
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ИсточникДействий = ЭтаФорма.ВладелецФормы;
	ЗначениеТабличногоПоля = ирОбщий.ДанныеЭлементаФормыЛкс(ИсточникДействий);
	ТипИсточника = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ИсточникДействий,,, ИмяТаблицыБД);
	Если ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ИмяТаблицыБД, ": ");
	КонецЕсли;
	ЭтаФорма.Отбор = Неопределено;
	Если ТипИсточника = "ТаблицаЗначений" Тогда 
		//
	ИначеЕсли ТипИсточника = "ДеревоЗначений" Тогда 
		//
	Иначе
		Если ТипИсточника = "ТабличнаяЧасть" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
		ИначеЕсли ТипИсточника = "НаборЗаписей" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
		ИначеЕсли ТипИсточника = "Список" Тогда
			НастройкиСписка = ирОбщий.НастройкиДинамическогоСпискаЛкс(ЗначениеТабличногоПоля, "Пользовательские");
			ЭтаФорма.Отбор = НастройкиСписка.Отбор;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Если Отбор <> Неопределено Тогда
		ирОбщий.СкопироватьОтборЛюбойЛкс(Компоновщик.Настройки.Отбор, Отбор);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
		мСхемаКомпоновки = ирОбщий.СоздатьСхемуКомпоновкиТаблицыБДЛкс(ИмяТаблицыБД);
		ЭлементыФормы.СтрокиТекущегоКлюча.Доступность = Ложь;
		мТаблицаИсточника = ирОбщий.ПустаяТаблицаЗначенийИзТаблицыБДЛкс(ИмяТаблицыБД);
	Иначе
		мТаблицаИсточника = ирОбщий.ТаблицаИлиДеревоЗначенийИзТаблицыФормыСКоллекциейЛкс(ИсточникДействий);
		мТаблицаИсточника = ирОбщий.СузитьТипыКолонокТаблицыБезПотериДанныхЛкс(мТаблицаИсточника);
		мСтруктураИсточника = Новый Структура("Таблица", мТаблицаИсточника);
		мСхемаКомпоновки = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(мСтруктураИсточника);
		ЭтаФорма.СтрокиТекущегоКлюча = мТаблицаИсточника.СкопироватьКолонки();
		//ЭлементыФормы.СтрокиТекущегоКлюча.Колонки.Очистить();
		ЭлементыФормы.СтрокиТекущегоКлюча.СоздатьКолонки();
		ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТекущегоКлюча,,,, Истина);
	КонецЕсли;
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновки);
	Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(Новый НастройкиКомпоновкиДанных); // Восстановленные при открытии настройки удаляем
	Если ПараметрНастройкаКомпоновки <> Неопределено Тогда
		Компоновщик.ЗагрузитьНастройки(ирОбщий.СкопироватьНастройкиКомпоновкиЛкс(ПараметрНастройкаКомпоновки,, Истина));
		ПараметрНастройкаКомпоновки = Неопределено;
	КонецЕсли; 
	ЭлементПорядка = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, "КоличествоСтрокАвто");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	
КонецФункции

Процедура КПКлючиСтрокВыполнить(Кнопка = Неопределено, РежимОтладки = Ложь, ВыбрасыватьИсключение = Ложь)
	
	Если мСхемаКомпоновки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючиСтрок.Очистить();
	КлючиСтрок.Колонки.Очистить();
	ЭлементыФормы.КлючиСтрок.Колонки.Очистить();
	ирОбщий.КомпоновщикНастроекВосстановитьЛкс(Компоновщик);
	ВременныеНастройки = Компоновщик.ПолучитьНастройки();
	Если ВременныеНастройки.Структура.Количество() = 0 Тогда
		ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(ВременныеНастройки.Структура);
	КонецЕсли;
	ПоляГруппировки = ВременныеНастройки.Структура[0].ПоляГруппировки.Элементы;
	ПоляГруппировки.Очистить();
	ВременныеНастройки.Выбор.Элементы.Очистить();
	ПоляКлюча = Новый Массив;
	мСтруктураКлюча = Новый Структура;
	Для Каждого ЭлементПорядка Из ВременныеНастройки.Порядок.Элементы Цикл
		Если ЭлементПорядка.Использование Тогда
			Если "" + ЭлементПорядка.Поле <> "КоличествоСтрокАвто" Тогда
				ИмяКолонки = СтрЗаменить(ЭлементПорядка.Поле, ".", "");
				ПоляКлюча.Добавить(ИмяКолонки);
				мСтруктураКлюча.Вставить(ИмяКолонки, ЭлементПорядка.Поле);
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ПоляГруппировки, ЭлементПорядка.Поле);
			КонецЕсли; 
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, ЭлементПорядка.Поле);
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, "КоличествоСтрокАвто");
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ВременныеНастройки.Структура[0].Отбор, "КоличествоСтрокАвто", МинимальныйРазмерГруппы, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	Попытка
		ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, ВременныеНастройки, КлючиСтрок, мСтруктураИсточника,,,,, РежимОтладки);
	Исключение
		Если ВыбрасыватьИсключение = Истина Тогда
			ВызватьИсключение;
		Иначе
			ирОбщий.СообщитьЛкс(ОписаниеОшибки());
			Возврат;
		КонецЕсли; 
	КонецПопытки; 
	ЭтаФорма.КлючиСтрокКоличество = КлючиСтрок.Количество();
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = 0;
	ЭлементыФормы.КлючиСтрок.СоздатьКолонки();
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.КлючиСтрок,,,, Истина);
	мСтрокаПолейКлюча = ирОбщий.СтрСоединитьЛкс(ПоляКлюча);
	Если КлючиСтрок.Количество() > 0 Тогда
		ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = КлючиСтрок[0];
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирОбщий.ПриПолученииДанныхДоступныхПолейКомпоновкиЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КлючиСтрокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КПКлючиСтрок.Кнопки.Идентификаторы,,,,,, Истина);
	
КонецПроцедуры

Процедура МинимальныйРазмерГруппыПриИзменении(Элемент)
	
	ПроверитьИСгруппировать();
	
КонецПроцедуры

Процедура ПроверитьИСгруппировать()
	
	Если ГруппироватьСразу Тогда
		КПКлючиСтрокВыполнить();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлючевыеКолонкиПриИзмененииФлажка(Элемент, Колонка)
	
	ПроверитьИСгруппировать();
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КПСтрокиТекущегоКлюча.Кнопки.Идентификаторы,,,,,, Истина);

КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаАвтовидимостьКолонок(Кнопка)
	
	ЭтаФорма.АвтовидимостьКолонокСоставаГруппы = Не Кнопка.Пометка;
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	
КонецПроцедуры

Процедура ПриИзмененииАвтовидимостьКолонокСоставаГруппы()
	
	ЭлементыФормы.КПСтрокиТекущегоКлюча.Кнопки.АвтовидимостьКолонок.Пометка = АвтовидимостьКолонокСоставаГруппы;
	ирОбщий.СкрытьПоказатьОднозначныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТекущегоКлюча, АвтовидимостьКолонокСоставаГруппы);
	
КонецПроцедуры

Процедура КлючиСтрокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	СтрокиТекущегоКлюча.Очистить();
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = 0;
	Если ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
	Иначе
		ВременныеНастройки = Компоновщик.ПолучитьНастройки();
		ТекущийКлюч = Новый Структура(мСтрокаПолейКлюча);
		ЗаполнитьЗначенияСвойств(ТекущийКлюч, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока); 
		Для Каждого КлючИЗначение Из мСтруктураКлюча Цикл
			ЭлементОтбора = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ВременныеНастройки.Отбор, КлючИЗначение.Значение, ТекущийКлюч[КлючИЗначение.Ключ]);
			#Если Сервер И Не Сервер Тогда
				ЭлементОтбора = ВременныеНастройки.Отбор.Элементы.Добавить();
			#КонецЕсли
			ЭлементОтбора.Использование = Истина;
		КонецЦикла;
		ВременныеНастройки.Выбор.Элементы.Очистить();
		Для Каждого ДоступноеПоле Из ВременныеНастройки.ДоступныеПоляВыбора.Элементы Цикл
			Если Не ДоступноеПоле.Папка И "" + ДоступноеПоле.Поле <> "КоличествоСтрокАвто" Тогда
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, ДоступноеПоле.Поле);
			КонецЕсли;
		КонецЦикла;
		ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, ВременныеНастройки, СтрокиТекущегоКлюча, мСтруктураИсточника);
		ЭтаФорма.СтрокиТекущегоКлючаКоличество = СтрокиТекущегоКлюча.Количество();
		Если СтрокиТекущегоКлючаКоличество > 0 И ЭлементыФормы.СтрокиТекущегоКлюча.ТекущаяСтрока = Неопределено Тогда
			ЭлементыФормы.СтрокиТекущегоКлюча.ТекущаяСтрока = СтрокиТекущегоКлюча[0];
		КонецЕсли; 
		ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	КонецЕсли;
	Если Автовыделение Тогда
		КПКлючиСтрокВыделитьВИсточнике();
	КонецЕсли;
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ДействияФормыИсходнаяТаблица(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(мТаблицаИсточника,,,, Ложь);
	
КонецПроцедуры

Процедура КлючиСтрокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура КПКлючиСтрокВыделитьВИсточнике(Кнопка = Неопределено)
	
	Если ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = Неопределено Или Не ЗначениеЗаполнено(мСтрокаПолейКлюча) Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
		Если ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("ТабличноеПоле") Тогда
			Попытка
				ЭтаФорма.ВладелецФормы.ИерархическийПросмотр = Ложь;
			Исключение
			КонецПопытки;
			Отбор.Сбросить();
			Для Каждого КолонкаКлюча Из КлючиСтрок.Колонки Цикл
				ЭлементОтбора = Отбор.Найти(КолонкаКлюча.Имя);
				Если ЭлементОтбора = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ирОбщий.УстановитьЭлементОтбораЛкс(ЭлементОтбора,, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока[КолонкаКлюча.Имя]);
			КонецЦикла;
		Иначе
			ЭтаФорма.ВладелецФормы.Отображение = ОтображениеТаблицы.Список;
			ирОбщий.ОтключитьНастройкиКомпоновкиЛкс(Отбор);
			Для Каждого КолонкаКлюча Из КлючиСтрок.Колонки Цикл 
				Если Отбор.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(КолонкаКлюча.Имя)) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ЭлементОтбора = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Отбор, КолонкаКлюча.Имя, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока[КолонкаКлюча.Имя]);
				#Если Сервер И Не Сервер Тогда
					ЭлементОтбора = ВременныеНастройки.Отбор.Элементы.Добавить();
				#КонецЕсли
				ЭлементОтбора.Использование = Истина;
				//ирОбщий.ПроверитьВключитьЭлементНастроекКомпоновкиВПользовательскиеНастройки(ЭлементОтбора);
			КонецЦикла;
		КонецЕсли;
	Иначе
		ирОбщий.ВыделитьСтрокиТабличногоПоляПоКлючуЛкс(ЭтаФорма.ВладелецФормы, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока, мСтрокаПолейКлюча);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	КПКлючиСтрокВыполнить(, Истина);
	
КонецПроцедуры

Процедура МинимальныйРазмерГруппыОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = Элемент.МинимальноеЗначение;
	ГруппироватьСразуПриИзменении();
	
КонецПроцедуры

Процедура ГруппироватьСразуПриИзменении(Элемент = Неопределено)
	
	Если ГруппироватьСразу Тогда
		ПроверитьИСгруппировать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.НадписьОтбор.Заголовок = ирОбщий.ПредставлениеОтбораЛкс(Компоновщик.Настройки.Отбор);
	Если ГруппироватьСразу Тогда
		Если мСтарыйСнимокНастройкиКомпоновки <> ирОбщий.ОбъектВСтрокуXMLЛкс(Компоновщик.Настройки) Тогда
			ирОбщий.КомпоновщикНастроекВосстановитьЛкс(Компоновщик);
			КПКлючиСтрокВыполнить();
			мСтарыйСнимокНастройкиКомпоновки = ирОбщий.ОбъектВСтрокуXMLЛкс(Компоновщик.Настройки);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ЭлементыФормы.КлючевыеКолонки, ВыбраннаяСтрока.Поле,,, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура КлючевыеКолонкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ТабличноеПолеПорядкаКомпоновкиВыборЛкс(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОтборПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура КлючевыеКолонкиПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КлючевыеКолонкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаВыделитьВИсточнике(Кнопка)
	
	ирОбщий.ВыделитьСтрокиТабличногоПоляПоКлючуЛкс(ЭтаФорма.ВладелецФормы, ЭлементыФормы.СтрокиТекущегоКлюча.ТекущаяСтрока,, Ложь);
	
КонецПроцедуры

Процедура КлючевыеКолонкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ирОбщий.ТабличноеПолеЭлементовКомпоновкиПеретаскиваниеЛкс(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыУстановитьГруппирующиеКолонкиПоТаблицеБД(Кнопка)
	
	ФормаВыбораОбъектаБД = ирОбщий.ФормаВыбораОбъектаМетаданныхЛкс(,, мПоследняяВыбраннаяТаблицаБД,,,, Истина, Истина,,, Истина, Истина);
	РезультатВыбора = ФормаВыбораОбъектаБД.ОткрытьМодально();
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	мПоследняяВыбраннаяТаблицаБД = РезультатВыбора.ПолноеИмяОбъекта;
	СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(ирКэш.ИмяТаблицыИзМетаданныхЛкс(мПоследняяВыбраннаяТаблицаБД),,, Ложь);
	#Если Сервер И Не Сервер Тогда
		СтруктураКлюча = Новый Структура;
	#КонецЕсли
	Для Каждого КлючИЗначение Из СтруктураКлюча Цикл
		ЭлементПорядка = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, КлючИЗначение.Ключ);
		Если ЭлементПорядка = Неопределено Тогда
			ирОбщий.СообщитьЛкс("Поле """ + КлючИЗначение.Ключ + """ ключа не найдено в доступных полях компоновки");
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура ОтборПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура АвтовыделениеПриИзменении(Элемент)
	
	КПКлючиСтрокВыделитьВИсточнике();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ГруппировкаТаблицы");
ирОбщий.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоля);
АвтовидимостьКолонокСоставаГруппы = Истина;
