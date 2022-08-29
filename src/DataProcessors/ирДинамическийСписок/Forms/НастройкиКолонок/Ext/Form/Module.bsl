﻿Перем мПлатформа;

Процедура ОсновныеДействияФормыПрименить(Кнопка)
	
	ПолучитьРезультат(Ложь); 
	ОбновитьСвязанноеТабличноеПоле();
	
КонецПроцедуры

Процедура ОбновитьСвязанноеТабличноеПоле(Восстановить = Ложь)
	
	Если Восстановить Тогда
		ЭтаФорма.Результат = Новый Структура;
		Результат.Вставить("ПрименятьПорядок", ПрименятьПорядок);
		Результат.Вставить("Сохранить", Ложь);
		Результат.Вставить("НастройкиКолонок", НастройкиКолонок.Выгрузить());
	КонецЕсли;
	Если СвязанноеТабличноеПоле <> Неопределено Тогда
		СтарыеНастройки = НастройкиКолонок.Выгрузить();
		ПрименитьНастройкиКолонокКТабличномуПолю(СвязанноеТабличноеПоле, Результат);
		Если Не Результат.Сохранить Тогда
			НастройкиКолонок.Загрузить(СтарыеНастройки);
		КонецЕсли;  
	Иначе
		Если Не Результат.Сохранить Тогда
			ОповеститьОВыборе(Результат); 
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОсновныеДействияФормыПрименитьИЗакрыть(Кнопка)
	
	Закрыть(ПолучитьРезультат(Истина));
	
КонецПроцедуры

Функция ПолучитьРезультат(Сохранить)
	
	ЭтаФорма.Результат = Новый Структура;
	Результат.Вставить("ПрименятьПорядок", ПрименятьПорядок);
	Результат.Вставить("Сохранить", Сохранить);
	Результат.Вставить("НастройкиКолонок", ОбработкаОбъектСлужебная.НастройкиКолонок.Выгрузить());
	Возврат Результат;

КонецФункции

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.ЗакрыватьПриВыборе = Ложь;
	ЭлементыФормы.НадписьСохранениеНастроек.Видимость = ПараметрРучноеСохранение;
	ЭлементыФормы.ДействияФормы.Кнопки.ЗагрузитьПорядокИзОсновнойФормы.Доступность = ЗначениеЗаполнено(ПолноеИмяТаблицы);
	ОбработкаОбъектСлужебная.НастройкиКолонок.Загрузить(НастройкиКолонок.Выгрузить());
	Если ЗначениеЗаполнено(ПолноеИмяТаблицы) Тогда
		ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицы);
		#Если Сервер И Не Сервер Тогда
			ПоляТаблицы = Новый ТаблицаЗначений;
		#КонецЕсли
		Для Каждого СтрокаНастройкиКолонки Из ОбработкаОбъектСлужебная.НастройкиКолонок Цикл
			ДоступноеПоле = ПоляТаблицы.Найти(СтрокаНастройкиКолонки.Имя, "Имя");
			Если ДоступноеПоле = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаНастройкиКолонки.ТипЗначения = ДоступноеПоле.ТипЗначения;
		КонецЦикла;
	КонецЕсли;
	Если СвязанноеТабличноеПоле <> Неопределено Тогда
		ТекущаяКолонка = ирОбщий.ТабличноеПоле_ТекущаяКолонкаЛкс(СвязанноеТабличноеПоле);
		Если Не ЗначениеЗаполнено(ПараметрИмяТекущейКолонки) И ТекущаяКолонка <> Неопределено Тогда
			ПараметрИмяТекущейКолонки = ТекущаяКолонка.Имя;
		КонецЕсли; 
	КонецЕсли;
	СтрокаТекущейКолонки = ОбработкаОбъектСлужебная.НастройкиКолонок.Найти(ПараметрИмяТекущейКолонки, "Имя");
	Если СтрокаТекущейКолонки <> Неопределено Тогда
		ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока = СтрокаТекущейКолонки;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ЭлементыФормы.НастройкиКолонок.Колонки.Положение.ЭлементУправления.СписокВыбора = мПлатформа.ДоступныеЗначенияТипа("ПоложениеКолонки");
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыАктивизироватьКолонку(Кнопка = Неопределено)
	
	Если ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока = Неопределено Или Не ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Видимость Тогда
		Возврат;
	КонецЕсли;   
	Если СвязанноеТабличноеПоле <> Неопределено Тогда
		ИмяКолонки = ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Имя;
		КолонкаТП = СвязанноеТабличноеПоле.Колонки.Найти(ИмяКолонки);
		ирОбщий.ТабличноеПоле_УстановитьТекущуюКолонкуЛкс(СвязанноеТабличноеПоле, КолонкаТП);
	Иначе
		Оповещение = Новый Структура;
		Оповещение.Вставить("ТекущаяКолонка", ЭлементыФормы.НастройкиКолонок.ТекущаяСтрока.Имя);
		ОповеститьОВыборе(Оповещение);
	КонецЕсли;
	
