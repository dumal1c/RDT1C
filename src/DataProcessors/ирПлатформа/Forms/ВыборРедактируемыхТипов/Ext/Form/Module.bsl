﻿Перем мСоответствиеСтруктурТипа;

Функция ОтобранныеСтрокиТаблицы() Экспорт

	ВременныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(РедактируемыеТипы);
	ирОбщий.СкопироватьОтборПостроителяЛкс(ВременныйПостроительЗапроса.Отбор, ЭлементыФормы.РедактируемыеТипы.ОтборСтрок);
	ВременныйПостроительЗапроса.ВыбранныеПоля.Добавить("Имя");
	ВременныйПостроительЗапроса.Выполнить();
	Результат = ВременныйПостроительЗапроса.Результат.Выгрузить();
	Возврат Результат;

КонецФункции // ПолучитьОтобранныеСтрокиТаблицы()

Функция ПомеченныеСтрокиТаблицы() Экспорт

	Результат = РедактируемыеТипы.Выгрузить(Новый Структура("Пометка", Истина), "Имя");
	Возврат Результат;

КонецФункции

Процедура КоманднаяПанельТиповУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭтаФорма, ЭлементыФормы.РедактируемыеТипы,, Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельТиповСнятьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭтаФорма, ЭлементыФормы.РедактируемыеТипы,, Ложь);
	
КонецПроцедуры

Процедура УстановитьПометкуДерева(СтрокиДереваТипов, Признак)

	Для каждого СтрокаДереваТипа Из СтрокиДереваТипов Цикл
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаДереваТипа.Пометка, Признак);
		УстановитьПометкуДерева(СтрокаДереваТипа.Строки, Признак);
	КонецЦикла;

КонецПроцедуры // УстановитьСПометкуДерева()

Процедура ЗакрытьССохранением()

	ВыбранныеСтроки = РедактируемыеТипы.НайтиСтроки(Новый Структура("Пометка", Истина));
	НовоеЗначение = ПолучитьЗначениеВыбора(ВыбранныеСтроки);
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);

КонецПроцедуры

Функция ПолучитьЗначениеВыбора(Знач ВыбранныеСтроки)
	
	МассивТипов = Новый Массив();
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		МассивТипов.Добавить(СериализаторXDTO.ИзXMLТипа(ВыбраннаяСтрока.Имя, ВыбраннаяСтрока.URIПространстваИмен));
	КонецЦикла;
	Если МассивТипов.Найти(Тип("Строка")) <> Неопределено Тогда 
		КвалификаторыСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ?(Фиксированная, ДопустимаяДлина.Фиксированная, ДопустимаяДлина.Переменная));
	КонецЕсли; 
	Если МассивТипов.Найти(Тип("Число")) <> Неопределено Тогда 
		КвалификаторыЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ?(Неотрицательное, ДопустимыйЗнак.Неотрицательный, ДопустимыйЗнак.Любой));
	КонецЕсли; 
	Если МассивТипов.Найти(Тип("Дата")) <> Неопределено Тогда 
		КвалификаторыДаты = Новый КвалификаторыДаты(СоставДаты);
	КонецЕсли;
	Если ВыбранныеСтроки.Количество() = 1 Тогда
		ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ВыбранныеСтроки[0].Имя, ВыбранныеСтроки[0].Представление);
	КонецЕсли; 
	ОграничениеТипа = Новый ОписаниеТипов(МассивТипов, ,,КвалификаторыЧисла, КвалификаторыСтроки, КвалификаторыДаты);
	Модифицированность = Ложь;
	Если МножественныйВыбор Тогда
		Если ЭтоСсылкаНаОпределяемыйТип Тогда
			НовоеЗначение = ирОбщий.ОписаниеТиповСоСсылкойНаОпределяемыйТипЛкс(ОпределяемыйТип); // Это не создает ссылку
		Иначе
			НовоеЗначение = ОграничениеТипа;
		КонецЕсли; 
	Иначе
		Типы = ОграничениеТипа.Типы();
		Если Типы.Количество() > 0 Тогда
			НовоеЗначение = Типы[0];
		Иначе
			НовоеЗначение = Неопределено
		КонецЕсли; 
	КонецЕсли;
	Возврат НовоеЗначение;

КонецФункции

