﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Функция ВыполнитьРегистрацию() Экспорт

	//http://msdn.microsoft.com/en-us/library/windows/desktop/ms687653%28v=vs.85%29.aspx
	// http://icodeguru.com/VC%26MFC/APracticalGuideUsingVisualCandATL/133.htm
	// Коды ошибок http://msdn.microsoft.com/en-us/library/windows/desktop/dd542647%28v=vs.85%29.aspx
	КаталогПриложений = Новый COMОбъект("COMAdmin.COMAdminCatalog");
	КаталогПриложений.Connect(Компьютер);
	Приложения = КаталогПриложений.GetCollection("Applications");
	Приложения.Populate();
	Для Каждого СтрокаТаблицы Из Классы Цикл
		НовыйСборкаПлатформы = СтрокаТаблицы.НовыйСборкаПлатформы;
		Если ЗначениеЗаполнено(НовыйСборкаПлатформы) Тогда
			Если Не ирОбщий.ЭтоЛокальныйКомпьютерЛкс(Компьютер) Тогда
				Сообщить("Изменение COM классов нелокальной машины не поддерживается");
				Прервать;
			Иначе
				ЗарегистрироватьCOMКлассСборкиПлатформы(ТипыComКлассов.Найти(СтрокаТаблицы.ТипКласса, "Имя"), СтрокаТаблицы.x64, НовыйСборкаПлатформы);
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла; 
	Результат = Истина;
	Возврат Результат;
		
КонецФункции

Процедура ЗарегистрироватьCOMКлассСборкиПлатформы(Знач ТипКласса, Знач x64 = Неопределено, Знач СборкаПлатформы = Неопределено) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    ТипКласса = ТипыComКлассов.Найти();
	#КонецЕсли
	Если x64 = Неопределено Тогда
		x64 = ирКэш.Это64битныйПроцессЛкс();
	КонецЕсли; 
	ОтборСтрок = Новый Структура("СборкаПлатформы", ирОбщий.ПолучитьПервыйФрагментЛкс(СборкаПлатформы, " - "));
	Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(СборкаПлатформы, " - ");
	Если Фрагменты.Количество() > 1 Тогда
		ОтборСтрок.Вставить("x64", Фрагменты[1] = "64");
	Иначе
		ОтборСтрок.Вставить("x64", x64);
	КонецЕсли; 
	СтрокиТаблицы = СборкиПлатформы.НайтиСтроки(ОтборСтрок);
	Если СтрокиТаблицы.Количество() > 0 Тогда
		СтрокаТаблицыНовогоРелиза = СтрокиТаблицы[0];
		ЗарегистрироватьCOMКлассИзКаталогаФайлов(ТипКласса, x64, СтрокаТаблицыНовогоРелиза.Каталог + "bin", СборкаПлатформы);
	Иначе
		ВызватьИсключение "Файл регистрации класса " + ТипКласса.Имя + " для сборки платформы " + СборкаПлатформы + " не найден";
	КонецЕсли;

КонецПроцедуры

