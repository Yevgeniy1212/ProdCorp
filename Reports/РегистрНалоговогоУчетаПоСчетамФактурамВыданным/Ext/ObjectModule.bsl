﻿Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем мПоддержкаРаботыСоСтруктурнымиПодразделениями Экспорт;

Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;

#Если Клиент Тогда

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Результат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();	
	ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
	// выводим шапку
	СведенияОНалогоплательщике = ОбщегоНазначения.СведенияОЮрФизЛице(Организация, КонецПериода);
	Макет = ПолучитьОбщийМакет("ЗаголовокРегистраНалоговогоУчета");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок58");
	//ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ПолучитьТекстЗаголовка();
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "Сумма НДС по реализованным товарам, работам, услугам ";
	ОбластьЗаголовок.Параметры.Заполнить(СведенияОНалогоплательщике);
	ОбластьЗаголовок.Параметры.НалоговыйПериод = ОбщегоНазначения.ПолучитьПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(КонецПериода));
	Результат.Вывести(ОбластьЗаголовок);
	
	// сохраним признак РасширеннойНастройки
	СохраненныйПризнакРасширеннойНастройки = ЭтотОбъект.РасширеннаяНастройка;
	ЭтотОбъект.РасширеннаяНастройка = Ложь; // выставляем в ЛОЖЬ, чтобы зафиксировать шапку таблицы при выводе
	
	ТиповыеОтчеты.ВывестиТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	// выводим подвал
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОтветЛица = ОбщегоНазначения.ОтветственныеЛицаОрганизаций(Организация, КонецПериода, глЗначениеПеременной("глТекущийПользователь").Физлицо);
	ОбластьПодвал.Параметры.ФИОРуководителя = ОтветЛица.Руководитель;
	ОбластьПодвал.Параметры.ФИОглБухгалтера = ОтветЛица.ГлавныйБухгалтер;
	ОбластьПодвал.Параметры.ФИОИсполнителя 	= ОтветЛица.ОтветственныйЗаРегистры;
	ОбластьПодвал.Параметры.ДатаСоставления = Формат(ОбщегоНазначения.ПолучитьРабочуюДату(), "ДФ=""дд ММММ гггг 'г.'""");
	
	Результат.Вывести(ОбластьПодвал);
    		
	// Выполним дополнительную обработку Результата отчета
	ОбработкаРезультатаОтчета(Результат);
	
	Возврат;
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
		
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(КонецПериода));
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ПредставлениеНомераДокумента", ПредставлениеНомераДокумента);	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "глСписокПрефиксовУзлов", глСписокПрефиксовУзлов);	
		
	Если ЗначениеЗаполнено(мСписокСтруктурныхЕдиниц) Тогда
		ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек, "Организация", мСписокСтруктурныхЕдиниц, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Налогоплательщик", 				Организация);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ОтветственноеЛицоРуководитель", 	Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ОтветственноеЛицоГлБухгалтер", 	Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);		
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ФормированиеПоДатеВыписки",      СокрЛП(ФормированиеПоДатеВыписки) = "ПоДатеВыписки");
	
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ЗаголовокОтчета = "Регистр налогового учета по счетам-фактурам выданным";

	//Возврат ТиповыеОтчеты.ПолучитьТекстЗаголовка(ЭтотОбъект, ЗаголовокОтчета, ОрганизацияВНачале);
	Возврат ЗаголовокОтчета;
	
КонецФункции

Процедура ОбработкаРезультатаОтчета(Результат)
	
	ТиповыеОтчеты.ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);
	
КонецПроцедуры

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
	
	Если НЕ ЗначениеЗаполнено(СохраненнаяНастройка) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецПериода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ФормированиеПоДатеВыписки", СокрЛП(ФормированиеПоДатеВыписки) = "ПоДатеВыписки");
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	МакетЗаголовок = ПолучитьМакет("ЗаголовокРегистраНУ");
	ОбластьЗаголовок = МакетЗаголовок.ПолучитьОбласть("Заголовок");
	
	ОбластьЗаголовок.Параметры.РНННалогоплательщика = Организация.РНН;
	ОбластьЗаголовок.Параметры.НазваниеОрганизации  = Организация.НаименованиеПолное;

	Результат.Вывести(ОбластьЗаголовок);
			
КонецПроцедуры

Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли
мСписокСтруктурныхЕдиниц = Новый СписокЗначений;
//мПоддержкаРаботыСоСтруктурнымиПодразделениями = Константы.ПоддержкаРаботыСоСтруктурнымиПодразделениями.Получить();
мПоддержкаРаботыСоСтруктурнымиПодразделениями = Истина;