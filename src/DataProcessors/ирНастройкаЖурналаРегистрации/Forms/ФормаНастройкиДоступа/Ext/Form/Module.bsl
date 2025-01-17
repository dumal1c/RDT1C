﻿Перем ПереданныеНастройки Экспорт;
Перем ТекущийОбъектМД Экспорт;
Перем мИндексыКартинок; 
Перем мПлатформа;
Перем мПоляДоступа;
Перем мПоляРегистрации;
Перем мМетаданныеБезНастроекПолей;
Перем мПустаяТаблицаПолейРегистрации;
Перем мПустаяТаблицаПолейДоступа;

Процедура ОтобразитьПоляДоступаИРегистрацииДляСтрокиДерева(СтрокаДерева)

	ДоступностьПолейРегистрации = Ложь;
	ДоступностьПолейДоступа = Ложь;
	
	Если СтрокаДерева.ЭтоГруппа Или мМетаданныеБезНастроекПолей.Найти(СтрокаДерева.Родитель.ПолноеИмя) <> Неопределено Тогда
		
		ПоляРегистрации = мПустаяТаблицаПолейРегистрации;
		ПоляДоступа = мПустаяТаблицаПолейДоступа;  
		
	Иначе
		
		ДоступностьПолейРегистрации = Истина;
		
		ПоляРегистрации = мПоляРегистрации[СтрокаДерева.ПолноеИмя];  
	
		Если ЛиДоступ Тогда
			
			ПоляДоступа = мПоляДоступа[СтрокаДерева.ПолноеИмя];  
			ДоступностьПолейДоступа = Истина;
			
		КонецЕсли;  		
		
	КонецЕсли;
	
	ЭлементыФормы.ПоляРегистрации.Доступность = ДоступностьПолейРегистрации;
	ЭлементыФормы.КоманднаяПанельПоляРегистрации.Доступность = ДоступностьПолейРегистрации;
	ЭлементыФормы.ПоляДоступа.Доступность = ДоступностьПолейДоступа;
	ЭлементыФормы.КоманднаяПанельПоляДоступа.Доступность = ДоступностьПолейДоступа;
		  	
КонецПроцедуры

Функция ПреобразоватьМассивВСписок(Массив)

	Результат = Новый СписокЗначений;
	Для Каждого ЭлементМассива Из Массив Цикл
		
		Результат.Добавить(ЭлементМассива);
		
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

Функция СоздатьТаблицуПолейРегистрации()

	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ПолеРегистрации", Новый ОписаниеТипов("СписокЗначений"));
	Возврат Результат;
	
КонецФункции

Функция СоздатьТаблицуПолейДоступа()

	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ПолеДоступа", Новый ОписаниеТипов("Строка"));
	Возврат Результат;
	
КонецФункции

