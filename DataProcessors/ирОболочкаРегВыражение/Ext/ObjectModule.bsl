﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем ТекущийДвижок;
Перем Вычислитель;
Перем ТипВхождения;
Перем ВхождениеОбразец;
Перем ЧтениеJSON;
Перем СтарыйGlobal;
Перем СтарыйIgnoreCase;
Перем СтарыйMultiline;
Перем СтарыйPattern;
Перем ДоступныеДвижкиСтруктура;

Функция НайтиВхождения(Знач ТекстГдеИскать, ТолькоПоследнее = Ложь) Экспорт 
	Если ТекстГдеИскать = Неопределено Тогда
		ТекстГдеИскать = "";
	КонецЕсли; 
	Вхождения = Новый Массив;
	Если ТекущийДвижок = "VBScript" Тогда
		РезультатПоиска = Вычислитель().Execute(ТекстГдеИскать);
		Если РезультатПоиска.Count > 0 Тогда
			Если ТолькоПоследнее Тогда
				Вхождения.Добавить(РезультатПоиска.Item(РезультатПоиска.Count - 1));
			Иначе
				Для каждого Элемент из РезультатПоиска Цикл
					Вхождения.Добавить(Элемент);
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		Попытка
			РезультатJSON = Вычислитель().MatchesJSON(ТекстГдеИскать);
		Исключение
			ВызватьИсключение Вычислитель().ОписаниеОшибки;
		КонецПопытки;
		Если ЗначениеЗаполнено(РезультатJSON) Тогда
			УстановитьПривилегированныйРежим(Истина);
			Если ТипВхождения = Неопределено Тогда
				ВхождениеОбразец = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирОболочкаРегВхождение");
				ТипВхождения = ТипЗнч(ВхождениеОбразец); // Надо удерживать ВхождениеОбразец, чтобы для внешней обработки ТипВхождения не разрушался
				ЧтениеJSON = Вычислить("Новый ЧтениеJSON"); //
				#Если Сервер И Не Сервер Тогда
					ЧтениеJSON = Новый ЧтениеJSON;
				#КонецЕсли
			КонецЕсли; 
			ЧтениеJSON.УстановитьСтроку(РезультатJSON);
			Коллекция = Вычислить("ПрочитатьJSON(ЧтениеJSON, Ложь)"); // 8.3
			#Если Сервер И Не Сервер Тогда
				Коллекция = Новый Массив;
			#КонецЕсли
			Если Коллекция.Количество() > 0 Тогда
				Если ТолькоПоследнее Тогда
					Элемент = Коллекция[Коллекция.ВГраница()];
					Коллекция = Новый Массив;
					Коллекция.Добавить(Элемент);
				КонецЕсли; 
				Для Каждого Элемент Из Коллекция Цикл
					Вхождение = Новый (ТипВхождения);
					ЗаполнитьЗначенияСвойств(Вхождение, Элемент, "FirstIndex, Length, SubMatches, Value"); 
					Вхождения.Добавить(Вхождение);
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Результат = Вхождения;
	Возврат Результат;
КонецФункции

Функция Replace(Знач ТекстГдеИскать, Знач ШаблонЗамены) Экспорт 
	Если ТекстГдеИскать = Неопределено Тогда
		ТекстГдеИскать = "";
	КонецЕсли; 
	Если ТекущийДвижок = "VBScript" Тогда
		Результат = Вычислитель().Replace(ТекстГдеИскать, ШаблонЗамены);
	Иначе
		Попытка
			Результат = Вычислитель().Replace(ТекстГдеИскать,, ШаблонЗамены);
		Исключение
			// После номера группы обязательно делать не цифру. Тогда будет работать одинаково в VBScript и PCRE2. Например вместо "$152" делать "$1 52", иначе PCRE2 будет читать "ссылка на группу 152"
			ВызватьИсключение Вычислитель().ОписаниеОшибки;
		КонецПопытки;
	КонецЕсли; 
	Возврат Результат;
КонецФункции

Функция Test(Знач ТекстГдеИскать) Экспорт 
	Если ТекстГдеИскать = Неопределено Тогда
		ТекстГдеИскать = "";
	КонецЕсли; 
	Если ТекущийДвижок = "VBScript" Тогда
		Результат = Вычислитель().Test(ТекстГдеИскать);
	Иначе
		Результат = Вычислитель().Test(ТекстГдеИскать);
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция КоличествоПодгрупп(Вхождение) Экспорт 
	Если ТипЗнч(Вхождение.SubMatches) = Тип("Массив") Тогда
		Результат = Вхождение.SubMatches.Количество();
	Иначе
		Результат = Вхождение.SubMatches.Count;
	КонецЕсли;
	Возврат Результат; 
