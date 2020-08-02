﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Функция ПолучитьСписокЗначенийЭлементаОтбора(ПолеОтбора) Экспорт 
	
	Если ПолеОтбора = "Уровень" Тогда
		ВозможныеЗначения = Новый СписокЗначений;
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Ошибка);
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Предупреждение);
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Информация); 
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Примечание);
	ИначеЕсли ПолеОтбора = "СтатусТранзакции" Тогда
		ВозможныеЗначения = Новый СписокЗначений;
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована);
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена);
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена);
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции);
	ИначеЕсли Ложь
		Или ПолеОтбора = "Пользователь" 
		Или ПолеОтбора = "Компьютер" 
		Или ПолеОтбора = "ИмяПриложения" 
		Или ПолеОтбора = "Событие" 
		Или ПолеОтбора = "Метаданные" 
		Или ПолеОтбора = "РабочийСервер" 
		Или ПолеОтбора = "ОсновнойIPПорт" 
		Или ПолеОтбора = "ВспомогательныйIPПорт" 
		Или ПолеОтбора = "РазделениеДанныхСеанса" 
	Тогда
		СтруктураЗначенийОтбора = ПолучитьЗначенияОтбораЖурналаРегистрации(ПолеОтбора, ИмяФайла);
		ВозможныеЗначения = СтруктураЗначенийОтбора[ирОбщий.ПеревестиСтроку(ПолеОтбора)];
	Иначе
		ВозможныеЗначения = Неопределено;
	КонецЕсли; 
	Если ВозможныеЗначения <> Неопределено Тогда
		Если ТипЗнч(ВозможныеЗначения) = Тип("СписокЗначений") Тогда
			СписокВыбора = ВозможныеЗначения;
		ИначеЕсли ТипЗнч(ВозможныеЗначения) = Тип("Массив") Тогда
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.ЗагрузитьЗначения(ВозможныеЗначения);
			СписокВыбора.СортироватьПоЗначению();
		ИначеЕсли ТипЗнч(ВозможныеЗначения) = Тип("Соответствие") Тогда
			СписокВыбора = Новый СписокЗначений;
			Для Каждого КлючИЗначение Из ВозможныеЗначения Цикл
				СписокВыбора.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЦикла; 
			СписокВыбора.СортироватьПоПредставлению();
		КонецЕсли; 
	КонецЕсли;
	Возврат СписокВыбора;

КонецФункции

Функция УстановитьОписаниеТиповЗначенияОтбора(СтрокаОтбора) Экспорт
	
	ПолеОтбора = СтрокаОтбора.Поле;
	МетаРеквизит = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ПолеОтбора];
	БазовоеОписаниеТипов = МетаРеквизит.Тип;
	Если Ложь
		Или ПолеОтбора = "Уровень"
		Или ПолеОтбора = "СтатусТранзакции"
		Или ПолеОтбора = "Пользователь" 
		Или ПолеОтбора = "Компьютер" 
		Или ПолеОтбора = "ИмяПриложения" 
		Или ПолеОтбора = "Событие" 
		Или ПолеОтбора = "Метаданные" 
		Или ПолеОтбора = "РабочийСервер" 
		Или ПолеОтбора = "ОсновнойIPПорт" 
		Или ПолеОтбора = "ВспомогательныйIPПорт" 
		Или ПолеОтбора = "РазделениеДанныхСеанса" 
	Тогда
		ОписаниеТипов = Новый ОписаниеТипов("СписокЗначений");
	ИначеЕсли ПолеОтбора = "Сеанс" Тогда
		ОписаниеТипов = Новый ОписаниеТипов(БазовоеОписаниеТипов, "СписокЗначений");
	Иначе
		ОписаниеТипов = БазовоеОписаниеТипов;
	КонецЕсли; 
	СтрокаОтбора.ОписаниеТипов = ОписаниеТипов;
	СтрокаОтбора.Значение = ОписаниеТипов.ПривестиЗначение(СтрокаОтбора.Значение);
	СтрокаОтбора.Представление = МетаРеквизит.Представление();
	Если МетаРеквизит.Имя = "Данные" Тогда
		//СтрокаОтбора.Представление = "Данные (медленно!)";
	КонецЕсли; 
	
