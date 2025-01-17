﻿
Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ФайлШаблоновТекста", ФайлШаблоновТекста);
	мПлатформа.ПолучитьТаблицуШаблоновТекста(ИмяКласса,, Истина);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ЛиОткрыватьПустойСписок", ЛиОткрыватьПустойСписок);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ЛиАктивизироватьОкноСправкиПриЕгоОткрытии", ЛиАктивизироватьОкноСправкиПриЕгоОткрытии);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ПредпочитаюСобственныйКонструкторЗапроса", ПредпочитаюСобственныйКонструкторЗапроса);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".АвтоматическаяПодсказкаПоВызовуМетода", АвтоматическаяПодсказкаПоВызовуМетода);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".ПоказыватьВсеТипыВСпискеАвтодополненияHTML", ПоказыватьВсеТипыВСпискеАвтодополненияHTML);
	ирОбщий.СохранитьЗначениеЛкс(ИмяКласса + ".АвтоматическаяПодсказкаАвтодополненияHTML", АвтоматическаяПодсказкаАвтодополненияHTML);
	ОбработкаОбъект.АвтоматическаяПодсказкаПоВызовуМетода = АвтоматическаяПодсказкаПоВызовуМетода;
	ОбработкаОбъект.ПоказыватьВсеТипыВСпискеАвтодополненияHTML = ПоказыватьВсеТипыВСпискеАвтодополненияHTML;
	ОбработкаОбъект.АвтоматическаяПодсказкаАвтодополненияHTML = АвтоматическаяПодсказкаАвтодополненияHTML;
	Если ЭтаФорма.КаталогКэша = мПлатформа.СтруктураПодкаталоговФайловогоКэша.КэшМодулей.ПолноеИмя Тогда
		ирОбщий.СохранитьЗначениеЛкс("ПапкаКэшаМодулей", Неопределено,, Истина);
	Иначе
		ирОбщий.СохранитьЗначениеЛкс("ПапкаКэшаМодулей", КаталогКэша,, Истина);
	КонецЕсли; 
	мПлатформа.ПапкаКэшаМодулей = Новый Файл(КаталогКэша);
	ЭтаФорма.Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ФайлШаблоновТекста = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ФайлШаблоновТекста");
	ЛиОткрыватьПустойСписок = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ЛиОткрыватьПустойСписок");
	ЛиАктивизироватьОкноСправкиПриЕгоОткрытии = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ЛиАктивизироватьОкноСправкиПриЕгоОткрытии");
	ПредпочитаюСобственныйКонструкторЗапроса = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ПредпочитаюСобственныйКонструкторЗапроса");
	ПоказыватьВсеТипыВСпискеАвтодополненияHTML = ПоказыватьВсеТипыВСпискеАвтодополненияHTML(Истина);
	АвтоматическаяПодсказкаПоВызовуМетода = АвтоматическаяПодсказкаПоВызовуМетода(Истина);
	АвтоматическаяПодсказкаАвтодополненияHTML = АвтоматическаяПодсказкаАвтодополненияHTML(Истина);
	ЭтаФорма.КаталогКэша = мПлатформа.ПапкаКэшаМодулей.ПолноеИмя;
	ОбновитьИнфоПапкиКэша();

КонецПроцедуры

Процедура ФайлШаблоновНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	лПолноеИмяФайла = ирКлиент.ВыбратьФайлЛкс(, "st", "Файл шаблонов текста 1С", Элемент.Значение);
	Если лПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(Элемент, лПолноеИмяФайла);
	
КонецПроцедуры

Процедура ФайлШаблоновТекстаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТаблицаШаблоновТекста = ирКэш.Получить().ПолучитьТаблицуШаблоновТекста(ИмяКласса);
	ТаблицаШаблоновТекста.Сортировать("Шаблон");
	ирОбщий.ИсследоватьЛкс(ТаблицаШаблоновТекста, Ложь, Истина);
	
КонецПроцедуры

