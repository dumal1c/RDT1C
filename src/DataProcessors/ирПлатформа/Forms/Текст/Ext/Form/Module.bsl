﻿// +++.КЛАСС.ПолеТекстаПрограммы
// Это коллекция экземпляров компоненты. Обязательный блок.
Перем ПолеТекстаПрограммы;
// ---.КЛАСС.ПолеТекстаПрограммы

Перем мТекущаяСтраницаТекста;
Перем мРедакторJSON;
Перем мПолеТекстаПоиска;
 
Процедура ЗакрытьССохранением()
	
	Если ПараметрРежимВыбораМассива Тогда
		Закрыть();
	КонецЕсли;
	Если Не ЭтаФорма.МодальныйРежим И ЭтаФорма.ВладелецФормы = Неопределено Тогда 
		Если Не ЭтаФорма.Модифицированность Или ОсновныеДействияФормыСохранитьВФайл() Тогда 
			Закрыть();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Текст = ПолучитьТекст(); 
	ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Текст);

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ЗакрытьССохранением();
	
КонецПроцедуры

Процедура ПриОткрытии()

	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаПрограммы = Новый Структура;
	Обработка1 = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
	    Обработка1 = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	Обработка1.Инициализировать(ПолеТекстаПрограммы, ЭтаФорма, ЭлементыФормы.ВстроенныйЯзык, ЭлементыФормы.КоманднаяПанельВстроенныйЯзык, Ложь, "ВыполнитьЛокально", ЭтаФорма,,, Истина);
	Обработка2 = ирОбщий.СоздатьОбъектПоИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
	    Обработка2 = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	Обработка2.Инициализировать(ПолеТекстаПрограммы, ЭтаФорма, ЭлементыФормы.ЯзыкЗапросов, ЭлементыФормы.КоманднаяПанельЯзыкЗапросов, Истина,,,,, Истина);
	// ---.КЛАСС.ПолеТекстаПрограммы
	
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
	мТекущаяСтраницаТекста = ЭлементыФормы.ПанельОсновная.Страницы.Обычный;
	ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Обычный;   
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ПодменюJSON.Кнопки.ФорматироватьJSON.Доступность = ирКэш.ДоступенJSONЛкс();

	мПолеТекстаПоиска = ирКлиент.ОболочкаПоляТекстаЛкс(ЭлементыФормы.РезультатыПоиска);
	ЭлементыФормы.ПанельОсновная.Страницы.JSON.Доступность = ирКэш.НомерВерсииПлатформыЛкс() >= 803014;
	ЭлементыФормы.ПанельОсновная.Страницы.XML.Доступность = ирКэш.ДоступенРедакторМонакоЛкс();
	УстановитьТекст(НачальноеЗначениеВыбора);
	Если Не ЗначениеЗаполнено(ВариантПросмотра) Тогда
		Если Истина
			И СтрДлина(НачальноеЗначениеВыбора) < 1000000 // чтобы не заставлять пользователя ждать
			И ирОбщий.ЛиТекстJSONЛкс(НачальноеЗначениеВыбора) 
		Тогда
			ВариантПросмотра = "JSON";
		ИначеЕсли ирОбщий.ЛиТекстXMLЛкс(НачальноеЗначениеВыбора) Тогда
			ВариантПросмотра = "XML";
		ИначеЕсли ирОбщий.ЛиТекстHTMLЛкс(НачальноеЗначениеВыбора) Тогда
			ВариантПросмотра = "HTML";
		ИначеЕсли ирОбщий.ЛиТекстЗапросаЛкс(НачальноеЗначениеВыбора) Тогда
			ВариантПросмотра = "ЯзыкЗапросов";
		Иначе
			Если Ложь
				Или ЗначениеЗаполнено(ПараметрСтрокаПоиска) 
				Или ТолькоПросмотр И Найти(НачальноеЗначениеВыбора, "://") > 0
			Тогда
				ЭтаФорма.СтрокаПоиска = ПараметрСтрокаПоиска;
				ЭтаФорма.ПараметрСтрокаПоиска = "";
				ВариантПросмотра = "РезультатыПоиска";
			ИначеЕсли ЗначениеЗаполнено(НачальноеЗначениеВыбора) И СтрЧислоСтрок(НачальноеЗначениеВыбора) = 1 Тогда 
				ВариантПросмотра = "Компактный";
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
	Если ВариантПросмотра <> "" Тогда
		СтартоваяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Найти(ВариантПросмотра);
		Если СтартоваяСтраница = Неопределено Тогда
			ВызватьИсключение "Указан отсутствующий вариант просмотра - " + ВариантПросмотра;
		КонецЕсли;
		Если Не СтартоваяСтраница.Доступность Тогда
			Если СтартоваяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.XML Тогда
				СтартоваяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.HTML;
			Иначе
				СтартоваяСтраница = Неопределено;
			КонецЕсли; 
		КонецЕсли; 
		Если СтартоваяСтраница <> Неопределено Тогда
			ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = СтартоваяСтраница;
		КонецЕсли; 
	КонецЕсли;
	ЭлементыФормы.ТолькоПросмотр.Доступность = Не ТолькоПросмотр;
	ЭтаФорма.рТолькоПросмотр = ТолькоПросмотр;
	ирКлиент.ФормаОбъекта_ОбновитьЗаголовокЛкс(ЭтаФорма);
	ОбновитьДоступность();
	ЭтаФорма.ПараметрВыделитьВсе = Ложь; 
	//ПриОткрытииОтложенно();
	ПодключитьОбработчикОжидания("ПриОткрытииОтложенно", 0.1, Истина); // Почему то при сихнронном вызове выделение слова не происходит
	
