﻿Перем _Значение_ Экспорт;
Перем БазовоеВыражение Экспорт;
Перем СтруктураТипаКоллекции;
Перем СтруктураТипаЭлементаКоллекции;
Перем МаркерСловаЗначения;
Перем Коллекция;
Перем ПутьКДаннымКоллекции;
Перем ОписанияКолонок;
Перем СвойстваЭлементовКоллекции;
Перем ИмяКолонкиИндекс;
Перем мПлатформа;

Процедура УстановитьИсследуемоеЗначение(пЗначение, пПутьКДанным = Неопределено, пСтруктураТипаКоллекции = Неопределено,
	БезСлужебныхКолонок = Ложь) Экспорт 

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

	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
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
	МассивТиповЭлементовКоллекции = мПлатформа.ПолучитьТипыЭлементовКоллекции(СтруктураТипаКоллекции);
	ЕстьИндекс = Ложь;
	СтруктураТипаЭлементаКоллекции = мПлатформа.НоваяСтруктураТипа(); // т.к. цикл может и не выполниться ни разу
	Для Каждого ТипЭлементаКоллекции Из МассивТиповЭлементовКоллекции Цикл
		СтруктураТипаЭлементаКоллекции = мПлатформа.НоваяСтруктураТипа();
		Если ТипЗнч(СтруктураТипаКоллекции.Метаданные) <> Тип("COMОбъект") Тогда // Сделано для ISWbemObject {WbemScripting.SwbemLocator}
			СтруктураТипаЭлементаКоллекции.Метаданные = СтруктураТипаКоллекции.Метаданные; // Было закомментировано
		КонецЕсли; 
		СтруктураТипаЭлементаКоллекции.ИмяОбщегоТипа = ТипЭлементаКоллекции;
		// Создадим колонки таблицы
		СтруктураКлюча = Новый Структура("БазовыйТип, ЯзыкПрограммы", ТипЭлементаКоллекции, 0);
		НайденныеСтроки = мПлатформа.ТаблицаОбщихТипов.НайтиСтроки(СтруктураКлюча);
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтруктураТипаЭлементаКоллекции.СтрокаОписания = НайденныеСтроки[0];
			СтруктураТипаЭлементаКоллекции.ИмяОбщегоТипа = НайденныеСтроки[0].Слово;
		КонецЕсли; 
		ДобавитьТипЭлементаКоллекции(СтруктураТипаЭлементаКоллекции, ЕстьИндекс);
	КонецЦикла;
	
	Размер = 0;
	// Заполним таблицу
	КоличествоЭлементов = ирОбщий.ПолучитьКоличествоЭлементовКоллекцииЛкс(Коллекция);
	СписокТиповОбнаруженныхЭлементов = Новый СписокЗначений;
	СписокТиповОбнаруженныхЭлементов.ТипЗначения = Новый ОписаниеТипов("Тип");
	НепустыеСвойства = Новый Структура;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоЭлементов, "Подготовка таблицы");
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		СтрокаЭлемента = ТаблицаКоллекции.Добавить();
		СтрокаЭлемента._ТипЭлементаКоллекции = ТипЗнч(ЭлементКоллекции);
		СтрокаЭлемента._ЗначениеЭлементаКоллекции = ЭлементКоллекции;
		Если ЕстьИндекс Тогда
			СтрокаЭлемента[ИмяКолонкиИндекс] = Коллекция.Индекс(ЭлементКоллекции);
		КонецЕсли;
		Если СписокТиповОбнаруженныхЭлементов.НайтиПоЗначению(ТипЗнч(ЭлементКоллекции)) = Неопределено Тогда
			СписокТиповОбнаруженныхЭлементов.Добавить(ТипЗнч(ЭлементКоллекции));
			//лСтруктураТипаЭлементаКоллекции = мПлатформа.СтруктураТипаИзКонкретногоТипа(ТипЗнч(ЭлементКоллекции));
			лСтруктураТипаЭлементаКоллекции = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(ЭлементКоллекции);
			ДобавитьТипЭлементаКоллекции(лСтруктураТипаЭлементаКоллекции);
		КонецЕсли; 
		Если ТипЗнч(ЭлементКоллекции) = Тип("ОбъектXDTO") Тогда
			Для Каждого СвойствоXDTO Из ЭлементКоллекции.Свойства() Цикл
				Если ТаблицаКоллекции.Колонки.Найти(СвойствоXDTO.Имя) = Неопределено Тогда
					ТаблицаКоллекции.Колонки.Добавить(СвойствоXDTO.Имя);
					СвойстваЭлементовКоллекции.Добавить(СвойствоXDTO.Имя);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли; 
		Для Каждого СвойствоЭлементаКоллекции Из СвойстваЭлементовКоллекции Цикл
			Попытка
				ЗначениеСвойства = ЭлементКоллекции[СвойствоЭлементаКоллекции];
			Исключение
				СтрокаЭлемента[СвойствоЭлементаКоллекции] = "<Недоступно>";
				Продолжить;
			КонецПопытки; 
			Если Не НепустыеСвойства.Свойство(СвойствоЭлементаКоллекции) Тогда
				НепустыеСвойства.Вставить(СвойствоЭлементаКоллекции);
			КонецЕсли; 
			//Попытка
			//	КоличествоДочернее = ЗначениеСвойства.Количество();
			//Исключение
			//	Продолжить;
			//КонецПопытки;
			СтрокаЭлемента[СвойствоЭлементаКоллекции] = ЗначениеСвойства;
		КонецЦикла; 
		Размер = Размер + 1;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	// https://www.hostedredmine.com/issues/893358
	Для Каждого СвойствоЭлементаКоллекции Из СвойстваЭлементовКоллекции Цикл
		Если Не НепустыеСвойства.Свойство(СвойствоЭлементаКоллекции) Тогда
			ТаблицаКоллекции.Колонки.Удалить(СвойствоЭлементаКоллекции);
		КонецЕсли; 
	КонецЦикла; 
	ТаблицаКоллекции = ирОбщий.ТаблицаСМинимальнымиТипамиКолонокЛкс(ТаблицаКоллекции);
	СписокТиповОбнаруженныхЭлементов.СортироватьПоЗначению();
	//ТипыОбнаруженныхЭлементов = Новый ОписаниеТипов(СписокТиповОбнаруженныхЭлементов.ВыгрузитьЗначения());
	ЭлементыФормы.ТаблицаКоллекции.СоздатьКолонки();
	ирОбщий.ТабличноеПолеВставитьКолонкуНомерСтрокиЛкс(ЭлементыФормы.ТаблицаКоллекции);
	ирОбщий.ТабличноеПолеРезультатаЗапросаНастроитьКолонкиЛкс(ЭлементыФормы.ТаблицаКоллекции);
	ТабличноеПоле = ЭлементыФормы.ТаблицаКоллекции;
	Для Каждого Колонка Из ТабличноеПоле.Колонки Цикл
		Если Ложь
			Или Колонка.Имя = "_ТипЭлементаКоллекции" 
			Или Колонка.Имя = "_ЗначениеЭлементаКоллекции" // Нормально редактировать без указания типов при создании колонки все равно не получится
		Тогда
			Колонка.ТолькоПросмотр = Истина;
			Продолжить;
		КонецЕсли; 
		ПолеВвода = Колонка.ЭлементУправления;
		#Если Сервер И Не Сервер Тогда
			ПолеВвода = Новый ПолеВвода;
		#КонецЕсли
		ПолеВвода.КнопкаВыбора = Истина;
		ПолеВвода.ВыбиратьТип = Истина;
		ПолеВвода.КнопкаОчистки = Истина;
		ПолеВвода.КнопкаОткрытия = Истина;
		Попытка
			ПолеВвода.МногострочныйРежим = Истина;
		Исключение
		КонецПопытки; 
		ПолеВвода.УстановитьДействие("ПриИзменении", Новый Действие("ЯчейкаПриИзменении"));
		ПолеВвода.УстановитьДействие("НачалоВыбора", Новый Действие("ЯчейкаНачалоВыбора"));
	КонецЦикла;
	ЭлементыФормы.ТаблицаКоллекции.ТекущаяКолонка = ЭлементыФормы.ТаблицаКоллекции.Колонки[0];
	Если ТаблицаКоллекции.Колонки.Количество() = 3 Тогда
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

