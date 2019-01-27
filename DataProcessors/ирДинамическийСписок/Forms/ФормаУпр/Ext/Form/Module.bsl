﻿#Если Не ВебКлиент И Не ТонкийКлиент И Не МобильныйКлиент Тогда

Процедура УстановитьОбъектМетаданных(ПолноеИмяТаблицы = Неопределено) Экспорт

	ЭлементыФормы = Элементы;
	Если ПолноеИмяТаблицы <> Неопределено Тогда
		ЗначениеИзменено = Ложь;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(фОбъект.ПолноеИмяТаблицы, ПолноеИмяТаблицы, ЗначениеИзменено);
		Если Не ЗначениеИзменено Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли;
	Если ЭлементыФормы.Найти("ДинамическийСписокВременноеПоле") <> Неопределено Тогда
		Элементы.ДинамическийСписокВременноеПоле.Видимость = Ложь;
		Элементы.Переместить(Элементы.ДинамическийСписокВременноеПоле, ЭтаФорма);
	КонецЕсли; 
	Элементы.ДинамическийСписок.Видимость = Истина;
	ЭлементыФормы.ДинамическийСписок.ИзменятьСоставСтрок = Истина;
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(фОбъект.ПолноеИмяТаблицы);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ОсновнойЭУ.РежимВыбора = РежимВыбора;
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(фОбъект.ПолноеИмяТаблицы);
	ЭтаФорма.ЕстьОграниченияДоступа = ирОбщий.ЕстьОграниченияДоступаКСтрокамТаблицыЛкс(ОбъектМД);
	ЭлементыФормы.ПраваДоступаКСтрокам.Гиперссылка = ЕстьОграниченияДоступа;
	ТипТаблицыБД = ирОбщий.ПолучитьТипТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
	Если Ложь
		Или ТипТаблицыБД = "Последовательность"
		Или ТипТаблицыБД = "Изменения"
		Или ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицыБД)
	Тогда
		//Сообщить("Динамический список для таблицы """ + фОбъект.ОбъектМетаданных + """ недоступен");
		ДинамическийСписок.ПроизвольныйЗапрос = Истина;
		ДинамическийСписок.ТекстЗапроса = "ВЫБРАТЬ * ИЗ " + фОбъект.ПолноеИмяТаблицы;
	Иначе
		ДинамическийСписок.ОсновнаяТаблица = фОбъект.ПолноеИмяТаблицы;
	КонецЕсли; 
	Если Не ирСервер.НастроитьАвтоТаблицуФормыДинамическогоСпискаЛкс(ЭтаФорма, ОсновнойЭУ, фОбъект.ПолноеИмяТаблицы, фОбъект.РежимИмяСиноним) Тогда 
		фОбъект.ПолноеИмяТаблицы = "";
		Возврат;
	КонецЕсли;
	Элементы.ДинамическийСписокРедакторОбъектаБД.Доступность = ТипТаблицыБД <> "Изменения";
	ПредставлениеТаблицы = ирОбщий.ПолучитьОписаниеТаблицыБДИис(фОбъект.ПолноеИмяТаблицы).Представление;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеТаблицы, ": ");
	Если РежимВыбора Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (выбор)";
	КонецЕсли; 
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(фОбъект.ПолноеИмяТаблицы);
	фОбъект.ВместоОсновной = ирОбщий.ПолучитьИспользованиеДинамическогоСпискаВместоОсновнойФормыЛкс(фОбъект.ПолноеИмяТаблицы);
	ОбновитьСлужебныеДанные();
	//Попытка
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Наименование.ОтображатьИерархию = Истина;
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.ОтображатьИерархию = Ложь;
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.Видимость = Ложь;
	//Исключение
	//КонецПопытки;
	//ЭлементыФормы.КоманднаяПанельПереключателяДерева.Кнопки.РежимДерева.Доступность = ирОбщий.ЛиМетаданныеИерархическогоОбъектаЛкс(ОбъектМД);
	//ирОбщий.НастроитьТабличноеПолеЛкс(ОсновнойЭУ);
	ДинамическийСписок.КомпоновщикНастроек.Восстановить(); // Не влияет на пользовательские настройки
	ЗагрузитьНастройкиСписка();
	фОбъект.СтарыйОбъектМетаданных = фОбъект.ПолноеИмяТаблицы;
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.ПоследниеВыбранные);
	//РезультирующаяСхема = Элементы.ДинамическийСписок.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	//АдресСхемы = ПоместитьВоВременноеХранилище(РезультирующаяСхема, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