Функция ДобавитьОбъектМетаданныхВНастройку(ПолноеИмяОбъекта, пПоляРегистрации = Неопределено, пПоляДоступа = Неопределено, Интерактивно = Истина)
	
	ОбъектМетаданных = ирКэш.ОбъектМДПоПолномуИмениЛкс(ПолноеИмяОбъекта);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли; 
	ТекущаяСтрокаДерева = ДеревоМетаданных.Строки.Найти(ОбъектМетаданных.ПолноеИмя(), "ПолноеИмя", Истина);
	Если ТекущаяСтрокаДерева <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли; 
	ИмяКоллекции = ирОбщий.КорневойТипКонфигурацииЛкс(ОбъектМетаданных); 
	РодительскаяГруппа = ДеревоМетаданных.Строки.Найти(ИмяКоллекции, "ПолноеИмя");
	Если РодительскаяГруппа = Неопределено Тогда
		ирОбщий.СообщитьЛкс("Для объекта метаданных " + ПолноеИмяОбъекта + " невозможна настройка " + ?(ЛиДоступ, "доступа", "отказа в доступе"), СтатусСообщения.Внимание);
		Возврат Ложь; 
	КонецЕсли; 
	ТекущаяСтрокаДерева = ДобавитьСтрокуДерева(РодительскаяГруппа.Строки, ОбъектМетаданных.Представление(), ОбъектМетаданных.ПолноеИмя(), мИндексыКартинок[ИмяКоллекции]);
	мПоляРегистрации[ТекущаяСтрокаДерева.ПолноеИмя] = СоздатьТаблицуПолейРегистрации();
	Если пПоляРегистрации <> Неопределено Тогда
		ТаблицаПолейРегистрации = мПоляРегистрации[ТекущаяСтрокаДерева.ПолноеИмя];
		Для Каждого ПолеРегистрации Из пПоляРегистрации Цикл
			СтрокаТЗ = ТаблицаПолейРегистрации.Добавить();
			Если ТипЗнч(ПолеРегистрации) = Тип("Массив") Тогда
				СтрокаТЗ.ПолеРегистрации = ПреобразоватьМассивВСписок(ПолеРегистрации);
			Иначе
				СтрокаТЗ.ПолеРегистрации.Добавить(ПолеРегистрации);
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
	мПоляДоступа[ТекущаяСтрокаДерева.ПолноеИмя] = СоздатьТаблицуПолейДоступа();
	Если пПоляДоступа <> Неопределено Тогда
		ТаблицаПолейДоступа = мПоляДоступа[ТекущаяСтрокаДерева.ПолноеИмя];
		Для Каждого ПолеДоступа Из пПоляДоступа Цикл
			СтрокаТЗ = ТаблицаПолейДоступа.Добавить();
			СтрокаТЗ.ПолеДоступа = ПолеДоступа;
		КонецЦикла; 
	КонецЕсли;  		
	Если Интерактивно Тогда		
		ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока = ТекущаяСтрокаДерева;
		ОтобразитьПоляДоступаИРегистрацииДляСтрокиДерева(ТекущаяСтрокаДерева);		
	КонецЕсли; 
	Возврат Истина;
	
КонецФункции

Процедура ОтобразитьПереданныеНастройки()
	
	Если ПереданныеНастройки <> Неопределено Тогда
		
		Для Каждого ОписаниеИспользования Из ПереданныеНастройки Цикл
			
			ДобавитьОбъектМетаданныхВНастройку(ОписаниеИспользования.Объект, ОписаниеИспользования.ПоляРегистрации, ?(ЛиДоступ, ОписаниеИспользования.ПоляДоступа, Неопределено));
			
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

Функция ДобавитьСтрокуДерева(СтрокиДерева, Представление, ПолноеИмя, ИндексКартинки, ЭтоГруппа  = Ложь)
	
	СтрокаДерева = СтрокиДерева.Добавить();
	СтрокаДерева.Представление = Представление;
	СтрокаДерева.ПолноеИмя = ПолноеИмя;
	СтрокаДерева.ИндексКартинки = ИндексКартинки;	
	СтрокаДерева.ЭтоГруппа = ЭтоГруппа;
	Возврат СтрокаДерева;
	
КонецФункции