КонецПроцедуры

Процедура ПриОткрытииОтложенно()
	
	Если ПараметрСтрокаПоиска <> "" Тогда 
		ПолеТекста = ПолеТекста();
		ирКлиент.НайтиПоказатьСтрокуВПолеТекстаЛкс(ЭтаФорма, ПолеТекста, ПараметрСтрокаПоиска, Ложь);
		ЭтаФорма.СтрокаПоиска = ПараметрСтрокаПоиска;
		ЭтаФорма.ПараметрСтрокаПоиска = "";
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьДоступность()
	
	Если ТолькоПросмотр Тогда
		НоваяСтрока = "" + СтрДлина(ПолучитьТекст()) + " символов";
	Иначе
		НоваяСтрока = "";
	КонецЕсли;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, НоваяСтрока);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		СтандартнаяОбработка = Ложь;
		Ответ = Вопрос("Строковый литерал был изменен. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			ЗакрытьССохранением();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекст() Экспорт

	ПолеТекста = ПолеТекста(Истина);
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Если ПолеТекста.ЭлементФормы = ЭлементыФормы.JSON Тогда
		Текст = мРедакторJSON.getText();
	Иначе
		Текст = ПолеТекста.ПолучитьТекст();
	КонецЕсли; 
	Возврат Текст;

КонецФункции

Функция ПолеТекста(Старое = Ложь)
	
	Если Старое Тогда
		ИмяСтраницы = мТекущаяСтраницаТекста.Имя;
	Иначе
		ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	КонецЕсли;
	ТекущееПоле = ЭлементыФормы[ИмяСтраницы];
	Если ТипЗнч(ТекущееПоле) = Тип("ТабличноеПоле") Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПолеТекста = ирКлиент.ОболочкаПоляТекстаЛкс(ТекущееПоле);
	Возврат ПолеТекста;

КонецФункции

Функция УстановитьТекст(Текст, Активировать = Ложь, НачальнаяСтрока = 0, НачальнаяКолонка = 0, КонечнаяСтрока = 0, КонечнаяКолонка = 0)

	ПолеТекста = ПолеТекста();
	Если ПолеТекста = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	ВыделитьВсе = ПараметрВыделитьВсе;
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Если ПолеТекста.ЭлементФормы = ЭлементыФормы.JSON Тогда
		Если мРедакторJSON = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли; 
		мРедакторJSON.setMode("code"); // https://github.com/josdejong/jsoneditor/issues/1210
		мРедакторJSON.setText(Текст);
		Если Активировать Тогда
			мРедакторJSON.focus();
		КонецЕсли;
		ДеревоJSONПриИзменении();
	Иначе
		//ВыделитьВсе = ТипЗнч(ПолеТекста.ЭлементФормы) = Тип("ПолеВвода");
		Если Не ПолеТекста.УстановитьТекст(Текст, Активировать) Тогда 
			Возврат Ложь;
		КонецЕсли; 
		Если Не ВыделитьВсе И НачальнаяСтрока <> 0 Тогда
			ПолеТекста.УстановитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
		КонецЕсли; 
	КонецЕсли; 
	Если ПараметрСтрокаПоиска <> "" Тогда 
		ирКлиент.НайтиПоказатьСтрокуВПолеТекстаЛкс(ЭтаФорма, ПолеТекста, ПараметрСтрокаПоиска, Ложь);
	ИначеЕсли ВыделитьВсе И СтрДлина(Текст) > 0 Тогда
		ПолеТекста.УстановитьГраницыВыделения(1, СтрДлина(Текст) + 1);
	КонецЕсли; 
	Возврат Истина;

КонецФункции

Процедура ПанельОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ПолеТекста = ПолеТекста(Истина);
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	П1=0; П2=0; П3=0; П4=0;
	Если СтрДлина(ПолеТекста.ВыделенныйТекст()) <> СтрДлина(Текст) Тогда
		ПолеТекста.ПолучитьГраницыВыделения(П1, П2, П3, П4);
	КонецЕсли; 
	Текст = ПолучитьТекст();
	Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Дерево Тогда
		Дерево.Строки.Очистить();
		Если ирОбщий.ЛиТекстJSONЛкс(Текст) Тогда
			ОбъектJSON = ирОбщий.ОбъектИзСтрокиJSONЛкс(Текст, Истина);
			ирОбщий.ДеревоЗначенийИзМассиваСтруктурЛкс(ОбъектJSON, Дерево);
		ИначеЕсли ирОбщий.ЛиТекстXMLЛкс(Текст) Тогда
			//ЭлементыФормы.ЗначениеДеревом.Колонки.Очистить();
			XMLДокумент = Новый ЧтениеXML;
			XMLДокумент.УстановитьСтроку(Текст);
			ЗагрузитьДеревоXML(XMLДокумент, Дерево.Строки);
			Если Дерево.Строки.Количество() > 0 Тогда
				ЭлементыФормы.Дерево.Развернуть(Дерево.Строки[0]);
			КонецЕсли;
		КонецЕсли;
		Возврат;
	ИначеЕсли ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.РезультатыПоиска Тогда
		ОбновитьПоиск(Истина, Истина);
		//ПолеТекста.УстановитьГраницыВыделения(П1, П2, П3, П4);
		Возврат;
	ИначеЕсли ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.JSON Тогда
		Если Не ирОбщий.СтрНачинаетсяСЛкс(ЭлементыФормы.JSON.Документ.URL, "file") Тогда // Иначе при повторном открытии будет 2 подряд события ДокументСформирован
			ЭлементыФормы.JSON.Перейти(БазовыйФайлРедактораJSON());
		КонецЕсли;
	ИначеЕсли ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.XML Тогда
		Если Не ирОбщий.СтрНачинаетсяСЛкс(ЭлементыФормы.XML.Документ.URL, "file") Тогда // Иначе при повторном открытии будет 2 подряд события ДокументСформирован
			ЭлементыФормы.XML.Перейти(мПлатформа.БазовыйФайлРедактораКода());
		КонецЕсли;
	КонецЕсли;
	Если УстановитьТекст(Текст, Истина, П1, П2, П3, П4) Тогда 
		мТекущаяСтраницаТекста = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница;
	КонецЕсли; 
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
Функция КлсПолеТекстаПрограммыОбновитьКонтекст(Знач Компонента = Неопределено, Знач Кнопка = Неопределено) Экспорт 
КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       - КнопкаКоманднойПанели.
//
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	// Имя страницы совпадает с именем поля текстового документа
	Компонента = 0;
	Если ПолеТекстаПрограммы.Свойство(ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя, Компонента) Тогда 
		#Если Сервер И Не Сервер Тогда
		    Компонента = Обработки.ирКлсПолеТекстаПрограммы.Создать();
		#КонецЕсли
		Компонента.Нажатие(Кнопка);
	КонецЕсли; 
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстаПрограммы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	// Имя страницы совпадает с именем поля текстового документа
	Компонента = 0;
	Если ПолеТекстаПрограммы.Свойство(ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя, Компонента) Тогда 
		#Если Сервер И Не Сервер Тогда
		    Компонента = Обработки.ирКлсПолеТекстаПрограммы.Создать();
		#КонецЕсли
		Компонента.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	Иначе
		ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСравнитьТекст(Кнопка)
	
	ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница;
	ВариантСинтаксиса = Неопределено;
	Если Ложь
		Или ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.ВстроенныйЯзык
		Или ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.ЯзыкЗапросов
		Или ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.XML
	Тогда
		ВариантСинтаксиса = ТекущаяСтраница.Имя;
	КонецЕсли; 
	ирКлиент.ЗапомнитьСодержимоеЭлементаФормыДляСравненияЛкс(ЭтаФорма, ЭлементыФормы[ТекущаяСтраница.Имя], ВариантСинтаксиса);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыДействие(Кнопка)
	
	ПолноеИмяФайла = ирКлиент.ВыбратьФайлЛкс(,,, ПолучитьТекст());
	Если ПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УстановитьТекст(ПолноеИмяФайла);
	
КонецПроцедуры

Функция ОсновныеДействияФормыСохранитьВФайл(Кнопка = Неопределено)
	
	Результат = Ложь;
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Если ВыборФайла.Выбрать() Тогда
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ПолучитьТекст());
		ТекстовыйДокумент.Записать(ВыборФайла.ПолноеИмяФайла);
		Результат = Истина;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Процедура ОсновныеДействияФормыЗагрузитьИзФайла(Кнопка)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	УстановитьТекст(ирОбщий.ПрочитатьТекстИзФайлаЛкс(ВыборФайла.ПолноеИмяФайла));

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирКлиент.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирКлиент.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ТолькоПросмотрПриИзменении(Элемент)
	
	ЭтаФорма.ТолькоПросмотр = рТолькоПросмотр;
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОткрытьЧерезXML(Кнопка)
	
	ОткрытьЧерезФайл("XML");
	