Процедура КнопкаОКНажатие(Кнопка)
	
	ЗакрытьССохранением();

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	// http://www.hostedredmine.com/issues/884504
	ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.ПодстрокаОтбораПоПредставлению, ЭлементыФормы.ПодстрокаОтбораПоПредставлению.Значение);
	
	// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
	ЭлементыФормы.ПодстрокаОтбораПоПредставлению.Данные = "ЭлементыФормы.РедактируемыеТипы.Отбор.Представление.Значение";
	ЭлементыФормы.ПодстрокаОтбораПоПредставлению.КнопкаВыбора = Ложь;
	ЭлементыФормы.ПодстрокаОтбораПоПредставлению.КнопкаСпискаВыбора = Истина;

	ЭлементыФормы.РедактируемыеТипы.ОтборСтрок.Представление.Значение = "";
	СброситьПометкиУПомеченных();
	Если ТипЗнч(НачальноеЗначениеВыбора) = Тип("Тип") Тогда
		ВыбранныеТипы = Новый Массив();
		ВыбранныеТипы.Добавить(НачальноеЗначениеВыбора);
	ИначеЕсли ТипЗнч(НачальноеЗначениеВыбора) = Тип("ОписаниеТипов") Тогда
		ВыбранныеТипы = НачальноеЗначениеВыбора.Типы();
	Иначе
		ВыбранныеТипы = Новый Массив();
	КонецЕсли; 
	ЭлементыФормы.РазрешитьСоставнойТип.Доступность = МножественныйВыбор;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.УстановитьФлажки.Доступность = МножественныйВыбор;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.СнятьФлажки.Доступность = МножественныйВыбор;
	Если МножественныйВыбор Тогда
		ЭлементыФормы.РедактируемыеТипы.РежимВыделения = РежимВыделенияТабличногоПоля.Множественный;
		РазрешитьСоставнойТип = Истина;
		Если ВыбранныеТипы.Количество() > 0 Тогда
			КоманднаяПанельТиповТолькоВыбранные(ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные);
			Если ВыбранныеТипы.Количество() = 1 Тогда
				РазрешитьСоставнойТип = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	РедактируемыеТипы.Загрузить(мПлатформа.ТаблицаРедактируемыхТиповИзОписанияТипов(ОграничениеТипа));
	ЭлементыФормы.ПанельКвалификаторов.Доступность = МножественныйВыбор;
	Если МножественныйВыбор Тогда
		ЭлементыФормы.КоманднаяПанельТипов.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ЗначениеИзСтроки);
		ЭлементыФормы.КоманднаяПанельТипов.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ЗначениеИзБуфера);
	КонецЕсли; 
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.УстановитьФлажки.Доступность = РазрешитьСоставнойТип;

	Если МножественныйВыбор Тогда
		ЗагрузитьОписаниеТипов(НачальноеЗначениеВыбора);
	КонецЕсли; 
	ЗагрузитьТипы(ВыбранныеТипы, НачальноеЗначениеВыбора);
	Если Не ТолькоПросмотр Тогда
		ЭлементыФормы.ОпределяемыйТип.Доступность = МножественныйВыбор; // Даже без выполнения этой строки поле остается почему то недоступным при открытии формы с ТолькоПросмотр=Да
	КонецЕсли;
	ЭлементыФормы.ЭтоСсылкаНаОпределяемыйТип.Доступность = МножественныйВыбор;
	Если ирКэш.НомерВерсииПлатформыЛкс() > 803001 Тогда
		ИмяОпределяемогоТипа = ирОбщий.ИмяОпределяемогоТипаИзОписанияТиповЛкс(НачальноеЗначениеВыбора);
		Если ЗначениеЗаполнено(ИмяОпределяемогоТипа) Тогда
			МассивМД = Новый Массив;
			МассивМД.Добавить(Метаданные.ОпределяемыеТипы[ИмяОпределяемогоТипа]);
		Иначе
			МассивМД = Метаданные.ОпределяемыеТипы;
		КонецЕсли; 
		Для Каждого ОбъектМД Из МассивМД Цикл
			Если НачальноеЗначениеВыбора = ОбъектМД.Тип Тогда
				ЭтаФорма.ОпределяемыйТип = ОбъектМД.Имя;
				ЭтаФорма.ЭтоСсылкаНаОпределяемыйТип = ЗначениеЗаполнено(ИмяОпределяемогоТипа);
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	ЭлементыФормы.РедактируемыеТипы.ОтборСтрок.Пометка.Значение = Истина;
		
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ПоследниеВыбранные);

	// Если у формы установить ТолькоПросмотр, то перестает редактироваться поле отбора по подстроке из-за связи с данными основного объекта
	ЭлементыФормы.РедактируемыеТипы.Колонки.Пометка.ТолькоПросмотр = ТолькоПросмотр; 
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = Не ТолькоПросмотр;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.УстановитьФлажки.Доступность = Не ТолькоПросмотр;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.СнятьФлажки.Доступность = Не ТолькоПросмотр;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ПоследниеВыбранные.Доступность = Не ТолькоПросмотр;
	Для Каждого ЭлементФормы Из ЭлементыФормы Цикл
		Попытка
			ИзменяетДанные = ЭлементФормы.ИзменяетДанные;
		Исключение
			Продолжить;
		КонецПопытки;
		Если ИзменяетДанные Тогда 
			Попытка
				ЭлементФормы.ТолькоПросмотр = ЭлементФормы.ТолькоПросмотр Или ТолькоПросмотр;
			Исключение
			КонецПопытки;
			Попытка
				ЭлементФормы.Доступность = ЭлементФормы.Доступность И Не ТолькоПросмотр;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	ЭтаФорма.ТолькоПросмотр = Ложь;
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура ЗагрузитьТипы(ВыбранныеТипы, МоноТип = Неопределено)
	
	Для Каждого ВыбранныйТип Из ВыбранныеТипы Цикл
		Если ТипЗнч(МоноТип) = Тип("Тип") Тогда
			Если ВыбранныйТип = Тип("Неопределено") Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		ТипXML = СериализаторXDTO.XMLТип(ВыбранныйТип);
		Если ТипXML = Неопределено Тогда
			ТекстСообщения = "Для типа """ + ВыбранныйТип + """ не предусмотрена сериализация";
			//ВызватьИсключение ТекстСообщения;
			ирОбщий.СообщитьЛкс(ТекстСообщения);
			Продолжить;
		КонецЕсли; 
		ЭлементСписка = РедактируемыеТипы.Найти(ТипXML.ИмяТипа, "Имя");
		Если ЭлементСписка = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		ЭлементСписка.Пометка = Истина;
		Если Не МножественныйВыбор Тогда
			ЭлементыФормы.РедактируемыеТипы.ТекущаяСтрока = ЭлементСписка;
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура ЗагрузитьОписаниеТипов(ОписаниеТипов)
	
	#Если Сервер И Не Сервер Тогда
		ОписаниеТипов = Новый ОписаниеТипов;
	#КонецЕсли
	Если ОписаниеТипов.СодержитТип(Тип("Строка")) Тогда
		Квалификаторы = ОписаниеТипов.КвалификаторыСтроки;
		ЭтаФорма.ДлинаСтроки = Квалификаторы.Длина;
		ЭтаФорма.Фиксированная = Квалификаторы.ДопустимаяДлина = ДопустимаяДлина.Фиксированная;
		ЭтаФорма.Неограниченная = ДлинаСтроки = 0;
	КонецЕсли; 
	Если ОписаниеТипов.СодержитТип(Тип("Число")) Тогда
		Квалификаторы = ОписаниеТипов.КвалификаторыЧисла;
		ЭтаФорма.Разрядность = Квалификаторы.Разрядность;
		ЭтаФорма.РазрядностьДробнойЧасти = Квалификаторы.РазрядностьДробнойЧасти;
		ЭтаФорма.Неотрицательное = Квалификаторы.ДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный;
	КонецЕсли; 
	Если ОписаниеТипов.СодержитТип(Тип("Дата")) Тогда
		Квалификаторы = ОписаниеТипов.КвалификаторыДаты;
		ЭтаФорма.СоставДаты = Квалификаторы.ЧастиДаты;
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельТиповТолькоВыбранные(Кнопка = Неопределено, НовыйРежим = Неопределено)
	
	Если НовыйРежим = Неопределено Тогда
		НовыйРежим = Не Кнопка.Пометка;
	КонецЕсли; 
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные.Пометка = НовыйРежим;
	ЭлементыФормы.РедактируемыеТипы.ОтборСтрок.Пометка.Использование = НовыйРежим;
	
КонецПроцедуры

Процедура ТаблицаТиповПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	//Попытка
	//	// В некоторых случаях долго выполняется. Поддержка системы 2iS
	//	ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(Вычислить("ПолучитьНастройкуКартинки(глПолучитьПиктограммуСсылочногоОбъекта(ПолучитьСсылкуТипа(ДанныеСтроки)))"));
	//Исключение
	//КонецПопытки;
	Если Ложь
		Или ОформлениеСтроки.Ячейки.Представление.Картинка.Вид = ВидКартинки.Пустая 
	Тогда
		ОформлениеСтроки.Ячейки.Представление.ОтображатьКартинку = Истина;
		XMLТип = Новый ТипДанныхXML(ДанныеСтроки.Имя, ДанныеСтроки.URIПространстваИмен);
		Тип = СериализаторXDTO.ИзXMLТипа(XMLТип);
		Если Тип <> Неопределено Тогда
			КартинкаТипа = ирОбщий.КартинкаТипаЛкс(Тип);
		КонецЕсли; 
		Если КартинкаТипа <> Неопределено И КартинкаТипа.Вид <> ВидКартинки.Пустая Тогда
			ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(КартинкаТипа);
		Иначе
			ОформлениеСтроки.Ячейки.Представление.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               - <Тип.Вид> - <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  - <Тип.Вид> - <описание значения>
//                 <продолжение описания значения>.
//
Функция ОпределитьТекущуюСтроку()


	
КонецФункции // ОпределитьТекущуюСтроку()

Процедура КоманднаяПанельДереваСправка(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.РедактируемыеТипы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТипXML = Новый ТипДанныхXML(ТекущаяСтрока.Имя, ТекущаяСтрока.URIПространстваИмен);
	Тип = СериализаторXDTO.ИзXMLТипа(ТипXML);
	ирОбщий.ОткрытьОписаниеТипаПоТипуЛкс(Тип, ЭтаФорма);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма, Отказ);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗакрытьССохранением();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьФильтрНажатие(Элемент)
	
	ЭлементыФормы.РедактируемыеТипы.ОтборСтрок.Имя.Значение = "";
	
КонецПроцедуры

Процедура СброситьПометкиУПомеченных(ВременнаяТаблица = Неопределено, КромеТекущейСтроки = Ложь)

	Если ВременнаяТаблица = Неопределено Тогда
		ВременнаяТаблица = ПомеченныеСтрокиТаблицы();
	КонецЕсли;
	Признак = Ложь;
	Для каждого ВременнаяСтрока Из ВременнаяТаблица Цикл
		СтрокаТипа = РедактируемыеТипы.Найти(ВременнаяСтрока.Имя);
		Если КромеТекущейСтроки И СтрокаТипа = ЭлементыФормы.РедактируемыеТипы.ТекущаяСтрока Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаТипа.Пометка = Признак;
	КонецЦикла;
	ПодключитьОбработчикОжидания("ОбновитьСтроки", 0.1, Истина);

КонецПроцедуры

Процедура ОбновитьСтроки()
	
	// Антибаг платформы 8.2.15. Непомеченные строки лишались текста в колонке "Представление" при выводе строки
	// http://partners.v8.1c.ru/forum/thread.jsp?id=1016721#1016721
	ЭлементыФормы.РедактируемыеТипы.ОбновитьСтроки();

КонецПроцедуры

Процедура РазрешитьСоставнойТипПриИзменении(Элемент)
	
	Если Не РазрешитьСоставнойТип Тогда
		ВременнаяТаблица = ПомеченныеСтрокиТаблицы();
		Если ВременнаяТаблица.Количество() > 1 Тогда
			ВременнаяТаблица.Удалить(0);
			СброситьПометкиУПомеченных(ВременнаяТаблица);
		КонецЕсли;
	КонецЕсли;
	ОтключитьОтборТолькоВыбранные();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ТаблицаТиповВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность И РежимВыбора Тогда
		УстановитьПометкуВТекущейСтроке();
		Если ЗакрыватьПриВыборе Тогда
			ЗакрытьССохранением();
		Иначе
			ВыбранныеСтроки = Новый Массив;
			ВыбранныеСтроки.Добавить(Элемент.ТекущаяСтрока);
			НовоеЗначение = ПолучитьЗначениеВыбора(ВыбранныеСтроки);
			ОповеститьОВыборе(НовоеЗначение);
		КонецЕсли; 
	Иначе
		КоманднаяПанельТиповОткрытьОбъектМетаданных();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолеВвода1ПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ПрименитьФильтрПоПодстрокеБезСохранения();
	
КонецПроцедуры

Процедура ПрименитьФильтрПоПодстрокеБезСохранения()
	
	ЭлементОтбораПредставление = ЭлементыФормы.РедактируемыеТипы.ОтборСтрок.Представление;
	ЭлементОтбораПредставление.ВидСравнения = ВидСравнения.Содержит;
	ЭлементОтбораПредставление.Использование = Истина; 
	ОтключитьОтборТолькоВыбранные();

КонецПроцедуры

Процедура ОтключитьОтборТолькоВыбранные()
	
	КнопкаФильтра = ЭтаФорма.ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные;
	Если КнопкаФильтра.Пометка Тогда
		КоманднаяПанельТиповТолькоВыбранные(ЭтаФорма.ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные);
	КонецЕсли;

КонецПроцедуры

Процедура ПолеВвода1НачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицаТиповПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Истина
		И Элемент.ТекущиеДанные <> Неопределено
		И (Ложь
			Или ирОбщий.СтрокиРавныЛкс(Элемент.ТекущиеДанные.Имя, "string")
			Или ирОбщий.СтрокиРавныЛкс(Элемент.ТекущиеДанные.Имя, "dateTime")
			Или ирОбщий.СтрокиРавныЛкс(Элемент.ТекущиеДанные.Имя, "decimal"))
	Тогда
		ИмяСтраницы = Элемент.ТекущиеДанные.Имя;
		ЭлементыФормы.ПанельКвалификаторов.ТекущаяСтраница = ЭлементыФормы.ПанельКвалификаторов.Страницы[ИмяСтраницы];
		ЭлементыФормы.ПанельКвалификаторов.Видимость = Истина;
	Иначе
		ЭлементыФормы.ПанельКвалификаторов.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура НеограниченнаяПриИзменении(Элемент)
	
	Если Элемент.Значение Тогда
		ЭтаФорма.ДлинаСтроки = 0;
	КонецЕсли; 
	НастроитьЭлементыФормы();
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.ДлинаСтроки.Доступность = Не Неограниченная;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.УстановитьФлажки.Доступность = РазрешитьСоставнойТип;

КонецПроцедуры

Процедура СоставДатыПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();

КонецПроцедуры

Процедура УстановитьПометкуВТекущейСтроке(НоваяПометка = Истина)

	ирОбщий.ТабличноеПоле_ИнтерактивноУстановитьПометкуТекущейСтрокиЛкс(ЭлементыФормы.РедактируемыеТипы,, НоваяПометка);

КонецПроцедуры

Процедура РазрядностьПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура РазрядностьДробнойЧастиПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();

КонецПроцедуры

Процедура НеотрицательноеПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура ДлинаСтрокиПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура ФиксированнаяПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура КоманднаяПанельТиповОткрыть(Кнопка)
	
	ТабличноеПоле = ЭлементыФормы.РедактируемыеТипы;
	ДанныеСтроки = ТабличноеПоле.ТекущаяСтрока;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОбъектМД = ОбъектМДСтрокиТипа(ДанныеСтроки);
	Если ОбъектМД <> Неопределено Тогда
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(ОбъектМД);
	КонецЕсли; 
	
КонецПроцедуры

Функция ОбъектМДСтрокиТипа(Знач ДанныеСтроки)
	
	ИмяТипа = ДанныеСтроки.Имя;
	Попытка
		Тип = Тип(ИмяТипа);
	Исключение
		Возврат Неопределено;
	КонецПопытки; 
	ОбъектМД = Метаданные.НайтиПоТипу(Тип);
	Возврат ОбъектМД;

КонецФункции

Процедура ПолеВвода1АвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст);
	ПрименитьФильтрПоПодстрокеБезСохранения();

КонецПроцедуры

Процедура ПолеВвода1Очистка(Элемент, СтандартнаяОбработка)
	
	Элемент.Значение = ""; // Меняем Неопределено на пустую строку
	ПрименитьФильтрПоПодстрокеБезСохранения();
	
КонецПроцедуры

Процедура КоманднаяПанельТиповОткрытьОбъектМетаданных(Кнопка = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.РедактируемыеТипы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Или Найти(ТекущаяСтрока.Имя, ".") = 0 Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(Метаданные.НайтиПоТипу(Тип(ТекущаяСтрока.Имя)));
	
КонецПроцедуры

Процедура КоманднаяПанельТиповИзXML(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, Истина,, "Введите текст XML сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли; 
	Объект = ирОбщий.ОбъектИзСтрокиXMLЛкс(Текст);
	Если Объект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПроверитьВыбранноеЗначение(Объект);
	
КонецПроцедуры

Процедура КоманднаяПанельТиповИзJSON(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, Истина,, "Введите текст JSON сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Чтение = ирОбщий.МойЧтениеJSON();
	#Если Сервер И Не Сервер Тогда
		Чтение = Новый ЧтениеJSON;
	#КонецЕсли
	Чтение.УстановитьСтроку(Текст);
	Попытка
		Объект = СериализаторXDTO.ПрочитатьJSON(Чтение);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	ПроверитьВыбранноеЗначение(Объект);
	
КонецПроцедуры

Процедура КоманднаяПанельТиповИзВнутр(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, Истина,, "Введите текст Внутр сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Попытка
		Объект = ЗначениеИзСтрокиВнутр(Текст);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	ПроверитьВыбранноеЗначение(Объект);
	
КонецПроцедуры

Процедура ПроверитьВыбранноеЗначение(Объект)
	
	ХТип = СериализаторXDTO.XMLТипЗнч(Объект);
	СтрокаТипа = РедактируемыеТипы.Найти(ХТип.ИмяТипа, "Имя");
	Если Истина
		И ОграничениеТипа.Типы().Количество() > 0
		И СтрокаТипа = Неопределено 
	Тогда
		Сообщить("Десериализован объект недопустимого для приемника типа (" + ТипЗнч(Объект) + ")");
	Иначе
		Если СтрокаТипа <> Неопределено Тогда
			ЭлементыФормы.РедактируемыеТипы.ТекущаяСтрока = СтрокаТипа;
		КонецЕсли; 
		ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Объект);
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельТиповИзJSONВСтруктуру(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, Истина,, "Введите текст JSON сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Чтение = ирОбщий.МойЧтениеJSON();
	#Если Сервер И Не Сервер Тогда
		Чтение = Новый ЧтениеJSON;
	#КонецЕсли
	Чтение.УстановитьСтроку(Текст);
	Попытка
		Объект = Вычислить("ПрочитатьJSON(Чтение)");
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	ПроверитьВыбранноеЗначение(Объект);
	
КонецПроцедуры

Процедура КоманднаяПанельТиповИзJSONВСоответствие(Кнопка)
	
	Текст = "";
	ирОбщий.ОткрытьЗначениеЛкс(Текст, Истина,, "Введите текст JSON сериализованного объекта");
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	Чтение = ирОбщий.МойЧтениеJSON();
	#Если Сервер И Не Сервер Тогда
		Чтение = Новый ЧтениеJSON;
	#КонецЕсли
	Чтение.УстановитьСтроку(Текст);
	Попытка
		Объект = Вычислить("ПрочитатьJSON(Чтение, Истина)");
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	ПроверитьВыбранноеЗначение(Объект);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.РедактируемыеТипы, Метаданные().ТабличныеЧасти.РедактируемыеТипы.Реквизиты.Имя.Имя, Кнопка);
	
КонецФункции

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КоманднаяПанельТиповНавигационнаяСсылка(Кнопка)
	
	Текст = "";
	ТекстИзБуфера = ирОбщий.ТекстИзБуфераОбменаОСЛкс();
	Если ЗначениеЗаполнено(ирОбщий.НавигационнаяСсылкаВЗначениеЛкс(ТекстИзБуфера)) Тогда
		Текст = ТекстИзБуфера;
	КонецЕсли;
	ВвестиСтроку(Текст, "Введите навигационную ссылку");
	Объект = ирОбщий.НавигационнаяСсылкаВЗначениеЛкс(Текст);
	Если Не ЗначениеЗаполнено(Объект) Тогда
		Возврат;
	КонецЕсли; 
	ПроверитьВыбранноеЗначение(Объект);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТаблицаРедактируемыхТиповПометкаПриИзменении(Элемент = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.РедактируемыеТипы.ТекущаяСтрока;
	НоваяПометка = ТекущаяСтрока.Пометка;
	Если Не РазрешитьСоставнойТип И НоваяПометка Тогда
		СброситьПометкиУПомеченных(, Истина);
	КонецЕсли;
	ЭтаФорма.ОпределяемыйТип = Неопределено;
	
КонецПроцедуры

Процедура ТаблицаРедактируемыхТиповПриИзмененииФлажка(Элемент, Колонка)
	
	//// https://www.hostedredmine.com/issues/923113 Временно отключаем возможный отбор "Имя в большом списке",
	//// чтобы при обработке изменения флажка он не давал большие задержки 
	//// Опыт использования показал неприятные визуальные эффекты.
	//ЭлементОтбораИмя = ЭлементыФормы.РедактируемыеТипы.ОтборСтрок.Имя;
	//СтароеИспользование = ЭлементОтбораИмя.Использование;
	//ЭлементОтбораИмя.Использование = Ложь;
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка, ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные);
	//ЭлементОтбораИмя.Использование = СтароеИспользование;
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОпределяемыйТипНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ирКэш.НомерВерсииПлатформыЛкс() < 803001 Тогда
		Возврат;
	КонецЕсли; 
	СписокВыбора = Новый СписокЗначений;
	Для Каждого ОбъектМД Из Метаданные.ОпределяемыеТипы Цикл
		#Если Сервер И Не Сервер Тогда
			ОбъектМД = Метаданные.ОпределяемыеТипы.ОпределяемыйТип1;
		#КонецЕсли
		НовыйЭлемент = СписокВыбора.Добавить(ОбъектМД.Имя, ОбъектМД.Представление());
		Если ОбъектМД.Имя = Элемент.Значение Тогда
			НачальныйВыбор = НовыйЭлемент;
		КонецЕсли; 
	КонецЦикла;
	РезультатВыбора = ирОбщий.ВыбратьЭлементСпискаЗначенийЛкс(СписокВыбора, НачальныйВыбор, Истина, "Выберите определяемый тип");
	Если РезультатВыбора <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, РезультатВыбора.Значение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределяемыйТипНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОпределяемыйТипПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	Если Не ЗначениеЗаполнено(ОпределяемыйТип) Тогда
		Возврат;
	КонецЕсли; 
	ОбъектМД = Метаданные.ОпределяемыеТипы.Найти(ОпределяемыйТип);
	Если ОбъектМД = Неопределено Тогда
		ОпределяемыйТип = "";
		Возврат;
	КонецЕсли; 
	СброситьПометкиУПомеченных();
	ОписаниеТипов = ОбъектМД.Тип;
	#Если Сервер И Не Сервер Тогда
		ОписаниеТипов = Новый ОписаниеТипов;
	#КонецЕсли
	ЗагрузитьОписаниеТипов(ОписаниеТипов);
	ЗагрузитьТипы(ОписаниеТипов.Типы());
	КоманднаяПанельТиповТолькоВыбранные(, Истина);

КонецПроцедуры

Процедура КоманднаяПанельТиповЗначениеИзБуфера(Кнопка)
	
	Объект = ирОбщий.ЗначениеИзБуфераОбменаЛкс();
	Если Объект <> Неопределено Тогда
		ПроверитьВыбранноеЗначение(Объект);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельТиповАнализПравДоступа(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
		ОписаниеТипов = Новый ОписаниеТипов;
	#КонецЕсли
	СписокПолныхИменМД = Новый Массив;
	Для Каждого СтрокаТипа Из ЭлементыФормы.РедактируемыеТипы.ВыделенныеСтроки Цикл
		ОбъектМДТипа = ОбъектМДСтрокиТипа(СтрокаТипа);
		Если ОбъектМДТипа <> Неопределено Тогда
			СписокПолныхИменМД.Добавить(ОбъектМДТипа.ПолноеИмя());
		КонецЕсли;
	КонецЦикла;
	Если СписокПолныхИменМД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Форма = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма");
	Форма.ОбъектМетаданных = СписокПолныхИменМД[0];
	Форма.ПараметрКлючВарианта = "ПоМетаданным";
	Форма.ВычислятьФункциональныеОпции = Истина;
	Форма.Открыть();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборРедактируемыхТипов");

СписокВыбора = ЭлементыФормы.СоставДаты.СписокВыбора;
СписокВыбора.Добавить(ЧастиДаты.Время);
СписокВыбора.Добавить(ЧастиДаты.Дата);
СписокВыбора.Добавить(ЧастиДаты.ДатаВремя);
СоставДаты = ЧастиДаты.ДатаВремя;
