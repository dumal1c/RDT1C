﻿// Параметры:
//   КаталогРаспаковки - Строка(0,П)
//
Функция ПолучитьФайлСтруктурыХранилищаОбъектаМетаданных(Знач КаталогРаспаковки = "") Экспорт
	
	RegExp = ирПлатформа.RegExp;
		RegExp.Global = Ложь;
		RegExp.Pattern = "{2,(" + ирПлатформа.шGUID + "),";
		ФайлКорневогоУказателя = Новый Файл(КаталогРаспаковки + "root.data.und");
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ФайлКорневогоУказателя.ПолноеИмя);
		РезультатыПоиска = RegExp.Execute(ТекстовыйДокумент.ПолучитьТекст());
		КорневойИД = РезультатыПоиска.Item(0).Submatches(0);
		ФайлСтруктуры = Новый Файл(КаталогРаспаковки + КорневойИД + ".data.und");
	Результат = ФайлСтруктуры;
	Возврат Результат;
КонецФункции

// Параметры:
//   ПолноеИмяФайлаВнешнейОбработки - Строка(0,П)
//   ИмяФормы - Строка(0,П) - Если не указана, используется Основая форма, а если основная форма не указана, используется единственная форма. Для быстрого выполнения нужно указывать.
//   МассивДобавляемыхРеквизитов - Массив - !Проверка уникальности не выполняется. Ее нужно делать снаружи
//   СтарыйТекстМодуля - Строка(0,П)
//
Функция ПроверитьОбновитьМодульИРеквизитыФормыВФайле(Знач ПолноеИмяФайлаВнешнейОбработки = "", Знач ИмяФормы = "", Знач МассивДобавляемыхРеквизитов, НовыйТекстМодуля,
	СтарыйТекстМодуля = "") Экспорт
	
	ФайлВнешнейОбработки = Новый Файл(ПолноеИмяФайлаВнешнейОбработки);
	Если Не ЗначениеЗаполнено(ИмяФормы) Тогда
		ВнешнийОбъект = ВнешниеОбработки.Создать(ФайлВнешнейОбработки.ПолноеИмя);
		ОбъектМетаданных = ВнешнийОбъект.Метаданные();
		Если ОбъектМетаданных.ОсновнаяФорма <> Неопределено Тогда
			ИмяФормы = ОбъектМетаданных.ОсновнаяФорма.Имя;
		ИначеЕсли ОбъектМетаданных.Формы.Количество() = 1 Тогда
			ИмяФормы = ОбъектМетаданных.Формы[0].Имя;
		Иначе
			ВызватьИсключение "Невозможно определить форму внешней обработки для обновления";
		КонецЕсли;
	КонецЕсли;
	ИмяКаталогаСборки = "Rebuild";
	ИмяКаталогаРаспаковки = ФайлВнешнейОбработки.Путь + ИмяКаталогаСборки;
	КаталогРаспаковки = ИмяКаталогаРаспаковки + "\";
	УдалитьФайлы(ИмяКаталогаРаспаковки, "*.*");
	СоздатьКаталог(ИмяКаталогаРаспаковки);
	ирПлатформа.РаспаковатьФайлВнешнейОбработки(ФайлВнешнейОбработки.ПолноеИмя, КаталогРаспаковки);
	БылаМодификация = Ложь;
	RegExp = ирПлатформа.RegExp;
	
	// Получаем модуль формы и изменяем его, если не соответствует стандарту
	
	//ФайлСпискаФорм = Новый файл(КаталогРаспаковки + "copyinfo.data.und");
	//ТекстовыйДокумент = Новый ТекстовыйДокумент;
	//ТекстовыйДокумент.Прочитать(ФайлСпискаФорм.ПолноеИмя);
	//RegExp.Global = Ложь;
	//RegExp.Pattern = "(" + ирПлатформа.шGUID + "),1,\n\{d5b0e5ed-256d-401c-9c36-f630cafd8a62,""" + ИмяФормы + """";
	//РезультатыПоиска = RegExp.Execute(ТекстовыйДокумент.ПолучитьТекст());
	//СтарыеТекстыМодулейФорм = Новый Структура;
	//ИДФормы = РезультатыПоиска.Item(0).Submatches(0);
	
	ФайлСтруктуры = ПолучитьФайлСтруктурыХранилищаОбъектаМетаданных(КаталогРаспаковки);
	ТекстСтруктуры = Новый ТекстовыйДокумент;
	ТекстСтруктуры.Прочитать(ФайлСтруктуры.ПолноеИмя);
	RegExp.Global = Ложь;
	RegExp.Pattern = "\{d5b0e5ed-256d-401c-9c36-f630cafd8a62,\d+((?:," + ирПлатформа.шGUID + ")*)\}";
	РезультатыПоиска = RegExp.Execute(ТекстСтруктуры.ПолучитьТекст());
	ТекстСпискаИД = РезультатыПоиска.Item(0).Submatches(0);
	RegExp.Global = Истина;
	RegExp.Pattern = ирПлатформа.шGUID;
	РезультатыПоиска = RegExp.Execute(ТекстСпискаИД);
	Для Каждого Вхождение Из РезультатыПоиска Цикл
		ТекстФайлаФормы = Новый ТекстовыйДокумент;
		ТекстФайлаФормы.Прочитать(КаталогРаспаковки + Вхождение.Value + ".data.und");
		//RegExp.Global = Ложь;
		//RegExp.Pattern = Вхождение.Value + "\},""(" + ирПлатформа.шИмя + ")"";
		//РезультатыПоиска2 = RegExp.Execute(ТекстФайлаФормы.ПолучитьТекст());
		Маркер = Вхождение.Value + "},""" + ИмяФормы + """";
		Если Найти(НРег(ТекстФайлаФормы.ПолучитьТекст()), Нрег(Маркер)) > 0 Тогда
			ИДФормы = Вхождение.Value;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ИДФормы = Неопределено Тогда
		ВызватьИсключение "Не удалось определить внутренний идентификатор формы """ + ИмяФормы + """";
	КонецЕсли;
	
	ФайлМодуляФормы = Новый Файл(КаталогРаспаковки + ИДФормы + ".0.data.und.unp\" + "module.data");
	СтарыйТекстМодуляФормы = Неопределено;
	
	Результат = Ложь;
	ТекстДляПроверки = Новый ТекстовыйДокумент;
	ТекстДляПроверки.Прочитать(ФайлМодуляФормы.ПолноеИмя);
	ТекстОбразец = Новый ТекстовыйДокумент;
	ТекстОбразец.УстановитьТекст(НовыйТекстМодуля);
	СтарыйТекстМодуля = ТекстДляПроверки.ПолучитьТекст();
	Если ТекстОбразец.ПолучитьТекст() <> СтарыйТекстМодуля Тогда
		ТекстОбразец.Записать(ФайлМодуляФормы.ПолноеИмя);
		Результат = Истина;
	КонецЕсли;
	
	Если Истина
		И МассивДобавляемыхРеквизитов <> Неопределено
		И МассивДобавляемыхРеквизитов.Количество() > 0
	Тогда
		ФайлДиалогаФормы = Новый Файл(ФайлМодуляФормы.Путь + "form.data");
		ТекстДиалога = Новый ТекстовыйДокумент;
		ТекстДиалога.Прочитать(ФайлДиалогаФормы.ПолноеИмя);
		КоличествоНовыхРеквизитов = МассивДобавляемыхРеквизитов.Количество();
		ОстатокТекста0 = ТекстДиалога.ПолучитьТекст();
	
		RegExp.Global = Ложь;
		RegExp.Pattern = "},\d+,\d+,\d+,0,\d+,4,4,\d+},";
		Вхождения = RegExp.Execute(ОстатокТекста0);
		Если Вхождения.Count = 0 Тогда
			Сообщить("При анализе диалога не найден маркер1");
			Возврат Неопределено;
		ИначеЕсли Вхождения.Count > 1 Тогда
			Сообщить("При анализе диалога найдено более одного маркера1");
			Возврат Неопределено;
		КонецЕсли;
		Позиция = Вхождения.Item(0).FirstIndex;
		Позиция = Позиция + СтрДлина(Вхождения.Item(0).Value);
		Фрагмент1 = Лев(ОстатокТекста0, Позиция);
		ОстатокТекста1 = Сред(ОстатокТекста0, Позиция + 1);
	
		//Маркер = "},";
		//Позиция = Найти(ОстатокТекста1, Маркер);
		//Фрагмент2 = Лев(ОстатокТекста1, Позиция + СтрДлина(Маркер));
		Фрагмент2 = "";
		ОстатокТекста2 = Сред(ОстатокТекста1, СтрДлина(Фрагмент2) + 1);
	
		Маркер = ",
		|{";
		Позиция = Найти(ОстатокТекста2, Маркер);
		Если Позиция = 0 Тогда
			Сообщить("Не найден маркер2");
			Возврат Неопределено;
		КонецЕсли;
		Позиция = Позиция + СтрДлина(Маркер) - 1;
		Фрагмент3 = Лев(ОстатокТекста2, Позиция);
		ОстатокТекста3 = Сред(ОстатокТекста2, СтрДлина(Фрагмент3) + 1);
	
		Позиция = Найти(ОстатокТекста3, "}");
		Позиция2 = Найти(ОстатокТекста3, ",");
		Если Позиция2 > 0 Тогда
			Позиция = Мин(Позиция, Позиция2);
		КонецЕсли;
		Фрагмент4 = Лев(ОстатокТекста3, Позиция - 1);
		ОстатокТекста4 = Сред(ОстатокТекста3, СтрДлина(Фрагмент4) + 1);
		Число = Число(Фрагмент4);
		Число = Число + КоличествоНовыхРеквизитов;
		Фрагмент4 = Формат(Число, "ЧГ=");
	
		Разделитель = ",";
		СтрокаРеквизитов = "";
		Счетчик = 1;
		
		// Если у формы нет ни одного реквизита, то может получиться ошибка формата потока
		Строка1 = ирОбщий.СтрокаМеждуМаркерамиЛкс(ОстатокТекста4, "},", ",""");
		Если Ложь
			Или Не ЗначениеЗаполнено(Строка1)
			Или СтрДлина(Строка1) > 5
		Тогда
			// у формы нет ни одного реквизита
			Если ирКэш.НомерИзданияПлатформыЛкс() = "81" Тогда
				Строка1 = "0,1";
			ИначеЕсли ирКэш.НомерИзданияПлатформыЛкс() >= "82" Тогда
				// Здесь может быть нужно и "0,1" использовать, если в конфигураторе форму ни разу не сохраняли еще, а только конвертировали через ConvertFiles
				// Если такое случается, то при попытке открыть такую внешнюю обработку платформа будет падать
				Строка1 = "1,0,1";
			КонецЕсли;
		КонецЕсли;
	
		Для Каждого ИмяРеквизита Из МассивДобавляемыхРеквизитов Цикл
			СтрокаРеквизитов = СтрокаРеквизитов + Разделитель + "
			|{
			|{" + Формат(1000 + Счетчик, "ЧГ=") + "}," + Строка1 + ",""" + ИмяРеквизита + """,
			|{""Pattern""}
			|}";
			Счетчик = Счетчик + 1;
		КонецЦикла;
		НовыйТекст = Фрагмент1 + Фрагмент2 + Фрагмент3 + Фрагмент4 + СтрокаРеквизитов + ОстатокТекста4;
		ТекстДиалога.УстановитьТекст(НовыйТекст);
		ТекстДиалога.Записать(ФайлДиалогаФормы.ПолноеИмя);
		Результат = Истина;
	КонецЕсли;
	
	Если Результат Тогда
		// Здесь часто возникает ошибка 
		//{Обработка.ирПлатформа.МодульОбъекта(5 163)}: 
		//Ошибка при вызове метода контекста (Записать)
		//	ПолучитьМакет("v8unpack").Записать(Каталог + "\" + ИмяФайлаПакера);
		//Ошибка совместного доступа к файлу 'D:\Users\Сергей\AppData\Local\1C\1Cv82\File__D__1C_v82_DB_2iSРазработка__\b\Rebuild\v8unpack.exe'
		//						ВызватьИсключение Ошибка;//#Служебное
		ирПлатформа.УпаковатьФайлВнешнейОбработки(КаталогРаспаковки, ФайлВнешнейОбработки.ПолноеИмя);
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ТабличныйДокументИзОбщихКартинокПодсистемы() Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ШрифтЖирный = Новый Шрифт(,,Истина);
	ТабличныйДокумент.Область("R1C1:R1C1").Текст = "Имя";
	ТабличныйДокумент.Область("R1C2:R1C2").Текст = "Картинка";
	ТабличныйДокумент.Область("R1C1:R1C2").Шрифт = ШрифтЖирный;
	Для Каждого ОбщаяКартинка Из Метаданные.ОбщиеКартинки Цикл
		Если Не Метаданные.Подсистемы.ИнструментыРазработчикаTormozit.Состав.Содержит(ОбщаяКартинка) Тогда
			Продолжить;
		КонецЕсли;
		Рисунок = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		Рисунок.Картинка = БиблиотекаКартинок[ОбщаяКартинка.Имя];
		Рисунок.Имя = ОбщаяКартинка.Имя;
		Рисунок.РазмерКартинки = РазмерКартинки.РеальныйРазмер;
		ВысотаТаблицы = ТабличныйДокумент.ВысотаТаблицы + 1;
		ТабличныйДокумент.Область("R" + XMLСтрока(ВысотаТаблицы) + "C1:R" + XMLСтрока(ВысотаТаблицы) + "C1").Текст = ОбщаяКартинка.Имя;
		Рисунок.Расположить(ТабличныйДокумент.Область("R" + XMLСтрока(ВысотаТаблицы) + "C2:R" + XMLСтрока(ВысотаТаблицы) + "C2"));
	КонецЦикла;
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СгенерироватьМодульИнициализацииФормПодсистемыДляПортативногоРежима() Экспорт
	
	ТекстМодуля = Новый ЗаписьXML;
	ТекстМодуля.УстановитьСтроку("");
	//ТекстМодуля.ЗаписатьБезОбработки("
	//|Перем ирОбщий Экспорт;
	//|Перем ирСервер Экспорт;
	//|Перем ирКэш Экспорт;
	//|Перем ирПривилегированный Экспорт;
	//|Перем ирПортативный Экспорт;
	//|
	//|Перем ирПлатформа Экспорт;
	//|");
	ТипыМетаданных = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Ложь);
	ИндикаторТиповМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТипыМетаданных.Количество(), "Типы метаданных");
	Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМетаданных);
		Если СтрокаТипаМетаданных.Единственное = "Перерасчет" Тогда 
			КоллекцияМетаОбъектов = Новый Массив;
			Для Каждого МетаРегистрРасчета Из Метаданные.РегистрыРасчета Цикл
				Для Каждого Перерасчет Из МетаРегистрРасчета.Перерасчеты Цикл
					КоллекцияМетаОбъектов.Добавить(Перерасчет);
				КонецЦикла;
			КонецЦикла;
		Иначе
			КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
		КонецЕсли; 
		Индикатор2 = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
		Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
			Если Не Метаданные.Подсистемы.ИнструментыРазработчикаTormozit.Состав.Содержит(МетаОбъект) Тогда
				Продолжить;
			КонецЕсли;
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор2);
			Попытка
				МетаФормы = МетаОбъект.Формы;
			Исключение
				Продолжить;
			КонецПопытки;
			МенеджерОбъектаМетаданных = ирОбщий.ПолучитьМенеджерЛкс(МетаОбъект);
			Индикатор3 = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МетаФормы.Количество(), "Формы");
			Для Каждого МетаФорма Из МетаФормы Цикл
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор3);
				ПолноеИмяФормы = МетаФорма.ПолноеИмя();
				//Сообщить(ПолноеИмяФормы);
				//ПолноеИмяФормы = МетаОбъект.ПолноеИмя() + ".Форма." + МетаФорма.Имя;
				Попытка
					//Форма = ПолучитьФорму(ПолноеИмяФормы); // Так исключение не сработает и будет отображен диалог об ошибке. Особенность платформы
					Форма = МенеджерОбъектаМетаданных.ПолучитьФорму(МетаФорма.Имя,,Новый УникальныйИдентификатор());
				Исключение
					Сообщить("Ошибка при получении формы " + ПолноеИмяФормы + ": " + ОписаниеОшибки(), СтатусСообщения.ОченьВажное);
					Продолжить;
				КонецПопытки;
				Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
					Продолжить;
				КонецЕсли; 
				ТелоМетода = Новый ЗаписьXML;
				ТелоМетода.УстановитьСтроку("");
				ПроверитьСвойстваОбъектаДляПортативногоРежимаЛкс("ЭтаФорма", Форма, ТелоМетода);
				ТелоМетода = ТелоМетода.Закрыть();
				ТекстМодуля.ЗаписатьБезОбработки("
				|Процедура ИнициализироватьФорму_" + ирПлатформа.ИдентификаторИзПредставленияЛкс(ПолноеИмяФормы) + "(ЭтаФорма) Экспорт
				|
				|" + ТелоМетода + "
				|КонецПроцедуры
				|");
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Результат = 
	"//#Область ОбработчикиИнициализацииФорм
	|" + ТекстМодуля.Закрыть() + "
	|//#КонецОбласти";
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьСвойстваОбъектаДляПортативногоРежимаЛкс(ПутьКОбъекту, Объект, ТелоМетода)

	СтруктураТипа = ирПлатформа.ПолучитьСтруктуруТипаИзЗначения(Объект);
	ВнутренняяТаблицаСлов = ирПлатформа.ПолучитьТаблицуСловСтруктурыТипа(СтруктураТипа);
	Для Каждого ВнутренняяСтрокаСлова Из ВнутренняяТаблицаСлов Цикл
		Если ВнутренняяСтрокаСлова.ТипСлова = "Свойство" Тогда 
			ИмяСвойства = ВнутренняяСтрокаСлова.Слово;
			Если Ложь
				Или ИмяСвойства = "ИсточникДействий" 
				Или ИмяСвойства = "КонтекстноеМеню" 
			Тогда
				// Защита от длинных путей и зацикливания
				Продолжить;
			КонецЕсли; 
			Попытка
				Структура = Новый Структура(ИмяСвойства);
			Исключение
				// "КартинкаКнопкиВыбора#&^@^%&*^#1"
				Продолжить;
			КонецПопытки; 
			Попытка
				ЗаполнитьЗначенияСвойств(Структура, Объект); 
			Исключение
				// Не всегда доступное свойство
				Продолжить;
			КонецПопытки;
			ЗначениеСвойства = Структура[ИмяСвойства];
			Если ТипЗнч(ЗначениеСвойства) = Тип("Картинка") Тогда
				Если ЗначениеСвойства.Вид = ВидКартинки.ИзБиблиотеки Тогда
					ИмяОбщейКартинки = СериализаторXDTO.ЗаписатьXDTO(ЗначениеСвойства).ref.ЛокальноеИмя;
					Если Метаданные.ОбщиеКартинки.Найти(ИмяОбщейКартинки) <> Неопределено Тогда
						ТелоМетода.ЗаписатьБезОбработки(Символы.Таб + ПутьКОбъекту + "." + ИмяСвойства + " = ирКэш.КартинкаПоИмениЛкс("""
							+ ИмяОбщейКартинки + """);" + Символы.ПС);
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли ТипЗнч(ЗначениеСвойства) = Тип("Цвет") Тогда
				ИмяЦветаСтиля = СериализаторXDTO.ЗаписатьXDTO(ЗначениеСвойства).ЛексическоеЗначение;
				ПозицияСкобки = Найти(ИмяЦветаСтиля, "}");
				Если ПозицияСкобки > 0 Тогда
					ИмяЦветаСтиля = Сред(ИмяЦветаСтиля, ПозицияСкобки + 1);
					Если Метаданные.ЭлементыСтиля.Найти(ИмяЦветаСтиля) <> Неопределено Тогда
						ТелоМетода.ЗаписатьБезОбработки(Символы.Таб + ПутьКОбъекту + "." + ИмяСвойства + " = ирОбщий.ПолучитьЦветСтиляЛкс("""
							+ ИмяЦветаСтиля + """);" + Символы.ПС);
					КонецЕсли;
				КонецЕсли; 
			КонецЕсли;
			Если ирПлатформа.мМассивТиповЭлементовУправления.Найти(ТипЗнч(ЗначениеСвойства)) <> Неопределено Тогда
				ПроверитьСвойстваОбъектаДляПортативногоРежимаЛкс(ПутьКОбъекту + "." + ИмяСвойства, ЗначениеСвойства, ТелоМетода);
			КонецЕсли; 
			Если ирОбщий.ЭтоКоллекцияЛкс(ЗначениеСвойства) Тогда
				ЕстьИндексПоИмени = Ложь;
				Для Каждого ЭлементКоллекции Из ЗначениеСвойства Цикл
					Если Не ЕстьИндексПоИмени Тогда
						Попытка
							Пустышка = Вычислить("ЗначениеСвойства." + ЭлементКоллекции.Имя);
						Исключение
							// Если к элементу по имени нельзя обратиться, то он нас не интересует.
							Прервать;
						КонецПопытки;
					КонецЕсли; 
					ЕстьИндексПоИмени = Истина;
					Если Ложь
						Или ирПлатформа.мМассивТиповЭлементовУправления.Найти(ТипЗнч(ЭлементКоллекции)) <> Неопределено
						Или ТипЗнч(ЭлементКоллекции) = Тип("КнопкаКоманднойПанели")
					Тогда
						ПроверитьСвойстваОбъектаДляПортативногоРежимаЛкс(ПутьКОбъекту + "." + ИмяСвойства + "." + ЭлементКоллекции.Имя, ЭлементКоллекции, ТелоМетода);
					КонецЕсли; 
				КонецЦикла; 
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	КаталогВыгрузкиКонфигурации = ПолучитьИмяВременногоФайла();
	Если ЗначениеЗаполнено(СтрокаСоединенияБазыПодсистемы) Тогда
		СтрокаСоединенияБазыПодсистемыЛ = СтрокаСоединенияБазыПодсистемы;
	Иначе
		СтрокаСоединенияБазыПодсистемыЛ = СтрокаСоединенияИнформационнойБазы();
	КонецЕсли; 
	СоздатьКаталог(КаталогВыгрузкиКонфигурации);
	ТекстЛога = "";
	// Выгружаем конфигурацию в файлы
	Если Не ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigToFiles """ + КаталогВыгрузкиКонфигурации + """ -Format Hierarchical", СтрокаСоединенияБазыПодсистемыЛ, ТекстЛога,,
		"Выгрузка конфигурации в файлы") 
	Тогда 
		УдалитьФайлы(КаталогВыгрузкиКонфигурации);
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	КаталогВерсии = Каталог + "\" + Метаданные.Версия;
	КаталогМодули = Новый Файл(КаталогВерсии + "\Модули");
	Если Не КаталогМодули.Существует() Тогда
		СоздатьКаталог(КаталогМодули.ПолноеИмя);
	КонецЕсли; 
	УдалитьФайлы(КаталогВыгрузкиКонфигурации + "\CommonModules\ирПортативный.xml");
	УдалитьФайлы(КаталогВыгрузкиКонфигурации + "\CommonModules\ирИнтерфейс.xml");
	УдалитьФайлы(КаталогВыгрузкиКонфигурации + "\CommonModules\ирИнтерфейсОбъявление.xml");
	СтрокаВерсии = Метаданные.Версия + "p";
	
	// ирПортативный.ОбщиеКартинки
	ТабличныйДокументКартинки = ТабличныйДокументИзОбщихКартинокПодсистемы();
	ИмяфайлаТабличногоДокумента = КаталогВыгрузкиКонфигурации + "\DataProcessors\ирПортативный\Templates\ОбщиеКартинки\Ext\Template.xml";
	ирОбщий.СохранитьЗначениеВФайлЛкс(ТабличныйДокументКартинки, ИмяфайлаТабличногоДокумента);
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяфайлаТабличногоДокумента);
	ТекстМодуля = ТекстовыйДокумент.ПолучитьТекст();
	// Антибаг платформы 8.3.9 Без этого текст теряется при загрузке внешней обработки из файлов
	ТекстМодуля = СтрЗаменить(ТекстМодуля, "<v8:lang>#</v8:lang>", "<v8:lang></v8:lang>");
	ТекстовыйДокумент.УстановитьТекст(ТекстМодуля);
	ТекстовыйДокумент.Записать(ИмяфайлаТабличногоДокумента);

	// ирПортативный.Модуль
	ИмяфайлаМодуля = КаталогВыгрузкиКонфигурации + "\DataProcessors\ирПортативный\Ext\ObjectModule.bsl";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяфайлаМодуля);
	ТекстМодуля = ТекстовыйДокумент.ПолучитьТекст();
	ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстМодуля, "#Область ОбработчикиИнициализацииФорм", "#КонецОбласти", Ложь, Истина);
	НаЧтоЗаменить = СгенерироватьМодульИнициализацииФормПодсистемыДляПортативногоРежима();
	ТекстМодуля = СтрЗаменить(ТекстМодуля, ЧтоЗаменить, НаЧтоЗаменить);
	ИмяфайлаГлобальногоМодуля = КаталогВыгрузкиКонфигурации + "\CommonModules\ирГлобальный\Ext\Module.bsl";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяфайлаГлобальногоМодуля);
	ТекстГлобальногоМодуля = ТекстовыйДокумент.ПолучитьТекст();
	ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстМодуля, "#Область ГлобальныеПортативныеМетоды", "#КонецОбласти", Ложь, Истина);
	НаЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстГлобальногоМодуля, "#Область ГлобальныеПортативныеМетоды", "#КонецОбласти", Ложь, Истина);
	ТекстМодуля = СтрЗаменить(ТекстМодуля, ЧтоЗаменить, НаЧтоЗаменить);
	ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстМодуля,  "мВерсия = ", ";", Ложь, Истина);
	НаЧтоЗаменить = "мВерсия = """ + СтрокаВерсии + """;";
	ТекстМодуля = СтрЗаменить(ТекстМодуля, ЧтоЗаменить, НаЧтоЗаменить);
	ТекстовыйДокумент.УстановитьТекст(ТекстМодуля);
	ТекстовыйДокумент.Записать(ИмяфайлаМодуля);
	УдалитьФайлы(ИмяфайлаГлобальногоМодуля);
	
	// ирПортативныйСервер
	ИмяфайлаМодуля = КаталогВыгрузкиКонфигурации + "\DataProcessors\ирПортативныйСервер\Ext\ObjectModule.bsl";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяфайлаМодуля);
	ТекстМодуля = ТекстовыйДокумент.ПолучитьТекст();
	ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстМодуля,  "(""Версия"",", ");", Ложь, Истина);
	НаЧтоЗаменить = "(""Версия"", """ + СтрокаВерсии + """);";
	ТекстМодуля = СтрЗаменить(ТекстМодуля, ЧтоЗаменить, НаЧтоЗаменить);
	ТекстовыйДокумент.УстановитьТекст(ТекстМодуля);
	ТекстовыйДокумент.Записать(ИмяфайлаМодуля);
	
	ПреобразоватьОбъектыМетаданныхПоТипу(КаталогВерсии, "CommonModule", "CommonModules", "epf", КаталогВыгрузкиКонфигурации, СтрокаСоединенияБазыПодсистемыЛ, "DataProcessor");
	ПреобразоватьОбъектыМетаданныхПоТипу(КаталогВерсии, "Report", "Reports", "erf", КаталогВыгрузкиКонфигурации, СтрокаСоединенияБазыПодсистемыЛ);
	ПреобразоватьОбъектыМетаданныхПоТипу(КаталогВерсии, "DataProcessor", "DataProcessors", "epf", КаталогВыгрузкиКонфигурации, СтрокаСоединенияБазыПодсистемыЛ);
	УдалитьФайлы(КаталогВыгрузкиКонфигурации);
	
КонецПроцедуры

Процедура ПреобразоватьОбъектыМетаданныхПоТипу(КаталогВерсии, Знач ИмяТипаЕдинственное, Знач ИмяТипаМножественное, Знач РасширениеФайла, Знач КаталогВыгрузкиКонфигурации,
	Знач СтрокаСоединенияБазыПодсистемыЛ, Знач ПреобразоватьВТип = "")
	
	ФайлыДляОбработки = НайтиФайлы(КаталогВыгрузкиКонфигурации + "\" + ИмяТипаМножественное, "*.xml");
	Если Не ЗначениеЗаполнено(ПреобразоватьВТип) Тогда
		ПреобразоватьВТип = ИмяТипаЕдинственное;
	КонецЕсли; 
	Успех = Истина;
	ТекстЛога = "";
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ФайлыДляОбработки.Количество(), ИмяТипаМножественное);
	Для Каждого Файл Из ФайлыДляОбработки Цикл
		#Если _ Тогда
			Файл = Новый Файл;
		#КонецЕсли
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		КаталогВыгрузкиВнешнейОбработки = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(КаталогВыгрузкиВнешнейОбработки);
		ИмяОсновногоФайлаВнешнейОбработки = КаталогВыгрузкиВнешнейОбработки + "\" + Файл.Имя;
		ПодкаталогФайловВнешнейОбработки = КаталогВыгрузкиВнешнейОбработки + "\" + Файл.ИмяБезРасширения;
		СоздатьКаталог(ПодкаталогФайловВнешнейОбработки);
		ирОбщий.СкопироватьФайлыЛкс(Файл.Путь + "\" + Файл.ИмяБезРасширения, ПодкаталогФайловВнешнейОбработки);
		ФайлОбщегоМОдуля = Новый Файл(ПодкаталогФайловВнешнейОбработки + "\Ext\Module.bsl");
		Если ФайлОбщегоМОдуля.Существует() Тогда
			ПереместитьФайл(ФайлОбщегоМОдуля.ПолноеИмя, ПодкаталогФайловВнешнейОбработки + "\Ext\ObjectModule.bsl");
		КонецЕсли; 
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
		НовыйТекст = СтрЗаменить(ТекстовыйДокумент.ПолучитьТекст(), ИмяТипаЕдинственное, "External" + ПреобразоватьВТип);
		ЧтениеХмл = Новый ЧтениеXML;
		ПараметрыЧтения = Новый ПараметрыЧтенияXML(,,,,,,,, Ложь);
		ЧтениеХмл.УстановитьСтроку(НовыйТекст, ПараметрыЧтения);
		ПостроительDOM = Новый ПостроительDOM;
		ДокументДом = ПостроительDOM.Прочитать(ЧтениеХмл);
		ЧтениеХмл.Закрыть();
		КорневойУзел = ДокументДом.ПолучитьЭлементыПоИмени("External" + ПреобразоватьВТип);
		КорневойУзел = КорневойУзел[0];
		
		// Удаляем управляемые формы 
		УзлыДопФормы = КорневойУзел.ПолучитьЭлементыПоИмени("AuxiliaryForm");
		Для Каждого УзелДопФормы Из УзлыДопФормы Цикл
			Если Найти(УзелДопФормы.ТекстовоеСодержимое + "#", "Упр#") > 0 Тогда
				УзелДопФормы.РодительскийУзел.УдалитьДочерний(УзелДопФормы);
			КонецЕсли; 
		КонецЦикла; 
		УзлыФорм = КорневойУзел.ПолучитьЭлементыПоИмени("Form");
		Для Каждого УзелФормы Из УзлыФорм Цикл
			Если Найти(УзелФормы.ТекстовоеСодержимое + "#", "Упр#") > 0 Тогда
				УзелФормы.РодительскийУзел.УдалитьДочерний(УзелФормы);
			КонецЕсли; 
		КонецЦикла; 
		
		УзелИдентификации = КорневойУзел.ПолучитьЭлементыПоИмени("InternalInfo");
		Если УзелИдентификации.Количество() = 0 Тогда 
			УзелИдентификации = ДокументДом.СоздатьЭлемент("InternalInfo");
			КорневойУзел.ВставитьПеред(УзелИдентификации, КорневойУзел.ПервыйДочерний);
		КонецЕсли; 
		УзелИдентификации = КорневойУзел.ПолучитьЭлементыПоИмени("ChildObjects");
		Если УзелИдентификации.Количество() = 0 Тогда 
			УзелИдентификации = ДокументДом.СоздатьЭлемент("ChildObjects");
			КорневойУзел.ДобавитьДочерний(УзелИдентификации);
		КонецЕсли; 
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.ОткрытьФайл(ИмяОсновногоФайлаВнешнейОбработки);
		ЗаписьДом = Новый ЗаписьDOM;
		ЗаписьДом.Записать(ДокументДом, ЗаписьXML); 
		ЗаписьXML.Закрыть();
		Если ирОбщий.СтрокиРавныЛкс(Файл.ИмяБезРасширения, "ирПортативный") Тогда
			КонечныйФайл = КаталогВерсии + "\";
		Иначе
			КонечныйФайл = КаталогВерсии + "\Модули\";
		КонецЕсли; 
		КонечныйФайл = КонечныйФайл + Файл.ИмяБезРасширения + "." + РасширениеФайла;
		Если Не ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadExternalDataProcessorOrReportFromFiles """ + ИмяОсновногоФайлаВнешнейОбработки + """ """ + КонечныйФайл + """",
			СтрокаСоединенияБазыПодсистемыЛ, ТекстЛога) 
		Тогда 
			УдалитьФайлы(КаталогВыгрузкиВнешнейОбработки);
			УдалитьФайлы(КаталогВыгрузкиКонфигурации);
			Сообщить(ТекстЛога);
			Успех = Ложь;
			Прервать;
		КонецЕсли; 
		УдалитьФайлы(КаталогВыгрузкиВнешнейОбработки);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();

КонецПроцедуры

Процедура КаталогНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ВыбратьКаталогВФормеЛкс(Каталог);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.СохранитьЗначениеЛкс("ирВыпускВариантаПортативный.Каталог", Каталог);
	ирОбщий.СохранитьЗначениеЛкс("ирВыпускВариантаПортативный.СтрокаСоединенияБазыПодсистемы", СтрокаСоединенияБазыПодсистемы);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Подверсия = "1";
	Каталог = ирОбщий.ВосстановитьЗначениеЛкс("ирВыпускВариантаПортативный.Каталог");
	СтрокаСоединенияБазыПодсистемы = ирОбщий.ВосстановитьЗначениеЛкс("ирВыпускВариантаПортативный.СтрокаСоединенияБазыПодсистемы");
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ирКэш.НомерВерсииПлатформыЛкс() < 803008 Тогда
		Сообщить("Поддерживается только платформа 8.3.8 и выше");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

ирКэш.Получить();