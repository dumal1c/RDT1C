﻿Перем АктивнаяФорма Экспорт;
Перем СобственнаяСсылка Экспорт;

Процедура ПриОткрытии()
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ОбновитьДоступныеКоманды();
	ВыбраннаяГлобальнаяКоманда = ирОбщий.ВосстановитьЗначениеЛкс("ВыбраннаяГлобальнаяКоманда");
	Если ВыбраннаяГлобальнаяКоманда <> Неопределено Тогда
		НовыйТекущийЭлемент = Команды.Найти(ВыбраннаяГлобальнаяКоманда, "Имя");
		Если НовыйТекущийЭлемент <> Неопределено Тогда
			ЭлементыФормы.Команды.ТекущаяСтрока = НовыйТекущийЭлемент;
		КонецЕсли; 
	КонецЕсли; 
	Если Команды.Количество() = 0 Тогда
		//ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ПереоткрытьОтложенно.КнопкаПоУмолчанию = Истина;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить(ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК);
		//ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ОсновныеДействияФормы; // Почему то так фокус на кнопку по умолчанию как то неполноценно устанавливается
	КонецЕсли; 
КонецПроцедуры

Процедура ОбновитьДоступныеКоманды()
	
	Если ЭлементыФормы.Команды.ТекущаяСтрока <> Неопределено Тогда
		СтараяТекущаяКоманда = ЭлементыФормы.Команды.ТекущаяСтрока.Имя;
	КонецЕсли; 
	Команды.Очистить();
	Если АктивнаяФорма = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОтложенноеВыполнение = Ложь;
	ТекущийЭлементАктивнойФормы = ирОбщий.ТекущийЭлементАктивнойФормыЛкс(АктивнаяФорма);
	Если ТекущийЭлементАктивнойФормы <> Неопределено Тогда
		ДанныеТекущегоЭлемента = ирОбщий.ДанныеЭлементаФормыЛкс(ТекущийЭлементАктивнойФормы);
	КонецЕсли;
	ТекущаяКолонка = Неопределено;
	ОбщийТипДанныхТаблицы = Неопределено;
	ПолноеИмяТаблицыБД = Неопределено;
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
	Тогда 
		ТекущаяКолонка = ирОбщий.ТекущаяКолонкаТаблицыФормыЛкс(ТекущийЭлементАктивнойФормы);
		ОбщийТипДанныхТаблицы = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ТекущийЭлементАктивнойФормы,,, ПолноеИмяТаблицыБД);
	КонецЕсли; 
	КлючТекущегоПоляЯчейки = Неопределено;
	ЕстьСсылкиВТекущемПоле = ирОбщий.СсылкиИзТекущейКолонкиВыделенныхСтрокТаблицыЛкс(АктивнаяФорма, КлючТекущегоПоляЯчейки, Ложь).Количество() > 0;
	КлючТекущейСтрокиТаблицы = Неопределено;
	ирОбщий.КлючиСтрокБДИзТаблицыФормыЛкс(АктивнаяФорма, КлючТекущейСтрокиТаблицы,, Ложь);
	ЭтоПолеВвода = Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеВвода") 
		Или (Истина
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			И ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеВвода);
	Если КлючТекущегоПоляЯчейки <> Неопределено Тогда
		Если Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеТабличногоДокумента") 
			Или ЭтоПолеВвода 
			Или (Истина
				И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
				И ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента)
		Тогда
			Если ЕстьСсылкиВТекущемПоле Тогда
				Если ЭтоПолеВвода Тогда
					Параметр = "поле";
				Иначе
					Параметр = "ячейка";
				КонецЕсли; 
				#Если Сервер И Не Сервер Тогда
					РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс";
				НоваяКоманда.Представление = "Редактировать объект";
				НоваяКоманда.Пояснение = "Открыть объект по ссылке в редакторе объекта БД (ИР)";
				НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД");
				НоваяКоманда.Порядок = 10;
				НоваяКоманда.Параметр = Параметр;
				
				#Если Сервер И Не Сервер Тогда
					ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс";
				НоваяКоманда.Представление = "Открыть объект";
				НоваяКоманда.Пояснение = "Открыть объект по ссылке в основной форме";
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("Лупа");
				НоваяКоманда.Порядок = 20;
				НоваяКоманда.Параметр = Параметр;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
		Или ЭтоПолеВвода 
	Тогда
		ЗначениеСсылки = ирОбщий.СсылкаИзБуфераОбменаЛкс();
		Если Истина
			И ЗначениеСсылки <> Неопределено
			И ОбщийТипДанныхТаблицы <> "Список" 
		Тогда
			НаименованиеКоманды = "Вставить скопированную ссылку";
			#Если Сервер И Не Сервер Тогда
				ВставитьСкопированнуюСсылкуАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ВставитьСкопированнуюСсылкуАктивнойФормыЛкс";
			НоваяКоманда.Представление = НаименованиеКоманды;
			НоваяКоманда.Пояснение = "Alt+Shift+V Вставить скопированную по Ctrl+C ссылку - " + ЗначениеСсылки;
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирВставить");
			Если ЭтоПолеВвода Тогда 
				НоваяКоманда.Параметр = "поле";
			Иначе
				НоваяКоманда.Параметр = "ячейка";
			КонецЕсли; 
			НоваяКоманда.Порядок = 25;
		КонецЕсли; 
	КонецЕсли; 
	Если ЕстьСсылкиВТекущемПоле Тогда
		Если Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеТабличногоДокумента") 
			Или (Истина
				И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
				И (Ложь
					//Или ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеВвода
					Или ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента))
		Тогда
			//Если Истина
			//	И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			//	И ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента
			//Тогда
				Параметр = "ячейка";
			//Иначе
			//	Параметр = "поле";
			//КонецЕсли; 
			#Если Сервер И Не Сервер Тогда
				ОбработатьОбъектыТекущегоПоляАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ОбработатьОбъектыТекущегоПоляАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Обработать объекты";
			НоваяКоманда.Пояснение = "Обработать выделенные объекты в подборе и обработке объектов БД (ИР)";
			НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирПодборИОбработкаОбъектов");
			НоваяКоманда.Параметр = Параметр;
			НоваяКоманда.Порядок = 30;
		КонецЕсли; 
	КонецЕсли; 
	Если КлючТекущейСтрокиТаблицы <> Неопределено Тогда
		Если Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
		Тогда
			#Если Сервер И Не Сервер Тогда
				РедактироватьОбъектСтрокиАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "РедактироватьОбъектСтрокиАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Редактировать объект";
			НоваяКоманда.Пояснение = "Открыть объект по ссылке в редакторе объекта БД (ИР)";
			НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД");
			НоваяКоманда.Параметр = "строка";
			НоваяКоманда.Порядок = 100;
			
			#Если Сервер И Не Сервер Тогда
				ОбработатьОбъектыАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ОбработатьОбъектыАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Обработать объекты";
			НоваяКоманда.Пояснение = "Обработать выделенные/отобранные объекты в подборе и обработке объектов БД (ИР)";
			НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирПодборИОбработкаОбъектов");
			НоваяКоманда.Параметр = "строка";
			НоваяКоманда.Порядок = 110;
			
			Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(КлючТекущейСтрокиТаблицы) Тогда
				НаименованиеКоманды = "Копировать ссылку";
				#Если Сервер И Не Сервер Тогда
					КопироватьСсылкуАктивнойСтрокиАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "КопироватьСсылкуАктивнойСтрокиАктивнойФормыЛкс";
				НоваяКоманда.Представление = НаименованиеКоманды;
				НоваяКоманда.Пояснение = "Копировать ссылку в буфер обмена";
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирКопировать");
				НоваяКоманда.Параметр = "строка";
				НоваяКоманда.Порядок = 120;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеТабличногоДокумента") 
		Или (Истина
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
			И ТекущийЭлементАктивнойФормы.Вид = ВидПоляФормы.ПолеТабличногоДокумента)
	Тогда
		Если Истина
			И (Ложь
				Или ОбщийТипДанныхТаблицы <> "Список"
				Или ПолноеИмяТаблицыБД <> Неопределено)
			И (Ложь
				Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
				Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле"))
		Тогда
			НаименованиеКоманды = "Различные значения колонки";
			Если ДанныеТекущегоЭлемента = Неопределено Тогда
				НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
			КонецЕсли; 
			#Если Сервер И Не Сервер Тогда
				ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс";
			НоваяКоманда.Представление = НаименованиеКоманды;
			НоваяКоманда.Пояснение = "Открыть список различных значений колонки";
			НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРазличныеЗначенияКолонки");
			НоваяКоманда.Параметр = "таблица";
			НоваяКоманда.Порядок = 200;
			Если ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") Тогда
				#Если Сервер И Не Сервер Тогда
					ОткрытьМенеджерТабличногоПоляАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "ОткрытьМенеджерТабличногоПоляАктивнойФормыЛкс";
				НоваяКоманда.Представление = "Менеджер табличного поля";
				НоваяКоманда.Пояснение = "Открыть менеджер табличного поля";
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирМенеджерТабличногоПоля");
				НоваяКоманда.Параметр = "таблица";
				НоваяКоманда.Порядок = 203;
			КонецЕсли; 
			#Если Сервер И Не Сервер Тогда
				СообщитьКоличествоСтрокАктивнойТаблицыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "СообщитьКоличествоСтрокАктивнойТаблицыЛкс";
			НоваяКоманда.Представление = "Сколько строк?";
			НоваяКоманда.Пояснение = "Сообщить сколько строк всего/отобрано/выделено";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирСуммаСообщить");
			НоваяКоманда.Параметр = "таблица";
			НоваяКоманда.Порядок = 204;
			Если Истина
				И ОбщийТипДанныхТаблицы <> "Список" 
				И ирОбщий.ЛиИнтерактивноДоступнаяКолонкаЛкс(ТекущаяКолонка) 
			Тогда
				НаименованиеКоманды = "Установить значение в колонке";
				Если ДанныеТекущегоЭлемента = Неопределено Тогда
					НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
				КонецЕсли; 
				#Если Сервер И Не Сервер Тогда
					УстановитьЗначениеВКолонкеАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "УстановитьЗначениеВКолонкеАктивнойФормыЛкс";
				НоваяКоманда.Представление = НаименованиеКоманды;
				НоваяКоманда.Пояснение = "Групповая установка значения в колонке";
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирУстановитьЗначениеВКолонке");
				НоваяКоманда.Параметр = "таблица";
				НоваяКоманда.Порядок = 205;
			КонецЕсли; 
		КонецЕсли; 
		НаименованиеКоманды = "Вывести данные";
		Параметр = "таблица";
		Если ДанныеТекущегоЭлемента = Неопределено Тогда
			НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
		ИначеЕсли Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеТабличногоДокумента")
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
		Тогда
			НаименованиеКоманды = НаименованиеКоманды + " выделенных ячеек";
			Параметр = "табличный документ";
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			ОткрытьТаблицуАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОткрытьТаблицуАктивнойФормыЛкс";
		НоваяКоманда.Представление = НаименованиеКоманды;
		НоваяКоманда.Пояснение = "Вывести данные в таблицу значений";
		НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирТаблицаЗначений");
		НоваяКоманда.Параметр = Параметр;
		НоваяКоманда.Порядок = 210;
		
		НаименованиеКоманды = "Сравнить данные";
		Если Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы")
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле")
		Тогда
			Если ДанныеТекущегоЭлемента = Неопределено Тогда
				НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
			КонецЕсли; 
			Параметр = "таблица";
		Иначе
			Параметр = "табличный документ";
		КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
			СравнитьТаблицуАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "СравнитьТаблицуАктивнойФормыЛкс";
		НоваяКоманда.Представление = НаименованиеКоманды;
		НоваяКоманда.Пояснение = "Вывести данные во 2ю из 2-х ячеек сравнения в памяти приложения, а содержимое 2й перенести в 1ю.";
		НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирСравнить");
		НоваяКоманда.Параметр = Параметр;
		НоваяКоманда.Порядок = 220;
		
		Если Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеТабличногоДокумента")
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ПолеФормы") 
		Тогда
			#Если Сервер И Не Сервер Тогда
				ОткрытьТабличныйДокументАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ОткрытьТабличныйДокументАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Открыть табличный документ";
			НоваяКоманда.Пояснение = "Открыть табличный документ в редакторе табличного документа (ИР)";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирТабличныйДокумент");
			НоваяКоманда.Параметр = "табличный документ";
			НоваяКоманда.Порядок = 225;
		КонецЕсли; 
	
		Если Ложь
			Или ОбщийТипДанныхТаблицы = "Список" И ДанныеТекущегоЭлемента <> Неопределено
			Или ОбщийТипДанныхТаблицы = "ТабличнаяЧасть"
			Или ОбщийТипДанныхТаблицы = "НаборЗаписей"
		Тогда
			#Если Сервер И Не Сервер Тогда
				ирОбщий.ОтборБезЗначенияВТекущейКолонкеАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ирОбщий.ОтборБезЗначенияВТекущейКолонкеАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Отбор без значения";
			НоваяКоманда.Пояснение = "Отбор без значения в текущей колонке";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирОтборБезЗначения");
			НоваяКоманда.Параметр = "таблица";
			НоваяКоманда.Порядок = 230;
		КонецЕсли; 
		
		Если Истина
			И ОбщийТипДанныхТаблицы = "Список" 
			И ДанныеТекущегоЭлемента <> Неопределено 
		Тогда
			#Если Сервер И Не Сервер Тогда
				НастроитьДинамическийСписокАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "НастроитьДинамическийСписокАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Настроить список";
			НоваяКоманда.Пояснение = "Редактировать пользовательские и посмотреть фиксированные настройки списка";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("НастроитьСписок");
			НоваяКоманда.Параметр = "динамический список";
			НоваяКоманда.Порядок = 240;
		КонецЕсли; 
		
		Если Истина
			И ОбщийТипДанныхТаблицы = "Список" 
			И ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПервыйФрагментЛкс(ПолноеИмяТаблицыБД)) 
		Тогда
			#Если Сервер И Не Сервер Тогда
				НайтиВыбратьСсылкуВДинамическомСпискеАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "НайтиВыбратьСсылкуВДинамическомСпискеАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Найти объект по ID";
			НоваяКоманда.Пояснение = "Найти объект по внутреннему идентификатору";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирИдентификатор");
			НоваяКоманда.Параметр = "динамический список";
			НоваяКоманда.Порядок = 250;
		КонецЕсли; 
	КонецЕсли; 
	КлючОсновногоОбъекта = ирОбщий.КлючОсновногоОбъектаУправляемойФормыЛкс(АктивнаяФорма);
	Если ирОбщий.КлючОсновногоОбъектаУправляемойФормыЛкс(АктивнаяФорма) <> Неопределено Тогда
		#Если Сервер И Не Сервер Тогда
			РедактироватьОбъектАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "РедактироватьОбъектАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Редактировать объект";
		НоваяКоманда.Пояснение = "Открыть объект по ссылке в редакторе объекта БД (ИР)";
		НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД");
		НоваяКоманда.Параметр = "форма";
		НоваяКоманда.Порядок = 300;
		
		Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(КлючОсновногоОбъекта) Тогда
			НаименованиеКоманды = "Копировать ссылку";
			#Если Сервер И Не Сервер Тогда
				КопироватьСсылкуАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "КопироватьСсылкуАктивнойФормыЛкс";
			НоваяКоманда.Представление = НаименованиеКоманды;
			НоваяКоманда.Пояснение = "Копировать ссылку в буфер обмена";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирКопировать");
			НоваяКоманда.Параметр = "форма";
			НоваяКоманда.Порядок = 305;
		КонецЕсли; 
	КонецЕсли; 
	Если ирОбщий.ЭтоУправляемаяФормаОтчетаЛкс(АктивнаяФорма, Истина) Тогда
		#Если Сервер И Не Сервер Тогда
			ОтладитьКомпоновкуДанныхАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОтладитьКомпоновкуДанныхАктивнойФормыЛкс";
		НоваяКоманда.Представление = "Отладить компоновку данных";
		НоваяКоманда.Пояснение = "Отладить схему и настройки компоновки отчета в консоли компоновки данных (ИР)";
		НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирКонсольКомпоновокДанных");
		НоваяКоманда.Параметр = "форма";
		НоваяКоманда.Порядок = 310;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ОткрытьСтруктуруАктивнойФормыЛкс();
	#КонецЕсли
	НоваяКоманда = Команды.Добавить();
	НоваяКоманда.Имя = "ОткрытьСтруктуруАктивнойФормыЛкс";
	НоваяКоманда.Представление = "Открыть структуру формы";
	НоваяКоманда.Пояснение = "";
	НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирПлатформа.Форма.СтруктураФормы");
	НоваяКоманда.Параметр = "форма";
	НоваяКоманда.Порядок = 320;
	
	Команды.Сортировать("Порядок");
	Если СтараяТекущаяКоманда <> Неопределено Тогда
		НоваяТекущаяКоманда = Команды.Найти(СтараяТекущаяКоманда, "Имя");
	КонецЕсли; 
	Если НоваяТекущаяКоманда = Неопределено Тогда
		НоваяТекущаяКоманда = Команды[0];
	КонецЕсли; 
	ЭлементыФормы.Команды.ТекущаяСтрока = НоваяТекущаяКоманда;

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	ЗакрытьФорму();
	ПараметрыВызова = Новый Структура("Форма", АктивнаяФорма);
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЭтаФорма.СобственнаяСсылка = ЭтаФорма;
		ПодключитьОбработчикОжидания("ВыполнитьКомандуОтложенно", 0.1, Истина);
	Иначе
		ирОбщий.ПодключитьГлобальныйОбработчикОжиданияСПараметрамиЛкс(ЭлементыФормы.Команды.ТекущаяСтрока.Имя, ПараметрыВызова);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыполнитьКомандуОтложенно()
	
	ЭтаФорма.СобственнаяСсылка = Неопределено;
	ПараметрыВызова = Новый Структура("Форма", АктивнаяФорма);
	Выполнить("ирПортативный." + ЭлементыФормы.Команды.ТекущаяСтрока.Имя + "(ПараметрыВызова)"); // Так окно в управляемом приложении откроется в режиме блокирования владельца
	
КонецПроцедуры

Процедура ЗакрытьФорму()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	Если ЭлементыФормы.Команды.ТекущаяСтрока <> Неопределено Тогда
		ВыбраннаяГлобальнаяКоманда = ЭлементыФормы.Команды.ТекущаяСтрока.Имя;
	КонецЕсли; 
	ирОбщий.СохранитьЗначениеЛкс("ВыбраннаяГлобальнаяКоманда", ВыбраннаяГлобальнаяКоманда);
	Закрыть(ВыбраннаяГлобальнаяКоманда);
КонецПроцедуры

Процедура КомандыВыбор(Элемент, ЭлементСписка)
	
	ОсновныеДействияФормыОК();
	
КонецПроцедуры

Процедура КомандыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	//ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.Параметр.УстановитьКартинку(ДанныеСтроки.Картинка);
	
КонецПроцедуры

Процедура КомандыПриАктивизацииСтроки(Элемент)
	
	//ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
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

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ГлобальноеМеню", Ложь);
Команды.Колонки.Добавить("Картинка");