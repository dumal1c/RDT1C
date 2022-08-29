﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхНаименование = "" + ТабличноеПоле.Имя;
	выхИменаСвойств = "Табличная часть.КолонкиТабличногоПоля, Форма.БезОформления, Форма.КолонкиЗначений, Форма.КолонкиТипов, Форма.КолонкиИдентификаторов, Форма.ВстроитьЗначенияВРасшифровки, Форма.ТолькоВыделенныеСтроки, Форма.ОтображатьПустые, Форма.ИтогиЧисловыхКолонок, Форма.ВыводВТаблицуЗначений, Форма.КолонкиРазмеров, Форма.СузитьТипы, Форма.КоличествоПервых";
	Результат = Новый Структура("ИмяТабличногоПоля", ТабличноеПоле.Имя);
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	Если НастройкаФормы <> Неопределено Тогда
		Если ТипЗнч(ТабличноеПоле) <> Тип("ТабличноеПоле") Тогда
			НастройкаФормы.БезОформления = Истина;
		КонецЕсли;
		Если НастройкаФормы.Свойство("ИмяТабличногоПоля") И НастройкаФормы.ИмяТабличногоПоля = ТабличноеПоле.Имя Тогда
			Для Каждого НастройкаКолонки Из НастройкаФормы.КолонкиТабличногоПоля Цикл
				НоваяКолонка = КолонкиТабличногоПоля.Найти(НастройкаКолонки.Имя, "Имя");
				Если НоваяКолонка <> Неопределено Тогда
					НоваяКолонка.Пометка = НастройкаКолонки.Пометка;
				КонецЕсли;
			КонецЦикла;
			Если КолонкиТабличногоПоля.Найти(Истина, "Пометка") = Неопределено Тогда
				ирОбщий.УстановитьСвойствоВКоллекцииЛкс(КолонкиТабличногоПоля, "Пометка", Истина);
			КонецЕсли;
		КонецЕсли; 
		Если НастройкаФормы.Свойство("КолонкиТабличногоПоля") Тогда 
			НастройкаФормы.Удалить("КолонкиТабличногоПоля");        
		КонецЕсли;
	КонецЕсли;
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура КПКолонкиТолькоВключенные(Кнопка)
	
	УстановитьОтборТолькоВключенные(Не Кнопка.Пометка);
	
КонецПроцедуры

Процедура УстановитьОтборТолькоВключенные(НовоеЗначение)
	
	ЭлементыФормы.КПКолонки.Кнопки.ТолькоВключенные.Пометка = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.ВидСравнения = ВидСравнения.Равно;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Использование = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Значение = Истина;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если КолонкиТабличногоПоля.Найти(Истина, "Пометка") <> Неопределено Тогда
		УстановитьОтборТолькоВключенные(Истина);
	КонецЕсли;
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура ДобавитьКолонки(Знач КолонкиТП, Знач ТекущаяКолонка)
	
	ПолноеИмяТаблицыБД = "";
	Если ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ТабличноеПоле,,, ПолноеИмяТаблицыБД) = "Список" Тогда 
		ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицыБД);
	Иначе
		ЭлементыФормы.КолонкиТабличногоПоля.Колонки.ТолькоДляВыделенных.Видимость = Ложь;
	КонецЕсли; 
	Для Каждого КолонкаТП Из КолонкиТП Цикл
		Если Истина
			И Не КолонкаТП.Видимость 
			И (Ложь
				Или ТипЗнч(КолонкаТП) <> Тип("КолонкаТабличногоПоля")
				Или Не КолонкаТП.ИзменятьВидимость // В управляемой форме нет свойства ИзменятьВидимость
				)
		Тогда
			Продолжить;
		КонецЕсли; 
		Если ТипЗнч(КолонкаТП) = Тип("ГруппаФормы") Тогда
			ДобавитьКолонки(КолонкаТП.ПодчиненныеЭлементы, ТекущаяКолонка);
			Продолжить;
		КонецЕсли; 
		ДобавитьСтрокуКолонки(КолонкаТП, ТекущаяКолонка, ПоляТаблицыБД);
	КонецЦикла;
	Если ТипЗнч(ТабличноеПоле) = Тип("ТаблицаФормы") Тогда
		ТекущееПоле = ТабличноеПоле.ТекущийЭлемент;
		Если ТипЗнч(ТекущееПоле) = Тип("ПолеФормы") Тогда
			// Пользовательская колонка
			ДобавитьСтрокуКолонки(ТекущееПоле, ТекущаяКолонка, ПоляТаблицыБД);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ДобавитьСтрокуКолонки(КолонкаТП, Знач ТекущаяКолонка, Знач ПоляТаблицыБД)
	
	ПутьКДанным = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
	Если Истина
		И ЗначениеЗаполнено(ПутьКДанным) 
		И КолонкиТабличногоПоля.Найти(ПутьКДанным) <> Неопределено 
	Тогда
		Возврат;
	КонецЕсли; 
	СтрокаКолонки = КолонкиТабличногоПоля.Добавить();
	СтрокаКолонки.Имя = КолонкаТП.Имя;
	Если ТипЗнч(КолонкаТП) = Тип("ПолеФормы") Тогда
		СтрокаКолонки.Заголовок = КолонкаТП.Заголовок;
	Иначе
		СтрокаКолонки.Заголовок = КолонкаТП.ТекстШапки;
	КонецЕсли; 
	СтрокаКолонки.Пометка = КолонкаТП.Видимость;
	СтрокаКолонки.Видимость = КолонкаТП.Видимость;
	СтрокаКолонки.Данные = ПутьКДанным;
	//СтрокаКолонки.ТипЗначения = 
	Если ТекущаяКолонка = КолонкаТП Тогда
		ЭлементыФормы.КолонкиТабличногоПоля.ТекущаяСтрока = СтрокаКолонки;
	КонецЕсли;
	Если ПоляТаблицыБД <> Неопределено Тогда
		СтрокаКолонки.ТолькоДляВыделенных = ПоляТаблицыБД.Найти(ПутьКДанным, "Имя") = Неопределено;
	КонецЕсли; 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура БезОформленияПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	//ЭлементыФормы.ВыводВТаблицуЗначений.Доступность = БезОформления;
	ЭлементыФормы.КолонкиИдентификаторов.Доступность = БезОформления;
	ЭлементыФормы.КолонкиТипов.Доступность = БезОформления;
	ЭлементыФормы.КолонкиЗначений.Доступность = БезОформления;
	ЭлементыФормы.ОтображатьПустые.Доступность = БезОформления;
	ЭлементыФормы.ИтогиЧисловыхКолонок.Доступность = БезОформления;
	ЭлементыФормы.КолонкиРазмеров.Доступность = БезОформления;
	ЭлементыФормы.ВстроитьЗначенияВРасшифровки.Доступность = Не ВыводВТаблицуЗначений;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ИсполняемаяКомпоновка.Доступность = БезОформления;
	ПолноеИмяТаблицыБД = "";
	ДанныеТабличногоПоля = Неопределено;
	ТипИсточника = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ТабличноеПоле,,, ПолноеИмяТаблицыБД, ДанныеТабличногоПоля);
	ЭлементыФормы.КоличествоПервых.Доступность = Истина
		И ТипИсточника = "Список" 
		И ДанныеТабличногоПоля <> Неопределено
		И ЗначениеЗаполнено(ПолноеИмяТаблицыБД) 
		И Не ТолькоВыделенныеСтроки;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляЛкс(ТабличноеПоле, ЭтаФорма, Истина);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КолонкиТабличногоПоляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт

	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если БезОформления И Не ЗначениеЗаполнено(ДанныеСтроки.Данные) Тогда
		ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
	КонецЕсли;
	