Процедура СохранитьНастройкиСписка()
	
	Если Не ЗначениеЗаполнено(фОбъект.СтарыйОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.НастройкиКолонок.Очистить();
	Для Каждого КолонкаТП Из Элементы.ДинамическийСписок.ПодчиненныеЭлементы Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(ОписаниеКолонки, КолонкаТП,, "Имя"); 
		ОписаниеКолонки.Имя = ИмяКолонкиБезРодителя(ЭтаФорма, КолонкаТП);
		ОписаниеКолонки.ВысотаЯчейки = КолонкаТП.Высота;
	КонецЦикла;
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("НастройкиКолонок", фОбъект.НастройкиКолонок.Выгрузить());
	СтруктураНастроек.Вставить("ПользовательскиеНастройки", ЭтаФорма.ДинамическийСписок.КомпоновщикНастроек.ПользовательскиеНастройки);
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, СтруктураНастроек);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяКолонкиБезРодителя(ЭтаФорма, Колонка)
	
	Возврат Сред(Колонка.Имя, СтрДлина(ЭтаФорма.Элементы.ДинамическийСписок.Имя) + 1);
	
КонецФункции

Процедура ЗагрузитьНастройкиСписка()
	
	СохраненныеНастройки = ирОбщий.ВосстановитьЗначениеЛкс("ДинамическийСписок." + фОбъект.ПолноеИмяТаблицы + "." + РежимВыбора);
	Если СохраненныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
		#Если Сервер И Не Сервер Тогда
		    СохраненныеНастройки = Новый Структура;
		#КонецЕсли
	// Чтобы сбросились пользовательские настройки
	ЭтаФорма.ДинамическийСписок.КомпоновщикНастроек.Инициализировать(ДинамическийСписок.КомпоновщикНастроек.ПолучитьИсточникДоступныхНастроек()); 
	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		фОбъект.НастройкиКолонок.Загрузить(СохраненныеНастройки.НастройкиКолонок);
		Если СохраненныеНастройки.Свойство("ПользовательскиеНастройки") Тогда
			ЭтаФорма.ДинамическийСписок.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(СохраненныеНастройки.ПользовательскиеНастройки);
		КонецЕсли; 
	КонецЕсли; 
	ПрименитьНастройкиКолонок();
	// Чтобы появилась команда ALT+F "Расширенный поиск"
	Элементы.ДинамическийСписок.Видимость = Ложь;
	Элементы.ДинамическийСписок.Видимость = Истина;
	
КонецПроцедуры

Процедура ПрименитьНастройкиКолонок()
	
	НачальноеКоличество = фОбъект.НастройкиКолонок.Количество(); 
	КолонкиТП = Элементы.ДинамическийСписок.ПодчиненныеЭлементы;
	Для Счетчик = 1 По НачальноеКоличество Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок[НачальноеКоличество - Счетчик];
		КолонкаТП = КолонкиТП.Найти(Элементы.ДинамическийСписок.Имя + ОписаниеКолонки.Имя);
		Если КолонкаТП <> Неопределено Тогда
			//КолонкиТП.Сдвинуть(КолонкаТП, -КолонкиТП.Индекс(КолонкаТП));
			Элементы.Переместить(КолонкаТП, КолонкаТП.Родитель, КолонкиТП[0]);
			КолонкаТП.Видимость = ОписаниеКолонки.Видимость;
			Если ОписаниеКолонки.Ширина > 0 Тогда
				КолонкаТП.Ширина = ОписаниеКолонки.Ширина;
			КонецЕсли; 
			Если ОписаниеКолонки.ВысотаЯчейки > 0 Тогда
				КолонкаТП.Высота = ОписаниеКолонки.ВысотаЯчейки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура НайтиСсылкуВСписке(КлючСтроки, УстановитьОбъектМетаданных = Истина) Экспорт

	#Если ТонкийКлиент Или ВебКлиент Тогда
		Возврат;
	#Иначе
		ЭлементыФормы = Элементы;
		МетаданныеТаблицы = Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(КлючСтроки));
		Если УстановитьОбъектМетаданных Тогда
			УстановитьОбъектМетаданныхНаКлиенте(МетаданныеТаблицы.ПолноеИмя());
		КонецЕсли; 
		ИмяXMLТипа = СериализаторXDTO.XMLТипЗнч(КлючСтроки).ИмяТипа;
		Если Ложь
			Или Найти(ИмяXMLТипа, "Ref.") > 0
			Или Найти(ИмяXMLТипа, "RecordKey.") > 0
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
		Иначе
			ирОбщий.СкопироватьОтборЛюбойЛкс(ПользовательскийОтбор(), КлючСтроки.Методы.Отбор);
		КонецЕсли; 
	#КонецЕсли 

КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхПриИзменении(Элемент)
	СохранитьНастройкиСписка();
	ЭтаФорма.КлючУникальности = фОбъект.ПолноеИмяТаблицы;
	ЭтаФорма.мКлючУникальности = ЭтаФорма.КлючУникальности;
	УстановитьОбъектМетаданныхНаКлиенте();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбъектМетаданныхНаКлиенте(ПолноеИмяТаблицы = Неопределено)
	
	УстановитьОбъектМетаданных(ПолноеИмяТаблицы);
	ОбновитьКоличествоСтрокОтложенно();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоСтрокОтложенно()
	
	фОбъект.КоличествоСтрокВОбластиПоиска = "";
	ПодключитьОбработчикОжидания("ОбновитьКоличествоСтрок", 0.1, Истина);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ДинамическийСписок.Видимость = Ложь;
	ЭлементыФормы = Элементы;
	НачальноеЗначениеВыбора = Параметры.ТекущаяСтрока;
	ЭтаФорма.РежимВыбора = Параметры.РежимВыбора;
	Элементы.ОбъектМетаданных.ТолькоПросмотр = РежимВыбора;
	ирСервер.УправляемаяФорма_ПриСозданииЛкс(ЭтаФорма, Отказ, СтандартнаяОбработка,, ПоляСИсториейВыбора());
	НовоеИмяТаблицы = Параметры.ИмяТаблицы;
	Если ЗначениеЗаполнено(НовоеИмяТаблицы) Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(НовоеИмяТаблицы);
		Если ОбъектМД <> Неопределено Тогда
			УстановитьОбъектМетаданных(НовоеИмяТаблицы);
		КонецЕсли;
	КонецЕсли; 
	Если Истина
		И ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы)
		И НачальноеЗначениеВыбора <> Неопределено 
		И ЗначениеЗаполнено(НачальноеЗначениеВыбора) 
	Тогда
		Если Ложь
			Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь)
			Или ирОбщий.ЛиСсылкаНаПеречислениеЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиКлючЗаписиРегистраЛкс(НачальноеЗначениеВыбора)
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = НачальноеЗначениеВыбора;
		//ИначеЕсли ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь) Тогда 
		//	ДанныеСписка = ирОбщий.ПолучитьДанныеЭлементаУправляемойФормыЛкс(ЭлементыФормы.ДинамическийСписок); //
		//	ТекущаяСтрока = ДанныеСписка.Найти(НачальноеЗначениеВыбора, "Ссылка");
		//	Если ТекущаяСтрока <> Неопределено Тогда
		//		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = ТекущаяСтрока;
		//	КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	Если ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДинамическийСписок;
	КонецЕсли; 
	Если РежимВыбора Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Функция ПоляСИсториейВыбора()
	
	Возврат Элементы.ОбъектМетаданных;

КонецФункции

