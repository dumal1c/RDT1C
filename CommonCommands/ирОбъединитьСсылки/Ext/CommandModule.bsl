﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна в вебклиенте");
	#ИначеЕсли ТонкийКлиент Тогда
		ОткрытьФорму("Обработка.ирПортативный.Форма.ЗапускСеансаУправляемая");
	#Иначе
		ФормаОбработки = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПоискДублейИЗаменаСсылок.Форма");
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ПараметрКоманды[0]));
		ФормаОбработки.ОткрытьДляЗаменыПоСпискуСсылок(ПараметрКоманды);
	#КонецЕсли 
	
КонецПроцедуры