Процедура ПостроитьДерево()
	
	ДеревоМетаданных.Строки.Очистить();
	Если НЕ ЛиДоступ И НЕ КоллекцияОбъектовМетаданныхПуста("Константы") Тогда
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Константы", "Константа", мИндексыКартинок["Константа"] - 1 , Истина);
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("ПланыОбмена") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Планы обмена", "ПланОбмена", мИндексыКартинок["ПланОбмена"] - 1 , Истина);		
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("Справочники") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Справочники", "Справочник", мИндексыКартинок["Справочник"] - 1, Истина);
	КонецЕсли; 
    Если НЕ КоллекцияОбъектовМетаданныхПуста("Документы") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Документы", "Документ", мИндексыКартинок["Документ"] - 1, Истина);
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("ЖурналыДокументов") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Журналы документов",	"ЖурналДокументов", мИндексыКартинок["ЖурналДокументов"] - 1, Истина);
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("ПланыВидовХарактеристик") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Планы видов характеристик", "ПланВидовХарактеристик", мИндексыКартинок["ПланВидовХарактеристик"] - 1, Истина);
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("ПланыВидовРасчета") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Планы видов расчетов", "ПланВидовРасчета", мИндексыКартинок["ПланВидовРасчета"] - 1, Истина);
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("ПланыСчетов") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Планы счетов", "ПланСчетов", мИндексыКартинок["ПланСчетов"] - 1, Истина);
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("РегистрыСведений") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Регистры сведений", "РегистрСведений", мИндексыКартинок["РегистрСведений"] - 1, Истина);		
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("РегистрыНакопления") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Регистры накопления", "РегистрНакопления", мИндексыКартинок["РегистрНакопления"] - 1, Истина);	
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("РегистрыБухгалтерии") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Регистры бухгалтерии", "РегистрБухгалтерии", мИндексыКартинок["РегистрБухгалтерии"] - 1,	Истина);		
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("РегистрыРасчета") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Регистры расчета", "РегистрРасчета", мИндексыКартинок["РегистрРасчета"] - 1,	Истина);		
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("БизнесПроцессы") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Бизнес-процессы", "БизнесПроцесс", мИндексыКартинок["БизнесПроцесс"] - 1, Истина);		
	КонецЕсли; 
	Если НЕ КоллекцияОбъектовМетаданныхПуста("Задачи") Тогда		
		ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Задачи", "Задача", мИндексыКартинок["Задача"] - 1, Истина);		
	КонецЕсли; 
	//Если НЕ ЛиДоступ И НЕ КоллекцияОбъектовМетаданныхПуста("Обработки") Тогда
	//	ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Обработки", "Обработка", мИндексыКартинок["Обработка"] - 1 , Истина);
	//КонецЕсли;
	//Если НЕ ЛиДоступ И НЕ КоллекцияОбъектовМетаданныхПуста("Отчеты") Тогда
	//	ДобавитьСтрокуДерева(ДеревоМетаданных.Строки, "Отчеты", "Отчет", мИндексыКартинок["Отчет"] - 1 , Истина);
	//КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьМассивПолейДоступаДляСтрокиДерева(СтрокаДерева)

	ТаблицаПолей = мПоляДоступа[СтрокаДерева.ПолноеИмя]; 
	Если ТаблицаПолей = Неопределено Тогда
		
		Возврат Новый Массив();
		
	Иначе
		
		Возврат ТаблицаПолей.ВыгрузитьКолонку("ПолеДоступа");
		
	КонецЕсли; 
	
КонецФункции // ПолучитьМассивПолейДоступаДляСтрокиДерева()

Функция ПолучитьМассивПолейРегистрацииДляСтрокиДерева(СтрокаДерева)

	ТаблицаПолей = мПоляРегистрации[СтрокаДерева.ПолноеИмя]; 
	Если ТаблицаПолей = Неопределено Тогда
		
		Возврат Новый Массив();
		
	Иначе
		
		Результат = Новый Массив();
		
		Для Каждого СтрокаТЗ Из ТаблицаПолей Цикл
			
			Если СтрокаТЗ.ПолеРегистрации.Количество() = 1 Тогда
				
				Результат.Добавить(СтрокаТЗ.ПолеРегистрации[0].Значение);
				
			Иначе
				
				Результат.Добавить(СтрокаТЗ.ПолеРегистрации.ВыгрузитьЗначения());
				
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции // ПолучитьМассивПолейДоступаДляСтрокиДерева()

Функция КоллекцияОбъектовМетаданныхПуста(ИмяКоллекции)

	Возврат Метаданные[ИмяКоллекции].Количество() = 0; 

КонецФункции // КоллекцияОбъектовМетаданныхПуста()

