﻿
// Проверяет настройки версионирования по переданному объекту и
// и возвращает вариант версионирования. Если по объекту не настроено
// версионирование, то он версионируется в соответствии с правилами
// версионирования "по умолчанию".
//
Функция ОбъектВерсионируется(знач Источник, НомерПоследнейВерсии,ПолноеИмя) Экспорт
	
	// Проверяем, что подсистема версионирования включена
	Если НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ИспользоватьВерсионированиеОбъектов") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВариантВерсионирования = ВариантВерсионированияОбъекта(ПолноеИмя);
	Если ВариантВерсионирования = Ложь Тогда
		ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать;
	КонецЕсли;
	
	НомерПоследнейВерсии = ВерсионированиеОбъектов.НомерПоследнейВерсии(Источник.Ссылка);
	
	Возврат Не (ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать 
				Или ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении
					И НомерПоследнейВерсии = 0
					И Не Источник.Проведен);
	
КонецФункции
				
Функция ВариантВерсионированияОбъекта(ПолноеИмя) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиВерсионированияОбъектов.Вариант
		|ИЗ
		|	РегистрСведений.НастройкиВерсионированияОбъектов КАК НастройкиВерсионированияОбъектов
		|ГДЕ
		|	НастройкиВерсионированияОбъектов.ТипОбъекта = &ТипОбъекта
		|	И НастройкиВерсионированияОбъектов.Использовать";

	Запрос.УстановитьПараметр("ТипОбъекта", ПолноеИмя);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Вариант;
	КонецЦикла;
    Возврат Ложь;
КонецФункции

Процедура ЗаписатьВерсию(Ссылка,ХранилищеДанных,НомерВерсии,АвторВерсии,ТипВерсииОбъекта,Комментарий,ДополнительныйКомментарий,ДополнительныеСвойства) Экспорт
	МенеджерЗаписиВерсииОбъектов = РегистрыСведений.ВерсииОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписиВерсииОбъектов.Объект			  = Ссылка;
	МенеджерЗаписиВерсииОбъектов.ДатаВерсии		  = ТекущаяДатаСеанса();
	МенеджерЗаписиВерсииОбъектов.ВерсияОбъекта	  = ХранилищеДанных;
	МенеджерЗаписиВерсииОбъектов.НомерВерсии	  = НомерВерсии;
	
	Если ДополнительныеСвойства.Свойство("ЭтоВерсияОбмена") Тогда
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписиВерсииОбъектов, ДополнительныеСвойства);
		
	Иначе
		
		МенеджерЗаписиВерсииОбъектов.АвторВерсии	  = ?(ЗначениеЗаполнено(АвторВерсии), АвторВерсии, ПользователиКлиентСервер.АвторизованныйПользователь());
		МенеджерЗаписиВерсииОбъектов.Комментарий 	  = ?(ЗначениеЗаполнено(Комментарий), Комментарий, ДополнительныйКомментарий);
		МенеджерЗаписиВерсииОбъектов.ТипВерсииОбъекта = ?(ЗначениеЗаполнено(ТипВерсииОбъекта), ТипВерсииОбъекта, Перечисления.ТипыВерсийОбъекта.ИзмененоПользователем);
		
	КонецЕсли;
	
	МенеджерЗаписиВерсииОбъектов.Записать();
КонецПроцедуры


Функция СтруктураДанныхДокументаДляАктаСверки(Документ) Экспорт
	Результат =	Новый Структура("НомерВходящегоДокумента,ВидВходящегоДокумента,ДатаВходящегоДокумента");
	ЗаполнитьЗначенияСвойств(Результат,Документ);
	Возврат Результат;
КонецФункции

