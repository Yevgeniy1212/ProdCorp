﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем РежимРасшифровки Экспорт;
Перем мДеревоСтруктурныхЕдиниц Экспорт;
Перем СохранятьНастройкуОтчета Экспорт;
Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем мСписокПодразделений Экспорт;
Перем ВедётсяУчетПоПодразделениям Экспорт;
Перем СохраненныйСчет Экспорт;
Перем ОтображатьОформление Экспорт;

#Если Клиент Тогда

//
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , КонецПериода);
	СписокПараметров.Вставить("СчетУчета"         , Счет);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	СписокПараметров.Вставить("ЭтоНовыйДокумент"  , Ложь);
	
	Возврат СписокПараметров;
	
КонецФункции
//
Процедура ОбработкаИзмененияСчета(ПолнаяОбработка = Истина) Экспорт
	
	Если ЗначениеЗаполнено(Счет) Тогда
		
		КоличествоСубконто = Счет.ВидыСубконто.Количество();
		
		ИмяПоляПрефикс = "Субконто";
		
		ПараметрыОС      		= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыНМА     		= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыФизЛица 		= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыСтатейЗатрат 	= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		ПараметрыВидовДохода 	= Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		
		// Изменение представления и наложения ограничения типа значения
		Для Индекс = 1 По КоличествоСубконто Цикл
			Поле = СхемаКомпоновкиДанных.НаборыДанных.ОсновнойНаборДанных.Поля.Найти(ИмяПоляПрефикс + Индекс);
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
			
			// Добавление группировок с соответствии с выбранным счетом	
			ДанныеОтчета.Группировка.Очистить();
			
			Если ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений() Тогда
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

	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;	
	
	МакетШапкиОтчета = СтандартныеОтчеты.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = СтандартныеОтчеты.КоличествоПоказателей(ЭтотОбъект);
	
	КоличествоГруппировок = 1;
	Для Каждого Группировка Из ДанныеОтчета.Группировка Цикл
		Если Группировка.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 2);
	ДанныеОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки);
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 2 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = КоличествоКолонок - 6 По КоличествоКолонок - 1 Цикл
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			ТиповыеОтчеты.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
	
	Если КоличествоПоказателей > 1 Тогда
		Для ИндексСтроки = 1 По КоличествоСтрок - 1 Цикл
			СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
			
			КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
			Ячейка = СтрокаМакета.Ячейки[КоличествоКолонок - 7];
			ТиповыеОтчеты.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЕсли;
	
	МакетПодвалаОтчета            = СтандартныеОтчеты.ПолучитьМакетПодвала(МакетКомпоновки);
	МакетГруппировкиОрганизация   = СтандартныеОтчеты.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация");
	МакетГруппировкиСчет          = СтандартныеОтчеты.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет");
	МакетГруппировкиПодразделение = СтандартныеОтчеты.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Подразделение");
	МакетГруппировкиВалюта        = СтандартныеОтчеты.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта");
	
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
	// Форматирование заголовков колонок таблицы
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 0 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = 0 По КоличествоКолонок - 1 Цикл
			
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			СтандартныеОтчеты.ОформитьЯчейкуШапкиТаблицы(Ячейка, ?(ИндексКолонки = 0, Ложь, Истина), Истина);

		КонецЦикла;
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	
	Если ПоказателиОтчета.РазвернутоеСальдо.Значение Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			Если ТипЗнч(Макет.Макет) = Тип("МакетОбластиКомпоновкиДанных") 
				И Макет <> МакетШапкиОтчета
				И Макет <> МакетПодвалаОтчета Тогда
				Если Макет.Макет.Количество() > 1 Тогда
					Для Счетчик = 1 По КоличествоПоказателей Цикл
						Макет.Макет.Удалить(Макет.Макет[Макет.Макет.Количество() - 1]);		
					КонецЦикла;		
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		МассивСтрокДляПеремещения = Новый Массив;
		Для Счетчик = КоличествоПоказателей + 1 По МакетПодвалаОтчета.Макет.Количество() Цикл
			МассивСтрокДляПеремещения.Добавить(МакетПодвалаОтчета.Макет[Счетчик - 1]);
		КонецЦикла;
		
		Для Каждого СтрокаМакета Из МассивСтрокДляПеремещения Цикл
			МакетПодвалаОтчета.Макет.Сдвинуть(СтрокаМакета, -КоличествоПоказателей);			
		КонецЦикла;
		
		// Добавим надпись "Итого развернутое" в подвал
		Для Счетчик = 0 По КоличествоКолонок - 7 Цикл
			Ячейка = МакетПодвалаОтчета.Макет[0].Ячейки[Счетчик];
			ТиповыеОтчеты.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Ложь);
		КонецЦикла;
		Ячейка = МакетПодвалаОтчета.Макет[0].Ячейки[0];
		НовыйЭлемент = Ячейка.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
		НовыйЭлемент.Значение = "Итого";
		
		Ячейка = МакетПодвалаОтчета.Макет[КоличествоПоказателей].Ячейки[0];
		Ячейка.Элементы.Очистить();
		НовыйЭлемент = Ячейка.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
		НовыйЭлемент.Значение = "Итого развернутое";
	КонецЕсли;
	
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		Если Макет = МакетШапкиОтчета Тогда
		Иначе
			Индекс = -1;			
			Для Каждого ЭлементМассива Из МассивПоказателей Цикл
				Если ПоказателиОтчета[ЭлементМассива].Значение Тогда
					Индекс = Индекс + 1;
				КонецЕсли;
			КонецЦикла;
			//Если ПоказателиОтчета.Контроль.Значение Тогда 
			//	Индекс = Индекс + 1;					
			//КонецЕсли;
			
			Если ПоказателиОтчета.ВалютнаяСумма.Значение И КоличествоПоказателей = 1 Тогда 
				
			ИначеЕсли ПоказателиОтчета.ВалютнаяСумма.Значение Тогда
				Индекс = Индекс + 1;				
				Если МакетГруппировкиВалюта.Найти(Макет) <> Неопределено ИЛИ Макет = МакетПодвалаОтчета Тогда
			
				Иначе
					Макет.Макет.Удалить(Макет.Макет[Индекс]);
					Индекс = Индекс - 1;
				КонецЕсли;
			КонецЕсли;
			
			Если ПоказателиОтчета.Количество.Значение Тогда
				Индекс = Индекс + 1;
				Если МакетГруппировкиВалюта.Найти(Макет) <> Неопределено Тогда
					Макет.Макет.Удалить(Макет.Макет[Индекс]);
				КонецЕсли;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПоСубсчетам Тогда
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
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	СтандартныеОтчеты.ДобавитьДиаграммуВСтандартныеОтчеты(ЭтотОбъект);
	
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
			
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ЭлиминироватьСчета", ЭлиминироватьСчета);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КорСчет", СчетаЭлиминации.ВыгрузитьЗначения());
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("ВалютнаяСумма");
	МассивПоказателей.Добавить("Количество");
		
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;
	
	КоличествоПоказателей = СтандартныеОтчеты.КоличествоПоказателей(ЭтотОбъект);
	
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = "Показатели";
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Если ПоказателиОтчета.РазвернутоеСальдо.Значение Тогда
			Для Каждого ЭлементМассива Из МассивПоказателей Цикл
				Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
					Если КоличествоПоказателей > 1 Тогда
						ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива + "Развернутый");
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	ГруппаСальдоНаНачало = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачало.Заголовок     = "Сальдо на начало периода";
	ГруппаСальдоНаНачало.Использование = Истина;
	ГруппаСальдоНаНачалоДт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоДт.Заголовок     = "Дебет";
	ГруппаСальдоНаНачалоДт.Использование = Истина;
	ГруппаСальдоНаНачалоДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаНачалоКт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоКт.Заголовок     = "Кредит";
	ГруппаСальдоНаНачалоКт.Использование = Истина;
	ГруппаСальдоНаНачалоКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаОбороты = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОбороты.Заголовок     = "Обороты за период";
	ГруппаОбороты.Использование = Истина;
	ГруппаОборотыДт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыДт.Заголовок     = "Дебет";
	ГруппаОборотыДт.Использование = Истина;
	ГруппаОборотыДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаОборотыКт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыКт.Заголовок     = "Кредит";
	ГруппаОборотыКт.Использование = Истина;
	ГруппаОборотыКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСальдоНаКонец = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонец.Заголовок     = "Сальдо на конец периода";
	ГруппаСальдоНаКонец.Использование = Истина;
	ГруппаСальдоНаКонецДт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецДт.Заголовок     = "Дебет";
	ГруппаСальдоНаКонецДт.Использование = Истина;
	ГруппаСальдоНаКонецДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаКонецКт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецКт.Заголовок     = "Кредит";
	ГруппаСальдоНаКонецКт.Использование = Истина;
	ГруппаСальдоНаКонецКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
		
	ВидОстатка = "Развернутый";
	Если ПоказателиОтчета.РазвернутоеСальдо.Значение Тогда
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатка + "ОстатокДт");
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатка + "ОстатокКт");
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ЭлементМассива + ВидОстатка + "ОборотДт");
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ЭлементМассива + ВидОстатка + "ОборотКт");
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатка + "ОстатокДт");
				ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатка + "ОстатокКт");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ВидОстатка = "";	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
			ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатка + "ОстатокДт");
			ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатка + "ОстатокКт");
			ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотДт");
			ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотКт");
			ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатка + "ОстатокДт");
			ТиповыеОтчеты.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатка + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	// Дополнительные данные
	СтандартныеОтчеты.ДобавитьДополнительныеПоля(ЭтотОбъект);
  
	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ИспользоватьОформлениеГруппировок = НастройкиФормы.ИспользоватьОформлениеГруппировок;
	Для Каждого ПолеВыбраннойГруппировки Из ДанныеОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
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
	
	Если мДеревоСтруктурныхЕдиниц.Колонки.Количество() = 0 Тогда 
		
		СписокСтруктурныхЕдиниц = Новый СписокЗначений;
		СписокСтруктурныхЕдиниц.ЗагрузитьЗначения(мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
		
		Для Каждого СтрПодразделение Из мСписокПодразделений Цикл 
			СписокСтруктурныхЕдиниц.Добавить(СтрПодразделение.Значение);
		КонецЦикла;		
				
		мДеревоСтруктурныхЕдиниц = СтандартныеОтчеты.СформироватьДеревоСЕ(, СписокСтруктурныхЕдиниц);
		
	КонецЕсли;
	
	ТиповыеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, мДеревоСтруктурныхЕдиниц);
			  		
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	 СтандартныеОтчеты.ВыводЗаголовкаОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Процедура ВыводПодписейОтчета(ОтчетОбъект, Результат)
	
	СтандартныеОтчеты.ВыводПодписейОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ЗаголовокОтчета = "Оборотно-сальдовая ведомость по счету " + Счет + СтандартныеОтчеты.ПолучитьПредставлениеПериода(ЭтотОбъект);

	Возврат ?(ОрганизацияВНачале, ЗаголовокОтчета, ЗаголовокОтчета + " " + СтандартныеОтчеты.ПолучитьТекстОрганизация(ЭтотОбъект));
	
