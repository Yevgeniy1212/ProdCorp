﻿Перем мСписокИсточниковФинансирования Экспорт;
Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем мСписокПодразделений Экспорт;
Перем мДеревоСтруктурныхЕдиниц Экспорт;
Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем ПромежуточныеДанные Экспорт;
Перем РежимРасшифровки Экспорт;
Перем ВедётсяУчетПоПодразделениям Экспорт;

#Если Клиент Тогда

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	СтандартныеОтчеты.ЗаполнитьДанныеОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Результат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ВыводЗаголовкаОтчета(ЭтотОбъект, Результат);
	ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
	//КомпоновщикНастроек.Восстановить();
	//НастройкаКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	
	СтандартныеОтчеты.ВывестиОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	// Выполним дополнительную обработку Результата отчета
	ОбработкаРезультатаОтчета(Результат);
	
	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(Результат, ПолучитьТекстЗаголовка(), Строка(глТекущийПользователь));
	
	Возврат;
	
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
	
	Если мДеревоСтруктурныхЕдиниц.Колонки.Количество() = 0 Тогда 
		
		СписокСтруктурныхЕдиниц = Новый СписокЗначений;
		СписокСтруктурныхЕдиниц.ЗагрузитьЗначения(мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
		
		Для Каждого СтрПодразделение Из мСписокПодразделений Цикл 
			СписокСтруктурныхЕдиниц.Добавить(СтрПодразделение.Значение);
		КонецЦикла;		
				
		мДеревоСтруктурныхЕдиниц = СтандартныеОтчеты.СформироватьДеревоСЕ(, СписокСтруктурныхЕдиниц);
		
	КонецЕсли;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВыборкаДанных = ПолучитьВыборку();
	ВнешниеНаборыДанных.Вставить("ТаблицаДанных", ВыборкаДанных);
	
	
	ТиповыеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, мДеревоСтруктурныхЕдиниц);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	СтандартныеОтчеты.ИнициализацияОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	СтандартныеОтчеты.ВыводЗаголовкаСпециализированногоОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
		
	ЗаголовокОтчета = "Реестр документов поступления НМА " + СтандартныеОтчеты.ПолучитьПредставлениеПериода(ЭтотОбъект);

	Возврат ?(ОрганизацияВНачале, ЗаголовокОтчета, ЗаголовокОтчета + " " + СтандартныеОтчеты.ПолучитьТекстОрганизация(ЭтотОбъект));
		
КонецФункции

Функция ПолучитьВыборку()
	
	Запрос = Новый Запрос;
	
	//Содержит текст построителя отчета
	
	Текст =
"ВЫБРАТЬ
|	ПоступлениеНМА.Номер,
|	ПоступлениеНМА.Дата,
|	ВЫБОР
|		КОГДА ПоступлениеНМА.СуммаВключаетНДС
|			ТОГДА ПоступлениеНМА.СуммаДокумента
|		ИНАЧЕ ПоступлениеНМА.СуммаДокумента + ДанныеПоТЧ.СуммаНДС
|	КОНЕЦ КАК СуммаДокумента,
|	ПоступлениеНМА.СуммаВключаетНДС,
|	ПоступлениеНМА.Организация,
|	ПоступлениеНМА.Контрагент,
|	ПоступлениеНМА.ДоговорКонтрагента,
|	ПоступлениеНМА.ТипОперации,
|	ПоступлениеНМА.ВалютаДокумента,
|	ПоступлениеНМА.КурсВзаиморасчетов,
|	ПоступлениеНМА.Комментарий,
|	ДанныеПоТЧ.СуммаНДС КАК СуммаНДС
|ИЗ
|	Документ.ПоступлениеНМА КАК ПоступлениеНМА
|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
|			ТЧ.ТекДокумент КАК ТекДокумент,
|			СУММА(ТЧ.СуммаНДС) КАК СуммаНДС
|		ИЗ
|			(ВЫБРАТЬ
|				Товары.Ссылка КАК ТекДокумент,
|				СУММА(Товары.СуммаНДС) КАК СуммаНДС
|			ИЗ
|				Документ.ПоступлениеНМА.НМА КАК Товары
|			ГДЕ
|				Товары.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
|				И Товары.Ссылка.Проведен
|			
|			СГРУППИРОВАТЬ ПО
|				Товары.Ссылка
|			) КАК ТЧ
|		
|		СГРУППИРОВАТЬ ПО
|			ТЧ.ТекДокумент) КАК ДанныеПоТЧ
|		ПО (ДанныеПоТЧ.ТекДокумент = ПоступлениеНМА.Ссылка)
|ГДЕ
|	ПоступлениеНМА.Дата МЕЖДУ &НачалоПериода И &КонецПериода
|	И ПоступлениеНМА.Проведен";	

	Запрос.УстановитьПараметр("НачалоПериода",НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(КонецПериода));
	
	Запрос.Текст = Текст;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ОбработкаРезультатаОтчета(Результат)
	
	ТиповыеОтчеты.ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);

КонецПроцедуры

// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	//ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	ЗаполнитьНачальныеНастройки();
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	
	СтруктураНастроек.Вставить("мСписокПодразделений", мСписокПодразделений);
	СтруктураНастроек.Вставить("мСписокСтруктурныхЕдиниц", мСписокСтруктурныхЕдиниц);
	СтруктураНастроек.Вставить("мДеревоСтруктурныхЕдиниц", мДеревоСтруктурныхЕдиниц);
	
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);

КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры


Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли
мСписокИсточниковФинансирования = Новый СписокЗначений;
мСписокСтруктурныхЕдиниц = Новый СписокЗначений;
мСписокПодразделений = Новый СписокЗначений;
мДеревоСтруктурныхЕдиниц = Новый ДеревоЗначений;

ВедётсяУчетПоПодразделениям = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();

РежимРасшифровки = Ложь;