Функция СтруктураДанныхДокументаДляПечати(Документ) Экспорт
	Результат =	Новый Структура("Номер,Организация,Дата,ДокументОснование,НомерВходящегоДокумента,ВидВходящегоДокумента,ДатаВходящегоДокумента,НомерДокументаГЗ,ДатаДокументаГЗ");
	Если Документ =Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Результат,Документ);
	Если Документ.Метаданные().Реквизиты.Найти("ДокументОснование")<>Неопределено И Документ.ДокументОснование<>Неопределено Тогда
		СтруктураОснование = Новый Структура("Организация");
		ЗаполнитьЗначенияСвойств(СтруктураОснование,Документ.ДокументОснование);
		Результат.Вставить("ДокументОснование",СтруктураОснование);
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Функция производит поиск документа заданного вида, имеющего значение реквизита "ДокументОснование", равное
// переданной ссылке.
//
// Параметры:
//  ДокументСсылка  - ссылка на документ, для которого надо найти подчиненный документ,
//  ВидСчетаФактуры - строка, вид документа, по умолчанию "СчетФактураВыданный"
//
// Возвращаемое значение:
//  Если нашли, то возвращаем ссылку, не нашли - Неопределено
//
Функция НайтиПодчиненныйДокумент(ДокументСсылка, ВидДокумента = "СчетФактураВыданный") Экспорт

	НайденныйДокумент = Неопределено;
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда 
		Запрос = Новый Запрос;
		
		// Установим параметры запроса
		Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
		
		Если ВидДокумента = "СчетФактураВыданный"  ИЛИ ВидДокумента = "СчетФактураПолученный" Тогда
			
			Запрос.Текст = 
			"ВЫБРАТЬ 
			|	Ссылка 
			|ИЗ
			|	Документ." + ВидДокумента + ".ДокументыОснования Как ТЧ_Документов
			|
			|ГДЕ
			|	ТЧ_Документов.ДокументОснование = &ДокументСсылка";
		Иначе
			Запрос.Текст = 
			
			"ВЫБРАТЬ 
			|	Ссылка 
			|ИЗ
			|	Документ." + ВидДокумента + "
			|
			|ГДЕ
			|	ДокументОснование = &ДокументСсылка";
			
		КонецЕсли;
		
		ВыборкаИзЗапроса = Запрос.Выполнить().Выбрать();
		
		Если ВыборкаИзЗапроса.Следующий() Тогда
			НайденныйДокумент = ВыборкаИзЗапроса.Ссылка;
		КонецЕсли;
		
	КонецЕсли;

	Возврат НайденныйДокумент;

КонецФункции // НайтиПодчиненныйДокумент()

