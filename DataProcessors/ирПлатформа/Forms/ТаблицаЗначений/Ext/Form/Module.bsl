﻿Перем СтараяТаблицаКолонок;
Перем ЭтоДерево;
Перем РасширениеФайла;
Перем мПлатформа;

// Обработка выбора значения в таблице
//
Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	Если РежимВыбора Тогда
		ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ВыбраннаяСтрока);
	Иначе
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	КонецЕсли; 

КонецПроцедуры // ТаблицаВыбор

Функция ПолучитьРезультат()
	
	Возврат ЭлементыФормы.ПолеТаблицы.Значение;
	
КонецФункции

Процедура КоманднаяПанельТаблицаСжатьКолонки(Кнопка)
	
	ирОбщий.СжатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаШиринаКолонок(Кнопка)
	
	ирОбщий.РасширитьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Функция ОбновитьКолонкуТабличногоПоляПоКолонкеДанных(КолонкаДанных)
	
	Если КолонкаДанных.Имя = "" Тогда
		Возврат Неопределено;
	КонецЕсли;
	КолонкиТП = ЭлементыФормы.ПолеТаблицы.Колонки;
	КолонкаТП = КолонкиТП.Найти(КолонкаДанных.Имя);
	Если КолонкаТП = Неопределено Тогда
		КолонкаТП = КолонкиТП.Добавить(КолонкаДанных.Имя); 
	КонецЕсли; 
	КолонкаТП.Данные = КолонкаДанных.Имя;
	ТекстШапки = КолонкаДанных.Имя;
	Если ЗначениеЗаполнено(КолонкаДанных.Заголовок) И ТекстШапки <> КолонкаДанных.Заголовок Тогда
		ТекстШапки = ТекстШапки + " (" + КолонкаДанных.Заголовок + ")";
	КонецЕсли; 
	КолонкаТП.ТекстШапки = ТекстШапки;
	КолонкаТП.ОтображатьИерархию = Ложь;
	КолонкаТП.ЭлементУправления.КнопкаВыбора = Истина;
	КолонкаТП.ЭлементУправления.ВыбиратьТип = Истина;
	КолонкаТП.ЭлементУправления.КнопкаОчистки = Истина;
	КолонкаТП.ЭлементУправления.КнопкаОткрытия = Истина;
	КолонкаТП.ЭлементУправления.УстановитьДействие("ОкончаниеВводаТекста", Новый Действие("ЯчейкаОкончаниеВводаТекста"));
	КолонкаТП.ЭлементУправления.УстановитьДействие("НачалоВыбора", Новый Действие("ЯчейкаНачалоВыбора"));
	КолонкаТП.ЭлементУправления.УстановитьДействие("ПриИзменении", Новый Действие("ЯчейкаПриИзменении"));
	Возврат КолонкаТП;
	
КонецФункции

Процедура ОбновитьТаблицуКолонок()

	СтароеИмя = Неопределено;
	Если ЭлементыФормы.ТаблицаКолонок.ТекущаяСтрока <> Неопределено Тогда
		СтароеИмя = ЭлементыФормы.ТаблицаКолонок.ТекущаяСтрока.Имя;
	КонецЕсли;
	ТаблицаКолонок.Очистить();
	ирОбщий.ТабличноеПолеВставитьКолонкуНомерСтрокиЛкс(ЭлементыФормы.ПолеТаблицы);
	Для Каждого Колонка Из ЭлементыФормы.ПолеТаблицы.Значение.Колонки Цикл
		СтрокаКолонки = ТаблицаКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКолонки, Колонка); 
		СтрокаКолонки.ИмяСтаройКолонки = Колонка.Имя;
		ОбновитьКолонкуТабличногоПоляПоКолонкеДанных(Колонка);
	КонецЦикла;
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы);
	СтараяТаблицаКолонок = ТаблицаКолонок.Скопировать();
	Если СтароеИмя <> Неопределено Тогда
		НоваяТекущаяСтрока = ТаблицаКолонок.Найти(СтароеИмя, "Имя");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ТаблицаКолонок.ТекущаяСтрока = НоваяТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	ОбновитьКолонкиТаблицы(); // 18.03.2012

