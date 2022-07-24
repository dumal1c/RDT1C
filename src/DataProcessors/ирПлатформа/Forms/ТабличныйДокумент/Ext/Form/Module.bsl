﻿Перем ОбработчикРасшифровки Экспорт;

Функция ПолучитьРезультат()
	
	ирОбщий.ТабличныйДокументВосстановитьОформлениеТекущихСтрокЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
	Возврат ЭлементыФормы.ПолеТабличногоДокумента.ПолучитьОбласть();
	
КонецФункции

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение)
	
	#Если Сервер И Не Сервер Тогда
		НовоеЗначение = Новый ТабличныйДокумент;
	#КонецЕсли   
	ЭтаФорма.КодЯзыка = НовоеЗначение.КодЯзыка;
	Если Не ЗначениеЗаполнено(КодЯзыка) Тогда
		ЭтаФорма.КодЯзыка = ТекущийЯзык().КодЯзыка;
	КонецЕсли;
	Если ирКэш.ЭтоУчебнаяПлатформаЛкс() Тогда
		// Так только текущий язык останется
		ЭлементыФормы.ПолеТабличногоДокумента.ВставитьОбласть(НовоеЗначение.Область(),,, Ложь); 
	Иначе
		// Так будут потеряны несериализуемые расшифровки
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
		НовоеЗначение.Записать(ИмяВременногоФайла);
		ЭлементыФормы.ПолеТабличногоДокумента.Прочитать(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭлементыФормы.ПолеТабличногоДокумента, НовоеЗначение,, "ТолькоПросмотр, ОтображатьЗаголовки"); 
	//Если ПолеТабличногоДокумента <> Неопределено Тогда
	//	#Если Сервер И Не Сервер Тогда
	//		ПолеТабличногоДокумента = Новый ТабличныйДокумент;
	//	#КонецЕсли
	//	ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть = ЭлементыФормы.ПолеТабличногоДокумента.Область(ПолеТабличногоДокумента.ТекущаяОбласть.Имя);
	//КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если НачальноеЗначениеВыбора = Неопределено Тогда
		НачальноеЗначениеВыбора = Новый ТабличныйДокумент;
	КонецЕсли;
	Если ЭтаФорма.ТолькоПросмотр Тогда
		ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Редактирование.Доступность = Ложь;
	ИначеЕсли НачальноеЗначениеВыбора.ВысотаТаблицы = 0 Тогда 
		КоманднаяПанельТабличныйДокументРедактирование();
	КонецЕсли; 
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора);
	Для Каждого Язык Из Метаданные.Языки Цикл
		#Если Сервер И Не Сервер Тогда
			Язык = Метаданные.Языки.Русский;
		#КонецЕсли
		ЭлементыФормы.КодЯзыка.СписокВыбора.Добавить(Язык.КодЯзыка, Язык.Имя + " - " + Язык.КодЯзыка);
	КонецЦикла;
	ЭлементыФормы.КодЯзыка.СписокВыбора.СортироватьПоПредставлению();

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Модифицированность = Ложь;
	НовоеЗначение = ПолучитьРезультат();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОсновныеДействияФормыОК();
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаЗагрузитьИзФайла(Кнопка)
	
	ирОбщий.ЗагрузитьТабличныйДокументИнтерактивноЛкс(ЭлементыФормы.ПолеТабличногоДокумента);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(ПолучитьРезультат().ПолучитьОбласть(),,,, Ложь);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументАвтосумма(Кнопка)
	
	ЭтаФорма.Автосумма = Не Кнопка.Пометка;
	Кнопка.Пометка = Автосумма;
	ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть;
	
КонецПроцедуры

