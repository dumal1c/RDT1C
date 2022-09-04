﻿Перем мСтрокаПорядка;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.Автосортировка, Реквизит.ВыводитьСообщения, Реквизит.ВыполнятьНаСервере, Реквизит.КомпоновщикДопПолей, Реквизит.ЛюбаяСсылкаБлокируетУдаление, Реквизит.ПаузаМеждуУдалениями, Реквизит.СтандартныйПоискСсылок, Реквизит.ТипыДляЗаполненияКандидатов, Табличная часть.УдаляемыеОбъекты, Табличная часть.НеблокирующиеТипы";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		НастройкаФормы = Новый Структура;
	#КонецЕсли
	ИспользованиеКандидаты = Ложь;
	ИспользованиеПрочее = Ложь;
	Если НастройкаФормы <> Неопределено Тогда
		ИспользованиеКандидаты = Истина;
		ИспользованиеПрочее = Истина;
		СпискиСвойств = Новый Соответствие;
		СпискиСвойств[Истина] = Новый Структура;
		СпискиСвойств[Ложь] = Новый Структура;
		СоставНастройкиФормы = ДопПараметры.СоставНастройкиФормы;
		#Если Сервер И Не Сервер Тогда
			СоставНастройкиФормы = Новый СписокЗначений;
		#КонецЕсли
		Если СоставНастройкиФормы <> Неопределено Тогда
			ИспользованиеКандидаты = СоставНастройкиФормы.НайтиПоЗначению("Кандидаты").Пометка;
			ИспользованиеПрочее = СоставНастройкиФормы.НайтиПоЗначению("Прочее").Пометка;
		КонецЕсли; 
		Если НастройкаФормы.Свойство("УдаляемыеОбъекты") Тогда
			Если ИспользованиеКандидаты Тогда
				СтарыеУдаляемыеОбъекты = НастройкаФормы.УдаляемыеОбъекты;
			КонецЕсли; 
			НастройкаФормы.Удалить("УдаляемыеОбъекты");
		КонецЕсли; 
		Если Истина
			И ДопПараметры <> Неопределено
			И ДопПараметры.Свойство("ПриОткрытии")
			И УдаляемыеОбъекты.Количество() > 0
		Тогда
			СтарыеУдаляемыеОбъекты = Неопределено;
		КонецЕсли; 
		Если Истина
			И НастройкаФормы.Свойство("НеблокирующиеТипы") 
			И НастройкаФормы.НеблокирующиеТипы <> Неопределено
			И НастройкаФормы.НеблокирующиеТипы.Колонки.Метаданные.ТипЗначения.КвалификаторыСтроки.Длина <= 200 // Опасно
		Тогда
			Для Каждого СтрокаТипа Из НастройкаФормы.НеблокирующиеТипы Цикл
				Если ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(ирОбщий.ПервыйФрагментЛкс(СтрокаТипа.Метаданные)) Тогда
					СтрокаТипа.Игнорировать = Истина;
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
		ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы, СпискиСвойств[Истина], СпискиСвойств[Ложь], ИспользованиеПрочее); 
	КонецЕсли; 
	Если СтарыеУдаляемыеОбъекты <> Неопределено Тогда
		СтарыеУдаляемыеОбъекты = ОбновитьДанныеКандидатов(СтарыеУдаляемыеОбъекты);
		#Если Сервер И Не Сервер Тогда
		    СтарыеУдаляемыеОбъекты = Новый ТаблицаЗначений;
		#КонецЕсли
		СтарыеУдаляемыеОбъекты.ЗаполнитьЗначения(Ложь, "Удаляется");
		ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(СтарыеУдаляемыеОбъекты, УдаляемыеОбъекты,,, Истина);
		ПослеИзмененияСоставаКандидатов();
		Если УдаляемыеОбъекты.Количество() > 0 Тогда
			ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока = УдаляемыеОбъекты[0];
		КонецЕсли; 
	КонецЕсли; 
	НастроитьЭлементыФормы();
	
КонецПроцедуры

// Устанавливает доступность элементов управления в зависимости от режима
//
Процедура вДоступностьКнопок() 
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Контроль.Доступность = УдаляемыеОбъекты.Количество() > 0;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.КонтрольИУдалениеПорциями.Доступность = УдаляемыеОбъекты.Количество() > 0;
	ЕстьУдаляемые = УдаляемыеОбъекты.Найти(Истина, "Удаляется") <> Неопределено;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить.Доступность = ЕстьУдаляемые;
	
КонецПроцедуры

