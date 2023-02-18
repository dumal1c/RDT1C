﻿Перем АктивнаяФорма Экспорт;
Перем СобственнаяСсылка Экспорт;
Перем ДатаОткрытия;

Процедура ПриОткрытии()
	ирКлиент.Форма_ПриОткрытииЛкс(ЭтаФорма);
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
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Команды;
	ДатаОткрытия = ТекущаяДата();
КонецПроцедуры

Процедура ОбновитьДоступныеКоманды()
	
	Если ЭлементыФормы.Команды.ТекущаяСтрока <> Неопределено Тогда
		СтараяТекущаяКоманда = ЭлементыФормы.Команды.ТекущаяСтрока.Имя;
	КонецЕсли; 
	Команды.Очистить();
	Если АктивнаяФорма = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ирОбщий.ПервыйФрагментЛкс(АктивнаяФорма.Заголовок, ":"), ": ");
	ОтложенноеВыполнение = Ложь;
	ФормаОбщихКоманд = ирКэш.ФормаОбщихКомандЛкс();
	ОбщиеКоманды = ФормаОбщихКоманд.ЭлементыФормы.Команды.Кнопки;
	ТекущийЭлементАктивнойФормы = ирКлиент.ТекущийЭлементАктивнойФормыЛкс(АктивнаяФорма);
	Если ТекущийЭлементАктивнойФормы <> Неопределено Тогда
		ДанныеТекущегоЭлемента = ирОбщий.ДанныеЭлементаФормыЛкс(ТекущийЭлементАктивнойФормы);
	КонецЕсли;
	ТекущаяКолонка = Неопределено;
	ОбщийТипДанныхТаблицы = Неопределено;
	ПолноеИмяТаблицыБД = Неопределено;
	ЛиВыделенныхСтрокБолееОдной = Ложь;
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
	Тогда 
		ЛиВыделенныхСтрокБолееОдной = ТекущийЭлементАктивнойФормы.ВыделенныеСтроки.Количество() > 1;
		ТекущаяКолонка = ирКлиент.ТабличноеПолеТекущаяКолонкаЛкс(ТекущийЭлементАктивнойФормы);
		ОбщийТипДанныхТаблицы = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ТекущийЭлементАктивнойФормы,,, ПолноеИмяТаблицыБД);
		Если ОбщийТипДанныхТаблицы <> "Список" Тогда
			ТекущаяКолонкаДанных = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТекущийЭлементАктивнойФормы);
			Если ЗначениеЗаполнено(ТекущаяКолонкаДанных) Тогда
				ТаблицаЗначений = ирКлиент.ТаблицаИлиДеревоЗначенийИзТаблицыФормыСКоллекциейЛкс(ТекущийЭлементАктивнойФормы, Новый Массив);
				#Если Сервер И Не Сервер Тогда
					ТаблицаЗначений = Новый ТаблицаЗначений;
				#КонецЕсли
				КолонкаТаблицы = ТаблицаЗначений.Колонки.Найти(ТекущаяКолонкаДанных);
				Если КолонкаТаблицы <> Неопределено Тогда
					ОписаниеТиповКолонки = КолонкаТаблицы.ТипЗначения;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	КлючТекущегоПоляЯчейки = Неопределено;
	ЕстьСсылкиВТекущемПоле = ирКлиент.ЗначенияВыделенныхЯчеекТаблицыЛкс(АктивнаяФорма, КлючТекущегоПоляЯчейки, Ложь).Количество() > 0;
	КлючТекущейСтрокиТаблицы = Неопределено;
	ЗначениеТекущегоПоля = ирКлиент.Форма_ЗначениеТекущегоПоляЛкс(АктивнаяФорма);
	ирКлиент.КлючиСтрокБДИзТаблицыФормыЛкс(АктивнаяФорма, КлючТекущейСтрокиТаблицы,, Ложь);
	ЭтоПолеВвода = ирКлиент.ЛиПолеФормыИмеетТипЛкс(ТекущийЭлементАктивнойФормы, Тип("ПолеВвода"));
	ЭтоПолеТекста = Ложь
		Или ирКлиент.ЛиПолеФормыИмеетТипЛкс(ТекущийЭлементАктивнойФормы, Тип("ПолеТекстовогоДокумента"))
		Или ирКлиент.ЛиПолеФормыИмеетТипЛкс(ТекущийЭлементАктивнойФормы, Тип("ПолеHTMLДокумента"));
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
		Или ЭтоПолеВвода 
		Или ирКлиент.ЛиПолеФормыИмеетТипЛкс(ТекущийЭлементАктивнойФормы, Тип("ПолеТабличногоДокумента"))
	Тогда
		Если ЭтоПолеВвода Тогда
			Параметр = "поле";
		Иначе
			Параметр = "ячейка";
		КонецЕсли; 
		Если ЕстьСсылкиВТекущемПоле Тогда
			#Если Сервер И Не Сервер Тогда
				РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс";
			НоваяКоманда.Порядок = 10;
			НоваяКоманда.Параметр = Параметр;
			КнопкаОбщейКоманды = ОбщиеКоманды.РедакторОбъектаБД;
			НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
			НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
			НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
			
			Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(КлючТекущегоПоляЯчейки) Тогда
				#Если Сервер И Не Сервер Тогда
					ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс";
				НоваяКоманда.Представление = "Открыть объект данных";
				НоваяКоманда.Пояснение = "Открыть объект данных по ссылке в основной форме";
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("Лупа");
				НоваяКоманда.Порядок = 20;
				НоваяКоманда.Параметр = Параметр;
			КонецЕсли;
		//ИначеЕсли ирОбщий.ЛиКоллекцияЛкс(ЗначениеТекущегоПоля) Тогда 
		//	#Если Сервер И Не Сервер Тогда
		//		РедактироватьСписокТекущегоПоляАктивнойФормыЛкс();
		//	#КонецЕсли
		//	НоваяКоманда = Команды.Добавить();
		//	НоваяКоманда.Имя = "РедактироватьСписокТекущегоПоляАктивнойФормыЛкс";
		//	НоваяКоманда.Представление = "Редактировать список значений";
		//	НоваяКоманда.Пояснение = "Редактировать список значений в инструменте";
		//	НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирСписокЗначений");
		//	НоваяКоманда.Порядок = 20;
		//	НоваяКоманда.Параметр = Параметр;
		КонецЕсли;
	КонецЕсли;
	Если Ложь
		Или ЭтоПолеТекста
		Или ТипЗнч(ЗначениеТекущегоПоля) = Тип("Строка") И СтрДлина(ЗначениеТекущегоПоля) > 150
	Тогда
		НаименованиеКоманды = "Открыть текст";
		#Если Сервер И Не Сервер Тогда
			ОткрытьТекстАктивнойФормыЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "ОткрытьТекстАктивнойФормыЛкс";
		НоваяКоманда.Представление = НаименованиеКоманды;
		НоваяКоманда.Пояснение = "Открыть текст в редакторе текста без его возвращения в форму";
		НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирПолеТекстовогоДокумента");
		Если ЭтоПолеТекста Или ЭтоПолеВвода Тогда 
			НоваяКоманда.Параметр = "поле";
		Иначе
			НоваяКоманда.Параметр = "ячейка";
		КонецЕсли; 
		НоваяКоманда.Порядок = 23;
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
		Или ЭтоПолеВвода
	Тогда
		ЗначениеИзБуфера = ирКлиент.ЗначениеИзБуфераОбменаЛкс();
		Если Истина
			И ЗначениеИзБуфера <> Неопределено
			И ОбщийТипДанныхТаблицы <> "Список" 
			И Не ТекущийЭлементАктивнойФормы.ТолькоПросмотр
		Тогда
			НаименованиеКоманды = "Вставить скопированное значение";
			#Если Сервер И Не Сервер Тогда
				ВставитьСкопированнуюСсылкуАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ВставитьСкопированнуюСсылкуАктивнойФормыЛкс";
			НоваяКоманда.Представление = НаименованиеКоманды;
			НоваяКоманда.Пояснение = "Вставить (Alt+Shift+V) - " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеИзБуфера,, Истина);
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирВставить");
			Если ЭтоПолеВвода Тогда 
				НоваяКоманда.Параметр = "поле";
			Иначе
				НоваяКоманда.Параметр = "ячейка";
			КонецЕсли; 
			НоваяКоманда.Порядок = 25;
		КонецЕсли; 
		Если ЗначениеИзБуфера <> Неопределено И ТипЗнч(ЗначениеИзБуфера) = ТипЗнч(КлючТекущегоПоляЯчейки) Тогда
			НаименованиеКоманды = "Сравнить скопированное значение";
			#Если Сервер И Не Сервер Тогда
				СравнитьСкопированнуюСсылкуСЯчейкойАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "СравнитьСкопированнуюСсылкуСЯчейкойАктивнойФормыЛкс";
			НоваяКоманда.Представление = НаименованиеКоманды;
			НоваяКоманда.Пояснение = "Сравнить с - " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеИзБуфера,, Истина);
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирСравнениеОбъектов");
			НоваяКоманда.Параметр = "ячейка";
			НоваяКоманда.Порядок = 27;
		КонецЕсли; 
	КонецЕсли; 
	Если Истина
		И ЕстьСсылкиВТекущемПоле 
		И (Ложь
			Или ЛиВыделенныхСтрокБолееОдной
			//Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(КлючТекущегоПоляЯчейки)
			)
	Тогда
		Если Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
			Или ирКлиент.ЛиПолеФормыИмеетТипЛкс(ТекущийЭлементАктивнойФормы, Тип("ПолеТабличногоДокумента"))
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
			НоваяКоманда.Порядок = 30;
			НоваяКоманда.Параметр = Параметр;
			КнопкаОбщейКоманды = ОбщиеКоманды.КонсольОбработки;
			НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
			НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
			НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
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
			НоваяКоманда.Пояснение = "Открыть редактор объекта БД строки";
			НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирРедакторОбъектаБД");
			НоваяКоманда.Параметр = "строка";
			НоваяКоманда.Порядок = 100;
			
			Если ЛиВыделенныхСтрокБолееОдной Тогда
				#Если Сервер И Не Сервер Тогда
					ОбработатьОбъектыАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "ОбработатьОбъектыАктивнойФормыЛкс";
				НоваяКоманда.Порядок = 110;
				НоваяКоманда.Параметр = "строка";
				КнопкаОбщейКоманды = ОбщиеКоманды.ОбработатьОбъекты;
				НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
				НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
				НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
			КонецЕсли;
			
			Если ирОбщий.ЛиСсылкаНаОбъектБДЛкс(КлючТекущейСтрокиТаблицы, Ложь) Тогда
				НаименованиеКоманды = "Копировать ссылки";
				#Если Сервер И Не Сервер Тогда
					КопироватьСсылкуАктивнойСтрокиАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "КопироватьСсылкуАктивнойСтрокиАктивнойФормыЛкс";
				НоваяКоманда.Представление = НаименованиеКоманды;
				НоваяКоманда.Пояснение = "Копировать ссылки в буфер обмена и сравнения";
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирКопировать");
				НоваяКоманда.Параметр = "строка";
				НоваяКоманда.Порядок = 120;
			КонецЕсли; 
			Если ТипЗнч(ЗначениеИзБуфера) = ТипЗнч(КлючТекущейСтрокиТаблицы) Тогда
				НаименованиеКоманды = "Сравнить скопированное значение";
				#Если Сервер И Не Сервер Тогда
					СравнитьСкопированнуюСсылкуСКлючомСтрокиАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "СравнитьСкопированнуюСсылкуСКлючомСтрокиАктивнойФормыЛкс";
				НоваяКоманда.Представление = НаименованиеКоманды;
				НоваяКоманда.Пояснение = "Сравнить с - " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеИзБуфера,, Истина);
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирСравнениеОбъектов");
				НоваяКоманда.Параметр = "строка";
				НоваяКоманда.Порядок = 140;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если Ложь
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
		Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") 
		Или ирКлиент.ЛиПолеФормыИмеетТипЛкс(ТекущийЭлементАктивнойФормы, Тип("ПолеТабличногоДокумента"))
	Тогда
		Если Истина
			И (Ложь
				Или ОбщийТипДанныхТаблицы <> "Список"
				Или ПолноеИмяТаблицыБД <> Неопределено)
			И (Ложь
				Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы") 
				Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле"))
		Тогда
			КнопкаОбщейКоманды = ОбщиеКоманды.РазличныеЗначенияКолонки;
			НаименованиеКоманды = КнопкаОбщейКоманды.Текст;
			Если ДанныеТекущегоЭлемента = Неопределено Тогда
				НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
			КонецЕсли; 
			#Если Сервер И Не Сервер Тогда
				ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс";
			НоваяКоманда.Порядок = 200; 
			НоваяКоманда.Параметр = "таблица";
			НоваяКоманда.Представление = НаименованиеКоманды;
			НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
			НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;

			Если ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") Тогда
				#Если Сервер И Не Сервер Тогда
					ОткрытьМенеджерТабличногоПоляАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "ОткрытьМенеджерТабличногоПоляАктивнойФормыЛкс";
				НоваяКоманда.Параметр = "таблица";
				НоваяКоманда.Порядок = 203; 
				КнопкаОбщейКоманды = ОбщиеКоманды.МенеджерТабличногоПоля;
				НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
				НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
				НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
			КонецЕсли;
			#Если Сервер И Не Сервер Тогда
				СообщитьКоличествоСтрокАктивнойТаблицыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "СообщитьКоличествоСтрокАктивнойТаблицыЛкс";
			НоваяКоманда.Порядок = 204;
			НоваяКоманда.Параметр = "таблица";
			КнопкаОбщейКоманды = ОбщиеКоманды.СколькоСтрок;
			НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
			НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
			НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
			
			Если ЛиВыделенныхСтрокБолееОдной Тогда
				#Если Сервер И Не Сервер Тогда
					СравнитьСтрокиАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "СравнитьСтрокиАктивнойФормыЛкс";
				НоваяКоманда.Параметр = "таблица";
				НоваяКоманда.Порядок = 205;
				КнопкаОбщейКоманды = ОбщиеКоманды.СравнитьСтроки;
				НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
				НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
				НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
			КонецЕсли; 
			Если Истина
				И ОбщийТипДанныхТаблицы <> "Список" 
				И ОбщийТипДанныхТаблицы <> Неопределено
				И ирКлиент.ЛиВКолонкеДоступнаЭмуляцияИнтерактивногоИзмененияЛкс(ТекущаяКолонка) 
			Тогда
				КнопкаОбщейКоманды = ОбщиеКоманды.УстановитьЗначениеВКолонке;
				НаименованиеКоманды = КнопкаОбщейКоманды.Текст;
				Если ДанныеТекущегоЭлемента = Неопределено Тогда
					НаименованиеКоманды = НаименованиеКоманды + " выделенных строк";
				КонецЕсли; 
				#Если Сервер И Не Сервер Тогда
					УстановитьЗначениеВКолонкеАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "УстановитьЗначениеВКолонкеАктивнойФормыЛкс";
				НоваяКоманда.Параметр = "таблица";
				НоваяКоманда.Порядок = 206;
				НоваяКоманда.Представление = НаименованиеКоманды;
				НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
				НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
			КонецЕсли; 
			Если Истина
				И ОбщийТипДанныхТаблицы <> "Список" 
				И ОбщийТипДанныхТаблицы <> Неопределено  
				И ТекущийЭлементАктивнойФормы.ИзменятьСоставСтрок 
				И Не ТекущийЭлементАктивнойФормы.ТолькоПросмотр
			Тогда
				#Если Сервер И Не Сервер Тогда
					ЗагрузитьДанныеВТабличноеПолеАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "ЗагрузитьДанныеВТабличноеПолеАктивнойФормыЛкс";
				НоваяКоманда.Параметр = "таблица";
				НоваяКоманда.Порядок = 207;
				КнопкаОбщейКоманды = ОбщиеКоманды.ЗагрузитьСтроки;
				НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
				НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
				НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
			КонецЕсли; 
			Если Истина
				И ЗначениеИзБуфера <> Неопределено
				И ОбщийТипДанныхТаблицы <> "Список" 
			Тогда
				Если Истина
					И ОписаниеТиповКолонки <> Неопределено
					И ОписаниеТиповКолонки.СодержитТип(ТипЗнч(ЗначениеИзБуфера)) 
				Тогда
					НаименованиеКоманды = "Найти скопированное значение";
					#Если Сервер И Не Сервер Тогда
						НайтиСкопированнуюСсылкуВТаблицеАктивнойФормыЛкс();
					#КонецЕсли
					НоваяКоманда = Команды.Добавить();
					НоваяКоманда.Имя = "НайтиСкопированнуюСсылкуВТаблицеАктивнойФормыЛкс";
					НоваяКоманда.Представление = НаименованиеКоманды;
					НоваяКоманда.Пояснение = "Найти - " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеИзБуфера,, Истина);
					НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирНайтиВСписке");
					НоваяКоманда.Параметр = "таблица";
					НоваяКоманда.Порядок = 208;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
		
		КнопкаОбщейКоманды = ОбщиеКоманды.ВывестиСтроки;
		НаименованиеКоманды = КнопкаОбщейКоманды.Текст;
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
		НоваяКоманда.Порядок = 210;
		НоваяКоманда.Параметр = Параметр;
		НоваяКоманда.Представление = НаименованиеКоманды;
		НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
		НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
		
		Если ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле") Тогда
			КнопкаОбщейКоманды = ОбщиеКоманды.НастроитьКолонки;
			#Если Сервер И Не Сервер Тогда
				НастроитьКолонкиТаблицыАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "НастроитьКолонкиТаблицыАктивнойФормыЛкс";
			НоваяКоманда.Порядок = 215;
			НоваяКоманда.Параметр = "таблица";
			НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
			НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
			НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
		КонецЕсли;
		
		КнопкаОбщейКоманды = ОбщиеКоманды.Сравнить;
		НаименованиеКоманды = КнопкаОбщейКоманды.Текст;
		Если Ложь
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы")
			Или ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТабличноеПоле")
		Тогда
			Если ДанныеТекущегоЭлемента = Неопределено Тогда
				НаименованиеКоманды = НаименованиеКоманды + " выделенные строки";
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
		НоваяКоманда.Порядок = 220;
		НоваяКоманда.Параметр = Параметр;
		НоваяКоманда.Представление = НаименованиеКоманды;
		НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
		НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
		
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
			НоваяКоманда.Пояснение = "Открыть табличный документ в редакторе табличного документа (ИР). Если доступно редактирование, то результат возвращается.";
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
				ирКлиент.ОтборБезЗначенияВТекущейКолонкеАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ирКлиент.ОтборБезЗначенияВТекущейКолонкеАктивнойФормыЛкс";
			НоваяКоманда.Параметр = "таблица";
			НоваяКоманда.Порядок = 230;
			КнопкаОбщейКоманды = ОбщиеКоманды.ОтборБезЗначенияВТекущейКолонке;
			НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
			НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
			НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
		КонецЕсли; 
		
		Если Истина
			И ОбщийТипДанныхТаблицы = "Список" 
			И ТипЗнч(ТекущийЭлементАктивнойФормы) = Тип("ТаблицаФормы")
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
			
			Если ПолноеИмяТаблицыБД <> Неопределено Тогда
				#Если Сервер И Не Сервер Тогда
					ОткрытьДинамическийСписокАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "ОткрытьДинамическийСписокАктивнойФормыЛкс";
				НоваяКоманда.Представление = "Открыть динамический список";
				НоваяКоманда.Пояснение = "Открыть динамический список ИР основной таблицы БД текущего списка";
				НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирДинамическийСписок");
				НоваяКоманда.Параметр = "динамический список";
				НоваяКоманда.Порядок = 245;
			КонецЕсли; 
		КонецЕсли; 
		
		Если Истина
			И ОбщийТипДанныхТаблицы = "Список" 
			И ирОбщий.ЛиКорневойТипСсылкиЛкс(ирОбщий.ПервыйФрагментЛкс(ПолноеИмяТаблицыБД)) 
		Тогда
			Если ТипЗнч(ЗначениеИзБуфера) = ТипЗнч(КлючТекущейСтрокиТаблицы) Тогда
				НаименованиеКоманды = "Найти скопированное значение";
				#Если Сервер И Не Сервер Тогда
					НайтиСкопированнуюСсылкуВТаблицеАктивнойФормыЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "НайтиСкопированнуюСсылкуВТаблицеАктивнойФормыЛкс";
				НоваяКоманда.Представление = НаименованиеКоманды;
				НоваяКоманда.Пояснение = "Найти - " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеИзБуфера,, Истина);
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирНайтиВСписке");
				НоваяКоманда.Параметр = "динамический список";
				НоваяКоманда.Порядок = 247;
			КонецЕсли;
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
	КлючОсновногоОбъекта = ирОбщий.КлючОсновногоОбъектаФормыЛкс(АктивнаяФорма);
	Если ирОбщий.КлючОсновногоОбъектаФормыЛкс(АктивнаяФорма) <> Неопределено Тогда
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
			НоваяКоманда.Пояснение = "Копировать ссылку в буфер обмена и сравнения";
			НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирКопировать");
			НоваяКоманда.Параметр = "форма";
			НоваяКоманда.Порядок = 305;
			Если ЗначениеИзБуфера <> Неопределено И ТипЗнч(ЗначениеИзБуфера) = ТипЗнч(КлючОсновногоОбъекта) Тогда
				НаименованиеКоманды = "Сравнить скопированное значение";
				#Если Сервер И Не Сервер Тогда
					СравнитьСкопированнуюСсылкуСАктивнойФормойЛкс();
				#КонецЕсли
				НоваяКоманда = Команды.Добавить();
				НоваяКоманда.Имя = "СравнитьСкопированнуюСсылкуСАктивнойФормойЛкс";
				НоваяКоманда.Представление = НаименованиеКоманды;
				НоваяКоманда.Пояснение = "Сравнить с - " + ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеИзБуфера,, Истина);
				НоваяКоманда.Картинка = ирКэш.КартинкаПоИмениЛкс("ирСравнениеОбъектов");
				НоваяКоманда.Параметр = "форма";
				НоваяКоманда.Порядок = 307;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Попытка
		СхемаКомпоновкиДанных = АктивнаяФорма.СхемаКомпоновкиДанных;
	Исключение
		СхемаКомпоновкиДанных = Неопределено;
	КонецПопытки;
	Если Ложь
		Или ирКлиент.ЭтоУправляемаяФормаОтчетаЛкс(АктивнаяФорма, Истина) 
		Или (Истина
			И ТипЗнч(АктивнаяФорма) = Тип("Форма")
			И ТипЗнч(СхемаКомпоновкиДанных) = Тип("СхемаКомпоновкиДанных"))
	Тогда
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
	ИначеЕсли ТипЗнч(АктивнаяФорма) = Тип("Форма") Тогда 
		Попытка
			ПостроительОтчета = АктивнаяФорма.ПостроительОтчета;
		Исключение
		КонецПопытки;
		Если ТипЗнч(ПостроительОтчета) = Тип("ПостроительОтчета") Тогда
			#Если Сервер И Не Сервер Тогда
				ОтладитьПостроительОтчетаАктивнойФормыЛкс();
			#КонецЕсли
			НоваяКоманда = Команды.Добавить();
			НоваяКоманда.Имя = "ОтладитьПостроительОтчетаАктивнойФормыЛкс";
			НоваяКоманда.Представление = "Отладить построение отчета";
			НоваяКоманда.Пояснение = "Отладить после выполнения отчет в консоли построителей отчетов (ИР)";
			НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирКонсольПостроителейОтчетов");
			НоваяКоманда.Параметр = "форма";
			НоваяКоманда.Порядок = 310;
		КонецЕсли;
	КонецЕсли; 
	Если Истина
		И ОбщийТипДанныхТаблицы = "СписокЗначений" 
		И ТекущийЭлементАктивнойФормы.ТолькоПросмотр = Ложь
		И ТекущийЭлементАктивнойФормы.ИзменятьСоставСтрок = Истина
	Тогда
		#Если Сервер И Не Сервер Тогда
			РедактироватьАктивныйСписокЗначенийЛкс();
		#КонецЕсли
		НоваяКоманда = Команды.Добавить();
		НоваяКоманда.Имя = "РедактироватьАктивныйСписокЗначенийЛкс";
		НоваяКоманда.Представление = "Редактировать список значений";
		НоваяКоманда.Пояснение = "Редактировать список значений в редакторе ИР и вернуть обратно в эту форму";
		НоваяКоманда.Картинка = БиблиотекаКартинок.ирСписокЗначений;
		НоваяКоманда.Параметр = "форма";
		НоваяКоманда.Порядок = 315;
	КонецЕсли; 
	
	#Если Сервер И Не Сервер Тогда
		ИсследоватьТекущийЭлементАктивнойФормыЛкс();
	#КонецЕсли
	НоваяКоманда = Команды.Добавить();
	НоваяКоманда.Имя = "ИсследоватьТекущийЭлементАктивнойФормыЛкс";
	НоваяКоманда.Представление = "Исследовать элемент формы";
	НоваяКоманда.Пояснение = "Открыть текущий элемент формы в исследователе, где можно менять его свойства";
	НоваяКоманда.Картинка = ирКэш.КартинкаИнструментаЛкс("Обработка.ирИсследовательОбъектов");
	НоваяКоманда.Параметр = "форма";
	НоваяКоманда.Порядок = 320;

	#Если Сервер И Не Сервер Тогда
		ОткрытьСтруктуруАктивнойФормыЛкс();
	#КонецЕсли
	НоваяКоманда = Команды.Добавить();
	НоваяКоманда.Имя = "ОткрытьСтруктуруАктивнойФормыЛкс";
	НоваяКоманда.Параметр = "форма";
	НоваяКоманда.Порядок = 330;
	КнопкаОбщейКоманды = ОбщиеКоманды.СтруктураФормы;
	НоваяКоманда.Представление = КнопкаОбщейКоманды.Текст;
	НоваяКоманда.Пояснение = КнопкаОбщейКоманды.Пояснение;
	НоваяКоманда.Картинка = КнопкаОбщейКоманды.Картинка;
	
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
		ирКлиент.ПодключитьОбработчикОжиданияСПараметрамиЛкс(ЭлементыФормы.Команды.ТекущаяСтрока.Имя, ПараметрыВызова);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыполнитьКомандуОтложенно()
	
	ЭтаФорма.СобственнаяСсылка = Неопределено;
	ПараметрыВызова = Новый Структура("Форма", АктивнаяФорма);
	Выполнить("ирПортативный." + ЭлементыФормы.Команды.ТекущаяСтрока.Имя + "(ПараметрыВызова)"); // Так окно в управляемом приложении откроется в режиме блокирования владельца
	