КонецПроцедуры

Процедура ОткрытьЧерезФайл(РасширениеФайла)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(РасширениеФайла);
	Текст = ПолучитьТекст();
	ТектовыйДокумент = Новый ТекстовыйДокумент;
	ТектовыйДокумент.УстановитьТекст(Текст);
	ТектовыйДокумент.Записать(ИмяВременногоФайла);
	ЗапуститьПриложение(ИмяВременногоФайла);

КонецПроцедуры

Процедура ОсновныеДействияФормыОткрытьЧерезJSON(Кнопка)
	
	ОткрытьЧерезФайл("JSON");
	
КонецПроцедуры

Процедура ЗагрузитьДеревоXML(ЧтениеXML, СтрокаДерева) 
	
	#Если Сервер И Не Сервер Тогда
		ЧтениеXML = Новый ЧтениеXML;
	#КонецЕсли
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.ИнструкцияОбработки Тогда
			НоваяСрокаДерева = СтрокаДерева.Добавить();
			НоваяСрокаДерева.ТипУзла = ЧтениеXML.ТипУзла;
			НоваяСрокаДерева.Свойство = ЧтениеXML.Имя;
			НоваяСрокаДерева.Значение = ЧтениеXML.Значение;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			НоваяСрокаДерева = СтрокаДерева.Добавить();
			НоваяСрокаДерева.ТипУзла = ЧтениеXML.ТипУзла;
			НоваяСрокаДерева.Свойство = ЧтениеXML.Имя;
			НоваяСрокаДерева.Значение = ЧтениеXML.Значение;
			Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
				НоваяСрокаДерева.Атрибуты.Добавить(ЧтениеXML.Имя, ЧтениеXML.Значение);
			КонецЦикла;
			ЗагрузитьДеревоXML(ЧтениеXML, НоваяСрокаДерева.Строки);
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Возврат; Прервать;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Ничего Тогда
			Возврат; Прервать;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			Если СтрокаДерева.Количество() = 0 И СтрокаДерева.Родитель <> Неопределено Тогда
				СтрокаДерева.Родитель.Значение = ЧтениеXML.Значение;
			Иначе
				НоваяСрокаДерева = СтрокаДерева.Добавить();
				НоваяСрокаДерева.ТипУзла = ЧтениеXML.ТипУзла;
				НоваяСрокаДерева.Свойство = ЧтениеXML.Имя;
				НоваяСрокаДерева.Значение = ЧтениеXML.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОткрытьЧерезTXT(Кнопка)
	
	ОткрытьЧерезФайл("TXT");

КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	Текст = ПолучитьТекст();
	ирКлиент.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма); // Там текст очистится
	ирКлиент.ОткрытьЗначениеЛкс(Текст,,, ирКлиент.ЗаголовокДляКопииОбъектаЛкс(ЭтаФорма), Ложь);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	ЭлементыФормы.JSON.УстановитьТекст(""); // Так отключаем платформенный вызов перезагрузки этого редактора при открытии закэшированной формы
	ЭлементыФормы.XML.УстановитьТекст(""); // Так отключаем платформенный вызов перезагрузки этого редактора при открытии закэшированной формы
	УстановитьТекст(""); // Освобождаем память для случая, когда форма в кэше. TODO очистить все страницы
	мРедакторJSON = Неопределено;
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	// Уничтожение всех экземпляров компоненты. Обязательный блок.
	Для Каждого КлючИЗначение Из ПолеТекстаПрограммы Цикл
		ОбъектКомпоненты = КлючИЗначение.Значение;
		#Если Сервер И Не Сервер Тогда
			ОбъектКомпоненты = Обработки.ирКлсПолеТекстаПрограммы.Создать();
		#КонецЕсли
		ОбъектКомпоненты.Уничтожить();
	КонецЦикла;
	// ---.КЛАСС.ПолеТекстаПрограммы

