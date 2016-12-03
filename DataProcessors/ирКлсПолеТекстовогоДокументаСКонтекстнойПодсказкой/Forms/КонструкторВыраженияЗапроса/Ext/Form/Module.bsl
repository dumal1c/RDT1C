﻿Перем мИмяСлужебногоПоля;
Перем мПредставленияТиповВыражений;
Перем ДиалектSQL Экспорт;
Перем ПараметрыДиалектаSQL;

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	Если Кнопка = ЛксПолучитьКнопкуКоманднойПанелиЭкземпляраКомпоненты(ПодсказкаПоляТекстаВыражения, "ПерейтиКОпределению") Тогда
		ТекущееВыражение = ПодсказкаПоляТекстаВыражения.ПолучитьТекущееОбъектноеВыражение();
		Если Лев(ТекущееВыражение, 1) = "&" Тогда
			ИмяПараметра = Сред(ТекущееВыражение, 2);
			ДоступныйПараметр = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных("ПараметрыДанных.ИмяПараметра"));
			Если ДоступныйПараметр <> Неопределено Тогда
				ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступныйПараметр;
				ПараметрСхемы = СхемаКомпоновки.Параметры.Найти(ЛксПолучитьПоследнийФрагмент(ДоступныйПараметр.Поле));
				Если ПараметрСхемы <> Неопределено Тогда
					Если ПараметрСхемы.Выражение <> "" Тогда
						Попытка 
							ЗначениеПараметра = Вычислить(ПараметрСхемы.Выражение);
							ОткрытьЗначение(ЗначениеПараметра);
						Исключение
							ЛксСообщитьСУчетомМодальности("Ошибка при вычислении параметра """ + ПараметрСхемы.ИмяПараметра + """"
								+ Символы.ПС + ОписаниеОшибки(), МодальныйРежим, СтатусСообщения.Важное);
						КонецПопытки;
					Иначе
						ЗначениеПараметра = ПараметрСхемы.Значение;
						ОткрытьЗначение(ЗначениеПараметра);
					КонецЕсли;
				КонецЕсли; 
			КонецЕсли;
			Возврат;
		Иначе
			ДоступноеПоле = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных(ТекущееВыражение));
			Если ДоступноеПоле <> Неопределено Тогда
				ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПоле;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	ПодсказкаПоляТекстаВыражения.Нажатие(Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКэш.Получить().ИнициализацияОписанияМетодовИСвойств();
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПодсказкаПоляТекстаВыражения.Инициализировать(,
		ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ЭлементыФормы.КоманднаяПанельТекста,
		1, "ПроверитьВыражение", ЭтаФорма, "Выражение");
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
	ЛксОбновитьТекстПослеМаркераВСтроке(ЭтаФорма.Заголовок,, мПредставленияТиповВыражений.НайтиПоЗначению(ТипВыражения).Представление);
	ПараметрыДиалектаSQL = мДиалектыSQL.Найти(ДиалектSQL, "Диалект");
	ЭлементыФормы.КПЗапросы.Кнопки.ПеренестиВоВременнуюТаблицу.Доступность = Истина
		И ПараметрыДиалектаSQL.ВременныеТаблицы 
		И ПараметрыДиалектаSQL.Пакет;
	УстановитьСхемуКомпоновки();
	//мПлатформа = ирКэш.Получить();
	Если ирНеглобальный.СтрокиРавныЛкс(мДиалектSQL, "1С") Тогда
		СтруктураТипаКонтекста = мПлатформа.ПолучитьНовуюСтруктуруТипа();
		СтруктураТипаКонтекста.ИмяОбщегоТипа = "Локальный контекст";
		СписокСлов = мПлатформа.ПолучитьВнутреннююТаблицуПредопределенныхСлов(СтруктураТипаКонтекста,,,,1);
		//ТаблицаСлов = мПлатформа.ПолучитьВнутреннююТаблицуПредопределенныхСлов(СтруктураТипа, 1);
		Для Каждого СтрокаСлова Из СписокСлов Цикл
			Если Не ирНеглобальный.СтрокиРавныЛкс(СтрокаСлова.ТипСлова, "Метод") Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаФункции = ТаблицаФункций.Добавить();
			СтрокаФункции.Функция = СтрокаСлова.Слово;
			СтрокаФункции.СтруктураТипа = СтрокаСлова.ТаблицаСтруктурТипов[0];
		КонецЦикла;
	КонецЕсли; 
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	ЭлементыФормы.ПолеТекстаВыражения.УстановитьТекст(Выражение);
	КоманднаяПанельТекстаОбновитьЗапросы();

КонецПроцедуры

Функция УстановитьСхемуКомпоновки()
	
	ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса(, Истина);
	Если ТекстПроверочногоЗапроса = Неопределено Тогда
		ОбновитьКонтекстнуюПодсказку();
		Возврат Неопределено;
	КонецЕсли; 
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = ЛксДобавитьЛокальныйИсточникДанных(СхемаКомпоновки);
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	НаборДанных.Запрос = ТекстПроверочногоЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	ПолеНабора = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	ПолеНабора.Поле = мИмяСлужебногоПоля;
	ПолеНабора.ПутьКДанным = мИмяСлужебногоПоля;
	ПолеНабора.ОграничениеИспользования.Условие = Истина;
	Если Параметры = Неопределено Тогда
		ВызватьИсключение "Не передана таблица параметров";
	КонецЕсли; 
	Для Каждого CтрокаПараметра Из Параметры Цикл
		ПараметрСхемы = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСхемы.Имя = CтрокаПараметра.Имя;
		ПараметрСхемы.ТипЗначения = CтрокаПараметра.ТипЗначения;
	КонецЦикла;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	Исключение
		ОписаниеОшибки = ОписаниеОшибки(); // Чтобы в отладчике сразу была понятна причина ошибки
	КонецПопытки; 
	ОбновитьКонтекстнуюПодсказку();
	
КонецФункции

Процедура ОбновитьКонтекстнуюПодсказку()
	
	ПодсказкаПоляТекстаВыражения.ОчиститьТаблицуСловЛокальногоКонтекста();
	Для Каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы Цикл
		НрегПервыйФрагмент = ЛксПолучитьПервыйФрагмент(НРег(ДоступноеПоле.Поле));
		Если НрегПервыйФрагмент = НРег("ПараметрыДанных") Тогда
			Для Каждого ДоступныйПараметр Из ДоступноеПоле.Элементы Цикл
				ИмяСвойства = ПараметрыДиалектаSQL.ПрефиксПараметра + ЛксПолучитьПоследнийФрагмент(ДоступныйПараметр.Поле);
				ПодсказкаПоляТекстаВыражения.ДобавитьСловоЛокальногоКонтекста(ИмяСвойства, "Свойство", , ДоступныйПараметр,,,, "СтрокаТаблицы");
			КонецЦикла; 
		Иначе
			ПодсказкаПоляТекстаВыражения.ДобавитьСловоЛокальногоКонтекста("" + ДоступноеПоле.Поле, "Свойство",, ДоступноеПоле,,,, "СтрокаТаблицы");
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПодсказкаПоляТекстаВыражения.Уничтожить();
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьИзменения()

	Если Не ПодсказкаПоляТекстаВыражения.ПроверитьПрограммныйКод() Тогда 
		Ответ = Вопрос("Выражение содержит ошибки. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли; 
	Текст = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	Если Не МодальныйРежим Тогда
		ирНеглобальный.ПоместитьТекстВБуферОбменаОСЛкс(Текст);
	КонецЕсли;
	Модифицированность = Ложь;
	Закрыть(Текст);
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
Функция ПроверитьВыражение(ТекстДляПроверки, ЛиСинтаксическийКонтроль = Ложь) Экспорт
	
	Если мДиалектSQL = "1С" Тогда
		ПроверочныйЗапрос = Новый Запрос;
		ПроверочныйЗапрос.Текст = ПолучитьТекстПроверочногоЗапроса(ТекстДляПроверки);
		ПроверочныйЗапрос.НайтиПараметры(); // Здесь будет возникать ошибка
	КонецЕсли; 
	КоманднаяПанельТекстаОбновитьЗапросы();

КонецФункции // ВычислитьВФорме()

Функция ПолучитьТекстПроверочногоЗапроса(Знач ТекстДляПроверки = "", ДляСхемы = Ложь)
	
	Если Истина
		И ДляСхемы
		И КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы.Количество() > 0
	Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ТекстДляПроверки) Тогда
		ТекстДляПроверки = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	КонецЕсли; 

	Если ТипВыражения = "ПараметрВиртуальнойТаблицы" Тогда
		Если Не ЗначениеЗаполнено(ШаблонПолноеИмяТаблицы) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонПолноеИмяТаблицы""";
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(ШаблонНомерПараметра) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонНомерПараметра""";
		КонецЕсли; 
		Запятые = ЛксПолучитьСтрокуПовтором(",", ШаблонНомерПараметра - 1);
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИЗ " + ШаблонПолноеИмяТаблицы + "(" + Запятые + "
		|" + ТекстДляПроверки + "
		|) КАК Т";
	ИначеЕсли ТипВыражения = "УсловиеОтбора" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1=1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ * " + ШаблонТекстИЗ + " ГДЕ 
		|" + ТекстДляПроверки;
	ИначеЕсли ТипВыражения = "ВыбранноеПоле" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ " + ТекстДляПроверки + " " + ШаблонТекстИЗ;
	ИначеЕсли ТипВыражения = "ПолеИтога" Тогда
		//Если Не ЗначениеЗаполнено(ШаблонТекстЗапроса) Тогда
		//	ВызватьИсключение "Не задан параметр ""ШаблонТекстЗапроса""";
		//КонецЕсли; 
		//ТекстЗапроса = ШаблонТекстЗапроса + " ИТОГИ
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИТОГИ
		|" + ТекстДляПроверки + "
		| КАК " + мИмяСлужебногоПоля + " ПО ОБЩИЕ";
	Иначе
		ТекстЗапроса = "";
	КонецЕсли; 
	Возврат ТекстЗапроса;

КонецФункции

Процедура ДоступныеПоляНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	НрегПервыйФрагмент = ЛксПолучитьПервыйФрагмент(НРег(Элемент.ТекущаяСтрока.Поле));
	Если НрегПервыйФрагмент = НРег("ПараметрыДанных") Тогда
		ПараметрыПеретаскивания.Значение = "&" + ЛксПолучитьПоследнийФрагмент(Элемент.ТекущаяСтрока.Поле);
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

Процедура КонтекстноеМенюФункцийСинтаксПомощник(Кнопка)
	
	ТекущаяСтрокаФункций = ЭлементыФормы.ТаблицаФункций.ТекущаяСтрока;
	Если ТекущаяСтрокаФункций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтруктураТипа = ТекущаяСтрокаФункций.СтруктураТипа;
	Если СтруктураТипа <> Неопределено Тогда
		СтрокаОписания = СтруктураТипа.СтрокаОписания;
		Если СтрокаОписания <> Неопределено Тогда
			ирНеглобальный.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаФункцийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Функция + "()";
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ЛксПриПолученииДанныхДоступныхПолейКомпоновки(ОформленияСтрок);

КонецПроцедуры // ПриПолученииДанныхДоступныхПолей()

Процедура КоманднаяПанельТекстаОбновитьЗапросы(Кнопка = Неопределено)
	
	//ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса();
	ТекстВыражения = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	Если ПустаяСтрока(ТекстВыражения) Тогда
		ТекстВыражения = "1";
	КонецЕсли; 
	ТекстПроверочногоЗапроса = "ВЫБРАТЬ 
	|" + ТекстВыражения;
	СлужебноеПолеТекстовогоДокумента.УстановитьТекст(ТекстПроверочногоЗапроса);
	НачальныйТокен = РазобратьТекстЗапроса(ТекстПроверочногоЗапроса, Истина); // Возможно здесь тоже придется включить полное, а не сокращенное дерево
	Запросы.Очистить();
	Если НачальныйТокен <> Неопределено Тогда
		ЗаполнитьСписокЗапросовПоТокену(НачальныйТокен);
	КонецЕсли; 
	
КонецПроцедуры

Функция ЗаполнитьСписокЗапросовПоТокену(Знач Токен) Экспорт
	
	Данные = Токен.Data;
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ИмяПравила = Данные.ParentRule.RuleNonterminal.Text;
	Если ИмяПравила = "<EmbededRoot>" Тогда
		CтрокаЗапроса = Запросы.Добавить();
		CтрокаЗапроса.Номер = Запросы.Количество();
		CтрокаЗапроса.Текст = ПолучитьТекстИзТокена(Токен, CтрокаЗапроса.НачальнаяСтрока, CтрокаЗапроса.НачальнаяКолонка,
			CтрокаЗапроса.КонечнаяСтрока, CтрокаЗапроса.КонечнаяКолонка);
	Иначе
		Для ИндексТокена = 0 По Данные.TokenCount - 1 Цикл
			ТокенВниз = Данные.Tokens(Данные.TokenCount - 1 - ИндексТокена);
			Если ТокенВниз.Kind = 0 Тогда
				ПсевдонимСнизу = ЗаполнитьСписокЗапросовПоТокену(ТокенВниз);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	
КонецФункции

Процедура ЗапросыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ФормаКонструктораЗапроса = ПолучитьФорму("КонструкторЗапроса");
	ФормаКонструктораЗапроса.ЭтоВложенныйЗапрос = Истина;
	ЗагрузитьТекстВКонструктор(ВыбраннаяСтрока.Текст, ФормаКонструктораЗапроса);
	РезультатФормы = ФормаКонструктораЗапроса.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
			ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
		ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст = ФормаКонструктораЗапроса.Текст;
		КоманднаяПанельТекстаОбновитьЗапросы();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПЗапросыПеренестиВоВременнуюТаблицу(Кнопка)

	ВыбраннаяСтрока = ЭлементыФормы.Запросы.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КонструкторВложенногоЗапроса = ПолучитьФорму("КонструкторЗапроса");
	ЗагрузитьТекстВКонструктор(ВыбраннаяСтрока.Текст, КонструкторВложенногоЗапроса);
	Если Не КонструкторЗапроса.ЛиПакетныйЗапрос Тогда
		КонструкторЗапроса.ЛиПакетныйЗапрос = Истина;
		КонструкторЗапроса.ЛиПакетныйЗапросПриИзменении();
	КонецЕсли; 
	ЗапросПакета = КонструкторЗапроса.ЗапросыПакета.Вставить(КонструкторЗапроса.ЗапросыПакета.Индекс(КонструкторЗапроса.ЭлементыФормы.ЗапросыПакета.ТекущаяСтрока));
	ЗаполнитьЗначенияСвойств(ЗапросПакета, КонструкторВложенногоЗапроса.ЗапросыПакета[0]);
	КонструкторЗапроса.ОбновитьНаименованиеЗапроса(ЗапросПакета);
	ЗапросПакета.ТипЗапроса = 1;
	ЗапросПакета.ИмяВременнойТаблицы = мПлатформа.ПолучитьИдентификаторИзПредставления(ЗапросПакета.Имя);
	КонструкторЗапроса.ОбновитьДоступныеВременныеТаблицы();
	ТекстВыбор = "";
	Для Каждого ВыбранноеПоле Из ЗапросПакета.ЧастиОбъединения[0].ВыбранныеПоля Цикл
		Если ТекстВыбор <> "" Тогда
			ТекстВыбор = ТекстВыбор + ", ";
		КонецЕсли; 
		ТекстВыбор = ТекстВыбор + ВыбранноеПоле.Имя;
	КонецЦикла; 
	ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
		ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
	ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст = 
		КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("SELECT") + " " + ТекстВыбор + " " + КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("FROM") + " " 
		+ ЗапросПакета.ИмяВременнойТаблицы + " " + КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("AS") + " " + ЗапросПакета.ИмяВременнойТаблицы;
	КоманднаяПанельТекстаОбновитьЗапросы();
	
КонецПроцедуры


ЛксПодключитьОбработчикиСобытийДоступныхПолейКомпоновки(ЭлементыФормы.ДоступныеПоля);

Запросы.Колонки.Добавить("НачальнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("НачальнаяСтрока", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяСтрока", Новый ОписаниеТипов("Число"));
ЭтаФорма.ТипВыражения = "Параметр";
мПредставленияТиповВыражений = Новый СписокЗначений;
мПредставленияТиповВыражений.Добавить("УсловиеОтбора", "Отбор");
мПредставленияТиповВыражений.Добавить("ПараметрВиртуальнойТаблицы", "Параметр таблицы");
мПредставленияТиповВыражений.Добавить("УсловиеСвязи", "Связь таблиц");
мПредставленияТиповВыражений.Добавить("ВыбранноеПоле", "Выбранное поле");
мПредставленияТиповВыражений.Добавить("Группировка", "Группировка");
мПредставленияТиповВыражений.Добавить("ПолеИтога", "Итоги");

ТаблицаФункций.Колонки.Добавить("СтруктураТипа");
мИмяСлужебногоПоля = "_СлужебноеПоле48198";