КонецФункции

Функция ДобавитьЭлементОтбора(Отбор, ПолеОтбора = "Данные", Знач ЗначениеОтбора = Неопределено, ПредставлениеЗначения = Неопределено,
	Использование = Неопределено, ОставлятьСтарыеПометки = Истина) Экспорт
	
	Если ПолеОтбора = "Уровень" И ТипЗнч(ЗначениеОтбора) = Тип("Строка") Тогда
		ЗначениеОтбора = УровеньЖурналаРегистрации[ЗначениеОтбора];
	КонецЕсли; 
	ДоступныеЗначенияЭлементаОтбора = ПолучитьСписокЗначенийЭлементаОтбора(ПолеОтбора);
	СтрокаОтбора = Отбор.Найти(ПолеОтбора);
	Если СтрокаОтбора = Неопределено Тогда
		СтрокаОтбора = Отбор.Добавить();
		СтрокаОтбора.Поле = ПолеОтбора;
		СтрокаОтбора.Значение = ДоступныеЗначенияЭлементаОтбора;
	КонецЕсли;
	УстановитьОписаниеТиповЗначенияОтбора(СтрокаОтбора);
	Если Использование <> Неопределено Тогда
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаОтбора.Использование, Использование);
	КонецЕсли; 
	Если ТипЗнч(СтрокаОтбора.Значение) = Тип("СписокЗначений") Тогда
		СписокВыбора = СтрокаОтбора.Значение;
		Если Не ОставлятьСтарыеПометки Тогда
			СписокВыбора.ЗаполнитьПометки(Ложь);
		КонецЕсли; 
		Если ТипЗнч(ЗначениеОтбора) <> Тип("СписокЗначений") Тогда
			лПустышка = ЗначениеОтбора;
			ЗначениеОтбора = Новый СписокЗначений;
			ЗначениеОтбора.Добавить(лПустышка, , Истина);
		КонецЕсли; 
		Для Каждого ЭлементСписка Из СписокВыбора Цикл
			ЭлементСтарогоСписка = ЗначениеОтбора.НайтиПоЗначению(ЭлементСписка.Значение);
			Если ЭлементСтарогоСписка <> Неопределено Тогда
				ЭлементСписка.Пометка = ЭлементСтарогоСписка.Пометка;
			КонецЕсли; 
		КонецЦикла;
		Для Каждого ДоступноеЗначение Из ДоступныеЗначенияЭлементаОтбора Цикл
			ЭлементСписка = СписокВыбора.НайтиПоЗначению(ДоступноеЗначение.Значение);
			Если ЭлементСписка = Неопределено Тогда
				ЭлементСписка = СписокВыбора.Добавить();
			КонецЕсли; 
			ЗаполнитьЗначенияСвойств(ЭлементСписка, ДоступноеЗначение,, "Пометка"); 
		КонецЦикла;
		СписокВыбора.СортироватьПоПредставлению();
	Иначе
		Если ЗначениеОтбора = Неопределено Тогда
			ЗначениеОтбора = СтрокаОтбора.Значение;
		КонецЕсли; 
		СтрокаОтбора.Значение = СтрокаОтбора.ОписаниеТипов.ПривестиЗначение(ЗначениеОтбора);
	КонецЕсли; 
	Возврат СтрокаОтбора;
	
КонецФункции

Процедура ЗаполнитьОтборВыгрузки() Экспорт 
	
	СписокУровнейОтбора = Новый СписокЗначений;
	СписокУровнейОтбора.Добавить(УровеньЖурналаРегистрации.Ошибка,, Истина);
	СписокУровнейОтбора.Добавить(УровеньЖурналаРегистрации.Предупреждение,, Истина);
	ДобавитьЭлементОтбора(Отбор, "Уровень", СписокУровнейОтбора);
	ДобавитьЭлементОтбора(Отбор, "Комментарий");
	ДобавитьЭлементОтбора(Отбор, "Пользователь");
	ДобавитьЭлементОтбора(Отбор, "Событие");
	ДобавитьЭлементОтбора(Отбор, "СтатусТранзакции");
	ДобавитьЭлементОтбора(Отбор, "ИмяПриложения");
	ДобавитьЭлементОтбора(Отбор, "Данные");
	ДобавитьЭлементОтбора(Отбор, "Метаданные");