// Выполняет поиск помеченных на удаление объектов
// и заполняет ими таблицу УдаляемыеОбъекты
//
Процедура ЗаполнитьПомеченныеНаУдаление()
	
	Кнопка = ЭлементыФормы.КоманднаяПанельУдаляемыхОбъектов.Кнопки.Заполнить;
	Если Кнопка.Картинка <> ирКэш.КартинкаПоИмениЛкс("ирОстановить") Тогда
		НачальноеЗначениеВыбора = ТипыДляЗаполненияКандидатов.ВыгрузитьЗначения();
		мПлатформа = ирКэш.Получить();
		Форма = мПлатформа.ПолучитьФорму("ВыборОбъектаМетаданных");
		лСтруктураПараметров = Новый Структура;
		лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
		лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
		лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", НачальноеЗначениеВыбора);
		Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
		МассивРазрешенныхТипов = Форма.ОткрытьМодально();
		#Если Сервер И Не Сервер Тогда
		    МассивРазрешенныхТипов = Новый Массив;
		#КонецЕсли
		Если МассивРазрешенныхТипов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ТипыДляЗаполненияКандидатов.ЗагрузитьЗначения(МассивРазрешенныхТипов);
	КонецЕсли; 
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("МассивРазрешенныхТипов", МассивРазрешенныхТипов);
	БлокируемыеЭлементыФормы = Новый Массив;
	БлокируемыеЭлементыФормы.Добавить(ЭлементыФормы.УдаляемыеОбъекты);
	#Если Сервер И Не Сервер Тогда
		НайтиПомеченныеНаУдалениеЛкс();
		ЗаполнитьПомеченныеНаУдалениеЗавершение();
	#КонецЕсли
	ирОбщий.ВыполнитьЗаданиеФормыЛкс("НайтиПомеченныеНаУдалениеЛкс", ПараметрыЗадания, ЭтаФорма, "ЗаполнитьКандидаты",,
		Кнопка, "ЗаполнитьПомеченныеНаУдалениеЗавершение",, БлокируемыеЭлементыФормы);

КонецПроцедуры

Процедура ЗаполнитьПомеченныеНаУдалениеЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		Если РезультатЗадания = Неопределено Тогда
			Возврат;
		КонецЕсли;
		СостояниеСтрок = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Ссылка");
		ПомеченныеОбъекты = РезультатЗадания.ПомеченныеОбъекты;
		МассивРазрешенныхТипов = РезультатЗадания.МассивРазрешенныхТипов;
		НачалоЗадания = РезультатЗадания.НачалоЗадания;
		СсылкиНаКандидата.Очистить();
		УдаляемыеОбъекты.Очистить();
		ПослеИзмененияСоставаКонтролируемыхОбъектов();
		СоответствиеТипаКМетаданному = Новый Соответствие;
		Если МассивРазрешенныхТипов.Количество() > 0 Тогда
			РазрешенныеТипы = Новый Соответствие;
			Для Каждого ПолноеИмяМД Из МассивРазрешенныхТипов Цикл
				РазрешенныеТипы[Тип(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(ПолноеИмяМД))] = 1;
			КонецЦикла;
			МассивКУдалению = Новый Массив;
			Для Каждого ПомеченныйОбъект Из ПомеченныеОбъекты Цикл
				Если РазрешенныеТипы[ТипЗнч(ПомеченныйОбъект)] = Неопределено Тогда
					Продолжить;
				КонецЕсли; 
				МассивКУдалению.Добавить(ПомеченныйОбъект);
			КонецЦикла;
		Иначе
			МассивКУдалению = ПомеченныеОбъекты;
		КонецЕсли; 
		Длительность = ТекущаяДата() - НачалоЗадания;
		Если Длительность > 10 Тогда
			ирОбщий.СообщитьЛкс("Поиск ссылок выполнен за " + XMLСтрока(Длительность) + "с. Найдено " + XMLСтрока(МассивКУдалению.Количество()) + " ссылок.");
		КонецЕсли; 
		ДобавитьМассивОбъектовВУдаляемыеОбъекты(МассивКУдалению, ЭтаФорма, Истина);
		ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок.Сбросить();
		вДоступностьКнопок();
		ПослеИзмененияСоставаКандидатов();
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, СостояниеСтрок);
	КонецЕсли; 

КонецПроцедуры

// Выполняет поиск ссылок на помеченные на удаление объекты,
// заполняет ими таблицу значений "ТаблицаСсылок",
// производит контроль на возможность удаления
//
Процедура вКонтроль()
	
	КонтролироватьСсылкиНаКандидаты();
	ПослеКонтроляСсылок();
	
КонецПроцедуры

Процедура ПослеКонтроляСсылок()
	
	ЭтаФорма.НеобходимоВыполнитьКонтроль = Ложь;
	вДоступностьКнопок();
	вПодсчитатьИтогУдаляемыеОбъекты();
	мСтрокаПорядка = "Метаданные";
	вПоказатьСсылкиНаУдаляемыйОбъект();

КонецПроцедуры

// Подсчитывает количество Помеченных, Выбранных, Удаляемых и НеУдаляемых объектов
//
Процедура вПодсчитатьИтогУдаляемыеОбъекты()
	
	ТекстНадписи =  "Без учета отбора Всего: " + УдаляемыеОбъекты.Количество() +".  Разрешен контроль: " + УдаляемыеОбъекты.Итог("Разрешен");
	Если ТаблицаСсылок <> Неопределено Тогда
		КоличествоУдаляемых = УдаляемыеОбъекты.НайтиСтроки(Новый Структура("Удаляется", Истина)).Количество();
		ТекстНадписи = ТекстНадписи + ".  Возможно удалить: " + КоличествоУдаляемых + ".  Невозможно удалить: " + (УдаляемыеОбъекты.Количество() - КоличествоУдаляемых);
	КонецЕсли;
	ЭлементыФормы.НадписьОбъекты.Значение = ТекстНадписи;
	ирОбщий.ТабличноеПолеОбновитьТекстыПодваловЛкс(ЭтаФорма, ЭлементыФормы.УдаляемыеОбъекты);
	
КонецПроцедуры

Процедура ПослеИзмененияСоставаКонтролируемыхОбъектов()
	
	ЭтаФорма.НеобходимоВыполнитьКонтроль = Истина;
	вДоступностьКнопок();
	вПодсчитатьИтогУдаляемыеОбъекты();
	
КонецПроцедуры

