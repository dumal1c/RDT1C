﻿Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ДействияФормыПрименить(Кнопка)
	
	Если ВыполнитьРегистрацию() Тогда 
		ОбновитьДанные(Ложь);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КомпьютерПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КомпьютерНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ОбновитьДанные(ЗапроситьПодтверждение = Истина)
	
	Если ЗапроситьПодтверждение И Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	ОбновитьТаблицуКлассов();
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
	ирОбщий.ЗаполнитьДоступныеСборкиПлатформыЛкс(СборкиПлатформы, Компьютер, ТипыComКлассов);
	ОбновитьТаблицуКлассов();
	
КонецПроцедуры

Процедура КлассыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ИзданиеПлатформы = ЭлементыФормы.Классы.ТекущиеДанные.ИзданиеПлатформы;
	Разрядность = ЭлементыФормы.Классы.ТекущиеДанные.x64;
	ИмяКласса = ЭлементыФормы.Классы.ТекущиеДанные.ТипКласса;
	СписокСборок = Новый СписокЗначений();
	Попытка
		СборкиПлатформы.НайтиСтроки(Новый Структура(ИмяКласса));
		ПолнаяПоддержкаКласса = Истина;
	Исключение
		ПолнаяПоддержкаКласса = Ложь;
	КонецПопытки;
	Если ПолнаяПоддержкаКласса Тогда
		ОтборСтрок = Новый Структура("ИзданиеПлатформы, x64, " + ИмяКласса, ИзданиеПлатформы, Разрядность, Истина);
		СтрокиСборок = СборкиПлатформы.НайтиСтроки(ОтборСтрок);
		Для Каждого СтрокаСборки Из СтрокиСборок Цикл
			СписокСборок.Добавить(СтрокаСборки.СборкаПлатформы);
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
		Каталог = ирОбщий.ПолучитьКаталогНастроекПриложения1СЛкс();
	#Иначе
		Каталог = "";
	#КонецЕсли 
	ИмяФайла = ирОбщий.ВыбратьФайлЛкс(Ложь, "xml",,, Каталог, "comcntrcfg.xml");
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		Возврат;
	КонецЕсли; 
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ТекстовыйДокумент = ирОбщий.ПолучитьТекстКонфигурационногоФайлаВнешнихСоединенийЛкс();
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

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеCOMКлассами1С.Форма.Форма");