КонецФункции

Функция ДоступенPCRE2() Экспорт 
	
	Возврат ирКэш.НомерВерсииПлатформыЛкс() >= 803006;

КонецФункции

Функция ДоступенVBScript() Экспорт 
	
	Возврат ирКэш.ЛиПлатформаWindowsЛкс();

КонецФункции

Функция ДоступныеДвижки(ВернутьСтруктуру = Ложь) Экспорт 
	
	Если ВернутьСтруктуру И ДоступныеДвижкиСтруктура <> Неопределено Тогда
		Возврат ДоступныеДвижкиСтруктура;
	КонецЕсли; 
	Список = Новый СписокЗначений;
	Если ДоступенPCRE2() Тогда
		// https://www.pcre.org/current/doc/html
		// https://github.com/alexkmbk/RegEx1CAddin
		Список.Добавить("PCRE2"); 
	КонецЕсли; 
	Если ДоступенVBScript() Тогда
		Список.Добавить("VBScript");
	КонецЕсли; 
	Если ВернутьСтруктуру Тогда
		ДоступныеДвижкиСтруктура = Новый Структура;
		Для Каждого ЭлементСписка Из Список Цикл
			ДоступныеДвижкиСтруктура.Вставить(ЭлементСписка.Значение, ЭлементСписка.Значение);
		КонецЦикла;
		Список = ДоступныеДвижкиСтруктура;
	КонецЕсли; 
	Возврат Список;

КонецФункции

Функция ТекущийДвижок() Экспорт 
	
	Возврат ТекущийДвижок;

КонецФункции

Функция УстановитьДвижок(НовыйДвижок) Экспорт 
	
	Если ТекущийДвижок = НовыйДвижок Тогда
		Возврат Истина;
	КонецЕсли; 
	Если НовыйДвижок = "PCRE2" Тогда
		Если ДоступенPCRE2() Тогда
			ТекущийДвижок = НовыйДвижок;
		КонецЕсли; 
	ИначеЕсли НовыйДвижок = "VBScript" Тогда
		Если ДоступенVBScript() Тогда
			ТекущийДвижок = НовыйДвижок;
		КонецЕсли; 
	КонецЕсли;
	Если ТекущийДвижок = НовыйДвижок Тогда
		СтарыйGlobal = Неопределено;
		СтарыйIgnoreCase = Неопределено;
		СтарыйMultiline = Неопределено;
		СтарыйPattern = Неопределено;
		Вычислитель = Неопределено;
	КонецЕсли; 
	Возврат ТекущийДвижок = НовыйДвижок;
	
КонецФункции

Функция Вычислитель()
	Если Вычислитель = Неопределено Тогда
		Если ТекущийДвижок = "VBScript" Тогда
			Вычислитель = Новый COMОбъект("VBScript.RegExp");
		Иначе
			мПлатформа = ирКэш.Получить();
			#Если Сервер И Не Сервер Тогда
				мПлатформа = Обработки.ирПлатформа.Создать();
			#КонецЕсли
			Вычислитель = мПлатформа.ПолучитьОбъектВнешнейКомпонентыИзМакета("RegEx", "AddIn.ВычислительРегВыражений.RegEx", "ВычислительРегВыражений", ТипВнешнейКомпоненты.Native);
			Вычислитель.ВызыватьИсключения = Истина;
		КонецЕсли; 
	КонецЕсли; 
	Если Ложь 
		// Ускорение
		Или СтарыйGlobal <> Global
		Или СтарыйIgnoreCase <> IgnoreCase
		Или СтарыйMultiline <> Multiline
		Или СтарыйPattern <> Pattern 
	Тогда
		ЗаполнитьЗначенияСвойств(Вычислитель, ЭтотОбъект, "Global, IgnoreCase, Multiline, Pattern");
		СтарыйGlobal = Global;
		СтарыйIgnoreCase = IgnoreCase;
		СтарыйMultiline = Multiline;
		СтарыйPattern = Pattern;
	КонецЕсли;
	Возврат Вычислитель;
КонецФункции

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

IgnoreCase = Истина;
Если ДоступенPCRE2() Тогда
	ТекущийДвижок = "PCRE2";
КонецЕсли; 
#Если Клиент Тогда
Если ДоступенVBScript() Тогда
	ТекущийДвижок = "VBScript";
КонецЕсли; 
#КонецЕсли 
//ТекущийДвижок = "PCRE2"; // для отладки