КонецПроцедуры

Процедура НастройкиКолонокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		Или Колонка = ЭлементыФормы.НастройкиКолонок.Колонки.Имя 
		Или Колонка = ЭлементыФормы.НастройкиКолонок.Колонки.Заголовок
	Тогда
		СтандартнаяОбработка = Ложь;
		ДействияФормыАктивизироватьКолонку();
	КонецЕсли; 
	
КонецПроцедуры

Процедура НастройкиКолонокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура НастройкиКолонокПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДействияФормыПереместитьВверх(Кнопка)
	
	ПорядокИзменен = ирОбщий.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, -1);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыПереместитьВниз(Кнопка)
	
	ПорядокИзменен = ирОбщий.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, +1);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыВНачало(Кнопка)
	
	ПорядокИзменен = ирОбщий.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, -100000);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыВКонец(Кнопка)
	ПорядокИзменен = ирОбщий.ТабличноеПолеСдвинутьВыделенныеСтрокиЛкс(ЭлементыФормы.НастройкиКолонок, +100000);
	Если ПорядокИзменен Тогда
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 
КонецПроцедуры

Процедура НастройкиКолонокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	СтандартнаяОбработка = ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Копирование;
	ЭтаФорма.ПрименятьПорядок = Истина;
	
КонецПроцедуры

Процедура НастройкиКолонокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура НастройкиКолонокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки,,, Новый Структура("ТипЗначения"));

КонецПроцедуры

Процедура ДействияФормыЗагрузитьПорядокИзОсновнойФормы(Кнопка)
	
	Если ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		Форма = СсылкаОбъекта.ПолучитьФорму();
	ИначеЕсли ЗначениеЗаполнено(ПолноеИмяТаблицы) Тогда 
		Форма = ирОбщий.ПолучитьФормуСпискаЛкс(ПолноеИмяТаблицы,, Ложь, ВладелецФормы, РежимВыбора);
	КонецЕсли; 
	Если Форма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(Форма) = Тип("Форма") Тогда
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.ЭлементыФормы Цикл
			Если Истина
				И  ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле")
				И (Ложь
					Или Не ЗначениеЗаполнено(СсылкаОбъекта)
					Или Найти(НРег(ЭлементФормы.Имя), НРег(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяТаблицы))) > 0)
			Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	Иначе
		ТабличноеПоле = Неопределено;
		Для Каждого ЭлементФормы Из Форма.Элементы Цикл
			Если Истина
				И  ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы")
				И (Ложь
					Или Не ЗначениеЗаполнено(СсылкаОбъекта)
					Или Найти(НРег(ЭлементФормы.Имя), НРег(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяТаблицы))) > 0)
			Тогда
				ТабличноеПоле = ЭлементФормы;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	Если ТабличноеПоле <> Неопределено Тогда
		СтрокаКолонкиКартинка = ЭлементыФормы.НастройкиКолонок.Значение.Найти("Картинка", "Имя");
		Если СтрокаКолонкиКартинка <> Неопределено Тогда
			ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(СтрокаКолонкиКартинка, -ЭлементыФормы.НастройкиКолонок.Значение.Индекс(СтрокаКолонкиКартинка));
		КонецЕсли; 
		Счетчик = 0;
		Для Каждого КолонкаТП Из ирОбщий.КолонкиТаблицыФормыИлиТабличногоПоляЛкс(ТабличноеПоле) Цикл
			ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
			Если ЗначениеЗаполнено(ДанныеКолонки) Тогда
				СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти(ДанныеКолонки, "Имя");
			ИначеЕсли КолонкаТП.Имя = "Картинка" Тогда
				СтрокаКолонки = ЭлементыФормы.НастройкиКолонок.Значение.Найти(КолонкаТП.Имя, "Имя");
			КонецЕсли;
			Если СтрокаКолонки <> Неопределено Тогда
				ЭлементыФормы.НастройкиКолонок.Значение.Сдвинуть(СтрокаКолонки, -ЭлементыФормы.НастройкиКолонок.Значение.Индекс(СтрокаКолонки)+Счетчик);
				Счетчик = Счетчик + 1;
			КонецЕсли; 
		КонецЦикла;
		ЭтаФорма.ПрименятьПорядок = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура НастройкиКолонокПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ОбновитьСвязанноеТабличноеПоле(Результат = Неопределено Или Не Результат.Сохранить);
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.НастройкиКолонок");

мПлатформа = ирКэш.Получить();