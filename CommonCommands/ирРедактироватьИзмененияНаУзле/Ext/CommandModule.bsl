﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна в вебклиенте");
	#ИначеЕсли ТонкийКлиент Тогда
		ОткрытьФорму("Обработка.ирПортативный.Форма.ЗапускСеансаУправляемая");
	#Иначе
		Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторИзмененийНаУзлах.Форма");
		Форма.ПараметрУзелОбмена = ПараметрКоманды;
		Форма.Открыть();
	#КонецЕсли 
	
КонецПроцедуры