КонецПроцедуры

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение) Экспорт 
	
	ТипОбъекта = ТипЗнч(НовоеЗначение);
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипОбъекта);
	ЭтоДерево = (ТипОбъекта = Тип("ДеревоЗначений"));
	ЭлементыФормы.ПолеТаблицы.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	ЭлементыФормы.ПолеТаблицы.Значение = НовоеЗначение;
	ЭтаФорма.Заголовок = ТипОбъекта;
	ОбновитьТаблицуКолонок();
	ЭлементыФормы.КоманднаяПанельТаблица.Кнопки.Передать.Кнопки.КонсольКомпоновки.Доступность = Не ЭтоДерево;
	ЭлементыФормы.КоманднаяПанельТаблица.Кнопки.ПоказатьНеуникальные.Доступность = Не ЭтоДерево;
	НачальноеЗначениеВыбора = НовоеЗначение;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если НачальноеЗначениеВыбора = Неопределено Тогда
		НачальноеЗначениеВыбора = Новый ТаблицаЗначений;
		НачальноеЗначениеВыбора.Колонки.Добавить("Колонка1", Новый ОписаниеТипов("Строка"));
	КонецЕсли;
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора);
	Если ТабличноеПоле <> Неопределено Тогда
		Если ТабличноеПоле.ТекущаяКолонка <> Неопределено Тогда 
			ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле);
			Если ЗначениеЗаполнено(ДанныеКолонки) Тогда
				ЭлементыФормы.ПолеТаблицы.ТекущаяКолонка = ЭлементыФормы.ПолеТаблицы.Колонки.Найти(ДанныеКолонки);
				// https://partners.v8.1c.ru/forum/t/1632942/m/1632942
				ПодключитьОбработчикОжидания("ПереустановитьТекущуюКолонку", 0.1, Истина);
				ЭлементыФормы.ТаблицаКолонок.ТекущаяСтрока = ТаблицаКолонок.Найти(ДанныеКолонки, "Имя");
			КонецЕсли; 
		КонецЕсли; 
		Если ТабличноеПоле.ТекущаяСтрока <> Неопределено Тогда
			Если ТипЗнч(ТабличноеПоле.Значение) = Тип("ДеревоЗначений") Тогда
				КоординатыВДереве = ирОбщий.ПолучитьКоординатыСтрокиДереваЛкс(ТабличноеПоле.ТекущаяСтрока);
				НоваяТекущаяСтрока = ирОбщий.ПолучитьСтрокуДереваПоКоординатамЛкс(ТабличноеПоле.Значение, КоординатыВДереве);
			Иначе
				НоваяТекущаяСтрока = НачальноеЗначениеВыбора.Получить(ТабличноеПоле.Значение.Индекс(ТабличноеПоле.ТекущаяСтрока));
			КонецЕсли; 
			Если НоваяТекущаяСтрока <> Неопределено Тогда
				ЭлементыФормы.ПолеТаблицы.ТекущаяСтрока = НоваяТекущаяСтрока;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если ТаблицаКолонок.Количество() = 0 Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТаблицаКолонок;
	КонецЕсли; 
	ЭтаФорма.рТолькоПросмотр = ТолькоПросмотр;
	ЭлементыФормы.ТолькоПросмотр.Доступность = Не ТолькоПросмотр;
	ТолькоПросмотрПриИзменении();
	
КонецПроцедуры

// https://partners.v8.1c.ru/forum/t/1632942/m/1632942
Процедура ПереустановитьТекущуюКолонку()
	
	ЭлементыФормы.ПолеТаблицы.ТекущаяКолонка = ЭлементыФормы.ПолеТаблицы.ТекущаяКолонка;
	
КонецПроцедуры

