﻿Перем _Значение_ Экспорт;
Перем БазовоеВыражение Экспорт;
Перем СтруктураТипаКоллекции;
Перем СтруктураТипаЭлементаКоллекции;
Перем МаркерСловаЗначения;
Перем Коллекция;
Перем ПутьКДаннымКоллекции;
Перем ОписанияКолонок;
Перем СвойстваЭлементовКоллекции;

Процедура УстановитьИсследуемоеЗначение(пЗначение, пПутьКДанным = Неопределено, пСтруктураТипаКоллекции = Неопределено,
	БезСлужебныхКолонок = Истина) Экспорт 

	БазовоеВыражение = пПутьКДанным;
	ЭтаФорма[МаркерСловаЗначения] = пЗначение;
	Если БазовоеВыражение = Неопределено Тогда
		Выражение = МаркерСловаЗначения;
	Иначе
		Выражение = БазовоеВыражение;
	КонецЕсли;
	ПутьКДаннымКоллекции = Выражение;
	Если Истина
		И БазовоеВыражение <> Неопределено
		И Найти(Выражение, БазовоеВыражение) = 1
	Тогда
		ВыражениеДляВычисления = "_Значение_" + Сред(Выражение, СтрДлина(БазовоеВыражение) + 1);
	Иначе
		ВыражениеДляВычисления = Выражение;
	КонецЕсли; 
	//Попытка
		Коллекция = Вычислить(ВыражениеДляВычисления);
	//Исключение

	Если пСтруктураТипаКоллекции = Неопределено Тогда
		ШаблонСтруктуры = Новый Структура;
		Если ирКэш.Получить().мМассивТиповВключающихМетаданные.Найти(ТипЗнч(пЗначение)) <> Неопределено Тогда 
			ШаблонСтруктуры.Вставить("Метаданные", пЗначение);
		КонецЕсли;
		СтруктураТипаКоллекции = ирКэш.Получить().ПолучитьСтруктуруТипаИзЗначения(пЗначение, , ШаблонСтруктуры);
	Иначе
		СтруктураТипаКоллекции = пСтруктураТипаКоллекции;
	КонецЕсли;
	ЭтаФорма.ЭлементыФормы.Выражение.ТолькоПросмотр = БазовоеВыражение <> Неопределено;
	ЭтаФорма.БезСлужебныхКолонок = БезСлужебныхКолонок;

КонецПроцедуры // УстановитьИсследуемоеЗначение()