КонецПроцедуры

Процедура ЗакрытьФорму()
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
	
	//ирКлиент.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);  
	Если ДанныеСтроки.Параметр = "ячейка" Тогда
		КартинкаГранулы = ирКэш.КартинкаПоИмениЛкс("ирЯчейкаТаблицы");
	ИначеЕсли ДанныеСтроки.Параметр = "поле" Тогда
		КартинкаГранулы = ирКэш.КартинкаПоИмениЛкс("ирПолеВвода");
	ИначеЕсли ДанныеСтроки.Параметр = "строка" Тогда
		КартинкаГранулы = ирКэш.КартинкаПоИмениЛкс("ирСтрокаТаблицы");
	ИначеЕсли ДанныеСтроки.Параметр = "форма" Тогда
		КартинкаГранулы = ирКэш.КартинкаПоИмениЛкс("ирФорма");
	Иначе
		КартинкаГранулы = ирКэш.КартинкаПоИмениЛкс("ирНовыйФайл"); // белая картинка
	КонецЕсли;
	ОформлениеСтроки.Ячейки.Параметр.УстановитьКартинку(КартинкаГранулы);
	ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(ДанныеСтроки.Картинка);
	
КонецПроцедуры

Процедура КомандыПриАктивизацииСтроки(Элемент)
	
	//ирКлиент.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирКлиент.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ДатаОткрытия = ТекущаяДата() Тогда
		// Защита от двойного вызова
		Возврат;
	КонецЕсли;
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОсновныеДействияФормыОткрытьСтатью(Кнопка)
	
	ЗапуститьПриложение("https://infostart.ru/1c/articles/1273456/");
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирКлиент.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ГлобальноеМеню", Ложь);
Команды.Колонки.Добавить("Картинка");