Процедура ПослеИзмененияСоставаКандидатов()
	
	Если Автосортировка Тогда
		ирОбщий.СостояниеЛкс("Сортировка кандидатов");
		УдаляемыеОбъекты.Сортировать("Метаданные, Представление");
		ирОбщий.СостояниеЛкс("");
	КонецЕсли; 
	ПослеИзмененияСоставаКонтролируемыхОбъектов();

КонецПроцедуры

// Подсчитывает количество Найденных, Удаляемых и НеУдаляемых ссылок на текущий объектов
//
Процедура вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты()
	
	СтрокаУдаляемыхОбъектов = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные;
	Если Ложь
		Или СтрокаУдаляемыхОбъектов = Неопределено 
		Или ТаблицаСсылок = Неопределено 
	Тогда
		ЭлементыФормы.НадписьСсылки.Значение = "";
	Иначе
		ЭлементыФормы.НадписьСсылки.Значение = "Найдено по объекту: " + СтрокаУдаляемыхОбъектов.Ссылок
		+ ",   Удаляемых: " + (СтрокаУдаляемыхОбъектов.Ссылок - СтрокаУдаляемыхОбъектов.НеУдаляемыхСсылок)
		+ ",   Неудаляемых: " + СтрокаУдаляемыхОбъектов.НеУдаляемыхСсылок;
	КонецЕсли;
	
КонецПроцедуры

// Показывает ссылки в таблице СсылкиНаУдаляемыеОбъекты
// на текущий удаляемый объект из таблицы УдаляемыеОбъекты
//
Процедура вПоказатьСсылкиНаУдаляемыйОбъект()
	
	СтрокаУдаляемыхОбъектов = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные;
	СсылкиНаКандидата.Очистить();
	Если ТаблицаСсылок <> Неопределено Тогда
		Если ОтборПоТекущемуКандидату Тогда
			Если СтрокаУдаляемыхОбъектов = Неопределено Тогда
				Возврат;
			КонецЕсли; 
			СтрокиСсылающихсяОбъектов = ТаблицаСсылок.НайтиСтроки(Новый Структура("Ссылка", СтрокаУдаляемыхОбъектов.Ссылка));
		Иначе
			СтрокиСсылающихсяОбъектов = ТаблицаСсылок;
		КонецЕсли; 
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СтрокиСсылающихсяОбъектов.Количество(), "Загрузка ссылающихся объектов");
		Для каждого СтрокаСсылающихсяОбъектов Из СтрокиСсылающихсяОбъектов Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			НоваяСтрока = СсылкиНаКандидата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСсылающихсяОбъектов);
			//НоваяСтрока.Ссылка = СтрокаСсылающихсяОбъектов.Ссылка;
			Если Не ОтборПоТекущемуКандидату Тогда 
				НоваяСтрока.МетаданныеКандидата = СтрокаСсылающихсяОбъектов.Ссылка.Метаданные().ПолноеИмя();
			КонецЕсли; 
			//НоваяСтрока.Данные = СтрокаСсылающихсяОбъектов.Данные;
			НоваяСтрока.Метаданные = СтрокаСсылающихсяОбъектов.Метаданные;
			//НоваяСтрока.ИндексКартинки = СтрокаСсылающихсяОбъектов.ИндексКартинки;
			ОбновитьПризнакЕстьВКандидиатахСсылкиНаКандидата(НоваяСтрока);
			НоваяСтрока.Блокирует = Не СтрокаСсылающихсяОбъектов.Удаляется И НеблокирующиеТипы.Найти(НоваяСтрока.Метаданные, "Метаданные") = Неопределено;
			Если Не СтандартныйПоискСсылок Тогда
				НоваяСтрока.уваОбъектСвязи = СтрокаСсылающихсяОбъектов.ОбъектСвязи;
			КонецЕсли; 
			НоваяСтрока.ГлобальныйИндексСсылки = ТаблицаСсылок.Индекс(СтрокаСсылающихсяОбъектов);
		КонецЦикла;
		СсылкиНаКандидата.Сортировать(мСтрокаПорядка);
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли; 
	вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты();
	
КонецПроцедуры

Процедура ОбновитьПризнакЕстьВКандидиатахСсылкиНаКандидата(Знач НоваяСтрока)
	
	НоваяСтрока.ЕстьВКандидатах = УдаляемыеОбъекты.Найти(НоваяСтрока.Данные, "Ссылка") <> Неопределено;

КонецПроцедуры 

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирОбщий.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Контроль" Основных действий формы,
//
Процедура ОсновныеДействияФормыКонтроль(Кнопка)
	
	Если Кнопка.Картинка <> ирКэш.КартинкаПоИмениЛкс("ирОстановить") Тогда
		Ответ = Вопрос("Выполнить после контроля удаление объектов, которые возможно удалить?", РежимДиалогаВопрос.ДаНет);
		ЗапуститьУдалениеПослеКонтроля = Ответ = КодВозвратаДиалога.Да;
		ирОбщий.СохранитьНастройкуФормыЛкс(ЭтаФорма);
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		СброситьКолонкуУдаляется();
	#КонецЕсли
	ПодключитьОбработчикОжидания("СброситьКолонкуУдаляется", 0.1, Истина);
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ЗапуститьУдалениеПослеКонтроля", ЗапуститьУдалениеПослеКонтроля);
	БлокируемыеЭлементыФормы = Новый Массив;
	БлокируемыеЭлементыФормы.Добавить(ЭлементыФормы.УдаляемыеОбъекты);
	#Если Сервер И Не Сервер Тогда
		КонтролироватьСсылкиНаКандидаты();
		КонтролироватьЗавершение();
	#КонецЕсли
	РезультатЗапуска = ирОбщий.ВыполнитьЗаданиеФормыЛкс("КонтролироватьСсылкиНаКандидаты", ПараметрыЗадания, ЭтаФорма, "КонтролироватьСсылки",,
		Кнопка, "КонтролироватьЗавершение",, БлокируемыеЭлементыФормы, Истина);
	Если РезультатЗапуска = Тип("ФоновоеЗадание") Тогда
		ЭтаФорма.ОтключитьОбработчикОжидания("СброситьКолонкуУдаляется");
	КонецЕсли; 

