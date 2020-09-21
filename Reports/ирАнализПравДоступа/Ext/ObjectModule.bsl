﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем РежимОтладки Экспорт;
Перем ТаблицаСтарая;
Перем ПользовательСтарый;
Перем РольСтарый;
Перем ПолеОбъектаСтарый;
Перем ОбъектМетаданныхСтарый;
Перем СтарыйИспользоватьНаборПолей;

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	#Если _ Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		КонечнаяНастройка = Новый НастройкиКомпоновкиДанных;
		ВнешниеНаборыДанных = Новый Структура;
		ДокументРезультат = Новый ТабличныйДокумент;
	#КонецЕсли
	ДокументРезультат.Очистить();
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Роль) Тогда
		Роли = Новый Массив;
		МетаРоль = Метаданные.Роли.Найти(Роль);
		Если МетаРоль <> Неопределено Тогда
			Роли.Добавить(МетаРоль);
		Иначе
			Сообщить("Роль """ + Роль + """ не найдена в метаданных");
			Возврат;
		КонецЕсли; 
	ИначеЕсли ЗначениеЗаполнено(Пользователь) Тогда
		Если Пользователь = ИмяПользователя() Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
		Иначе
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
		КонецЕсли; 
		Если ПользовательИБ = Неопределено Тогда
			Сообщить("Пользователь с именем """ + Пользователь + """ не найден", СтатусСообщения.Внимание);
			Возврат;
		КонецЕсли; 
		Роли = ПользовательИБ.Роли;
	Иначе
		Роли = Метаданные.Роли;
	КонецЕсли;
	Если ИспользоватьНаборПолей Тогда
		НаборПолейТаблица.Очистить();
		Для Каждого ЭлементСписка Из НаборПолей Цикл
			СтрокаПоля = НаборПолейТаблица.Добавить();
			СтрокаПоля.ПолеПолноеИмя = ЭлементСписка.Значение;
			СтрокаПоля.ОбъектМДПолноеИмя = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(СтрокаПоля.ПолеПолноеИмя);
			ТипТаблицы = ирОбщий.ТипТаблицыБДЛкс(СтрокаПоля.ОбъектМДПолноеИмя);
			Если ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
				СтрокаПоля.ТабличнаяЧасть = ирОбщий.ПоследнийФрагментЛкс(СтрокаПоля.ОбъектМДПолноеИмя);
				СтрокаПоля.ОбъектМДПолноеИмя = ирОбщий.СтрокаБезПоследнегоФрагментаЛкс(СтрокаПоля.ОбъектМДПолноеИмя);
			КонецЕсли; 
			СтрокаПоля.Поле = ирОбщий.ПоследнийФрагментЛкс(СтрокаПоля.ПолеПолноеИмя);
		КонецЦикла;
	КонецЕсли; 
	Если Ложь
		Или ТаблицаСтарая = Неопределено 
		Или ИспользоватьНаборПолей <> СтарыйИспользоватьНаборПолей
		Или (Истина
			И ЗначениеЗаполнено(ОбъектМетаданныхСтарый)
			И ОбъектМетаданных <> ОбъектМетаданныхСтарый) 
		Или (Истина
			//И ЗначениеЗаполнено(ПолеОбъектаСтарый)
			И ПолеОбъекта <> ПолеОбъектаСтарый) 
		Или (Истина
			И ЗначениеЗаполнено(ПользовательСтарый)
			И Пользователь <> ПользовательСтарый) 
		Или (Истина
			И ЗначениеЗаполнено(РольСтарый)
			И Роль <> РольСтарый) 
	Тогда
		Таблица = Новый ТаблицаЗначений;
		Таблица.Колонки.Добавить("ТипМетаданных", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("ОбъектМетаданных", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("ОбъектМетаданныхПредставление", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("Поле", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("ПолеПолноеИмя", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("ТабличнаяЧасть", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("Право", Новый ОписаниеТипов("Строка"));
		Таблица.Колонки.Добавить("Доступ", Новый ОписаниеТипов("Строка"));
		МассивПрав = Новый Структура;
		МассивПрав.Вставить("Чтение", "1.Чтение");
		МассивПрав.Вставить("Просмотр", "2.Просмотр");
		МассивПрав.Вставить("Добавление", "3.Добавление");
		МассивПрав.Вставить("ИнтерактивноеДобавление", "4.Интерактивное Добавление");
		МассивПрав.Вставить("Изменение", "5.Изменение");
		МассивПрав.Вставить("Редактирование", "6.Интерактивное изменение");
		МассивПрав.Вставить("Удаление", "7.Удаление");
		МассивПрав.Вставить("ИнтерактивноеУдаление", "8.Интерактивное Удаление");
		МассивПрав.Вставить("Использование", "9.Использование");
		ПраваСсылочные = Новый Структура;
		ПраваСсылочные.Вставить("Чтение");
		ПраваСсылочные.Вставить("Просмотр");
		ПраваСсылочные.Вставить("Добавление");
		ПраваСсылочные.Вставить("ИнтерактивноеДобавление");
		ПраваСсылочные.Вставить("Изменение");
		ПраваСсылочные.Вставить("Редактирование");
		ПраваСсылочные.Вставить("Удаление");
		ПраваСсылочные.Вставить("ИнтерактивноеУдаление");
		ПраваРегистры = Новый Структура;
		ПраваРегистры.Вставить("Чтение");
		ПраваРегистры.Вставить("Просмотр");
		ПраваРегистры.Вставить("Изменение");
		ПраваРегистры.Вставить("Редактирование");
		ПраваЖурналы = Новый Структура;
		ПраваЖурналы.Вставить("Чтение");
		ПраваЖурналы.Вставить("Просмотр");
		ПраваНехранимые = Новый Структура;
		ПраваНехранимые.Вставить("Использование");
		ПраваНехранимые.Вставить("Просмотр");
		мПлатформа = ирКэш.Получить();
		#Если Сервер И Не Сервер Тогда
			мПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		ТипыМетаданных = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Ложь);
		ПользовательСтарый = Пользователь;
		РольСтарый = Роль;
		Если ИспользоватьНаборПолей Тогда
			ОбъектМетаданныхСтарый = Неопределено;
		Иначе
			ОбъектМетаданныхСтарый = ОбъектМетаданных;
		КонецЕсли;
		СтарыйИспользоватьНаборПолей = ИспользоватьНаборПолей;
		ПолеОбъектаСтарый = ПолеОбъекта;
		ИндикаторТиповМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТипыМетаданных.Количество(), "Объекты. Типы метаданных");
		Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМетаданных);
			Попытка
				КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
			Исключение
				Продолжить;
			КонецПопытки;
			КорневойТип = СтрокаТипаМетаданных.Единственное;
			Если Ложь
				Или ирОбщий.ЛиКорневойТипПеречисленияЛкс(КорневойТип) 
				Или КорневойТип = "ВнешнийИсточникДанных"
			Тогда
				Продолжить;
			КонецЕсли; 
			ЛиКорневойТипСсылочный = ирОбщий.ЛиКорневойТипСсылкиЛкс(КорневойТип);
			ЛиКорневойТипРегистра = ирОбщий.ЛиКорневойТипРегистраБДЛкс(КорневойТип);
			ЛиКорневойТипЖурнала = ирОбщий.ЛиКорневойТипЖурналаДокументовЛкс(КорневойТип);
			ЛиКорневойТипНехранимый = Не ЛиКорневойТипСсылочный И Не ЛиКорневойТипРегистра И Не ЛиКорневойТипЖурнала;
			Если Истина
				И ЛиКорневойТипНехранимый
				//И ТипМетаданныхИмяЕдинственное <> "HttpСервис"
				//И ТипМетаданныхИмяЕдинственное <> "WebСервис"
				И КорневойТип <> "Интерфейс"
				И КорневойТип <> "КритерийОтбора"
				И КорневойТип <> "Отчет"
				И КорневойТип <> "Обработка"
				И КорневойТип <> "ОбщаяКоманда"
				И КорневойТип <> "ОбщаяФорма"
				И КорневойТип <> "ОбщийРеквизит"
				И КорневойТип <> "ПараметрСеанса"
			Тогда
				Продолжить;
			КонецЕсли;
			Если ЗначениеЗаполнено(ПолеОбъекта) Тогда
				ИмяПоляТипаМетаданных = ПолеОбъекта;
			ИначеЕсли ЛиКорневойТипСсылочный Или ЛиКорневойТипЖурнала Тогда
				ИмяПоляТипаМетаданных = "Ссылка";
			ИначеЕсли ЛиКорневойТипРегистра Тогда
				ИмяПоляТипаМетаданных = "Период";
			Иначе
				ИмяПоляТипаМетаданных = Неопределено;
			КонецЕсли; 
			ИндикаторОбъектов = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
			Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
				#Если Сервер И Не Сервер Тогда
					МетаОбъект = Метаданные.Обработки.ирАнализЖурналаРегистрации;
				#КонецЕсли
				ирОбщий.ОбработатьИндикаторЛкс(ИндикаторОбъектов);
				ПолноеИмяОбъектаМД = МетаОбъект.ПолноеИмя();
				ТабличныеЧасти = Новый Массив;
				Если Истина
					И Не ИспользоватьНаборПолей
					И ЗначениеЗаполнено(ОбъектМетаданных) 
				Тогда
					Если ОбъектМетаданных <> ПолноеИмяОбъектаМД Тогда
						Продолжить;
					КонецЕсли;
					Если Не ЗначениеЗаполнено(ПолеОбъекта) Тогда
						СтруктураТабличныхЧастей = ирОбщий.ТабличныеЧастиОбъектаЛкс(МетаОбъект);
						#Если Сервер И Не Сервер Тогда
							СтруктураТабличныхЧастей = Новый Структура;
						#КонецЕсли
						Для Каждого КлючИЗначение Из СтруктураТабличныхЧастей Цикл
							ТабличныеЧасти.Добавить(КлючИЗначение.Ключ);
						КонецЦикла;
					КонецЕсли; 
				ИначеЕсли ИспользоватьНаборПолей Тогда
					ТабличныеЧасти = НаборПолейТаблица.Выгрузить(Новый Структура("ОбъектМДПолноеИмя", ПолноеИмяОбъектаМД)).ВыгрузитьКолонку("ТабличнаяЧасть");
					Если ТабличныеЧасти.Количество() = 0 Тогда
						Продолжить;
					КонецЕсли; 
				КонецЕсли;
				ТабличныеЧасти.Добавить("");
				Для Каждого ИмяТЧ Из ТабличныеЧасти Цикл
					ТЧ_МД = МетаОбъект;
					ПолноеИмяТЧ_МД = ПолноеИмяОбъектаМД;
					Если ЗначениеЗаполнено(ИмяТЧ) Тогда
						ПолноеИмяТЧ_МД = ПолноеИмяТЧ_МД + "." + ИмяТЧ;
						ТЧ_МД = МетаОбъект.ТабличныеЧасти[ИмяТЧ];
					КонецЕсли; 
					ПредставлениеМД = ТЧ_МД.Представление();
					Если ВычислятьФункциональныеОпции Тогда
						// Добавим фиктивную строку для проверки функциональных опций на сам объект
						СтрокаТаблицы = Таблица.Добавить();
						СтрокаТаблицы.ТипМетаданных = КорневойТип;
						СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяОбъектаМД;
						СтрокаТаблицы.ОбъектМетаданныхПредставление = ПредставлениеМД;
						СтрокаТаблицы.ТабличнаяЧасть = ИмяТЧ;
						СтрокаТаблицы.ПолеПолноеИмя = ПолноеИмяТЧ_МД;
					КонецЕсли; 
					ПоляТЧ = Новый Массив;
					Если Истина
						И Не ИспользоватьНаборПолей
						И ЗначениеЗаполнено(ОбъектМетаданных) 
					Тогда
						ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТЧ_МД);
						Для Каждого СтрокаПоля Из ПоляТаблицы Цикл
							Если Ложь
								Или СтрокаПоля.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) 
								Или (Истина
									И ЗначениеЗаполнено(ИмяТЧ)
									И (Ложь
										Или СтрокаПоля.Имя = "Ссылка"
										Или СтрокаПоля.Имя = "НомерСтроки"))
							Тогда
								Продолжить;
							КонецЕсли; 
							ПоляТЧ.Добавить(СтрокаПоля.Имя);
						КонецЦикла;
					ИначеЕсли ИспользоватьНаборПолей Тогда
						ПоляТЧ = НаборПолейТаблица.Выгрузить(Новый Структура("ОбъектМДПолноеИмя, ТабличнаяЧасть", ПолноеИмяОбъектаМД, ИмяТЧ)).ВыгрузитьКолонку("Поле");
						Если ПоляТЧ.Количество() = 0 Тогда
							Продолжить;
						КонецЕсли;
					ИначеЕсли Не ЗначениеЗаполнено(ИмяТЧ) Тогда
						ПоляТЧ.Добавить(ИмяПоляТипаМетаданных);
					КонецЕсли;
					//ПоляТЧ.Добавить("");
					Для Каждого ИмяПоляОбъекта Из ПоляТЧ Цикл
						Для Каждого КлючИЗначение Из МассивПрав Цикл
							Если Ложь
								Или ЛиКорневойТипСсылочный И Не ПраваСсылочные.Свойство(КлючИЗначение.Ключ) 
								Или ЛиКорневойТипРегистра И Не ПраваРегистры.Свойство(КлючИЗначение.Ключ) 
								Или ЛиКорневойТипЖурнала И Не ПраваЖурналы.Свойство(КлючИЗначение.Ключ) 
								Или ЛиКорневойТипНехранимый И Не ПраваНехранимые.Свойство(КлючИЗначение.Ключ) 
							Тогда
								Продолжить;
							КонецЕсли; 
							//ИндикаторРолей = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Метаданные.Роли.Количество(), "Роли");
							Для Каждого РольЦикл Из Роли Цикл
								Право = КлючИЗначение.Ключ;
								ПрерватьЦикл = Ложь;
								ИмяПоляВместеСТЧ = ИмяПоляОбъекта;
								Если ЗначениеЗаполнено(ИмяТЧ) Тогда
									ИмяПоляВместеСТЧ = ИмяТЧ + "." + ИмяПоляОбъекта;
								КонецЕсли; 
								Если ЛиКорневойТипНехранимый Тогда
									Попытка
										ПараметрыДоступа = ПравоДоступа(Право, ТЧ_МД.Реквизиты[ИмяПоляОбъекта], РольЦикл);
									Исключение
										Прервать;
									КонецПопытки;
								Иначе
									Попытка
										ПараметрыДоступа = ПараметрыДоступа(Право, МетаОбъект, ИмяПоляВместеСТЧ, РольЦикл);
									Исключение
										Если Ложь
											Или ЗначениеЗаполнено(ПолеОбъекта) 
											Или ЗначениеЗаполнено(ИмяТЧ)
										Тогда
											ПрерватьЦикл = Истина;
										Иначе
											ИмяПоляОбъекта = "";
											ПараметрыДоступа = ирОбщий.ПараметрыДоступаКОбъектуМДЛкс(Право, МетаОбъект, РольЦикл, ПрерватьЦикл, ИмяПоляОбъекта);
										КонецЕсли; 
										Если ПрерватьЦикл Тогда
											Прервать;
										КонецЕсли; 
									КонецПопытки;
								КонецЕсли; 
								СтрокаТаблицы = Таблица.Добавить();
								СтрокаТаблицы.ТипМетаданных = КорневойТип;
								СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяОбъектаМД;
								СтрокаТаблицы.ОбъектМетаданныхПредставление = ПредставлениеМД;
								СтрокаТаблицы.ТабличнаяЧасть = ИмяТЧ;
								СтрокаТаблицы.Поле = ИмяПоляОбъекта;
								СтрокаТаблицы.ПолеПолноеИмя = ПолноеИмяОбъектаМД + "." + ИмяПоляВместеСТЧ;
								//ДочернийОбъектМД = ирОбщий.ДочернийОбъектМДПоИмениЛкс(МетаОбъект, ИмяПоляОбъекта, КорневойТип);
								//Если ДочернийОбъектМД <> Неопределено Тогда
								//	СтрокаТаблицы.ПолеПолноеИмя = ДочернийОбъектМД.ПолноеИмя();
								//КонецЕсли; 
								СтрокаТаблицы.Роль = РольЦикл.Имя;
								СтрокаТаблицы.Право = КлючИЗначение.Значение;
								Если ТипЗнч(ПараметрыДоступа) = Тип("Булево") Тогда
									Если ПараметрыДоступа Тогда
										Доступ = "да";
									Иначе
										Доступ = "нет";
									КонецЕсли; 
								ИначеЕсли ПараметрыДоступа.Доступность Тогда
									Если ПараметрыДоступа.ОграничениеУсловием Тогда
										Доступ = "да ограничено";
									Иначе
										Доступ = "да";
									КонецЕсли;
								Иначе
									Доступ = "нет";
								КонецЕсли;
								СтрокаТаблицы.Доступ = Доступ;
							КонецЦикла;
						КонецЦикла; 
						//ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		ТаблицаСтарая = Таблица;
	КонецЕсли;
	ПрофилиГруппДоступа = Новый ТаблицаЗначений;
	ПрофилиГруппДоступа.Колонки.Добавить("РольИмя", Новый ОписаниеТипов("Строка"));
	ПрофилиГруппДоступа.Колонки.Добавить("ПрофильГруппДоступа", Новый ОписаниеТипов("Строка"));
	ПрофилиГруппДоступа.Колонки.Добавить("КоличествоРолей", Новый ОписаниеТипов("Число"));
	Если ирКэш.НомерВерсииБСПЛкс() >= 200 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"
		|ВЫБРАТЬ
		|	ПрофилиГруппДоступаРоли.Ссылка КАК ПрофильГруппДоступа,
		|	Профили.КоличествоРолей КАК КоличествоРолей,
		|	ПрофилиГруппДоступаРоли.Роль.Имя КАК РольИмя
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ПрофилиГруппДоступа_РолиТ.Ссылка КАК Ссылка,
		|			КОЛИЧЕСТВО(ПрофилиГруппДоступа_РолиТ.Роль) КАК КоличествоРолей
		|		ИЗ
		|			Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступа_РолиТ
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ПрофилиГруппДоступа_РолиТ.Ссылка) КАК Профили
		|		ПО Профили.Ссылка = ПрофилиГруппДоступаРоли.Ссылка
		|";
		ПрофилиГруппДоступа = Запрос.Выполнить().Выгрузить();
	КонецЕсли; 
	РолиПользователей = Новый ТаблицаЗначений;
	РолиПользователей.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	РолиПользователей.Колонки.Добавить("Пользователь", Новый ОписаниеТипов("Строка"));
	Если ПравоДоступа("Администрирование", Метаданные) Тогда
		ДоступныеПользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Иначе
		ДоступныеПользователи = Новый Массив;
		ДоступныеПользователи.Добавить(ПользователиИнформационнойБазы.ТекущийПользователь());
	КонецЕсли; 
	Для Каждого ПользовательИБ Из ДоступныеПользователи Цикл
		#Если Сервер И Не Сервер Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
		#КонецЕсли
		Для Каждого РольЦикл Из ПользовательИБ.Роли Цикл
			СтрокаРоли = РолиПользователей.Добавить();
			СтрокаРоли.Роль = РольЦикл.Имя;
			СтрокаРоли.Пользователь = ПользовательИБ.Имя;
		КонецЦикла;
	КонецЦикла;
	ТаблицаРоли = Новый ТаблицаЗначений;
	ТаблицаРоли.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	ТаблицаРоли.Колонки.Добавить("УстанавливатьПраваДляНовыхОбъектов");
	ТаблицаРоли.Колонки.Добавить("НезависимыеПраваПодчиненныхОбъектов");
	ТаблицаРоли.Колонки.Добавить("УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию");
	Если ИзвлечьСвойстваРолей Тогда
		Для Каждого МетаРоль Из Роли Цикл
			ирПлатформа = ирКэш.Получить();
			#Если Сервер И Не Сервер Тогда
				ирПлатформа = Обработки.ирПлатформа.Создать();
			#КонецЕсли
			ФайлРоли = Новый Файл("" + ирПлатформа.СтруктураПодкаталоговФайловогоКэша.КэшРолей.ПолноеИмя + "\Роль." + МетаРоль.Имя + ".Права.xml");
			Если Не ФайлРоли.Существует() Тогда
				Сообщить("В кэше ролей не обнаружен файл роли """ + МетаРоль.Имя + """. Для извлечения свойств этой роли необходимо обновить кэш прав.");
				Продолжить;
			КонецЕсли; 
			СтрокаРоли = ТаблицаРоли.Добавить();
			СтрокаРоли.Роль = МетаРоль.Имя;
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.ОткрытьФайл(ФайлРоли.ПолноеИмя);
			ЧтениеXML.Прочитать();
			Для Счетчик = 1 По 3 Цикл
				ЧтениеXML.Прочитать();
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
					Если ЧтениеXML.ЛокальноеИмя = "setForNewObjects" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.УстанавливатьПраваДляНовыхОбъектов = Булево(ЧтениеXML.Значение);
					ИначеЕсли ЧтениеXML.ЛокальноеИмя = "setForAttributesByDefault" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.НезависимыеПраваПодчиненныхОбъектов = Булево(ЧтениеXML.Значение);
					ИначеЕсли ЧтениеXML.ЛокальноеИмя = "independentRightsOfChildObjects" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию = Булево(ЧтениеXML.Значение);
					КонецЕсли; 
					ЧтениеXML.Прочитать();
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
	КонецЕсли; 

	ФункциональныеОпции.Очистить();
	ФункциональныеОпцииПолей.Очистить();
	Если ВычислятьФункциональныеОпции Тогда
		Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
			СтрокаТаблицы = ФункциональныеОпции.Добавить();
			СтрокаТаблицы.ФункциональнаяОпция = ФункциональнаяОпция.Имя;
			СтрокаТаблицы.ФункциональнаяОпцияВключена = ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя);
		КонецЦикла;
		ДобавленныеОбъектыМД = Новый Соответствие;
		ИменаГруппировок = "ОбъектМетаданных, ТабличнаяЧасть, Поле, ПолеПолноеИмя";
		ПолныеИменаПолей = ТаблицаСтарая.Скопировать(, ИменаГруппировок);
		ПолныеИменаПолей.Свернуть(ИменаГруппировок);
		ВычисленныеФункОпцииРодительскихОбъектов = Новый Соответствие;
		Для Каждого СтрокаПоля Из ПолныеИменаПолей Цикл
			РодительскийОбъектМД = Метаданные.НайтиПоПолномуИмени(СтрокаПоля.ОбъектМетаданных);
			Если ЗначениеЗаполнено(СтрокаПоля.ТабличнаяЧасть) Тогда
				ТЧ_МД = РодительскийОбъектМД.ТабличныеЧасти.Найти(СтрокаПоля.ТабличнаяЧасть);
				Если ТЧ_МД <> Неопределено Тогда
					РодительскийОбъектМД = ТЧ_МД;
				КонецЕсли; 
			КонецЕсли; 
			ДочернийОбъектМД = ирОбщий.ДочернийОбъектМДПоИмениЛкс(РодительскийОбъектМД, СтрокаПоля.Поле);
			Если ДочернийОбъектМД <> Неопределено Тогда
				ОбъектМД = ДочернийОбъектМД;
				ПрямоеНазначение = Истина;
			Иначе
				Если ЗначениеЗаполнено(СтрокаПоля.Поле) Тогда
					Продолжить;
				КонецЕсли; 
				ОбъектМД = РодительскийОбъектМД;
				ПрямоеНазначение = Ложь;
			КонецЕсли; 
			ДобавленыСтроки = Ложь;
			ДобавленыСтрокиРодителя = Ложь;
			Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
				Если ФункциональнаяОпция.Состав.Содержит(ОбъектМД) Тогда
					СтрокаТаблицы = ФункциональныеОпцииПолей.Добавить();
					СтрокаТаблицы.ФункциональнаяОпция = ФункциональнаяОпция.Имя;
					СтрокаТаблицы.ПолеПолноеИмя = СтрокаПоля.ПолеПолноеИмя;
					СтрокаТаблицы.ПрямоеНазначение = ПрямоеНазначение = ЗначениеЗаполнено(СтрокаПоля.Поле);
					ДобавленыСтроки = Истина;
				КонецЕсли; 
			КонецЦикла;
			//Если Не ДобавленыСтроки Тогда
			//	// Если объект не входит в функциональные опции
			//	СтрокаТаблицы = ФункциональныеОпцииПолей.Добавить();
			//	СтрокаТаблицы.ФункциональнаяОпция = "";
			//	СтрокаТаблицы.ПолеПолноеИмя = СтрокаПоля.ПолеПолноеИмя;
			//	СтрокаТаблицы.ПрямоеНазначение = ПрямоеНазначение = ЗначениеЗаполнено(СтрокаПоля.Поле);
			//КонецЕсли;
		КонецЦикла;
	КонецЕсли; 

	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Пользователь", Пользователь,,, Ложь);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ОбъектМетаданных) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "ОбъектМетаданных", ОбъектМетаданных,,, Ложь);
	КонецЕсли; 
	Если ЗначениеЗаполнено(Роль) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Роль", Роль,,, Ложь);
	КонецЕсли; 
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ПрофилиГруппДоступа", ПрофилиГруппДоступа);
	ВнешниеНаборыДанных.Вставить("РолиПользователей", РолиПользователей);
	ВнешниеНаборыДанных.Вставить("Роли", ТаблицаРоли);
	ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаСтарая);
	ВнешниеНаборыДанных.Вставить("ФункциональныеОпции", ФункциональныеОпции);
	ВнешниеНаборыДанных.Вставить("ФункциональныеОпцииПолей", ФункциональныеОпцииПолей);
	Если РежимОтладки = 2 Тогда
		ирОбщий.ОтладитьЛкс(СхемаКомпоновкиДанных, , КонечнаяНастройка, ВнешниеНаборыДанных);
		Возврат;
	КонецЕсли; 
	ирОбщий.СкомпоноватьВТабличныйДокументЛкс(СхемаКомпоновкиДанных, КонечнаяНастройка, ДокументРезультат, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
КонецПроцедуры

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

РежимОтладки = 0;