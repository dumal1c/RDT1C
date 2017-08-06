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
		ОформлениеСтроки.ЦветФона = Новый Цвет(245, 255, 245);
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
		ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, СтрокаТаблицыЗначений);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	//ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка, СтрокаТаблицыЗначений[Колонка.Данные]);
	ФормаСобытия = ПолучитьФорму("ФормаСобытия");
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
	Фильтр = Новый Структура;
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		Фильтр.Вставить("ДатаНачала", НачалоПериода);
	КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		Фильтр.Вставить("ДатаОкончания", КонецПериода);
	КонецЕсли;
	Для Каждого СтрокаОтбора Из Отбор Цикл
		ЗначениеОтбора = СтрокаОтбора.Значение;
		Если Истина
			И ЗначениеОтбора = Неопределено 
			И СтрокаОтбора.Поле <> "Данные"
		Тогда
			СтрокаОтбора.Использование = Ложь;
		КонецЕсли; 
		Если Не СтрокаОтбора.Использование Тогда
			Продолжить;
		КонецЕсли; 
		Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
			Если ЗначениеОтбора.ТипЗначения.Типы().Количество() = 0 Тогда
				СписокЗначений = ЗначениеОтбора;
				ЗначениеОтбора = Новый Массив();
				Для Каждого ЭлементСписка Из СписокЗначений Цикл
					Если ЭлементСписка.Пометка Тогда
						Если СтрокаОтбора.Поле = "Пользователь" Тогда
							ЗначениеЭлемента = ЭлементСписка.Представление;
						Иначе
							ЗначениеЭлемента = ЭлементСписка.Значение;
						КонецЕсли; 
						ЗначениеОтбора.Добавить(ЗначениеЭлемента);
					КонецЕсли; 
				КонецЦикла;
			Иначе
				ЗначениеОтбора = ЗначениеОтбора.ВыгрузитьЗначения();
			КонецЕсли; 
		КонецЕсли; 
		Фильтр.Вставить(СтрокаОтбора.Поле, ЗначениеОтбора);
	КонецЦикла;
	
	НачалоИнтервала = ТекущаяДата();
	ТаблицаЗначенийЖурнала = Новый ТаблицаЗначений;
	Если АнализироватьТранзакцииСУчастиемОбъекта Тогда
		Состояние("Анализ транзакций журнала...");
		ТаблицаТранзакций = Новый ТаблицаЗначений;
		ВыгрузитьЖурналРегистрации(ТаблицаТранзакций, Фильтр,, ИмяФайла, МаксимальныйРазмерВыгрузки);
		ТаблицаТранзакций.Свернуть("Транзакция");
		ТаблицаТранзакций.Сортировать("Транзакция");
		Транзакции = ТаблицаТранзакций.ВыгрузитьКолонку("Транзакция");
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Транзакции.Количество(), "Выгрузка журнала по транзакциям");
		ФильтрТранзакции = ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(Фильтр);
		Для Каждого Транзакция Из Транзакции Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			//ФильтрТранзакции.Вставить("Транзакция", ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(Транзакция, "(",")"));
			ФильтрТранзакции.Вставить("Транзакция", Транзакция);
			Если Транзакция <> "" Тогда
				ФильтрТранзакции.Удалить("Данные");
			КонецЕсли; 
			ТаблицаТранзакции = Новый ТаблицаЗначений;
			ВыгрузитьЖурналРегистрации(ТаблицаТранзакции, ФильтрТранзакции,, ИмяФайла, МаксимальныйРазмерВыгрузки - ТаблицаЗначенийЖурнала.Количество());
			Если Транзакция = "" Тогда
				ТаблицаТранзакции = ТаблицаТранзакции.Скопировать(Новый Структура("Транзакция", ""));
			КонецЕсли; 
			ТаблицаТранзакции.Колонки.Добавить("ПорядокСтроки", Новый ОписаниеТипов("Число"));
			Для Счетчик = 1 По ТаблицаТранзакции.Количество() Цикл
				ТаблицаТранзакции[Счетчик - 1].ПорядокСтроки = ТаблицаЗначенийЖурнала.Количество() + Счетчик;
			КонецЦикла;
			Если ТаблицаЗначенийЖурнала.Колонки.Количество() = 0 Тогда
				ТаблицаЗначенийЖурнала = ТаблицаТранзакции;
			Иначе
				ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ТаблицаТранзакции, ТаблицаЗначенийЖурнала);
			КонецЕсли; 
			Если ТаблицаЗначенийЖурнала.Количество() >= МаксимальныйРазмерВыгрузки Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		//ТаблицаЗначенийЖурнала.Индексы.Добавить("Дата, ПорядокСтроки");
		//ТаблицаЗначенийЖурнала.Сортировать("Дата, ПорядокСтроки");
	Иначе
		Состояние("Выборка из журнала регистрации...");
		ВыгрузитьЖурналРегистрации(ТаблицаЗначенийЖурнала, Фильтр,, ИмяФайла, МаксимальныйРазмерВыгрузки);
		ТаблицаЗначенийЖурнала.Колонки.Добавить("ПорядокСтроки", Новый ОписаниеТипов("Число"));
		Для Счетчик = 1 По ТаблицаЗначенийЖурнала.Количество() Цикл
			ТаблицаЗначенийЖурнала[Счетчик - 1].ПорядокСтроки = Счетчик;
		КонецЦикла;
	КонецЕсли; 
	ТаблицаЗначенийЖурнала.Индексы.Добавить("ПорядокСтроки");
	ТаблицаЗначенийЖурнала.Сортировать("ПорядокСтроки");
	ТаблицаЖурнала.Загрузить(ТаблицаЗначенийЖурнала);
	КоличествоСтрокЖурнала = ТаблицаЖурнала.Количество();
	КонецИнтервала = ТекущаяДата();
	Состояние("");
	
	ДлительностьИнтервала = КонецИнтервала - НачалоИнтервала;
	Если ДлительностьИнтервала > 5 Тогда
		КолвоЧасов = Цел(ДлительностьИнтервала / 3600);
		ДлительностьИнтервалаДата = '00010101' + (КонецИнтервала - НачалоИнтервала) - КолвоЧасов * 3600;
		ДлительностьИнтервалаСтр = Формат(КолвоЧасов, "ЧН=; ЧГ=0") + ":" + Формат(ДлительностьИнтервалаДата, "ДФ=мм:сс; ДП=");
		Сообщить("Загрузка данных журнала выполнена за " + ДлительностьИнтервалаСтр);
	КонецЕсли; 
	
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

