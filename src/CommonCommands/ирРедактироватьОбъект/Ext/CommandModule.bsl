﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна в вебклиенте");
	#ИначеЕсли ТонкийКлиент Тогда
		ОткрытьФорму("Обработка.ирПортативный.Форма.ЗапускСеансаУправляемая");
	#Иначе
		ирКлиент.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ПараметрКоманды);
	#КонецЕсли 
	
КонецПроцедуры