КонецПроцедуры

Процедура ОсновныеДействияФормыФорматироватьJSON(Кнопка)
	
	УстановитьТекст(ирОбщий.ФорматироватьТекстJsonЛкс(ПолучитьТекст()));

КонецПроцедуры

Процедура ОсновныеДействияФормыФорматироватьXML(Кнопка)
	
	НовыйТекст = ПолучитьТекст();
	Попытка
		НовыйТекст = ирОбщий.ФорматироватьТекстXMLЛкс(НовыйТекст);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Координаты = ирОбщий.СтрокаМеждуМаркерамиЛкс(СтрПолучитьСтроку(ОписаниеОшибки, 1), " - [", "]", Ложь);
		ФрагментыКоординат = ирОбщий.СтрРазделитьЛкс("" + Координаты, ",", Истина);
		Если ФрагментыКоординат.Количество() = 2 Тогда
			РедакторXML = РедакторXML();
			Если РедакторXML <> Неопределено Тогда
				ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.XML;
			КонецЕсли; 
			ПолеТекстаHTML = ПолеТекста();
			#Если Сервер И Не Сервер Тогда
				ПолеТекстаHTML = Обработки.ирОболочкаПолеТекста.Создать();
			#КонецЕсли
			ПолеТекстаHTML.ПоказатьОшибку(Число(ФрагментыКоординат[0]), Число(ФрагментыКоординат[1]), ЭтаФорма);
		КонецЕсли;
		ирОбщий.СообщитьЛкс(ОписаниеОшибки);
		Возврат;
	КонецПопытки; 
	УстановитьТекст(НовыйТекст);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура JSONДокументСформирован(Элемент)
	
	// Может быть двойная инициализация при открытии закэшированной формы закрытой на странице XML и потому сейчас может быть мРедакторJSON <> Неопределено
	Страница = ЭлементыФормы.ПанельОсновная.Страницы.JSON;
	Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница <> Страница Тогда
		Возврат;
	КонецЕсли;
	Текст = ПолучитьТекст();
	мРедакторJSON = Элемент.Документ.defaultView.Init();
	ирКлиент.РедакторJSON_ИнициироватьЛкс(мРедакторJSON);
	мРедакторJSON.aceEditor.setReadOnly(ТолькоПросмотр);
	УстановитьТекст(Текст, Истина);
	мТекущаяСтраницаТекста = Страница;

КонецПроцедуры

Процедура JSONonclick(Элемент, pEvtObj)
	
	Если Элемент.ИзменяетДанные И pEvtObj.srcElement.id = "onChange" Тогда
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ДеревоJSONПриИзменении(Элемент = Неопределено)

	ирКлиент.ПереключитьРежимДереваРедактораJSONЛкс(мРедакторJSON, РежимДереваJSON);
	
КонецПроцедуры

Процедура ОткрытьРазбивкуСтроки(ТипПриемника)
	
	ФормаРазбивки = ПолучитьФорму("РазбивкаТекста",, ТипПриемника);
	ФормаРазбивки.Приемник = Новый (ТипПриемника);
	ФормаРазбивки.Текст = ПолучитьТекст();
	ФормаРазбивки.ОткрытьПриемникПриЗакрытии = Истина;
	ФормаРазбивки.Открыть();

КонецПроцедуры

Процедура ОсновныеДействияФормыРазбитьВТаблицу(Кнопка)
	ОткрытьРазбивкуСтроки(Тип("ТаблицаЗначений"));
