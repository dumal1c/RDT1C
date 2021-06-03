﻿Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	// Если указать ИсполняемыйФайлПлатформы, то будет ошибка при загрузке расширения из файлов
	// Неизвестная версия формата 2.6 загружаемого файла
	ЭтаФорма.ИсполняемыйФайлПлатформы = "";
	
	КаталогВыгрузкиКонфигурации = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогВыгрузкиКонфигурации);
	ТекстЛога = "";
	// Выгружаем конфигурацию в файлы
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigToFiles """ + КаталогВыгрузкиКонфигурации + """ -Format Hierarchical", СтрокаСоединенияИнформационнойБазы(), ТекстЛога,,
		"Выгрузка конфигурации в файлы",,,, ИмяПользователя, ПарольПользователя);
	Если Не Успех Тогда 
		УдалитьФайлы(КаталогВыгрузкиКонфигурации);
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	//КаталогВыгрузкиКонфигурации = "Z:\Ир"; // Для отладки
	
	Результат = СоздатьРасширение("e", КаталогВыгрузкиКонфигурации);
	УдалитьФайлы(КаталогВыгрузкиКонфигурации);
	Сообщить(Результат);
	//Предупреждение("Не забудь вручную убрать флажок ""Проверять значения языка"" у расширения!");
	
КонецПроцедуры