КонецПроцедуры

Функция ПолучитьДанные(НачалоПериода = Неопределено, КонецПериода = Неопределено, СтруктураОтбора = Неопределено, МаксимальныйРазмерВыгрузки = Неопределено) Экспорт 
	
	//ЗаполнитьОтборВыгрузки();
	Если НачалоПериода <> Неопределено Тогда
		ЭтотОбъект.НачалоПериода = НачалоПериода;
	Иначе
		ЭтотОбъект.НачалоПериода = НачалоДня(ТекущаяДата());
	КонецЕсли; 
	Если КонецПериода <> Неопределено Тогда
		ЭтотОбъект.КонецПериода = КонецПериода;
	Иначе
		ЭтотОбъект.КонецПериода = Неопределено;
	КонецЕсли; 
	Если МаксимальныйРазмерВыгрузки <> Неопределено Тогда
		ЭтотОбъект.МаксимальныйРазмерВыгрузки = МаксимальныйРазмерВыгрузки;
	КонецЕсли; 
	Если СтруктураОтбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из СтруктураОтбора Цикл
			ДобавитьЭлементОтбора(ЭтотОбъект.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение,, Истина);
		КонецЦикла; 
	КонецЕсли;
	ЗагрузитьДанныеЖурнала();
	Возврат ТаблицаЖурнала;
	
КонецФункции