КонецПроцедуры

Процедура ДобавитьТипЭлементаКоллекции(СтруктураТипаЭлементаКоллекции, выхЕстьИндекс = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ВнутренняяТаблицаСлов = мПлатформа.ПолучитьТаблицуСловСтруктурыТипа(СтруктураТипаЭлементаКоллекции);
	Если СтруктураТипаЭлементаКоллекции.ИмяОбщегоТипа = "КлючИЗначение" Тогда
		ВнутренняяТаблицаСлов.Сортировать("Слово Убыв");
	КонецЕсли; 
	Для Каждого ВнутренняяСтрокаСлова Из ВнутренняяТаблицаСлов Цикл
		Если ВнутренняяСтрокаСлова.ТипСлова = "Метод" Тогда
			// Методы здесь игнорируем
			Если ВнутренняяСтрокаСлова.Слово = "Индекс" И ТаблицаКоллекции.Колонки.Найти(ИмяКолонкиИндекс) = Неопределено Тогда
				ТаблицаКоллекции.Колонки.Добавить(ИмяКолонкиИндекс, Новый ОписаниеТипов("Число"), "Индекс*");
				выхЕстьИндекс = Истина;
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
			ТаблицаКоллекции.Колонки.Добавить(ВнутренняяСтрокаСлова.Слово);
			СвойстваЭлементовКоллекции.Добавить(ВнутренняяСтрокаСлова.Слово);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
 
Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если СтруктураТипаКоллекции = Неопределено Тогда
		УстановитьИсследуемоеЗначение(Новый Массив);
	Иначе
		ТипКоллекции = мПлатформа.ИмяТипаИзСтруктурыТипа(СтруктураТипаКоллекции);
		ОбновитьДанные();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьТекущийЭлемент()

	ТекущаяСтрока = ЭлементыФормы.ТаблицаКоллекции.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирИсследовательОбъектов.Форма.ИсследовательОбъектов",, ЭтаФорма, Выражение);
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
			ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, СодержимоеЯчейки);
		Иначе
			Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирИсследовательОбъектов.Форма.ИсследовательОбъектов",, ЭтаФорма, Выражение + "." + Колонка.Имя);
			ОбновитьМетаданныеВСтруктуреТипаЭлементаКоллекции(ВыбраннаяСтрока);
			СтруктураСтрокОписаний = ОписанияКолонок[Колонка.Имя];
			СтруктураТипаЭлементаКоллекции = ирКэш.Получить().СтруктураТипаИзКонкретногоТипа(ВыбраннаяСтрока._ТипЭлементаКоллекции);
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
		//	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ВыбраннаяСтрока._ЗначениеЭлементаКоллекции);
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
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
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
	//Колонки._ЗначениеЭлементаКоллекции.Видимость = Видимость;
	Колонки._ТипЭлементаКоллекции.Видимость = Видимость;
	ЭлементыФормы.КоманднаяПанельКоллекции.Кнопки.БезСлужебных.Пометка = Не Видимость;