Процедура ЗарегистрироватьСсылочныеОбъектыАвтоматически(МетаданныеДляРегистрации)
	
	Если МетаданныеДляРегистрации.Количество() = 0 Тогда
		Возврат;		
	КонецЕсли; 	
	
	ОчиститьСообщения();
	Для Каждого ОбъектМетаданных Из МетаданныеДляРегистрации Цикл
		СтрокаДерева = ДеревоМетаданных.Строки.Найти(ОбъектМетаданных, "ПолноеИмя", Истина);
		Если СтрокаДерева <> Неопределено Тогда
			Если Не ЕстьПолеСсылкаВТаблицеПолейРегистрации(мПоляРегистрации[ОбъектМетаданных]) Тогда
				ПолеРегистрации = Новый СписокЗначений();
				ПолеРегистрации.Добавить("Ссылка");
				мПоляРегистрации[ОбъектМетаданных].Добавить().ПолеРегистрации = ПолеРегистрации;
				ирОбщий.СообщитьЛкс("В поля регистрации объекта " + СтрокаДерева.Представление + " добавлен реквизит ""Ссылка""");
				Модифицированность = Истина;
			КонецЕсли; 
		Иначе
			ДобавитьОбъектМетаданныхВНастройку(ОбъектМетаданных, ирОбщий.ЗначенияВМассивЛкс("Ссылка"), Неопределено, Ложь);		
			СтрокаДерева = ДеревоМетаданных.Строки.Найти(ОбъектМетаданных, "ПолноеИмя", Истина);
			ирОбщий.СообщитьЛкс("Добавлен объект метаданных " + СтрокаДерева.Представление + " с полем регистрации ""Ссылка"""); 
			Модифицированность = Истина;
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	мПоляДоступа = Новый Соответствие;
	мПоляРегистрации = Новый Соответствие;
	ЭлементыФормы.ДеревоМетаданных.Колонки.Представление.ОтображатьИерархию = Истина;
	ЭлементыФормы.ПоляДоступа.Доступность = ЛиДоступ;
	ЭлементыФормы.КоманднаяПанельПоляДоступа.Доступность = ЛиДоступ;
	ЭлементыФормы.ДеревоМетаданных.Колонки.Доступ.Видимость = ЛиДоступ;
	ЭлементыФормы.ПроверитьПолнотуНастройкиПолейРегистрации.Видимость = ЛиДоступ;
	ЭтаФорма.Заголовок = ?(ЛиДоступ, "Настройка события Доступ.Доступ", "Настройка события Доступ.ОтказВДоступе");
	ПостроитьДерево();
	ОтобразитьПереданныеНастройки();
	Если ТекущийОбъектМД <> Неопределено Тогда
		ТекущаяСтрока = ДеревоМетаданных.Строки.Найти(ТекущийОбъектМД, "ПолноеИмя", Истина);
		Если ТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Модифицированность И Вопрос(НСтр("ru = 'Настройки были изменены. Уверены?'"), РежимДиалогаВопрос.ДаНет, 60) = КодВозвратаДиалога.Нет;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	Закрыть(Неопределено);
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Если Модифицированность Тогда
		ВозвращаемыеНастройки = Новый Массив();
		Для Каждого СтрокаГруппа Из ДеревоМетаданных.Строки Цикл
			Для Каждого СтрокаОбъект Из СтрокаГруппа.Строки Цикл
				Описание = Новый Структура("Объект, ПоляРегистрации"+ ?(ЛиДоступ,", ПоляДоступа", ""));
				Описание.Объект = СтрокаОбъект.ПолноеИмя;
				Если ЛиДоступ Тогда
					Описание.ПоляДоступа = ПолучитьМассивПолейДоступаДляСтрокиДерева(СтрокаОбъект);
				КонецЕсли; 
				Описание.ПоляРегистрации = ПолучитьМассивПолейРегистрацииДляСтрокиДерева(СтрокаОбъект);
				ВозвращаемыеНастройки.Добавить(Описание);
			КонецЦикла; 
		КонецЦикла; 
		Модифицированность = Ложь;
		Закрыть(ВозвращаемыеНастройки);
	Иначе
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

