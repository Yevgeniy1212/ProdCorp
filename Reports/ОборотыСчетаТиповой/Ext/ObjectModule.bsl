﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем РежимРасшифровки Экспорт;
Перем СохранятьНастройкуОтчета Экспорт;
Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем мСписокПодразделений Экспорт;
Перем мДеревоСтруктурныхЕдиниц Экспорт;
Перем ВедётсяУчетПоПодразделениям Экспорт;
Перем СохраненныйСчет Экспорт;
Перем ФормироватьДиаграмму Экспорт;
Перем ОтображатьОформление Экспорт;

#Если Клиент Тогда
	
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , КонецПериода);
	СписокПараметров.Вставить("СчетУчета"         , Счет);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	//СписокПараметров.Вставить("Организация"       , Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	СписокПараметров.Вставить("ЭтоНовыйДокумент"  , Ложь);
	
	Возврат СписокПараметров;
	
КонецФункции

Процедура ОбработкаИзмененияСчета(ПолнаяОбработка = Истина) Экспорт
	
	Если ЗначениеЗаполнено(Счет) Тогда
		
		КоличествоСубконто = Счет.ВидыСубконто.Количество();
		ИмяПоляПрефикс = "Субконто";
		
		ПараметрыОС      		= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыНМА     		= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыФизЛица 		= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыСтатейЗатрат 	= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыВидовДохода 	= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		
		МассивНаборовДанных = Новый Массив;
		МассивНаборовДанных.Добавить("ОсновнойНаборДанных");
		МассивНаборовДанных.Добавить("Обороты");
		
		// Изменение представления и наложения ограничения типа значения
		Для Индекс = 1 По КоличествоСубконто Цикл
			Для Каждого ЭлементМассива Из МассивНаборовДанных Цикл
				Набор = СхемаКомпоновкиДанных.НаборыДанных[ЭлементМассива];
				Поле = Набор.Поля.Найти(ИмяПоляПрефикс + Индекс);
				Если Поле <> Неопределено Тогда
					ТипЗначения = Счет.ВидыСубконто[Индекс - 1].ВидСубконто.ТипЗначения;
					Поле.ТипЗначения = ТипЗначения;
					Поле.Заголовок   = Счет.ВидыСубконто[Индекс - 1].ВидСубконто.Наименование;
				КонецЕсли;
				
				Если Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства")) Тогда
					ПараметрыОС.ИндексСубконто    = Индекс;
					ПараметрыОС.ЗаголовокСубконто = Поле.Заголовок;
				ИначеЕсли Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.НематериальныеАктивы")) Тогда
					ПараметрыНМА.ИндексСубконто    = Индекс;
					ПараметрыНМА.ЗаголовокСубконто = Поле.Заголовок;
				ИначеЕсли Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.СтатьиЗатрат")) Тогда
					ПараметрыСтатейЗатрат.ИндексСубконто    = Индекс;
					ПараметрыСтатейЗатрат.ЗаголовокСубконто = Поле.Заголовок;
				ИначеЕсли Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Доходы")) Тогда
					ПараметрыВидовДохода.ИндексСубконто    = Индекс;
					ПараметрыВидовДохода.ЗаголовокСубконто = Поле.Заголовок;
				ИначеЕсли Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ФизическиеЛица")) Тогда
					ПараметрыФизЛица.ИндексСубконто    = Индекс;
					ПараметрыФизЛица.ЗаголовокСубконто = Поле.Заголовок;
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;
		
		СтандартныеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(СхемаКомпоновкиДанных, "ДанныеОС"     , ПараметрыОС);
		СтандартныеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(СхемаКомпоновкиДанных, "ДанныеНМА"    , ПараметрыНМА);
		СтандартныеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(СхемаКомпоновкиДанных, "ДанныеФизЛица", ПараметрыФизЛица);
		СтандартныеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(СхемаКомпоновкиДанных, "ДанныеСтатейЗатрат", ПараметрыСтатейЗатрат);
		СтандартныеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(СхемаКомпоновкиДанных, "ДанныеВидовДохода", ПараметрыВидовДохода);
		
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
			
		Если ПолнаяОбработка Тогда
			
			// Управление показателями
			ДанныеОтчета.ПоказателиОтчета.БУ.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.БУ.Значение      = Истина;
			
			Если Счет.Валютный Тогда
				ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Использование = Истина;
				ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение      = Не УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ФормироватьОтчетыБезДанныхПоВалютам");			
			Иначе
				ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Использование = Ложь;
				ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение      = Ложь;		
			КонецЕсли;
			Если Счет.Количественный Тогда
				ДанныеОтчета.ПоказателиОтчета.Количество.Использование = Истина;
				ДанныеОтчета.ПоказателиОтчета.Количество.Значение      = Истина;		
			Иначе
				ДанныеОтчета.ПоказателиОтчета.Количество.Использование = Ложь;
				ДанныеОтчета.ПоказателиОтчета.Количество.Значение      = Ложь;	
			КонецЕсли;
			
			Если Счет.Вид = ВидСчета.АктивноПассивный Тогда
				ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Использование = Истина;
				ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Значение      = Ложь;		
			Иначе
				ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Использование = Ложь;
				ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Значение      = Ложь;	
			КонецЕсли;
			
			// Выводимые данные			
			СальдоНаНачалоДт   = Истина;
			СальдоНаНачалоКт   = Истина;
			СальдоНаКонецДт    = Истина;
			СальдоНаКонецКт    = Истина;
			ОборотыЗаПериодДт  = Истина;
			ОборотыЗаПериодКт  = Истина;
			ОборотыСоСчетамиДт = Истина;
			ОборотыСоСчетамиКт = Истина;
			
			// Добавление группировок с соответствии с выбранным счетом	
			ДанныеОтчета.Группировка.Очистить();
			
			
			Если ВедётсяУчетПоПодразделениям Тогда
				НоваяСтрока = ДанныеОтчета.Группировка.Добавить();
				НоваяСтрока.Поле           = "Подразделение";
				НоваяСтрока.Использование  = Истина;
				НоваяСтрока.Представление  = "Структурное подразделение";
				НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
				
				НоваяСтрока.Оформление  = Новый НастройкаОформления();
				Шрифт = НоваяСтрока.Оформление["Шрифт"];
				Шрифт.Использование = Истина;
				НоваяСтрока.ПоУмолчанию  = Истина;
				
				НастройкиФормы.Вставить("ДоступностьПодразделения", Истина);
			Иначе
				НастройкиФормы.Вставить("ДоступностьПодразделения", Ложь);	
			КонецЕсли;
			
			Если Счет.Валютный 
				И Не УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ФормироватьОтчетыБезДанныхПоВалютам") Тогда
				НоваяСтрока = ДанныеОтчета.Группировка.Добавить();
				НоваяСтрока.Поле = "Валюта";
				НоваяСтрока.Использование = Истина;
				НоваяСтрока.Представление = "Валюта";
				НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
				
				НоваяСтрока.Оформление  = Новый НастройкаОформления();
				Шрифт = НоваяСтрока.Оформление["Шрифт"];
				Шрифт.Использование = Истина;
				НоваяСтрока.ПоУмолчанию  = Истина;
			КонецЕсли;
			
			Для Индекс = 1 По КоличествоСубконто Цикл
				НоваяСтрока = ДанныеОтчета.Группировка.Добавить();
				Поле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
				НоваяСтрока.Поле           = Поле.Поле;
				НоваяСтрока.Использование  = Истина;
				НоваяСтрока.Представление  = Поле.Заголовок;
				НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
				
				НоваяСтрока.Оформление  = Новый НастройкаОформления();
				Шрифт = НоваяСтрока.Оформление["Шрифт"];
				Шрифт.Использование = Истина;
				НоваяСтрока.ПоУмолчанию  = Истина;
				
			КонецЦикла;	
			
			// Обработка дополнительных полей
			СтандартныеОтчеты.ЗаполнитьДополнительныеПоляПоУмолчанию(ЭтотОбъект);
			
			Если Не РежимРасшифровки Тогда
				СтандартныеОтчеты.ОбработатьОтборПриСменеСчета(СохраненныйСчет, Счет, КомпоновщикНастроек);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СохраненныйСчет = Счет;
	