КонецПроцедуры

Процедура ОсновныеДействияФормыРазбитьВМассив(Кнопка)
	ОткрытьРазбивкуСтроки(Тип("Массив"));
КонецПроцедуры

Функция РедакторXML()
	Если Не ирКэш.ДоступенРедакторМонакоЛкс() Тогда 
		Возврат Неопределено;
	КонецЕсли; 
	ПолеТекста = ирКлиент.ОболочкаПоляТекстаЛкс(ЭлементыФормы.XML);
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Результат = ПолеТекста.РедакторHTML();
	Возврат Результат;
КонецФункции

Процедура XMLДокументСформирован(Элемент)
	
	Страница = ЭлементыФормы.ПанельОсновная.Страницы.XML;
	Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница <> Страница Тогда
		Возврат;
	КонецЕсли;
	Текст = ПолучитьТекст();
	ПолеТекстаHTML = ирКлиент.ОболочкаПоляТекстаЛкс(Элемент);
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаHTML = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ПолеТекстаHTML.Инициировать();
	РедакторHTML = ПолеТекстаHTML.РедакторHTML();
	РедакторHTML.init("1"); // Версия1С
	РедакторHTML.minimap(Ложь);
	РедакторHTML.setLanguageMode("xml");
	//РедакторHTML.enableModificationEvent(Истина);
	РедакторHTML.setOption("generateModificationEvent", Истина);
	УстановитьТекст(Текст, Истина);
	мТекущаяСтраницаТекста = Страница;
	
КонецПроцедуры

Функция ВводДоступенЛкс() Экспорт 
	Если ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.XML Тогда
		РедакторHTML = ЭлементыФормы.XML.Документ.defaultView;
		Результат = РедакторHTML.hasTextFocus();
	Иначе
		Результат = ВводДоступен();
	КонецЕсли; 
	Возврат Результат;
КонецФункции

Процедура XMLonclick(Элемент, ДанныеСобытия)
	
	Событие = ДанныеСобытия.eventData1C;
	Если Событие <> Неопределено Тогда
		ПолеТекстаHTML = ирКлиент.ОболочкаПоляТекстаЛкс(Элемент);
		#Если Сервер И Не Сервер Тогда
			ПолеТекстаHTML = Обработки.ирОболочкаПолеТекста.Создать();
		#КонецЕсли
		Если Событие.event = "EVENT_CONTENT_CHANGED" Тогда
			ЭтаФорма.Модифицированность = Истина;
		ИначеЕсли Событие.event = "EVENT_ON_LINK_CLICK" Тогда
			ПолеТекстаHTML.ОбработатьКликНаГиперссылке(Событие);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИзXMLвXDTO(Кнопка)
	
	Попытка
		Объект = ирОбщий.ОбъектXDTOИзСтрокиXMLЛкс(Текст);
	Исключение
		ирОбщий.СообщитьЛкс(ОписаниеОшибки(), СтатусСообщения.Важное);
	КонецПопытки;
	Если Объект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.ИсследоватьЛкс(Объект);
	
КонецПроцедуры

Процедура ДеревоПриАктивизацииСтроки(Элемент)
	ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура ДеревоПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ПараметрРежимВыбораМассива Тогда
		Результат = ТаблицаИзДерева();
		Если Результат = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ирКлиент.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Результат);
	Иначе
		КПДеревоВыгрузитьВТаблицу();
	КонецЕсли;
КонецПроцедуры

Процедура КПДеревоВыгрузитьВТаблицу(Кнопка = Неопределено)
	
	СтрокиДерева = Неопределено;
    Результат = ТаблицаИзДерева(СтрокиДерева);
	Если Результат.Колонки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ТекущаяСтрока = ЭлементыФормы.Дерево.ТекущаяСтрока;
	ИмяТаблицы = ТекущаяСтрока.Свойство;
	ИндексТекущейСтроки = СтрокиДерева.Найти(ТекущаяСтрока);
	ТекущаяСтрока = Неопределено;
	Если ИндексТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = Результат[ИндексТекущейСтроки];
	КонецЕсли;
	ирКлиент.ОткрытьТаблицуЗначенийЛкс(Результат, ТекущаяСтрока, Ложь, ИмяТаблицы,, Ложь);
КонецПроцедуры