КонецПроцедуры

Процедура КонтролироватьЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		Если РезультатЗадания = Неопределено Тогда
			Возврат;
		КонецЕсли;
		СостояниеСтрок = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Ссылка");
		Если СостояниеЗадания <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатЗадания); 
			УдаляемыеОбъекты.Загрузить(РезультатЗадания.УдаляемыеОбъекты);
		КонецЕсли; 
		ПослеКонтроляСсылок();
		ЭтаФорма.ОтключитьОбработчикОжидания("СброситьКолонкуУдаляется");
		Если Истина
			И Не НеобходимоВыполнитьКонтроль
			И РезультатЗадания.ЗапуститьУдалениеПослеКонтроля
			И ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить.Доступность
		Тогда 
			ОсновныеДействияФормыУдалить(ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить);
		КонецЕсли;
		ОбновитьДоступныеДопПоля();
		ДополнительныеПоляПрочитатьПоля();
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, СостояниеСтрок);
		Если Истина
			И ВыводитьСообщения 
			И РезультатЗадания.ЗамерПоиска <> Неопределено 
			И РезультатЗадания.ЗамерПоиска.Количество() > 0 
		Тогда
			ирОбщий.ОткрытьЗначениеЛкс(РезультатЗадания.ЗамерПоиска,,, "Замер поиска " + ТекущаяДата(), Ложь);
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура СброситьКолонкуУдаляется()
	
	Для Каждого СтрокаУдаляемогоОбъекта из УдаляемыеОбъекты Цикл
		СтрокаУдаляемогоОбъекта.Удаляется = Ложь;
	КонецЦикла;

КонецПроцедуры

Процедура ОсновныеДействияФормыУдалить(Кнопка = Неопределено)
	
	БлокируемыеЭлементыФормы = Новый Массив;
	БлокируемыеЭлементыФормы.Добавить(ЭлементыФормы.УдаляемыеОбъекты);
	#Если Сервер И Не Сервер Тогда
		УдалитьОбъектыЛкс();
		УдалитьЗавершение();
	#КонецЕсли
	РезультатЗапуска = ирОбщий.ВыполнитьЗаданиеФормыЛкс("УдалитьОбъектыЛкс",, ЭтаФорма, "УдалитьОбъекты",, Кнопка, "УдалитьЗавершение",, БлокируемыеЭлементыФормы, Истина);
	Если РезультатЗапуска = Тип("ФоновоеЗадание") Тогда
		ЭтаФорма.ОтключитьОбработчикОжидания("СброситьКолонкуУдаляется");
	КонецЕсли; 

КонецПроцедуры

Процедура УдалитьЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		Если РезультатЗадания = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		СостояниеСтрок = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Ссылка");
		Если СостояниеЗадания <> Неопределено Тогда
			УдаляемыеОбъекты.Загрузить(РезультатЗадания.УдаляемыеОбъекты);
		КонецЕсли; 
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, СостояниеСтрок);
		вДоступностьКнопок();
		вПодсчитатьИтогУдаляемыеОбъекты();
		Если ЗначениеЗаполнено(РезультатЗадания.КоличествоУдалено) Тогда
			ТипыУдаленныхОбъектов = РезультатЗадания.ТипыУдаленныхОбъектов;
			ТипыУдаленныхОбъектов = ирОбщий.ВыгрузитьСвойствоКоллекцииЛкс(ТипыУдаленныхОбъектов, "Ключ");
			ирОбщий.ОповеститьОЗаписиОбъектаЛкс(ТипыУдаленныхОбъектов, ЭтаФорма, Истина);
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

// Процедура вызывается при изменении флажков:
//	ПоказыватьОбъектыКоторыеМожноУдалить,ПоказыватьОбъектыКоторыеНельзяУдалить
//
Процедура ПоказыватьОбъектыПриИзменении(Элемент)
	
	Если Истина
		И Не ПоказыватьОбъектыКоторыеМожноУдалить
		И Не ПоказыватьОбъектыКоторыеНельзяУдалить
	Тогда
		Если Элемент = ЭлементыФормы.ПоказыватьОбъектыКоторыеМожноУдалить Тогда
			ЭтаФорма.ПоказыватьОбъектыКоторыеНельзяУдалить = Истина;
		Иначе
			ЭтаФорма.ПоказыватьОбъектыКоторыеМожноУдалить = Истина;
		КонецЕсли; 
	КонецЕсли; 
	ОтборСтрок = ЭлементыФормы.УдаляемыеОбъекты.ОтборСтрок;
	Если ПоказыватьОбъектыКоторыеМожноУдалить И ПоказыватьОбъектыКоторыеНельзяУдалить тогда
		ОтборСтрок.Удаляется.Использование = Ложь;
		ОтборСтрок.Разрешен.Использование = Ложь;
	ИначеЕсли ПоказыватьОбъектыКоторыеНельзяУдалить тогда
		ОтборСтрок.Удаляется.Установить(Ложь, Истина);
		ОтборСтрок.Разрешен.Использование = Ложь;
	Иначе
		ОтборСтрок.Удаляется.Установить(Истина, Истина);
		ОтборСтрок.Разрешен.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается при изменении флажков:
//	ПоказыватьСсылкиУдаляемых,ПоказыватьСсылкиНеудаляемых
//
Процедура ПоказыватьСсылкиПриИзменении(Элемент)
	
	Если Истина
		И Не ПоказыватьСсылкиУдаляемых
		И Не ПоказыватьСсылкиНеудаляемых
	Тогда
		Если Элемент = ЭлементыФормы.ПоказыватьСсылкиНеудаляемых Тогда
			ЭтаФорма.ПоказыватьСсылкиУдаляемых = Истина;
		Иначе
			ЭтаФорма.ПоказыватьСсылкиНеудаляемых = Истина;
		КонецЕсли; 
	КонецЕсли; 
	Если Истина
		И ПоказыватьСсылкиУдаляемых
		И ПоказыватьСсылкиНеудаляемых
	Тогда
		ЭлементыФормы.СсылкиНаКандидата.ОтборСтрок.Блокирует.Использование = Ложь;
	Иначе 
		ЭлементыФормы.СсылкиНаКандидата.ОтборСтрок.Блокирует.Установить(Не ПоказыватьСсылкиУдаляемых, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Обновить" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовЗаполнить(Кнопка)
	Если ЭлементыФормы.УдаляемыеОбъекты.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли; 
	ЗаполнитьПомеченныеНаУдаление();
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Установить Флажки" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Разрешен", Истина,,, УдаляемыеОбъекты.Найти(Истина, "Предопределенный") <> Неопределено);
	//ПослеИзмененияСоставаКонтролируемыхОбъектов();
	
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Снять Флажки" командной панели "Удаляемые Объекты"
//
Процедура КоманднаяПанельУдаляемыхОбъектовСнятьФлажки(Кнопка = Неопределено)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Разрешен", Ложь);
	//ПослеИзмененияСоставаКонтролируемыхОбъектов();
	
КонецПроцедуры

// Процедура вызывается при активизации строки табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриАктивизацииСтроки(Элемент)
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если ОтборПоТекущемуКандидату Тогда
		вПоказатьСсылкиНаУдаляемыйОбъект();
	Иначе
		вПодсчитатьИтогСсылкиНаУдаляемыеОбъекты();
	КонецЕсли; 
КонецПроцедуры

// Процедура вызывается при выоде строки табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Картинка;
	ЯчейкаКартинки.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
	ЯчейкаКартинки.ОтображатьКартинку = Истина;
	Если ТаблицаСсылок <> Неопределено и ДанныеСтроки.Разрешен Тогда
		//Если ДанныеСтроки.Удаляется Тогда
			ОформлениеСтроки.ЦветФона = Новый Цвет(240, 255, 240);
		//КонецЕсли;
	КонецЕсли;
	Если ДанныеСтроки.Предопределенный Тогда
		ОформлениеСтроки.Ячейки.Разрешен.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
КонецПроцедуры

// Процедура вызывается перед началом изменения табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущаяКолонка <> ЭлементыФормы.УдаляемыеОбъекты.Колонки.Разрешен Тогда
		ФормаОбъекта = ЭлементыФормы.УдаляемыеОбъекты.ТекущиеДанные.ссылка.ПолучитьФорму(,,);
		ФормаОбъекта.Открыть();
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

// Процедура вызывается при изменении флажка табличного поля "Удаляемые объекты"
//
Процедура УдаляемыеОбъектыПриИзмененииФлажка(Элемент, Колонка)
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
КонецПроцедуры

// Процедура вызывается при выоде строки табличного поля "Ссылки на удаляемые объекты"
//
Процедура СсылкиНаУдаляемыеОбъектыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Ячейки = ОформлениеСтроки.Ячейки;
	Ячейки.Блокирует.ОтображатьТекст = Ложь;
	Если Не ДанныеСтроки.Блокирует Тогда
		Ячейки.Блокирует.УстановитьКартинку(ирКэш.КартинкаПоИмениЛкс("ирТестирование"));
	Иначе
		Ячейки.Блокирует.УстановитьКартинку(ирКэш.КартинкаПоИмениЛкс("ирИсключение"));
	КонецЕсли;
	Ячейки.ИндексКартинки.ОтображатьКартинку = Истина;
	Если ДанныеСтроки.ИндексКартинки > -1 Тогда 
		Ячейки.ИндексКартинки.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
	КонецЕсли;
	КлючОбъекта = КлючСсылающегосяОбъекта(ДанныеСтроки);
	Если ТипЗнч(КлючОбъекта) <> Тип("Структура") Тогда
		Ячейки.Данные.Текст = ирОбщий.ПредставлениеКлючаСтрокиБДЛкс(КлючОбъекта, Ложь);
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовПометитьУказанноеКоличество(Кнопка)
	
	Если ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
	// запрашивает сколько пометить и помечает от текущей строки
	Колво = 300;
	Если Не ВвестиЧисло(Колво,"Количество помечаемых", 6, 0) Тогда
		Возврат;
	КонецЕсли;
	
	ПометитьУказанноеКоличествоКандидатов(Колво);
	ПослеИзмененияСоставаКонтролируемыхОбъектов();
	
КонецПроцедуры