Процедура ОбновитьДанные()

	СтарыйИндекс = Неопределено;
	Если ЭлементыФормы.ТаблицаКоллекции.ТекущаяСтрока <> Неопределено Тогда
		СтарыйИндекс = ТаблицаКоллекции.Индекс(ЭлементыФормы.ТаблицаКоллекции.ТекущаяСтрока);
	КонецЕсли; 
	СтараяКолонка = Неопределено;
	Если ЭлементыФормы.ТаблицаКоллекции.ТекущаяКолонка <> Неопределено Тогда
		СтараяКолонка = ЭлементыФормы.ТаблицаКоллекции.ТекущаяКолонка.Имя;
	КонецЕсли; 
	ТаблицаКоллекции.Очистить();
	СвойстваЭлементовКоллекции = Новый Массив;
	МассивТиповЭлементовКоллекции = ирКэш.Получить().ПолучитьТипыЭлементовКоллекции(СтруктураТипаКоллекции);
	ЕстьИндекс = Ложь;
	СтруктураТипаЭлементаКоллекции = ирКэш.Получить().ПолучитьНовуюСтруктуруТипа(); // т.к. цикл может и не выполниться ни разу
	Для Каждого ТипЭлементаКоллекции Из МассивТиповЭлементовКоллекции Цикл
		СтруктураТипаЭлементаКоллекции = ирКэш.Получить().ПолучитьНовуюСтруктуруТипа();
		Если ТипЗнч(СтруктураТипаКоллекции.Метаданные) <> Тип("COMОбъект") Тогда // Сделано для COMОбъект.{WbemScripting.SwbemLocator}.ISWbemObject
			СтруктураТипаЭлементаКоллекции.Метаданные = СтруктураТипаКоллекции.Метаданные; // Было закомментировано
		КонецЕсли; 
		СтруктураТипаЭлементаКоллекции.ИмяОбщегоТипа = ТипЭлементаКоллекции;
		// Создадим колонки таблицы
		СтруктураКлюча = Новый Структура("БазовыйТип, ЯзыкПрограммы", ТипЭлементаКоллекции, 0);
		НайденныеСтроки = ирКэш.Получить().ТаблицаОбщихТипов.НайтиСтроки(СтруктураКлюча);
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтруктураТипаЭлементаКоллекции.СтрокаОписания = НайденныеСтроки[0];
			СтруктураТипаЭлементаКоллекции.ИмяОбщегоТипа = НайденныеСтроки[0].Слово;
		КонецЕсли; 
		ВнутренняяТаблицаСлов = ирКэш.Получить().ПолучитьТаблицуСловСтруктурыТипа(СтруктураТипаЭлементаКоллекции);
		Для Каждого ВнутренняяСтрокаСлова Из ВнутренняяТаблицаСлов Цикл
			Если ВнутренняяСтрокаСлова.ТипСлова = "Метод" Тогда
				// Методы здесь игнорируем
				Если ВнутренняяСтрокаСлова.Слово = "Индекс" Тогда
					ТаблицаКоллекции.Колонки.Добавить("Индекс", Новый ОписаниеТипов("Число"));
					ЕстьИндекс = Истина;
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			СтруктураСтрокОписаний = ОписанияКолонок[ВнутренняяСтрокаСлова.Слово];
			Если СтруктураСтрокОписаний = Неопределено Тогда
				СтруктураСтрокОписаний = Новый Соответствие;
				ОписанияКолонок[ВнутренняяСтрокаСлова.Слово] = СтруктураСтрокОписаний;
			КонецЕсли; 
			//КонкретныйТип = ирКэш.Получить().ПолучитьКонкретныйТипИзСтруктурыТипа(СтруктураТипаЭлементаКоллекции);
			//Если КонкретныйТип <> Неопределено Тогда
			//КонецЕсли; 
			СтруктураСтрокОписаний.Вставить(СтруктураТипаЭлементаКоллекции.ИмяОбщегоТипа, ВнутренняяСтрокаСлова.ТаблицаСтруктурТипов);
			Если ТаблицаКоллекции.Колонки.Найти(ВнутренняяСтрокаСлова.Слово) = Неопределено Тогда
				ОписаниеТипов = ирКэш.Получить().ПолучитьОписаниеТиповИзТаблицыСтруктурТипов(ВнутренняяСтрокаСлова.ТаблицаСтруктурТипов);
				
				// Антибаг платформы 8.2.15 http://partners.v8.1c.ru/forum/thread.jsp?id=1015693#1015693
				Типы = ОписаниеТипов.Типы();
				Если Типы.Количество() > 0 Тогда
					ПростойТип = Типы[0];
					Если Истина
						И Типы.Количество() = 1
						И (Ложь
							Или ПростойТип = Тип("КоллекцияАтрибутовDOM")
							Или ПростойТип = Тип("ДокументDOM")
							Или ПростойТип = Тип("СписокУзловDOM")
							Или ПростойТип = Тип("АтрибутDOM")
							Или ПростойТип = Тип("ТипУзлаDOM")
							Или ПростойТип = Тип("ЭлементDOM")
							Или ПростойТип = Тип("КонфигурацияДокументаDOM")
							Или ПростойТип = Тип("ОпределениеТипаДокументаDOM")
							Или ПростойТип = Тип("КоллекцияНотацийDOM")
							Или ПростойТип = Тип("КоллекцияСущностейDOM")
							
							Или ПростойТип = Тип("ЗначениеXDTO")
							Или ПростойТип = Тип("ТипЗначенияXDTO")
							Или ПростойТип = Тип("ТипОбъектаXDTO"))
					Тогда
						ОписаниеТипов = Новый ОписаниеТипов("Строка");
					КонецЕсли; 
				КонецЕсли; 
			
				ТаблицаКоллекции.Колонки.Добавить(ВнутренняяСтрокаСлова.Слово, ОписаниеТипов);
				СвойстваЭлементовКоллекции.Добавить(ВнутренняяСтрокаСлова.Слово);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Размер = 0;
	// Заполним таблицу
	Попытка
		КоличествоЭлементов = Коллекция.Количество();
	Исключение
		КоличествоЭлементов = Неопределено;
	КонецПопытки;
	Индикатор = ЛксПолучитьИндикаторПроцесса(КоличествоЭлементов, "Подготовка таблицы");
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		ЛксОбработатьИндикатор(Индикатор);
		СтрокаЭлемента = ТаблицаКоллекции.Добавить();
		СтрокаЭлемента._ТипЭлементаКоллекции = ТипЗнч(ЭлементКоллекции);
		СтрокаЭлемента._ЗначениеЭлементаКоллекции = ЭлементКоллекции;
		Если ЕстьИндекс Тогда
			СтрокаЭлемента.Индекс = Коллекция.Индекс(ЭлементКоллекции);
		КонецЕсли;
		//Если НайденныеСтроки.Количество() > 0 Тогда
			Попытка
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента, ЭлементКоллекции);
			Исключение
				// Сюда попадаем, если какое то свойство недоступно
			КонецПопытки; 
			Для Каждого СвойствоЭлементаКоллекции Из СвойстваЭлементовКоллекции Цикл
				Попытка
					ЗначениеСвойства = ЭлементКоллекции[СвойствоЭлементаКоллекции];
				Исключение
					СтрокаЭлемента[СвойствоЭлементаКоллекции] = "<Недоступно>";
					Продолжить;
				КонецПопытки; 
				Попытка
					КоличествоДочернее = ЗначениеСвойства.Количество();
				Исключение
					Продолжить;
				КонецПопытки;
				СтрокаЭлемента[СвойствоЭлементаКоллекции] = ЗначениеСвойства;
			КонецЦикла; 
		//КонецЕсли;
		Размер = Размер + 1;
	КонецЦикла;
	ЛксОсвободитьИндикаторПроцесса();
	ЭлементыФормы.ТаблицаКоллекции.СоздатьКолонки();
	Для Каждого Колонка Из ЭлементыФормы.ТаблицаКоллекции.Колонки Цикл
		Если Ложь
			Или Колонка.Имя = "_ТипЭлементаКоллекции" 
			Или Колонка.Имя = "_ЗначениеЭлементаКоллекции" // Нормально редактировать без указания типов при создании колонки все равно не получится
		Тогда
			Колонка.ТолькоПросмотр = Истина;
			Продолжить;
		КонецЕсли; 
		ПолеВвода = Колонка.ЭлементУправления;
		ПолеВвода.КнопкаВыбора = Истина;
		ПолеВвода.ВыбиратьТип = Истина;
		ПолеВвода.КнопкаОчистки = Истина;
		ПолеВвода.КнопкаОткрытия = Истина;
		ПолеВвода.УстановитьДействие("ПриИзменении", Новый Действие("ЯчейкаПриИзменении"));
		ПолеВвода.УстановитьДействие("НачалоВыбора", Новый Действие("ЯчейкаНачалоВыбора"));
	КонецЦикла;
	ЭлементыФормы.ТаблицаКоллекции.ТекущаяКолонка = ЭлементыФормы.ТаблицаКоллекции.Колонки[0];
	Если ТаблицаКоллекции.Колонки.Количество() = 2 Тогда
		БезСлужебныхКолонок = Ложь;
	КонецЕсли; 
	ПереключитьСлужебныеКолонки(Не БезСлужебныхКолонок);
	Если СтарыйИндекс <> Неопределено Тогда
		Если ТаблицаКоллекции.Количество() > СтарыйИндекс Тогда
			ЭлементыФормы.ТаблицаКоллекции.ТекущаяСтрока = ТаблицаКоллекции[СтарыйИндекс];
		КонецЕсли; 
	КонецЕсли; 
	Если СтараяКолонка <> Неопределено Тогда
		НоваяКолонка = ЭлементыФормы.ТаблицаКоллекции.Колонки.Найти(СтараяКолонка);
		Если НоваяКолонка <> Неопределено Тогда
			ЭлементыФормы.ТаблицаКоллекции.ТекущаяКолонка = НоваяКолонка;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры // ОбновитьДанные()
 
