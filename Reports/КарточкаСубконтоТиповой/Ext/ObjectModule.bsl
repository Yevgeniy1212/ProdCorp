﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем РежимРасшифровки Экспорт;
Перем СохранятьНастройкуОтчета Экспорт;
Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем мСписокПодразделений Экспорт;
Перем мДеревоСтруктурныхЕдиниц Экспорт;
Перем ВедётсяУчетПоПодразделениям Экспорт;

Перем мТекущийНаборПоказателей;

#Если Клиент Тогда

Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , КонецПериода);
	СписокПараметров.Вставить("СчетУчета"         , Неопределено);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	//СписокПараметров.Вставить("Организация"       , Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	СписокПараметров.Вставить("ЭтоНовыйДокумент"  , Ложь);
	
	Возврат СписокПараметров;
	
КонецФункции
	
Процедура ОбработкаИзмененияСоставаСубконто(ПолнаяОбработка = Истина) Экспорт
	
	МассивСубконто = Новый Массив;
	
	ИмяПоляПрефикс = "Субконто";
	
	// Изменение представления и наложения ограничения типа значения
	Индекс = 1;
	Для Каждого ВидСубконто Из СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ВидСубконто.Значение) Тогда
			МассивСубконто.Добавить(ВидСубконто.Значение);
			Поле = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти(ИмяПоляПрефикс + Индекс);
			Если Поле <> Неопределено Тогда
				Поле.ТипЗначения = ВидСубконто.Значение.ТипЗначения;
				Поле.Заголовок   = Строка(ВидСубконто.Значение);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;

	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Если ПолнаяОбработка Тогда
		
		// Управление показателями
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(ВС1.Ссылка.Количественный) КАК Количественный,
		|	МАКСИМУМ(ВС1.Ссылка.Валютный) КАК Валютный,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВС1.Ссылка) КАК КоличествоСчетов
		|ИЗ
		|	ПланСчетов.Типовой.ВидыСубконто КАК ВС1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК ВС2
		|		ПО ВС1.Ссылка = ВС2.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК ВС3
		|		ПО ВС1.Ссылка = ВС3.Ссылка
		|ГДЕ
		|	ВС1.ВидСубконто = &ВидСубконто1
		|	И ВС2.ВидСубконто = &ВидСубконто2
		|	И ВС3.ВидСубконто = &ВидСубконто3";
		Индекс = 3;
		Пока Индекс <> 0 Цикл
			Если Индекс > МассивСубконто.Количество() Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВС" + Индекс + ".ВидСубконто = &ВидСубконто" + Индекс, "ИСТИНА");	
			КонецЕсли;	
			Индекс = Индекс - 1;
		КонецЦикла;
		Для Индекс = 1 По МассивСубконто.Количество() Цикл
			Запрос.УстановитьПараметр("ВидСубконто" + Индекс, МассивСубконто[Индекс - 1]);
		КонецЦикла;
		
		ЕстьВалюта               = Ложь;
		ЕстьКоличество           = Ложь;
		ЕстьСчета                = Ложь;	
		ЕстьУчетПоПодразделениям = Ложь;
		
		Если СписокВидовСубконто.Количество() = 0 Тогда
			ЕстьВалюта               = Истина;
			ЕстьКоличество           = Истина;
			ЕстьСчета                = Истина;
			ЕстьУчетПоПодразделениям = Истина;
		Иначе
			ВыборкаСчета = Запрос.Выполнить().Выбрать();
			Пока ВыборкаСчета.Следующий() Цикл
				ЕстьВалюта               = ?(ВыборкаСчета.Валютный              = Истина, Истина, Ложь);
				ЕстьКоличество           = ?(ВыборкаСчета.Количественный        = Истина, Истина, Ложь);
				ЕстьСчета                = ?(ВыборкаСчета.КоличествоСчетов      = 0     , Ложь  , Истина);  
				ЕстьУчетПоПодразделениям = ВедётсяУчетПоПодразделениям;
			КонецЦикла;
		КонецЕсли;
		
		ДанныеОтчета.ПоказателиОтчета.БУ.Использование = Истина;
		ДанныеОтчета.ПоказателиОтчета.БУ.Значение      = Истина;
							
		Если Не ЕстьСчета Тогда
			ДанныеОтчета.ПоказателиОтчета.БУ.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.БУ.Значение      = Ложь;
		КонецЕсли;
		
		Если ЕстьВалюта Тогда
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение      = Истина;			
		Иначе
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение      = Ложь;		
		КонецЕсли;
		Если ЕстьКоличество Тогда
			ДанныеОтчета.ПоказателиОтчета.Количество.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.Количество.Значение      = Истина;		
		Иначе
			ДанныеОтчета.ПоказателиОтчета.Количество.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.Количество.Значение      = Ложь;	
		КонецЕсли;
		
		Если ЕстьУчетПоПодразделениям Тогда
			НастройкиФормы.Вставить("ДоступностьПодразделения", Истина);
		Иначе
			НастройкиФормы.Вставить("ДоступностьПодразделения", Ложь);	
		КонецЕсли;
				
		КоличествоСубконто = МассивСубконто.Количество();
		
		Если Не РежимРасшифровки Тогда 
			// Добавление неактивных отборов по субконто в соответствии с выбранным счетом
			ОтборыДляУдаления = Новый Массив;
			Для Каждого ЭлементОтбора Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
				Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
					Если Найти(ЭлементОтбора.ЛевоеЗначение, "Субконто") > 0 ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "Валюта"
						ИЛИ (Найти(ЭлементОтбора.ЛевоеЗначение, "Подразделение") = 1 И НЕ ЕстьУчетПоПодразделениям) Тогда
						ОтборыДляУдаления.Добавить(ЭлементОтбора);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого ЭлементОтбора Из ОтборыДляУдаления Цикл
				КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
			КонецЦикла;
			
			Для Индекс = 1 По МассивСубконто.Количество() Цикл
				Поле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
				ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек, ИмяПоляПрефикс + Индекс, МассивСубконто[Индекс - 1].ТипЗначения.ПривестиЗначение(Неопределено), , Ложь);	
			КонецЦикла;
			
			Если Не ЕстьУчетПоПодразделениям Тогда
				Подразделение = Неопределено;
			КонецЕсли;
						
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	СтандартныеОтчеты.ЗаполнитьДанныеОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено, ВыводитьПолностью = Истина) Экспорт
	
	Результат.Очистить();
	
	Если ДанныеОтчета.ПоказателиОтчета.БУ.Использование Тогда 
		
		Настройки = КомпоновщикНастроек.ПолучитьНастройки();
		ВыводЗаголовкаОтчета(ЭтотОбъект, Результат);
		Если ВыводитьПолностью Тогда
			ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
			КомпоновщикНастроек.Восстановить();
			НастройкаКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
			КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
			СтандартныеОтчеты.ВывестиОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных, Истина, НастройкаКомпоновкиДанных);
		КонецЕсли; 
		ВыводПодписейОтчета(ЭтотОбъект, Результат);
		
		УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(Результат, ПолучитьТекстЗаголовка(), Строка(глТекущийПользователь));
		
		Если ВыводитьПолностью Тогда
			// Выполним дополнительную обработку Результата отчета
			ОбработкаРезультатаОтчета(Результат);
			
			// Сохраним настройки для Истории
			ДополнительныеПоля = Новый СписокЗначений;
			ДополнительныеПоля.Добавить(мСписокСтруктурныхЕдиниц, "мСписокСтруктурныхЕдиниц");
			ДополнительныеПоля.Добавить(мДеревоСтруктурныхЕдиниц, "мДеревоСтруктурныхЕдиниц");
			ДополнительныеПоля.Добавить(мСписокПодразделений, "мСписокПодразделений");
			СтандартныеОтчеты.СохранитьНастройкуДляИстории(ЭтотОбъект, ДополнительныеПоля);
		КонецЕсли;
		
	Иначе 
		
		Сообщить("Внимание!!! Не найдено счетов с указанным Вами набором субконто.", СтатусСообщения.Внимание);
		
	КонецЕсли;
		
	