Процедура ТаблицаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КоманднаяПанельТаблица.Кнопки.Идентификаторы);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Модифицированность = Ложь;
	НовоеЗначение = ПолучитьРезультат();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Если ЭтоДерево Тогда
		Если ЭлементыФормы.ПолеТаблицы.ТекущаяСтрока <> Неопределено Тогда
			Родитель = ЭлементыФормы.ПолеТаблицы.ТекущаяСтрока.Родитель;
		КонецЕсли; 
		Если Родитель = Неопределено Тогда
			Родитель = ЭлементыФормы.ПолеТаблицы.Значение;
		КонецЕсли; 
		ЭтаФорма.КоличествоСтрок = Родитель.Строки.Количество();
	Иначе
		ЭтаФорма.КоличествоСтрок = ЭлементыФормы.ПолеТаблицы.Значение.Количество();
	КонецЕсли; 
	ЭтаФорма.КоличествоКолонок = ЭлементыФормы.ПолеТаблицы.Значение.Колонки.Количество();
	Если Не ирОбщий.СериализацииРавныЛкс(СтараяТаблицаКолонок, ТаблицаКолонок) Тогда 
		ОбновитьКолонкиТаблицы();
		СтараяТаблицаКолонок = ТаблицаКолонок.Скопировать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьКолонкиТаблицы()
	
	Таблица = ЭлементыФормы.ПолеТаблицы.Значение;
	КолонкиДляУдаления = Новый Массив;
	Для Каждого КолонкаДляУдаления Из Таблица.Колонки Цикл
		КолонкиДляУдаления.Добавить(КолонкаДляУдаления);
	КонецЦикла;
	
	ПозицияКолонки = -1;
	Для Каждого СтрокаКолонки Из ТаблицаКолонок Цикл
		ПозицияКолонки = ПозицияКолонки + 1;
		Если СтрокаКолонки.ИмяСтаройКолонки <> "" Тогда
			ИмяСтаройКолонки = СтрокаКолонки.ИмяСтаройКолонки;
			СтараяКолонка = Таблица.Колонки[ИмяСтаройКолонки];
			КолонкиДляУдаления.Удалить(КолонкиДляУдаления.Найти(СтараяКолонка));
			
			//Если Не ирОбщий.СтрокиРавныЛкс(ИмяСтаройКолонки, СтрокаКолонки.Имя) Тогда
			Если ИмяСтаройКолонки <> СтрокаКолонки.Имя Тогда
				НовоеИмя = СтрокаКолонки.Имя;
				НовоеИмяКорректно = Истина;
				Попытка
					СтараяКолонка.Имя = НовоеИмя;
				Исключение
					// Ввели некорректное имя колонки
					НовоеИмяКорректно = Ложь;
				КонецПопытки; 
				Если НовоеИмяКорректно Тогда
					Колонка = ЭлементыФормы.ПолеТаблицы.Колонки.Найти(ИмяСтаройКолонки);
					Колонка.Имя = СтрокаКолонки.Имя;
					СтрокаКолонки.ИмяСтаройКолонки = СтрокаКолонки.Имя;
					ОбновитьКолонкуТабличногоПоляПоКолонкеДанных(СтараяКолонка);
				КонецЕсли; 
			КонецЕсли;
			
			Если Не ирОбщий.СериализацииРавныЛкс(СтараяКолонка.ТипЗначения, СтрокаКолонки.ТипЗначения) Тогда
				ВременноеИмя = ирКэш.Получить().ПолучитьИдентификаторИзПредставления(Новый УникальныйИдентификатор());
				ВременнаяКолонка = Таблица.Колонки.Добавить(ВременноеИмя, СтрокаКолонки.ТипЗначения);
				Если ЭтоДерево Тогда
					ВсеСтроки = ирОбщий.ВсеСтрокиДереваЗначенийЛкс(Таблица);
				Иначе
					ВсеСтроки = Таблица;
				КонецЕсли; 
				Для Каждого СтрокаТаблицы Из ВсеСтроки Цикл
					ОбработкаПрерыванияПользователя();
					СтрокаТаблицы[ВременноеИмя] = СтрокаТаблицы[ИмяСтаройКолонки];
				КонецЦикла; 
				Таблица.Колонки.Удалить(ИмяСтаройКолонки);
				ВременнаяКолонка.Имя = СтрокаКолонки.Имя;
				ОбновитьКолонкуТабличногоПоляПоКолонкеДанных(ВременнаяКолонка);
				СтараяКолонка = ВременнаяКолонка;
			КонецЕсли;
			Таблица.Колонки.Сдвинуть(СтараяКолонка, -Таблица.Колонки.Индекс(СтараяКолонка) + ПозицияКолонки);
		Иначе
			Если СтрокаКолонки.Имя = "" Тогда
				 Продолжить;
			КонецЕсли; 
			СтараяКолонка = Таблица.Колонки.Добавить(СтрокаКолонки.Имя, СтрокаКолонки.ТипЗначения);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтараяКолонка, СтрокаКолонки, "Заголовок, Ширина"); 
		ОбновитьКолонкуТабличногоПоляПоКолонкеДанных(СтараяКолонка);
		Если СтрокаКолонки.ИмяСтаройКолонки = "" Тогда
			СтрокаКолонки.ИмяСтаройКолонки = СтрокаКолонки.Имя;
		КонецЕсли;
	КонецЦикла;
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы);
	// Антибаг платформы https://partners.v8.1c.ru/forum/topic/1263179
	Если КолонкиДляУдаления.Количество() = 0 Тогда
		ЭлементыФормы.ПолеТаблицы.Колонки.Удалить(ЭлементыФормы.ПолеТаблицы.Колонки.Добавить());
	КонецЕсли; 	
	Для Каждого КолонкаДляУдаления Из КолонкиДляУдаления Цикл
		КолонкаФормыДляУдаления = ЭлементыФормы.ПолеТаблицы.Колонки.Найти(КолонкаДляУдаления.Имя);
		Если КолонкаФормыДляУдаления <> Неопределено Тогда
			ЭлементыФормы.ПолеТаблицы.Колонки.Удалить(КолонкаФормыДляУдаления);
		КонецЕсли; 
		Таблица.Колонки.Удалить(КолонкаДляУдаления);
	КонецЦикла; 
	Если ЭлементыФормы.ПолеТаблицы.Колонки.Количество() > 1 Тогда
		ЭлементыФормы.ПолеТаблицы.Колонки[1].ОтображатьИерархию = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИзменитьСвернутостьПанелиКолонок(Видимость = Истина)
	
	ирОбщий.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.ТаблицаКолонок, ЭлементыФормы.гРазделитель, ЭтаФорма.Панель, "верх");

