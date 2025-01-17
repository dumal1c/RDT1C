﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирКлиент Экспорт;

Функция ОткрытьДляОтладки(ПостроительОтчета, Модально = Истина) Экспорт
	
	Форма = ЭтотОбъект.ПолучитьФорму("Форма");
	ЗаполнитьЗначенияСвойств(ПостроительОтчетов, ПостроительОтчета);
	ПостроительОтчетов.УстановитьНастройки(ПостроительОтчета.ПолучитьНастройки());
	ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ПостроительОтчета.Параметры, ПостроительОтчетов.Параметры);
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецФункции 

Функция ПолучитьПутьСтроки(Строка) Экспорт
	ПутьСтроки = Неопределено;
	
	Если Строка <> Неопределено Тогда
		ТС = Строка;
		Пока ТС <> Неопределено Цикл
			Если ПутьСтроки = Неопределено Тогда
				ПутьСтроки = ТС.Запрос;
			Иначе
				ПутьСтроки = ТС.Запрос + Символы.ПС + ПутьСтроки;
			КонецЕсли;
			ТС = ТС.Родитель;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПутьСтроки;
КонецФункции

Функция НайтиСтрокуПоПути(Путь) Экспорт
	ТекущаяСтрокаДерева = Неопределено;

	Если Путь <> Неопределено Тогда
		
		Для тс = 1 По СтрЧислоСтрок(Путь) Цикл
			ТекущееИмяЗапроса = СтрПолучитьСтроку(Путь, тс);
			
			Если ТекущаяСтрокаДерева = Неопределено Тогда 
				Строки = ДеревоЗапросов.Строки;
			Иначе
				Строки = ТекущаяСтрокаДерева.Строки;
			КонецЕсли;
			
			Найдено = Ложь;
			Для Каждого сд Из Строки Цикл
				Если сд.Запрос = ТекущееИмяЗапроса Тогда
					// Нашли текущее имя
					Найдено = Истина;
					ТекущаяСтрокаДерева = сд;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Не Найдено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТекущаяСтрокаДерева;
КонецФункции

Процедура ДополнитьКолонкиТаблицыПараметров(ТаблицаПараметров) Экспорт 
	
	ДобавленныеКолонкиПараметров = Новый Структура;
	ДобавленныеКолонкиПараметров.Вставить("ТипЗначения", Новый ОписаниеТипов("ОписаниеТипов"));
	ДобавленныеКолонкиПараметров.Вставить("ЗначениеПоУмолчанию");
	ДобавленныеКолонкиПараметров.Вставить("ПредставлениеПараметра", Новый ОписаниеТипов("Строка"));
	ДобавленныеКолонкиПараметров.Вставить("Служебный", Новый ОписаниеТипов("Булево"));
	Для Каждого ДобавленнаяКолонка Из ДобавленныеКолонкиПараметров Цикл
		Если ТаблицаПараметров.Колонки.Найти(ДобавленнаяКолонка.Ключ) = Неопределено Тогда
			ТаблицаПараметров.Колонки.Добавить(ДобавленнаяКолонка.Ключ, ДобавленнаяКолонка.Значение);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ДополнитьКолонкиТаблицыПараметров()

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
//ирПортативный ирОбщий = ирПортативный.ОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ОбщийМодульЛкс("ирСервер");
//ирПортативный ирКлиент = ирПортативный.ОбщийМодульЛкс("ирКлиент");

// Создадим структуру дерева запросов
ДеревоЗапросов.Колонки.Добавить("Запрос");
ДеревоЗапросов.Колонки.Добавить("ИД");
ДеревоЗапросов.Колонки.Добавить("ТекстЗапроса");
ДеревоЗапросов.Колонки.Добавить("ПараметрыЗапроса");
ДеревоЗапросов.Колонки.Добавить("АвтоЗаполнение");
ДеревоЗапросов.Колонки.Добавить("НастройкиПостроителя");
ДеревоЗапросов.Колонки.Добавить("ВыбТипДиаграммы");
ДеревоЗапросов.Колонки.Добавить("РазмещениеГруппировок");
ДеревоЗапросов.Колонки.Добавить("РазмещениеРеквизитов");
ДеревоЗапросов.Колонки.Добавить("ТипОформления");
ДеревоЗапросов.Колонки.Добавить("ПредставленияДляИмен");
ДеревоЗапросов.Колонки.Добавить("ИспользоватьМакет");
ДеревоЗапросов.Колонки.Добавить("ЛиМинимальнаяШирина");
ДеревоЗапросов.Колонки.Добавить("Макет");
ДеревоЗапросов.Колонки.Добавить("ВыводВДиаграмму");
ДеревоЗапросов.Колонки.Добавить("ВыводВСводнуюТаблицу");
ДеревоЗапросов.Колонки.Добавить("ВыводВТаблицу");
ДеревоЗапросов.Колонки.Добавить("ПоУмолчаниюВыводитьВ");
ДеревоЗапросов.Колонки.Добавить("ОтчетРасшифровки");
ДеревоЗапросов.Колонки.Добавить("РазмещениеИтогов");
ДеревоЗапросов.Колонки.Добавить("НастройкаДляЗагрузки");
ДеревоЗапросов.Колонки.Добавить("СохранятьНастройкиАвтоматически");
ДеревоЗапросов.Колонки.Добавить("ФиксированныйЗаголовок");
ДеревоЗапросов.Колонки.Добавить("МакетСОформлением");
ДеревоЗапросов.Колонки.Добавить("ФорматыДляИмен");
ДеревоЗапросов.Колонки.Добавить("ВыбТипСводДиаграммы");
ДеревоЗапросов.Колонки.Добавить("ВыводВСводДиаграмму");

ПостроительОтчетов.ВыводитьДетальныеЗаписи = Истина;
ПостроительОтчетов.АвтоДетальныеЗаписи = Истина;
РасширенныйРежим = Истина;
ОтображатьНастройки = Истина;