&НаСервереБезКонтекста
Процедура ДинамическийСписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	#Если Сервер И Не Сервер Тогда
	    Настройки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	РасширенноеПредставлениеХранилищЗначений = Ложь;
	РасширенныеКолонки = Неопределено;
	ИменаКолонокСПиктограммамиТипов = Неопределено;
	КолонкиТаблицы = Настройки.Выбор.Элементы;
	ВариантОтображенияИдентификаторов = Неопределено;
	Настройки.ДополнительныеСвойства.Свойство("ОтображениеИдентификаторов", ВариантОтображенияИдентификаторов);
	СостоянияКнопки = ирОбщий.ПолучитьСостоянияКнопкиОтображатьПустыеИИдентификаторыЛкс();
	ЛиОтбражатьПустые = Ложь
		Или ВариантОтображенияИдентификаторов = СостоянияКнопки[1]
		Или ВариантОтображенияИдентификаторов = СостоянияКнопки[2];
	ОтображатьИдентификаторы = Ложь
			Или ВариантОтображенияИдентификаторов = СостоянияКнопки[2];
	ирПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    ирПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ТипЗнч(ИменаКолонокСПиктограммамиТипов) = Тип("Строка") Тогда
		ИменаКолонокСПиктограммамиТипов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ИменаКолонокСПиктограммамиТипов, ",", Истина); 
	КонецЕсли; 
	Для Каждого СтрокаСписка Из Строки Цикл
		СтрокаОформления = СтрокаСписка.Значение;
		ДанныеСтроки = СтрокаОформления.Данные;
		Ячейки = СтрокаОформления.Оформление;
		Для Каждого Ячейка Из Ячейки Цикл
			//КолонкаОтображаетДанныеФлажка = Ложь;
			ЗначениеЯчейки = ДанныеСтроки[Ячейка.Ключ];
			//Если Ложь
			//	Или КолонкаОтображаетДанныеФлажка
			//	Или Формат(ЗначениеЯчейки, Колонка.Формат) = Ячейка.Текст 
			//Тогда // Здесь могут быть обращения к БД
				ПредставлениеЗначения = "";
				//Если Истина
				//	И Не КолонкаОтображаетДанныеФлажка
				//	И ТипЗнч(ЗначениеЯчейки) <> Тип("Строка") 
				//Тогда
				//	ПредставлениеЗначения = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеЯчейки, Колонка,, РасширенноеПредставлениеХранилищЗначений);
				//КонецЕсли; 
				Если ЛиОтбражатьПустые И Не ирОбщий.ЭтоКоллекцияЛкс(ЗначениеЯчейки) Тогда
					ЦветПустых = ирОбщий.ЦветФонаЯчеекПустыхЗначенийЛкс();
					Если ТипЗнч(ЗначениеЯчейки) = Тип("Строка") Тогда
						ПредставлениеЗначения = """" + ЗначениеЯчейки + """";
						Ячейка.Значение.УстановитьЗначениеПараметра("ЦветФона", ЦветПустых);
					Иначе
						Попытка
							ЗначениеНепустое = ЗначениеЗаполнено(ЗначениеЯчейки) И ЗначениеЯчейки <> Ложь;
						Исключение
							ЗначениеНепустое = Истина;
						КонецПопытки;
						Если Не ЗначениеНепустое Тогда
							ПредставлениеЗначения = ирПлатформа.мПолучитьПредставлениеПустогоЗначения(ЗначениеЯчейки);
							Ячейка.Значение.УстановитьЗначениеПараметра("ЦветФона", ЦветПустых);
						КонецЕсли;
					КонецЕсли; 
				КонецЕсли; 
				Если ПредставлениеЗначения <> "" Тогда
					Ячейка.Значение.УстановитьЗначениеПараметра("Текст", ПредставлениеЗначения);
				КонецЕсли; 
			//КонецЕсли; 
			Если ОтображатьИдентификаторы Тогда
				ИдентификаторСсылки = ирОбщий.ПолучитьИдентификаторСсылкиЛкс(ЗначениеЯчейки);
				Если ИдентификаторСсылки <> Неопределено Тогда
					XMLТип = XMLТипЗнч(ЗначениеЯчейки);
					ИдентификаторСсылки = ИдентификаторСсылки + "." + XMLТип.ИмяТипа;
				КонецЕсли; 
				Если ИдентификаторСсылки <> Неопределено Тогда
					Ячейка.Значение.УстановитьЗначениеПараметра("Текст", ИдентификаторСсылки);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;  
		Если Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("ИдентификаторСсылкиЛкс")) <> Неопределено Тогда
			Попытка
				ЯчейкаИдентификатора = Ячейки["ИдентификаторСсылкиЛкс"];
			Исключение
				// Скрыли колонку в таблице
			КонецПопытки;
			Если ЯчейкаИдентификатора <> Неопределено Тогда
				Ссылка = ДанныеСтроки.Ссылка;
				Если ирОбщий.ЛиСсылкаНаПеречислениеЛкс(Ссылка) Тогда
					ИдентификаторСсылки = "" + XMLСтрока(Ссылка);
				Иначе
					ИдентификаторСсылки = "" + ирОбщий.ПолучитьИдентификаторСсылкиЛкс(Ссылка);
				КонецЕсли; 
				ЯчейкаИдентификатора.УстановитьЗначениеПараметра("Текст", ИдентификаторСсылки);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ирОбщий.ДинамическийСписок_ОбъектМетаданных_НачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		лПолноеИмяОбъекта = Неопределено;
		Если ВыбранноеЗначение.Свойство("ПолноеИмяОбъекта", лПолноеИмяОбъекта) Тогда
			фОбъект.ПолноеИмяТаблицы = ВыбранноеЗначение.ПолноеИмяОбъекта;
			ОбъектОбъектМетаданныхПриИзменении(Элемент);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтрокуЧерезРедакторОбъектаБД(Команда)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(Элементы.ДинамическийСписок, фОбъект.ПолноеИмяТаблицы,,,,, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РедакторОбъектаБДЯчейки(Команда)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

&НаСервере
Процедура ОбъектРежимИмяСинонимПриИзмененииНаСервере()
	ирОбщий.НастроитьЗаголовкиАвтоТаблицыФормыДинамическогоСпискаЛкс(Элементы.ДинамическийСписок, фОбъект.ПолноеИмяТаблицы, фОбъект.РежимИмяСиноним);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектРежимИмяСинонимПриИзменении(Элемент)
	ОбъектРежимИмяСинонимПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НовоеОкно(Команда)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Функция Отбор() Экспорт 
	Возврат ДинамическийСписок.Отбор;
КонецФункции

&НаКлиенте
Функция ПользовательскийОтбор() Экспорт 
	
	НастройкиСписка = ирОбщий.НастройкиДинамическогоСпискаЛкс(ДинамическийСписок, "Пользовательские");
	Возврат НастройкиСписка.Отбор;
	
КонецФункции

&НаКлиенте
Процедура ОсновнаяФорма(Команда)
	
	ЭлементыФормы = Элементы;
	МножественныйВыбор = ЭлементыФормы.ДинамическийСписок.МножественныйВыбор;
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	Если РежимВыбора Тогда
		Закрыть();
	КонецЕсли; 
	//Попытка
		Отбор = ДинамическийСписок.Отбор;
	//Исключение
	//	Отбор = Неопределено;
	//КонецПопытки;
	Форма = ирОбщий.ОткрытьФормуСпискаЛкс(фОбъект.ПолноеИмяТаблицы, Отбор, Ложь, ВладелецФормы, РежимВыбора, МножественныйВыбор, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
	Если Форма = Неопределено Тогда
		ЭтаФорма.Открыть();
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкиКолонок(Команда)
	СброситьНастройкиКолонокНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьНастройкиКолонокНаСервере()
	
	ХранилищеОбщихНастроек.Сохранить(ирОбщий.ИмяПродуктаЛкс(), "ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, Неопределено);
	УстановитьОбъектМетаданных();
	СохранитьНастройкиСписка();
	
КонецПроцедуры

Процедура СколькоСтрокНаСервере()
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаСервере();
	ирОбщий.ТабличноеПолеИлиТаблицаФормы_СколькоСтрокЛкс(ЭлементыФормы.ДинамическийСписок, НастройкиСписка);
КонецПроцедуры

&НаКлиенте
Процедура СколькоСтрок(Команда)
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	СколькоСтрокНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьНужноеКоличество(Команда)
	
	Количество = 10;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли; 
	ВыделитьНужноеКоличествоНаСервере(Количество);

КонецПроцедуры

&НаСервере
Процедура ВыделитьНужноеКоличествоНаСервере(Знач Количество)
	
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаСервере();
	ирОбщий.ВыделитьПервыеСтрокиДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, Количество, НастройкиСписка);

КонецПроцедуры

&НаКлиенте
Процедура РазличныеЗначенияКолонки(Команда)
	
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаКлиенте();
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ДинамическийСписок, НастройкиСписка);

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСписка(Команда)
	
	ИсполняемаяСхема = Неопределено;
	ИсполняемыеНастройки = НастройкиРезультатаНаКлиенте(ИсполняемаяСхема);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИсполняемыеНастройки", ИсполняемыеНастройки);
	ПараметрыФормы.Вставить("ИсполняемаяСхема", ИсполняемаяСхема);
	ПараметрыФормы.Вставить("ФиксированныеНастройки", ДинамическийСписок.КомпоновщикНастроек.ФиксированныеНастройки);
	ПараметрыФормы.Вставить("Настройки", ДинамическийСписок.КомпоновщикНастроек.Настройки);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", ДинамическийСписок.КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("ИсточникДоступныхНастроек", ДинамическийСписок.КомпоновщикНастроек.ПолучитьИсточникДоступныхНастроек());
	ОткрытьФорму("Обработка.ирДинамическийСписок.Форма.НастройкиСпискаУпр", ПараметрыФормы, ЭтаФорма,,,, Новый ОписаниеОповещения("ЗавершениеНастройкиСписка", ЭтаФорма));

КонецПроцедуры

&НаКлиенте
Процедура ОПодсистеме(Команда)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОбъекты(Команда)
	
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаКлиенте();
	ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, НастройкиСписка);