КонецПроцедуры

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	СтандартныеОтчеты.ЗаполнитьДанныеОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено, ВыводитьПолностью = Истина) Экспорт
	
	Результат.Очистить();
	
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
	
КонецПроцедуры

Процедура ПередВыводомОтчета(МакетКомпоновки) Экспорт
	
	Для Каждого ЭлементТелаМакета Из МакетКомпоновки.Тело Цикл 
		Если ТипЗнч(ЭлементТелаМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ДанныеОтчета.Вставить("ВысотаШапки", МакетКомпоновки.Макеты[ЭлементТелаМакета.МакетШапки].Макет.Количество()); 
			Прервать;	
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПоСубсчетам И ФормироватьДиаграмму Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			Если ТипЗнч(Макет.Макет) = Тип("МакетГруппировкиДиаграммыОбластиКомпоновкиДанных")
				ИЛИ ТипЗнч(Макет.Макет) = Тип("МакетРесурсаДиаграммыОбластиКомпоновкиДанных") Тогда
				Для Каждого Параметр Из Макет.Параметры Цикл
					Если ТипЗнч(Параметр) = Тип("ПараметрОбластиРасшифровкаКомпоновкиДанных") Тогда
						ВыражениеПоля = Параметр.ВыраженияПолей.Добавить();	
						ВыражениеПоля.Поле      = "Счет";
						ВыражениеПоля.Выражение = "&Счет";
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ГруппировкаТелаКомпоновки Из МакетКомпоновки.Тело Цикл
		Если ТипЗнч(ГруппировкаТелаКомпоновки) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ДанныеОтчета.Вставить("ШиринаШапки", МакетКомпоновки.Макеты[ГруппировкаТелаКомпоновки.МакетШапки].Макет[0].Ячейки.Количество()); 
		КонецЕсли;
	КонецЦикла;
	
	// Форматирование шапки таблицы
	Для Каждого ЭлементТелаМакета Из МакетКомпоновки.Тело Цикл 
		Если ТипЗнч(ЭлементТелаМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			
			КолонкиОтчета = ЭлементТелаМакета.Колонки;
			Для Каждого КолонкаОтчета Из КолонкиОтчета Цикл
				Для Каждого ТелоКолонки Из КолонкаОтчета.Тело Цикл
			    	СтандартныеОтчеты.ОформитьКолонкуШапкиТаблицы(ТелоКолонки, МакетКомпоновки, Истина, Истина);
				КонецЦикла;
			КонецЦикла;
			
			ШапкаГруппировок = МакетКомпоновки.Макеты[ЭлементТелаМакета.МакетШапки].Макет;
			Для Каждого СтрокаГруппировки Из ШапкаГруппировок Цикл
				Ячейка = СтрокаГруппировки.Ячейки[0];
				СтандартныеОтчеты.ОформитьЯчейкуШапкиТаблицы(Ячейка, , Истина);
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт

	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ФормироватьДиаграмму Тогда
		СтандартныеОтчеты.ДобавитьДиаграммуВСтандартныеОтчеты(ЭтотОбъект);
	КонецЕсли;
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Счет"         , Счет);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(КонецПериода));
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(КонецПериода));
	Иначе
		ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	Если мДеревоСтруктурныхЕдиниц.Колонки.Количество() = 0 Тогда 
		
		СписокСтруктурныхЕдиниц = Новый СписокЗначений;
		СписокСтруктурныхЕдиниц.ЗагрузитьЗначения(мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
		
		Для Каждого СтрПодразделение Из мСписокПодразделений Цикл 
			СписокСтруктурныхЕдиниц.Добавить(СтрПодразделение.Значение);
		КонецЦикла;		
				
		мДеревоСтруктурныхЕдиниц = СтандартныеОтчеты.СформироватьДеревоСЕ(, СписокСтруктурныхЕдиниц);
		
	КонецЕсли;
	
	ТиповыеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, мДеревоСтруктурныхЕдиниц);
			
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("ВалютнаяСумма");
	МассивПоказателей.Добавить("Количество");
		
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;
	
	КоличествоПоказателей = СтандартныеОтчеты.КоличествоПоказателей(ЭтотОбъект);
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	// Колонка "показатели"
	Если КоличествоПоказателей > 1 Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "Показатели";
		Колонка.Использование = Истина;
		
		ГруппаПоказатели = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
		
	МассивПоказателейДоп = Новый Массив;
	МассивПоказателейДоп.Добавить("ВалютнаяСумма");
	МассивПоказателейДоп.Добавить("Количество");

	ВидОстатков = ?(ПоказателиОтчета.РазвернутоеСальдо.Значение, "Развернутый", "");
	
	// Колонка "Сальдо на начало Дт"
	Если СальдоНаНачалоДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "НачальноеСальдоДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатков + "ОстатокДт");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаНачалоПериода." + ЭлементМассива + "НачальныйОстатокДт");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на начало Кт"
	Если СальдоНаНачалоКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "НачальноеСальдоКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатков + "ОстатокКт");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаНачалоПериода." + ЭлементМассива + "НачальныйОстатокКт");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты за период Дт"
	Если ОборотыЗаПериодДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "ОборотДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты со счетами Дт"
	Если ОборотыСоСчетамиДт Тогда
		Если ОборотыЗаПериодДт Тогда 
			Колонка = Колонка.Структура.Добавить();
		Иначе 
			Колонка = Таблица.Колонки.Добавить();
		КонецЕсли;
		Колонка.Имя           = "КорСчетДт";
		Колонка.Использование = Истина;
		
		ПолеГруппировки = Колонка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		
		Если Не ПоСубсчетамКорСчетов Тогда
			ЗначениеОтбора = ТиповыеОтчеты.ДобавитьОтбор(Колонка.Отбор, "SystemFields.LevelInGroup", 1);
			ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
			ТиповыеОтчеты.УстановитьПараметрВывода(Колонка, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		КонецЕсли;
		
		ЭлементПорядка = Колонка.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Использование     = Истина;
		ЭлементПорядка.Поле              = Новый ПолеКомпоновкиДанных("КорСчет");
		ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
		ТиповыеОтчеты.УстановитьПараметрВывода(Колонка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
		
		ТиповыеОтчеты.ДобавитьВыбранноеПоле(Колонка.Выбор, "КорСчет");
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		ОтборГруппаИЛИ = Колонка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ОтборГруппаИЛИ.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		ОтборГруппаИЛИ.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт");
				ТиповыеОтчеты.ДобавитьОтбор(ОтборГруппаИЛИ, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт");
				ТиповыеОтчеты.ДобавитьОтбор(ОтборГруппаИЛИ, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты за период Кт"
	Если ОборотыЗаПериодКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "ОборотКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты со счетами Кт"
	Если ОборотыСоСчетамиКт Тогда
		Если ОборотыЗаПериодДт Тогда 
			Колонка = Колонка.Структура.Добавить();
		Иначе 
			Колонка = Таблица.Колонки.Добавить();
		КонецЕсли;
		Колонка.Имя           = "КорСчетКт";
		Колонка.Использование = Истина;
		
		ПолеГруппировки = Колонка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		
		Если Не ПоСубсчетамКорСчетов Тогда
			ЗначениеОтбора = ТиповыеОтчеты.ДобавитьОтбор(Колонка.Отбор, "SystemFields.LevelInGroup", 1);
			ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
			ТиповыеОтчеты.УстановитьПараметрВывода(Колонка, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		КонецЕсли;
		
		ЭлементПорядка = Колонка.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Использование     = Истина;
		ЭлементПорядка.Поле              = Новый ПолеКомпоновкиДанных("КорСчет");
		ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;

		ТиповыеОтчеты.УстановитьПараметрВывода(Колонка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
		
		ТиповыеОтчеты.ДобавитьВыбранноеПоле(Колонка.Выбор, "КорСчет");
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		ОтборГруппаИЛИ = Колонка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ОтборГруппаИЛИ.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		ОтборГруппаИЛИ.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт");
				ТиповыеОтчеты.ДобавитьОтбор(ОтборГруппаИЛИ, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт");
				ТиповыеОтчеты.ДобавитьОтбор(ОтборГруппаИЛИ, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	// Колонка "Сальдо на конец Дт"
	Если СальдоНаКонецДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "КонечноеСальдоДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаКонецПериода." + ЭлементМассива + "Конечный" + ВидОстатков + "ОстатокДт");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаКонецПериода." + ЭлементМассива + "КонечныйОстатокДт");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на конец Кт"
	Если СальдоНаКонецКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "КонечноеСальдоКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаКонецПериода." + ЭлементМассива + "Конечный" + ВидОстатков + "ОстатокКт");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ЭлементМассива Из МассивПоказателейДоп Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(Группа, "СальдоНаКонецПериода." + ЭлементМассива + "КонечныйОстатокКт");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	// Дополнительные данные
	СтандартныеОтчеты.ДобавитьДополнительныеПоля(ЭтотОбъект);
  
	Структура = Таблица.Строки.Добавить();
	ИспользоватьОформлениеГруппировок = НастройкиФормы.ИспользоватьОформлениеГруппировок;
	КоличествоГруппировок = ?(ПоСубсчетам, 1, 0);
	Для Каждого ПолеВыбраннойГруппировки Из ДанныеОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить();
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.ТолькоИерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
			КоличествоГруппировок = КоличествоГруппировок + 1;
			
			Если ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Счет") Тогда 
												
				Если Не ПоСубсчетам Тогда
					ЗначениеОтбора = ТиповыеОтчеты.ДобавитьОтбор(Структура.Отбор, "SystemFields.LevelInGroup", 1);
					ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
					ТиповыеОтчеты.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
				КонецЕсли;
				
			КонецЕсли;
			
			СтандартныеОтчеты.ДобавитьОформлениеГруппировки(ПолеВыбраннойГруппировки, Структура, , ИспользоватьОформлениеГруппировок);
		КонецЕсли;
	КонецЦикла;
	
	// Период
	Если Периодичность > 0 Тогда
		СтандартныеОтчеты.ДобавитьГруппировкуПоПериоду(ЭтотОбъект, Структура);
		СтандартныеОтчеты.ДобавитьОформлениеГруппировки( , Структура, КомпоновщикНастроек, ИспользоватьОформлениеГруппировок);
	КонецЕсли;

КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	 СтандартныеОтчеты.ВыводЗаголовкаОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Процедура ВыводПодписейОтчета(ОтчетОбъект, Результат)
	
	СтандартныеОтчеты.ВыводПодписейОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ЗаголовокОтчета = "Обороты счета " + Счет + СтандартныеОтчеты.ПолучитьПредставлениеПериода(ЭтотОбъект);

	Возврат ?(ОрганизацияВНачале, ЗаголовокОтчета, ЗаголовокОтчета + " " + СтандартныеОтчеты.ПолучитьТекстОрганизация(ЭтотОбъект));
	
КонецФункции

Процедура ПолучитьСтруктуруПоказателейОтчета() Экспорт
	
	ПоказателиОтчета = СтандартныеОтчеты.ПолучитьСтруктуруПоказателейОтчета(,,,,, Истина, Истина, Истина);
	ДанныеОтчета.Вставить("ПоказателиОтчета", ПоказателиОтчета);
	
КонецПроцедуры

Процедура ОбработкаРезультатаОтчета(Результат)
	
	СтандартныеОтчеты.ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);

	КоличествоПоказателей = СтандартныеОтчеты.КоличествоПоказателей(ЭтотОбъект);
	
	ДанныеОтчета.Вставить("КоличествоПоказателей", КоличествоПоказателей);

	Если ФормироватьДиаграмму Тогда
		СтандартныеОтчеты.ОбработкаРезультатаОтчетаСДиаграммой(ЭтотОбъект, Результат);
	КонецЕсли;
	
	СтандартныеОтчеты.ОбработкаИзмененияНастроекДиаграммы(ЭтотОбъект, Результат, ДанныеОтчета.ВысотаШапки, ?(КоличествоПоказателей > 1, ДанныеОтчета.ШиринаШапки + 1, ДанныеОтчета.ШиринаШапки));
	
КонецПроцедуры

// Для настройки отчета (расшифровка и др.)
Процедура Настроить() Экспорт
	
	ЗаполнитьНачальныеНастройки();
	ОбработкаИзмененияСчета(РежимРасшифровки);
	
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

СохраненныйСчет = ПланыСчетов.Типовой.ПустаяСсылка();

ОтображатьОформление = Ложь;

#КонецЕсли