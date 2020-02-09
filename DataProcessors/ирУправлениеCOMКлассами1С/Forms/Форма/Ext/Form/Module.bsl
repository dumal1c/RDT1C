﻿Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельКлассыОбновить(Кнопка)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ДействияФормыПрименить(Кнопка)
	
	Если ВыполнитьРегистрацию() Тогда 
		ОбновитьДанные(Ложь);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КомпьютерПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КомпьютерНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОбновитьДанные(ЗапроситьПодтверждение = Истина)
	
	Если ЗапроситьПодтверждение И Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	Если ЭлементыФормы.Классы.ТекущаяСтрока <> Неопределено Тогда
		ТекущееИмяКласса = ЭлементыФормы.Классы.ТекущаяСтрока.ИмяКласса;
	КонецЕсли; 
	ОбновитьТаблицуКлассов();
	Если ТекущееИмяКласса <> Неопределено Тогда
		СтрокаКласса = Классы.Найти(ТекущееИмяКласса, "ИмяКласса");
		Если СтрокаКласса <> Неопределено Тогда
			ЭлементыФормы.Классы.ТекущаяСтрока = СтрокаКласса;
		КонецЕсли; 
	КонецЕсли; 
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры

Функция ЗапроситьПодтверждение()
	
	Результат = Истина;
	Если Модифицированность Тогда
		Ответ = Вопрос("Вы не применили изменения. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Результат = Ответ = КодВозвратаДиалога.ОК;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Процедура ПриОткрытии()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтотОбъект.ТекущаяСборкаПлатформы = СистемнаяИнформация.ВерсияПриложения;
	ЭтотОбъект.ПользовательОС = ирКэш.ТекущийПользовательОСЛкс();
	ЭтотОбъект.x64Текущая = ирКэш.Это64битныйПроцессЛкс();
	ЭтаФорма.ОтАдминистратора = ирКэш.ВКОбщая().IsAdmin();
	ЗаполнитьТипыCOMКлассов();
	КоманднаяПанельСборкиПлатформыОбновить();
	ОбновитьТаблицуКлассов();
	
КонецПроцедуры

Процедура КлассыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ИзданиеПлатформы = ЭлементыФормы.Классы.ТекущиеДанные.ИзданиеПлатформы;
	Разрядность = ЭлементыФормы.Классы.ТекущиеДанные.x64;
	ИмяКласса = ЭлементыФормы.Классы.ТекущиеДанные.ТипКласса;
	Внутрипроцессный = ЭлементыФормы.Классы.ТекущиеДанные.Внутрипроцессный;
	СписокСборок = Новый СписокЗначений();
	Попытка
		СборкиПлатформы.НайтиСтроки(Новый Структура(ИмяКласса));
		ПолнаяПоддержкаКласса = Истина;
	Исключение
		ПолнаяПоддержкаКласса = Ложь;
	КонецПопытки;
	Если ПолнаяПоддержкаКласса Тогда
		ОтборСтрок = Новый Структура("ИзданиеПлатформы, " + ИмяКласса, ИзданиеПлатформы, Истина);
		ОтборСтрок.Вставить("x64", Разрядность);
		СтрокиСборок = СборкиПлатформы.НайтиСтроки(ОтборСтрок);
		Для Каждого СтрокаСборки Из СтрокиСборок Цикл
			СписокСборок.Добавить(ПредставлениеСборкиПлатформы(СтрокаСборки, Внутрипроцессный));
		КонецЦикла;
	КонецЕсли; 
	ЭлементыФормы.Классы.Колонки.НовыйСборкаПлатформы.ЭлементУправления.СписокВыбора = СписокСборок;

КонецПроцедуры

Процедура КлассыНовыйСборкаПлатформыПриИзменении(Элемент)
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура КлассыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Сборка.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.Файл.Видимость = Ложь;
	
КонецПроцедуры

Процедура ДействияФормыФайлВключенияОтладки(Кнопка)
	
	#Если Не ТонкийКлиент И Не ВебКлиент Тогда
		Каталог = ирОбщий.КаталогНастроекПриложения1СЛкс();
	#Иначе
		Каталог = "";
	#КонецЕсли 
	ИмяФайла = ирОбщий.ВыбратьФайлЛкс(Ложь, "xml",,, Каталог, "comcntrcfg.xml");
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		Возврат;
	КонецЕсли; 
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ТекстовыйДокумент = ирОбщий.ТекстКонфигурационногоФайлаВнешнихСоединенийЛкс();
	ТекстовыйДокумент.Записать(ИмяВременногоФайла, КодировкаТекста.ANSI);
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	мПлатформа.ПереместитьФайлКакАдминистратор(ИмяВременногоФайла, ИмяФайла);
	
КонецПроцедуры

Процедура КоманднаяПанельСборкиПлатформыЗапуститьТолстый(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.СборкиПлатформы.ТекущаяСтрока;
	#Если Сервер И Не Сервер Тогда
	    ТекущаяСтрока = СборкиПлатформы.Добавить();
	#КонецЕсли
	Если ТекущаяСтрока = Неопределено Или Не ТекущаяСтрока.Application Тогда
		Возврат;
	КонецЕсли; 
	ЗапуститьПриложение(ТекущаяСтрока.Каталог + "bin\1cv8.exe");
	
КонецПроцедуры

Процедура КоманднаяПанельСборкиПлатформыЗапуститьТонкий(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.СборкиПлатформы.ТекущаяСтрока;
	#Если Сервер И Не Сервер Тогда
	    ТекущаяСтрока = СборкиПлатформы.Добавить();
	#КонецЕсли
	Если ТекущаяСтрока = Неопределено Или Не ТекущаяСтрока.CApplication Тогда
		Возврат;
	КонецЕсли; 
	ЗапуститьПриложение(ТекущаяСтрока.Каталог + "bin\1cv8c.exe");

КонецПроцедуры

Процедура КоманднаяПанельКлассыЗапуститьОтАдминистратора(Кнопка)
	
	ирОбщий.ЗапуститьСеансПодПользователемЛкс(ИмяПользователя(),,, "ОбычноеПриложение",,,,,,,, Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельСборкиПлатформыОбновить(Кнопка = Неопределено)
	
	ирОбщий.ЗаполнитьДоступныеСборкиПлатформыЛкс(СборкиПлатформы, Компьютер, ТипыComКлассов);
	
КонецПроцедуры

Процедура КоманднаяПанельКлассыПроверитьСозданиеОбъектов(Кнопка)
	
	СтрокиКлассов = Классы.НайтиСтроки(Новый Структура("X64, Зарегистрирован", x64Текущая, Истина));
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СтрокиКлассов.Количество());
	Для Каждого СтрокаКласса Из СтрокиКлассов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Попытка
			Пустышка = Новый COMОбъект(СтрокаКласса.ИмяКласса);
			СтрокаКласса.РезультатПроверки = "ОК";
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			СтрокаКласса.РезультатПроверки = Сред(ОписаниеОшибки, Найти(ОписаниеОшибки, "}:") + 2);
		КонецПопытки; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
КонецПроцедуры

Процедура СборкиПлатформыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ирОбщий.ЭтоИмяЛокальногоСервераЛкс(Компьютер) И ВыбраннаяСтрока.ФайлыСуществуют Тогда
		ЗапуститьПриложение(ВыбраннаяСтрока.Каталог);
	КонецЕсли; 

КонецПроцедуры

Процедура КлассыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = Элемент.Колонки.ИмяФайла Тогда
		ирОбщий.ОткрытьФайлВПроводникеЛкс(ВыбраннаяСтрока.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеCOMКлассами1С.Форма.Форма");
