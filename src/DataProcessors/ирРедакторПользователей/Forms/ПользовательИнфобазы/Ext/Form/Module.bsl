﻿
// Переменная хранит обладает ли пользователь правами администрирования или нет
Перем мЕстьПраваАдминистрирования;

Перем мЗакрытиеФормыИнициированоПользователем;
Перем мФормаМодифицирована;
Перем мПлатформа;
Перем мЗаменаНепустогоПароля;

Процедура мСообщитьОбОшибке(Текст)
	
	ирОбщий.СообщитьЛкс(Текст, СтатусСообщения.Внимание);
	
КонецПроцедуры

// нажатие на ОК в форме пользователя БД
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	РезультатЗаписи = ЗаписатьПользователя();
	Если РезультатЗаписи = Истина Тогда
		мЗакрытиеФормыИнициированоПользователем = Истина;
		ЭтаФорма.Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

// отмена
Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	мЗакрытиеФормыИнициированоПользователем = Истина;
	ЭтаФорма.Закрыть(Ложь);
	
КонецПроцедуры

// Процедура заполняет информацию о пользователе БД
Процедура ОбновитьДанныеПользователяБД(ПользовательНастроек, Знач ОтображатьИмя = Истина)
	
	Если ПользовательНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;
	#Если Сервер И Не Сервер Тогда
	    ПользовательНастроек = ПользователиИнформационнойБазы.ТекущийПользователь();
	#КонецЕсли
	Если ОтображатьИмя Тогда
		ЭтаФорма.Имя = ПользовательНастроек.Имя;
		ЭтаФорма.ПолноеИмя = ПользовательНастроек.ПолноеИмя;
	КонецЕсли;
	ЭтаФорма.Язык = ПользовательНастроек.Язык;
	ЭтаФорма.ОсновнойИнтерфейс = ПользовательНастроек.ОсновнойИнтерфейс;
	ЭтаФорма.АутентификацияСтандартная = ПользовательНастроек.АутентификацияСтандартная;
	ЭтаФорма.ПарольУстановлен = ПользовательНастроек.ПарольУстановлен;
	ЭтаФорма.СохраняемоеЗначениеПароля = ПользовательНастроек.СохраняемоеЗначениеПароля;
	ЭтаФорма.ВариантПароля = 2;
	Попытка
		ЭтаФорма.ПользовательОС = ПользовательНастроек.ПользовательОС;
	Исключение
		ЭтаФорма.ПользовательОС = "<Неверные данные>";
	КонецПопытки; 
 	ЭтаФорма.ПоказыватьВСпискеВыбора = ПользовательНастроек.ПоказыватьВСпискеВыбора;
	ЭтаФорма.АутентификацияОС = ПользовательНастроек.АутентификацияОС;
	ЭтаФорма.АутентификацияOpenID = ПользовательНастроек.АутентификацияOpenID;
	Для Каждого СтрокаСпискаДоступныхРолей Из РолиПользователя Цикл
		СтрокаСпискаДоступныхРолей.Пометка = ПользовательНастроек.Роли.Содержит(Метаданные.Роли[СтрокаСпискаДоступныхРолей.Роль]);
	КонецЦикла; 
	Для Каждого СтрокаРазделителя Из РазделениеДанных Цикл
		СтрокаРазделителя.ЗначениеСтрока = "";
		//СтрокаРазделителя.Значение = Неопределено;
		СтрокаРазделителя.Включена = ПользовательНастроек.РазделениеДанных.Свойство(СтрокаРазделителя.Разделитель); 
		Если СтрокаРазделителя.Включена Тогда
			СтрокаРазделителя.ЗначениеСтрока = ПользовательНастроек.РазделениеДанных[СтрокаРазделителя.Разделитель];
			//СтрокаРазделителя.Значение = ЗначениеРазделителяИзСтроки(СтрокаРазделителя.Разделитель, СтрокаРазделителя.ЗначениеСтрока);
		КонецЕсли; 
	КонецЦикла; 
	ЭтаФорма.РежимЗапуска = ПользовательНастроек.РежимЗапуска;
	Если ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс() Тогда
		ЭтаФорма.ЗащитаОтОпасныхДействий = ПользовательНастроек.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
	КонецЕсли;
	Если ирКэш.ДоступноВосстановлениеПароляПользователямЛкс() Тогда
		ЭтаФорма.АдресЭлектроннойПочты = ПользовательНастроек.АдресЭлектроннойПочты;
		ЭтаФорма.ЗапрещеноВосстанавливатьПароль = ПользовательНастроек.ЗапрещеноВосстанавливатьПароль;
	КонецЕсли; 
	Если ОтображатьИмя Тогда
		СсылкиПользователей = СсылкиПользователей();
		СтрокаСсылки = СсылкиПользователей.Найти(ПользовательНастроек.УникальныйИдентификатор, "ИдентификаторПользователяИБ");
		Если СтрокаСсылки <> Неопределено Тогда
			ЭтаФорма.Ссылка = СтрокаСсылки.Ссылка;
		КонецЕсли;
	КонецЕсли;
	ОбновитьДоступность();
	