КонецПроцедуры // БезСлужебныхКолонок()

Процедура КоманднаяПанельКоллекцииБезСлужебных(Кнопка)
	
	ПереключитьСлужебныеКолонки(Кнопка.Пометка);
	
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
		Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
	КонецПопытки;
	Элемент.Значение = ТекущаяСтрока._ЗначениеЭлементаКоллекции[ТекущаяКолонка.Данные];

КонецПроцедуры // ЯчейкиПриИзменении()

Процедура ЯчейкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.ТаблицаКоллекции;
	ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	ТекущаяСтрока = ТабличноеПоле.ТекущаяСтрока;
	Попытка
		ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ТабличноеПоле, СтандартнаяОбработка);
	Исключение
		Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
		Возврат;
	КонецПопытки; 
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииСправка(Кнопка)

	ТабличноеПоле = ЭлементыФормы.ТаблицаКоллекции;
	ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	ТекущаяСтрока = ТабличноеПоле.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтруктураСтрокОписаний = ОписанияКолонок[ТекущаяКолонка.Имя];
	СтруктураТипа = ирКэш.Получить().СтруктураТипаИзКонкретногоТипа(ТекущаяСтрока._ТипЭлементаКоллекции);
	ТаблицаСтруктурТипов = СтруктураСтрокОписаний[СтруктураТипа.ИмяОбщегоТипа];
	Если ТаблицаСтруктурТипов <> Неопределено Тогда
		Если ТаблицаСтруктурТипов.Количество() > 0 Тогда
			СтруктураТипа = ТаблицаСтруктурТипов[0];
			СтрокаОписания = СтруктураТипа.СтрокаОписания;
			ирОбщий.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаКоллекцииПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КоманднаяПанельКоллекции.Кнопки.Идентификаторы);
	
КонецПроцедуры

Процедура КоманднаяПанельКоллекцииОбновить(Кнопка)
	
	ОбновитьДанные();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ЭлементыОткрытие(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ОткрытьЗначениеЛкс(Элемент.Значение, Ложь, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ТаблицаКоллекцииПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирИсследовательОбъектов.Форма.ИсследовательКоллекций");

МаркерСловаЗначения = "_Значение_";
ИмяКолонкиИндекс = "_Индекс_189958";
ОписанияКолонок = Новый Соответствие;
ТаблицаКоллекции.Колонки.Добавить("_ТипЭлементаКоллекции", Новый ОписаниеТипов("Тип"), "Тип элемента коллекции");
ТаблицаКоллекции.Колонки.Добавить("_ЗначениеЭлементаКоллекции",, "Значение элемента коллекции");
мПлатформа = ирКэш.Получить();