Процедура ПриОткрытии()
	
	Если СтруктураТипаКоллекции = Неопределено Тогда
		УстановитьИсследуемоеЗначение(Новый Массив);
	Иначе
		ТипКоллекции = ирКэш.Получить().ПолучитьСтрокуКонкретногоТипа(СтруктураТипаКоллекции);
		ОбновитьДанные();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьТекущийЭлемент()

	ТекущаяСтрока = ЭлементыФормы.ТаблицаКоллекции.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма = Обработки.ирИсследовательОбъектов.ПолучитьФорму("ИсследовательОбъектов", ЭтаФорма, Выражение);
		ОбновитьМетаданныеВСтруктуреТипаЭлементаКоллекции(ТекущаяСтрока);
		Форма.УстановитьИсследуемоеЗначение(ТекущаяСтрока._ЗначениеЭлементаКоллекции, Выражение, СтруктураТипаЭлементаКоллекции);
		Форма.ИмяТекущегоСвойства = ЭтаФорма.ЭлементыФормы.ТаблицаКоллекции.ТекущаяКолонка.Данные;
		Форма.Открыть();
	КонецЕсли;
	
КонецПроцедуры // ОткрытьТекущийЭлемент()

Функция ОбновитьМетаданныеВСтруктуреТипаЭлементаКоллекции(ТекущаяСтрока)

	Если ирКэш.Получить().мМассивТиповВключающихМетаданные.Найти(ТекущаяСтрока._ТипЭлементаКоллекции) <> Неопределено Тогда
		СтруктураТипаЭлементаКоллекции.Метаданные = ТекущаяСтрока._ЗначениеЭлементаКоллекции;
	//ИначеЕсли ТекущаяСтрока._ТипЭлементаКоллекции = Тип("ОбъектМетаданных") Тогда
	//	СтруктураТипаЭлементаКоллекции.Метаданные = ТекущаяСтрока._ЗначениеЭлементаКоллекции;
	ИначеЕсли ТекущаяСтрока._ТипЭлементаКоллекции = Тип("КлючИЗначение") Тогда 
		СтруктураТипаЭлементаКоллекции.Метаданные = Неопределено;
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

Процедура ТаблицаКоллекцииВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Истина
		И ЯчейкаСтрока
		И Не Колонка.Имя = "_ЗначениеЭлементаКоллекции"
	Тогда
		Если Колонка.Имя = "_ТипЭлементаКоллекции" Тогда
			Возврат;
		КонецЕсли; 
		СодержимоеЯчейки = ВыбраннаяСтрока._ЗначениеЭлементаКоллекции[Колонка.Данные];
		Если ОткрыватьИсследовать Тогда
			ирНеглобальный.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка, СодержимоеЯчейки);
		Иначе
			Форма = Обработки.ирИсследовательОбъектов.ПолучитьФорму("ИсследовательОбъектов", ЭтаФорма, Выражение + "." + Колонка.Имя);
			ОбновитьМетаданныеВСтруктуреТипаЭлементаКоллекции(ВыбраннаяСтрока);
			СтруктураСтрокОписаний = ОписанияКолонок[Колонка.Имя];
			СтруктураТипаЭлементаКоллекции = ирКэш.Получить().ПолучитьСтруктуруТипаИзКонкретногоТипа(ВыбраннаяСтрока._ТипЭлементаКоллекции);
			ТаблицаСтруктурТипов = СтруктураСтрокОписаний[СтруктураТипаЭлементаКоллекции.ИмяОбщегоТипа];
			Если ТаблицаСтруктурТипов <> Неопределено Тогда
				Если ТаблицаСтруктурТипов.Количество() > 0 Тогда
					СтруктураТипаЯчейки = ТаблицаСтруктурТипов[0];
				КонецЕсли; 
			КонецЕсли; 
			Форма.УстановитьИсследуемоеЗначение(СодержимоеЯчейки, Выражение + "." + Колонка.Имя, СтруктураТипаЯчейки);
			Форма.Открыть();
		КонецЕсли; 
	Иначе
		//Если ОткрыватьИсследовать Тогда
		//	ирНеглобальный.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка, ВыбраннаяСтрока._ЗначениеЭлементаКоллекции);
		//Иначе
			ОткрытьТекущийЭлемент();
		//КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииОткрыватьИсследовать(Кнопка)

	ОткрыватьИсследовать = Кнопка.Пометка;
	Кнопка.Пометка = Не ОткрыватьИсследовать;

КонецПроцедуры

Процедура ТаблицаКоллекцииПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		Если Элемент.ТекущаяСтрока._ТипЭлементаКоллекции = Тип("КлючИЗначение") Тогда
			ИндексЭлемента = """" + Элемент.ТекущаяСтрока.Ключ + """";
		Иначе
			ИндексЭлемента = Формат(ТаблицаКоллекции.Индекс(Элемент.ТекущаяСтрока), "ЧН=; ЧГ=");
		КонецЕсли;
		Выражение = ПутьКДаннымКоллекции + "[" + ИндексЭлемента + "]";
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаКоллекцииПередНачаломИзменения(Элемент, Отказ)
	
	//Отказ = Истина;
	//ОткрытьТекущийЭлемент();
	
КонецПроцедуры