КонецПроцедуры

Функция _ЗначениеРазделителяИзСтроки(ИмяРазделителя, СтрокаЗначения)
	
	МетаРазделитель = Метаданные.ОбщиеРеквизиты.Найти(ИмяРазделителя);
	Если Ложь
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Булево")) 
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Число")) 
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Дата")) 
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Строка"))
	Тогда
		Результат = МетаРазделитель.ТипЗначения.ПривестиЗначение(СтрокаЗначения);
	Иначе
		ОбъектМД = Метаданные.НайтиПоТипу(МетаРазделитель.ТипЗначения.Типы()[0]);
		Менеджер = ирОбщий.ПолучитьМенеджерЛкс(ОбъектМД);
	КонецЕсли; 
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ДЛЯ РАБОТЫ С ИНФОРМАЦИЕЙ О ПОЛЬЗОВАТЕЛЕ БД

// Процедура - обработчик "При изменении" АутентификацияСтандартная
Процедура АутентификацияСтандартнаяПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

// Процедура - обработчик "При изменении" АутентификацияОС
Процедура АутентификацияОСПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

// Процедура заполняет списки выбора атрибутов для пользователя БД
Процедура ИнициализироватьЭлементыРедактированияПользователяБД()
	
	ЗаполнитьСписокВыбораЯзыка(ЭлементыФормы.Язык.СписокВыбора);
	ЗаполнитьСписокВыбораИнтерфейса(ЭлементыФормы.ОсновнойИнтерфейс.СписокВыбора);
	ЗаполнитьСписокВыбораРежимаЗапуска(ЭлементыФормы.РежимЗапуска.СписокВыбора);
	
КонецПроцедуры

