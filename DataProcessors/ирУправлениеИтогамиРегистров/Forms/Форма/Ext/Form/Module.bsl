﻿Перем мСписокНазначенийТаблицИтогов;
Перем мСтруктураХраненияСРазмерами;
Перем мСтруктураХранения;
Перем мПлатформа;
Перем мСоединениеADO;
// Анализ статистики итогов http://infostart.ru/public/342076/

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Реквизит.ПоказыватьСтруктуруХранения, Реквизит.СтатистикаПоТекущемуРегистру, Реквизит.СтатистикаПриОбновленииСписка, Реквизит.ПрерыватьПриОшибке";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбновитьТаблицуРегистров()    
	
	Если ТаблицаРегистров.Количество() = 0 Тогда
		ТабличноеПоле = ЭлементыФормы.ТаблицаРегистров;
		СостояниеТабличногоПоля = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ТабличноеПоле, "ПолноеИмя");
		ТаблицаРегистров.Очистить();
		СписокМетаданных = Новый Массив;
		КоллекцияМетаданных = Метаданные.РегистрыБухгалтерии;
		Для каждого Регистр Из КоллекцияМетаданных Цикл
			НоваяСтрока = ТаблицаРегистров.Добавить();
			НоваяСтрока.ИмяРегистра					= Регистр.Имя;
			НоваяСтрока.ПолноеИмя					= Регистр.ПолноеИмя();
			НоваяСтрока.ПредставлениеРегистра		= Регистр.Синоним;
			НоваяСтрока.ТипРегистра					= "РегистрБухгалтерии";
		КонецЦикла; 
		КоллекцияМетаданных = Метаданные.РегистрыНакопления;
		Для каждого Регистр Из КоллекцияМетаданных Цикл
			НоваяСтрока = ТаблицаРегистров.Добавить();
			НоваяСтрока.ИмяРегистра				= Регистр.Имя;
			НоваяСтрока.ПолноеИмя				= Регистр.ПолноеИмя();
			НоваяСтрока.ПредставлениеРегистра	= Регистр.Синоним;
			НоваяСтрока.ТипРегистра				= "РегистрНакопления";
			Если Регистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
				НоваяСтрока.ВидРегистра					= "Остатки";
			КонецЕсли; 
		КонецЦикла;
		ЭтаФорма.КоличествоРегистров = ТаблицаРегистров.Количество();
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ТабличноеПоле, СостояниеТабличногоПоля);
	КонецЕсли; 
	Если ПоказыватьСтруктуруХранения Тогда
		Если мСтруктураХраненияСРазмерами = Неопределено Тогда
			мСтруктураХраненияСРазмерами = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирСтруктураХраненияБД");
			#Если Сервер И Не Сервер Тогда
			    мСтруктураХраненияСРазмерами = Обработки.ирСтруктураХраненияБД.Создать();
			#КонецЕсли
			мСтруктураХраненияСРазмерами.ОтборПоМетаданным = ТаблицаРегистров.ВыгрузитьКолонку("ПолноеИмя");
			мСтруктураХраненияСРазмерами.ПоказыватьСУБД = Истина;
			мСтруктураХраненияСРазмерами.ПоказыватьSDBL = Ложь;
			мСтруктураХраненияСРазмерами.ПоказыватьРазмеры = Истина;
			мСтруктураХраненияСРазмерами.ОбновитьТаблицы();
			СоединениеADO(Ложь);
		КонецЕсли; 
	КонецЕсли; 
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТаблицаРегистров.Количество(), "Регистры");
	Для Каждого СтрокаРегистра Из ТаблицаРегистров Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ОбновитьДанныеПоРегистру(СтрокаРегистра);
		Если ПоказыватьСтруктуруХранения И СтатистикаПриОбновленииСписка Тогда
			ОбновитьСтрокуРегистра(СтрокаРегистра);
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ОбновитьСтрокуРегистра();
	
КонецПроцедуры

Процедура ОбновитьДанныеПоРегистру(Знач СтрокаРегистра)
	
	ИмяРегистра = СтрокаРегистра.ИмяРегистра;
	МенеджерРегистра = Новый (СтрокаРегистра.ТипРегистра + "Менеджер." + ИмяРегистра);
	СтрокаРегистра.ИспользованиеИтогов = МенеджерРегистра.ПолучитьИспользованиеИтогов();		
	СтрокаРегистра.РазделениеИтогов = МенеджерРегистра.ПолучитьРежимРазделенияИтогов();
	Если Ложь
		Или СтрокаРегистра.ТипРегистра = "РегистрБухгалтерии" 
		Или СтрокаРегистра.ВидРегистра = "Остатки"
	Тогда 
		СтрокаРегистра.ИспользованиеТекущихИтогов = МенеджерРегистра.ПолучитьИспользованиеТекущихИтогов();		
		СтрокаРегистра.ПериодИтогов = МенеджерРегистра.ПолучитьПериодРассчитанныхИтогов();
		Если Не ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
			СтрокаРегистра.ПериодНачалаИтогов = МенеджерРегистра.ПолучитьМинимальныйПериодРассчитанныхИтогов();
		КонецЕсли;
	Иначе
		Если Не ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
			СтрокаРегистра.АгрегатыИтоги = ?(МенеджерРегистра.ПолучитьРежимАгрегатов(), "Агрегаты", "Итоги");
		КонецЕсли; 
		СтрокаРегистра.ВидРегистра = "Обороты";
	КонецЕсли; 
	ЗаполнитьДанныеХранения(СтрокаРегистра, мСтруктураХраненияСРазмерами);

КонецПроцедуры // ОбновитьТаблицуРегистров() 

Функция ЗаполнитьДанныеХранения(СтрокаРегистра, СтруктураХраненияСРазмерами)        
	
	#Если Сервер И Не Сервер Тогда
	    СтруктураХраненияСРазмерами = Обработки.ирСтруктураХраненияБД.Создать();
		СтрокаРегистра = ТаблицаРегистров.Добавить();
	#КонецЕсли
	Если ПоказыватьСтруктуруХранения Тогда
		РазмерыТаблицы = СтруктураХраненияСРазмерами.Таблицы.Найти(СтрокаРегистра.ПолноеИмя, "ИмяТаблицы");
		Если РазмерыТаблицы <> Неопределено Тогда
			СтрокаРегистра.ОсновнаяРазмер = РазмерыТаблицы.РазмерОбщий;
			СтрокаРегистра.ОсновнаяРазмерИндекса = РазмерыТаблицы.РазмерИндексы;
			СтрокаРегистра.ОсновнаяКоличествоСтрок = РазмерыТаблицы.КоличествоСтрок;
		КонецЕсли;
		ЗаполнитьСписокТаблицИтоговРегистра(СтрокаРегистра);
	КонецЕсли; 
	
КонецФункции

Процедура ВыполнитьКомандуПользователя(ВыделенныеСтроки, Команда, ПериодИтогов = Неопределено) 
	
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВыделенныеСтроки.Количество(), Команда);
	Для каждого СтрокаТаблицы Из ВыделенныеСтроки Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если СтрокаТаблицы.ТипРегистра = "РегистрНакопления" Тогда
			РегистрМенеджер = РегистрыНакопления[СтрокаТаблицы.ИмяРегистра];
		ИначеЕсли СтрокаТаблицы.ТипРегистра = "РегистрБухгалтерии" Тогда
			РегистрМенеджер = РегистрыБухгалтерии[СтрокаТаблицы.ИмяРегистра];
		КонецЕсли;
		Попытка
			Если Команда = "ВключитьИспользованиеИтогов" Тогда
				РегистрМенеджер.УстановитьИспользованиеИтогов(Истина);
				СтрокаТаблицы.ИспользованиеИтогов = Истина;
			ИначеЕсли Команда = "ВыключитьИспользованиеИтогов" Тогда
				РегистрМенеджер.УстановитьИспользованиеИтогов(Ложь);
				СтрокаТаблицы.ИспользованиеИтогов = Ложь;
			ИначеЕсли Команда = "ВключитьТекущиеИтоги" Тогда
				Если Истина
					И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
					И СтрокаТаблицы.ВидРегистра = "Обороты" 
				Тогда
					Продолжить;
				КонецЕсли;
				РегистрМенеджер.УстановитьИспользованиеТекущихИтогов(Истина);
				СтрокаТаблицы.ИспользованиеТекущихИтогов = Истина;
			ИначеЕсли Команда = "ВыключитьТекущиеИтоги" Тогда
				Если Истина
					И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
					И СтрокаТаблицы.ВидРегистра = "Обороты" 
				Тогда
					Продолжить;
				КонецЕсли;
				РегистрМенеджер.УстановитьИспользованиеТекущихИтогов(Ложь);
				СтрокаТаблицы.ИспользованиеТекущихИтогов = Ложь;   			
			ИначеЕсли Команда = "ВключитьРазделениеИтогов" Тогда
				РегистрМенеджер.УстановитьРежимРазделенияИтогов(Истина);
				СтрокаТаблицы.РазделениеИтогов = Истина;
			ИначеЕсли Команда = "ВыключитьРазделениеИтогов" Тогда
				РегистрМенеджер.УстановитьРежимРазделенияИтогов(Ложь);
				СтрокаТаблицы.РазделениеИтогов = Ложь;
			ИначеЕсли Команда = "УстановитьГраницыИтогов" Тогда
				Если Ложь
					Или (Истина
						И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
						И СтрокаТаблицы.ВидРегистра = "Остатки")
					Или СтрокаТаблицы.ТипРегистра = "РегистрБухгалтерии"
				Тогда
					РегистрМенеджер.УстановитьПериодРассчитанныхИтогов(ПериодИтогов.МаксимальнаяДата);
					СтрокаТаблицы.ПериодИтогов = ПериодИтогов.МаксимальнаяДата;
					Если Не ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
						РегистрМенеджер.УстановитьМинимальныйПериодРассчитанныхИтогов(ПериодИтогов.МинимальнаяДата);
						СтрокаТаблицы.ПериодНачалаИтогов = ПериодИтогов.МинимальнаяДата;
					КонецЕсли; 
				КонецЕсли;
			ИначеЕсли Команда = "ПересчитатьИтоги" Тогда
				РегистрМенеджер.ПересчитатьИтоги();
			ИначеЕсли Команда = "ПересчитатьТекущиеИтоги" Тогда
				Если Истина
					И СтрокаТаблицы.ТипРегистра = "РегистрНакопления" 
					И СтрокаТаблицы.ВидРегистра = "Обороты" 
				Тогда
					Продолжить;
				КонецЕсли;
				РегистрМенеджер.ПересчитатьТекущиеИтоги();
			ИначеЕсли Команда = "ПересчитатьИтогиЗаПериод" Тогда
				РегистрМенеджер.ПересчитатьИтогиЗаПериод(ПериодИтогов.НачалоПериода, ПериодИтогов.КонецПериода);
			КонецЕсли;
		Исключение
			Если ПрерыватьПриОшибке Тогда
				ВызватьИсключение;
			КонецЕсли; 
			ирОбщий.СообщитьЛкс("Ошибка обработки регистра """ + СтрокаТаблицы.ПолноеИмя + """: " + ОписаниеОшибки());
		КонецПопытки;
		ОбновитьДанныеПоРегистру(СтрокаТаблицы);
	КонецЦикла;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
	КонецЕсли; 
	
КонецПроцедуры 

Процедура КоманднаяПанельТаблицаРегистровОбновитьТаблицуИтогов(Кнопка)
	
	ОбновитьТаблицуРегистров();
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаРегистровВключитьИспользованиеИтогов(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ВключитьИспользованиеИтогов");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровВключитьИспользованиеИтогов()

Процедура КоманднаяПанельТаблицаРегистровВыключитьИспользованиеИтогов(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ВыключитьИспользованиеИтогов");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровВыключитьИспользованиеИтогов()

Процедура КоманднаяПанельТаблицаРегистровВключитьТекущиеИтоги(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ВключитьТекущиеИтоги");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровВключитьТекущиеИтоги()

Процедура КоманднаяПанельТаблицаРегистровВыключитьТекущиеИтоги(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ВыключитьТекущиеИтоги");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровВыключитьТекущиеИтоги()

Процедура КоманднаяПанельТаблицаРегистровВключитьРазделениеИтогов(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ВключитьРазделениеИтогов");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровВключитьРазделениеИтогов()

Процедура КоманднаяПанельТаблицаРегистровВыключитьРазделениеИтогов(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ВыключитьРазделениеИтогов");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровВыключитьРазделениеИтогов()

Процедура КоманднаяПанельТаблицаРегистровУстановитьПериодИтогов(Кнопка)
	
	ФормаУправленияИтогами = ПолучитьФорму("УстановитьГраницыИтогов", ЭтаФорма);
	Результат = ФормаУправленияИтогами.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "УстановитьГраницыИтогов", Результат);
	КонецЕсли;
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровУстановитьПериодИтогов()

Процедура КоманднаяПанельТаблицаРегистровПересчитатьИтоги(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ПересчитатьИтоги");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровПересчитатьИтоги()

Процедура КоманднаяПанельТаблицаРегистровПересчитатьТекущиеИтоги(Кнопка)
	
	ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ПересчитатьТекущиеИтоги");
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровПересчитатьТекущиеИтоги()

Процедура КоманднаяПанельТаблицаРегистровПересчитатьИтогиЗаПериод(Кнопка)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал	= Истина;
	НастройкаПериода.ВариантНастройки			= ВариантНастройкиПериода.Интервал;
	НастройкаПериода.ВариантНачала				= ВариантГраницыИнтервала.БезОграничения;
	НастройкаПериода.ВариантОкончания			= ВариантГраницыИнтервала.БезОграничения;
	Если НастройкаПериода.Редактировать() Тогда
		СтруктураПериода = Новый Структура("НачалоПериода,КонецПериода", НастройкаПериода.ПолучитьДатуНачала(), НастройкаПериода.ПолучитьДатуОкончания());
		ВыполнитьКомандуПользователя(ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки, "ПересчитатьИтогиЗаПериод", СтруктураПериода);
	КонецЕсли;
	
КонецПроцедуры // КоманднаяПанельТаблицаРегистровПересчитатьИтогиЗаПериод()    

Процедура КонтекстноеМенюВыделитьВсе(Кнопка)
	
	Для каждого СтрокаТаблицы Из ТаблицаРегистров Цикл
		
		 ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки.Добавить(СтрокаТаблицы); 

	 КонецЦикла;
	 
	 Обновить();
	
КонецПроцедуры // КонтекстноеМенюВыделитьВсе()
 
Процедура ТаблицаРегистровПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.Основная.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.Итоги.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.ПредставлениеРегистра.УстановитьКартинку(ирКэш.КартинкаПоИмениЛкс(ДанныеСтроки.ТипРегистра));
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	ОбновитьТаблицуРегистров();
	ЭлементыФормы.КоманднаяПанельТаблицаРегистров.Кнопки.ОчисткаТаблицСУБД.Доступность = Не ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.КоманднаяПанельТаблицаРегистров.Кнопки.ПараметрыСУБД.Доступность = Не ирКэш.ЭтоФайловаяБазаЛкс();
	НастроитьЭлементыФормы();
	
КонецПроцедуры // ПриОткрытии()

Процедура КоманднаяПанельТаблицаРегистровПоказатьСтруктуруХранения(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаРегистров.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	//Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирСтруктураХраненияБД.Форма");
	Форма = мСтруктураХраненияСРазмерами.ПолучитьФорму();
	Форма.ПараметрИмяТаблицы = ТекущаяСтрока.ТипРегистра + "." + ТекущаяСтрока.ИмяРегистра;
	Форма.Открыть();
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаРегистровОчисткаТаблицСУБД(Кнопка)
	
	ТекстЗапроса = СформироватьТекстЗапросаСУБДОчисткиТаблиц();
	ФормаТекста = ирОбщий.ПолучитьФормуТекстаЛкс(ТекстЗапроса, "Текст запроса очистки итогов выбранных регистров", "Обычный");
	ТекстЗапроса = ФормаТекста.ОткрытьМодально();
	Если ТекстЗапроса <> Неопределено Тогда
		СоединениеADO();
		Если мСоединениеADO = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		Если Не ирОбщий.ПодтверждениеОперацииСУБДЛкс() Тогда
			Возврат;
		КонецЕсли;
		ВыполнитьЗапросADO(ТекстЗапроса);
		Если мСоединениеADO.Properties("Multiple Results").Value <> 0 Тогда
			Сообщить("Запрос очистки выбранных таблиц БД выполнен успешно.");
			Если ПоказыватьСтруктуруХранения Тогда
				ОбновитьТаблицуРегистров();
			КонецЕсли; 
		КонецЕсли; 
		//ирОбщий.ОткрытьЗапросСУБДЛкс(ТекстЗапроса, "Очистка таблиц");
	КонецЕсли; 
	
КонецПроцедуры

Процедура СоединениеADO(ЗапрашиватьПараметры = Истина)
	
	Если мСоединениеADO = Неопределено Тогда
		Если Не ирОбщий.ПроверитьСоединениеADOЭтойБДЛкс(,,,,, ЗапрашиватьПараметры) Тогда
			Возврат;
		КонецЕсли; 
		мСоединениеADO = ирОбщий.ПолучитьСоединениеСУБД();
	КонецЕсли; 

КонецПроцедуры

Функция СформироватьТекстЗапросаСУБДОчисткиТаблиц()
		
	ТекстЗапроса = "";
	МассивМетаданных = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.ТаблицаРегистров.ВыделенныеСтроки Цикл 
		МассивМетаданных.Добавить(ВыделеннаяСтрока.ПолноеИмя);
	КонецЦикла;
	СтрокиТаблиц = ирОбщий.СтруктураХраненияБДЛкс(МассивМетаданных, Истина);
	Для Каждого СтрокаТаблицы Из СтрокиТаблиц Цикл
		Если Найти(мСписокНазначенийТаблицИтогов, "," + СтрокаТаблицы.Назначение + ",") > 0 Тогда
			ТекстЗапроса = ТекстЗапроса + "truncate table " + СтрокаТаблицы.ИмяТаблицыХранения;
			//ТекстЗапроса = ТекстЗапроса + " --" + СтрокаТаблицы.ИмяТаблицы + Символы.ПС; // https://partners.v8.1c.ru/forum/t/1485806/m/1485806
			ТекстЗапроса = ТекстЗапроса + " --" + СтрокаТаблицы.Метаданные + "." + СтрокаТаблицы.Назначение + Символы.ПС;
		КонецЕсли;
	КонецЦикла;
	//Если ДобавитьКонструкциюSHRINKDATABASE Тогда
	//	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "DBCC SHRINKDATABASE (" + ИмяБД + ", 10)";
	//КонецЕсли;
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура КоманднаяПанельТаблицаРегистровПараметрыСУБД(Кнопка)
	
	ирОбщий.ОткрытьФормуСоединенияСУБДЛкс();
	
КонецПроцедуры

Процедура ЗаполнитьСписокТаблицИтоговРегистра(СтрокаРегистра, УстановитьТекущуюСтроку = Истина)
	
	Если ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока <> Неопределено Тогда
		ИмяТекущейТаблицыИтогов = ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока.ИмяТаблицы;
	КонецЕсли; 
	ТаблицыИтоговРегистра.Очистить();
	Если СтрокаРегистра = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если мСтруктураХраненияСРазмерами = Неопределено Или Не ПоказыватьСтруктуруХранения Тогда
		Возврат;
	КонецЕсли; 
	СтрокиСтруктурыБД = мСтруктураХраненияСРазмерами.мСтруктураХраненияСУБД.НайтиСтроки(Новый Структура("Метаданные", СтрокаРегистра.ПолноеИмя)); // Этот способ быстрее
	Для Каждого СтрокаСтруктурыБД Из СтрокиСтруктурыБД Цикл
		Если Найти(мСписокНазначенийТаблицИтогов, "," + СтрокаСтруктурыБД.Назначение + ",") > 0 Тогда
			СтрокаТаблицыИтогов = ТаблицыИтоговРегистра.Добавить();
			СтрокаТаблицыИтогов.ИмяТаблицы = СтрокаСтруктурыБД.Метаданные + "." + СтрокаСтруктурыБД.Назначение;
			СтрокаТаблицыИтогов.ИмяХранения = СтрокаСтруктурыБД.ИмяТаблицыХранения;
			СтрокаТаблицыИтогов.Назначение = СтрокаСтруктурыБД.Назначение;
			РазмерыТаблицы = мСтруктураХраненияСРазмерами.Таблицы.Найти(СтрокаТаблицыИтогов.ИмяХранения, "ИмяТаблицыХранения");
			Если РазмерыТаблицы <> Неопределено Тогда
				СтрокаТаблицыИтогов.ИтогиРазмер = РазмерыТаблицы.РазмерОбщий;
				СтрокаТаблицыИтогов.ИтогиРазмерИндекса = РазмерыТаблицы.РазмерИндексы;
				СтрокаТаблицыИтогов.ИтогиКоличествоСтрок = РазмерыТаблицы.КоличествоСтрок;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла; 
	СтрокаРегистра.ИтогиРазмер = ТаблицыИтоговРегистра.Итог("ИтогиРазмер");
	СтрокаРегистра.ИтогиРазмерИндекса = ТаблицыИтоговРегистра.Итог("ИтогиРазмерИндекса");
	СтрокаРегистра.ИтогиКоличествоСтрок = ТаблицыИтоговРегистра.Итог("ИтогиКоличествоСтрок");
	Если УстановитьТекущуюСтроку Тогда
		Если ИмяТекущейТаблицыИтогов <> Неопределено Тогда
			НоваяСтрока = ТаблицыИтоговРегистра.Найти(ИмяТекущейТаблицыИтогов, "ИмяТаблицы");
			Если НоваяСтрока <> Неопределено Тогда
				ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока = НоваяСтрока;
			КонецЕсли; 
		КонецЕсли; 
		Если ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока = Неопределено И ТаблицыИтоговРегистра.Количество() > 0 Тогда
			ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока = ТаблицыИтоговРегистра[0];
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Функция ЗапросСтатистикиПоПериодам(Знач ПолноеИмяРегистра = "", Знач НазначениеТаблицыИтогов = "")
	
	Если Не ЗначениеЗаполнено(ПолноеИмяРегистра) Тогда
		ПолноеИмяРегистра = ЭлементыФормы.ТаблицаРегистров.ТекущаяСтрока.ПолноеИмя; 
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(НазначениеТаблицыИтогов) Тогда
		НазначениеТаблицыИтогов = ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока.Назначение;
	КонецЕсли; 
	СтрокиТаблиц = ирОбщий.СтруктураХраненияБДЛкс(ПолноеИмяРегистра, Истина);
	СтрокаХраненияИтогов = СтрокиТаблиц.Найти(НазначениеТаблицыИтогов, "Назначение");
	ИмяХраненияРегистра = СтрокиТаблиц.Найти(ПолноеИмяРегистра, "ИмяТаблицы").ИмяТаблицыХранения;
	УсловиеНулевыхРесурсов = УсловиеНулевогоИтога(ПолноеИмяРегистра, СтрокаХраненияИтогов);
	ВсегоЗаписей = 0;
	Запрос = "Select cast(Period as datetime) as Period, sum(TotalsRows) as TotalsRows, sum(DetailRows) as DetailRows 
	|, sum(TotalsNonZeroRows) as TotalsNonZeroRows, sum(TotalsZeroRows) as TotalsZeroRows
	|From
	|		 		(SELECT
	|		 			_Period as Period, 
	|		 			0 AS DetailRows,
	|		 			count(*) as TotalsRows,
	|					sum(case when " + УсловиеНулевыхРесурсов + "
	|						then 1 else 0 end) as TotalsZeroRows,
	|					sum(case when " + УсловиеНулевыхРесурсов + "
	|						then 0 else 1 end) as TotalsNonZeroRows
	|		 		FROM 
	|	 				" + СтрокаХраненияИтогов.ИмяТаблицыХранения + "
	|		 		GROUP BY _Period
	|		 		  
	|		 	  UNION all 
	|		 
	|	 			SELECT 
	|					Period as Period, 
	|	 				count(*) as DetailRows, 
	|	 				0 as TotalsRows,
	|	 				0 as TotalsZeroRows,
	|	 				0 as TotalsNonZeroRows
	|	 			From 
	|	 				( 
	|	 				  SELECT DATEADD(MONTH,1+DATEDIFF(MONTH,0, _Period),0) as Period
	|			 			FROM " + ИмяХраненияРегистра + "
	|	 				) as v
	|		 		GROUP BY Period 
	|	 		) as al
	|	 		GROUP by Period
	|			ORDER by Period";
	Возврат Запрос;

КонецФункции

Функция ВыполнитьЗапросADO(ТекстЗапроса)
	
	СоединениеADO(); 
	РезультатЗапроса = Новый COMОбъект("ADODB.Recordset");
	adOpenStatic = 3;
	adLockOptimistic = 3;
	adCmdText = 1;
	РезультатЗапроса.Open(ТекстЗапроса, мСоединениеADO, adOpenStatic, adLockOptimistic, adCmdText);
	Возврат РезультатЗапроса;

КонецФункции

Процедура ТаблицаРегистровПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ОбновитьСтрокуРегистра();

КонецПроцедуры

Процедура ОбновитьСтрокуРегистра(Знач СтрокаРегистра = Неопределено)
	
	Если СтрокаРегистра = Неопределено Тогда
		СтрокаРегистра = ЭлементыФормы.ТаблицаРегистров.ТекущиеДанные;
		РасчитатьСтатистику = ПоказыватьСтруктуруХранения И СтатистикаПоТекущемуРегистру;
		ЗаполнитьСписокТаблицИтоговРегистра(СтрокаРегистра);
	Иначе
		РасчитатьСтатистику = ПоказыватьСтруктуруХранения И СтатистикаПриОбновленииСписка;
		ЗаполнитьСписокТаблицИтоговРегистра(СтрокаРегистра, Ложь);
	КонецЕсли; 
	ПериодыИтогов.Очистить();
	Если Истина
		И РасчитатьСтатистику
		И СтрокаРегистра <> Неопределено 
		И мСоединениеADO <> Неопределено
	Тогда
		СтрокаРегистра.КоличествоПериодов = 0;
		СтрокаРегистра.ИтогиКоличествоНулевых = 0;
		СтрокаРегистра.ИтогиКоличествоСтрок = 0;
		Для Каждого СтрокаТаблицыИтогов Из ТаблицыИтоговРегистра Цикл
			Запрос = ЗапросСтатистикиПоПериодам(СтрокаРегистра.ПолноеИмя, СтрокаТаблицыИтогов.Назначение);
			ТаблицаРезультата = ирОбщий.ВыполнитьЗапросКЭтойБазеЧерезADOЛкс(Запрос,,,,,, мСоединениеADO);
			СтрокаТаблицыИтогов.КоличествоПериодов = ТаблицаРезультата.Количество();
			Если СтрокаРегистра.КоличествоПериодов = 0 Тогда
				СтрокаРегистра.КоличествоПериодов = ТаблицаРезультата.Количество(); // Доделать
			КонецЕсли; 
			СтрокаТаблицыИтогов.ИтогиКоличествоСтрок = 0;
			ПредыдущееЧислоИтогов = 0;
			Для Каждого СтрокаРезультата ИЗ ТаблицаРезультата Цикл
				Стр = ПериодыИтогов.Добавить();
				Стр.Назначение = СтрокаТаблицыИтогов.Назначение;
				Стр.Период = СтрокаРезультата.Period;
				Стр.ЧислоДетальных = СтрокаРезультата.DetailRows;
				Стр.ЧислоИтогов = СтрокаРезультата.TotalsRows;
				Стр.ЧислоИтоговНулевых = СтрокаРезультата.TotalsZeroRows;
				Стр.ЧислоИтоговПрирост = Стр.ЧислоИтогов - ПредыдущееЧислоИтогов;
				ПредыдущееЧислоИтогов = Стр.ЧислоИтогов;
				СтрокаТаблицыИтогов.ИтогиКоличествоНулевых = СтрокаТаблицыИтогов.ИтогиКоличествоНулевых + Стр.ЧислоИтоговНулевых;
				СтрокаТаблицыИтогов.ИтогиКоличествоСтрок = СтрокаТаблицыИтогов.ИтогиКоличествоСтрок + Стр.ЧислоИтогов;
			КонецЦикла;
			ПериодыИтогов.Сортировать("Период убыв");
			СтрокаРегистра.ИтогиКоличествоНулевых = СтрокаРегистра.ИтогиКоличествоНулевых + СтрокаТаблицыИтогов.ИтогиКоличествоНулевых;
			СтрокаРегистра.ИтогиКоличествоСтрок = СтрокаРегистра.ИтогиКоличествоСтрок + СтрокаТаблицыИтогов.ИтогиКоличествоСтрок;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ПоказыватьРазмерыПриИзменении(Элемент)
	
	ОбновитьТаблицуРегистров();
	ОбновитьСтрокуРегистра();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.СтатистикаПоТекущемуРегистру.Доступность = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.СтатистикаПриОбновленииСписка.Доступность = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.КоманднаяПанельТаблицаРегистров.Кнопки.ПоказатьСтруктуруХранения.Доступность = ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.КоличествоПериодов.Видимость = ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.Итоги.Видимость = ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.ИтогиРазмер.Видимость = ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.ИтогиРазмерИндекса.Видимость = ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.ИтогиКоличествоСтрок.Видимость = ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.ИтогиКоличествоНулевых.Видимость = ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.ИтогиКоличествоСтрок.Видимость = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.ИтогиКоличествоНулевых.Видимость = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицыИтоговРегистра.Колонки.ИтогиКоличествоСтрок.Видимость = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицыИтоговРегистра.Колонки.ИтогиКоличествоНулевых.Видимость = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицаРегистров.Колонки.КоличествоПериодов.Видимость = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ТаблицыИтоговРегистра.Колонки.КоличествоПериодов.Видимость = Не ирКэш.ЭтоФайловаяБазаЛкс() И ПоказыватьСтруктуруХранения;
	ЭлементыФормы.ПериодыИтогов.Доступность = СтатистикаПоТекущемуРегистру;

КонецПроцедуры

Процедура ТаблицыИтоговРегистраПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока = Неопределено Тогда 
		ЗначениеОтбора = "111";
	Иначе
		ЗначениеОтбора = ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока.Назначение;
	КонецЕсли; 
	ЭлементыФормы.ПериодыИтогов.ОтборСтрок.Назначение.Установить(ЗначениеОтбора);
	
КонецПроцедуры

Процедура ПолучатьПериодыИзСУБДПриИзменении(Элемент)
	
	ОбновитьСтрокуРегистра();
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура КППериодыОткрытьЗапросСатистики(Кнопка)
	
	Если ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Запрос = ЗапросСтатистикиПоПериодам();
	ирОбщий.ОткрытьЗапросСУБДЛкс(Запрос, "Итоги по периодам");
	
КонецПроцедуры

Процедура КППериодыКомпоноватьОстаткиИОбороты(Кнопка)
	
	ОткрытьКомпоновкуПериода("ОстаткиИОбороты");
	
КонецПроцедуры

Процедура ОткрытьКомпоновкуПериода(Знач ИмяВиртуальнойТаблицы)
	
	Если ЭлементыФормы.ПериодыИтогов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	НоваяСхемаКомпоновки = ирОбщий.ПолучитьСхемуКомпоновкиТаблицыБДЛкс(ЭлементыФормы.ТаблицаРегистров.ТекущаяСтрока.ПолноеИмя + "." + ИмяВиртуальнойТаблицы,,,,,, Истина);
	#Если Сервер И Не Сервер Тогда
		НоваяСхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	НастройкаКомпоновки = НоваяСхемаКомпоновки.НастройкиПоУмолчанию;
	ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(НастройкаКомпоновки.Структура);
	СтрокаПериода = ЭлементыФормы.ПериодыИтогов.ТекущаяСтрока;
	ПараметрДанных = НастройкаКомпоновки.ПараметрыДанных.Элементы.Добавить();
	ПараметрДанных.Параметр = Новый ПараметрКомпоновкиДанных("НачалоПериода");
	ПараметрДанных.Значение = НачалоМесяца(СтрокаПериода.Период - 1);
	ПараметрДанных.Использование = Истина;
	ПараметрДанных = НастройкаКомпоновки.ПараметрыДанных.Элементы.Добавить();
	ПараметрДанных.Параметр = Новый ПараметрКомпоновкиДанных("КонецПериода");
	ПараметрДанных.Значение = КонецМесяца(СтрокаПериода.Период - 1);
	ПараметрДанных.Использование = Истина;
	ирОбщий.ОтладитьЛкс(НоваяСхемаКомпоновки,, НастройкаКомпоновки);

КонецПроцедуры

Процедура КППериодыКомпоноватьОбороты(Кнопка)
	
	ОткрытьКомпоновкуПериода("Обороты");
	
КонецПроцедуры

Процедура КППериодыДинамическийСписок(Кнопка)
	
	Если ЭлементыФормы.ПериодыИтогов.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаСписка = ирОбщий.ОткрытьФормуСпискаЛкс(ЭлементыФормы.ТаблицаРегистров.ТекущаяСтрока.ПолноеИмя,, Истина);
	СтрокаПериода = ЭлементыФормы.ПериодыИтогов.ТекущаяСтрока;
	ирОбщий.УстановитьЭлементОтбораЛкс(ФормаСписка.ЭлементыФормы.ДинамическийСписок.Значение.Отбор.Период, ВидСравнения.ИнтервалВключаяГраницы,
		НачалоМесяца(СтрокаПериода.Период - 1), КонецМесяца(СтрокаПериода.Период - 1));	
	
КонецПроцедуры

Функция ЗапросУдаленияНулевыхИтогов(Знач ПолноеИмяРегистра = "", Знач НазначениеТаблицыИтогов = "", выхБудетУдалено = Неопределено)
	
	Если Не ЗначениеЗаполнено(ПолноеИмяРегистра) Тогда
		ПолноеИмяРегистра = ЭлементыФормы.ТаблицаРегистров.ТекущаяСтрока.ПолноеИмя; 
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(НазначениеТаблицыИтогов) Тогда
		НазначениеТаблицыИтогов = ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока.Назначение;
	КонецЕсли; 
	СтрокиТаблиц = ирОбщий.СтруктураХраненияБДЛкс(ПолноеИмяРегистра, Истина);
	СтрокаХраненияИтогов = СтрокиТаблиц.Найти(НазначениеТаблицыИтогов, "Назначение");
	УсловиеНулевыхРесурсов = УсловиеНулевогоИтога(ПолноеИмяРегистра, СтрокаХраненияИтогов);
	Запрос = "DELETE FROM " + СтрокаХраненияИтогов.ИмяТаблицыХранения + " 
	|WHERE " + УсловиеНулевыхРесурсов;
	Если ЭлементыФормы.ПериодыИтогов.ТекущаяСтрока <> Неопределено Тогда
		ПериодКонечный = ЭлементыФормы.ПериодыИтогов.ТекущаяСтрока.Период;
		СтрокаДаты = Формат(ДобавитьМесяц(ПериодКонечный, 2000*12), "ДФ='yyyy-MM-dd HH:mm:ss'; ДП="); 
		Запрос = Запрос + "
		|	AND cast(_Period as datetime) <= convert(DateTime, '" + СтрокаДаты + "', 101)";
	Иначе
		ПериодКонечный = Неопределено;
	КонецЕсли; 
	КопияПериодов = ПериодыИтогов.Выгрузить(Новый Структура("Назначение", НазначениеТаблицыИтогов));
	НачальноеКоличество = КопияПериодов.Количество(); 
	Для СчетчикКопияПериодов = 1 По НачальноеКоличество Цикл
		СтрокаПериода = КопияПериодов[НачальноеКоличество - СчетчикКопияПериодов];
		Если Ложь
			Или СтрокаПериода.ЧислоИтоговНулевых = 0
			Или (Истина
				И ПериодКонечный <> Неопределено 
				И СтрокаПериода.Период > ПериодКонечный)
		Тогда
			КопияПериодов.Удалить(СтрокаПериода);
		КонецЕсли;
	КонецЦикла;
	выхБудетУдалено = КопияПериодов.Итог("ЧислоИтоговНулевых");
	Возврат Запрос;

КонецФункции

Функция УсловиеНулевогоИтога(Знач ПолноеИмяРегистра, Знач СтрокаХраненияИтогов)
	
	МетаРегистр = ирКэш.ОбъектМДПоПолномуИмениЛкс(ПолноеИмяРегистра);
	ПоляТаблицыИтогов = СтрокаХраненияИтогов.Поля;
	Если СтрокаХраненияИтогов.Назначение = "ИтогиМеждуСчетами" Тогда
		// Антибаг платформы 8.3.8. В описании полей не указаны метаданные
		Возврат "1=0";
	КонецЕсли; 
	УсловиеНулевыхРесурсов = "";
	Для Каждого ПолеИтогов Из ПоляТаблицыИтогов Цикл
		ИмяПоля = ПолеИтогов.ИмяПоля;
		Если Не ЗначениеЗаполнено(ИмяПоля) Тогда
			// Антибаг платформы 8.3.11 https://bugboard.v8.1c.ru/error/000016790.html
			ИмяПоля = ирОбщий.ПоследнийФрагментЛкс(ПолеИтогов.Метаданные);
		КонецЕсли; 
		Если МетаРегистр.Ресурсы.Найти(ИмяПоля) <> Неопределено Тогда
			Если УсловиеНулевыхРесурсов <> "" Тогда
				УсловиеНулевыхРесурсов = УсловиеНулевыхРесурсов + "
				|	AND ";
			КонецЕсли; 
			УсловиеНулевыхРесурсов = УсловиеНулевыхРесурсов + ПолеИтогов.ИмяПоляХранения +  " = 0";
		КонецЕсли; 
	КонецЦикла;
	Возврат УсловиеНулевыхРесурсов;

КонецФункции

Процедура КППериодыУдалитьНулевые(Кнопка)
	
	Если ЭлементыФормы.ТаблицыИтоговРегистра.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	БудетУдалено = 0;
	ТекстЗапроса = ЗапросУдаленияНулевыхИтогов(,, БудетУдалено);
	Если ТекстЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаТекста = ирОбщий.ПолучитьФормуТекстаЛкс(ТекстЗапроса, "Текст запроса очистки нулевых итогов", "Обычный");
	ТекстЗапроса = ФормаТекста.ОткрытьМодально();
	Если ТекстЗапроса <> Неопределено Тогда
		СоединениеADO();
		Если мСоединениеADO = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		Если Не ирОбщий.ПодтверждениеОперацииСУБДЛкс() Тогда
			Возврат;
		КонецЕсли;
		Ответ = Вопрос("Будет удалено " + БудетУдалено + " строк нулевых итогов. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		ВыполнитьЗапросADO(ТекстЗапроса);
		Если мСоединениеADO.Properties("Multiple Results").Value <> 0 Тогда
			Сообщить("Запрос очистки нулевых итогов выполнен успешно.");
			Если ПоказыватьСтруктуруХранения Тогда
				ОбновитьСтрокуРегистра();
			КонецЕсли; 
		КонецЕсли; 
		//ирОбщий.ОткрытьЗапросСУБДЛкс(ТекстЗапроса, "Очистка нулевых итогов");
	КонецЕсли; 

КонецПроцедуры

Процедура СтатистикаПриОбновленииСпискаПриИзменении(Элемент)
	
	ОбновитьТаблицуРегистров();
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ТаблицыИтоговРегистраПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

Процедура ПериодыИтоговПриАктивизацииСтроки(Элемент)
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура ПериодыИтоговПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеИтогамиРегистров.Форма.Форма");
мПлатформа = ирКэш.Получить();
мСписокНазначенийТаблицИтогов = ",Итоги,ИтогиМеждуСчетами,ИтогиПоСчетам,ИтогиПоСчетамССубконто1,ИтогиПоСчетамССубконто2,ИтогиПоСчетамССубконто3,";
	//+ "НастройкиХраненияИтоговРегистраБухгалтерии,НастройкиХраненияИтоговРегистраНакопления,";