Функция ТаблицаИзДерева(выхСтрокиДерева = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.Дерево.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	Если ирОбщий.СтрНачинаетсяСЛкс(ТекущаяСтрока.Значение, "[Массив-") Тогда
		выхСтрокиДерева = ТекущаяСтрока.Строки;
		ОтборСтрок = Неопределено;
	Иначе
		выхСтрокиДерева = ирОбщий.РодительСтрокиДереваЛкс(ТекущаяСтрока).Строки; 
		ОтборСтрок = Новый Структура("Свойство", ТекущаяСтрока.Свойство);
	КонецЕсли;
	выхСтрокиДерева = ирОбщий.ОтобратьЭлементыКоллекцииЛкс(выхСтрокиДерева, ОтборСтрок);
	Результат = ирОбщий.ТаблицаИзДереваСвойствоЗначениеАтрибутыЛкс(выхСтрокиДерева);
	Возврат Результат;

КонецФункции

Процедура КрупныйШрифтПриИзменении(Элемент = Неопределено)
	ЭлементыФормы.Компактный.Шрифт = Новый Шрифт(, ?(КрупныйШрифт, 10, 9));
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Компактный; // Чтобы выделение стало видно
КонецПроцедуры

Процедура ПоискДокументСформирован(Элемент)
	Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.РезультатыПоиска Тогда
		ОбновитьПоиск(Истина);
	КонецЕсли;
КонецПроцедуры

Процедура СтрокаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_ОбновитьСписокЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура СтрокаПоискаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	Если ирКлиент.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОбновитьПоиск();
	КонецЕсли;
КонецПроцедуры

Процедура СтрокаПоискаПриИзменении(Элемент)
	ирКлиент.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьПоиск();
КонецПроцедуры

Процедура ОбновитьПоиск(ИспользоватьВнешнийТекст = Ложь, СохранитьПозицию = Ложь)
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Если ИспользоватьВнешнийТекст Тогда
		Текст = СтрЗаменить(ПолучитьТекст(), Символы.ВК, ""); // При установке innerHTML они все равно удалятся, а при расчете позиций вхождений учитываются 
	Иначе
		Текст = мПолеТекстаПоиска.ПолучитьТекст();
	КонецЕсли;
	Если СохранитьПозицию Тогда
		ВыделениеВТексте = мПолеТекстаПоиска.ПолучитьВыделениеВДокументеHTML();
	КонецЕсли;
	ВыражениеПоискаСлов = ирОбщий.РегВыражениеСтрокиПоискаЛкс(СтрокаПоиска);
	РезультатыПоиска = ирОбщий.НайтиРегулярноеВыражениеЛкс(Текст, ВыражениеПоискаСлов,,, Истина,, Ложь);
	ЭлементыФормы.НадписьНайдено.Заголовок = "Найдено: " + РезультатыПоиска.Количество();
	
	РезультатыПоиска.Колонки.Добавить("ЛиГиперссылка", Новый ОписаниеТипов("Булево"));
	ВхожденияГиперссылок = ирОбщий.НайтиРегулярноеВыражениеЛкс(Текст, "(\b(?:[" + шБукваЦифра + "]+)://[" + шБукваЦифра + "-+&@#\\/%?=~_|!:,.;()]+)",,, Истина,, Ложь);
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ВхожденияГиперссылок, РезультатыПоиска, Новый Структура("ЛиГиперссылка", Истина));
	РезультатыПоиска.Сортировать("ПозицияВхождения");
	#Если Сервер И Не Сервер Тогда
		РезультатыПоиска = Новый ТаблицаЗначений;
	#КонецЕсли
	РезультатыПоиска.Колонки.ПозицияВхождения.Имя = "ПозицияПодгруппы";
	РезультатыПоиска.Колонки.ДлинаВхождения.Имя = "ДлинаПодгруппы";
	РезультатыПоиска.Колонки.ТекстВхождения.Имя = "Значение";
	РезультатыПоиска.Колонки.Добавить("Длина", Новый ОписаниеТипов("Число"));
	РезультатыПоиска.ЗагрузитьКолонку(РезультатыПоиска.ВыгрузитьКолонку("ДлинаПодгруппы"), "Длина");
	мПолеТекстаПоиска.РазметитьТекстРезультатамиПоиска(Текст, РезультатыПоиска,, ПереносСлов);
	Для Каждого ВхождениеГиперссылки Из РезультатыПоиска.НайтиСтроки(Новый Структура("ЛиГиперссылка", Истина)) Цикл
		РезультатыПоиска.Удалить(ВхождениеГиперссылки);
	КонецЦикла;
	Если СохранитьПозицию Тогда
		ВыделениеВТексте.Начало = Макс(0, ВыделениеВТексте.Начало - 1);
		ВыделениеВТексте.Конец = ВыделениеВТексте.Начало;
		мПолеТекстаПоиска.УстановитьВыделениеВДокументеHTML(ВыделениеВТексте);
	КонецЕсли;
	СледующееВхождениеНажатие();