Процедура ПометитьУказанноеКоличествоКандидатов(Знач Колво, НачальнаяСтрока = Неопределено)
	
	Если НачальнаяСтрока = Неопределено Тогда
		НачальнаяСтрока = ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока;
	КонецЕсли; 
	ТаблицаОтборанных = ирОбщий.ПостроительТабличногоПоляСОтборомКлиентаЛкс(ЭлементыФормы.УдаляемыеОбъекты).Результат.Выгрузить();
	ТаблицаОтборанных.Индексы.Добавить("Ссылка");
	Для НомерСтроки = НачальнаяСтрока.НомерСтроки ПО УдаляемыеОбъекты.Количество() Цикл
		СтрокаУдаляемогоОбъекта = УдаляемыеОбъекты[НомерСтроки - 1];
		Если ТаблицаОтборанных.Найти(СтрокаУдаляемогоОбъекта.Ссылка, "Ссылка") <> Неопределено Тогда
			СтрокаУдаляемогоОбъекта.Разрешен = Истина;
			Колво = Колво - 1;
		КонецЕсли;
		Если Колво <= 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыРедакторОбъектаБД(Кнопка = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.СсылкиНаКандидата.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючОбъекта = КлючСсылающегосяОбъекта(ТекущаяСтрока);
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъекта, ТекущаяСтрока.Ссылка);

КонецПроцедуры

Функция КлючСсылающегосяОбъекта(Знач ТекущаяСтрока)
	
	ТипМетаданных = ирОбщий.ПервыйФрагментЛкс(ТекущаяСтрока.Метаданные);
	Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипМетаданных) Тогда
		КлючОбъекта = ТекущаяСтрока.Данные;
	ИначеЕсли ирОбщий.ЛиКорневойТипКонстантыЛкс(ТипМетаданных) Тогда
		КлючОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(ТекущаяСтрока.Метаданные);
	Иначе // Регистр сведений
		КлючОбъекта = ТаблицаСсылок[ТекущаяСтрока.ГлобальныйИндексСсылки].КлючЗаписиРегистраСведений;
	КонецЕсли;
	Возврат КлючОбъекта;

КонецФункции