КонецПроцедуры

Процедура КолонкиТабличногоПоляПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка, ЭлементыФормы.КПКолонки.Кнопки.ТолькоВключенные);

КонецПроцедуры

Процедура КолонкиТабличногоПоляПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ТолькоВыделенныеСтрокиПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КолонкиТабличногоПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	#Если Сервер И Не Сервер Тогда
		ТабличноеПоле = Новый ТабличноеПоле;
	#КонецЕсли
	КолонкаТП = ТабличноеПоле.Колонки[ВыбраннаяСтрока.Имя];
	Если КолонкаТП.Видимость И КолонкаТП.Доступность Тогда
		ТабличноеПоле.ТекущаяКолонка = КолонкаТП;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыводВТаблицуЗначенийПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	КолонкиТабличногоПоля.Очистить();
	Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда
		КолонкиТП = ТабличноеПоле.Колонки;
		ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Иначе
		КолонкиТП = ТабличноеПоле.ПодчиненныеЭлементы;
		ТекущаяКолонка = ТабличноеПоле.ТекущийЭлемент;
	КонецЕсли; 
	ДобавитьКолонки(КолонкиТП, ТекущаяКолонка);
	ДоступныДанныеПоля = ирОбщий.ДанныеЭлементаФормыЛкс(ТабличноеПоле) <> Неопределено;
	ЭтаФорма.ТолькоВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки.Количество() > 1 Или Не ДоступныДанныеПоля;
	ЭлементыФормы.ТолькоВыделенныеСтроки.Доступность = ДоступныДанныеПоля;
	ЭлементыФормы.БезОформления.Доступность = ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле");
КонецПроцедуры

Процедура КПКолонкиПометитьВсеВидимые(Кнопка)
	
	Для Каждого СтрокаКолонки Из КолонкиТабличногоПоля.НайтиСтроки(Новый Структура("Видимость", Истина)) Цикл 
		СтрокаКолонки.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПараметрыВыводаСтрокТаблицы");
БезОформления = Истина;
КолонкиЗначений = Истина;
ВстроитьЗначенияВРасшифровки = Истина;
СузитьТипы = Истина;
СписокВыбора = ЭлементыФормы.КоличествоПервых.СписокВыбора;
СписокВыбора.Добавить(1000);
СписокВыбора.Добавить(10000);
СписокВыбора.Добавить(100000);
СписокВыбора.Добавить(1000000);
КоличествоПервых = 100000;