Процедура КоманднаяПанель1ОбновитьКэшМодулей(Кнопка)
	
	Ответ = Вопрос("Обновление кэша модулей использует конфигуратор текущей базы и может занять до нескольких минут. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	УдалитьФайлы(КаталогКэша, "*");
	ТекстЛога = "";
	Если ирКэш.НомерРежимаСовместимостиЛкс() >= 803010 Тогда
		РасширенияКонфигурацииМои = Вычислить("РасширенияКонфигурации");
		#Если Сервер И Не Сервер Тогда
			РасширенияКонфигурацииМои = РасширенияКонфигурации;
		#КонецЕсли
		Для Каждого РасширениеКонфигурации Из РасширенияКонфигурацииМои.Получить() Цикл
			#Если Сервер И Не Сервер Тогда
				РасширениеКонфигурации = РасширенияКонфигурации.Создать();
			#КонецЕсли
			Если ирКэш.НомерРежимаСовместимостиЛкс() >= 803012 Тогда
				Если Не РасширениеКонфигурации.Активно Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigFiles """ + КаталогКэша + """ -Extension """ + РасширениеКонфигурации.Имя + """ -Module", СтрокаСоединенияИнформационнойБазы(),
				ТекстЛога, Истина, "Выгрузка модулей расширения " + РасширениеКонфигурации.Имя);
			Если Не Успех Тогда 
				Сообщить(ТекстЛога);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigFiles """ + КаталогКэша + """ -Module", СтрокаСоединенияИнформационнойБазы(), ТекстЛога, Истина, "Выгрузка модулей конфигурации");
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	мПлатформа.МодулиМетаданных = Неопределено;
	ОбновитьИнфоПапкиКэша();
	
КонецПроцедуры

Процедура КоманднаяПанель1ОчиститьСтатистику(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Ответ = Вопрос("Очистить статистику выбора (" + мПлатформа.ТаблицаСтатистикиВыбора.Количество() + " слов). Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	мПлатформа.ТаблицаСтатистикиВыбора.Очистить();
	СохранитьСтатистикуВыбораПодсказки();
	Сообщить("Статистика выбора очищена");
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка)
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

// Каталог кэша

Процедура ОбновитьИнфоПапкиКэша()
	
	МаскаПоискаФайлаДатыИзменения = "*МодульОбъекта*.txt";
	ПапкаКэша = Новый Файл(ЭтаФорма.КаталогКэша);
	ЭтаФорма.ДатаОбновленияКэша = Неопределено;
	ЭтаФорма.РазмерКэша = Неопределено;
	Если ПапкаКэша.Существует() Тогда
		ФайлыКэша = НайтиФайлы(КаталогКэша, МаскаПоискаФайлаДатыИзменения);
		Если ФайлыКэша.Количество() > 0 Тогда
			ЭтаФорма.ДатаОбновленияКэша = ФайлыКэша[0].ПолучитьВремяИзменения();
		КонецЕсли; 
		ЭтаФорма.РазмерКэша = Неопределено;
		ПодключитьОбработчикОжидания("ВычислитьРазмерПапкиКэша", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

Процедура ВычислитьРазмерПапкиКэша()
	
	ЭтаФорма.РазмерКэша = ирОбщий.ВычислитьРазмерКаталогаЛкс(КаталогКэша) /1000/1000;

КонецПроцедуры

Процедура КаталогКэшаПриИзменении(Элемент)
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Файл = Новый Файл(КаталогКэша);
	Если Файл.Существует() Тогда
		ЭтаФорма.КаталогКэша = Файл.ПолноеИмя;
		ОбновитьИнфоПапкиКэша();
	Иначе
		КаталогКэшаОчистка();
	КонецЕсли; 
	мПлатформа.МодулиМетаданных = Неопределено;
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма,,, ИмяКомпьютера());
КонецПроцедуры

Процедура КаталогКэшаОчистка(Элемент = Неопределено, СтандартнаяОбработка = Истина)
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	СтандартнаяОбработка = Ложь;
	ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(Элемент, мПлатформа.СтруктураПодкаталоговФайловогоКэша.КэшМодулей.ПолноеИмя);
КонецПроцедуры

Процедура КаталогКэшаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма, ИмяКомпьютера());
КонецПроцедуры

Процедура КаталогКэшаНачалоВыбора(Элемент, СтандартнаяОбработка)
	НоваяПапка = ирКлиент.ВыбратьКаталогВФормеЛкс(Элемент.Значение,, "Выберите папку кэша");
	Если НоваяПапка <> Неопределено Тогда
		ирКлиент.ИнтерактивноЗаписатьВПолеВводаЛкс(Элемент, НоваяПапка);
	КонецЕсли;
КонецПроцедуры

Процедура КаталогКэшаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(КаталогКэша);
	
КонецПроцедуры

Процедура ФайлШаблоновТекстаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма, ИмяКомпьютера());
КонецПроцедуры

Процедура ФайлШаблоновТекстаПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма,,, ИмяКомпьютера());
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Ответ = ирКлиент.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОсновныеДействияФормыОК();
	КонецЕсли; 
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ФормаНастройки");