Процедура ЗагрузитьДанныеЖурнала() Экспорт 
	
	Фильтр = ПолучитьФильтрВыгрузкиЖурнала();
	Если Фильтр = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		Фильтр = Новый Структура;
	#КонецЕсли
	НачалоИнтервала = ТекущаяДата();
	ЭтотОбъект.ТаблицаЗначенийЖурнала = Новый ТаблицаЗначений;
	Если Фильтр.Свойство("Данные") Тогда
		// Антибаг платформы 8.3.8-14 https://partners.v8.1c.ru/forum/t/1807905/m/1807905
		МаксимальныйРазмерВыгрузкиТекущий = 0;
	Иначе
		МаксимальныйРазмерВыгрузкиТекущий = МаксимальныйРазмерВыгрузки;
	КонецЕсли; 
	Если АнализироватьТранзакцииСУчастиемОбъекта Тогда
		#Если Клиент Тогда
		Состояние("Анализ транзакций журнала...");
		#КонецЕсли
		ТаблицаТранзакций = Новый ТаблицаЗначений;
		ВыгрузитьЖурналРегистрации(ТаблицаТранзакций, Фильтр,, ИмяФайла, МаксимальныйРазмерВыгрузкиТекущий);
		ТаблицаТранзакций.Свернуть("Транзакция");
		ТаблицаТранзакций.Сортировать("Транзакция");
		Транзакции = ТаблицаТранзакций.ВыгрузитьКолонку("Транзакция");
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Транзакции.Количество(), "Выгрузка журнала по транзакциям");
		ФильтрТранзакции = ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(Фильтр);
		Для Каждого Транзакция Из Транзакции Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			//ФильтрТранзакции.Вставить("Транзакция", ирОбщий.СтрокаМеждуМаркерамиЛкс(Транзакция, "(",")"));
			ФильтрТранзакции.Вставить("Транзакция", Транзакция);
			Если Транзакция <> "" Тогда
				ФильтрТранзакции.Удалить("Данные");
			КонецЕсли; 
			ТаблицаТранзакции = Новый ТаблицаЗначений;
			Если МаксимальныйРазмерВыгрузкиТекущий > 0 Тогда
				МаксимальныйРазмерВыгрузкиТекущий = МаксимальныйРазмерВыгрузкиТекущий - ТаблицаЗначенийЖурнала.Количество();
			КонецЕсли; 
			ВыгрузитьЖурналРегистрации(ТаблицаТранзакции, ФильтрТранзакции,, ИмяФайла, МаксимальныйРазмерВыгрузкиТекущий);
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
			Если МаксимальныйРазмерВыгрузкиТекущий > 0 И ТаблицаЗначенийЖурнала.Количество() >= МаксимальныйРазмерВыгрузкиТекущий Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		//ТаблицаЗначенийЖурнала.Индексы.Добавить("Дата, ПорядокСтроки");
		//ТаблицаЗначенийЖурнала.Сортировать("Дата, ПорядокСтроки");
	Иначе
		#Если Клиент Тогда
		Состояние("Выборка из журнала регистрации...");
		#КонецЕсли
		ВыгрузитьЖурналРегистрации(ТаблицаЗначенийЖурнала, Фильтр,, ИмяФайла, МаксимальныйРазмерВыгрузкиТекущий);
		ТаблицаЗначенийЖурнала.Колонки.Добавить("ПорядокСтроки", Новый ОписаниеТипов("Число"));
		Для Счетчик = 1 По ТаблицаЗначенийЖурнала.Количество() Цикл
			ТаблицаЗначенийЖурнала[Счетчик - 1].ПорядокСтроки = Счетчик;
		КонецЦикла;
	КонецЕсли; 
	ТаблицаЗначенийЖурнала.Индексы.Добавить("ПорядокСтроки");
	ТаблицаЗначенийЖурнала.Сортировать("ПорядокСтроки");
	ирОбщий.ПеревестиКолонкиВыгрузитьЖурналРегистрацииЛкс(ТаблицаЗначенийЖурнала);
	ТаблицаЖурнала.Загрузить(ТаблицаЗначенийЖурнала);
	ЭтотОбъект.КоличествоСтрокЖурнала = ТаблицаЖурнала.Количество();
	КонецИнтервала = ТекущаяДата();
	#Если Клиент Тогда
	Состояние("");
	#КонецЕсли
	
	ДлительностьИнтервала = КонецИнтервала - НачалоИнтервала;
	Если ВыводитьДлительностьВыгрузки Или ДлительностьИнтервала > 5 Тогда
		КолвоЧасов = Цел(ДлительностьИнтервала / 3600);
		ДлительностьИнтервалаДата = '00010101' + (КонецИнтервала - НачалоИнтервала) - КолвоЧасов * 3600;
		ДлительностьИнтервалаСтр = Формат(КолвоЧасов, "ЧН=; ЧГ=0") + ":" + Формат(ДлительностьИнтервалаДата, "ДФ=мм:сс; ДП=");
		ИспользованныйВариант = ОписаниеВариантаОтбора(Истина);
		ПредставлениеОтбора = ПредставлениеВариантаОтбора(ИспользованныйВариант);
		ирОбщий.СообщитьЛкс("Выгрузка данных журнала выполнена за " + ДлительностьИнтервалаСтр + ". Отбор - " + ПредставлениеОтбора);
	КонецЕсли;
	Если МаксимальныйРазмерВыгрузки > 0 И МаксимальныйРазмерВыгрузки = ТаблицаЖурнала.Количество() Тогда
		ирОбщий.СообщитьЛкс("Выгрузка прервана по максимально допустимому количеству сообщений");
	КонецЕсли; 

КонецПроцедуры