КонецПроцедуры

Процедура ИгнорироватьРегистрПриИзменении(Элемент)
	ОбновитьПоиск();
КонецПроцедуры

Процедура ПереносСловПриИзменении(Элемент)
	ОбновитьПоиск(, Истина);
КонецПроцедуры

Процедура ПредыдущееВхождениеНажатие(Элемент = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ВыделениеВТексте = мПолеТекстаПоиска.ПолучитьВыделениеВДокументеHTML();
	
	// Мультиметка00203932
	ВыбраннаяГруппа = Неопределено;
	ИнвертироватьПоиск = Ложь;
	Для Каждого Группа Из мПолеТекстаПоиска.РезультатыПоиска Цикл
		Если Группа.ПозицияПодгруппы = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		Если Группа.ПозицияПодгруппы < ВыделениеВТексте.Начало Тогда
			ВыбраннаяГруппа = Группа;
		Иначе
			ИнвертироватьПоиск = Группа.ПозицияПодгруппы > ВыделениеВТексте.Начало + 2; // 2 - Крайний перенос строки 
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Если ВыбраннаяГруппа <> Неопределено Тогда
		мПолеТекстаПоиска.ВыделитьРезультатПоиска(ВыбраннаяГруппа);
	ИначеЕсли ИнвертироватьПоиск Тогда 
		СледующееВхождениеНажатие();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СледующееВхождениеНажатие(Элемент = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		мПолеТекстаПоиска = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ВыделениеВТексте = мПолеТекстаПоиска.ПолучитьВыделениеВДокументеHTML();
	
	// Мультиметка00203931
	ВыбраннаяГруппа = Неопределено;
	ИнвертироватьПоиск = Ложь;
	Для Каждого Группа Из мПолеТекстаПоиска.РезультатыПоиска Цикл
		Если Группа.ПозицияПодгруппы = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		ИнвертироватьПоиск = Группа.ПозицияПодгруппы < ВыделениеВТексте.Начало;
		Если Истина
			И Группа.ПозицияПодгруппы >= ВыделениеВТексте.Начало
			И Группа.ПозицияПодгруппы + Группа.ДлинаПодгруппы > ВыделениеВТексте.Конец + 2 // 2 - Крайний перенос строки 
		Тогда
			ВыбраннаяГруппа = Группа;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Если ВыбраннаяГруппа <> Неопределено Тогда
		мПолеТекстаПоиска.ВыделитьРезультатПоиска(ВыбраннаяГруппа);
	ИначеЕсли ИнвертироватьПоиск Тогда 
		ПредыдущееВхождениеНажатие();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПРезультатыПоискаПоискРегулярногоВыражения(Кнопка)
	Конструктор = ирКлиент.ПолучитьФормуЛкс("Обработка.ирКонструкторРегулярногоВыражения.Форма");
	Конструктор.ПараметрПроверочныйТекст = ПолучитьТекст();
	Конструктор.ПараметрВыражение = ирОбщий.РегВыражениеСтрокиПоискаЛкс(СтрокаПоиска);
	Конструктор.ОткрытьМодально();
КонецПроцедуры

Процедура РезультатыПоискаonclick(Элемент, pEvtObj)
	
	Если ирКлиент.ОткрытьГиперссылкуИзПоляHTMLЛкс(pEvtObj.srcElement, pEvtObj.ctrlKey) Тогда 
		pEvtObj.returnValue = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура КМ_РезультатыПоискаОткрытьГиперссылку(Кнопка) 
	ВыделениеПоля = ЭтаФорма.ЭлементыФормы.РезультатыПоиска.Документ.getSelection();
	ирКлиент.ОткрытьГиперссылкуИзПоляHTMLЛкс(ВыделениеПоля.focusNode);
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.Текст");
ПереносСлов = Истина;
ИгнорироватьРегистр = Истина;