// Процедура выполняет запись пользователя ИБ
Функция ЗаписатьПользователя()
	
	Если ПользовательИБ = Неопределено Тогда
		//Возврат Ложь;
		ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
	КонецЕсли;
	Имя = СокрЛП(Имя);
	Если НЕ ЗначениеЗаполнено(Имя) Тогда
		мСообщитьОбОшибке("Не заполнено имя пользователя базы данных!");
		Возврат Ложь;
	КонецЕсли;
	
	//проверим что бы было указано то что нужно
	Если Истина
		И АутентификацияОС
		И ПустаяСтрока(ПользовательОС) 
	Тогда
		мСообщитьОбОшибке("Укажите пользователя Windows или запретите Windows-аутентификацию!");
		Возврат Ложь;
	КонецЕсли;
	
	ПользовательИБ.Имя = Имя;
	ПользовательИБ.ПолноеИмя = ПолноеИмя;
	ПользовательИБ.ПользовательОС = ПользовательОС;
	Если ВариантПароля = 0 Тогда
		Если Пароль <> ПодтверждениеПароля Тогда
			мСообщитьОбОшибке("Пароль и подтверждение пароля не совпадают!!!"); 
			Возврат Ложь;
		КонецЕсли;
		ПользовательИБ.Пароль = Пароль;
	ИначеЕсли ВариантПароля = 1 Тогда
		ПользовательИБ.СохраняемоеЗначениеПароля = СохраняемоеЗначениеПароля;
	КонецЕсли; 
	
	ПользовательИБ.АутентификацияСтандартная = АутентификацияСтандартная;
	ПользовательИБ.ПоказыватьВСпискеВыбора = ПоказыватьВСпискеВыбора;
	ПользовательИБ.АутентификацияОС = АутентификацияОС;
	ПользовательИБ.АутентификацияOpenID = АутентификацияOpenID;
	ПользовательИБ.Язык = Язык;
	ПользовательИБ.ОсновнойИнтерфейс = ОсновнойИнтерфейс;
	Если РежимЗапуска <> Неопределено Тогда
		ПользовательИБ.РежимЗапуска = РежимЗапуска;
	КонецЕсли; 
	Если ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс() Тогда
		ПользовательИБ.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = ЭтаФорма.ЗащитаОтОпасныхДействий;
	КонецЕсли; 
	Если ирКэш.ДоступноВосстановлениеПароляПользователямЛкс() Тогда
		ПользовательИБ.АдресЭлектроннойПочты = ЭтаФорма.АдресЭлектроннойПочты;
		ПользовательИБ.ЗапрещеноВосстанавливатьПароль = ЭтаФорма.ЗапрещеноВосстанавливатьПароль;
	КонецЕсли; 
	
	// Роли сохраняем
	Для Каждого СтрокаСпискаДоступныхРолей Из РолиПользователя Цикл
		мРоль = Метаданные.Роли[СтрокаСпискаДоступныхРолей.Роль];
		СодержитРоль = ПользовательИБ.Роли.Содержит(мРоль);
		Если СодержитРоль И Не СтрокаСпискаДоступныхРолей.Пометка Тогда
			ПользовательИБ.Роли.Удалить(мРоль);
		ИначеЕсли Не СодержитРоль И СтрокаСпискаДоступныхРолей.Пометка Тогда
			ПользовательИБ.Роли.Добавить(мРоль);
		КонецЕсли; 
	КонецЦикла;
	
	Если РазделениеДанных.Количество() > 0 Тогда
		ПользовательИБ.РазделениеДанных.Очистить();
		Для Каждого СтрокаРазделителя Из РазделениеДанных Цикл
			Если СтрокаРазделителя.Включена Тогда
				ПользовательИБ.РазделениеДанных.Вставить(СтрокаРазделителя.Разделитель, СтрокаРазделителя.ЗначениеСтрока);
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	
	// запись пользователя БД
	Попытка
		ПользовательИБ.Записать();
	Исключение
		мСообщитьОбОшибке("Ошибка при сохранении данных пользователя инфобазы. " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	ЭтаФорма.Модифицированность = Ложь;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, Имя, ": ");
	ирОбщий.ОповеститьОЗаписиОбъектаЛкс(ПользовательИБ, ЭтаФорма); 
	Возврат Истина;
		
КонецФункции

//Процедура - обработчик события "НачалоВыбора" в: Поле ввода "ПользовательОС"
Процедура ПользовательОСНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаПользователяОСНачалоВыбораЛкс(Элемент, СтандартнаяОбработка, Истина);
	
КонецПроцедуры

//Процедура - обаботчик события, "При изменении" у имени пользователя БД
Процедура ИмяПриИзменении(Элемент)
	
	Элемент.Значение = СокрЛП(Имя);
	
	// полное имя пользователя БД тоже ставим если оно пустое
	Если НЕ ЗначениеЗаполнено(ПолноеИмя) Тогда
		ПолноеИмя = Элемент.Значение
	КонецЕсли;
	
КонецПроцедуры

// перед открытием
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ОбработкаОбъекта = Новый (ТипЗнч(ОбработкаОбъекта)); // https://www.hostedredmine.com/issues/919705
	мПлатформа = ирКэш.Получить();
	ИнициализироватьЭлементыРедактированияПользователяБД();
	ОбновитьДоступныеРоли();
	Если ПользовательДляКопированияНастроек = Неопределено Тогда
		ОбновитьДанныеПользователяБД(ПользовательИБ);
	Иначе
		ОбновитьДанныеПользователяБД(ПользовательДляКопированияНастроек, Ложь);
	КонецЕсли;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, Имя, ": ");
	ЭтаФорма.ТолькоПросмотр = НЕ мЕстьПраваАдминистрирования;
	мФормаМодифицирована = Модифицированность;
		
КонецПроцедуры