Процедура ПолеТабличногоДокументаПриАктивизацииОбласти(Элемент)
	
	Если Автосумма Тогда
		ТекстКнопки = ирОбщий.ПолеТабличногоДокумента_ПолучитьПредставлениеСуммыВыделенныхЯчеекЛкс(Элемент);
	Иначе
		ТекстКнопки = "";
	КонецЕсли;
	ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Автосумма.Текст = ТекстКнопки;
	ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.РасшифровкаЯчейки.Доступность = Истина
		И ТипЗнч(ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть) = Тип("ОбластьЯчеекТабличногоДокумента")
		И ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
		И ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Расшифровка <> Неопределено;
	Если ВыделятьТекущиеСтроки Тогда
		ПодключитьОбработчикОжидания("ОформитьТекущиеСтроки", 0.1, Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура ОформитьТекущиеСтроки()
	ирОбщий.ТабличныйДокументОформитьТекущиеСтрокиЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРедактирование(Кнопка = Неопределено)
	
	Кнопка = ЭлементыФормы.КоманднаяПанельТабличныйДокумент.Кнопки.Редактирование;
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементыФормы.ПолеТабличногоДокумента.ТолькоПросмотр = Не Кнопка.Пометка;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРедакторОбъектаБД(Кнопка)
	
	ЗначениеРасшифровки = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Расшифровка;
	Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(ЗначениеРасшифровки) Тогда
		ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ЗначениеРасшифровки);
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументПередатьВПодборИОбработкуОбъектов(Кнопка)
	
	ТаблицаЗначений = ирОбщий.ТаблицаКлючейИзТабличногоДокументаЛкс(ЭлементыФормы.ПолеТабличногоДокумента);
	Если ТаблицаЗначений.Количество() > 0 Тогда
		ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
		ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(ТаблицаЗначений.ВыгрузитьКолонку(0));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументАвтоширина(Кнопка)
	
	ирОбщий.УстановитьАвтоширинуКолонокТабличногоДокументаЛкс(ЭлементыФормы.ПолеТабличногоДокумента);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументЗафиксировать(Кнопка)
	
	ЭлементыФормы.ПолеТабличногоДокумента.ФиксацияСлева = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Лево - 1;
	ЭлементыФормы.ПолеТабличногоДокумента.ФиксацияСверху = ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Верх - 1;
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументСохранитьВФайл(Кнопка)
	
	ирОбщий.СохранитьТабличныйДокументИнтерактивноЛкс(ЭлементыФормы.ПолеТабличногоДокумента,,, УстанавливатьПризнакСодержитЗначение);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументЗагрузитьВТаблицуЗначений(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ЗагрузкаТабличныхДанных = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирЗагрузкаТабличныхДанных");
	#Если Сервер И Не Сервер Тогда
	    ЗагрузкаТабличныхДанных = Обработки.ирЗагрузкаТабличныхДанных.Создать();
	#КонецЕсли
	Форма = ЗагрузкаТабличныхДанных.ПолучитьФорму();
	Форма.ПараметрТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
	Форма.Открыть();
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументРасшифровкаЯчейки(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ЭлементыФормы.ПолеТабличногоДокумента.ТекущаяОбласть.Расшифровка);
	
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументОткрытьВExcel(Кнопка)
	
	ПолноеИмяФайла = ПолучитьИмяВременногоФайла("xls");
	ирОбщий.СохранитьТабличныйДокументИнтерактивноЛкс(ЭлементыФормы.ПолеТабличногоДокумента, ПолноеИмяФайла, Истина, УстанавливатьПризнакСодержитЗначение);
	
КонецПроцедуры

Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ОбработчикРасшифровки <> Неопределено И ирКэш.НомерВерсииПлатформыЛкс() >= 803003 Тогда
		Выполнить("ВыполнитьОбработкуОповещения(ОбработчикРасшифровки, Расшифровка)");
	Иначе
		ирОбщий.ОткрытьЗначениеЛкс(Расшифровка, , СтандартнаяОбработка);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭтаФорма.КоличествоСтрок = ЭлементыФормы.ПолеТабличногоДокумента.ВысотаТаблицы;
	ЭтаФорма.КоличествоКолонок = ЭлементыФормы.ПолеТабличногоДокумента.ШиринаТаблицы;
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура КоманднаяПанельТабличныйДокументВыделятьТекущиеСтроки(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ВыделятьТекущиеСтроки = Кнопка.Пометка;
	Если ВыделятьТекущиеСтроки Тогда
		ОформитьТекущиеСтроки();
	Иначе
		ирОбщий.ТабличныйДокументВосстановитьОформлениеТекущихСтрокЛкс(ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокумента);
	КонецЕсли;
	
КонецПроцедуры

Процедура КодЯзыкаПриИзменении(Элемент)
	
	ЭлементыФормы.ПолеТабличногоДокумента.КодЯзыка = КодЯзыка;
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ТабличныйДокумент");
УстанавливатьПризнакСодержитЗначение = Истина;