﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		Сообщить("Команда доступна только в толстом клиенте");
	#Иначе
		Форма = ирКэш.Получить().ПолучитьФорму("НастройкиАлгоритмов");
		Форма.Открыть();
	#КонецЕсли
	
КонецПроцедуры