// перед закрытием
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если мЗакрытиеФормыИнициированоПользователем Тогда
		
		мЗакрытиеФормыИнициированоПользователем = Ложь;
		Возврат;
		
	КонецЕсли;
	
	// форму принудительно пытаются закрыть	
	Если Модифицированность Тогда
		
		// есть права на изменение пользователя БД
		ОтветПользователя = Вопрос("Настройки пользователя БД были изменены. Сохранить?", РежимДиалогаВопрос.ДаНетОтмена, ,
			КодВозвратаДиалога.Да);
			
		Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
			
			// записываем внесенные изменения
			РезультатЗаписи = ЗаписатьПользователя();
			Отказ = Не РезультатЗаписи;
			
			Если Не Отказ Тогда
				мЗакрытиеФормыИнициированоПользователем = Истина;
				Закрыть(Истина);
			КонецЕсли;			
				
		ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда	
			
			// ничего делать не надо
			
		Иначе	
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭлементыФормы.ЗащитаОтОпасныхДействий.Доступность = ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс();
	Если Не ирКэш.ДоступноВосстановлениеПароляПользователямЛкс() Тогда
		ЭлементыФормы.АдресЭлектроннойПочты.Доступность = Ложь;
		ЭлементыФормы.ЗапрещеноВосстанавливатьПароль.Доступность = Ложь;
	КонецЕсли; 
	Модифицированность = мФормаМодифицирована;
	Если ПользовательИБ <> Неопределено Тогда
		УстановитьОтборТолькоВключенные(Истина);
	КонецЕсли; 
	
КонецПроцедуры

// копирование настроек пользователя БД
Процедура КоманднаяПанельОбщаяСкопироватьНастройки(Кнопка)
	
	СписокВыбора = Новый СписокЗначений;
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для каждого ВремПользователь Из МассивПользователей Цикл
		СписокВыбора.Добавить(ВремПользователь.УникальныйИдентификатор, ВремПользователь.Имя);
	КонецЦикла; 
	СписокВыбора.СортироватьПоЗначению();
	ВыбранныйПользователь = СписокВыбора.ВыбратьЭлемент("Выберите пользователя, от которого копировать настройки", СписокВыбора);
	Если ВыбранныйПользователь = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВыбранныйПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ВыбранныйПользователь.Значение);
	ОбновитьДанныеПользователяБД(ВыбранныйПользовательИБ, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаДоступныхРолейТолькоВключенные(Кнопка)
	
	УстановитьОтборТолькоВключенные(Не Кнопка.Пометка);
	
КонецПроцедуры 

Процедура УстановитьОтборТолькоВключенные(НовоеЗначение)
	
	ЭлементыФормы.КоманднаяПанельСпискаДоступныхРолей.Кнопки.ТолькоВключенные.Пометка = НовоеЗначение;
	ЭлементыФормы.РолиПользователя.ОтборСтрок.Пометка.ВидСравнения = ВидСравнения.Равно;
	ЭлементыФормы.РолиПользователя.ОтборСтрок.Пометка.Использование = НовоеЗначение;
	ЭлементыФормы.РолиПользователя.ОтборСтрок.Пометка.Значение = Истина;
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Функция СгенерироватьПароль(ДлинаСлучайногоПароля = 10)
	
	ЗапрещенныеСимволы = Новый СписокЗначений();
	ЗапрещенныеСимволы.Добавить(" ");
	НовыйПароль = "";
	Генератор = Новый ГенераторСлучайныхЧисел();
	Счетчик = 0;
	Пока Счетчик < ДлинаСлучайногоПароля цикл
		КодСимвола = Генератор.СлучайноеЧисло(33, 126);
		Символ = Символ(КодСимвола);
		НовыйПароль = НовыйПароль + Символ;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	Возврат НовыйПароль;
	
КонецФункции

Процедура СгенерироватьНажатие(Элемент)
	
	НовыйПароль = СгенерироватьПароль();
	ЭтаФорма.Пароль = НовыйПароль;
	ЭтаФорма.ПодтверждениеПароля = НовыйПароль;
	ирОбщий.ТекстВБуферОбменаОСЛкс(НовыйПароль);
	Предупреждение("Новый пароль установлен в форме и помещен в буфер обмена");
	
КонецПроцедуры

Процедура ВариантПароляСохраняемоеЗначениеПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ВариантПароляЯвныйПриИзменении(Элемент)
	
	ОбновитьДоступность();
	Если Пароль = мЗаменаНепустогоПароля Тогда
		ЭтаФорма.Пароль = "";
		ЭтаФорма.ПодтверждениеПароля = "";
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	ЭлементыФормы.СохраняемоеЗначениеПароля.ТолькоПросмотр = ВариантПароля <> 1;
	ЭлементыФормы.Пароль.ТолькоПросмотр = ВариантПароля <> 0;
	ЭлементыФормы.ПодтверждениеПароля.ТолькоПросмотр = ВариантПароля <> 0;
	ЭлементыФормы.Сгенерировать.Доступность = АутентификацияСтандартная И ВариантПароля = 0;
	ЭлементыФормы.Пароль.Доступность              			= АутентификацияСтандартная;
	ЭлементыФормы.ВариантПароляЯвный.Доступность 	= АутентификацияСтандартная;
	ЭлементыФормы.ПодтверждениеПароля.Доступность 			= АутентификацияСтандартная;
	ЭлементыФормы.НадписьПодтверждениеПароляБД.Доступность	= АутентификацияСтандартная;
	ЭлементыФормы.ВариантПароляСохраняемоеЗначение.Доступность = АутентификацияСтандартная;
	ЭлементыФормы.ВариантПароляНеМенять.Доступность 		= АутентификацияСтандартная;
	ЭлементыФормы.СохраняемоеЗначениеПароля.Доступность = АутентификацияСтандартная;
	ЭлементыФормы.ПоказыватьВСпискеВыбора.Доступность 		= АутентификацияСтандартная;
	ЭлементыФормы.ПользовательОС.Доступность 				= АутентификацияОС;
	ЭлементыФормы.НадписьПользовательОС.Доступность 		= АутентификацияОС;
	Если ВариантПароля <> 0 Тогда
		Если ПарольУстановлен Тогда
			ЭтаФорма.Пароль = мЗаменаНепустогоПароля;
			ЭтаФорма.ПодтверждениеПароля = мЗаменаНепустогоПароля;
		Иначе
			ЭтаФорма.Пароль = "";
			ЭтаФорма.ПодтверждениеПароля = "";
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ПарольОчистка(Элемент, СтандартнаяОбработка)
	
	ПодтверждениеПароля = "";
	
КонецПроцедуры

Процедура КоманднаяПанельОбщаяНайтиВСписке(Кнопка)
	
	Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторПользователей.Форма");
	Форма.ПараметрИмяПользователя = Имя;
	Форма.Открыть();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗаписать(Кнопка)
	
	ЗаписатьПользователя();
	
КонецПроцедуры

Процедура РолиПользователяПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка, ЭлементыФормы.КоманднаяПанельСпискаДоступныхРолей.Кнопки.ТолькоВключенные);
	
