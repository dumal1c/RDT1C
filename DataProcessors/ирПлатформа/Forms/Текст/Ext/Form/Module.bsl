﻿// +++.КЛАСС.ПолеТекстаПрограммы
// Это коллекция экземпляров компоненты. Обязательный блок.
Перем ПолеТекстаПрограммы;
// ---.КЛАСС.ПолеТекстаПрограммы

Перем мТекущаяСтраница;
Перем мРедакторJSON;
 
Процедура ЗакрытьССохранением()

	Текст = ПолучитьТекст();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Текст);

КонецПроцедуры // ЗакрытьССохранением()

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ЗакрытьССохранением();
	
КонецПроцедуры

Процедура ПриОткрытии()

	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаПрограммы = Новый Структура;
	Обработка1 = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
	    Обработка1 = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	Обработка1.Инициализировать(ПолеТекстаПрограммы,
		ЭтаФорма, ЭлементыФормы.ВстроенныйЯзык, ЭлементыФормы.КоманднаяПанельВстроенныйЯзык, Ложь, "ВыполнитьЛокально", ЭтаФорма);
	Обработка2 = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
	    Обработка2 = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	Обработка2.Инициализировать(ПолеТекстаПрограммы,
		ЭтаФорма, ЭлементыФормы.ЯзыкЗапросов, ЭлементыФормы.КоманднаяПанельЯзыкЗапросов, Истина);
	// ---.КЛАСС.ПолеТекстаПрограммы
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	УстановитьТекст(НачальноеЗначениеВыбора);
	Если РекомендуемыйВариант <> "" Тогда
		ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы[РекомендуемыйВариант];
	КонецЕсли;
	ЭлементыФормы.ТолькоПросмотр.Доступность = Не ТолькоПросмотр;
	ЭтаФорма.рТолькоПросмотр = ТолькоПросмотр;
	ОбновитьДоступность();
	ЭтаФорма.ПараметрВыделитьВсе = Ложь;
	ЭлементыФормы.ПанельОсновная.Страницы.JSON.Доступность = ирКэш.НомерВерсииПлатформыЛкс() >= 803014;
	Если ЭлементыФормы.ПанельОсновная.Страницы.JSON.Доступность Тогда
		ЭлементыФормы.JSON.Перейти(БазовыйФайлРедактораJSON());
	КонецЕсли; 
	ЭлементыФормы.ПанельОсновная.Страницы.XML.Доступность = ирКэш.ЛиДоступенРедакторМонакоЛкс();
	Если ЭлементыФормы.ПанельОсновная.Страницы.XML.Доступность Тогда
		ЭлементыФормы.XML.Перейти(мПлатформа.БазовыйФайлРедактораКода());
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

	ТекущееПоле = ЭлементыФормы[мТекущаяСтраница.Имя];
	ПолеТекста = ирОбщий.ОболочкаПоляТекстаЛкс(ТекущееПоле);
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Если ТекущееПоле = ЭлементыФормы.JSON Тогда
		Текст = мРедакторJSON.getText();
	Иначе
		Текст = ПолеТекста.ПолучитьТекст();
	КонецЕсли; 
	Возврат Текст;

КонецФункции

Функция УстановитьТекст(Текст, Активировать = Ложь)

	ТекущееПоле = ЭлементыФормы[ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя];
	ВыделитьВсе = ПараметрВыделитьВсе;
	ПолеТекста = ирОбщий.ОболочкаПоляТекстаЛкс(ТекущееПоле);
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Если ТекущееПоле = ЭлементыФормы.JSON Тогда
		Если мРедакторJSON = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли; 
		мРедакторJSON.setMode("code"); // https://github.com/josdejong/jsoneditor/issues/1210
		мРедакторJSON.setText(Текст);
		Если Активировать Тогда
			мРедакторJSON.focus();
		КонецЕсли;
		ДеревоJSONПриИзменении();
	ИначеЕсли ТипЗнч(ТекущееПоле) = Тип("ПолеВвода") Тогда
		ТекущееПоле.Значение = Текст;
		ВыделитьВсе = Истина;
	Иначе
		Если Не ПолеТекста.УстановитьТекст(Текст, Активировать) Тогда 
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли; 
	Если ВыделитьВсе И СтрДлина(Текст) > 0 Тогда
		ПолеТекста.УстановитьГраницыВыделения(1, СтрДлина(Текст) + 1);
	КонецЕсли; 
	Возврат Истина;

