﻿// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Это коллекция экземпляров компоненты. Обязательный блок.
Перем ПолеТекстовогоДокументаСКонтекстнойПодсказкой;
// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой

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

	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой = Новый Структура;
	Обработка1 = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой");
	#Если Сервер И Не Сервер Тогда
	    Обработка1 = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	Обработка1.Инициализировать(ПолеТекстовогоДокументаСКонтекстнойПодсказкой,
		ЭтаФорма, ЭлементыФормы.ВстроенныйЯзык, ЭлементыФормы.КоманднаяПанельВстроенныйЯзык, Ложь, "ВыполнитьЛокально", ЭтаФорма);
	Обработка2 = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой");
	#Если Сервер И Не Сервер Тогда
	    Обработка2 = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	Обработка2.Инициализировать(ПолеТекстовогоДокументаСКонтекстнойПодсказкой,
		ЭтаФорма, ЭлементыФормы.ЯзыкЗапросов, ЭлементыФормы.КоманднаяПанельЯзыкЗапросов, Истина);
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
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
	Если ТипЗнч(ТекущееПоле) = Тип("ПолеВвода") Тогда
		Текст = ТекущееПоле.Значение;
	ИначеЕсли ТекущееПоле = ЭлементыФормы.JSON Тогда
		Текст = мРедакторJSON.getText();
	Иначе
		Текст = ТекущееПоле.ПолучитьТекст();
	КонецЕсли; 
	Возврат Текст;

КонецФункции

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура УстановитьТекст(Текст)

	ТекущееПоле = ЭлементыФормы[мТекущаяСтраница.Имя];
	ВыделитьВсе = ПараметрВыделитьВсе;
	Если ТипЗнч(ТекущееПоле) = Тип("ПолеВвода") Тогда
		ТекущееПоле.Значение = Текст;
		ВыделитьВсе = Истина;
	ИначеЕсли ТекущееПоле = ЭлементыФормы.JSON Тогда
		Если мРедакторJSON = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		мРедакторJSON.setText(Текст);
	Иначе
		ТекущееПоле.УстановитьТекст(Текст);
	КонецЕсли; 
	Если ВыделитьВсе И СтрДлина(Текст) > 0 Тогда
		ТекущееПоле.УстановитьГраницыВыделения(1, СтрДлина(Текст) + 1);
	КонецЕсли; 

КонецПроцедуры

Процедура ПанельОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Текст = ПолучитьТекст();
	мТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница; 
	УстановитьТекст(Текст); 
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       – КнопкаКоманднойПанели.
//
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	// Имя страницы совпадает с именем поля текстового документа
	Компонента = 0;
	Если ПолеТекстовогоДокументаСКонтекстнойПодсказкой.Свойство(ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя, Компонента) Тогда 
		#Если Сервер И Не Сервер Тогда
		    Компонента = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
		#КонецЕсли
		Компонента.Нажатие(Кнопка);
	КонецЕсли; 
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстовогоДокументаСКонтекстнойПодсказкой = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	// Имя страницы совпадает с именем поля текстового документа
	Компонента = 0;
	Если ПолеТекстовогоДокументаСКонтекстнойПодсказкой.Свойство(ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя, Компонента) Тогда 
		#Если Сервер И Не Сервер Тогда
		    Компонента = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
		#КонецЕсли
		Компонента.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	Иначе
		ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСравнитьТекст(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭтаФорма, ЭлементыФормы[ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя]);
	
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
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

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
	мРедакторJSON.menu.style.backgroundColor = "#d0d0d0";
	мРедакторJSON.aceEditor.setReadOnly(ТолькоПросмотр);
	ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница; // Вызовет ПриСменеСтраницы

КонецПроцедуры

Процедура JSONonclick(Элемент, pEvtObj)
	
	Если Элемент.ИзменяетДанные И pEvtObj.srcElement.id = "onChange" Тогда
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли; 

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.Текст");

мТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница;