Функция СоздатьРасширение(Знач СуффиксВерсии, Знач КаталогВыгрузкиКонфигурации)
	
	ВерсияРасширения = Метаданные.Версия + СуффиксВерсии;
	
	ИмяРасширения = "Расширение1";
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("cfe");
	ПолучитьОбщийМакет("ирШаблонРасширения").Записать(ИмяВременногоФайла);
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadCfg """ + ИмяВременногоФайла + """ -Extension """ + ИмяРасширения + """", , ТекстЛога,,, Истина, ИсполняемыйФайлПлатформы);
	Если Не Успех Тогда 
		УдалитьФайлы(ИмяВременногоФайла);
		Сообщить(ТекстЛога);
		Возврат Неопределено;
	КонецЕсли;
	УдалитьФайлы(ИмяВременногоФайла);
	
	ТекстЛога = "";
	КаталогВыгрузкиРасширения = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогВыгрузкиРасширения);
	// Выгрузка расширения в файлы
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigToFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -Format Hierarchical", , ТекстЛога,,
		"Выгрузка расширения в файлы",, ИсполняемыйФайлПлатформы);
	Если Не Успех Тогда 
		УдалитьФайлы(КаталогВыгрузкиРасширения);
		Сообщить(ТекстЛога);
		Возврат Неопределено;
	КонецЕсли;
	
	//Предупреждение(1);
	RegExp = ирКэш.ВычислительРегВыраженийЛкс();
	RegExp.Global = Истина;
	
	// Скопируем все папки кроме Catalogs и Ext и файла ConfigDumpInfo.xml
	Файлы = НайтиФайлы(КаталогВыгрузкиКонфигурации, "*");
	Для Каждого Файл Из Файлы Цикл
		Если Ложь
			Или Файл.Имя = "Catalogs"
			Или Файл.Имя = "Ext"
			Или Не Файл.ЭтоКаталог()
		Тогда
			Продолжить;
		КонецЕсли; 
		ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + Файл.Имя); 
		Если Не ФайлПриемник.Существует() Тогда
			СоздатьКаталог(ФайлПриемник.ПолноеИмя);
		КонецЕсли; 
		ирОбщий.СкопироватьФайлыЛкс(КаталогВыгрузкиКонфигурации + "\" + Файл.Имя, КаталогВыгрузкиРасширения + "\" + Файл.Имя);
	КонецЦикла;
	
	// Во всех CommonCommands удалить <CommandParameterType>...</CommandParameterType>
	Файлы = НайтиФайлы(КаталогВыгрузкиРасширения + "\CommonCommands", "*.xml");
	Для Каждого Файл Из Файлы Цикл
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
		ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
		ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<CommandParameterType>", "</CommandParameterType>", Ложь, Истина);
		ТекстФайла = СтрЗаменить(ТекстФайла, ЧтоЗаменить, "");
		ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
		ТекстовыйДокумент.Записать(Файл.ПолноеИмя);
	КонецЦикла;
	
	// Очищаем ссылки в подсистемах
	Файлы = НайтиФайлы(КаталогВыгрузкиРасширения + "\SubSystems", "*.xml", Истина);
	Для Каждого Файл Из Файлы Цикл
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
		ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
		//ТекстФайла = ирОбщий.СтрЗаменитьЛкс(ТекстФайла, "<xr:Item xsi:type=""xr:MDObjectRef"">CommonCommand.ирОткрытьНастройкиАлгоритмов</xr:Item>", "");
		Пока Истина Цикл
			ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<xr:Item xsi:type=""xr:MDObjectRef"">Catalog.", "</xr:Item>", Ложь, Истина);
			Если Не ЗначениеЗаполнено(ЧтоЗаменить) Тогда
				Прервать;
			КонецЕсли; 
			ТекстФайла = СтрЗаменить(ТекстФайла, ЧтоЗаменить, "");
		КонецЦикла; 
		Пока Истина Цикл
			ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<Command name=""Catalog.", "</Command>", Ложь, Истина);
			Если Не ЗначениеЗаполнено(ЧтоЗаменить) Тогда
				Прервать;
			КонецЕсли; 
			ТекстФайла = СтрЗаменить(ТекстФайла, ЧтоЗаменить, "");
		КонецЦикла; 
		ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
		ТекстовыйДокумент.Записать(Файл.ПолноеИмя);
	КонецЦикла;
	
	// Очищаем ссылки в ролях
	Файлы = НайтиФайлы(КаталогВыгрузкиРасширения + "\Roles", "*.xml", Истина);
	Для Каждого Файл Из Файлы Цикл
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
		ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
		Пока Истина Цикл
			ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, 
			"	<object>
			|		<name>Catalog.", "</object>", Ложь, Истина);
			Если Не ЗначениеЗаполнено(ЧтоЗаменить) Тогда
				Прервать;
			КонецЕсли; 
			ТекстФайла = СтрЗаменить(ТекстФайла, ЧтоЗаменить, "");
		КонецЦикла; 
		ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
		ТекстовыйДокумент.Записать(Файл.ПолноеИмя);
	КонецЦикла;
	
	// У общего модуля ирГлобальный убираем флажок Сервер, т.к. в расширении такие общие модули недопустимы
	ИмяФайла = КаталогВыгрузкиРасширения + "\CommonModules\ирГлобальный.xml";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	ТекстФайла = ирОбщий.СтрЗаменитьЛкс(ТекстФайла, "<Server>true</Server>", "<Server>false</Server>");
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ИмяФайла);
	
	//// Скопируем глобальные методы в общий модуль ирОтладка
	//ИмяФайла = КаталогВыгрузкиРасширения + "\CommonModules\ирГлобальный\Ext\Module.bsl";
	//ТекстовыйДокумент = Новый ТекстовыйДокумент;
	//ТекстовыйДокумент.Прочитать(ИмяФайла);
	//ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	//ТекстМетодов = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "#Область ГлобальныеПортативныеМетоды", "#КонецОбласти", Ложь, Истина);
	//ИмяФайла = КаталогВыгрузкиРасширения + "\CommonModules\ирОтладка\Ext\Module.bsl";
	//ТекстовыйДокумент = Новый ТекстовыйДокумент;
	//ТекстовыйДокумент.Прочитать(ИмяФайла);
	//ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	//ТекстФайла = ТекстФайла + ТекстМетодов;
	//ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	//ТекстовыйДокумент.Записать(ИмяФайла);
	
	// У общего модуля ирПривилегированный убираем флажок Привилегированный
	ИмяФайла = КаталогВыгрузкиРасширения + "\CommonModules\ирПривилегированный.xml";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	ТекстФайла = ирОбщий.СтрЗаменитьЛкс(ТекстФайла, "<Privileged>true</Privileged>", "<Privileged>false</Privileged>");
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ИмяФайла);
	
	// У подсистемы ИнструментыРазработчикаTormozit обновим версию
	ИмяФайла = КаталогВыгрузкиРасширения + "\SubSystems\ИнструментыРазработчикаTormozit.xml";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	RegExp.Pattern = "(<Comment)>(\S)+?(</Comment>)";
	ТекстФайла = RegExp.Replace(ТекстФайла, "$1>" + ВерсияРасширения + "$3"); // После номера группы обязательно делать не цифру
	RegExp.Pattern = "(<v8:content>Инструменты разработчика\s*) (\S)+?(\s*</v8:content>)";
	ТекстФайла = RegExp.Replace(ТекстФайла, "$1 " + ВерсияРасширения + "$3"); // После номера группы обязательно делать не цифру. Замена делается для каждого языка
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ИмяФайла);
	
	ИмяФайла = КаталогВыгрузкиРасширения + "\CommonModules\ирИнтерфейсДляВстраивания\Ext\Module.bsl";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	ТекстФайла = ирОбщий.СтрЗаменитьЛкс(ТекстФайла, "// Версия модуля X.XX", "// Версия модуля " + Метаданные.Версия);
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ИмяФайла);

	ИмяФайла = КаталогВыгрузкиРасширения + "\Languages\Русский.xml";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	ТекстФайла = ирОбщий.СтрЗаменитьЛкс(ТекстФайла, "<Name>Русский</Name>", "<Name>Русский</Name><ObjectBelonging>Adopted</ObjectBelonging>");
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ИмяФайла);
	
	// Заменим элемент <ChildObjects> в файле Configuration.xml
	ФайлКонфигурацииИсточника = КаталогВыгрузкиКонфигурации + "\Configuration.xml";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ФайлКонфигурацииИсточника);
	ТекстФайлаИсточника = ТекстовыйДокумент.ПолучитьТекст();
	ФайлКонфигурацииПриемника = КаталогВыгрузкиРасширения + "\Configuration.xml";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ФайлКонфигурацииПриемника);
	ТекстФайлаПриемника = ТекстовыйДокумент.ПолучитьТекст();
	ЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайлаПриемника, "<ChildObjects>", "</ChildObjects>", Ложь, Истина);
	НаЧтоЗаменить = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайлаИсточника, "<ChildObjects>", "</ChildObjects>", Ложь, Истина);
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, ЧтоЗаменить, НаЧтоЗаменить);
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, "<Version>4.00</Version>", "<Version>" + ВерсияРасширения + "</Version>");
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, "<Language>Английский</Language>", "");
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, "<Interface>ирРазработчик</Interface>", "");
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, "<Style>ирОсновной</Style>", "");
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, "<Catalog>ирАлгоритмы</Catalog>", "");
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, "<Catalog>ирКомандаРедактироватьОбъект</Catalog>", "");
	ТекстФайлаПриемника = ирОбщий.СтрЗаменитьЛкс(ТекстФайлаПриемника, "<Catalog>ирОбъектыДляОтладки</Catalog>", "");
	ТекстовыйДокумент.УстановитьТекст(ТекстФайлаПриемника);
	ТекстовыйДокумент.Записать(ФайлКонфигурацииПриемника);
	
	// Загрузка расширения из файлов
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadConfigFromFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -Format Hierarchical", , ТекстЛога,,
		"Загрузка расширения из файлов",, ИсполняемыйФайлПлатформы);
	УдалитьФайлы(КаталогВыгрузкиРасширения); // Закомментировано для отладки
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат Неопределено;
	КонецЕсли;
	
	//// Выгружаем расширение в файлы
	//Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigToFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -Format Hierarchical", , ТекстЛога);
	//Если Не Успех Тогда 
	//	УдалитьФайлы(КаталогВыгрузкиРасширения);
	//	Сообщить(ТекстЛога);
	//	Возврат;
	//КонецЕсли;
	//ФайлКонфигурацииИсточника = КаталогВыгрузкиРасширения + "\Configuration.xml";
	//ТекстовыйДокумент = Новый ТекстовыйДокумент;
	//ТекстовыйДокумент.Прочитать(ФайлКонфигурацииИсточника);
	//ТекстФайлаИсточника = ТекстовыйДокумент.ПолучитьТекст();
	//Предупреждение(1);
	//ТекстФайлаИсточника = СтрЗаменить(ТекстФайлаИсточника, "<DefaultLanguage>Language.ирРусский</DefaultLanguage>", ""); // На первом проходе в 8.3.10 невозможно сделать
	//ТекстовыйДокумент.УстановитьТекст(ТекстФайлаИсточника);
	//ТекстовыйДокумент.Записать(ФайлКонфигурацииИсточника);
	//
	//// Загружаем расширение из файлов
	//Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadConfigFromFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -Format Hierarchical", , ТекстЛога);
	//Если Не Успех Тогда 
	//	УдалитьФайлы(КаталогВыгрузкиРасширения);
	//	Сообщить(ТекстЛога);
	//	Возврат;
	//КонецЕсли;
	
	// Выгружаем расширение 
	КонечныйФайл = Каталог + "\ИР " + ВерсияРасширения + ".cfe";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpCfg """ + КонечныйФайл + """ -Extension """ + ИмяРасширения + """", , ТекстЛога,,,, ИсполняемыйФайлПлатформы);
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат Неопределено;
	КонецЕсли;

	Если ирКэш.НомерВерсииПлатформыЛкс() < 803013 Тогда
		// https://partners.v8.1c.ru/forum/t/1713417/m/1713417
		Сообщить("Выполните изменение свойства ""Режим совместимости"" расширения, оставив его выключенным");
		ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("",,,,,,, Ложь);
	КонецЕсли;
	Возврат КонечныйФайл;

