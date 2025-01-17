﻿
Процедура OKНажатие(Кнопка)
	Отбор = Новый Структура;
	
	Если ДлительностьМин > 0 Тогда
		Отбор.Вставить("ДлительностьМин", ДлительностьМин);
	КонецЕсли;
	
	Если ДлительностьМин > 0 Тогда
		Отбор.Вставить("ДлительностьМакс", ДлительностьМакс);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Ключ) Тогда
		Отбор.Вставить("Ключ", Ключ);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Наименование) Тогда
		Отбор.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Метод) Тогда
		Отбор.Вставить("ИмяМетода", Метод);
	КонецЕсли;
	
	Если Регламентное <> Неопределено Тогда
		Отбор.Вставить("РегламентноеЗадание", Регламентное);
	КонецЕсли;
	
	Массив = Новый Массив;
	
	Если Активно Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.Активно);
	КонецЕсли;
	
	Если Завершено Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.Завершено);
	КонецЕсли;
	
	Если ЗавершеноТревожно Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.ЗавершеноАварийно);
	КонецЕсли;
	
	Если Отменено Тогда
		Массив.Добавить(СостояниеФоновогоЗадания.Отменено);
	КонецЕсли;
	
	Если Массив.Количество() > 0 ТОгда
		Отбор.Вставить("Состояние", Массив);
	КонецЕсли;
	
	Закрыть(Истина);
КонецПроцедуры

Процедура ПриОткрытии()
	Активно = Ложь;
	Завершено = Ложь;
	ЗавершеноТревожно = Ложь;
	Отменено = Ложь;
	
	Если Отбор <> Неопределено Тогда
		Для Каждого Свойство из Отбор Цикл
			Если Свойство.Ключ = "Начало" Тогда
				Начало = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Конец" Тогда
				Конец = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "ДлительностьМин" Тогда
				ДлительностьМин = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "ДлительностьМакс" Тогда
				ДлительностьМакс = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Конец" Тогда
				Конец = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Ключ" Тогда
				Ключ = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Наименование" Тогда
				Наименование = Свойство.Значение;	
			ИначеЕсли Свойство.Ключ = "ИмяМетода" Тогда
				Метод = Свойство.Значение;	
			ИначеЕсли Свойство.Ключ = "Ключ" Тогда
				Ключ = Свойство.Значение;	
			ИначеЕсли Свойство.Ключ = "РегламентноеЗадание" Тогда
				Регламентное = Свойство.Значение;
				Если Регламентное <> Неопределено Тогда
					СписокВыбора = ЭлементыФормы.Регламентное.СписокВыбора;
					Для Каждого ЭлементСписка из СписокВыбора Цикл
						Если ЭлементСписка.Значение.УникальныйИдентификатор = Регламентное.УникальныйИдентификатор ТОгда
							Регламентное = ЭлементСписка.Значение;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли; 
			ИначеЕсли Свойство.Ключ = "Состояние" Тогда
				Для Каждого СостояниеЗадания из Свойство.Значение Цикл
					Если СостояниеЗадания = СостояниеФоновогоЗадания.Активно Тогда
						Активно = Истина;
					ИначеЕсли СостояниеЗадания = СостояниеФоновогоЗадания.Завершено Тогда
						Завершено = Истина;
					ИначеЕсли СостояниеЗадания = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
						ЗавершеноТревожно = Истина;
					ИначеЕсли СостояниеЗадания = СостояниеФоновогоЗадания.Отменено Тогда
						Отменено = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(1);
	СписокВыбора.Добавить(10);
	СписокВыбора.Добавить(100);
	СписокВыбора.Добавить(1000);
	СписокВыбора.Добавить(10000);
	СписокВыбора.Добавить(100000);
	ЭлементыФормы.ДлительностьМин.СписокВыбора = СписокВыбора;
	ЭлементыФормы.ДлительностьМакс.СписокВыбора = СписокВыбора;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирКлиент.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирКлиент.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирКлиент.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольЗаданий.Форма.ДиалогОтбораФоновогоЗадания");

Регламентные = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
Для Каждого РегламентноеЗадание из Регламентные Цикл
	ЭлементыФормы.Регламентное.СписокВыбора.Добавить(РегламентноеЗадание, РегламентноеЗадание);
КонецЦикла;