Процедура ПереключитьСлужебныеКолонки(Видимость)

	Колонки = ЭлементыФормы.ТаблицаКоллекции.Колонки;
	Колонки._ЗначениеЭлементаКоллекции.Видимость = Видимость;
	Колонки._ТипЭлементаКоллекции.Видимость = Видимость;
	ЭлементыФормы.КоманднаяПанельКоллекции.Кнопки.БезСлужебных.Пометка = Не Видимость;

КонецПроцедуры // БезСлужебныхКолонок()

Процедура КоманднаяПанельКоллекцииБезСлужебных(Кнопка)
	
	ПереключитьСлужебныеКолонки(Кнопка.Пометка);
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииСжатьКолонки(Кнопка)
	
	ЛксСжатьКолонкиТабличногоПоля(ЭлементыФормы.ТаблицаКоллекции);
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииОПодсистеме(Кнопка)
	
	ЛксОткрытьСправкуПоПодсистеме(ЭтотОбъект);
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииЯчейкаСтрока(Кнопка)
	
	ЯчейкаСтрока = Не Кнопка.Пометка;
	Кнопка.Пометка = ЯчейкаСтрока;
	
КонецПроцедуры

Процедура ЯчейкаПриИзменении(Элемент)

	ТабличноеПоле = ЭлементыФормы.ТаблицаКоллекции;
	ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	ТекущаяСтрока = ТабличноеПоле.ТекущаяСтрока;
	Попытка
		ТекущаяСтрока._ЗначениеЭлементаКоллекции[ТекущаяКолонка.Данные] = Элемент.Значение;
		БылаОшибка = Ложь;
	Исключение
		Сообщить(ирНеглобальный.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
	КонецПопытки;
	Элемент.Значение = ТекущаяСтрока._ЗначениеЭлементаКоллекции[ТекущаяКолонка.Данные];

КонецПроцедуры // ЯчейкиПриИзменении()

Процедура ЯчейкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.ТаблицаКоллекции;
	ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	ТекущаяСтрока = ТабличноеПоле.ТекущаяСтрока;
	Попытка
		ирНеглобальный.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(ТабличноеПоле, СтандартнаяОбработка);
	Исключение
		Сообщить(ирНеглобальный.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
		Возврат;
	КонецПопытки; 
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииКонсольКода(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииСправка(Кнопка)

	ТабличноеПоле = ЭлементыФормы.ТаблицаКоллекции;
	ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	ТекущаяСтрока = ТабличноеПоле.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтруктураСтрокОписаний = ОписанияКолонок[ТекущаяКолонка.Имя];
	СтруктураТипа = ирКэш.Получить().ПолучитьСтруктуруТипаИзКонкретногоТипа(ТекущаяСтрока._ТипЭлементаКоллекции);
	ТаблицаСтруктурТипов = СтруктураСтрокОписаний[СтруктураТипа.ИмяОбщегоТипа];
	Если ТаблицаСтруктурТипов <> Неопределено Тогда
		Если ТаблицаСтруктурТипов.Количество() > 0 Тогда
			СтруктураТипа = ТаблицаСтруктурТипов[0];
			СтрокаОписания = СтруктураТипа.СтрокаОписания;
			ирНеглобальный.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииШиринаКолонок(Кнопка)
	
	ЛксВвестиИУстановитьШиринуКолонокТабличногоПоля(ЭлементыФормы.ТаблицаКоллекции);

КонецПроцедуры

Процедура ТаблицаКоллекцииПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирНеглобальный.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки,
		ЭлементыФормы.КоманднаяПанельКоллекции.Кнопки.Пустые.Пометка);
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииОбновить(Кнопка)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииМенеджерТабличногоПоля(Кнопка)
	
	 Обработки.ирМенеджерТабличногоПоля.ПолучитьФорму(, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.ТаблицаКоллекции);
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииКонсольКомпоновки(Кнопка)
	
    Отчеты.ирКонсольКомпоновокДанных.Создать().ОткрытьПоТаблицеЗначений(ТаблицаКоллекции);
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииПустые(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементыФормы.ТаблицаКоллекции.ОбновитьСтроки();

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирНеглобальный.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирНеглобальный.ВстроитьКнопкиСтруктурыКоманднойПанелиЛкс(ЭтаФорма);

МаркерСловаЗначения = "_Значение_";
ОписанияКолонок = Новый Соответствие;
ТаблицаКоллекции.Колонки.Добавить("_ТипЭлементаКоллекции", Новый ОписаниеТипов("Тип"), "Тип элемента коллекции");
ТаблицаКоллекции.Колонки.Добавить("_ЗначениеЭлементаКоллекции",, "Значение элемента коллекции");