Процедура ЗагрузитьТабличнуюЧастьВТаблицуЗначений(ТаблицаЗначений,ИмяТабличнойЧасти,Ссылка=Неопределено) Экспорт
	ТаблицаЗначений.Очистить();
	Если ТипЗнч(ИмяТабличнойЧасти)<>Тип("Строка") Тогда
		Для Каждого СтрокаИсходная Из ИмяТабличнойЧасти Цикл
			НС = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НС,СтрокаИсходная);
		КонецЦикла;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ ТЧ.* ИЗ Документ."+Ссылка.Метаданные().Имя+"."+ИмяТабличнойЧасти+" КАК ТЧ ГДЕ ТЧ.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НС = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НС,Выборка);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьВыпискуБанка(СписокДокументов,Организация,СчетОрганизации,ДатаОплаты,ТолькоОплаченные,мОтображатьСтруктурныеПодразделения,мСтруктурныеПодразделения) Экспорт

	СписокДокументов.Очистить();
	
	Если Организация.Пустая() ИЛИ СчетОрганизации.Пустая() ИЛИ
		НЕ ЗначениеЗаполнено(ДатаОплаты) Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	// исходящие платежные поручения	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПлатежноеПоручениеИсходящее.Ссылка          КАК Документ,
	|   ПлатежноеПоручениеИсходящее.ВидОперации     КАК ВидОперации,
	|	ВЫБОР 
	|		Когда ПлатежноеПоручениеИсходящее.ВидОперации=&Перевод 
	|		Тогда ПлатежноеПоручениеИсходящее.Организация.Представление
	|	    Иначе ПлатежноеПоручениеИсходящее.Контрагент.Представление	
	|   КОНЕЦ КАК Контрагент,
	|	ПлатежноеПоручениеИсходящее.Оплачено        КАК Оплачено,
	|	ИСТИНА КАК ИзменятьСостояние, 
	|	0 КАК СуммаПриход,
	|	ЕстьNull(ПлатежноеПоручениеИсходящее.СуммаДокумента,0) + ЕстьNull(ПлатежноеПоручениеИсходящее.СуммаКомиссии,0)  КАК СуммаРасход
	|ИЗ
	|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручениеИсходящее
	|
	|ГДЕ
	|	ПлатежноеПоручениеИсходящее.СчетОрганизации = &СчетОрганизации
	|	И НЕ ПлатежноеПоручениеИсходящее.ПометкаУдаления";
	
	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежноеПоручениеИсходящее.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	КонецЕсли;

	Если ТолькоОплаченные Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежноеПоручениеИсходящее.Оплачено
		|	И КонецПериода(ПлатежноеПоручениеИсходящее.Дата,День) = &ДатаОплаты";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	И ((ПлатежноеПоручениеИсходящее.Оплачено И КонецПериода(ПлатежноеПоручениеИсходящее.Дата,День) = &ДатаОплаты)
		|	ИЛИ (НЕ ПлатежноеПоручениеИсходящее.Оплачено И КонецПериода(ПлатежноеПоручениеИсходящее.Дата,День) <= &ДатаОплаты))";
	КонецЕсли;

	// денежные чеки
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДенежныйЧек.Ссылка,
	|	"""",
	|	ДенежныйЧек.Организация.Представление,
	|	ДенежныйЧек.Оплачено,
	|	ЛОЖЬ,
	|	0,
	|	ДенежныйЧек.СуммаДокумента
	|ИЗ
	|	Документ.ден_ДенежныйЧек КАК ДенежныйЧек
	|
	|ГДЕ
	|	ДенежныйЧек.СчетОрганизации = &СчетОрганизации
	|   И НЕ ДенежныйЧек.ПометкаУдаления";
	
	//Если мОтображатьСтруктурныеПодразделения Тогда
	//	ТекстЗапроса = ТекстЗапроса + "
	//	|	И ДенежныйЧек.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	//КонецЕсли;
	Если ТолькоОплаченные Тогда
		ТекстЗапроса=ТекстЗапроса+"
		|И ДенежныйЧек.Оплачено
		|И КонецПериода(ДенежныйЧек.ДатаОплаты,День) = &ДатаОплаты";
	Иначе
		ТекстЗапроса=ТекстЗапроса+"	 		 
		|И ((ДенежныйЧек.Оплачено И КонецПериода(ДенежныйЧек.ДатаОплаты,День) = &ДатаОплаты)
		|ИЛИ (НЕ ДенежныйЧек.Оплачено И КонецПериода(ДенежныйЧек.Дата,День) <= &ДатаОплаты))";
	КонецЕсли;
	
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОбъявлениеНаВзнос.Ссылка,
	|	"""",
	|	ОбъявлениеНаВзнос.Организация.Представление,
	|	ОбъявлениеНаВзнос.Оплачено,
	|	ЛОЖЬ,
	|	ОбъявлениеНаВзнос.СуммаДокумента,
	|	0
	|ИЗ
	|	Документ.ден_ОбъявлениеНаВзносНаличными КАК ОбъявлениеНаВзнос
	|
	|ГДЕ
	|	ОбъявлениеНаВзнос.СчетОрганизации = &СчетОрганизации
	|   И НЕ ОбъявлениеНаВзнос.ПометкаУдаления";
	Если ТолькоОплаченные Тогда
		ТекстЗапроса=ТекстЗапроса+"
		|И ОбъявлениеНаВзнос.Оплачено
		|И КонецПериода(ОбъявлениеНаВзнос.ДатаОплаты,День) = &ДатаОплаты";
	Иначе
		ТекстЗапроса=ТекстЗапроса+"	 		 
		|И ((ОбъявлениеНаВзнос.Оплачено И КонецПериода(ОбъявлениеНаВзнос.ДатаОплаты,День) = &ДатаОплаты)
		|ИЛИ (НЕ ОбъявлениеНаВзнос.Оплачено И КонецПериода(ОбъявлениеНаВзнос.Дата,День) <= &ДатаОплаты))";
	КонецЕсли;
	
	// Входящие платежные поручения
	ТекстЗапроса = ТекстЗапроса + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПлатежноеПоручениеВходящее.Ссылка,
	|	ПлатежноеПоручениеВходящее.ВидОперации,
	|	ПлатежноеПоручениеВходящее.Контрагент.Представление,
	|	ПлатежноеПоручениеВходящее.Оплачено,
	|	ИСТИНА,
	|	ПлатежноеПоручениеВходящее.СуммаДокумента,
	|	0
	|ИЗ
	|	Документ.ПлатежноеПоручениеВходящее КАК ПлатежноеПоручениеВходящее
	|
	|ГДЕ
	|	ПлатежноеПоручениеВходящее.СчетОрганизации = &СчетОрганизации
	|	И НЕ ПлатежноеПоручениеВходящее.ПометкаУдаления";
 	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежноеПоручениеВходящее.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	КонецЕсли;

	Если ТолькоОплаченные Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежноеПоручениеВходящее.Оплачено
		|	И КонецПериода(ПлатежноеПоручениеВходящее.Дата,День) = &ДатаОплаты";

	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	И ((ПлатежноеПоручениеВходящее.Оплачено И КонецПериода(ПлатежноеПоручениеВходящее.Дата,День) = &ДатаОплаты)
		|	ИЛИ (НЕ ПлатежноеПоручениеВходящее.Оплачено И КонецПериода(ПлатежноеПоручениеВходящее.Дата,День) <= &ДатаОплаты))";

	КонецЕсли;
	
	// Платежные ордера
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПлатежныйОрдерВходящий.Ссылка,
	|	ПлатежныйОрдерВходящий.ВидОперации,
	|	ВЫБОР 
	|		Когда ПлатежныйОрдерВходящий.ВидОперации=&Инкассация 
	|		Тогда ПлатежныйОрдерВходящий.Организация.Представление
	|	    Иначе ПлатежныйОрдерВходящий.Контрагент.Представление	
	|   КОНЕЦ КАК Контрагент,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ПлатежныйОрдерВходящий.СуммаДокумента,
	|	0
	|ИЗ
	|	Документ.ПлатежныйОрдерПоступлениеДенежныхСредств КАК ПлатежныйОрдерВходящий
	|
	|ГДЕ
	|	ПлатежныйОрдерВходящий.СчетОрганизации = &СчетОрганизации
	|   И ПлатежныйОрдерВходящий.Проведен
	|	И КонецПериода(ПлатежныйОрдерВходящий.Дата,День) = &ДатаОплаты";
	
	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежныйОрдерВходящий.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	КонецЕсли;
	
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПлатежныйОрдерИсходящий.Ссылка,
	|	ПлатежныйОрдерИсходящий.ВидОперации,
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА ПлатежныйОрдерИсходящий.Контрагент.Представление
	|			ИНАЧЕ ПлатежныйОрдерИсходящий.Организация.Представление
	|	КОНЕЦ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА 0
	|			ИНАЧЕ ЕстьNull(ПлатежныйОрдерИсходящий.СуммаДокумента,0) + ЕстьNull(ПлатежныйОрдерИсходящий.СуммаКомиссии,0)
	|	КОНЕЦ,
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА ЕстьNull(ПлатежныйОрдерИсходящий.СуммаДокумента,0) + ЕстьNull(ПлатежныйОрдерИсходящий.СуммаКомиссии,0)
	|			ИНАЧЕ 0
	|	КОНЕЦ
	|ИЗ
	|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК ПлатежныйОрдерИсходящий
	|
	|ГДЕ
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА ПлатежныйОрдерИсходящий.СчетОрганизации = &СчетОрганизации
	|			ИНАЧЕ ПлатежныйОрдерИсходящий.СчетКонтрагента = &СчетОрганизации
	|	КОНЕЦ
	|   И ПлатежныйОрдерИсходящий.Проведен
	|	И КонецПериода(ПлатежныйОрдерИсходящий.Дата,День) = &ДатаОплаты";
	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежныйОрдерИсходящий.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	КонецЕсли;
	
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ 
	|ВЫБРАТЬ
	|	ПлатежныйОрдерИсходящий.Ссылка,
	|	ПлатежныйОрдерИсходящий.ВидОперации,
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА ПлатежныйОрдерИсходящий.Контрагент.Представление
	|			ИНАЧЕ ПлатежныйОрдерИсходящий.Организация.Представление
	|	КОНЕЦ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА ЕстьNull(ПлатежныйОрдерИсходящий.СуммаДокумента,0) + ЕстьNull(ПлатежныйОрдерИсходящий.СуммаКомиссии,0)
	|			ИНАЧЕ 0
	|	КОНЕЦ,
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА 0
	|			ИНАЧЕ ЕстьNull(ПлатежныйОрдерИсходящий.СуммаДокумента,0) + ЕстьNull(ПлатежныйОрдерИсходящий.СуммаКомиссии,0)
	|	КОНЕЦ
	|ИЗ
	|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК ПлатежныйОрдерИсходящий
	|
	|ГДЕ
	|	ВЫБОР 
	|		КОГДА ПлатежныйОрдерИсходящий.ВидОперации <> &ПереводНаСчет
	|			ТОГДА ПлатежныйОрдерИсходящий.СчетКонтрагента = &СчетОрганизации
	|			ИНАЧЕ ПлатежныйОрдерИсходящий.СчетОрганизации = &СчетОрганизации
	|	КОНЕЦ
	|   И ПлатежныйОрдерИсходящий.Проведен
	|	И КонецПериода(ПлатежныйОрдерИсходящий.Дата,День) = &ДатаОплаты";
	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежныйОрдерИсходящий.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	КонецЕсли;
	
	//Платежные поручения на перевод денежных средств: приход
		
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	ПлатежноеПоручениеИсходящее.Ссылка,
	|	ПлатежноеПоручениеИсходящее.ВидОперации,
	|	ПлатежноеПоручениеИсходящее.Организация.Представление,	
	|	ПлатежноеПоручениеИсходящее.Оплачено,
	|	ИСТИНА,
	|	ПлатежноеПоручениеИсходящее.СуммаДокумента,
	|	0
	|ИЗ
	|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручениеИсходящее
	|
	|ГДЕ
	|	ПлатежноеПоручениеИсходящее.СчетКонтрагента = &СчетОрганизации
	|	И ПлатежноеПоручениеИсходящее.ВидОперации=&Перевод
	|	И НЕ ПлатежноеПоручениеИсходящее.ПометкаУдаления";
	
	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежноеПоручениеИсходящее.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	КонецЕсли;

	Если ТолькоОплаченные Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПлатежноеПоручениеИсходящее.Оплачено
		|	И КонецПериода(ПлатежноеПоручениеИсходящее.Дата,День) = &ДатаОплаты";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	И ((ПлатежноеПоручениеИсходящее.Оплачено И КонецПериода(ПлатежноеПоручениеИсходящее.Дата,День) = &ДатаОплаты)
		|	ИЛИ (НЕ ПлатежноеПоручениеИсходящее.Оплачено И КонецПериода(ПлатежноеПоручениеИсходящее.Дата,День) <= &ДатаОплаты))";
	КонецЕсли;
	
	////Платежные ордера на перевод денежных средств: при списании
	//	
	//ТекстЗапроса=ТекстЗапроса+"
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|ВЫБРАТЬ
	//|	ПлатежныйОрдерИсходящийПеревод.Ссылка,
	//|	ПлатежныйОрдерИсходящийПеревод.ВидОперации,
	//|	ПлатежныйОрдерИсходящийПеревод.Организация.Представление,
	//|	ИСТИНА,
	//|	ЛОЖЬ,
	//|	ЕстьNull(ПлатежныйОрдерИсходящийПеревод.СуммаДокумента,0) + ЕстьNull(ПлатежныйОрдерИсходящийПеревод.СуммаКомиссии,0),
	//|	0
	//|ИЗ
	//|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК ПлатежныйОрдерИсходящийПеревод
	//|
	//|ГДЕ
	//|	ПлатежныйОрдерИсходящийПеревод.СчетКонтрагента = &СчетОрганизации
	//|   И ПлатежныйОрдерИсходящийПеревод.Проведен
	//|	И КонецПериода(ПлатежныйОрдерИсходящийПеревод.Дата,День) = &ДатаОплаты";

	//Приходный кассовый ордер: получение наличности в банке
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	ПриходныйКассовыйОрдер.Ссылка,
	|	ПриходныйКассовыйОрдер.ВидОперации,
	|	ПриходныйКассовыйОрдер.Организация.Представление,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	0,
	|	ПриходныйКассовыйОрдер.СуммаДокумента
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|
	|ГДЕ
	|	ПриходныйКассовыйОрдер.ВидОперации=&ПолучениеНаличности
	|	И ПриходныйКассовыйОрдер.ДенежныйЧек = &ПустойДенежныйЧек
	|	И ПриходныйКассовыйОрдер.СчетОрганизации = &СчетОрганизации
	|   И ПриходныйКассовыйОрдер.Проведен
	|   И ПриходныйКассовыйОрдер.Оплачено
	|	И КонецПериода(ПриходныйКассовыйОрдер.Дата,День) = &ДатаОплаты";
	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И ПриходныйКассовыйОрдер.СтруктурноеПодразделениеПолучатель В (&СтруктурноеПодразделение)";
	КонецЕсли;
	
	
	//Расходный кассовый ордер: взнос наличными в банк
	ТекстЗапроса=ТекстЗапроса+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдер.ВидОперации,
	|	РасходныйКассовыйОрдер.Организация.Представление,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	РасходныйКассовыйОрдер.СуммаДокумента,
	|	0
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|
	|ГДЕ
	|   РасходныйКассовыйОрдер.ВидОперации=&ВзносНаличными
	|	И РасходныйКассовыйОрдер.ОбъявлениеНаВзносНаличными = &ПустоеОбъявление
	|	И РасходныйКассовыйОрдер.СчетОрганизации = &СчетОрганизации
	|   И РасходныйКассовыйОрдер.Проведен
	|   И РасходныйКассовыйОрдер.Оплачено
	|	И КонецПериода(РасходныйКассовыйОрдер.Дата,День) = &ДатаОплаты";
	
	Если мОтображатьСтруктурныеПодразделения Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И РасходныйКассовыйОрдер.СтруктурноеПодразделениеОтправитель В (&СтруктурноеПодразделение)";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО
	|	Документ";

	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("СчетОрганизации", СчетОрганизации);
	Запрос.УстановитьПараметр("ДатаОплаты",      КонецДня(ДатаОплаты));
	Запрос.УстановитьПараметр("Перевод",Перечисления.ВидыОперацийППИсходящее.ПереводНаДругойСчет);
	Запрос.УстановитьПараметр("ПолучениеНаличности",Перечисления.ВидыОперацийПКО.ПолучениеНаличныхДенежныхСредствВБанке);
	Запрос.УстановитьПараметр("ВзносНаличными",Перечисления.ВидыОперацийРКО.ВзносНаличнымиВБанк);
	Запрос.УстановитьПараметр("Инкассация",Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ИнкассацияДенежныхСредств);
	Если мОтображатьСтруктурныеПодразделения Тогда
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", мСтруктурныеПодразделения);
	КонецЕсли;

	Запрос.УстановитьПараметр("ПустоеОбъявление",Документы.ден_ОбъявлениеНаВзносНаличными.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойДенежныйЧек",Документы.ден_ДенежныйЧек.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПереводНаСчет",Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПереводНаДругойСчет);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();

	Пока РезультатЗапроса.Следующий() Цикл
		Строка = СписокДокументов.Добавить();
		Строка.Документ        		= РезультатЗапроса.Документ;
		Строка.Контрагент      		= РезультатЗапроса.Контрагент;
		Строка.ВидОперации      	= РезультатЗапроса.ВидОперации;
		Строка.СуммаПриход     		= РезультатЗапроса.СуммаПриход;
		Строка.СуммаРасход     		= РезультатЗапроса.СуммаРасход;
		Если РезультатЗапроса.Документ.Проведен Тогда
			Строка.Оплачено        		= РезультатЗапроса.Оплачено;
		Иначе
			Строка.Оплачено = Ложь;
		КонецЕсли;
		Строка.ИзменятьСостояние	= РезультатЗапроса.ИзменятьСостояние;
		Строка.Проведен 			= РезультатЗапроса.Документ.Проведен;
	КонецЦикла;
КонецПроцедуры