КонецПроцедуры

Процедура ПередВыводомОтчета(МакетКомпоновки) Экспорт
	
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;
	
	КоличествоПоказателей = 0;
	Для Каждого Показатель Из ПоказателиОтчета Цикл
		Если Показатель.Значение.Значение Тогда
			КоличествоПоказателей = КоличествоПоказателей + 1;
		КонецЕсли;
	КонецЦикла;
	
	// Если показатель один, то удалим столбик "Показатель"
	Если КоличествоПоказателей = 1 Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			Для Каждого СтрокаМакета Из Макет.Макет Цикл
				СтрокаМакета.Ячейки.Удалить(СтрокаМакета.Ячейки[4]);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	МакетПроводки = СтандартныеОтчеты.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Проводки", Истина);
	
	Если МакетПроводки.Количество() = 1 Тогда
		МакетПроводки = МакетПроводки[0];
		ДанныеОтчета.Вставить("МакетПроводок", МакетПроводки.Имя);
	КонецЕсли;
	
	// Форматирование шапки таблицы
	ШапкаТаблицы = МакетКомпоновки.Макеты[МакетКомпоновки.Тело[0].Макет].Макет;
	Для Каждого СтрокаГруппировки Из ШапкаТаблицы Цикл
		Для Каждого Ячейка Из СтрокаГруппировки.Ячейки Цикл
			СтандартныеОтчеты.ОформитьЯчейкуШапкиТаблицы(Ячейка, Истина, Истина);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт
	
	Если ЭлементРезультата.Макет = ДанныеОтчета.МакетПроводок Тогда 
		Если ЭлементРезультата.ЗначенияПараметров.П1.Значение = null Тогда
			Отказ = Истина;
		КонецЕсли;                                                          
	КонецЕсли;
			
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НачалоПериода));
	Иначе
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
	КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(КонецПериода));
	Иначе
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
	КонецЕсли;
	
	ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек.Настройки.Структура[0].Структура[0].Отбор, "ПериодГруппировки",,ВидСравненияКомпоновкиДанных.Заполнено);
	ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек.Настройки.Структура[0].Структура[0].Структура[0].Отбор, "Регистратор",,ВидСравненияКомпоновкиДанных.Заполнено);
	ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек.Настройки.Структура[1].Структура[0].Отбор, "Регистратор",,ВидСравненияКомпоновкиДанных.Заполнено);

	ТиповыеОтчеты.УстановитьПараметрВывода(КомпоновщикНастроек.Настройки.Структура[0].Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ТиповыеОтчеты.УстановитьПараметрВывода(КомпоновщикНастроек.Настройки.Структура[0].Структура[0].Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ТиповыеОтчеты.УстановитьПараметрВывода(КомпоновщикНастроек.Настройки.Структура[1].Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);

	Если Периодичность = 0 Тогда
		КомпоновщикНастроек.Настройки.Структура[0].Использование = Ложь;
		КомпоновщикНастроек.Настройки.Структура[1].Использование = Истина;
	Иначе
		КомпоновщикНастроек.Настройки.Структура[0].Использование = Истина;
		КомпоновщикНастроек.Настройки.Структура[1].Использование = Ложь;
	КонецЕсли;
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ПС", Символы.ПС);
	
	Если мДеревоСтруктурныхЕдиниц.Колонки.Количество() = 0 Тогда 
		
		СписокСтруктурныхЕдиниц = Новый СписокЗначений;
		СписокСтруктурныхЕдиниц.ЗагрузитьЗначения(мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
		
		Для Каждого СтрПодразделение Из мСписокПодразделений Цикл 
			СписокСтруктурныхЕдиниц.Добавить(СтрПодразделение.Значение);
		КонецЦикла;		
				
		мДеревоСтруктурныхЕдиниц = СтандартныеОтчеты.СформироватьДеревоСЕ(, СписокСтруктурныхЕдиниц);
		
	КонецЕсли;

	ТиповыеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, мДеревоСтруктурныхЕдиниц, , Истина);
		
	МассивВидовСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивВидовСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивВидовСубконто.Количество() > 0 Тогда
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "СписокВидовСубконто", МассивВидовСубконто);
	КонецЕсли;
	
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;
	
	ЛинияСплошная = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("ВалютнаяСумма");
	МассивПоказателей.Добавить("Количество");
	
	ТекущийНаборПоказателей = "" + ПоказателиОтчета.БУ.Значение + ПоказателиОтчета.ВалютнаяСумма.Значение + ПоказателиОтчета.Количество.Значение;
	Если ТекущийНаборПоказателей <> мТекущийНаборПоказателей Тогда
		
		МассивМакетов = Новый Массив;
		МассивМакетов.Добавить("ПериодГруппировкиЗаголовок"); 
		МассивМакетов.Добавить("ОбщиеИтогиЗаголовок");
		МассивМакетов.Добавить("ОбщиеИтогиПодвал");
		МассивМакетов.Добавить("ПроводкиЗаголовок");	
				
		Для Каждого ЭлементМакет Из МассивМакетов Цикл
			СхемаКомпоновкиДанных.Макеты[ЭлементМакет].Макет = СтандартныеОтчеты.ПолучитьКопиюОписанияМакета(СхемаКомпоновкиДанных.Макеты[ЭлементМакет + "Образец"].Макет);
			ОписаниеМакета = СхемаКомпоновкиДанных.Макеты[ЭлементМакет].Макет;
			
			МассивСтрокДляУдаления = Новый Массив;
			Индекс = 0;
			Для Каждого ЭлементМассива Из МассивПоказателей Цикл
				Если Не ПоказателиОтчета[ЭлементМассива].Значение Тогда 
					МассивСтрокДляУдаления.Добавить(ОписаниеМакета[Индекс]);
				КонецЕсли;
				Индекс = Индекс + 1;
			КонецЦикла;	
			
			Для Каждого Строка Из МассивСтрокДляУдаления Цикл
				ОписаниеМакета.Удалить(Строка);
			КонецЦикла;
			
			КоличествоСтрок = ОписаниеМакета.Количество();
			
			// Обвести область
			Если КоличествоСтрок > 0 Тогда
				Для Индекс = 0 По 12 Цикл
					ПоследняяСтрока = ?(ЭлементМакет = "ОбщиеИтогиПодвал" И Индекс < 4, 0, КоличествоСтрок - 1);
					ПараметрГраницы = ТиповыеОтчеты.ПолучитьПараметр(ОписаниеМакета[0].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
					ТиповыеОтчеты.УстановитьПараметр(ПараметрГраницы.ЗначенияВложенныхПараметров, "СтильГраницы.Сверху", ЛинияСплошная);
					ПараметрГраницы = ТиповыеОтчеты.ПолучитьПараметр(ОписаниеМакета[ПоследняяСтрока].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
					ТиповыеОтчеты.УстановитьПараметр(ПараметрГраницы.ЗначенияВложенныхПараметров, "СтильГраницы.Снизу", ЛинияСплошная);	
				КонецЦикла;
			КонецЕсли;
			
			Для Индекс = 1 По КоличествоСтрок - 1 Цикл
				ОписаниеМакета[Индекс].Ячейки[0].Элементы.Очистить();	
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
				ОписаниеМакета[Индекс].Ячейки[1].Элементы.Очистить();
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
				ОписаниеМакета[Индекс].Ячейки[2].Элементы.Очистить();
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
				ОписаниеМакета[Индекс].Ячейки[3].Элементы.Очистить();
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
				Если ЭлементМакет = "ПроводкиЗаголовок" Тогда
					ОписаниеМакета[Индекс].Ячейки[5].Элементы.Очистить();
					ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
					ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
					ОписаниеМакета[Индекс].Ячейки[8].Элементы.Очистить();
					ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
					ТиповыеОтчеты.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		мТекущийНаборПоказателей = ТекущийНаборПоказателей;
	КонецЕсли;
	
	Если Не ПоказателиОтчета.БУ.Значение Тогда
		ГруппаОтборов = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтборов.Использование = Истина;
		ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ЭлементМассива <> "БУ" И ПоказателиОтчета[ЭлементМассива].Значение Тогда
				ТиповыеОтчеты.ДобавитьОтбор(ГруппаОтборов, ЭлементМассива + "Дт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
				ТиповыеОтчеты.ДобавитьОтбор(ГруппаОтборов, ЭлементМассива + "Кт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	 СтандартныеОтчеты.ВыводЗаголовкаОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Процедура ВыводПодписейОтчета(ОтчетОбъект, Результат)
	
	СтандартныеОтчеты.ВыводПодписейОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ТекстСубконто = "";
	Для Каждого ВидСубконто Из СписокВидовСубконто Цикл
		ТекстСубконто = ТекстСубконто + ВидСубконто + ", ";	
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстСубконто) Тогда
		ТекстСубконто = Лев(ТекстСубконто, СтрДлина(ТекстСубконто) - 2);
	КонецЕсли;
	
	ЗаголовокОтчета = "Карточка субконто " + ТекстСубконто + СтандартныеОтчеты.ПолучитьПредставлениеПериода(ЭтотОбъект);

	Возврат ?(ОрганизацияВНачале, ЗаголовокОтчета, ЗаголовокОтчета + " " + СтандартныеОтчеты.ПолучитьТекстОрганизация(ЭтотОбъект));
	
КонецФункции

Процедура ПолучитьСтруктуруПоказателейОтчета() Экспорт
	
	ПоказателиОтчета = СтандартныеОтчеты.ПолучитьСтруктуруПоказателейОтчета(,,,, Ложь, Истина, Истина, Ложь);
	ДанныеОтчета.Вставить("ПоказателиОтчета", ПоказателиОтчета);

КонецПроцедуры

Процедура ОбработкаРезультатаОтчета(Результат)
	
	СтандартныеОтчеты.ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);

	// Зафиксируем заголовок отчета
	ВысотаЗаголовка = Результат.Области.Заголовок.Низ;
	Результат.ФиксацияСверху = ВысотаЗаголовка + 2;
	
КонецПроцедуры

// Для настройки отчета (расшифровка и др.)
Процедура Настроить() Экспорт
	
	ЗаполнитьНачальныеНастройки();
	ОбработкаИзмененияСоставаСубконто(РежимРасшифровки);
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	//Если СохранятьНастройкуОтчета Тогда
		//сохраним список структурных единиц
		ДополнительныеПоля = Новый СписокЗначений;
		ДополнительныеПоля.Добавить(мСписокСтруктурныхЕдиниц, "мСписокСтруктурныхЕдиниц");
		ДополнительныеПоля.Добавить(мДеревоСтруктурныхЕдиниц, "мДеревоСтруктурныхЕдиниц");
		ДополнительныеПоля.Добавить(мСписокПодразделений, "мСписокПодразделений");
		СтандартныеОтчеты.СохранитьНастройку(ЭтотОбъект, ДополнительныеПоля);
	//КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	
	Если СтруктураПараметров.Количество() = 1
		 И СтруктураПараметров.Свойство("НастройкиФормы") Тогда
		НастройкиФормы = СтруктураПараметров.НастройкиФормы;
		СохраненнаяНастройка = Неопределено;
	КонецЕсли;
	
	Если РежимРасшифровки Тогда
		НастройкиФормы = СтруктураПараметров.НастройкиФормы;
	Иначе
		ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	СтандартныеОтчеты.ИнициализацияОтчета(ЭтотОбъект);
	
КонецПроцедуры

Расшифровки = Новый СписокЗначений;
мСписокСтруктурныхЕдиниц = Новый СписокЗначений;
мСписокПодразделений = Новый СписокЗначений;
мДеревоСтруктурныхЕдиниц = Новый ДеревоЗначений;

ВедётсяУчетПоПодразделениям = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();

НастройкаПериода = Новый НастройкаПериода;

РежимРасшифровки = Ложь;

#КонецЕсли