КонецФункции

Процедура КаталогНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ВыбратьКаталогВФормеЛкс(Каталог);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.СохранитьЗначениеЛкс("ирВыпускВариантаРасширение.Каталог", Каталог);
	ирОбщий.СохранитьЗначениеЛкс("ирВыпускВариантаРасширение.ИсполняемыйФайлПлатформы", ИсполняемыйФайлПлатформы);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.Каталог = ирОбщий.ВосстановитьЗначениеЛкс("ирВыпускВариантаРасширение.Каталог");
	ЭтаФорма.ИсполняемыйФайлПлатформы = ирОбщий.ВосстановитьЗначениеЛкс("ирВыпускВариантаРасширение.ИсполняемыйФайлПлатформы");
	ирОбщий.ЗаполнитьСписокАдминистраторовБазыЛкс(ЭлементыФормы.ИмяПользователя.СписокВыбора);
	ЭтаФорма.ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ирКэш.НомерВерсииПлатформыЛкс() < 803010 Тогда
		Сообщить("Поддерживается только платформа 8.3.10 и выше");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИсполняемыйФайлПлатформыНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	РезультатВыбора = ирОбщий.ВыбратьФайлЛкс(, "exe",, Элемент.Значение);
	Если ЗначениеЗаполнено(РезультатВыбора) Тогда
		Элемент.Значение = РезультатВыбора;
	КонецЕсли;  
	
КонецПроцедуры