Функция ЗарегистрироватьCOMКлассИзКаталогаФайлов(ТипКласса, x64 = Неопределено, пКаталогФайла = Неопределено, СборкаПлатформы = Неопределено) Экспорт 
	
	Если Не ЗначениеЗаполнено(пКаталогФайла) Тогда
		КаталогФайла = КаталогПрограммы();
		СборкаПлатформы = ТекущаяСборкаПлатформы;
	Иначе
		КаталогФайла = пКаталогФайла;
	КонецЕсли; 
	Если ТипКласса.Внутрипроцессный Тогда
		Если x64 <> Неопределено И ирКэш.Это64битнаяОСЛкс() Тогда
			Если x64 Тогда
				Команда = "%systemroot%\System32\regsvr32.exe";
			Иначе
				Команда = "%systemroot%\SysWoW64\regsvr32.exe";
			КонецЕсли; 
		Иначе
			Команда = "regsvr32.exe";
		КонецЕсли; 
		Если ТипКласса.Имя = "ComConnector" Тогда
			ПолноеИмяФайла = КаталогФайла + "\" + ТипКласса.КлючевойФайл;
			Команда = Команда + " """ + ПолноеИмяФайла + """ ";
		ИначеЕсли ТипКласса.Имя  = "ServerAdminScope" Тогда
			ПолноеИмяФайла = КаталогФайла + "\" + ТипКласса.КлючевойФайл;
			//Команда = Команда + " """ + ПолноеИмяФайла + """ /n /i:user";
			Команда = Команда + " """ + ПолноеИмяФайла + """ /i:user";
		Иначе
			РезультатКоманды = "Неизвестный тип COM класса """ + ТипКласса.Имя + """ платформы 1С";
		КонецЕсли; 
		Если Не ПоказыватьРезультатРегистрации Тогда
			Команда = Команда + " /s";
		КонецЕсли; 
	Иначе
		#Если Не Клиент Тогда
			Если Не ЗначениеЗаполнено(пКаталогФайла) Тогда
				ВызватьИсключение "Регистрация COM класса типа """ + ТипКласса.Имя + """ отменена, т.к. определение пути к исполняемому файлу клиентского приложения на сервере не реализовано.";
			КонецЕсли; 
		#КонецЕсли
		Если Не ЗначениеЗаполнено(РезультатКоманды) Тогда
			ПолноеИмяФайла = КаталогФайла + "\" + ТипКласса.КлючевойФайл;
			Команда = """" + ПолноеИмяФайла + """ /regserver";
		КонецЕсли; 
	КонецЕсли;
	Если ЗначениеЗаполнено(Команда) Тогда
		Файл = Новый Файл(ПолноеИмяФайла);
		Если Не Файл.Существует() Тогда
			ВызватьИсключение "При регистрации COM класса типа """ + ТипКласса.Имя + """ не найден файл """ + Файл.ПолноеИмя + """
				|Переустановите платформу с необходимой компонентой";
		Иначе
			РезультатКоманды = ирОбщий.ПолучитьТекстРезультатаКомандыОСЛкс(Команда,,, Истина); // Тут всегда пустой результат
		КонецЕсли; 
	КонецЕсли;
	#Если Сервер И Не Клиент Тогда
		Текст = "серверном контексте";
	#Иначе
		Текст = "клиентском контексте";
	#КонецЕсли
	ПроцессОС = ирОбщий.ПолучитьПроцессОСЛкс("текущий");
	//#Если Клиент Тогда
	//	Текст = Текст + " из процесса " + ПроцессОС.Name + "(" + XMLСтрока(ПроцессОС.ProcessID) + ")";
	//#КонецЕсли 
	ТекстСообщения = "Выполнена локальная регистрация COM класса """ + ТипКласса.Имя + """ " + СборкаПлатформы + " в " + Текст;
	Сообщить(ТекстСообщения);
	//#Если Клиент Тогда
	//	Сообщить("! После регистрации для возможности использовать класс может потребоваться перезапуск процесса 1С !", СтатусСообщения.Внимание);
	//#КонецЕсли 
	Возврат РезультатКоманды;

КонецФункции

Процедура ПроверитьСозданиеCOMОбъекта(СтрокаКласса)
	
	//#Если _ Тогда
	//    СтрокаКласса = ЭтотОбъект.Классы.Добавить();
	//#КонецЕсли
	//Попытка
	//	РезультатСоздания = ирОбщий.СоздатьCOMОбъектИис(СтрокаКласса.ИмяКласса, Компьютер, Не СтрокаКласса.Внутрипроцессный);
	//Исключение
	//	РезультатСоздания = Неопределено;
	//КонецПопытки;
	//Если РезультатСоздания <> Неопределено Тогда
	//	СтрокаКласса.Зарегистрирован = Истина;
	//	СтрокаКласса.ПроверкаСоздания = Истина;
	//КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьКлассыИзКоллекции(Компоненты, x64)

	Компоненты.Populate();
	Для Каждого Компонента Из Компоненты Цикл
		ИмяКласса = Компонента.Name;
		Если Найти(НРег(ИмяКласса), "v8") = 1 Тогда 
			Для Каждого СтрокаТипаКласса Из ТипыComКлассов Цикл
				Если Найти(НРег(ИмяКласса), НРег(СтрокаТипаКласса.ИмяКлассаПослеV8)) = 4 Тогда
					ИдентификаторКомпоненты = Компонента.Value("CLSID");
					НомерИзданияПлатформы = Число(Сред(ИмяКласса, 3, 1));
					Если СтрокаТипаКласса.Внутрипроцессный Тогда
						ПолноеИмяФайла = Компонента.Value("InprocServer32");
					Иначе
						ПолноеИмяФайла = Компонента.Value("LocalServer32");
					КонецЕсли; 
					ИмяКласса = "V8" + НомерИзданияПлатформы + СтрокаТипаКласса.ИмяКлассаПослеV8;
					СтрокиКлассов = Классы.НайтиСтроки(Новый Структура("ИмяКласса, x64", ИмяКласса, x64));
					Если СтрокиКлассов.Количество() > 0 Тогда
						СтрокаПриложения = СтрокиКлассов[0];
						СтрокаПриложения.ИмяФайла = ПолноеИмяФайла;
						СтрокаПриложения.ИдентификаторКласса = Компонента.Value("CLSID");
						СтрокаПриложения.Зарегистрирован = Истина;
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура ОбновитьТаблицуКлассов(ЗаполнятьТолькоВнешниеСоединения = Ложь) Экспорт 
	
	Классы.Очистить();
	МассивРазрядностей = Новый Массив();
	МассивРазрядностей.Добавить(Ложь);
	Если ирКэш.Это64битнаяОСЛкс(Компьютер) Тогда
		МассивРазрядностей.Добавить(Истина);
		//Если ЗаполнятьТолькоВнешниеСоединения Тогда 
		//	Если КэшКонтекстаИис.Это64битныйПроцессИис() Тогда
		//		МассивРазрядностей.Удалить(0);
		//	Иначе
		//		МассивРазрядностей.Удалить(1);
		//	КонецЕсли; 
		//КонецЕсли; 
	КонецЕсли; 
	
	ИзданияПлатформы = Новый СписокЗначений;
	Для Счетчик = 1 По 3 Цикл
		ИзданияПлатформы.Добавить("8" + Счетчик, "8." + Счетчик);
	КонецЦикла;
	Для Каждого ИзданиеПлатформы Из ИзданияПлатформы Цикл
		Для Каждого ТипКласса Из ТипыComКлассов Цикл
			Если Истина
				И ЗаполнятьТолькоВнешниеСоединения 
				И ТипКласса.Имя <> "ComConnector"
			Тогда
				Продолжить;
			КонецЕсли; 
			Для Каждого x64 Из МассивРазрядностей Цикл
				Если Не ТипКласса.Внутрипроцессный И x64 И ИзданиеПлатформы.Значение < "83" Тогда
					Продолжить;
				КонецЕсли; 
				ИмяКласса = "V" + ИзданиеПлатформы.Значение + ТипКласса.ИмяКлассаПослеV8;
				СтрокаКласса = Классы.Добавить();
				СтрокаКласса.ИзданиеПлатформы = ИзданиеПлатформы.Представление;
				СтрокаКласса.ИмяКласса = ИмяКласса;
				СтрокаКласса.ВнутриПроцессный = ТипКласса.Внутрипроцессный;
				СтрокаКласса.ТипКласса = ТипКласса.Имя;
				СтрокаКласса.x64 = x64;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла; 
	
	КаталогПриложений = Новый COMОбъект("COMAdmin.COMAdminCatalog");
	КаталогПриложений.Connect(Компьютер);
	Если ирКэш.Это64битнаяОСЛкс(Компьютер) Тогда
		Компоненты = КаталогПриложений.GetCollection("InprocServers");
		ЗаполнитьКлассыИзКоллекции(Компоненты, Истина);
		Компоненты = КаталогПриложений.GetCollection("WOWLegacyServers");
		ЗаполнитьКлассыИзКоллекции(Компоненты, Ложь);
	КонецЕсли; 
	Компоненты = КаталогПриложений.GetCollection("LegacyServers");
	ЗаполнитьКлассыИзКоллекции(Компоненты, ирКэш.Это64битнаяОСЛкс(Компьютер));

	Приложения = КаталогПриложений.GetCollection("Applications");
	Приложения.Populate();
	Для Каждого Приложение Из Приложения Цикл
		Если Ложь
			Или Приложение.Key = "{9EB3B62C-79A2-11D2-9891-00C04F79AF51}" 
			Или Приложение.Key = "{7B4E1F3C-A702-11D2-A336-00C04F7978E0}" 
			Или Приложение.Key = "{01885945-612C-4A53-A479-E97507453926}" 
			Или Приложение.Key = "{02D4B3F1-FD88-11D1-960D-00805FC79235}" 
		Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаДоступногоПриложения = Неопределено;
		Компоненты = Приложения.GetCollection("Components", Приложение.Key);
		Попытка
			Компоненты.Populate();
		Исключение
			Компоненты = Неопределено;
			Сообщить("Ошибка получения компонент приложения """ + Приложение.Value("Name") + """: " + ОписаниеОшибки(), СтатусСообщения.Внимание);
			Продолжить;
		КонецПопытки; 
		Если Компоненты <> Неопределено Тогда
			Для Каждого Компонента Из Компоненты Цикл
				ИмяКласса = Компонента.Value("ProgID");
				Если Истина
					И Найти(НРег(ИмяКласса), "v8") = 1 
					И Найти(НРег(ИмяКласса), ".comconnector") = 4 
				Тогда
					НомерИзданияПлатформы = Число(Сред(ИмяКласса, 3, 1));
					ИмяКласса = "V8" + НомерИзданияПлатформы + ".ComConnector";
					ПолноеИмяФайла = Компонента.Value("DLL");
					Это64битнаяКомпонента = Найти(НРег(ПолноеИмяФайла), "(x86)") = 0 И ирКэш.Это64битнаяОСЛкс(Компьютер); // Ненадежно
					СтрокиКлассов = Классы.НайтиСтроки(Новый Структура("ИмяКласса, x64", ИмяКласса, Это64битнаяКомпонента));
					Если СтрокиКлассов.Количество() > 0 Тогда
						СтрокаКласса = СтрокиКлассов[0];
						СтрокаКласса.ИмяФайла = ПолноеИмяФайла;
						СтрокаКласса.ИдентификаторКласса = Компонента.Value("CLSID");
						СтрокаКласса.Зарегистрирован = Истина;
					КонецЕсли; 
				КонецЕсли; 
				Прервать;
			КонецЦикла;
		КонецЕсли; 
		Если ирКэш.Это64битнаяОСЛкс(Компьютер) Тогда
			Компоненты = Приложения.GetCollection("LegacyComponents", Приложение.Key);
			Компоненты.Populate();
			Для Каждого Компонента Из Компоненты Цикл
				ИмяКласса = Компонента.Value("ProgID");
				Если Истина
					И Найти(НРег(ИмяКласса), "v8") = 1 
					И Найти(НРег(ИмяКласса), ".comconnector") = 4 
				Тогда
					НомерИзданияПлатформы = Число(Сред(ИмяКласса, 3, 1));
					ИмяКласса = "V8" + НомерИзданияПлатформы + ".ComConnector";
					СтрокиКлассов = Классы.НайтиСтроки(Новый Структура("ИмяКласса, x64", ИмяКласса, Ложь));
					Если СтрокиКлассов.Количество() > 0 Тогда
						СтрокаКласса = СтрокиКлассов[0];
						ПолноеИмяФайла = Компонента.Value("InprocServer32");
						СтрокаКласса.ИдентификаторКласса = Компонента.Value("CLSID");
						СтрокаКласса.ИмяФайла = ПолноеИмяФайла;
						СтрокаКласса.Зарегистрирован = Истина;
					КонецЕсли; 
				КонецЕсли; 
				Прервать;
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла;
	Для Каждого СтрокаТаблицы Из Классы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.ИмяФайла) Тогда
			ФайлWMI = ирОбщий.ПолучитьФайлWMIЛкс(СтрокаТаблицы.ИмяФайла);
			Если ФайлWMI <> Неопределено Тогда
				СтрокаТаблицы.ФайлСуществует = Истина;
			КонецЕсли; 
			Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(СтрЗаменить(СтрокаТаблицы.ИмяФайла, "\\", "\"), "\");
			Фрагменты.Удалить(Фрагменты.ВГраница());
			Фрагменты.Удалить(Фрагменты.ВГраница());
			КаталогСборки = ирОбщий.ПолучитьСтрокуСРазделителемИзМассиваЛкс(Фрагменты, "\") + "\";
			СтрокаСборкиПлатформы = СборкиПлатформы.Найти(НРег(КаталогСборки), "НКаталог");
			Если ЗначениеЗаполнено(СтрокаСборкиПлатформы) Тогда
				СтрокаТаблицы.СборкаПлатформы = ПредставлениеСборкиПлатформы(СтрокаСборкиПлатформы, СтрокаТаблицы.Внутрипроцессный);
			Иначе
				Если ФайлWMI <> Неопределено Тогда
					СтрокаТаблицы.СборкаПлатформы = ФайлWMI.Version;
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	Классы.Сортировать("ИзданиеПлатформы Убыв, ТипКласса");
	
КонецПроцедуры

Функция ПредставлениеСборкиПлатформы(Знач СтрокаСборки, Знач Внутрипроцессный = Ложь) Экспорт 
	
	ПредставлениеСборки = СтрокаСборки.СборкаПлатформы;
	//Если Не Внутрипроцессный Тогда
	//	ПредставлениеСборки = ПредставлениеСборки + " - " + ?(СтрокаСборки.x64, "64", "32");
	//КонецЕсли;
	Возврат ПредставлениеСборки;

КонецФункции

Функция ЗаполнитьТипыCOMКлассов() Экспорт 
	
	ТабличныйДокумент = ПолучитьМакет("ТипыCOMКлассов");
	Результат = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(ТабличныйДокумент);
	ТипыComКлассов.Загрузить(Результат);
	Возврат Результат;
	
КонецФункции

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ПолноеИмяФайлаБазовогоМодуля = ирОбщий.ВосстановитьЗначениеЛкс("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