Функция ОписаниеВариантаОтбора(Полное = Ложь) Экспорт 
	
	Результат = Новый Структура;
	Если Полное Или ЗначениеЗаполнено(КонецПериода) Тогда
		Результат.Вставить("НачалоПериода", НачалоПериода);
		Результат.Вставить("КонецПериода", КонецПериода);
	КонецЕсли; 
	Результат.Вставить("МаксимальныйРазмерВыгрузки", МаксимальныйРазмерВыгрузки);
	Результат.Вставить("Отбор", Отбор);
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеВариантаОтбора(Знач СохраняемыйВариант) Экспорт 
	
	ИмяВарианта = "";
	Если СохраняемыйВариант.Свойство("НачалоПериода") И ЗначениеЗаполнено(СохраняемыйВариант.НачалоПериода) Тогда
		ИмяВарианта = ИмяВарианта + " С " + СохраняемыйВариант.НачалоПериода;
	КонецЕсли; 
	Если СохраняемыйВариант.Свойство("КонецПериода") И ЗначениеЗаполнено(СохраняемыйВариант.КонецПериода) Тогда
		ИмяВарианта = ИмяВарианта + " По " + СохраняемыйВариант.КонецПериода;
	КонецЕсли; 
	Если ЗначениеЗаполнено(СохраняемыйВариант.МаксимальныйРазмерВыгрузки) Тогда
		ИмяВарианта = ИмяВарианта + "; Количество <= " + СохраняемыйВариант.МаксимальныйРазмерВыгрузки;
	КонецЕсли; 
	Для Каждого СтрокаОтбора Из СохраняемыйВариант.Отбор Цикл
		ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора(СтрокаОтбора);
		Если ТипЗнч(СтрокаОтбора.Значение) = Тип("СписокЗначений") И СтрокаОтбора.Значение.ТипЗначения.Типы().Количество() = 0 Тогда
			ПредставлениеСтрокиОтбора = ПредставлениеСтрокиОтбора(СтрокаОтбора,, 3);
			ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора И ЗначениеЗаполнено(ПредставлениеСтрокиОтбора);
		Иначе
			ПредставлениеСтрокиОтбора = "" + СтрокаОтбора.Значение;
		КонецЕсли; 
		Если ИспользованиеСтрокиОтбора Тогда
			ИмяВарианта = ИмяВарианта + "; " + СтрокаОтбора.Представление + " = " + ПредставлениеСтрокиОтбора;
		КонецЕсли; 
	КонецЦикла;
	Если Лев(ИмяВарианта, 1) = ";" Тогда
		ИмяВарианта = Сред(ИмяВарианта, 3);
	КонецЕсли; 
	Возврат ИмяВарианта;

КонецФункции

Функция ПредставлениеСтрокиОтбора(Знач ДанныеСтроки, выхКоличествоПомеченных = 0, МаксЭлементов = 20) Экспорт 
	
	Результат = "";
	Если ДанныеСтроки.Значение <> Неопределено Тогда
		выхКоличествоПомеченных = 0;
		Для Каждого ЭлементСписка Из ДанныеСтроки.Значение Цикл
			Если ЭлементСписка.Пометка Тогда
				выхКоличествоПомеченных = выхКоличествоПомеченных + 1;
				Если выхКоличествоПомеченных < МаксЭлементов Тогда
					Если Результат <> "" Тогда
						Результат = Результат + "; ";
					КонецЕсли;
					ПредставлениеЭлемента = ЭлементСписка.Представление;
					Если Не ЗначениеЗаполнено(ПредставлениеЭлемента) Тогда
						ПредставлениеЭлемента = ЭлементСписка.Значение;
					КонецЕсли; 
					Результат = Результат + ПредставлениеЭлемента;
				ИначеЕсли выхКоличествоПомеченных = МаксЭлементов Тогда
					Результат = Результат + "...";
				КонецЕсли;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Функция ИспользованиеСтрокиОтбора(Знач СтрокаОтбора) Экспорт 
	
	ИспользованиеСтрокиОтбора = СтрокаОтбора.Использование;
	Если ИспользованиеСтрокиОтбора Тогда
		Если СтрокаОтбора.Поле = "Данные" Тогда
			ИспользованиеСтрокиОтбора = СтрокаОтбора.Значение <> Неопределено;
		ИначеЕсли ТипЗнч(СтрокаОтбора.Значение) = Тип("Строка") Тогда
			ИспользованиеСтрокиОтбора = ЗначениеЗаполнено(СтрокаОтбора.Значение);
		КонецЕсли; 
	КонецЕсли;
	Возврат ИспользованиеСтрокиОтбора;

КонецФункции

Функция ПолучитьФильтрВыгрузкиЖурнала()
	
	Фильтр = Новый Структура;
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		Фильтр.Вставить("ДатаНачала", НачалоПериода);
	КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		Фильтр.Вставить("ДатаОкончания", КонецПериода);
	КонецЕсли;
	Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) И НачалоПериода > КонецПериода Тогда
		ирОбщий.СообщитьЛкс("Конец периода меньше начала периода", СтатусСообщения.Важное);
		Возврат Неопределено;
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
				СписокЗначенийЛ = ЗначениеОтбора;
				ЗначениеОтбора = Новый Массив();
				Для Каждого ЭлементСписка Из СписокЗначенийЛ Цикл
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
	Возврат Фильтр;

