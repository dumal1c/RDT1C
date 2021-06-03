﻿Процедура ДобавляемоеСвойствоПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ДобавляемоеСвойство) Тогда
		Возврат;
	КонецЕсли; 
	СтрокаСвойства = ДобавитьДопСвойствоНаФорму(ДобавляемоеСвойство);
	ЭлементыФормы.ДополнительныеСвойства.ТекущаяСтрока = ирОбщий.ИдентификаторСтрокиТабличногоПоляЛкс(СтрокаСвойства);
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ДобавляемоеСвойствоНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ДополнительныеСвойстваВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ДанныеСтроки = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.ДополнительныеСвойства);
	Если ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ДанныеСтроки.РасширенноеЗначение) Тогда 
		ДополнительныеСвойстваЗначениеПриИзменении();
	КонецЕсли; 

КонецПроцедуры

Процедура ДополнительныеСвойстваПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДополнительныеСвойстваЗначениеПриИзменении(Элемент = Неопределено)
	
	ТекущиеДанные = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.ДополнительныеСвойства);
	ТекущиеДанные.РасширенноеЗначение = ТекущиеДанные.Значение;
	ОбновитьТипЗначенияВСтрокеСвойства();

КонецПроцедуры

Процедура ОбновитьТипЗначенияВСтрокеСвойства(Знач СтрокаСвойства = Неопределено)
	
	СтрокаСвойства = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ЭлементыФормы.ДополнительныеСвойства, СтрокаСвойства);
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаСвойства, "РасширенноеЗначение");

КонецПроцедуры

Процедура ДополнительныеСвойстваЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ЗначениеИзменено = ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.ДополнительныеСвойства, СтандартнаяОбработка,, Истина);
	Если ЗначениеИзменено Тогда
		ДополнительныеСвойстваЗначениеПриИзменении();
	КонецЕсли; 
	
КонецПроцедуры

Функция ДобавитьДопСвойствоНаФорму(Знач ИмяСвойства, Знач ЗначениеСвойства = Неопределено)
	
	СтрокаСвойства = ДополнительныеСвойства.НайтиСтроки(Новый Структура("НИмя", НРег(ИмяСвойства)));
	Если СтрокаСвойства.Количество() = 0 Тогда
		СтрокаСвойства = ДополнительныеСвойства.Добавить();
		СтрокаСвойства.Имя = ИмяСвойства; 
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаСвойства);
	Иначе
		СтрокаСвойства = СтрокаСвойства[0];
	КонецЕсли; 
	СтрокаСвойства.Значение = ЗначениеСвойства;
	СтрокаСвойства.РасширенноеЗначение = ЗначениеСвойства;
	ОбновитьТипЗначенияВСтрокеСвойства(СтрокаСвойства);
	ДополнительныеСвойства.Сортировать("Имя");
	Возврат СтрокаСвойства;

КонецФункции

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ТекущиеПараметры = ирКэш.ПараметрыЗаписиОбъектовЛкс();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ТекущиеПараметры,, "ДополнительныеСвойства");
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ТекущиеПараметры.ДополнительныеСвойства, ДополнительныеСвойства);
	Если ПараметрТолькоОбъектыНаСервере Тогда
		ЭлементыФормы.ОтключатьКонтрольЗаписи.Видимость = Ложь;
		ЭлементыФормы.ОтключатьЗаписьВерсии.Видимость = Ложь;
		ЭлементыФормы.БезАвторегистрацииИзменений.Видимость = Ложь;
		ЭлементыФормы.РамкаГруппыДополнительныеСвойства.Видимость = Ложь;
		ЭлементыФормы.ДополнительныеСвойства.Видимость = Ложь;
		ЭлементыФормы.НадписьПомещаются.Видимость = Ложь;
		ЭлементыФормы.ДобавляемоеСвойство.Видимость = Ложь;
		ЭлементыФормы.НадписьДобавить.Видимость = Ложь;
		ЭлементыФормы.НадписьСкрыты.Видимость = Истина;
	КонецЕсли;
	Если ирКэш.НомерВерсииПлатформыЛкс() < 803015 Тогда
		ЭлементыФормы.ОтключатьЗаписьВерсии.Видимость = Ложь;
	КонецЕсли; 
	ЭлементыФормы.ПривилегированныйРежим.Доступность = ПравоДоступа("Администрирование", Метаданные);
	Если Не ЭлементыФормы.ПривилегированныйРежим.Доступность Тогда
		ЭтаФорма.ПривилегированныйРежим = Ложь;
	КонецЕсли; 
	ЭлементыФормы.НеИспользоватьИмитаторыОбъектовДанных.Видимость = Истина
		И Не ирКэш.ЛиФайловаяБазаЛкс()
		И Не ирКэш.ЛиПортативныйРежимЛкс();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	Если НеИспользоватьИмитаторыОбъектовДанных Тогда
		ЭлементыФормы.НеИспользоватьИмитаторыОбъектовДанных.ЦветТекста = WebЦвета.Красный;
	Иначе
		ЭлементыФормы.НеИспользоватьИмитаторыОбъектовДанных.ЦветТекста = Новый Цвет;
	КонецЕсли;

КонецПроцедуры

Процедура ОсновныеДействияФормыОсновныеДействияФормыПрименить(Кнопка)
	
	ТекущиеПараметры = ирКэш.ПараметрыЗаписиОбъектовЛкс();
	ЗаполнитьЗначенияСвойств(ТекущиеПараметры, ЭтаФорма); 
	ирОбщий.СохранитьЗначениеЛкс("ирПараметрыЗаписиОбъектов.БезАвторегистрацииИзменений", БезАвторегистрацииИзменений);
	ирОбщий.СохранитьЗначениеЛкс("ирПараметрыЗаписиОбъектов.ДополнительныеСвойства", ДополнительныеСвойства);
	ирОбщий.СохранитьЗначениеЛкс("ирПараметрыЗаписиОбъектов.ОбъектыНаСервере", ОбъектыНаСервере);
	ирОбщий.СохранитьЗначениеЛкс("ирПараметрыЗаписиОбъектов.НеИспользоватьИмитаторыОбъектовДанных", НеИспользоватьИмитаторыОбъектовДанных);
	ирОбщий.СохранитьЗначениеЛкс("ирПараметрыЗаписиОбъектов.ОтключатьКонтрольЗаписи", ОтключатьКонтрольЗаписи);
	ирОбщий.СохранитьЗначениеЛкс("ирПараметрыЗаписиОбъектов.ОтключатьЗаписьВерсии", ОтключатьЗаписьВерсии);
    ирОбщий.СохранитьЗначениеЛкс("ирПараметрыЗаписиОбъектов.ПривилегированныйРежим", ПривилегированныйРежим);
	Закрыть();

КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура НеИспользоватьИмитаторыОбъектовДанныхПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПараметрыЗаписиОбъектов");

ДополнительныеСвойства.Колонки.Удалить("Значение");
ДополнительныеСвойства.Колонки.Добавить("Значение", ирОбщий.ОписаниеТиповВсеРедактируемыеТипыЛкс()); // Программно нужно добавлять, чтобы все типы можно было использовать
ДополнительныеСвойства.Колонки.Добавить("РасширенноеЗначение");
