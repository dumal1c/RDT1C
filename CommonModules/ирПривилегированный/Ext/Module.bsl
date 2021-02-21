﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

// Привилегированные процедуры и функции

// Находит все ссылки на массив ссылок.
//
// Параметры:
//  пМассивСсылок – Массив – ссылок;
//  пТаблицаРезультатов - ТаблицаЗначений - возвращаемая таблица с найденными ссылками.
//
Функция НайтиПоСсылкамЛкс(МассивСсылок, ТаблицаРезультатов = Неопределено) Экспорт

	//Если ФильтрПоМетаданным <> Неопределено Тогда
	//	// 8.3.5+
	//	НайденныеСсылки = Вычислить("НайтиПоСсылкам(МассивСсылок,, ФильтрПоМетаданным)");
	//Иначе
		НайденныеСсылки = НайтиПоСсылкам(МассивСсылок);
	//КонецЕсли; 
	Если ТаблицаРезультатов = Неопределено Тогда
		ТаблицаРезультатов = Новый ТаблицаЗначений;
	КонецЕсли; 
	ирОбщий.ПеревестиКолонкиНайтиПоСсылкамЛкс(НайденныеСсылки);
	Для Сч = 0 По НайденныеСсылки.Колонки.Количество() - 1 Цикл
		ТаблицаРезультатов.Колонки.Добавить(НайденныеСсылки.Колонки[Сч].Имя);
	КонецЦикла;
	Для Каждого Строка Из НайденныеСсылки Цикл
		Если Ложь
			Или Строка.Метаданные = Неопределено
		    Или Строка.Ссылка = Неопределено 
		Тогда
		    Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаРезультатов.Добавить();
		НоваяСтрока.Данные = ЗначениеВСтрокуВнутр(Строка.Данные);
		НоваяСтрока.Метаданные = Строка.Метаданные.ПолноеИмя();
		НоваяСтрока.Ссылка = Строка.Ссылка;
	КонецЦикла;
	ирОбщий.ПеревестиКолонкиНайтиПоСсылкамЛкс(ТаблицаРезультатов);
	Возврат ТаблицаРезультатов;
	
КонецФункции

Функция ТекущийСеансЛкс() Экспорт 
	
	Если ирКэш.НомерРежимаСовместимостиЛкс() >= 803007 Тогда
		ТекущийСеанс = Вычислить("ПолучитьТекущийСеансИнформационнойБазы()");
		#Если Сервер И Не Сервер Тогда
			ТекущийСеанс = ПолучитьТекущийСеансИнформационнойБазы();
		#КонецЕсли
	Иначе
		Попытка
			Сеансы = ПолучитьСеансыИнформационнойБазы();
		Исключение
			Сообщить("У пользователя отсутствуют административные права 1С. Некоторые функции инструментов отключены.");
			Возврат Неопределено;
		КонецПопытки; 
		НомерСеанса = НомерСеансаИнформационнойБазы();
		Для Каждого Сеанс Из Сеансы Цикл 
			Если Сеанс.НомерСеанса = НомерСеанса Тогда 
				ТекущийСеанс = Сеанс;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	Если ТекущийСеанс = Неопределено Тогда
		Сообщить("Собственный сеанс не найден");
		Результат = Неопределено;
	Иначе
		Результат = Новый Структура;
		Результат.Вставить("НачалоСеанса", ТекущийСеанс.НачалоСеанса);
		Результат.Вставить("НомерСеанса", ТекущийСеанс.НомерСеанса);
		Результат.Вставить("ИмяПриложения", ТекущийСеанс.ИмяПриложения);
		Результат.Вставить("ИмяКомпьютера", ТекущийСеанс.ИмяКомпьютера);
	КонецЕсли;
	Возврат Результат;

КонецФункции