Функция _ОтметитьЭлементыСписка(ВыбранныеЗначения, СписокВыбора) 
	
	ФормаФиксированногоСписка = ирКэш.Получить().ПолучитьФорму("ФиксированныйСписокЗначений");
	ФормаФиксированногоСписка.НачальноеЗначениеВыбора = СписокВыбора;
	РезультатВыбора = ФормаФиксированногоСписка.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		Возврат РезультатВыбора;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	
КонецФункции

Процедура ПриОткрытии()
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоДня(ТекущаяДата());
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(МаксимальныйРазмерВыгрузки) Тогда
		//МаксимальныйРазмерВыгрузки = 1000; // Есть подозрение, что указание этого параметра сильно замедляет выборку
	КонецЕсли;
	ДействияФормыОткрытьФайлЖурнала();

КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ТипЗнч(ДанныеСтроки.Значение) = Тип("СписокЗначений") Тогда
		Если ДанныеСтроки.Значение.ТипЗначения.Типы().Количество() = 0 Тогда
			ПредставлениеЗначения = "";
			КоличествоПомеченных = 0;
			Для Каждого ЭлементСписка Из ДанныеСтроки.Значение Цикл
				Если ЭлементСписка.Пометка Тогда
					КоличествоПомеченных = КоличествоПомеченных + 1;
					Если КоличествоПомеченных < 20 Тогда
						Если ПредставлениеЗначения <> "" Тогда
							ПредставлениеЗначения = ПредставлениеЗначения + "; ";
						КонецЕсли;
						ПредставлениеЭлемента = ЭлементСписка.Представление;
						Если Не ЗначениеЗаполнено(ПредставлениеЭлемента) Тогда
							ПредставлениеЭлемента = ЭлементСписка.Значение;
						КонецЕсли; 
						ПредставлениеЗначения = ПредставлениеЗначения + ПредставлениеЭлемента;
					ИначеЕсли КоличествоПомеченных = 20 Тогда
						ПредставлениеЗначения = ПредставлениеЗначения + "...";
					КонецЕсли;
				КонецЕсли; 
			КонецЦикла;
			ОформлениеСтроки.Ячейки.Значение.УстановитьТекст("(" + КоличествоПомеченных + " из " + ДанныеСтроки.Значение.Количество() + ") " + ПредставлениеЗначения);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
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
    КонсольКомпоновокДанных.ОткрытьПоТаблицеЗначений(ТаблицаЖурнала.Выгрузить());
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ТаблицаЖурнала);
	
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
	
КонецПроцедуры

Процедура ОтборПриАктивизацииСтроки(Элемент)

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
	
	ДобавитьЭлементОтбора(Отбор, "Сеанс", НомерСеансаИнформационнойБазы(),,, Ложь);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОтборЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, , Истина);

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
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.Отбор, СтандартнаяОбработка, , Истина);
	
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
	ДобавитьЭлементОтбора(Отбор, "Уровень");
	ДобавитьЭлементОтбора(Отбор, "Комментарий");
	ДобавитьЭлементОтбора(Отбор, "Пользователь");
	ДобавитьЭлементОтбора(Отбор, "Событие");
	ДобавитьЭлементОтбора(Отбор, "СтатусТранзакции");
	ДобавитьЭлементОтбора(Отбор, "ИмяПриложения");
	ДобавитьЭлементОтбора(Отбор, "Данные");
	ДобавитьЭлементОтбора(Отбор, "Метаданные");
	ТаблицаЖурнала.Очистить();
	
КонецПроцедуры

Процедура КоманднаяПанельОтборОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Отбор, ЭтаФорма);
	
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

