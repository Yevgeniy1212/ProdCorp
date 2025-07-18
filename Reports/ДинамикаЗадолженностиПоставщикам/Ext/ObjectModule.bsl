﻿Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем СписокКонтрагентов Экспорт;

#Если Клиент Тогда

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	// Проверим заполнение обязательных реквизитов
	Если ПроверитьЗаполнениеОбязательныхРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
	ВыводЗаголовкаОтчета(ЭтотОбъект, Результат);
	ОтчетыДляРуководителя.ВывестиОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	
	// Выполним дополнительную обработку Результата отчета
	ОбработкаРезультатаОтчета(Результат);
	
	Возврат;
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Интервал);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(КонецПериода));
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "СписокСчетовКтЗадолженности", ОтчетыДляРуководителя.ВозвратитьМассивСчетовДтКтЗадолженности(Истина,Истина,Истина));
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "СчетаПользователя"          , ОтчетыДляРуководителя.ПолучитьСписокСчетовПользователяДляРасчетаЗадолженности(2));
	
	ИсключенныеСчета = ОтчетыДляРуководителя.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(2);
	Если ЗначениеЗаполнено(ИсключенныеСчета) Тогда
		ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек, "Счет", ИсключенныеСчета, ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мСписокСтруктурныхЕдиниц) Тогда
		ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек, "Организация", мСписокСтруктурныхЕдиниц, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
	ТипДополнения = ОтчетыДляРуководителя.ПолучитьТипДополненияПоИнтервалу(Интервал);
	
	Для каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
	
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") Тогда
			ОтчетыДляРуководителя.УстановитьДополнениеПоляГруппировки(ЭлементСтруктуры, ТипДополнения);
		Иначе
			Если ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
				ЭлементГруппировок = ЭлементСтруктуры.Точки;
			ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
				ЭлементГруппировок = ЭлементСтруктуры.Колонки;
			Иначе 
				Возврат;
			КонецЕсли;
			Для каждого Группировка Из ЭлементГруппировок Цикл
				ОтчетыДляРуководителя.УстановитьДополнениеПоляГруппировки(Группировка, ТипДополнения);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	ТиповыеОтчеты.ДоработатьТиповойОтчетПередВыводом(ЭтотОбъект);
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	МакетЗаголовок = ПолучитьОбщийМакет("ЗаголовокОтчета");
	ОбластьЗаголовок = МакетЗаголовок.ПолучитьОбласть("Заголовок");
	
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ПолучитьТекстЗаголовка();
	
	Результат.Вывести(ОбластьЗаголовок);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ЗаголовокОтчета = "Динамика задолженности поставщикам";
	
	Возврат ТиповыеОтчеты.ПолучитьТекстЗаголовка(ЭтотОбъект, ЗаголовокОтчета, ОрганизацияВНачале);
	
КонецФункции

Процедура ОбработкаРезультатаОтчета(Результат)
	
	ТиповыеОтчеты.ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);
	
КонецПроцедуры

Процедура УстановитьИнтервал() Экспорт
	
	ОтчетыДляРуководителя.УстановитьИнтервал(ЭтотОбъект);
	
КонецПроцедуры

Функция ПроверитьЗаполнениеОбязательныхРеквизитов()
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(НачалоПериода) ИЛИ Не ЗначениеЗаполнено(КонецПериода) Тогда
		Сообщить("Не указан период формирования отчета", СтатусСообщения.Важное);
		Отказ = Истина;
	ИначеЕсли НачалоПериода > КонецПериода Тогда
		Сообщить("Дата начала периода не может быть больше даты конца периода", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КоличествоВыводимыхЗаписейВДиаграмме) Тогда
		Сообщить("Не указано количество выводимых записей в диаграмме", СтатусСообщения.Важное);
		Отказ = Истина;     
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Интервал) Тогда
		Сообщить("Не указан интервал", СтатусСообщения.Важное); 
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции
	
// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	
	Если СохраненнаяНастройка = Неопределено Тогда
		СсылкаНаОбъект = ТиповыеОтчеты.ПолучитьИдентификаторОбъекта(ЭтотОбъект);
		Настройка = Справочники.СохраненныеНастройки.СоздатьЭлемент();
		Настройка.НастраиваемыйОбъект = СсылкаНаОбъект;
		Настройка.ТипНастройки = Перечисления.ТипыНастроек.НастройкиПользователяНастройкиОтчета;
		Настройка.Наименование = "НастройкиПользователяНастройкиОтчета";
		Настройка.ИспользоватьПриОткрытии = Истина;
		НовыйПользователь = Настройка.Пользователи.Добавить();
		НовыйПользователь.Пользователь = глЗначениеПеременной("глТекущийПользователь");
		Настройка.Записать();
		
		СохраненнаяНастройка = Настройка.Ссылка;
	КонецЕсли;
	
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	
	// добавляем в настройки компоновщика ОтрицательноеКрасным
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление;
	ВыделятьОтрицательные = Неопределено;
	Для Каждого ЭлементОформления Из УсловноеОформление.Элементы Цикл
		ПараметрВыделятьОтрицательные = ЭлементОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыделятьОтрицательные"));
		Если ПараметрВыделятьОтрицательные.Использование Тогда
			ВыделятьОтрицательные = ПараметрВыделятьОтрицательные;
			ЭлементОформленияВыделятьОтрицательные = ЭлементОформления;
		КонецЕсли;
	КонецЦикла;
	Если ВыделятьОтрицательные <> Неопределено Тогда
		СохраненноеУсловноеОформление = СтруктураПараметров.НастройкиКомпоновщика.УсловноеОформление;
		ЕстьНастройка = Ложь;
		Для Каждого ЭлементОформления Из СохраненноеУсловноеОформление.Элементы Цикл
			ПараметрВыделятьОтрицательные = ЭлементОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыделятьОтрицательные"));
			Если ПараметрВыделятьОтрицательные.Использование Тогда
				ЕстьНастройка = Истина;
			КонецЕсли;
		КонецЦикла;
		Если НЕ ЕстьНастройка Тогда
			НовоеОформление = СохраненноеУсловноеОформление.Элементы.Добавить();
			НовоеОформление.Использование = ЭлементОформленияВыделятьОтрицательные.Использование;
			НовоеОформление.Представление = ЭлементОформленияВыделятьОтрицательные.Представление;
			НовыйПараметр = НовоеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыделятьОтрицательные"));
			НовыйПараметр.Использование = ВыделятьОтрицательные.Использование;
			НовыйПараметр.Значение      = ВыделятьОтрицательные.Значение;
		КонецЕсли;
	КонецЕсли;
	
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	СтандартныеОтчеты.ИнициализацияОтчета(ЭтотОбъект);
	
КонецПроцедуры

Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли
мСписокСтруктурныхЕдиниц = Новый СписокЗначений;