Процедура УдаляемыеОбъектыСсылкаПриИзменении(Элемент)
	
	ОбновитьСтрокуУдаляемогоОбъекта(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭлементыФормы.СсылкиНаКандидата.Колонки.Блокирует.КартинкиСтрок = Новый Картинка; // Отключаем стандартную картинку для типа Булево
	СоставНастройкиФормы = Новый СписокЗначений;
	СоставНастройкиФормы.Добавить("Кандидаты", "Кандидаты на удаление", Истина);
	СоставНастройкиФормы.Добавить("Прочее", "Прочее", Ложь);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма,,, Новый Структура("ПриОткрытии"), "dor", СоставНастройкиФормы);
	ПослеИзмененияСоставаКандидатов();
	Если УдаляемыеОбъекты.Количество() = 0 Тогда
		Ответ = Вопрос("Поиск помеченных на удаление может занять продолжительное время!
		|Выполнить его сейчас?", РежимДиалогаВопрос.ДаНет, 10);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаполнитьПомеченныеНаУдаление();
		КонецЕсли;
	КонецЕсли; 
	НастройкиДопПолей = ирОбщий.ВосстановитьЗначениеЛкс("ирУдалениеОбъектовСКонтролемСсылок.ДопПоля");
	Если НастройкиДопПолей <> Неопределено Тогда
		КомпоновщикДопПолей.ЗагрузитьНастройки(НастройкиДопПолей);
	КонецЕсли;
	ЭлементыФормы.ПаузаМеждуУдалениями.СписокВыбора.Добавить(5);
	ЭлементыФормы.ПаузаМеждуУдалениями.СписокВыбора.Добавить(10);
	ЭлементыФормы.ПаузаМеждуУдалениями.СписокВыбора.Добавить(20);
	ОбновитьНеблокирующиеТипы();
	ирОбщий.УстановитьДоступностьВыполненияНаСервереЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовПодбор(Кнопка)
	
	Если ЭлементыФормы.УдаляемыеОбъекты.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли; 
	Если ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока <> Неопределено Тогда
		НачальноеЗначение = ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока.Ссылка;
	КонецЕсли; 
	ирОбщий.ОткрытьПодборСВыборомТипаЛкс(ЭлементыФормы.УдаляемыеОбъекты,, НачальноеЗначение);
	
КонецПроцедуры

Процедура УдаляемыеОбъектыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Массив = Новый Массив();
		Массив.Добавить(ВыбранноеЗначение);
		ВыбранноеЗначение = Массив;
	КонецЕсли;
	Если ДобавитьМассивОбъектовВУдаляемыеОбъекты(ВыбранноеЗначение, ЭтаФорма, Истина) Тогда 
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 

КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыДобавитьВКандидаты(Кнопка)
	
	ДобавитьМассивОбъектовВУдаляемыеОбъекты(ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки, ЭтаФорма,, Истина);
	Для Каждого ВыбраннаяСтрока Из ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки Цикл
		ОбновитьПризнакЕстьВКандидиатахСсылкиНаКандидата(ВыбраннаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыНайтиСсылкуВУдаляемыхОбъектах(Кнопка)
	
	Если ЭлементыФормы.СсылкиНаКандидата.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаУдаляемого = УдаляемыеОбъекты.Найти(ЭлементыФормы.СсылкиНаКандидата.ТекущаяСтрока.Данные, "Ссылка");
	Если СтрокаУдаляемого <> Неопределено Тогда
		ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока = СтрокаУдаляемого;
	Иначе
		Предупреждение("Данные не найдены в удаляемых объектах");
	КонецЕсли; 
	
КонецПроцедуры

Процедура СсылкиНаУдаляемыеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.Данные = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		КП_СсылкиНаУдаляемыеОбъектыРедакторОбъектаБД();
	Иначе
		//ФормаОбъекта = ВыбраннаяСтрока.Данные.ПолучитьФорму(,,);
		//ФормаОбъекта.Открыть();
		КлючОбъекта = КлючСсылающегосяОбъекта(ВыбраннаяСтрока);
		ОткрытьЗначение(КлючОбъекта);
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовРедакторОбъектаБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.УдаляемыеОбъекты.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ТекущаяСтрока.Ссылка);
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыКонсольОбработки(Кнопка)
	
	МассивКлючей = Новый Массив;
	Для Каждого ВыбраннаяСтрока Из ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки Цикл
		МассивКлючей.Добавить(КлючСсылающегосяОбъекта(ВыбраннаяСтрока));
	КонецЦикла;
	ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(МассивКлючей);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура НеблокирующиеТипыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	РедактироватьНеблокирующиеТипы();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура РедактироватьНеблокирующиеТипы()
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", , ЭтаФорма);
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", НеблокирующиеТипы.ВыгрузитьКолонку("Метаданные"));
	лСтруктураПараметров.Вставить("ОтображатьКонстанты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПоследовательности", Истина);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	Если ЭлементыФормы.НеблокирующиеТипы.ТекущаяСтрока <> Неопределено Тогда
		лСтруктураПараметров.Вставить("ТекущаяСтрока", ЭлементыФормы.НеблокирующиеТипы.ТекущаяСтрока.Метаданные);
	КонецЕсли; 
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	РезультатФормы = Форма.ОткрытьМодально();
	Если ТипЗнч(РезультатФормы) = Тип("Массив") Тогда
		УстановитьНеблокирующиеТипы(РезультатФормы);
		ОбновитьНеблокирующиеТипы();
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьНеблокирующиеТипы()
	
	//Для Каждого ОбъектМД Из Метаданные.Последовательности Цикл
	//	ПолноеИмяМД = ОбъектМД.ПолноеИмя();
	//	Если НеблокирующиеТипы.Найти(ПолноеИмяМД, "Метаданные") = Неопределено Тогда
	//		СтрокаНеблокирующегоТипа = НеблокирующиеТипы.Добавить();
	//		СтрокаНеблокирующегоТипа.Метаданные = ПолноеИмяМД;
	//	КонецЕсли; 
	//КонецЦикла;
	Если ирКэш.НомерВерсииБСПЛкс() >= 203 Тогда
		ИменаМД = ирОбщий.НеблокирующиеМетаданныеБСПЛкс();
		Для Каждого ПолноеИмяМД Из ИменаМД Цикл
			Если СтрЧислоВхождений(ПолноеИмяМД, ".") > 1 Тогда
				Продолжить;
			КонецЕсли; 
			Если НеблокирующиеТипы.Найти(ПолноеИмяМД, "Метаданные") = Неопределено Тогда
				СтрокаНеблокирующегоТипа = НеблокирующиеТипы.Добавить();
				СтрокаНеблокирующегоТипа.Метаданные = ПолноеИмяМД;
				СтрокаНеблокирующегоТипа.Игнорировать = Истина;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 

КонецПроцедуры

Процедура КПНеблокирующиеТипыИзменить(Кнопка)
	
	РедактироватьНеблокирующиеТипы();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыДобавитьВНеблокирующие(Кнопка)
	
	Ответ = Вопрос("Вы действитель хотите добавить типы выбранных объектов в неблокирующие типы?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	Для Каждого ВыбраннаяСтрока Из ЭлементыФормы.СсылкиНаКандидата.ВыделенныеСтроки Цикл
		ДобавитьНеблокирующийТип(ВыбраннаяСтрока.Метаданные);
	КонецЦикла;
	НеблокирующиеТипы.Сортировать("Метаданные");
	ПослеИзмененияСоставаКандидатов();
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовОтобратьПоТипам(Кнопка)
	
	ирОбщий.ИзменитьОтборКлиентаПоМетаданнымЛкс(ЭлементыФормы.УдаляемыеОбъекты);
	
КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыОтобратьПоТипам(Кнопка)
	
	Если ЭлементыФормы.СсылкиНаКандидата.ТекущаяКолонка = ЭлементыФормы.СсылкиНаКандидата.Колонки.МетаданныеКандидата Тогда
		ИмяКолонкиМетаданных = ЭлементыФормы.СсылкиНаКандидата.ТекущаяКолонка.Данные;
	Иначе
		ИмяКолонкиМетаданных = ЭлементыФормы.СсылкиНаКандидата.Колонки.Метаданные.Данные;
	КонецЕсли;
	ирОбщий.ИзменитьОтборКлиентаПоМетаданнымЛкс(ЭлементыФормы.СсылкиНаКандидата, ИмяКолонкиМетаданных);

КонецПроцедуры

Процедура НеблокирующиеТипыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.Метаданные.ИндексКартинки = ирОбщий.ИндексКартинкиТипаТаблицыБДЛкс(ирОбщий.ПервыйФрагментЛкс(ДанныеСтроки.Метаданные));
	ОформлениеСтроки.Ячейки.Метаданные.ОтображатьКартинку = Истина;

КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовОчистить(Кнопка)
	
	Если ЭлементыФормы.УдаляемыеОбъекты.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Вы уверены, что хотите очистить список кандидатов?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		УдаляемыеОбъекты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельУдаляемыхОбъектовОбработкаОбъектов(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭтаФорма.ЭлементыФормы.УдаляемыеОбъекты, "Ссылка");
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.СохранитьЗначениеЛкс("ирУдалениеОбъектовСКонтролемСсылок.ДопПоля", КомпоновщикДопПолей.ПолучитьНастройки());
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КП_СсылкиНаУдаляемыеОбъектыОтборПоТекущемуКандидату(Кнопка)
	
	ОтборПоТекущемуКандидату = Не Кнопка.Пометка;
	Кнопка.Пометка = ОтборПоТекущемуКандидату;
	ЭлементыФормы.СсылкиНаКандидата.Колонки.Ссылка.Видимость = Не ОтборПоТекущемуКандидату;
	ЭлементыФормы.СсылкиНаКандидата.Колонки.МетаданныеКандидата.Видимость = Не ОтборПоТекущемуКандидату;
	вПоказатьСсылкиНаУдаляемыйОбъект();
	
КонецПроцедуры

Процедура ОбновитьДоступныеДопПоля()
	
	ирОбщий.ОбновитьДоступныеПоляДляДополнительныхПолейЛкс(ТаблицаСсылок, КомпоновщикДопПолей, ЭлементыФормы.ДоступныеПоляДополнительныхПолей);

КонецПроцедуры

Процедура ДополнительныеПоляПрочитатьПоля(Кнопка = Неопределено)
	
	// Это надо делать в самом конце потока кода, чтобы пользователь мог прервать этот долгий процесс
	мСтрокаПорядка = ирОбщий.ПрочитатьДополнительныеПоляСсылающихсяОбъектовЛкс(ЭлементыФормы.СсылкиНаКандидата, КомпоновщикДопПолей, ТаблицаСсылок); 
	вПоказатьСсылкиНаУдаляемыйОбъект();

КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирОбщий.ПриПолученииДанныхДоступныхПолейКомпоновкиЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры // ПриПолученииДанныхДоступныхПолей()

Процедура КоманднаяПанельУдаляемыхОбъектовПараметрыЗаписи(Кнопка)
	
	ирОбщий.ОткрытьОбщиеПараметрыЗаписиЛкс(Истина);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыКонтрольИУдалениеПорциями(Кнопка)
	
	РазмерПорции = 1000;
	Ответ = Вопрос("Выполнить порционный контроль и удаление ВСЕХ (пометка игнорируется!) кандидатов по " + XMLСтрока(РазмерПорции) + " штук в порции?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.Отмена Тогда
		КоличествоПорций = УдаляемыеОбъекты.Количество() / РазмерПорции;
		Если Цел(КоличествоПорций) < КоличествоПорций Тогда
			КоличествоПорций = КоличествоПорций + 1;
		КонецЕсли; 
		НачальноеКоличествоКандидатов = УдаляемыеОбъекты.Количество();
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоПорций, "Порции");
		Для Счетчик = 1 По КоличествоПорций Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.УдаляемыеОбъекты, "Разрешен", Ложь);
			ПометитьУказанноеКоличествоКандидатов(РазмерПорции, УдаляемыеОбъекты[(Счетчик - 1) * РазмерПорции - (НачальноеКоличествоКандидатов - УдаляемыеОбъекты.Количество())]);
			ПодключитьОбработчикОжидания("СброситьКолонкуУдаляется", 0.1, Истина);
			вКонтроль();
			ОтключитьОбработчикОжидания("СброситьКолонкуУдаляется");
			Если Истина
				И Не НеобходимоВыполнитьКонтроль
				И ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить.Доступность
			Тогда 
				ОсновныеДействияФормыУдалить();
			КонецЕсли;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		ирОбщий.СообщитьЛкс("Удалено объектов всего " + XMLСтрока(НачальноеКоличествоКандидатов - УдаляемыеОбъекты.Количество()) + "");
	КонецЕсли; 
	
КонецПроцедуры

Процедура НеблокирующиеТипыПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);

