﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

#Если Клиент Тогда	
Перем мПараметры Экспорт;
	
// Инициализирует экземпляр класса.
//
// Параметры:
//  *СтруктураЭкземляров - Структура, *Неопределено - содержит все объекты данного класса для данной формы;
//  пФорма       - Форма - владелец элементов управления;
//  пПолеТекстовогоДокумента – ПолеТекстовогоДокумента;
//  пКоманднаяПанель – КоманднаяПанель – в конце которой будут размещены кнопки;
//
Процедура Инициализировать(пФорма, пФормула, пМетодВыполнения = "", пКонтекстВыполнения = Неопределено, Параметры = Неопределено, Описание = Неопределено) Экспорт

	Формула = пФормула;
	КонтекстВыполнения = пКонтекстВыполнения;
	МетодВыполнения = пМетодВыполнения;
	
	Если КонтекстВыполнения = Неопределено Тогда
		КонтекстВыполнения = ЭтотОбъект;
	КонецЕсли;
	Если МетодВыполнения = "" Тогда
		МетодВыполнения = "ВыполнитьЛокально";
	КонецЕсли;
	Попытка
		Выполнить("КонтекстВыполнения." + МетодВыполнения + "(""Неопределено"")");
	Исключение
		//Сообщить(ОписаниеОшибки(), СтатусСообщения.Информация);
		//Сообщить("Задан неверный контекст выполнения программы. Будет использован чистый контекст выполнения", СтатусСообщения.Информация);
		КонтекстВыполнения = ЭтотОбъект;
		МетодВыполнения = "ВычислитьЛокально";
	КонецПопытки;
	ЭтотОбъект.мПараметры = Параметры;
	Если Описание <> Неопределено Тогда
		ЭтотОбъект.Описание = Описание;
	КонецЕсли; 
	
КонецПроцедуры // Инициализировать()

// Освобождает ресурсы занятые экземпляром класса.
// Самое главное - очистить ссылки на формы и объекты БД.
//
// Параметры:
//  Нет.
//
Процедура Уничтожить() Экспорт

	Для Каждого Реквизит Из Метаданные().Реквизиты Цикл
		ЭтотОбъект[Реквизит.Имя] = Неопределено;
	КонецЦикла;

КонецПроцедуры // Уничтожить()

// Вычисляет программный код локально.
//
// Параметры:
//  ТекстДляВычисления – Строка.
//
Функция ВычислитьЛокально(ТекстДляВычисления) Экспорт
	
	Результат = ирОбщий.ВычислитьВыражение(ТекстДляВычисления, мПараметры, НаСервере);
	Возврат Результат;

КонецФункции // ВычислитьЛока()

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

Описание = "Здесь задается выражение для вычисления на встроенном языке. Для обращения к значениям параметров служит переменная Параметры.";
#КонецЕсли