КонецФункции

Процедура ПанельОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Текст = ПолучитьТекст();
	Если УстановитьТекст(Текст, Истина) Тогда 
		мТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница;
	КонецЕсли; 
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       – КнопкаКоманднойПанели.
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
		ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
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
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭтаФорма, ЭлементыФормы[ТекущаяСтраница.Имя], ВариантСинтаксиса);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыДействие(Кнопка)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(,,, ПолучитьТекст());
	Если ПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УстановитьТекст(ПолноеИмяФайла);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСохранитьВФайл(Кнопка)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ПолучитьТекст());
	ТекстовыйДокумент.Записать(ВыборФайла.ПолноеИмяФайла);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузитьИзФайла(Кнопка)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ВыборФайла.ПолноеИмяФайла);
	УстановитьТекст(ТекстовыйДокумент.ПолучитьТекст());

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

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

Процедура ОсновныеДействияФормыПросмотрДереваJSON(Кнопка)
	
	Текст = ПолучитьТекст();
	ирОбщий.ОткрытьПросмотрДереваJSONЛкс(Текст);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОткрытьЧерезTXT(Кнопка)
	
	ОткрытьЧерезФайл("TXT");

КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьЗначениеЛкс(ПолучитьТекст(),,,, Ложь);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОсновныеДействияФормыФорматироватьJSON(Кнопка)
	
	УстановитьТекст(ирОбщий.ФорматироватьТекстJsonЛкс(ПолучитьТекст()));

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура JSONДокументСформирован(Элемент)
	
	мРедакторJSON = Элемент.Документ.defaultView.Init();
	ирОбщий.РедакторJSON_ИнициироватьЛкс(мРедакторJSON);
	мРедакторJSON.aceEditor.setReadOnly(ТолькоПросмотр);
	ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница; // Вызовет ПриСменеСтраницы
	мРедакторJSON.setText(ПолучитьТекст());

КонецПроцедуры

Процедура JSONonclick(Элемент, pEvtObj)
	
	Если Элемент.ИзменяетДанные И pEvtObj.srcElement.id = "onChange" Тогда
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ДеревоJSONПриИзменении(Элемент = Неопределено)

	ирОбщий.ПереключитьРежимДереваРедактораJSONЛкс(мРедакторJSON, РежимДереваJSON);
	
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

Процедура XMLДокументСформирован(Элемент)
	
	ПолеТекстаHTML = ирОбщий.ОболочкаПоляТекстаЛкс(Элемент);
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаHTML = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ПолеТекстаHTML.Инициировать();
	Инфо = Новый СистемнаяИнформация();
	РедакторHTML = ЭлементыФормы.XML.Документ.defaultView;
	РедакторHTML.init(Инфо.ВерсияПриложения);
	РедакторHTML.minimap(Ложь);
	РедакторHTML.showStatusBar(Ложь);
	РедакторHTML.switchXMLMode();
	РедакторHTML.enableModificationEvent(Истина);
	ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница; // Вызовет ПриСменеСтраницы
	//РедакторHTML.updateText(ПолучитьТекст());
	добавитьобработчик Элемент.Документ.defaultView.onresize, ЭтаФорма.XMLonresize; // https://github.com/salexdv/bsl_console/issues/178
	
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
		Если Событие.event = "EVENT_CONTENT_CHANGED" Тогда
			ЭтаФорма.Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура XMLonresize(pEvtObj) Экспорт
	
	ПолеТекста = ирОбщий.ОболочкаПоляТекстаЛкс(ЭлементыФормы.XML);
	#Если Сервер И Не Сервер Тогда
		ПолеТекста = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	ПолеТекста.Перерисовать();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.Текст");

мТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница;