КонецПроцедуры

&НаКлиенте
Функция НастройкиРезультатаНаКлиенте(выхАдресСхемы = Неопределено)
	
	выхАдресСхемы = Неопределено;
    НастройкаКомпоновки = Неопределено;
    ИсполняемыеСхемаИНастройка(выхАдресСхемы, НастройкаКомпоновки);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(выхАдресСхемы));
	Компоновщик.ЗагрузитьНастройки(НастройкаКомпоновки);
	Результат = Компоновщик.Настройки;
	Возврат Результат;
	
КонецФункции

Функция НастройкиРезультатаНаСервере()
	
	АдресСхемы = Неопределено;
    НастройкаКомпоновки = Неопределено;
    ИсполняемыеСхемаИНастройка(АдресСхемы, НастройкаКомпоновки);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	Компоновщик.ЗагрузитьНастройки(НастройкаКомпоновки);
	Результат = Компоновщик.Настройки;
	Возврат Результат;
	
КонецФункции

Процедура ИсполняемыеСхемаИНастройка(АдресСхемы, НастройкаКомпоновки)
	
	АдресСхемы = ПоместитьВоВременноеХранилище(Элементы.ДинамическийСписок.ПолучитьИсполняемуюСхемуКомпоновкиДанных(), УникальныйИдентификатор);
	НастройкаКомпоновки = Элементы.ДинамическийСписок.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();

