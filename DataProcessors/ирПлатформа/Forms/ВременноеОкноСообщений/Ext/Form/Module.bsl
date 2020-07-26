﻿// http://www.hostedredmine.com/issues/882395

Функция ВывестиСообщение(ТекстСообщения) Экспорт 
	ЭлементыФормы.Текст.Видимость = Истина;
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если Ложь
		Или ТекущаяДата() - ДатаНачалаПотока > 2 
		Или ирКэш.НомерВерсииПлатформыЛкс() >= 803015 И мПлатформа.СчетчикМодальныхФорм > 0 // http://www.hostedredmine.com/issues/882442
	Тогда
		Открыть();
		//ирОбщий.УстановитьПрикреплениеФормыВУправляемомПриложенииЛкс(ЭтаФорма); // Не работает
		//Активизировать(); // Не работает
	КонецЕсли; 
	Если ирКэш.НомерВерсииПлатформыЛкс() < 803015 Или мПлатформа.СчетчикМодальныхФорм = 0 Тогда
		ПодключитьОбработчикОжидания("ОчиститьТекстОтложенно", 0.1, Истина);
	КонецЕсли; 
	ТекстовыйДокумент = ЭлементыФормы.Текст;
	НовыйТекст = ТекстСообщения;
	Текст = ТекстовыйДокумент.ПолучитьТекст();
	Если ЗначениеЗаполнено(Текст) Тогда
		НовыйТекст = Текст + Символы.ПС + НовыйТекст;
	КонецЕсли; 
	ТекстовыйДокумент.УстановитьТекст(НовыйТекст);
	СделанаОбрезка = Ложь;
	Пока ТекстовыйДокумент.КоличествоСтрок() > 30 Цикл
		ТекстовыйДокумент.УдалитьСтроку(1);
		СделанаОбрезка = Истина;
	КонецЦикла; 
	Если СделанаОбрезка Тогда
		ТекстовыйДокумент.ВставитьСтроку(1, "...");
	КонецЕсли; 
	НомерСтроки = ТекстовыйДокумент.КоличествоСтрок();
	Если ТекущаяДата() - ПоследнееОбновлениеОтображения > 0 Тогда
		ЭтаФорма.ПоследнееОбновлениеОтображения = ТекущаяДата();
		ЭлементыФормы.Текст.УстановитьГраницыВыделения(НомерСтроки, 1, НомерСтроки, 1);
	КонецЕсли; 
КонецФункции

Процедура УстановитьДатуНачалаПотока()
	ЭтаФорма.ДатаНачалаПотока = ТекущаяДата();
КонецПроцедуры

Процедура ОчиститьТекстОтложенно() Экспорт 
	ЭлементыФормы.Текст.Видимость = Ложь;
	ЭлементыФормы.Текст.УстановитьТекст("");
КонецПроцедуры

Процедура ПриЗакрытии()
	ЭлементыФормы.Текст.УстановитьТекст("");
КонецПроцедуры

УстановитьДатуНачалаПотока();
ПодключитьОбработчикОжидания("УстановитьДатуНачалаПотока", 1);