КонецПроцедуры

Процедура КоманднаяПанельТаблицаКолонки(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ИзменитьСвернутостьПанелиКолонок(Кнопка.Пометка);
	
КонецПроцедуры

Процедура ПриЗакрытии()

	ИзменитьСвернутостьПанелиКолонок(Истина);
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Модифицированность Тогда
		Ответ = Вопрос("Данные в форме были изменены. Хотите сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			Модифицированность = Ложь;
			ОсновныеДействияФормыОК();
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЯчейкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.ПолеТаблицы, СтандартнаяОбработка, , Истина);
	
КонецПроцедуры

Процедура ЯчейкаПриИзменении(Элемент)
	
	Оповестить("ПриИзмененииЯчейки", , ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура ЯчейкаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура ТаблицаКолонокТипЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	//РезультатВыбора = ирОбщий.РедактироватьОписаниеРедактируемыхТиповЛкс(Элемент);
	//Если РезультатВыбора <> Неопределено Тогда
	//	Элемент.Значение = РезультатВыбора;
	//КонецЕсли; 
	//СтандартнаяОбработка = Ложь;
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаКолонок, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаОбновить(Кнопка)
	
	ОбновитьТаблицуКолонок();
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура ТаблицаКолонокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Если Не Копирование Тогда
			Элемент.ТекущиеДанные.ТипЗначения = ирОбщий.ОписаниеТиповВсеРедактируемыеТипыЛкс();
		КонецЕсли; 
		Элемент.ТекущиеДанные.ИмяСтаройКолонки = Неопределено;
		Элемент.ТекущиеДанные.Имя = ирОбщий.ПолучитьАвтоУникальноеИмяВКоллекцииЛкс(Элемент.Значение, Элемент.ТекущиеДанные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы, ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаСохранитьВФайл(Кнопка)
	
	ирОбщий.СохранитьЗначениеВФайлИнтерактивноЛкс(ПолучитьРезультат(), РасширениеФайла);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаЗагрузитьИзФайла(Кнопка)
	
	Результат = ирОбщий.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс(РасширениеФайла);
	Если Ложь
		Или ТипЗнч(Результат) = Тип("ТаблицаЗначений")
		Или ТипЗнч(Результат) = Тип("ДеревоЗначений")
	Тогда
		УстановитьРедактируемоеЗначение(Результат);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаКонсольКомпоновки(Кнопка)
	
    КонсольКомпоновокДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Отчет.ирКонсольКомпоновокДанных");
	#Если Сервер И Не Сервер Тогда
		КонсольКомпоновокДанных = Отчеты.ирКонсольКомпоновокДанных.Создать();
	#КонецЕсли
    КонсольКомпоновокДанных.ОткрытьПоТаблицеЗначений(ЭлементыФормы.ПолеТаблицы.Значение);
	
КонецПроцедуры

Процедура ТаблицаКолонокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура КоманднаяПанельТаблицаКонсольОбработки(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭтаФорма.ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаРедакторОбъектаБД(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭтаФорма.ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьЗначениеЛкс(ПолучитьРезультат().Скопировать(),,,, Ложь,, ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Функция СформироватьимяКолонки(знач ИмяКолонки, ИДТекСтроки)
	НТЗ = ТаблицаКолонок;
	Флаг = Истина;
	Индекс = 0;
	ИмяКолонки = СокрЛП(ИмяКолонки);
	Пока Флаг Цикл
		Имя = ИмяКолонки + Строка(Формат(Индекс, "ЧН=-"));
		Имя = СтрЗаменить(Имя, "-", "");
		// Если нет строки с таким именем.
		Фильтр = Новый Структура("Имя", Имя);
		ОтфильтрованныеСтроки = НТЗ.НайтиСтроки(Фильтр);
		Если ОтфильтрованныеСтроки.Количество() = 0 Тогда
			Флаг = Ложь;
		Иначе
			Если ОтфильтрованныеСтроки.Получить(0) <> ИДТекСтроки Тогда 
				Флаг = Истина;
			Иначе
				Флаг = Ложь;
			КонецЕсли;	
		КонецЕсли;
		//// Если нет колонки с таким именем.
		//Колонки = Элементы.ТаблицаЗначенийПараметр.ПодчиненныеЭлементы;
		//КолКолонок = Колонки.Количество();
		//Для Индекс = 0 по КолКолонок - 1 Цикл 
		//	Если Колонки.Получить(Индекс).Имя = Имя Тогда 
		//		Флаг = Истина;
		//		Прервать;
		//	КонецЕсли;	
		//КонецЦикла;	
		ВозврЗнач = ?(Флаг, "", Имя);
		Индекс = Индекс + 1;
	КонецЦикла; 
	Возврат ВозврЗнач;
КонецФункции

Функция ЧислоВСтрокуПодробно(Число)
	
	Возврат Формат(Число, "ЧН=; ЧВН=; ЧГ=0");
	
КонецФункции

Функция ТабличныйДокументВТаблицуЗначений(ИмяФайла) Экспорт
	
	Макет = Новый ТабличныйДокумент;
	Макет.Прочитать(ИмяФайла);
	КолонкиПриемника = ЭлементыФормы.ПолеТаблицы.Значение.Колонки;
	ЗагрузкаТабличныхДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирЗагрузкаТабличныхДанных");
	#Если Сервер И Не Сервер Тогда
	    ЗагрузкаТабличныхДанных = Обработки.ирЗагрузкаТабличныхДанных.Создать();
	#КонецЕсли
	Форма = ЗагрузкаТабличныхДанных.ПолучитьФорму();
	Форма.ПараметрТабличныйДокумент = Макет;
	Форма.РежимРедактора = Истина;
	РезультатФормы = Форма.ОткрытьМодально();
	Если РезультатФормы = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ТЗ = Форма.ТаблицаЗначений;
	УстановитьРедактируемоеЗначение(ТЗ);
	Возврат ТЗ;
	
КонецФункции    

Процедура КоманднаяПанельТаблицаЗагрузитьИзMXL(Кнопка)
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = ирОбщий.ПолучитьСтрокуФильтраДляВыбораФайлаЛкс("mxl,xls,xlsx,ods", "Табличный документ");
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите табличный документ для загрузки";
	ИмяФайлаТабДок = "";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ТабличныйДокументВТаблицуЗначений(ДиалогОткрытияФайла.ПолноеИмяФайла);
	//Иначе
	//	Предупреждение("Файл не выбран!");
	//	Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаЗаполнитьЗапросом(Кнопка)
	
	Если ТипЗнч(ЭлементыФормы.ПолеТаблицы.Значение) = Тип("ДеревоЗначений") Тогда
		Возврат;
	КонецЕсли; 
	КоллекцияДляЗаполнения = ЭлементыФормы.ПолеТаблицы.Значение.СкопироватьКолонки();
	ФиксированныеКолонки = Ложь;
	Если ЭлементыФормы.ПолеТаблицы.Значение.Колонки.Количество() > 0 Тогда
		Ответ = Вопрос("Хотите фиксировать колонки для результата запроса (необходимо для дополнения таблицы)?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ФиксированныеКолонки = Истина;
		КонецЕсли;
	КонецЕсли; 
	Если ФиксированныеКолонки Тогда
		КоллекцияДляЗаполнения.Колонки.Очистить();
	КонецЕсли; 
	КонсольЗапросов = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКонсольЗапросов");
	#Если Сервер И Не Сервер Тогда
		КонсольЗапросов = Обработки.ирКонсольЗапросов.Создать();
	#КонецЕсли
	РезультатЗапроса = КонсольЗапросов.ОткрытьДляЗаполненияКоллекции(КоллекцияДляЗаполнения);
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ФиксированныеКолонки Тогда
		Если ЭлементыФормы.ПолеТаблицы.Значение.Количество() > 0 Тогда
			Ответ = Вопрос("Очистить строки таблицы перед загрузкой результата запроса?", РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				ЭлементыФормы.ПолеТаблицы.Значение.Очистить();
			КонецЕсли;
		КонецЕсли; 
		ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(РезультатЗапроса, ЭлементыФормы.ПолеТаблицы.Значение);
	Иначе
		УстановитьРедактируемоеЗначение(РезультатЗапроса);
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаКолонокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если Не ОтменаРедактирования Тогда
		Элемент.ТекущиеДанные.Имя = ирОбщий.ПолучитьАвтоУникальноеИмяВКоллекцииЛкс(Элемент.Значение, Элемент.ТекущиеДанные,,, "Колонка");
		//ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(Элемент.ТекущиеДанные);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельТаблицаИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.ПолеТаблицы.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанельТаблицаРазличныеЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаВыбратьИЗаполнитьОбъектБД(Кнопка)
	
	Если ТипЗнч(ЭлементыФормы.ПолеТаблицы.Значение) = Тип("ДеревоЗначений") Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ВыбратьИЗаполнитьТабличнуюЧастьОбъектаБДЛкс(ЭлементыФормы.ПолеТаблицы.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицаКолонокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ТипЗначения,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаВСписок(Кнопка)
	
	Если Ложь
		Или ЭлементыФормы.ПолеТаблицы.ТекущаяКолонка = Неопределено 
		Или Не ЗначениеЗаполнено(ЭлементыФормы.ПолеТаблицы.ТекущаяКолонка.Данные) 
	Тогда
		Возврат;
	КонецЕсли; 
	Список = Новый СписокЗначений;
	Список.ТипЗначения = ТаблицаКолонок.Найти(ЭлементыФормы.ПолеТаблицы.ТекущаяКолонка.Данные, "Имя").ТипЗначения;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.ПолеТаблицы.ВыделенныеСтроки Цикл
		Список.Добавить(ВыделеннаяСтрока[ЭлементыФормы.ПолеТаблицы.ТекущаяКолонка.Данные]);
	КонецЦикла;
	ирОбщий.ОткрытьЗначениеЛкс(Список,,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаВывестиВТабличныйДокумент(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаВЗапрос(Кнопка)
	
    КонсольЗапросов = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКонсольЗапросов");
	#Если Сервер И Не Сервер Тогда
		КонсольЗапросов = Обработки.ирКонсольЗапросов.Создать();
	#КонецЕсли
    КонсольЗапросов.ОткрытьПоТаблицеЗначений(ЭлементыФормы.ПолеТаблицы.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаЗаполнитьГруппуДублейДляЗамены(Кнопка)
	
	ирОбщий.ОткрытьФормуЗаменыСсылокИзТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаКонсольКода(Кнопка)
	
	Текст = 
	"Для Каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
	|	
	|КонецЦикла;
	|";
	ирОбщий.ОперироватьСтруктуройЛкс(Текст, , Новый Структура("ТаблицаЗначений", ПолучитьРезультат()));
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭтаФорма, ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаУстановитьЗначениеВКолонке(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы, ЭтаФорма, "Обработка");
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаПередатьВТаблицуБД(Кнопка)
	
	КолонкиПриемника = ЭлементыФормы.ПолеТаблицы.Значение.Колонки;
	ЗагрузкаТабличныхДанных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирЗагрузкаТабличныхДанных");
	#Если Сервер И Не Сервер Тогда
	    ЗагрузкаТабличныхДанных = Обработки.ирЗагрузкаТабличныхДанных.Создать();
	#КонецЕсли
	Форма = ЗагрузкаТабличныхДанных.ПолучитьФорму();
	Форма.РежимРедактора = Истина;
	Форма.ТаблицаЗначений = ЭлементыФормы.ПолеТаблицы.Значение.Скопировать();
	Форма.ПараметрТабличныйДокумент = Новый ТабличныйДокумент;
	Форма.Открыть();
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаПоказатьНеуникальные(Кнопка)
	
	ирОбщий.ПоказатьНеуникальныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаРедакторСтроки(Кнопка)
	
	ирОбщий.ОткрытьРедакторСтрокиТаблицыЛкс(ЭтаФорма, ЭлементыФормы.ПолеТаблицы);
	
КонецПроцедуры

Процедура ПолеТаблицыПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Оповестить("ПриАктивизацииСтроки",, Элемент);

КонецПроцедуры

Процедура ТаблицаКолонокПриПолученииДанных(Элемент, ОформленияСтрок)
	
	ирОбщий.ПриПолученииДанныхТабличногоПоляКолонокЛкс(ОформленияСтрок);
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаИзТекста(Кнопка)
	
	ФормаРазбивки = ПолучитьФорму("РазбивкаТекста");
	ФормаРазбивки.Приемник = Новый ТаблицаЗначений;
	РезультатФормы = ФормаРазбивки.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		 УстановитьРедактируемоеЗначение(РезультатФормы);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТаблицаСУзитьТипыЗначений(Кнопка)
	
	Если ТипЗнч(ЭлементыФормы.ПолеТаблицы.Значение) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли; 
	СтароеИмя = Неопределено;
	Если ЭлементыФормы.ТаблицаКолонок.ТекущаяСтрока <> Неопределено Тогда
		СтароеИмя = ЭлементыФормы.ТаблицаКолонок.ТекущаяСтрока.Имя;
	КонецЕсли;
	СтарыйИндекс = Неопределено;
	Если ЭлементыФормы.ПолеТаблицы.ТекущаяСтрока <> Неопределено Тогда
		СтарыйИндекс = ЭлементыФормы.ПолеТаблицы.Значение.Индекс(ЭлементыФормы.ПолеТаблицы.ТекущаяСтрока);
	КонецЕсли;
	ТаблицаЗначений = ПолучитьРезультат();
	Если ТаблицаЗначений.Количество() > 0 Тогда
		НоваяТаблица = ирОбщий.ПолучитьТаблицуСМинимальнымиТипамиКолонокЛкс(ТаблицаЗначений);
	Иначе
		НоваяТаблица = ирОбщий.ПолучитьТаблицуСКолонкамиБезТипаNullЛкс(ТаблицаЗначений);
	КонецЕсли; 
	УстановитьРедактируемоеЗначение(НоваяТаблица);
	Если СтароеИмя <> Неопределено Тогда
		НоваяТекущаяСтрока = ТаблицаКолонок.Найти(СтароеИмя, "Имя");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ТаблицаКолонок.ТекущаяСтрока = НоваяТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	Если СтарыйИндекс <> Неопределено Тогда
		ЭлементыФормы.ПолеТаблицы.ТекущаяСтрока = ЭлементыФормы.ПолеТаблицы.Значение[СтарыйИндекс];
	КонецЕсли; 

КонецПроцедуры

Процедура ТолькоПросмотрПриИзменении(Элемент = Неопределено)
	
	ЭлементыФормы.ПолеТаблицы.ТолькоПросмотр = рТолькоПросмотр;
	ЭтаФорма.ТолькоПросмотр = рТолькоПросмотр;
	
КонецПроцедуры

Процедура ПолеТаблицыПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);
	
КонецПроцедуры

Процедура ТаблицаКолонокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
		
КонецПроцедуры

Функция АктивноеТабличноеПоле()
	Если ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТаблицаКолонок Тогда
		Результат = ЭтаФорма.ТекущийЭлемент;
	Иначе
		Результат = ЭлементыФормы.ПолеТаблицы;
	КонецЕсли; 
	Возврат Результат;
КонецФункции

Процедура КоманднаяПанельТаблицаСортироватьПоВозрастанию(Кнопка)
	
	ирОбщий.ТабличноеПолеСортироватьЛкс(ЭтаФорма, АктивноеТабличноеПоле(), Истина);

КонецПроцедуры

Процедура КоманднаяПанельТаблицаСортироватьПоУбыванию(Кнопка)
	
	ирОбщий.ТабличноеПолеСортироватьЛкс(ЭтаФорма, АктивноеТабличноеПоле(), Ложь);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ТаблицаЗначений");
РасширениеФайла = "VT_";
ТаблицаКолонок.Колонки.Добавить("ИмяСтаройКолонки", Новый ОписаниеТипов("Строка"));
ЭтоДерево = Ложь;
мПлатформа = ирКэш.Получить();