КонецПроцедуры

&НаКлиенте
Процедура ОтборБезЗначенияВТекущейКолонке(Команда)
	
	ЭлементыФормы = Элементы;
	
	// Для поддержки динамически добавленных (пользователем) полей списка. Но почему то не заработало
	//ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	//Если Не ЗначениеЗаполнено(ДанныеКолонки) Тогда
	//	ОбновитьСлужебныеДанные();
	//КонецЕсли;
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСлужебныеДанные()
	
	ирСервер.УправляемаяФорма_ОбновитьСлужебныеДанныеЛкс(ЭтаФорма,, ПоляСИсториейВыбора());

КонецПроцедуры

&НаКлиенте
Процедура ВывестиСтроки(Команда)
	
	ЭлементыФормы = Элементы;
	НастройкиСписка = НастройкиРезультатаНаКлиенте();
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ЭлементыФормы.ДинамическийСписок,, НастройкиСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор(Команда)
	
	ПользовательскиеНастройки = ирОбщий.НастройкиДинамическогоСпискаЛкс(ДинамическийСписок, "Пользовательские");
	Для Каждого ЭлементОтбора Из ПользовательскиеНастройки.Отбор.Элементы Цикл
		ЭлементОтбора.Использование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображениеИдентификаторов(Команда)
	
	ЭлементыФормы = Элементы;
	Кнопка = ЭлементыФормы.ФормаОтображениеИдентификаторов;
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ДинамическийСписок.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ОтображениеИдентификаторов", Кнопка.Заголовок);
	ЭлементыФормы.ДинамическийСписок.Обновить();
	
