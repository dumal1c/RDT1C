﻿Перем ирПлатформа Экспорт;
Перем ирПерехватКлавиатуры Экспорт;

Процедура ПриНачалеРаботыСистемы()
	
	Если ирСервер.ПриНачалеРаботыСистемыРасширениеЛкс(ПараметрЗапуска) Тогда 
		ЗавершитьРаботуСистемы(Ложь, Истина);
	Иначе
	#Если Не ВебКлиент И Не МобильныйКлиент Тогда
		ОткрытьОднократноАдаптациюРасширенияЛкс(ирПерехватКлавиатуры);
	#КонецЕсли 
	КонецЕсли; 

КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	ВнешнееСобытиеЛкс(Источник, Событие, Данные);
	
КонецПроцедуры