КонецПроцедуры

Процедура РолиПользователяПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура РолиПользователяПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КоманднаяПанельСпискаДоступныхРолейАнализПравДоступа(Кнопка)
	
	Если ЭлементыФормы.РолиПользователя.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаОтчета = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, Имя);
	ФормаОтчета.Пользователь = Имя;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.РолиПользователя.ВыделенныеСтроки Цикл
		ФормаОтчета.НаборРолей.Добавить(ВыделеннаяСтрока.Роль);
	КонецЦикла;
	ФормаОтчета.ПараметрКлючВарианта = "ПоМетаданным";
	ФормаОтчета.Открыть();
	
КонецПроцедуры

Процедура ОбновитьОтбор()
	
	ирОбщий.ТабличноеПолеУстановитьОтборПоПодстрокеЛкс(ЭтаФорма, ЭлементыФормы.РолиПользователя, ПодстрокаПоиска);

КонецПроцедуры

Процедура ПодстрокаПоискаПриИзменении(Элемент)
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьОтбор();
КонецПроцедуры

Процедура ПодстрокаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ПодстрокаПоискаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	Если ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(ЭтаФорма, Элемент, Текст) Тогда 
		ОбновитьОтбор();
	КонецЕсли;
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПользователей.Форма.ПользовательИнфобазы");
мЕстьПраваАдминистрирования = ПравоДоступа("Администрирование", Метаданные);
мЗаменаНепустогоПароля = "****************";
//Заполняем параметры пользователя БД
мЗакрытиеФормыИнициированоПользователем = Ложь;
ПользовательДляКопированияНастроек = Неопределено;