Процедура ПроверитьПолнотуНастройкиПолейРегистрацииНажатие(Элемент)
	Меню = Новый СписокЗначений;
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока; 	
	Если ТекущаяСтрока <> Неопределено Тогда		
		Если НЕ ТекущаяСтрока.ЭтоГруппа Тогда
			Меню.Добавить("Объект", ТекущаяСтрока.Представление);
			Меню.Добавить("Коллекция", ТекущаяСтрока.Родитель.Представление);
		Иначе
			Меню.Добавить("Коллекция", ТекущаяСтрока.Представление);
		КонецЕсли;                                                           		
	КонецЕсли; 
		
	Меню.Добавить("Все", "Все");
	Выбор = Неопределено;
	Выбор = ВыбратьИзМеню(Меню, Элемент); 
	
	Если Выбор <> Неопределено Тогда
		
		ПроверяемыеМетаданные = Новый Массив();
		Если Выбор.Значение = "Объект" Тогда
			ПроверяемыеМетаданные.Добавить(ТекущаяСтрока.ПолноеИмя);	
		Иначе
			Поддерево = ДеревоМетаданных;
			Если Выбор.Значение = "Коллекция" Тогда
				Поддерево = ?(ТекущаяСтрока.ЭтоГруппа, ТекущаяСтрока, ТекущаяСтрока.Родитель);
			КонецЕсли; 
			Для Каждого СтрокаДерева Из Поддерево.Строки Цикл
				Если СтрокаДерева.ЭтоГруппа Тогда
					Для Каждого СтрокаДерева1 Из СтрокаДерева.Строки Цикл
						ПроверяемыеМетаданные.Добавить(СтрокаДерева1.ПолноеИмя);
					КонецЦикла; 					
				Иначе
					ПроверяемыеМетаданные.Добавить(СтрокаДерева.ПолноеИмя);
				КонецЕсли; 				
			КонецЦикла; 
		КонецЕсли; 
		
		Если ПроверяемыеМетаданные.Количество() > 0 Тогда
			ФормаПроверки = ПолучитьФорму("ФормаПроверкиМетаданных");
			ФормаПроверки.ЗаполнитьОбъектыДляРегистрации(ПроверяемыеМетаданные, ДеревоМетаданных, мПоляРегистрации);
			МетаданныеДляРегистрации = ФормаПроверки.ОткрытьМодально();
			Если МетаданныеДляРегистрации <> Неопределено Тогда
				ЗарегистрироватьСсылочныеОбъектыАвтоматически(МетаданныеДляРегистрации);				
			КонецЕсли; 
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДеревоМетаданныхПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 		
		Возврат;                            		
	КонецЕсли; 
	
	ОтобразитьПоляДоступаИРегистрацииДляСтрокиДерева(ТекущаяСтрока);
	
КонецПроцедуры

Процедура ДеревоМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого ПолноеИмяОбъекта Из ВыбранноеЗначение Цикл
		
		Модифицированность = ДобавитьОбъектМетаданныхВНастройку(ПолноеИмяОбъекта) ИЛИ Модифицированность;
		
	КонецЦикла;       	
	
КонецПроцедуры 

Процедура ДеревоМетаданныхПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	Если ДанныеСтроки.ЭтоГруппа Тогда
		ОформлениеСтроки.Ячейки.Представление.УстановитьТекст(ДанныеСтроки.Представление + " (" + ДанныеСтроки.Строки.Количество() + ")");
	Иначе
		ОформлениеСтроки.Ячейки.Регистрация.УстановитьФлажок(мПоляРегистрации[ДанныеСтроки.ПолноеИмя].Количество() <> 0);
		ОформлениеСтроки.Ячейки.Доступ.УстановитьФлажок(мПоляДоступа[ДанныеСтроки.ПолноеИмя].Количество() <> 0);
	КонецЕсли; 
КонецПроцедуры

Процедура ПоляРегистрацииПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	Если ДанныеСтроки.ПолеРегистрации.Количество() = 1 Тогда
		
		ТекстЯчейки = ДанныеСтроки.ПолеРегистрации[0].Значение;   		
		
	ИначеЕсли ДанныеСтроки.ПолеРегистрации.Количество() = 0 Тогда 
		
		ТекстЯчейки = "";
		
	Иначе
		
		ТекстЯчейки = "";
		
		Для Каждого ЭлементСписка Из ДанныеСтроки.ПолеРегистрации Цикл
			
			ТекстЯчейки = ТекстЯчейки + ЭлементСписка.Значение + ", ";
			
		КонецЦикла;
		
		ТекстЯчейки = "[" + Лев(ТекстЯчейки, СтрДлина(ТекстЯчейки) - 2) + "]";		
		
	КонецЕсли;  
	
	ОформлениеСтроки.Ячейки.ПолеРегистрации.УстановитьТекст(ТекстЯчейки);     		
	
