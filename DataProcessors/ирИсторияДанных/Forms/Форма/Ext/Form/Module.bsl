﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ИмяПредставление, Форма.МаксКоличествоВерсий, Форма.НачалоПериода, Форма.КонецПериода";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	ИмяПредставлениеПриИзменении();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ПроверятьНаличиеВерсийПриИзменении();
	УстановитьОтборПоРеквизитам(ОтборПоРеквизитам);
	КПТипыОбновить();
	
КонецПроцедуры

Процедура КПТипыОбновить(Кнопка = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		ОбновитьТипыЗавершение();
	#КонецЕсли
	ирОбщий.ИтогиИсторииДанныхПоТипамЛкс(Типы.ВыгрузитьКолонки(), ВычислятьПоля, ВычислятьКоличествоВерсий, ОтборВерсий(), МаксКоличествоВерсий,
		ЭтаФорма, ЭлементыФормы.КПТипы.Кнопки.Обновить, "ОбновитьТипыЗавершение",, Кнопка = Неопределено);
	
КонецПроцедуры

Процедура ОбновитьТипыЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено, ПараметрыЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		СостояниеСтрокПоля = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Поля, "ИмяПоля");
		СостояниеСтрокВерсии = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Версии, "Данные, НомерВерсии");
		СостояниеСтрокТипы= ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Типы, "ПолноеИмяМД");
		Поля.Очистить();
		Версии.Очистить();
		ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(РезультатЗадания, Типы,,, Истина);
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Типы, СостояниеСтрокТипы);
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Версии, СостояниеСтрокВерсии);
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Поля, СостояниеСтрокПоля);
	КонецЕсли; 

КонецПроцедуры

Процедура ИмяПредставлениеПриИзменении(Элемент = Неопределено)
	
	ТабличноеПоле = ЭлементыФормы.Типы;
	ТабличноеПоле.Колонки.ПредставлениеМД.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяМД.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(СтараяКолонка.Имя, "МД") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеМД.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеМД;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяМД;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ТабличноеПоле = ЭлементыФормы.Поля;
	ТабличноеПоле.Колонки.ПредставлениеПоля.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяПоля.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "поля") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеПоля.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеПоля;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяПоля;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТипыПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	КП_ОбновитьВерсии();
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущаяСтрока = ЭлементыФормы.Типы.ТекущаяСтрока;
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ТекущаяСтрока.ПолноеИмяМД);
	Поля.Загрузить(ИспользованиеПолей(ОбъектМД,, Истина));
	
КонецПроцедуры

Процедура ТипыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОформлениеСтроки.Ячейки.ТипМетаданных.УстановитьКартинку(ирОбщий.ПолучитьКартинкуКорневогоТипаЛкс(ДанныеСтроки.ТипМетаданных));
	Если ДанныеСтроки.ЕстьДоступ = Ложь Тогда 
		ОформлениеСтроки.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
	Ячейки = ОформлениеСтроки.Ячейки;
	Если НадоСериализоватьКлюч() Тогда
		Попытка
			КлючЗаписи = ЗначениеИзСтрокиВнутр(Ячейки.Данные.Текст);
		Исключение
			// Некоторые большие ключи регистров в сериализованном виде не умещаются в 1024 символа
			КлючЗаписи = "<Ключ записи регистра обрезан и не может быть восстановлен>";
		КонецПопытки; 
		Ячейки.Данные.Текст = ирОбщий.ПредставлениеКлючаСтрокиБДЛкс(КлючЗаписи, Ложь);
	КонецЕсли;

КонецПроцедуры

Процедура КП_ДанныеРедакторОбъектаБД(Кнопка = Неопределено, НайтиВерсию = Неопределено)
	
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючОбъектаВерсии = КлючОбъектаВерсии(ТекущиеДанные);
	Если КлючОбъектаВерсии = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаРедактора = ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъектаВерсии);
	Если НайтиВерсию <> Ложь Тогда
		ФормаРедактора.НайтиВерсию(ТекущиеДанные.НомерВерсии);
	КонецЕсли; 
	
КонецПроцедуры

Функция КлючОбъектаВерсии(Знач СтрокаТаблицыВерсий = Неопределено)
	
	Если СтрокаТаблицыВерсий = Неопределено Тогда
		СтрокаТаблицыВерсий = ЭлементыФормы.Версии.ТекущиеДанные;
	КонецЕсли; 
	Если СтрокаТаблицыВерсий = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если Не НадоСериализоватьКлюч() Тогда
		СсылкаОбъекта = СтрокаТаблицыВерсий.Данные;
	Иначе
		Попытка
			СсылкаОбъекта = ЗначениеИзСтрокиВнутр(СтрокаТаблицыВерсий.Данные);
		Исключение
			СсылкаОбъекта = Неопределено;
		КонецПопытки; 
	КонецЕсли;
	Возврат СсылкаОбъекта;

КонецФункции

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ирКэш.НомерРежимаСовместимостиЛкс() < 803011 Тогда
		ирОбщий.СообщитьЛкс("Инструмент доступен только в режиме совместимости 8.3.11 и выше",,, Истина);
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Версии.Колонки.Данные Тогда
		КлючОбъектаВерсии = КлючОбъектаВерсии(ВыбраннаяСтрока);
		Если КлючОбъектаВерсии = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ирОбщий.ЛиКлючЗаписиРегистраЛкс(КлючОбъектаВерсии) Тогда
			ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.типы.ТекущаяСтрока.ПолноеИмяМД);
			#Если Сервер И Не Сервер Тогда
				ОбъектМД = Метаданные.РегистрыСведений.ABCКлассификацияПокупателей;
			#КонецЕсли
			Если ОбъектМД.ОсновнаяФормаЗаписи <> Неопределено Тогда
				ОткрытьЗначение(КлючОбъектаВерсии);
			Иначе
				КП_ДанныеРедакторОбъектаБД(, Ложь);
			КонецЕсли; 
		Иначе
			ОткрытьЗначение(КлючОбъектаВерсии);
		КонецЕсли; 
	Иначе
		КП_ДанныеОткрытьОтчетПоВерсии();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельИТС(Кнопка)
	
	ирОбщий.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000001938");
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельТипыОткрытьОбъектМетаданных(Кнопка)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельПараметрыЗаписи(Кнопка)
	
	ирОбщий.ОткрытьОбщиеПараметрыЗаписиЛкс();
	
КонецПроцедуры

Процедура ТипыПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);
	
КонецПроцедуры

Процедура КП_ОбновитьВерсии(Кнопка = Неопределено)
	
	СостояниеСтрокВерсии = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Версии, "Данные, НомерВерсии"); 
	Версии.Очистить();
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	Если ЭлементыФормы.Типы.ТекущаяСтрока.ЕстьДоступ = Ложь Тогда
		ирОбщий.СообщитьЛкс("Нет прав на чтение истории данных """ + ОбъектМД.ПолноеИмя() + """", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли; 
	НадоСериализоватьКлюч = НадоСериализоватьКлюч();
	Для Каждого СтрокаВыборки Из ВыбратьВерсии(ИсторияДанныхМоя, ОбъектМД) Цикл
		СтрокаВерсии = Версии.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаВерсии, СтрокаВыборки); 
		Если НадоСериализоватьКлюч Тогда
			СтрокаВерсии.Данные = ЗначениеВСтрокуВнутр(СтрокаВыборки.Данные);
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Версии, СостояниеСтрокВерсии);
	
КонецПроцедуры

Функция НадоСериализоватьКлюч()
	
	НадоСериализоватьКлюч = Ложь
		Или ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ТипМетаданных)
		Или ирОбщий.ЛиКорневойТипКонстантыЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ТипМетаданных);
	Возврат НадоСериализоватьКлюч;

КонецФункции

Функция ВыбратьВерсии(Знач ИсторияДанныхМоя, Знач ОбъектМД)
	
	ОтборВерсий = ОтборВерсий();
	ОтборВерсий.Вставить("Метаданные", ОбъектМД);
	Возврат ИсторияДанныхМоя.ВыбратьВерсии(ОтборВерсий,,, МаксКоличествоВерсий);

КонецФункции

Функция ОтборВерсий()
	
	ОтборВерсий = Новый Структура;
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		ОтборВерсий.Вставить("ДатаНачала", НачалоПериода);
	КонецЕсли; 
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		ОтборВерсий.Вставить("ДатаОкончания", КонецПериода);
	КонецЕсли; 
	Если ОтборПоРеквизитам Тогда
		МассивРеквизитов = Новый Массив;
		Для Каждого СтрокаРеквизита Из ЭлементыФормы.Поля.ВыделенныеСтроки Цикл
			МассивРеквизитов.Добавить(СтрокаРеквизита.ИмяПоля);
		КонецЦикла;
		Если МассивРеквизитов.Количество() > 0 Тогда
			ОтборВерсий.Вставить("ИзменениеЗначенийПолей", МассивРеквизитов);
		КонецЕсли; 
	КонецЕсли;
	Возврат ОтборВерсий;

КонецФункции

Процедура МаксКоличествоВерсийПриИзменении(Элемент)
	
	КП_ОбновитьВерсии();

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОбновитьИсторию(Кнопка)
	
	ирОбщий.ОбновитьИсториюДанныхЛкс(ЭтаФорма, Кнопка, "ОбновитьИсториюЗавершение");
	
КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирОбщий.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ОбновитьИсториюЗавершение(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено, ПараметрыЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		КПТипыОбновить();
	КонецЕсли; 

КонецПроцедуры

Процедура КП_ДанныеНайтиВФормеСпискаВерсий(Кнопка)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирОбщий.ОткрытьСистемнуюФормуСписокВерсийЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура КП_ДанныеОткрытьОтчетПоВерсии(Кнопка = Неопределено)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирОбщий.ОткрытьСистемнуюФормуОтчетПоВерсииЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура ПоляПриИзмененииФлажка(Элемент, Колонка)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Поля.Очистить();
		Возврат;
	КонецЕсли; 
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);
	
КонецПроцедуры

Процедура ПроверятьНаличиеВерсийПриИзменении(Элемент = Неопределено)
	
	Если ВычислятьКоличествоВерсий Тогда
		КПТипыОбновить();
		ЭлементыФормы.Типы.Колонки.КоличествоВерсий.Видимость = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиТипаЛкс(мОписанияТиповПолей.Найти(ДанныеСтроки.ИмяПоля, "Имя").ОписаниеТипов);
	Если ИндексКартинки <> Неопределено Тогда
		ОформлениеСтроки.Ячейки.ОписаниеТипов.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.ОписаниеТипов.ИндексКартинки = ИндексКартинки;
	КонецЕсли; 
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ИзменитьИспользованиеУВыделенныхИлиВсехСтрокПолей(Знач НовоеЗначениеПометки)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТабличноеПоле = ЭлементыФормы.Поля;
	ВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() <= 1 Тогда
		ВыделенныеСтроки = ТабличноеПоле.Значение; 
		Попытка
			ОтборСтрок = ТабличноеПоле.ОтборСтрок;
		Исключение
		КонецПопытки; 
		Если ОтборСтрок <> Неопределено Тогда
			Построитель = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(ТабличноеПоле);
			#Если Сервер И Не Сервер Тогда
				Построитель = Новый ПостроительЗапроса;
			#КонецЕсли
			Построитель.ВыбранныеПоля.Очистить();
			Построитель.ВыбранныеПоля.Добавить("ИмяПоля");
			НомераОтобранныхСтрок = Построитель.Результат.Выгрузить();
			НомераОтобранныхСтрок.Индексы.Добавить("ИмяПоля");
		КонецЕсли; 
	КонецЕсли; 
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
	Если НастройкиИстории = Неопределено Тогда 
		НастройкиИстории = Новый ("НастройкиИсторииДанных");
	КонецЕсли; 
	ИспользованиеПолей = Новый Соответствие;
	Для каждого СтрокаПоля из ВыделенныеСтроки Цикл
		Если Истина
			И НомераОтобранныхСтрок <> Неопределено
			И НомераОтобранныхСтрок.Найти(СтрокаПоля.ИмяПоля, "ИмяПоля") = Неопределено
		Тогда
			// Строка не отвечает отбору
			Продолжить;
		КонецЕсли;
		СтрокаПоля.Использование = НовоеЗначениеПометки;
		Если СтрокаПоля.ИспользованиеВМетаданных <> СтрокаПоля.Использование Тогда
			ИспользованиеПолей.Вставить(СтрокаПоля.ИмяПоля, СтрокаПоля.Использование);
		КонецЕсли; 
	КонецЦикла;
	НастройкиИстории.ИспользованиеПолей = ИспользованиеПолей;
	ИсторияДанныхМоя.УстановитьНастройки(ОбъектМД, НастройкиИстории);
	ОбновитьПредставлениеПолейВСтрокеТипа(НастройкиИстории, ОбъектМД, ЭлементыФормы.Типы.ТекущаяСтрока, ВычислятьПоля);
	ТабличноеПоле.ОбновитьСтроки();

КонецПроцедуры

Процедура ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, Знач ПарнаяДата, Знак)
	
	СимволЗнака = ?(Знак = 1, "+", "-");
	ИмяПарнойДаты = ?(Знак = 1, "Начало", "Конец");
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(1*60,          ИмяПарнойДаты + " " + СимволЗнака + " 1 минута");
	СписокВыбора.Добавить(10*60,       ИмяПарнойДаты + " " + СимволЗнака + " 10 минут");
	СписокВыбора.Добавить(2*60*60,       ИмяПарнойДаты + " " + СимволЗнака + " 2 часа");
	СписокВыбора.Добавить(1*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 1 день");
	СписокВыбора.Добавить(7*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 7 дней");
	СписокВыбора.Добавить(30*24*60*60,   ИмяПарнойДаты + " " + СимволЗнака + " 30 дней");
	РезультатВыбора = ЭтаФорма.ВыбратьИзСписка(СписокВыбора, Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Если Знак = -1 Тогда
			Если Не ЗначениеЗаполнено(ПарнаяДата) Тогда
				ПарнаяДата = ТекущаяДата();
			КонецЕсли; 
		КонецЕсли; 
		Элемент.Значение = ПарнаяДата + Знак * РезультатВыбора.Значение;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, НачалоПериода, 1);
	
КонецПроцедуры

Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, КонецПериода, -1);

КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НачалоПериода, ?(КонецПериода='0001-01-01', КонецПериода, КонецДня(КонецПериода)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		НачалоПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонецПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;

КонецПроцедуры

Функция НайтиВерсию(КлючОбъекта, НомерВерсии = Неопределено, ИмяРеквизита = "") Экспорт 
	
	НайденнаяСтрока = Типы.Найти(Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(КлючОбъекта)).ПолноеИмя(), "ПолноеИмяМД");
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ЭлементыФормы.Типы.ТекущаяСтрока = НайденнаяСтрока;
	Если ЗначениеЗаполнено(ИмяРеквизита) Тогда
		СтрокаРеквизита = Поля.Найти(ИмяРеквизита, "ИмяПоля");
		Если СтрокаРеквизита <> Неопределено Тогда
			ЭлементыФормы.Поля.ТекущаяСтрока = СтрокаРеквизита;
		КонецЕсли; 
	КонецЕсли; 
	Если НомерВерсии <> Неопределено Тогда
		СтрокаВерсии = Версии.Найти(НомерВерсии, "НомерВерсии");
		Если СтрокаВерсии <> Неопределено Тогда
			ЭлементыФормы.Версии.ТекущаяСтрока = СтрокаВерсии;
		Иначе
			Сообщить("Версия не найдена по текущим условиям отбора");
		КонецЕсли; 
	КонецЕсли; 
	
КонецФункции

Процедура ПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Поля.Колонки.ОписаниеТипов Тогда
		ирОбщий.ОткрытьЗначениеЛкс(мОписанияТиповПолей.Найти(ВыбраннаяСтрока.ИмяПоля, "Имя").ОписаниеТипов, Ложь, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_ДанныеУдалитьВерсии(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Вы действительно хотите удалить все версии объектов этого типа данных старше выбранной версии?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИсторияДанныхМоя = Вычислить("ИсторияДанных");
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		ИсторияДанныхМоя.УдалитьВерсии(ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД), ТекущиеДанные.Дата);
		КП_ОбновитьВерсии();
	КонецЕсли;
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОчиститьИсторию(Кнопка)
	
	Ответ = Вопрос("Вы действительно хотите очистить всю историю данных?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИсторияДанныхМоя = Вычислить("ИсторияДанных");
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		Для Каждого СтрокаТипа Из Типы Цикл
			ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(СтрокаТипа.ПолноеИмяМД);
			Попытка
				ИсторияДанныхМоя.УдалитьВерсии(ОбъектМД);
			Исключение
				ирОбщий.СообщитьЛкс("Ошибка удаления версий " + ОбъектМД.ПолноеИмя() + ": " + ОписаниеОшибки());
			КонецПопытки; 
		КонецЦикла;
		КПТипыОбновить();
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_ДанныеИсследоватьВерсию(Кнопка)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирОбщий.ИсследоватьВерсиюОбъектаДанныхЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура ПоляИспользованиеПриИзменении(Элемент)
	
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
	Если НастройкиИстории = Неопределено Тогда 
		НастройкиИстории = Новый ("НастройкиИсторииДанных");
	КонецЕсли; 
	ИспользованиеПолей = Новый Соответствие;
	Для Каждого СтрокаПоля Из Поля Цикл
		Если СтрокаПоля.ИспользованиеВМетаданных <> СтрокаПоля.Использование Тогда
			ИспользованиеПолей.Вставить(СтрокаПоля.ИмяПоля, СтрокаПоля.Использование);
		КонецЕсли; 
	КонецЦикла;
	НастройкиИстории.ИспользованиеПолей = ИспользованиеПолей;
	Попытка
		ИсторияДанныхМоя.УстановитьНастройки(ОбъектМД, НастройкиИстории);
	Исключение
		Сообщить("Ошибка изменения настроек истории " + ОбъектМД.ПолноеИмя() + ": " + ОписаниеОшибки());
		Возврат
	КонецПопытки;
	ОбновитьПредставлениеПолейВСтрокеТипа(НастройкиИстории, ОбъектМД, ЭлементыФормы.Типы.ТекущаяСтрока, Истина);

КонецПроцедуры

Процедура ВерсииПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВычислятьПоляПриИзменении(Элемент)
	
	КПТипыОбновить();
	
КонецПроцедуры

Процедура КП_ДанныеОтборПоРеквизитам(Кнопка)
	
	УстановитьОтборПоРеквизитам(Не ОтборПоРеквизитам);
	КП_ОбновитьВерсии();
	
КонецПроцедуры

Процедура УстановитьОтборПоРеквизитам(Знач НовоеИспользование)
	
	ЭтаФорма.ОтборПоРеквизитам = НовоеИспользование;
	ЭлементыФормы.КП_Данные.Кнопки.ОтборПоРеквизитам.Пометка = ЭтаФорма.ОтборПоРеквизитам;

КонецПроцедуры

Процедура ПоляПриАктивизацииСтроки(Элемент)
	
	Если ОтборПоРеквизитам Тогда
		КП_ОбновитьВерсии();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПТипыСоздатьВерсии(Кнопка)
	
	ОбработкаОбъектов = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирПодборИОбработкаОбъектов");
	#Если Сервер И Не Сервер Тогда
	    ОбработкаОбъектов = Обработки.ирПодборИОбработкаОбъектов.Создать();
	#КонецЕсли
	ФормаОбработки = ОбработкаОбъектов.ПолучитьФорму();
	ФормаОбработки.Открыть();
	ПолныеИменаТаблиц = Новый СписокЗначений;
	ПолныеИменаТаблиц.ЗагрузитьЗначения(ирОбщий.ЗначенияСвойстваКоллекцииЛкс(ЭлементыФормы.Типы.ВыделенныеСтроки, "ПолноеИмяМД"));
	Если ПолныеИменаТаблиц.Количество() = 1 Тогда
		ОбластьПоиска = ПолныеИменаТаблиц[0].Значение;
	Иначе
		ОбластьПоиска = ПолныеИменаТаблиц;
	КонецЕсли; 
	ФормаОбработки.УстановитьОбластьПоиска(ОбластьПоиска);
	Сообщить("После выбора объектов используйте обработку ""Записать версию""");
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТипыИспользованиеПриИзменении(Элемент)
	
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
	Если НастройкиИстории = Неопределено Тогда 
		НастройкиИстории = Новый ("НастройкиИсторииДанных");
	КонецЕсли; 
	НастройкиИстории.Использование = ЭлементыФормы.Типы.ТекущаяСтрока.Использование;
	Попытка
		ИсторияДанныхМоя.УстановитьНастройки(ОбъектМД, НастройкиИстории);
	Исключение
		Сообщить("Ошибка изменения настроек истории " + ОбъектМД.ПолноеИмя() + ": " + ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирИсторияДанных.Форма.Форма");
МаксКоличествоВерсий = 1000;
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(10);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(100);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(1000);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(10000);
