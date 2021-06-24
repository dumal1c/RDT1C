﻿Перем ПредставленияИмена;
Перем ПроверятьДоступностьПолей;
Перем ПолеТекстаВыражения;
Перем ВыражениеИсходное;

// Редактор HTML
Перем РедакторHTML;

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	Если Кнопка = ирОбщий.КнопкаКоманднойПанелиЭкземпляраКомпонентыЛкс(ПолеТекстаВыражения, "ПерейтиКОпределению") Тогда
		НачальнаяСтрока = 0;
		НачальнаяКолонка = 0;
		Если ПерейтиКОпределениюВФорме(НачальнаяСтрока, НачальнаяКолонка) Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли;
	ПолеТекстаВыражения.ВнешниеФункцииКомпоновкиДанных = ВнешниеФункцииРазрешены;
	ПолеТекстаВыражения.Нажатие(Кнопка);
	
КонецПроцедуры

Функция ПерейтиКОпределениюВФорме(Знач НомерСтроки = 0, Знач НомерКолонки = 0)
	
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ТекущееВыражение = ПолеТекстаВыражения.ТекущееОбъектноеВыражение(НомерСтроки, НомерКолонки);
	Если Лев(ТекущееВыражение, 1) = "&" Тогда
		ИмяПараметра = Сред(ТекущееВыражение, 2);
		ДоступныйПараметр = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных("ПараметрыДанных.ИмяПараметра"));
		Если ДоступныйПараметр <> Неопределено Тогда
			ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступныйПараметр;
			ПараметрСхемы = СхемаКомпоновки.Параметры.Найти(ирОбщий.ПоследнийФрагментЛкс(ДоступныйПараметр.Поле));
			Если ПараметрСхемы <> Неопределено Тогда
				Если ПараметрСхемы.Выражение <> "" Тогда
					Попытка 
						ЗначениеПараметра = Вычислить(ПараметрСхемы.Выражение);
						ОткрытьЗначение(ЗначениеПараметра);
					Исключение
						ирОбщий.СообщитьСУчетомМодальностиЛкс("Ошибка при вычислении параметра """ + ПараметрСхемы.ИмяПараметра + """"
						+ Символы.ПС + ОписаниеОшибки(), МодальныйРежим, СтатусСообщения.Важное);
					КонецПопытки;
				Иначе
					ЗначениеПараметра = ПараметрСхемы.Значение;
					ОткрытьЗначение(ЗначениеПараметра);
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
		Возврат Истина;
	Иначе
		ДоступноеПоле = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных(ТекущееВыражение));
		Если ДоступноеПоле <> Неопределено Тогда
			ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПоле;
		КонецЕсли; 
	КонецЕсли;
	Возврат Ложь;

КонецФункции

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстаВыражения = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
	    ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаВыражения.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Процедура ОбновитьДоступныеПоля()

	ВременнаяСхема = ирОбщий.КопияОбъектаЛкс(СхемаКомпоновки);
	Если ВременнаяСхема = Неопределено Тогда
		ВременнаяСхема = Новый СхемаКомпоновкиДанных;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ВременнаяСхема = Новый СхемаКомпоновкиДанных
	#КонецЕсли 
	Если ТипВыражения = "Параметр" Тогда
		ВременнаяСхема.НаборыДанных.Очистить();
		ВременнаяСхема.ВычисляемыеПоля.Очистить();
		ВременнаяСхема.ПоляИтога.Очистить();
	ИначеЕсли ТипВыражения = "ВычисляемоеПоле" Тогда
		ВременнаяСхема.ВычисляемыеПоля.Очистить();
	КонецЕсли; 
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ВременнаяСхема));
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаВыражения.ОбновитьКонтекстВыраженияЗапросаПоНастройкеКомпоновкиЛкс(КомпоновщикНастроек.Настройки);

КонецПроцедуры // ОбновитьДоступныеПоля()

Процедура ПриОткрытии()
	
	ирКэш.Получить().ИнициализацияОписанияМетодовИСвойств();
	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаВыражения = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстаПрограммы");
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаВыражения.Инициализировать(,
		ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ЭлементыФормы.КоманднаяПанельТекста,
		2, "ВычислитьВФорме", ЭтаФорма, "Выражение");
	ПолеТекстаВыражения.ЛиСерверныйКонтекст = НаСервере;
	// ---.КЛАСС.ПолеТекстаПрограммы
	
	Если НачальноеЗначениеВыбора <> Неопределено Тогда
		ЭтаФорма.ТипВыражения = НачальноеЗначениеВыбора.ТипВыражения;
		ЭлементыФормы.ТипВыражения.ТолькоПросмотр = Истина;
		ЭтаФорма.Выражение = НачальноеЗначениеВыбора.Выражение;
	КонецЕсли; 
	ирПлатформа = ирКэш.Получить();
	СтруктураТипаКонтекста = ирПлатформа.НоваяСтруктураТипа();
	СтруктураТипаКонтекста.ИмяОбщегоТипа = "Локальный";
	ТаблицаСлов = ирПлатформа.СвойстваТипаПредопределенные(СтруктураТипаКонтекста,,,,2);
	//ТаблицаСлов = ирПлатформа.СвойстваТипаПредопределенные(СтруктураТипа, 2);
	Для Каждого СтрокаСлова Из ТаблицаСлов Цикл
		Если Не ирОбщий.СтрокиРавныЛкс(СтрокаСлова.ТипСлова, "Метод") Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаФункции = ТаблицаФункций.Добавить();
		СтрокаФункции.Функция = СтрокаСлова.Слово;
		СтрокаФункции.СтруктураТипа = СтрокаСлова.ТаблицаСтруктурТипов[0];
	КонецЦикла;
	ОбновитьДоступныеПоля();
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
		ПроверятьДоступностьПолей = ВладелецФормы.ПроверятьДоступностьПолей;
	КонецЕсли;
	ПолеТекстаВыражения.ПолеТекста.УстановитьТекст(Выражение);
	ВыражениеИсходное = Выражение;
	ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML.Доступность = ирКэш.ЛиДоступенРедакторМонакоЛкс();
	Если ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML.Доступность Тогда
		ЭлементыФормы.РедакторHTML.Перейти(ирКэш.Получить().БазовыйФайлРедактораКода());
	КонецЕсли; 

КонецПроцедуры

Процедура ПриЗакрытии()
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаВыражения.Уничтожить();
	// ---.КЛАСС.ПолеТекстаПрограммы
	
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьИзменения()

	Если Не ПолеТекстаВыражения.ПроверитьПрограммныйКод() Тогда 
		Ответ = Вопрос("Выражение содержит ошибки. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли; 
	Текст = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	Если Не МодальныйРежим Тогда
		ирОбщий.ТекстВБуферОбменаОСЛкс(Текст, "ЯзыкЗапросов");
	КонецЕсли;
	Модифицированность = Ложь;
	//Закрыть(Текст);
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Текст);
	Возврат Истина;

КонецФункции // СохранитьИзменения()

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СохранитьИзменения();
	
КонецПроцедуры

// Выполняет программный код в контексте.
//
// Параметры:
//  ТекстДляВыполнения – Строка;
//  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
//
Функция ВычислитьВФорме(ТекстДляВыполнения, ЛиСинтаксическийКонтроль = Ложь) Экспорт
	
	ПроверочнаяСхема = ирОбщий.КопияОбъектаЛкс(СхемаКомпоновки);
	#Если Сервер И Не Сервер Тогда
		ПроверочнаяСхема = Новый СхемаКомпоновкиДанных
	#КонецЕсли
	//Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	НастройкаКомпоновки = Новый НастройкиКомпоновкиДанных;
	Группировка = НастройкаКомпоновки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ВыбранноеПоле = Группировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	лВыражение = ?(ТекстДляВыполнения = "", "0", ТекстДляВыполнения); // Пустую строку заменяем на 0, чтобы компоновщик не спотыкался;
	ИмяПоля = "_" + СтрЗаменить("" + Новый УникальныйИдентификатор, "-", "");
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Если Найти(ТипВыражения, "ВычисляемоеПоле") = 1 Тогда
		лПоле = ПроверочнаяСхема.ВычисляемыеПоля.Добавить();
		лПоле.Заголовок = ИмяПоля;
		лПоле.ПутьКДанным = ИмяПоля;
		лПоле.Выражение = "0";
		//Если ТипВыражения = "ВычисляемоеПоле.Выражение" Тогда 
			лПоле.Выражение = лВыражение;
		//ИначеЕсли ТипВыражения = "ВычисляемоеПоле.Представление" Тогда
		//	лПоле.ВыражениеПредставления = лВыражение;
		//ИначеЕсли ТипВыражения = "ВычисляемоеПоле.Упорядочивание" Тогда
		//	ПолеПорядка = Группировка.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		//	ПолеПорядка.Поле = Новый ПолеКомпоновкиДанных(лПоле.ПутьКДанным);
		//	ВыражениеУпорядочивания = лПоле.ВыраженияУпорядочивания.Добавить();
		//	ВыражениеУпорядочивания.Выражение = лВыражение;
		//КонецЕсли; 
	//ИначеЕсли Найти(ТипВыражения, "Поле") = 1 Тогда
	//	ИсточникДанных = ПроверочнаяСхема.ИсточникиДанных.Добавить();
	//	ИсточникДанных.Имя = "Local";
	//	ИсточникДанных.ТипИсточникаДанных =  "Local";
	//	НаборДанных = ПроверочнаяСхема.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	//	НаборДанных.ИсточникДанных = "Local";
	//	НаборДанных.Запрос = "Выбрать 1 КАК Поле1";
	//	лПоле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	//	лПоле.Поле = "Поле1";
	//	лПоле.ПутьКДанным = ИмяПоля;
	//	Если ТипВыражения = "Поле.Представление" Тогда
	//		лПоле.ВыражениеПредставления = лВыражение;
	//	ИначеЕсли ТипВыражения = "Поле.Упорядочивание" Тогда
	//		ВыражениеУпорядочивания = лПоле.ВыраженияУпорядочивания.Добавить();
	//		ВыражениеУпорядочивания.Выражение = лВыражение;
	//	КонецЕсли; 
ИначеЕсли ТипВыражения = "Параметр" Тогда
		лПоле = ПроверочнаяСхема.Параметры.Найти(ИмяПоля);
		Если лПоле = Неопределено Тогда
			лПоле = ПроверочнаяСхема.Параметры.Добавить();
			лПоле.Имя = ИмяПоля;
			лПоле.ОграничениеИспользования = Истина;
		КонецЕсли; 
		лПоле.Выражение = лВыражение;
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ПараметрыДанных." + ИмяПоля);
	ИначеЕсли ТипВыражения = "ПолеИтога" Тогда
		лПоле = ПроверочнаяСхема.ПоляИтога.Добавить();
		лПоле.ПутьКДанным = ИмяПоля;
		лПоле.Выражение = лВыражение;
	//ИначеЕсли Найти(ТипВыражения, "ПользовательскоеПоле") = 1 Тогда
	//	лПоле = Компоновщик.Настройки.ПользовательскиеПоля.Элементы.Добавить(Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных"));
	//	ИмяПоля = лПоле.ПутьКДанным;
	//	//Если ТипВыражения = "ПользовательскоеПоле.Детали" Тогда
	//		лПоле.УстановитьВыражениеДетальныхЗаписей(лВыражение);
	//	//ИначеЕсли ТипВыражения = "ПользовательскоеПоле.Итоги" Тогда
	//	//	лПоле.УстановитьВыражениеИтоговыхЗаписей(лВыражение);
	//	//КонецЕсли; 
	//	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
	КонецЕсли; 
	ирОбщий.ПроверитьСхемуКомпоновкиЛкс(ПроверочнаяСхема, НастройкаКомпоновки, ПроверятьДоступностьПолей, ВнешниеФункцииРазрешены, НаСервере);

КонецФункции

Процедура ДоступныеПоляНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	НрегПервыйФрагмент = ирОбщий.ПервыйФрагментЛкс(НРег(Элемент.ТекущаяСтрока.Поле));
	Если НрегПервыйФрагмент = НРег("ПараметрыДанных") Тогда
		ПараметрыПеретаскивания.Значение = "&" + ирОбщий.ПоследнийФрагментЛкс(Элемент.ТекущаяСтрока.Поле);
	ИначеЕсли Истина
		И ТипВыражения <> "ПолеИтога"
		И НрегПервыйФрагмент = НРег("СистемныеПоля") 
	Тогда
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
	Иначе
		ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Поле;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТекстаСсылкаНаОбъектБД(Кнопка)
	
	//ПолеВстроенногоЯзыка.ВставитьСсылкуНаОбъектБД(СхемаКомпоновки, "");
	
КонецПроцедуры

Процедура ДоступныеПоляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	Если Не ПредставленияИмена Тогда
		ОформлениеСтроки.Ячейки.Заголовок.УстановитьТекст(ирОбщий.ПоследнийФрагментЛкс("" + ДанныеСтроки.Поле));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТекстаПредставленияИмена(Кнопка)
	
	ПредставленияИмена = Не Кнопка.Пометка;
	Кнопка.Пометка = ПредставленияИмена;
	ЭлементыФормы.ДоступныеПоля.ОбновитьСтроки();
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Ответ = Вопрос("Выражение было изменено. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Отказ = Не СохранитьИзменения();
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельТекстаВнешниеФункции(Кнопка)
	
	ЭтаФорма.ВнешниеФункцииРазрешены = Не Кнопка.Пометка;
	Кнопка.Пометка = ВнешниеФункцииРазрешены;

КонецПроцедуры

Процедура ТипВыраженияПриИзменении(Элемент)
	
	ОбновитьДоступныеПоля();

КонецПроцедуры

Процедура КонтекстноеМенюФункцийСинтаксПомощник(Кнопка)
	
	ТекущаяСтрокаФункций = ЭлементыФормы.ТаблицаФункций.ТекущаяСтрока;
	Если ТекущаяСтрокаФункций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтруктураТипа = ТекущаяСтрокаФункций.СтруктураТипа;
	Если СтруктураТипа <> Неопределено Тогда
		СтрокаОписания = СтруктураТипа.СтрокаОписания;
		Если СтрокаОписания <> Неопределено Тогда
			ирОбщий.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаФункцийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Функция + "()";
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирОбщий.ПриПолученииДанныхДоступныхПолейКомпоновкиЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры // ПриПолученииДанныхДоступныхПолей()

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицаФункцийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ВыбраннаяСтрока.Функция + "(" + ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст + ")");
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

///////////////////////////
//  HTML редактор кода 

Функция РедакторВстроенный()
	
	Возврат ЭлементыФормы.ПолеТекстаВыражения;

КонецФункции

Функция АктивноеПолеТекста(ЭлементФормы = Неопределено)
	Если ЭлементФормы = Неопределено Тогда
		Если ЭлементыФормы.ПанельРедактора.ТекущаяСтраница = ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML Тогда
			Результат = ЭлементыФормы.РедакторHTML;
		Иначе
			Результат = РедакторВстроенный();
		КонецЕсли;
	Иначе
		Результат = ЭлементФормы;
	КонецЕсли;
	Возврат ирОбщий.ОболочкаПоляТекстаЛкс(Результат);
КонецФункции

Функция РедакторHTML()
	Если РедакторHTML = Неопределено Тогда
		РедакторHTML = ЭлементыФормы.РедакторHTML.Документ.defaultView;
		Если РедакторHTML <> Неопределено И Не ЗначениеЗаполнено(РедакторHTML.version1C) Тогда 
			РедакторHTML = Неопределено;
		КонецЕсли; 
	КонецЕсли;
	Возврат РедакторHTML;
КонецФункции

Процедура РедакторHTMLДокументСформирован(Элемент)
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ПолеТекстаВыражения.РедакторHTML_Инициировать(Элемент);
	ПанельРедактораПриСменеСтраницы(ЭлементыФормы.ПанельРедактора, ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML);
	
КонецПроцедуры

Функция ВводДоступенЛкс() Экспорт 
	Если ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.РедакторHTML Тогда
		Результат = РедакторHTML().hasTextFocus();
	Иначе
		Результат = ВводДоступен();
	КонецЕсли; 
	Возврат Результат;
КонецФункции

Процедура ПанельРедактораПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Перем КонечнаяКолонка, КонечнаяСтрока, НачальнаяКолонка, НачальнаяСтрока, НачальнаяПозиция, КонечнаяПозиция;
	
	Если РедакторHTML() = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Поле1 = АктивноеПолеТекста(РедакторВстроенный());
	Поле2 = АктивноеПолеТекста(ЭлементыФормы.РедакторHTML);
	#Если Сервер И Не Сервер Тогда
		Поле1 = Обработки.ирОболочкаПолеТекста.Создать();
		Поле2 = Обработки.ирОболочкаПолеТекста.Создать();
	#КонецЕсли
	Если ТипЗнч(ТекущаяСтраница) = Тип("Число") Тогда
		ТекущаяСтраница = ЭлементыФормы.ПанельРедактора.Страницы[ТекущаяСтраница];
	КонецЕсли; 
	Если ТекущаяСтраница = ЭлементыФормы.ПанельРедактора.Страницы.РедакторHTML Тогда
		ПолеТекстаВыражения.ПолеТекста = АктивноеПолеТекста(Поле2);
		Поле1.ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
		Поле2.УстановитьТекст(Поле1.ПолучитьТекст(), Истина, ВыражениеИсходное);
		Поле2.УстановитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	Иначе
		ПолеТекстаВыражения.ПолеТекста = АктивноеПолеТекста(Поле1);
		Поле2.ПолучитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
		Поле1.УстановитьТекст(Поле2.ПолучитьТекст());
		Поле1.УстановитьГраницыВыделения(НачальнаяСтрока, НачальнаяКолонка, КонечнаяСтрока, КонечнаяКолонка);
	КонецЕсли; 

КонецПроцедуры

Процедура РедакторHTMLonclick(Элемент, ДанныеСобытия)
	
	#Если Сервер И Не Сервер Тогда
		ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	РедакторHTML = РедакторHTML();
	Событие = ДанныеСобытия.eventData1C;
	Если Событие <> Неопределено Тогда
		Если Событие.event = "EVENT_CONTENT_CHANGED" Тогда
			ЭтаФорма.Модифицированность = Истина;
		ИначеЕсли Событие.event = "EVENT_ON_LINK_CLICK" Тогда
			ЗаголовокСсылки = Событие.params.label;
			Гиперссылка = Событие.params.href;
			РедакторHTML.hideHoverList();
			Если ЗаголовокСсылки = "Определение" Тогда
				Координаты = ирОбщий.СтрРазделитьЛкс(Гиперссылка, ",");
				НомерСтроки = Число(Координаты[0]);
				НомерКолонки = Число(Координаты[1]);
				Если Не ПерейтиКОпределениюВФорме(НомерСтроки, НомерКолонки) Тогда
					ПолеТекстаВыражения.ПерейтиКОпределению(НомерСтроки, НомерКолонки);
				КонецЕсли; 
			ИначеЕсли ЗаголовокСсылки = "Знач" Тогда
				ирОбщий.ОткрытьЗначениеЛкс(ВычислитьВыражение(Гиперссылка));
			ИначеЕсли Ложь
				Или Лев(ЗаголовокСсылки, 1) = "["
				Или ЗаголовокСсылки = "Допустимые типы" 
			Тогда 
				ПолеТекстаВыражения.ОткрытьОписаниеТипаПоГиперссылке(Гиперссылка);
			Иначе
				ПолеТекстаВыражения.ОткрытьКонтекстнуюСправку(Гиперссылка);
			КонецЕсли;
		ИначеЕсли Событие.event = "EVENT_BEFORE_HOVER" Тогда
			#Если Сервер И Не Сервер Тогда
				ВычислитьВыражение();
			#КонецЕсли
			ПолеТекстаВыражения.РедакторHTML_ПередПоказомПодсказкиУдержания("ВычислитьВыражение", Событие.params.column, Событие.params.line, Событие.params.word);
		ИначеЕсли Событие.event = "EVENT_BEFORE_SIGNATURE" Тогда
			ПолеТекстаВыражения.РедакторHTML_ПередПоказомСигнатуры(Событие.params.activeParameter, Событие.params.word, Событие.params.activeSignature, Событие.params.triggerCharacter);
		ИначеЕсли Событие.event = "EVENT_BEFORE_SHOW_SUGGEST" Тогда
			#Если Сервер И Не Сервер Тогда
				ПолеТекстаВыражения = Обработки.ирКлсПолеТекстаПрограммы.Создать();
			#КонецЕсли
			//ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров(ПолеТекстаВыражения);
			ПолеТекстаВыражения.РедакторHTML_ПередПоказомАвтодополнения(Событие.params.trigger, Событие.params.last_expression, Событие.params.last_word);
		ИначеЕсли Событие.event = "EVENT_ON_SELECT_SUGGEST_ROW" Тогда
			ПолеТекстаВыражения.РедакторHTML_ПриВыбореСтрокиАвтодополнения(Событие.params.trigger, Событие.params.last_expression, Событие.params.selected);
		ИначеЕсли Событие.event = "EVENT_ON_ACTIVATE_SUGGEST_ROW" Тогда
			ПолеТекстаВыражения.РедакторHTML_ПриАктивацииСтрокиАвтодополнения(Событие.params.trigger, Событие.params.focused, Событие.params.row_id);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ВычислитьВыражение(Знач ТекущееВыражение, выхУспехВычисления = Истина) Экспорт 
	
	выхУспехВычисления = Ложь;
	ИмяПараметра = Сред(ТекущееВыражение, 2);
	СтрокаПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Если СтрокаПараметра <> Неопределено Тогда
		ЗначениеПараметра = СтрокаПараметра.Значение;
		ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(СтрокаПараметра.Параметр);
		выхУспехВычисления = Истина;
	КонецЕсли;
	Возврат ЗначениеПараметра;

КонецФункции

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольКомпоновокДанных.Форма.РедакторВыраженияКомпоновки");

#Если Сервер И Не Сервер Тогда
	ПриПолученииДанныхДоступныхПолей();
#КонецЕсли
ирОбщий.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоля);

ПредставленияИмена = Ложь;
ПроверятьДоступностьПолей = Истина;
ВнешниеФункцииРазрешены = Истина;
ТипВыражения = "ПолеИтога";
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("Поле.Представление", "Поле.Представление");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("Поле.Упорядочивание", "Поле.Упорядочивание");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ВычисляемоеПоле.Выражение", "Вычисляемое поле.Выражение");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ВычисляемоеПоле.Представление", "Вычисляемое поле.Представление");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ВычисляемоеПоле.Упорядочивание", "Вычисляемое поле.Упорядочивание");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("Параметр.Выражение", "Параметр.Выражение");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ПолеИтога.Выражение", "Поле итога.Выражение");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ПользовательскоеПоле.Детали", "Пользовательское поле.Детали");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ПользовательскоеПоле.Итоги", "Пользовательское поле.Итоги");
ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ВычисляемоеПоле", "Вычисляемое поле");
ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("Параметр", "Параметр");
ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ПолеИтога", "Поле итога");
//ЭлементыФормы.ТипВыражения.СписокВыбора.Добавить("ПользовательскоеПоле", "Пользовательское поле");

ТаблицаФункций.Колонки.Добавить("СтруктураТипа");