КонецПроцедуры

Процедура СсылкиНаКандидатаПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);

КонецПроцедуры

Процедура УдаляемыеОбъектыРазрешенПриИзменении(Элемент)
	
	ПослеИзмененияСоставаКонтролируемыхОбъектов();

КонецПроцедуры

Процедура СсылкиНаКандидатаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура НеблокирующиеТипыПриАктивизацииСтроки(Элемент)
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.ЛюбаяСсылкаБлокируетУдаление.Доступность = Не СтандартныйПоискСсылок;
	
КонецПроцедуры

Процедура СтандартныйПоискСсылокПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирУдалениеОбъектовСКонтролемСсылок.Форма.Форма");

#Если Сервер И Не Сервер Тогда
	ПриПолученииДанныхДоступныхПолей();
#КонецЕсли
ирОбщий.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоляДополнительныхПолей);
ЭтаФорма.ПоказыватьОбъектыКоторыеМожноУдалить = Истина;
ЭтаФорма.ПоказыватьОбъектыКоторыеНельзяУдалить = Истина;
ЭтаФорма.ПоказыватьСсылкиУдаляемых = Истина;
ЭтаФорма.ПоказыватьСсылкиНеудаляемых = Истина;
ЭтаФорма.ВыводитьСообщения = Истина;
ЭтаФорма.ОтборПоТекущемуКандидату = Истина;
ЭтаФорма.Автосортировка = Истина;

