﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем РежимОтладки Экспорт;

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	#Если _ Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		КонечнаяНастройка = Новый НастройкиКомпоновкиДанных;
		ВнешниеНаборыДанных = Новый Структура;
		ДокументРезультат = Новый ТабличныйДокумент;
	#КонецЕсли
	ДокументРезультат.Очистить();
	СтандартнаяОбработка = Ложь;
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ТаблицаПодписки = Новый ТаблицаЗначений;
	ТаблицаПодписки.Колонки.Добавить("ОбъектМетаданных", Новый ОписаниеТипов("Строка"));
	ТаблицаПодписки.Колонки.Добавить("ОбъектМетаданныхПредставление", Новый ОписаниеТипов("Строка"));
	ТаблицаПодписки.Колонки.Добавить("Событие", Новый ОписаниеТипов("Строка"));
	ТаблицаПодписки.Колонки.Добавить("Подписка", Новый ОписаниеТипов("Строка"));
	ТаблицаПодписки.Колонки.Добавить("ТипОбъекта", Новый ОписаниеТипов("Строка"));
	ТаблицаПодписки.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	ТаблицаПодписки.Колонки.Добавить("ОбработчикИмя", Новый ОписаниеТипов("Строка"));
	ТаблицаПодписки.Колонки.Добавить("ОбработчикМодуль", Новый ОписаниеТипов("Строка"));
	ТаблицаОбщиеМодули = Новый ТаблицаЗначений;
	ТаблицаОбщиеМодули.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	ТаблицаОбщиеМодули.Колонки.Добавить("КлиентУправляемоеПриложение", Новый ОписаниеТипов("Булево"));
	ТаблицаОбщиеМодули.Колонки.Добавить("КлиентОбычноеПриложение", Новый ОписаниеТипов("Булево"));
	ТаблицаОбщиеМодули.Колонки.Добавить("Сервер", Новый ОписаниеТипов("Булево"));
	ТаблицаОбщиеМодули.Колонки.Добавить("ВнешнееСоединение", Новый ОписаниеТипов("Булево"));
	ТаблицаОбщиеМодули.Колонки.Добавить("ВызовСервера", Новый ОписаниеТипов("Булево"));
	ТаблицаОбщиеМодули.Колонки.Добавить("Привилегированный", Новый ОписаниеТипов("Булево"));
	ТаблицаОбщиеМодули.Индексы.Добавить("Имя");
	Счетчик = 1;
	Для Каждого Подписка Из Метаданные.ПодпискиНаСобытия Цикл
		#Если Сервер И Не Сервер Тогда
			Подписка = Метаданные.ПодпискиНаСобытия.ПередЗаписью1;
		#КонецЕсли
		Для Каждого ТипОбъекта Из Подписка.Источник.Типы() Цикл
			СтрокаТаблицы = ТаблицаПодписки.Добавить();
			СтрокаТаблицы.Событие = Подписка.Событие;
			СтрокаТаблицы.Обработчик = Подписка.Обработчик;
			Фрагменты = ирОбщий.СтрРазделитьЛкс(Подписка.Обработчик);
			СтрокаТаблицы.ОбработчикМодуль = Фрагменты[0];
			СтрокаТаблицы.ОбработчикИмя = Фрагменты[1];
			СтрокаТаблицы.Подписка = Подписка.Имя;
			СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзКонкретногоТипа(ТипОбъекта);
			СтрокаТаблицы.ОбъектМетаданных = СтруктураТипа.Метаданные.ПолноеИмя();
			СтрокаТаблицы.ОбъектМетаданныхПредставление = СтруктураТипа.Метаданные.Представление();
			СтрокаТаблицы.ТипОбъекта = ирОбщий.ПервыйФрагментЛкс(СтруктураТипа.ИмяОбщегоТипа);
			ИмяМодуля = СтрокаТаблицы.ОбработчикМодуль;
			СтрокаМодуля = ТаблицаОбщиеМодули.Найти(ИмяМодуля, "Имя");
			Если СтрокаМодуля = Неопределено Тогда
				СтрокаМодуля = ТаблицаОбщиеМодули.Добавить();
				СтрокаМодуля.Имя = ИмяМодуля;
				МодульМД = Метаданные.ОбщиеМодули.Найти(ИмяМодуля);
				Если МодульМД = Неопределено Тогда
					Продолжить;
				КонецЕсли; 
				#Если Сервер И Не Сервер Тогда
					МодульМД = Метаданные.ОбщиеМодули.ОбщегоНазначения;
				#КонецЕсли
				СтрокаМодуля.Сервер = МодульМД.Сервер;
				СтрокаМодуля.ВызовСервера = МодульМД.ВызовСервера;
				СтрокаМодуля.Привилегированный = МодульМД.Привилегированный;
				СтрокаМодуля.ВнешнееСоединение = МодульМД.ВнешнееСоединение;
				СтрокаМодуля.КлиентОбычноеПриложение = МодульМД.КлиентОбычноеПриложение;
				СтрокаМодуля.КлиентУправляемоеПриложение = МодульМД.КлиентУправляемоеПриложение;
			КонецЕсли; 
		КонецЦикла;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	События = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("События"));

	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	Если ЗначениеЗаполнено(ОбъектМетаданных) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "ОбъектМетаданных", ОбъектМетаданных,,, Ложь);
	КонецЕсли; 
	Если ЗначениеЗаполнено(Событие) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Событие", Событие,,, Ложь);
	КонецЕсли; 
	ВнешниеНаборыДанных = Новый Структура("Таблица, События, ОбщиеМодули", ТаблицаПодписки, События, ТаблицаОбщиеМодули);
	Если РежимОтладки = 2 Тогда
		ирОбщий.ОтладитьЛкс(СхемаКомпоновкиДанных, , КонечнаяНастройка, ВнешниеНаборыДанных);
		Возврат;
	КонецЕсли; 
	ирОбщий.СкомпоноватьВТабличныйДокументЛкс(СхемаКомпоновкиДанных, КонечнаяНастройка, ДокументРезультат, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
КонецПроцедуры

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

РежимОтладки = 0;