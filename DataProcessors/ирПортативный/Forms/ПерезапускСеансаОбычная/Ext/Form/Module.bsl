﻿Процедура ЗапуститьНовоеПриложение(Знач ОбычноеПриложение = Истина)
	
	#Если ВебКлиент Или МобильныйКлиент Тогда
		Сообщить("Команда недоступна веб клиенте");
	#Иначе
		Если ТекущийПользователь Тогда
			НастроитьПользователяНаСервере();
		КонецЕсли; 
		ПараметрыЗапуска = "";
		СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
		ПараметрыЗапуска = ПараметрыЗапуска + " ENTERPRISE";
		ПараметрыЗапуска = ПараметрыЗапуска + " /IBConnectionString""" + СтрЗаменить(СтрокаСоединения, """", """""") + """";
		Если ОбычноеПриложение Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /RunModeOrdinaryApplication";
		Иначе
			ПараметрыЗапуска = ПараметрыЗапуска + " /RunModeManagedApplication";
		КонецЕсли; 
		ПараметрыЗапуска = ПараметрыЗапуска + " /Debug";
		ПараметрыЗапуска = ПараметрыЗапуска + " /UC""" + КодРазрешения + """";
		ИспользуемоеИмяФайлаЛ = ПолучитьИспользуемоеИмяФайла(ИмяКомпьютера());
		Если ЗначениеЗаполнено(ИспользуемоеИмяФайлаЛ) Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /Execute""" + ИспользуемоеИмяФайлаЛ + """";
		КонецЕсли; 
		Если ТекущийПользователь Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " /N""" + ИмяПользователя() + """";
			Если ЗначениеЗаполнено(ПарольТекущегоПользователя) Тогда
				ПараметрыЗапуска = ПараметрыЗапуска + " /P""" + ПарольТекущегоПользователя + """";
			КонецЕсли; 
		КонецЕсли; 
		Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
			ПараметрыЗапуска = ПараметрыЗапуска + " " + ДополнительныеПараметры;
		КонецЕсли; 
		
		Если ПодключитьОтладчик Тогда
			Попытка
				ВК = Новый ("AddIn.ирОбщая.AddIn");
			Исключение
				// https://partners.v8.1c.ru/forum/t/1265923/m/1555146
				//АдресКомпоненты = ПолучитьАдресВнешнейКомпоненты();
				//УстановитьВнешнююКомпоненту(АдресКомпоненты); // Выдает предупреждение пользователю каждый раз
				//
				Это64битныйПроцесс = Это64битныйПроцесс();
				ДвоичныеДанные = ПолучитьДвоичныеДанныеВК(Это64битныйПроцесс);
				АдресКомпоненты = ПолучитьИмяВременногоФайла("dll");
				ДвоичныеДанные.Записать(АдресКомпоненты);
				
				Результат = ПодключитьВнешнююКомпоненту(АдресКомпоненты, "ирОбщая", ТипВнешнейКомпоненты.Native);
				Если Не Результат Тогда
					ВызватьИсключение "Не удалось подключить внешнюю компоненту Общая. Она требуется для флажка ""Подключить отладчик"""; 
				КонецЕсли; 
				ВК = Новый ("AddIn.ирОбщая.AddIn");
			КонецПопытки; 
			ИдентификаторПроцессаОС = ВК.PID();
			ПараметрыЗапускаДляОтладки = ПараметрыЗапускаСеансаДляПодключенияКТекущемуОтладчику(ИдентификаторПроцессаОС);
			ПараметрыЗапуска = ПараметрыЗапуска + " " + ПараметрыЗапускаДляОтладки;
		КонецЕсли; 
		
		ИсполняемыйФайл = Новый Файл(КаталогПрограммы() + "1cv8.exe");
		//Если Не ИсполняемыйФайл.Существует() Тогда
		//	ВызватьИсключение "Необходимо установить толстый клиент 1С";
		//КонецЕсли; 
		ЗапуститьПриложение("""" + ИсполняемыйФайл.ПолноеИмя + """ " + ПараметрыЗапуска);
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли; 
		Если ЗавершитьСеанс Тогда
			ЗавершитьРаботуСистемы();
		КонецЕсли; 
	#КонецЕсли

КонецПроцедуры

Процедура НастроитьПользователяНаСервере()
	
	Элементы = ЭлементыФормы;
	ИмяПользователя = ИмяПользователя();
	Если Элементы.ВключитьКомпактныйВариантФорм.Доступность И ВключитьКомпактныйВариантФорм Тогда
		НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, ИмяПользователя);
		Если НастройкиКлиентскогоПриложения = Неопределено Тогда
			НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
		КонецЕсли;
		НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения = Вычислить("ВариантМасштабаФормКлиентскогоПриложения.Компактный");
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения", "", НастройкиКлиентскогоПриложения, , ИмяПользователя);
	КонецЕсли; 
	Если Элементы.ОтключитьЗащитуОтОпасныхДействий.Доступность И ОтключитьЗащитуОтОпасныхДействий И ЗначениеЗаполнено(ИмяПользователя) Тогда
		Пользователь = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
		Если Пользователь <> Неопределено Тогда
			Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
			Пользователь.Записать();
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Функция ДоступнаЗащитаОтОпасныхДействий() Экспорт 
	
	Перем ТекущийПользователь;
	ЗащитаОтОпасныхДействийЛ = Неопределено;
	Попытка
		ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		ЗащитаОтОпасныхДействийЛ = ТекущийПользователь.ЗащитаОтОпасныхДействий;
	Исключение
	КонецПопытки;
	Возврат ЗащитаОтОпасныхДействийЛ <> Неопределено;
	
КонецФункции

#Если Не ВебКлиент И Не МобильныйКлиент Тогда
// р5яф67оыйи
Функция ПараметрыЗапускаСеансаДляПодключенияКТекущемуОтладчику(Знач ИдентификаторПроцессаОС) Экспорт 
	
	ПараметрыЗапускаДляОтладки = "";
	ТекущийПроцесс = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\CIMV2:Win32_Process.Handle='" + XMLСтрока(ИдентификаторПроцессаОС) + "'");
	КоманднаяСтрокаПроцесса = ТекущийПроцесс.CommandLine;
	ВычислительРегулярныхВыражений = Новый COMОбъект("VBScript.RegExp");
	ВычислительРегулярныхВыражений.IgnoreCase = Истина;
	ВычислительРегулярныхВыражений.Global = Истина;
	ВычислительРегулярныхВыражений.Pattern = "(/DebuggerUrl\s*.+?)( /|$)";
	Вхождения = ВычислительРегулярныхВыражений.Execute(КоманднаяСтрокаПроцесса);
	Если Вхождения.Count > 0 Тогда
		ПараметрыЗапускаДляОтладки = Вхождения.Item(Вхождения.Count - 1).SubMatches(0);
	КонецЕсли; 
	ВычислительРегулярныхВыражений.Pattern = "(/Debug\s+.+?)( /|$)";
	Вхождения = ВычислительРегулярныхВыражений.Execute(КоманднаяСтрокаПроцесса);
	Если Вхождения.Count > 0 Тогда
		СтрокаОтладчика = Вхождения.Item(Вхождения.Count - 1).SubMatches(0);
	Иначе
		СтрокаОтладчика = "/Debug";
	КонецЕсли;
	ПараметрыЗапускаДляОтладки = ПараметрыЗапускаДляОтладки + " " + СтрокаОтладчика;
	Возврат ПараметрыЗапускаДляОтладки;


КонецФункции
#КонецЕсли 

Функция ОбработкаОбъект()
	
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		ОбработкаОбъект = ЭтаФорма.РеквизитФормыВЗначение("Объект");
	Иначе
		ОбработкаОбъект = Вычислить("ЭтотОбъект");
	КонецЕсли; 
	Возврат ОбработкаОбъект;

КонецФункции

Функция ПолучитьДвоичныеДанныеВК(x64 = Ложь)
	ОбработкаОбъект = ОбработкаОбъект();
	ИмяМакета = "ВК";
	Если x64 Тогда
		ИмяМакета = ИмяМакета + "64";
	Иначе
		ИмяМакета = ИмяМакета + "32";
	КонецЕсли; 
	Возврат ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
КонецФункции

Функция ПолучитьАдресВнешнейКомпоненты()
	ОбработкаОбъект = ОбработкаОбъект();
	#Если Сервер И Не Сервер Тогда
	    ОбработкаОбъект = Обработки.ирПортативный.Создать();
	#КонецЕсли
	ОбъектМД = ОбработкаОбъект.Метаданные();
	// Антибаг платформы 8.2.19, исправлен в 8.3, ПолноеИмя() для дочерних метаданных внешней обработки возвращало обрезанное имя
	Адрес = ОбъектМД.ПолноеИмя() + ".Макет." + ОбъектМД.Макеты.ВК.Имя;
	Возврат Адрес;
КонецФункции

Функция ПолучитьИспользуемоеИмяФайла(ИмяКомпьютера)
	
	ОбработкаОбъект = ОбработкаОбъект();
	Попытка
		ИспользуемоеИмяФайлаЛ = ОбработкаОбъект.ИспользуемоеИмяФайла;
	Исключение
	КонецПопытки; 
	Возврат ИспользуемоеИмяФайлаЛ;
	
КонецФункции

Функция Это64битныйПроцесс() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Результат = СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	Возврат Результат;
	
КонецФункции

Процедура ЗапуститьОбычноеПриложениеНажатие(Элемент)
	
	ЗапуститьНовоеПриложение(Истина);
	
КонецПроцедуры

Процедура ЗапуститьТолстыйКлиентНажатие(Элемент)
	
	ЗапуститьНовоеПриложение(Ложь);
	
КонецПроцедуры

Процедура ТекущийПользовательПриИзменении(Элемент)
	
	ОбновитьДоступность();

КонецПроцедуры

Процедура ОбновитьДоступность()
	
	СисИнфо = Новый СистемнаяИнформация;
	ЭлементыФормы.ОтключитьЗащитуОтОпасныхДействий.Доступность = ТекущийПользователь И ДоступнаЗащитаОтОпасныхДействий();
	ЭлементыФормы.ВключитьКомпактныйВариантФорм.Доступность = ТекущийПользователь И Найти(СисИнфо.ВерсияПриложения, "8.2") <> 1;
	ЭлементыФормы.ПарольТекущегоПользователя.Доступность = ТекущийПользователь;
	
КонецПроцедуры

////////////////////////

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ОбновитьДоступность();
	
КонецПроцедуры

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ЗавершитьСеанс, Форма.ЗакрытьФорму, Форма.ПодключитьОтладчик, Форма.КодРазрешения, Форма.ТекущийПользователь, Форма.ОтключитьЗащитуОтОпасныхДействий, Форма.ВключитьКомпактныйВариантФорм, Форма.ДополнительныеПараметры";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	ОбновитьДоступность();

КонецПроцедуры

Процедура ДополнительныеПараметрыПриИзменении(Элемент)

	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ДополнительныеПараметрыНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт 
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПортативный.Форма.ПерезапускСеансаОбычная");
//ЭтаФорма.ПодключитьОтладчик = Истина;
ЭтаФорма.ЗакрытьФорму = Истина;
ЭтаФорма.ТекущийПользователь = Истина;
ЭтаФорма.ОтключитьЗащитуОтОпасныхДействий = Истина;
//ЭтаФорма.ВключитьКомпактныйВариантФорм = Истина;
