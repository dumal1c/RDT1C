﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПлатформа;
Перем мТипыСлужб Экспорт;

// "C:\Program Files\1cv8\current\bin\ras.exe" cluster --service --port=1545 localhost:2540
// "C:\Program Files\1cv8\current\bin\dbgs.exe" --service -p 2610"
// "C:\Program Files\1cv8\current\bin\crserver.exe" -srvc -port 1542 -d e:\storage83\

Функция ПрименитьИзменения() Экспорт
	
	Для Каждого ТипСлужбы Из мТипыСлужб Цикл
		ТаблицаСлужб = ЭтотОбъект[ТипСлужбы.Значение.ИмяТабличнойЧасти];
		Для Каждого СтрокаСлужбы Из ТаблицаСлужб Цикл
			ОбновитьСлужбуПоСтроке(СтрокаСлужбы);
		КонецЦикла;
	КонецЦикла;
	Возврат Истина;
		
КонецФункции

Функция ИзменитьСостояниеСлужбы(Знач СтрокаТаблицыСлужб, НовоеСостояния = "start") Экспорт 
	
	Команда = "net " + НовоеСостояния + " """ + СтрокаТаблицыСлужб.Имя + """";
	Результат = ирОбщий.ВыполнитьКомандуОСЛкс(Команда,,, Истина);
	Результат = СокрЛП(Результат);
	ирОбщий.СообщитьЛкс(Результат);
	Результат = НРег(Результат);
	Результат = Ложь
		Или Найти(Результат, "успешно")
		Или Найти(Результат, "success");
	Возврат Результат;
	
КонецФункции

Процедура ОбновитьСлужбуПоСтроке(СтрокаСлужбы)
	
		#Если Сервер И Не Сервер Тогда
		    СтрокаСлужбы = СлужбыАгентовСерверов.Добавить();
		#КонецЕсли
	СлужбаWMI = ирКэш.ПолучитьCOMОбъектWMIЛкс();
	Если СлужбаWMI = Неопределено Тогда
		Возврат;
	КонецЕсли; 	
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT * 
	|FROM Win32_Service
	|WHERE NAME = '" + СтрокаСлужбы.Имя + "'");
	АктуальнаяСлужба = Неопределено;
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		Прервать;
	КонецЦикла;
	Команда = "sc \\" + ИмяКомпьютера();
	ИмяСлужбы = СтрокаСлужбы.Имя;
	Если Ложь
		Или Не ЗначениеЗаполнено(ИмяСлужбы)
		Или ирОбщий.СтрокиРавныЛкс("<Авто>", ИмяСлужбы)
	Тогда
		Порт = ПортСтрокиСлужбы(СтрокаСлужбы);
		ПортСтрока = XMLСтрока(Порт);
		ИмяСлужбы = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ИмяПоУмолчанию + " " + ПортСтрока;
	КонецЕсли;
	ТекстИмяСлужбы = """" + ИмяСлужбы + """";
	Если СтрокаСлужбы.Удалить Тогда
		Команда = Команда + " delete " + ТекстИмяСлужбы;
	Иначе
		ОбновитьСтрокуЗапускаСлужбы(СтрокаСлужбы);
		СтрокаЗапускаНовая = СтрокаСлужбы.СтрокаЗапускаНовая;
		ПредставлениеСлужбы = СтрокаСлужбы.Представление;
		Если Ложь
			Или Не ЗначениеЗаполнено(ПредставлениеСлужбы)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", ПредставлениеСлужбы)
		Тогда
			ПредставлениеСлужбы = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ПредставлениеПоУмолчанию + " " + ПортСтрока;
		КонецЕсли;
		ПредставлениеСлужбы = """" + ПредставлениеСлужбы + """";
		//Если УдалитьСуществующуюПоИмени Тогда
		//	Команда = "sc delete " + ТекстИмяСлужбы;
		//	Результат = ирОбщий.ВыполнитьКомандуОСЛкс(Команда);
		//	Сообщить(Результат);
		//КонецЕсли;
		Если АктуальнаяСлужба = Неопределено Тогда
			ТипОперации = "create";
		Иначе
			ТипОперации = "config";
		КонецЕсли; 
		Если СтрокаСлужбы.Автозапуск Тогда
			РежимЗапускаСлужбы = "auto";
		Иначе
			РежимЗапускаСлужбы = "demand";
		КонецЕсли; 
		Команда = Команда + " " + ТипОперации + " " + ТекстИмяСлужбы + " binPath= """ + СтрЗаменить(СтрокаЗапускаНовая, """", "\""") + """ start= " + РежимЗапускаСлужбы 
			+ " depend= Dnscache/Tcpip/lanmanworkstation/lanmanserver displayname= " + ПредставлениеСлужбы;
		Если ЗначениеЗаполнено(СтрокаСлужбы.ПарольПользователя) Тогда
			Команда = Команда + " obj= " + СтрокаСлужбы.ИмяПользователя + " password= " + СтрокаСлужбы.ПарольПользователя;
		КонецЕсли; 
	КонецЕсли; 
	Результат = ирОбщий.ВыполнитьКомандуОСЛкс(Команда,,, Истина);
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Результат = "Не удалось получить результат обработки службы";
	КонецЕсли;
	ирОбщий.СообщитьЛкс("Результат обновления службы """ + ИмяСлужбы + """: " + СокрЛП(Результат));
	
	// установить описание службы можно только отдельным запуском sc
	Команда = "sc description " + ТекстИмяСлужбы + " " + ПредставлениеСлужбы;
	Результат = ирОбщий.ВыполнитьКомандуОСЛкс(Команда,,, Истина);
	//Если ЗапуститьСразу Тогда
	//	Команда = "net start " + ТекстИмяСлужбы;
	//	Результат = ирОбщий.ВыполнитьКомандуОСЛкс(Команда);
	//	Сообщить(Результат);
	//КонецЕсли;
	Если Истина
		И Не ирОбщий.СтрокиРавныЛкс(СтрокаСлужбы.ИмяПользователя, "LocalSystem") 
		И (Ложь
			Или СтрокаСлужбы.ТипСлужбы = мТипыСлужб.АгентСервера.ТипСлужбы 
			Или СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы)
	Тогда
		// Устанавливаем права на каталог файлов через PowerShell https://netlly.ru/posh-ntfs/
		Если СтрокаСлужбы.ТипСлужбы = мТипыСлужб.АгентСервера.ТипСлужбы Тогда
			КаталогФайлов = СтрокаСлужбы.КаталогКонфигурации;
		Иначе
			КаталогФайлов = СтрокаСлужбы.КаталогХранилища;
		КонецЕсли; 
		ФайлПараметров = Новый Файл(ПолучитьИмяВременногоФайла("txt"));
		ИмяПользователяПрав = СтрЗаменить(СтрокаСлужбы.ИмяПользователя, ".\", ИмяКомпьютера() + "\");
		Если Найти(ИмяПользователяПрав, "\") = 0 И Найти(ИмяПользователяПрав, "@") = 0 Тогда
			ИмяПользователяПрав = ИмяКомпьютера() + "\" + ИмяПользователяПрав;
		КонецЕсли; 
		ТекстПараметров = Новый ТекстовыйДокумент;
		ТекстПараметров.ДобавитьСтроку("Folder;SecIdentity;AccessRights;AccessControlType;BlockInherit");
		ТекстПараметров.ДобавитьСтроку(КаталогФайлов + ";" + ИмяПользователяПрав + ";FullControl;Allow");
		ТекстПараметров.Записать(ФайлПараметров.ПолноеИмя);
		СкриптУстановкиПрав = ПолучитьМакет("СкриптУстановкаПравNTFS");
		ФайлСкрипта = Новый Файл(ПолучитьИмяВременногоФайла("ps1"));
		СкриптУстановкиПрав.Записать(ФайлСкрипта.ПолноеИмя);
		КомандаСистемыЗапускаСкрипта = ирОбщий.КомандаСистемыЗапускаСкриптаPowerShellЛкс(ФайлСкрипта.Имя + " -FolderListFile " + ФайлПараметров.Имя);
		РезультатУстановкиПрав = ирОбщий.ВыполнитьКомандуОСЛкс(КомандаСистемыЗапускаСкрипта,,, Истина);
		Если ЗначениеЗаполнено(РезультатУстановкиПрав) Тогда
			ирОбщий.СообщитьЛкс("Ошибка предоставления пользователю " + СтрокаСлужбы.ИмяПользователя + " полных прав на каталог " + КаталогФайлов, СтатусСообщения.Внимание);
			ирОбщий.СообщитьЛкс(РезультатУстановкиПрав, СтатусСообщения.Внимание);
		Иначе
			ирОбщий.СообщитьЛкс("Пользователю " + СтрокаСлужбы.ИмяПользователя + " предоставлены полные права на каталог " + КаталогФайлов);
		КонецЕсли; 
		УдалитьФайлы(ФайлПараметров.ПолноеИмя);
		УдалитьФайлы(ФайлСкрипта.ПолноеИмя);
	КонецЕсли; 

КонецПроцедуры

Функция ПолноеИмяИсполняемогоФайла(СтрокаСлужбы, выхКаталогИсполняемыхФайлов = "")
	
	#Если Сервер И Не Сервер Тогда
		СтрокаСлужбы = Обработки.ирУправлениеСлужбамиСервера1С.Создать().СлужбыАгентовСерверов.Добавить();
	#КонецЕсли
	КраткоеИмяИсполняемогоФайла = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ИмяИсполняемогоФайла;
	Если ЗначениеЗаполнено(СтрокаСлужбы.СборкаПлатформыНовая) Тогда
		СборкаПлатформыНовая = СтрокаСлужбы.СборкаПлатформыНовая;
	Иначе
		СборкаПлатформыНовая = СтрокаСлужбы.СборкаПлатформыАктивная;
	КонецЕсли; 
	ОтборВерсий = Новый Структура(СтрокаСлужбы.ТипСлужбы + ", КлючСборки", Истина, СборкаПлатформыНовая);
	ПодходящиеВерсии = СборкиПлатформы.Выгрузить(ОтборВерсий);
	ПодходящиеВерсии.Сортировать("x64 Убыв");
	Если ПодходящиеВерсии.Количество() > 0 Тогда
		выхКаталогИсполняемыхФайлов = ПодходящиеВерсии[0].Каталог;
	Иначе
		выхКаталогИсполняемыхФайлов = СборкаПлатформыНовая;
	КонецЕсли; 
	ирОбщий.ДобавитьЕслиНужноПравыйСлешВФайловыйПутьЛкс(выхКаталогИсполняемыхФайлов);
	СтрокаЗапускаНовая = """" + выхКаталогИсполняемыхФайлов + "bin\" + КраткоеИмяИсполняемогоФайла + """";
	Возврат СтрокаЗапускаНовая;

КонецФункции

Процедура ОбновитьСтрокуЗапускаСлужбы(Знач СтрокаСлужбы) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    СтрокаСлужбы = Обработки.ирУправлениеСлужбамиСервера1С.Создать().СлужбыАгентовСерверов.Добавить();
	#КонецЕсли
	КаталогИсполняемыхФайлов = Неопределено;
    СтрокаЗапускаНовая = ПолноеИмяИсполняемогоФайла(СтрокаСлужбы, КаталогИсполняемыхФайлов);
	Порт = ПортСтрокиСлужбы(СтрокаСлужбы);
	ПортСлужбы = XMLСтрока(Порт);
	Если СтрокаСлужбы.ТипСлужбы = мТипыСлужб.АгентСервера.ТипСлужбы Тогда
		НачальныйПортРабочихПроцессов = СтрокаСлужбы.НачальныйПортРабочихПроцессов;
		Если Ложь
			Или Не ЗначениеЗаполнено(НачальныйПортРабочихПроцессов)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", НачальныйПортРабочихПроцессов)
		Тогда
			НачальныйПортРабочихПроцессов = Порт + 20;
		КонецЕсли; 
		КонечныйПортРабочихПроцессов = СтрокаСлужбы.КонечныйПортРабочихПроцессов;
		Если Ложь
			Или Не ЗначениеЗаполнено(КонечныйПортРабочихПроцессов)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", КонечныйПортРабочихПроцессов)
		Тогда
			КонечныйПортРабочихПроцессов = Порт + 51;
		КонецЕсли; 
		ПортКластера = XMLСтрока(Порт + 1);
		КаталогКонфигурации = СтрокаСлужбы.КаталогКонфигурации;
		Если Ложь
			Или Не ЗначениеЗаполнено(КаталогКонфигурации)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", КаталогКонфигурации)
		Тогда
			ФайлКаталогаВерсии = Новый Файл(КаталогИсполняемыхФайлов);
			КаталогКонфигурации = ФайлКаталогаВерсии.Путь + "srvinfo" + XMLСтрока(ПортСлужбы);
		КонецЕсли;
		СоздатьКаталог(КаталогКонфигурации);
		ДиапазонПортов = XMLСтрока(НачальныйПортРабочихПроцессов) + ":" + XMLСтрока(КонечныйПортРабочихПроцессов);
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -srvc -agent -regport " + ПортКластера + " -port " + ПортСлужбы + " -range " + ДиапазонПортов + " -d """ + КаталогКонфигурации + """";
		Если СтрокаСлужбы.РежимОтладки = "tcp" Тогда
			СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debug";
		ИначеЕсли СтрокаСлужбы.РежимОтладки = "http" Тогда
			СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debug -http";
			Если ЗначениеЗаполнено(СтрокаСлужбы.СерверОтладкиАдрес) Тогда
				СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debugServerAddr " + СтрокаСлужбы.СерверОтладкиАдрес;
			КонецЕсли; 
			Если ЗначениеЗаполнено(СтрокаСлужбы.СерверОтладкиПорт) Тогда
				СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debugServerPort " + XMLСтрока(СтрокаСлужбы.СерверОтладкиПорт);
			КонецЕсли; 
			Если ЗначениеЗаполнено(СтрокаСлужбы.СерверОтладкиПароль) Тогда
				СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debugServerPwd " + СтрокаСлужбы.СерверОтладкиПароль;
			КонецЕсли; 
		КонецЕсли;
	ИначеЕсли СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверАдминистрирования.ТипСлужбы Тогда
		Если СтрокаСлужбы.РежимКластера Тогда
			СтрокаЗапускаНовая = СтрокаЗапускаНовая + " cluster";
		КонецЕсли; 
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " --service --port=" + ПортСлужбы + " " + СтрокаСлужбы.СтрокаСоединенияАгентаСервера;
	ИначеЕсли СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверОтладки.ТипСлужбы Тогда
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " --service -p " + ПортСлужбы;
	ИначеЕсли СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы Тогда
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -srvc -port " + ПортСлужбы + " -d """ + СтрокаСлужбы.КаталогХранилища + """";
	КонецЕсли; 
	СтрокаСлужбы.СтрокаЗапускаНовая = СтрокаЗапускаНовая;

КонецПроцедуры

Функция ПортСтрокиСлужбы(Знач СтрокаСлужбы) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    СтрокаСлужбы = Обработки.ирУправлениеСлужбамиСервера1С.Создать().СлужбыАгентовСерверов.Добавить();
	#КонецЕсли
	Порт = СтрокаСлужбы.Порт;
	Если Не ЗначениеЗаполнено(Порт) Тогда
		Порт = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ПортПоУмолчанию;
	КонецЕсли;
	Возврат Порт;

КонецФункции

Процедура Заполнить() Экспорт 

	ирОбщий.ЗаполнитьДоступныеСборкиПлатформыЛкс(СборкиПлатформы);
	СлужбыАгентовСерверов.Очистить();
	СлужбыСерверовАдминистрирования.Очистить();
	СлужбыСерверовОтладки.Очистить();
	СлужбыХранилищКонфигураций.Очистить();
	СлужбаWMI = ирКэш.ПолучитьCOMОбъектWMIЛкс();
	Если СлужбаWMI = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	// СлужбыАгентовСерверов
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.АгентСервера.ИмяИсполняемогоФайла + "%'
		|AND PathName LIKE '%-srvc -agent%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыАгентовСерверов, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыАгентовСерверов.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.АгентСервера.ТипСлужбы;
		СтрокаЗапускаСлужбы = СокрЛП(АктуальнаяСлужба.PathName) + " ";
		МаркерПорт = " -port ";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.СтрокаМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		СтрокаДиапазона = ирОбщий.СтрокаМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), "-range ", " ", Ложь);
		Если ЗначениеЗаполнено(СтрокаДиапазона) Тогда
			ФрагментыДиапазона = ирОбщий.СтрРазделитьЛкс(СтрокаДиапазона, ":");
			СтрокаСлужбы.НачальныйПортРабочихПроцессов = Число(ФрагментыДиапазона[0]);
			СтрокаСлужбы.КонечныйПортРабочихПроцессов = Число(ФрагментыДиапазона[1]);
		КонецЕсли; 
		СтрокаСлужбы.КаталогКонфигурации = ирОбщий.СтрокаМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, "-d """, """"); // Регистрозависимость маркера не убрана!
		Если Не ЗначениеЗаполнено(СтрокаСлужбы.КаталогКонфигурации) Тогда
			СтрокаСлужбы.КаталогКонфигурации = ирОбщий.СтрокаМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, " -d ", " ");
		КонецЕсли; 
		СтрокаСлужбы.РежимОтладки = ирОбщий.РежимОтладкиИзКоманднойСтрокиЛкс(СтрокаЗапускаСлужбы);
		СтрокаСлужбы.СерверОтладкиАдрес = ирОбщий.СтрокаМеждуМаркерамиЛкс(Нрег(СтрокаЗапускаСлужбы), НРег("-debugServerAddr "), " ", Ложь);
		СтрокаСлужбы.СерверОтладкиПорт = ирОбщий.СтрокаМеждуМаркерамиЛкс(Нрег(СтрокаЗапускаСлужбы), НРег("-debugServerPort "), " ", Ложь);
		СтрокаСлужбы.СерверОтладкиПароль = ирОбщий.СтрокаМеждуМаркерамиЛкс(Нрег(СтрокаЗапускаСлужбы), НРег("-debugServerPwd "), " ", Ложь);
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");

	// СлужбыАдминистрированияСерверов
	// "C:\Program Files\1cv8\current\bin\ras.exe" cluster --service --port=1545 localhost:2540
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.СерверАдминистрирования.ИмяИсполняемогоФайла + "%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыСерверовАдминистрирования, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыСерверовАдминистрирования.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверАдминистрирования.ТипСлужбы;
		СтрокаЗапускаСлужбы = СокрЛП(АктуальнаяСлужба.PathName) + " ";
		МаркерПорт = " --port=";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.СтрокаМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		МаркерПорт = " -p="; // альтернативный
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.СтрокаМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		СтрокаСлужбы.РежимКластера = Найти(НРег(СтрокаЗапускаСлужбы), " cluster ") > 0;
		Фрагменты = ирОбщий.СтрРазделитьЛкс(СтрокаЗапускаСлужбы, " ", Истина);
		СтрокаСлужбы.СтрокаСоединенияАгентаСервера = Фрагменты[Фрагменты.ВГраница()];
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");
	
	// СлужбыСерверовОтладки
	// "C:\Program Files\1cv8\current\bin\dbgs.exe --service -p 2610"
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.СерверОтладки.ИмяИсполняемогоФайла + "%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыСерверовОтладки, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыСерверовОтладки.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверОтладки.ТипСлужбы;
		СтрокаЗапускаСлужбы = СокрЛП(АктуальнаяСлужба.PathName) + " ";
		МаркерПорт = " -p ";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.СтрокаМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Истина));
		КонецЕсли; 
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");

	// СлужбыХранилищКонфигураций
	// "C:\Program Files\1cv8\current\bin\crserver.exe" -srvc -port 1542 -d e:\storage83\
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.СерверХранилища.ИмяИсполняемогоФайла + "%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыХранилищКонфигураций, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыХранилищКонфигураций.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы;
		СтрокаЗапускаСлужбы = СокрЛП(АктуальнаяСлужба.PathName);
		МаркерПорт = " -port ";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.СтрокаМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		СтрокаСлужбы.КаталогХранилища = ирОбщий.СтрокаМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, "-d """, """"); // Регистрозависимость маркера не убрана!
		Если Не ЗначениеЗаполнено(СтрокаСлужбы.КаталогХранилища) Тогда
			СтрокаСлужбы.КаталогХранилища = ирОбщий.СтрокаМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, " -d ", " ");
		КонецЕсли; 
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");

КонецПроцедуры

Функция ДобавитьЗаполнитьСтрокуСлужбы(ТаблицаСлужб, Знач АктуальнаяСлужба)
	
		#Если Сервер И Не Сервер Тогда
		    ТаблицаСлужб = ЭтотОбъект.СлужбыСерверовОтладки;
		#КонецЕсли
	СтрокаЗапускаСлужбы = АктуальнаяСлужба.PathName;
	СтрокаСлужбы = ТаблицаСлужб.Добавить();
	СтрокаСлужбы.Имя = АктуальнаяСлужба.Name;
	СтрокаСлужбы.СтрокаЗапускаСлужбы = СтрокаЗапускаСлужбы;
	СтрокаЗапускаСлужбы = СтрЗаменить(СтрокаЗапускаСлужбы + " ", " /", " -");
	Если ЗначениеЗаполнено(АктуальнаяСлужба.ProcessId) Тогда
		АктивныйПроцесс = ирОбщий.ПолучитьПроцессОСЛкс(АктуальнаяСлужба.ProcessId);
		Если ТипЗнч(АктивныйПроцесс) <> Тип("Строка") Тогда
			СтрокаСлужбы.СтрокаЗапускаАктивная = АктивныйПроцесс.CommandLine;
			СтрокаСлужбы.ПараметрыИзменены = ЗначениеЗаполнено(СтрокаСлужбы.СтрокаЗапускаАктивная) И Не ирОбщий.СтрокиРавныЛкс(СтрокаСлужбы.СтрокаЗапускаАктивная, СтрокаСлужбы.СтрокаЗапускаСлужбы);
			Если Не ЗначениеЗаполнено(СтрокаСлужбы.СтрокаЗапускаАктивная) Тогда
				СтрокаСлужбы.СтрокаЗапускаАктивная = "<Для получения данных требуется запуск от имени администратора>";
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	СтрокаСлужбы.Представление = АктуальнаяСлужба.Caption;
	СтрокаСлужбы.ИмяПользователя = АктуальнаяСлужба.StartName;
	СтрокаСлужбы.ИдентификаторПроцесса = АктуальнаяСлужба.ProcessId;
	СтрокаСлужбы.Выполняется = ирОбщий.СтрокиРавныЛкс(АктуальнаяСлужба.State, "Running");
	СтрокаСлужбы.Автозапуск = ирОбщий.СтрокиРавныЛкс(АктуальнаяСлужба.StartMode, "Auto");
	СтрокаСлужбы.СборкаПлатформыНовая = ПолучитьСборкуПлатформуИзКоманднойСтроки(СтрокаЗапускаСлужбы);
	Если ЗначениеЗаполнено(СтрокаСлужбы.ИдентификаторПроцесса) Тогда
		АктивныйПроцесс = ирОбщий.ПолучитьПроцессОСЛкс(АктуальнаяСлужба.ProcessId);
		СтрокаЗапускаПроцесса = АктивныйПроцесс.CommandLine;
	Иначе
		АктивныйПроцесс = Неопределено;
	КонецЕсли; 
	Если АктивныйПроцесс <> Неопределено И ТипЗнч(СтрокаЗапускаПроцесса) = Тип("Строка") И ЗначениеЗаполнено(СтрокаЗапускаПроцесса) Тогда 
		СтрокаСлужбы.СборкаПлатформыАктивная = ПолучитьСборкуПлатформуИзКоманднойСтроки(СтрокаЗапускаПроцесса);
	КонецЕсли;
	Возврат СтрокаСлужбы;

КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Отказ = Ложь;
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить("");
	МассивИсключений.Добавить("<Авто>");
	Для Каждого ТипСлужбы Из мТипыСлужб Цикл
		ТипСлужбы = ТипСлужбы.Значение;
		ИмяТабличнойЧасти = ТипСлужбы.ИмяТабличнойЧасти;
		ТаблицаСлужб = ЭтотОбъект[ИмяТабличнойЧасти];
		Отказ = Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "Имя",,, МассивИсключений) Или Отказ;
		Отказ = Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "Представление",,, МассивИсключений) Или Отказ;
		Отказ = Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "Порт", , Новый Структура("Автозапуск, Удалить", Истина, Ложь)) Или Отказ;
		Если ТипСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы Тогда
			Отказ = Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "КаталогХранилища", , Новый Структура("Автозапуск, Удалить", Истина, Ложь)) Или Отказ;
		ИначеЕсли ТипСлужбы.ТипСлужбы = мТипыСлужб.АгентСервера.ТипСлужбы Тогда
			Отказ = Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "КаталогКонфигурации", , Новый Структура("Автозапуск, Удалить", Истина, Ложь)) Или Отказ;
		КонецЕсли; 
		Для Индекс = 0 По ТаблицаСлужб.Количество() - 1 Цикл
			СтрокаСлужбы = ТаблицаСлужб[Индекс];
			Если Не СтрокаСлужбы.Удалить Тогда
				МассивПутейКДанным = Новый Соответствие;
				Если ТипСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы Тогда
					МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].КаталогХранилища");
				ИначеЕсли ТипСлужбы.ТипСлужбы = мТипыСлужб.СерверАдминистрирования.ТипСлужбы Тогда
					МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].СтрокаСоединенияАгентаСервера");
				КонецЕсли;
				Если Не ЗначениеЗаполнено(СтрокаСлужбы.СборкаПлатформыАктивная)  Тогда
					МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].СборкаПлатформыНовая");
				КонецЕсли; 
				МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].Порт");
				ирОбщий.ПроверитьЗаполнениеРеквизитовОбъектаЛкс(ЭтотОбъект, МассивПутейКДанным, Отказ);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьWMIОбъектСлужбы(ИмяСлужбы, Компьютер = Неопределено, ВызыватьИсключениеЕслиНеНайдена = Истина) Экспорт 
	
	СлужбаWMI = ирКэш.ПолучитьCOMОбъектWMIЛкс();
	Если СлужбаWMI = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ТекстЗапросаWQL = "Select * from Win32_Service Where Name = '" + ИмяСлужбы + "'";
	ВыборкаСистемныхСлужб = СлужбаWMI.ExecQuery(ТекстЗапросаWQL);
	Для Каждого лСистемнаяСлужба Из ВыборкаСистемныхСлужб Цикл
		СистемнаяСлужба = лСистемнаяСлужба;
	КонецЦикла;
	Если СистемнаяСлужба = Неопределено Тогда 
		СистемнаяСлужба = "Системная служба с именем """ + ИмяСлужбы + """ не найдена" ; // Сигнатура (начало строки) используется в Обработка.ПоддержаниеСервераПриложенийИис
		Если ВызыватьИсключениеЕслиНеНайдена Тогда
			ВызватьИсключение СистемнаяСлужба;
		КонецЕсли; 
	КонецЕсли;
	Возврат СистемнаяСлужба;

КонецФункции

Функция ПолучитьСборкуПлатформуИзКоманднойСтроки(Строка)
	
	#Если Сервер И Не Сервер Тогда
	    мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Результат = "";
	ВычислительРегВыражений = мПлатформа.RegExp;
	ВычислительРегВыражений.Pattern = """(.+\\\d+\.\d+\.\d+\.\d+\\)";
	Вхождения = ВычислительРегВыражений.НайтиВхождения(Строка);
	Если Вхождения.Количество() > 0 Тогда
		Результат = Вхождения[0].Submatches(0);
	Иначе
		ВычислительРегВыражений = мПлатформа.RegExp;
		ВычислительРегВыражений.Pattern = """(.+\\)bin\\.*\.exe""";
		Вхождения = ВычислительРегВыражений.НайтиВхождения(Строка);
		Если Вхождения.Количество() > 0 Тогда
			Результат = Вхождения[0].Submatches(0);
		КонецЕсли; 
	КонецЕсли; 
	Для Каждого СтрокаСборкаПлатформы Из СборкиПлатформы Цикл
		Если ирОбщий.СтрокиРавныЛкс(СтрокаСборкаПлатформы.Каталог, Результат) Тогда
			Результат = СтрокаСборкаПлатформы.КлючСборки;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Процедура ОткрытьКонсольСерверов1С(Знач ТаблицаСерверов = Неопределено, Знач ТекущаяСтрокаТаблицыСерверов = Неопределено) Экспорт 

	Если ЗначениеЗаполнено(ТекущаяСтрокаТаблицыСерверов.СборкаПлатформыАктивная) Тогда
		СборкаПлатформыАктивная = ТекущаяСтрокаТаблицыСерверов.СборкаПлатформыАктивная;
	Иначе
		СборкаПлатформыАктивная = ТекущаяСтрокаТаблицыСерверов.СборкаПлатформыНовая;
	КонецЕсли; 
	СборкаПлатформыАктивная = ирОбщий.ПервыйФрагментЛкс(СборкаПлатформыАктивная, " ");
	ирОбщий.ОткрытьКонсольСерверов1СЛкс(СборкаПлатформыАктивная, ТаблицаСерверов);
	
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

мПлатформа = ирКэш.Получить();
ТаблицаТиповСлужб = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("ПараметрыТиповСлужб"),,,, Истина);
мТипыСлужб = Новый Структура;
Для Каждого СтрокаТаблицы Из ТаблицаТиповСлужб Цикл
	мТипыСлужб.Вставить(СтрокаТаблицы.ТипСлужбы, СтрокаТаблицы);
КонецЦикла;