КонецФункции

Процедура ПолучитьСтруктуруПоказателейОтчета() Экспорт
	
	ПоказателиОтчета = СтандартныеОтчеты.ПолучитьСтруктуруПоказателейОтчета(,,,,, Истина, Истина, Истина);
	ДанныеОтчета.Вставить("ПоказателиОтчета", ПоказателиОтчета);
	
КонецПроцедуры

Процедура ОбработкаРезультатаОтчета(Результат)
	
	СтандартныеОтчеты.ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);

	СтандартныеОтчеты.ОбработкаРезультатаОтчетаСДиаграммой(ЭтотОбъект, Результат);
	
	СтандартныеОтчеты.ОбработкаИзмененияНастроекДиаграммы(ЭтотОбъект, Результат, ДанныеОтчета.ВысотаШапки);
	
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
мСписокСтруктурныхЕдиниц 	= Новый СписокЗначений;
мСписокПодразделений 		= Новый СписокЗначений;
мДеревоСтруктурныхЕдиниц 	= Новый ДеревоЗначений;

ВедётсяУчетПоПодразделениям = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();


НастройкаПериода = Новый НастройкаПериода;

РежимРасшифровки = Ложь;

СохраненныйСчет = ПланыСчетов.Типовой.ПустаяСсылка();

ОтображатьОформление = Ложь;

#КонецЕсли