КонецФункции

#Если Клиент Тогда
	
Функция ВыбратьОбъектМетаданных(СтрокаТаблицыЗначений) Экспорт 
	
	СвойствоМетаданные = СтрокаТаблицыЗначений.Метаданные;
	СвойствоДанные = СтрокаТаблицыЗначений.Данные;
	Если ТипЗнч(СвойствоМетаданные) = Тип("Массив") Тогда 
		Если СвойствоМетаданные.Количество() = 0 Тогда 
			Возврат Неопределено;
		КонецЕсли; 
		Если СвойствоМетаданные.Количество() = 1 Тогда 
			ПолноеИмяМД = СвойствоМетаданные[0];
		Иначе
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.ЗагрузитьЗначения(СвойствоМетаданные);
			СписокВыбора.СортироватьПоЗначению();
			РезультатВыбора = СписокВыбора.ВыбратьЭлемент("Выберите объект метаданных");
			Если РезультатВыбора = Неопределено Тогда
				Возврат Неопределено;
			КонецЕсли; 
			ПолноеИмяМД = РезультатВыбора.Значение;
		КонецЕсли;
	Иначе
		ПолноеИмяМД = СвойствоМетаданные;
	КонецЕсли;
	Возврат ПолноеИмяМД;

КонецФункции

Функция ОткрытьСПараметром(ПолеОтбора = "Данные", ЗначениеОтбора, ПредставлениеЗначения = Неопределено) Экспорт 
	
	Форма = ПолучитьФорму(,, ЗначениеОтбора);
	Форма.Открыть();
	Форма.Отбор.ЗаполнитьЗначения(Ложь, "Использование");
	Форма.НачалоПериода = НачалоДня(ТекущаяДата());
	Форма.КонецПериода = Неопределено;
	ДобавитьЭлементОтбора(Форма.Отбор, ПолеОтбора, ЗначениеОтбора, ПредставлениеЗначения);
	Ответ = Вопрос("Сразу выполнить выгрузку с текущим отбором?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Форма.ОбновитьТаблицуЖурнала();
	КонецЕсли;
	Возврат Форма;
	
КонецФункции

Функция ОткрытьСОтбором(НачалоПериода = Неопределено, КонецПериода = Неопределено, СтруктураОтбора = Неопределено, МаксимальныйРазмерВыгрузки = Неопределено) Экспорт 
	
	Форма = ПолучитьФорму(,,);
	Форма.Открыть();
	Форма.Отбор.ЗаполнитьЗначения(Ложь, "Использование");
	Если НачалоПериода <> Неопределено Тогда
		Форма.НачалоПериода = НачалоПериода;
	Иначе
		Форма.НачалоПериода = НачалоДня(ТекущаяДата());
	КонецЕсли; 
	Если КонецПериода <> Неопределено Тогда
		Форма.КонецПериода = КонецПериода;
	Иначе
		Форма.КонецПериода = Неопределено;
	КонецЕсли; 
	Если МаксимальныйРазмерВыгрузки <> Неопределено Тогда
		Форма.МаксимальныйРазмерВыгрузки = МаксимальныйРазмерВыгрузки;
	КонецЕсли; 
	Если СтруктураОтбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из СтруктураОтбора Цикл
			ДобавитьЭлементОтбора(Форма.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение,, Истина);
		КонецЦикла; 
	КонецЕсли;
	Ответ = Вопрос("Сразу выполнить выгрузку с текущим отбором?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Форма.ОбновитьТаблицуЖурнала();
	КонецЕсли;
	Возврат Форма;
	
КонецФункции

#КонецЕсли

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

Отбор.Колонки.Добавить("Использование", Новый ОписаниеТипов("Булево"));
Отбор.Колонки.Добавить("Поле", Новый ОписаниеТипов("Строка"));
Отбор.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
Отбор.Колонки.Добавить("ОписаниеТипов", Новый ОписаниеТипов("ОписаниеТипов"));
Отбор.Колонки.Добавить("Значение");
ЭтотОбъект.МаксимальныйРазмерВыгрузки = 1000;