КонецПроцедуры

Процедура ПоляРегистрацииПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	Если Не Копирование Тогда
		ДобавитьПолеРегистрации(ЭлементыФормы.КоманднаяПанельПоляРегистрации.Кнопки.МенюДобавить.Кнопки.ДобавитьПоле);		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоляДоступаПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
		
КонецПроцедуры

Процедура ПоляРегистрацииПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущаяСтрокаДерева = ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока;
	ТекущиеДанныеТаблицы = ЭлементыФормы.ПоляРегистрации.ТекущиеДанные;
	Если ТекущаяСтрокаДерева <> Неопределено И НЕ ТекущаяСтрокаДерева.ЭтоГруппа И ТекущиеДанныеТаблицы <> Неопределено Тогда
		ФормаВыбораПолей = ПолучитьФорму("ФормаВыбораПолей");
		ФормаВыбораПолей.ЛиДоступ = Ложь;
		ФормаВыбораПолей.мИмяОбъектаМетаданных = ТекущаяСтрокаДерева.ПолноеИмя;
		ФормаВыбораПолей.УстановитьИспользованиеПолей(ТекущиеДанныеТаблицы.ПолеРегистрации);
		Результат = ФормаВыбораПолей.ОткрытьМодально();
		Если Результат <> Неопределено Тогда
			ТекущиеДанныеТаблицы.ПолеРегистрации = Результат;	
			Модифицированность = Истина;
		КонецЕсли;                                                                  
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоляРегистрацииПослеУдаления(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

Процедура ПоляДоступаПослеУдаления(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

Процедура КоманднаяПанельОбъектыМетаданныхУдалить(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено И НЕ ТекущаяСтрока.ЭтоГруппа Тогда
		
		мПоляРегистрации[ТекущаяСтрока.ПолноеИмя] = Неопределено;
		мПоляДоступа[ТекущаяСтрока.ПолноеИмя] = Неопределено;
		Родитель = ТекущаяСтрока.Родитель;
		Родитель.Строки.Удалить(ТекущаяСтрока);
		ОтобразитьПоляДоступаИРегистрацииДляСтрокиДерева(Родитель);
		Модифицированность = Истина;
		
	КонецЕсли; 
КонецПроцедуры
                                                            
Процедура КоманднаяПанельОбъектыМетаданныхДобавить(Кнопка)
	
	ФормаВыбораМетаданных = мПлатформа.ПолучитьФорму("ВыборОбъектаМетаданных", ЭлементыФормы.ДеревоМетаданных, ЭтаФорма);
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьВнешниеИсточникиДанных", Истина);
	лСтруктураПараметров.Вставить("ОтображатьВыборочныеТаблицы", Истина);
	Если НЕ ЛиДоступ Тогда
		лСтруктураПараметров.Вставить("ОтображатьКонстанты", Истина);
	КонецЕсли; 
	Если НЕ ЛиДоступ Тогда
		лСтруктураПараметров.Вставить("ОтображатьОбработки", Истина);
		лСтруктураПараметров.Вставить("ОтображатьОтчеты", Истина);
	КонецЕсли; 
	лСтруктураПараметров.Вставить("МножественныйВыбор", Истина);
	ФормаВыбораМетаданных.НачальноеЗначениеВыбора = лСтруктураПараметров;
	ФормаВыбораМетаданных.ОткрытьМодально();   
	
КонецПроцедуры 

Процедура КоманднаяПанельПоляДоступаРедактировать(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено И НЕ ТекущаяСтрока.ЭтоГруппа Тогда
		
		ФормаВыбораПолей = ПолучитьФорму("ФормаВыбораПолей");
		ФормаВыбораПолей.ЛиДоступ = Истина;
		ФормаВыбораПолей.мИмяОбъектаМетаданных = ТекущаяСтрока.ПолноеИмя;
		ФормаВыбораПолей.УстановитьИспользованиеПолей(ПоляДоступа.ВыгрузитьКолонку("ПолеДоступа"));
		Результат = ФормаВыбораПолей.ОткрытьМодально();
		Если Результат <> Неопределено Тогда
			
			ПоляДоступа = мПоляДоступа[ТекущаяСтрока.ПолноеИмя];
			ПоляДоступа.Очистить();
			Для Каждого ЭлементСписка Из Результат Цикл
				
				Стр = ПоляДоступа.Добавить();
				Стр.ПолеДоступа = ЭлементСписка.Значение;
				
			КонецЦикла; 
			
			Модифицированность = Истина;
			
		КонецЕсли;                                                                  
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДобавитьПолеРегистрации(Кнопка)
			
	ТекущаяСтрока = ЭлементыФормы.ДеревоМетаданных.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено И НЕ ТекущаяСтрока.ЭтоГруппа Тогда
		ФормаВыбораПолей = ПолучитьФорму("ФормаВыбораПолей");
		ФормаВыбораПолей.ЛиДоступ = Ложь;
		ФормаВыбораПолей.мИмяОбъектаМетаданных = ТекущаяСтрока.ПолноеИмя;
		Результат = ФормаВыбораПолей.ОткрытьМодально();
		Если Результат <> Неопределено Тогда
			ПоляРегистрации = мПоляРегистрации[ТекущаяСтрока.ПолноеИмя];
			Если Кнопка.Имя = "ДобавитьПоле" Тогда
				Для Каждого ВыбранноеПоле Из Результат Цикл
					Стр = ПоляРегистрации.Добавить();
					Стр.ПолеРегистрации = Новый СписокЗначений();
					Стр.ПолеРегистрации.Добавить(ВыбранноеПоле.Значение, ВыбранноеПоле.Представление);
				КонецЦикла;
			Иначе
				Стр = ПоляРегистрации.Добавить();
				Стр.ПолеРегистрации = Результат;
			КонецЕсли; 
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	ПоляРегистрации.Сортировать("ПолеРегистрации");
	
КонецПроцедуры 

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирКлиент.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ПриОткрытии()
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирНастройкаЖурналаРегистрации.Форма.ФормаНастройкиДоступа");

мИндексыКартинок = Новый Соответствие;
мИндексыКартинок["Константа"] = 1;  
мИндексыКартинок["Справочник"] = 3;
мИндексыКартинок["Документ"] = 13;
мИндексыКартинок["ЖурналДокументов"] = 16;
мИндексыКартинок["ПланСчетов"] = 40;
мИндексыКартинок["ПланВидовРасчета"] = 48;
мИндексыКартинок["ПланВидовХарактеристик"] = 38;
мИндексыКартинок["ПланОбмена"] = 52;
мИндексыКартинок["Задача"] = 46;
мИндексыКартинок["БизнесПроцесс"] = 44;
мИндексыКартинок["РегистрБухгалтерии"] = 42;
мИндексыКартинок["РегистрНакопления"] = 32;
мИндексыКартинок["РегистрРасчета"] = 50;
мИндексыКартинок["РегистрСведений"] = 34;
// Почему-то нельзя использовать Отчеты и Обработки при описании события отказа в доступе, хотя по умолчанию система их регистрирует
//мИндексыКартинок["Обработка"] = 19;
//мИндексыКартинок["Отчет"] = 24;

мМетаданныеБезНастроекПолей = Новый Массив;
мМетаданныеБезНастроекПолей.Добавить("Константа");
//мМетаданныеБезНастроекПолей.Добавить("Обработка");
//мМетаданныеБезНастроекПолей.Добавить("Отчет");

мПустаяТаблицаПолейРегистрации = СоздатьТаблицуПолейРегистрации();
мПустаяТаблицаПолейДоступа = СоздатьТаблицуПолейДоступа();

мПлатформа = ирКэш.Получить();