КонецПроцедуры

&НаКлиенте
Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ЭлементыФормы = Элементы;
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ДинамическийСписок, , Кнопка);
	
КонецФункции

&НаКлиенте
Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ВыбраннаяСтрока);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура СтруктураФормы(Команда)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеНастройкиСписка(Результат, Параметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
		ДинамическийСписок.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(Результат);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ЭлементыФормы = Элементы;
	
	Ответ = Вопрос("Использовать редактор объекта БД?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		ДобавитьСтрокуЧерезРедакторОбъектаБД(, Копирование, Группа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоСтрок()
	
	фОбъект.КоличествоСтрокВОбластиПоиска = ирОбщий.КоличествоСтрокВТаблицеБДЛкс(фОбъект.ПолноеИмяТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьКоличествоСтрокОтложенно();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаКолонок(Команда)
	
	СохранитьНастройкиСписка();
	ФормаНастроек = ирОбщий.ПолучитьФормуЛкс("Обработка.ирДинамическийСписок.Форма.НастройкиКолонок",, ЭтаФорма);
	ФормаНастроек.ОбработкаОбъект1.НастройкиКолонок.Загрузить(НастройкаКолонокСервер());
	Если Элементы.ДинамическийСписок.ТекущийЭлемент <> Неопределено Тогда
		ФормаНастроек.ПараметрИмяТекущейКолонки = ИмяКолонкиБезРодителя(ЭтаФорма, Элементы.ДинамическийСписок.ТекущийЭлемент);
	КонецЕсли; 
	ВыбранноеЗначение = ФормаНастроек.ОткрытьМодально();
	ОбработатьВыборНастроекКолонок(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборНастроекКолонок(Знач ВыбранноеЗначение)
	
	ОбработатьВыборНастроекКолонокСервер(ВыбранноеЗначение);

КонецПроцедуры

Процедура ОбработатьВыборНастроекКолонокСервер(Знач ВыбранноеЗначение)
	
	СтарыеНастройки = фОбъект.НастройкиКолонок.Выгрузить();
	Если ВыбранноеЗначение <> Неопределено Тогда
		Если ВыбранноеЗначение.Свойство("НастройкиКолонок") Тогда
			Если ВыбранноеЗначение.ПрименятьПорядок Тогда
				фОбъект.НастройкиКолонок.Загрузить(ВыбранноеЗначение.НастройкиКолонок);
			Иначе
				Для Каждого СтрокаКолонки Из фОбъект.НастройкиКолонок Цикл
					СтрокаНастройки = ВыбранноеЗначение.НастройкиКолонок.Найти(СтрокаКолонки.Имя, "Имя");
					ЗаполнитьЗначенияСвойств(СтрокаКолонки, СтрокаНастройки,, "Имя"); 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
		Если ВыбранноеЗначение.Свойство("ТекущаяКолонка") Тогда
			Элементы.ДинамическийСписок.ТекущийЭлемент = Элементы.ДинамическийСписок.ПодчиненныеЭлементы.Найти(Элементы.ДинамическийСписок.Имя + ВыбранноеЗначение.ТекущаяКолонка);
		КонецЕсли; 
	КонецЕсли; 
	ПрименитьНастройкиКолонок();
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение.Свойство("Сохранить") И ВыбранноеЗначение.Сохранить Тогда
		СохранитьНастройкиСписка();
	Иначе
		фОбъект.НастройкиКолонок.Загрузить(СтарыеНастройки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ОбработатьВыборНастроекКолонок(ВыбранноеЗначение);
	КонецЕсли; 
	
КонецПроцедуры

Функция НастройкаКолонокСервер()
	
	Возврат фОбъект.НастройкиКолонок.Выгрузить();

КонецФункции

&НаКлиенте
Процедура ОбъектМетаданныхОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Если ирОбщий.ПолучитьОписаниеТаблицыБДИис(Текст) <> Неопределено Тогда
			Значение = Новый СписокЗначений;
			Значение.Добавить(Текст);
		ИначеЕсли ирОбщий.ДинамическийСписок_ОбъектМетаданных_НачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка, Текст) <> Неопределено Тогда 
			Значение = Новый СписокЗначений;
			Значение.Добавить(ирОбщий.ДанныеЭлементаФормыЛкс(Элемент));
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступаКСтрокамНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Форма = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, фОбъект.ПолноеИмяТаблицы);
	Форма.ПолноеИмяТаблицы = фОбъект.ПолноеИмяТаблицы;
	Форма.Пользователь = ИмяПользователя();
	Форма.ПараметрКлючВарианта = "ПоПользователям";
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокуЧерезРедакторОбъектаБД(Команда = Неопределено, Копирование = Неопределено, ЭтоГруппа = Ложь)
	
	ЭлементыФормы = Элементы;
	Если Копирование = Неопределено Тогда
		Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока <> Неопределено Тогда
			Ответ = Вопрос("Хотите скопировать текущую строку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
			Копирование = Ответ = КодВозвратаДиалога.Да;
		Иначе
			Копирование = Ложь;
		КонецЕсли; 
	КонецЕсли; 
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(фОбъект.ПолноеИмяТаблицы);
	Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(фОбъект.ПолноеИмяТаблицы)) Тогда
		Если ПравоДоступа("Добавление", ОбъектМД) Тогда
			Отбор = ДинамическийСписок.КомпоновщикНастроек.ПолучитьНастройки().Отбор;
			ЭлементОтбораЭтоГруппа = ирОбщий.НайтиЭлементОтбораКомпоновкиЛкс(Отбор, "ЭтоГруппа");
			Если Копирование Тогда
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
				СтруктураОбъекта = ирОбщий.КопияОбъектаБДЛкс(СтруктураОбъекта);
			Иначе
				ЭтоГруппа = Ложь
					Или ЭтоГруппа = Истина
					Или (Истина
						И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(ОбъектМД)
						И ЭлементОтбораЭтоГруппа <> Неопределено
						И ЭлементОтбораЭтоГруппа.Использование = Истина
						И ЭлементОтбораЭтоГруппа.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
						И ЭлементОтбораЭтоГруппа.Значение = Истина);
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, ЭтоГруппа);
			КонецЕсли; 
			ирОбщий.УстановитьЗначенияРеквизитовПоОтборуЛкс(СтруктураОбъекта.Данные, Отбор);
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(СтруктураОбъекта);
		Иначе
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(Новый(СтрЗаменить(фОбъект.ПолноеИмяТаблицы, ".", "Ссылка.")));
		КонецЕсли; 
	Иначе
		КлючОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, Ложь);
		Для Каждого КлючИЗначение Из КлючОбъекта Цикл
			Если Копирование Тогда
				КлючОбъекта[КлючИЗначение.Ключ] = ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока[КлючИЗначение.Ключ];
			КонецЕсли; 
		КонецЦикла;
		СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, КлючОбъекта);
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СтруктураОбъекта);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныйРедакторОбъектаБДСтроки(Команда)
	
	Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка = Не Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка;
	Если Не Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка Тогда
		Возврат;
	КонецЕсли; 
	Если Элементы.ДинамическийСписок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	Сообщить("Закрепите окно связанного редактора БД через его контекстное меню на панели открытых окон");

КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка Тогда
		ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвязанныйРедакторОбъектаБДСтроки()
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(Элементы.ДинамическийСписок, фОбъект.ПолноеИмяТаблицы,, Истина,,, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытСвязанныйРедакторОбъектаБД" Тогда
		Элементы.ФормаСвязанныйРедакторОбъектаБДСтроки.Пометка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецЕсли
