﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мВалютаРегламентированногоУчета Экспорт;

Перем мУчетнаяПолитикаПоНалоговомуУчету Экспорт;
Перем мУчетнаяПолитикаПоБухгалтерскомуУчету Экспорт;

Перем мПоддержкаРаботыСоСтруктурнымиПодразделениями Экспорт;
Перем мОтображатьСтруктурныеПодразделения Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Заполняет счета БУ в строке табличной части
//
Процедура ЗаполнитьСчетаБУ(СтрокаТЧ, ИмяТабЧасти, СчетаУчета, ЗаполнятьБУ)

	МетаданныеДокумента = ЭтотОбъект.Метаданные();

	Если ЗаполнятьБУ = Истина Тогда
		СтрокаТЧ.СчетУчетаБУ  = СчетаУчета.СчетУчетаБУ;
		СтрокаТЧ.СчетУчетаНДС = СчетаУчета.СчетУчетаНДСПоПриобретению;
	ИначеЕсли ЗаполнятьБУ = Ложь Тогда
		СтрокаТЧ.СчетУчетаБУ  = ПланыСчетов.Типовой.ПустаяСсылка();
		Если ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СчетУчетаНДС", МетаданныеДокумента, ИмяТабЧасти) Тогда
			СтрокаТЧ.СчетУчетаНДС = ПланыСчетов.Типовой.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Заполняет счета НУ в строке табличной части
//
Процедура ЗаполнитьСчетаНУ(СтрокаТЧ, ИмяТабЧасти, СчетаУчета, ЗаполнятьНУ)
	
	Если ЗаполнятьНУ = Истина Тогда
		УправлениеПроизводством.ЗаполнитьСчетНалоговогоУчетаВСтрокеТабличногоПоля(СтрокаТЧ, "СчетУчетаБУ","СчетУчетаНУ" , Дата);
	ИначеЕсли ЗаполнятьНУ = Ложь Тогда
		СтрокаТЧ.СчетУчетаНУ  = ПланыСчетов.Налоговый.ПустаяСсылка();
	КонецЕсли;

КонецПроцедуры

// Заполняет счета БУ и НУ в строке табличной части
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧасти(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ) Экспорт

	СчетаУчета = УправлениеВнеоборотнымиАктивами.ПолучитьСчетаУчетаНМА(Организация, СтрокаТЧ.НематериальныйАктив, Дата);
	
	Если СчетаУчета.СчетУчетаБУ = ПланыСчетов.Типовой.ПустаяСсылка() Тогда 
		Если СтрокаТЧ.НематериальныйАктив.ВидНМА = Перечисления.ВидыНМА.Гудвилл Тогда
			СчетаУчета.СчетУчетаБУ = ПланыСчетов.Типовой.Гудвилл;
		Иначе
			СчетаУчета.СчетУчетаБУ = ПланыСчетов.Типовой.ПрочиеНематериальныеАктивы;	
		КонецЕсли;
	КонецЕсли;
	СчетаУчета.Вставить("СчетУчетаНДСПоПриобретению",ПланыСчетов.Типовой.НалогНаДобавленнуюСтоимостьКВозмещению);
	
	ЗаполнитьСчетаБУ(СтрокаТЧ, ИмяТабЧасти, СчетаУчета, ЗаполнятьБУ);
	
	ЗаполнитьСчетаНУ(СтрокаТЧ, ИмяТабЧасти, СчетаУчета, ЗаполнятьНУ);

КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧасти()


// Производит заполнение и установку реквизитов налогового учета и НДС в табличной части
//
Процедура ЗаполнитьРеквизитыНалоговогоУчета(СтрокаТабличнойЧасти) Экспорт	
	ОбработкаТабличныхЧастей.ЗаполнитьНДСВидОборотаТабЧасти(СтрокаТабличнойЧасти, ЭтотОбъект);
	ТекущийПользователь = глЗначениеПеременной("глТекущийПользователь");
	ОбработкаТабличныхЧастей.ЗаполнитьНДСВидПоступленияТабЧасти(СтрокаТабличнойЧасти, ЭтотОбъект, ТекущийПользователь);		
Конецпроцедуры	

//Получает документ и дату для указанного состояния НМА по бух учету
//
// Параметры
//
//
// Вовзаращаемое значение
//  Дата и документ - через указанные параметры процедуры.
//
Процедура ПолучитьДокументБухСостоянияНМА(	НМА, Организация, Состояние, ДокРегистратор, 
											ДатаДокРегистратора) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СостояниеНМА", 	Состояние);
	Запрос.УстановитьПараметр("НМА",             НМА);
	Запрос.УстановитьПараметр("Организация",    Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СостоянияНМАОрганизаций.Регистратор КАК Документ,
	|	СостоянияНМАОрганизаций.ДатаСостояния КАК Дата
	|ИЗ
	|	РегистрСведений.СостоянияНМАОрганизаций КАК СостоянияНМАОрганизаций
	|
	|ГДЕ
	|	СостоянияНМАОрганизаций.НематериальныйАктив = &НМА И
	|	СостоянияНМАОрганизаций.Организация = &Организация И
	|	СостоянияНМАОрганизаций.Состояние = &СостояниеНМА
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	
	ВыборкаДоков = Запрос.Выполнить().Выбрать();

	Если ВыборкаДоков.Следующий()  Тогда
		ДокРегистратор      = ВыборкаДоков.Документ;
		ДатаДокРегистратора = ВыборкаДоков.Дата;
	Иначе
		ДокРегистратор      = Неопределено;
		ДатаДокРегистратора = '00010101';
	КонецЕсли;

КонецПроцедуры // УправлениеВнеоборотнымиАктивами.ПолучитьДокументБухСостоянияОС()

// Процедура выполняет заполнение документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	ДокументОснование = Основание.Ссылка;
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.Доверенность") Тогда
		// Заполним реквизиты шапки по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);		
		
		ПоддержкаУчетаВременныхРазниц = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата, Неопределено) 
										И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата, Неопределено);
		//заполним табличную часть
		Для Каждого Строка Из Основание.Товары Цикл
			Если ТипЗнч(Строка.НаименованиеТовара) = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
				НоваяСтрока = НМА.Добавить();
				НоваяСтрока.НематериальныйАктив = Строка.НаименованиеТовара;
				// - КУФИБ - начало
				НоваяСтрока.Заказ = Строка.Заказ;
				НоваяСтрока.ЗаявкаМТС = Строка.ЗаявкаМТС;
				НоваяСтрока.Подразделение = Строка.Подразделение;
				НоваяСтрока.Проект = Строка.Проект;
				// - КУФИБ - конец
				
				//заполним счета учета
				ЗаполнитьСчетаУчетаВСтрокеТабЧасти(НоваяСтрока, НМА, Истина, УчитыватьКПН И (ПоддержкаУчетаВременныхРазниц ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ));
				//заполним реквизиты налоговового учета
				ЗаполнитьРеквизитыНалоговогоУчета(НоваяСтрока);
			КонецЕсли;			
		КонецЦикла;   		
		ДокументОснование = Основание;
		СчетаУчета 	= УправлениеВзаиморасчетами.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
		СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетов;
		СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансов;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		
		Если Основание.ПодтвержденДокументамиОтгрузки Тогда
			#Если Клиент Тогда
				Если Основание.ПодтвержденДокументамиОтгрузки Тогда
					Сообщить("Данные счет-фактуры уже подтверждены документами отгрузки! Ввод на основании не возможен!", СтатусСообщения.Важное);				
				КонецЕсли;				
			#КонецЕсли
			Возврат;       		
		КонецЕсли;  
		
		Дата = Основание.ДатаСовершенияОборотаПоРеализации;
		
				
		// Заполним реквизиты шапки по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		
		ПоддержкаУчетаВременныхРазниц = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата, Неопределено) 
										И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата, Неопределено);
										
		ПлательщикНДС = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата);
										
		Если НЕ ПлательщикНДС И Основание.УчитыватьНДС И НЕ Основание.СуммаВключаетНДС Тогда
			УчестьСуммуНДС = Истина;
		Иначе
			УчестьСуммуНДС = Ложь;
		КонецЕсли;

		УчетНДСИАкциза.ЗаполнитьТабличныеЧастиИзДокументаОснования(ЭтотОбъект, Основание.Ссылка);
		
		Для каждого СтрокаТабличнойЧасти Из НМА Цикл
			//заполним счета учета
			ЗаполнитьСчетаУчетаВСтрокеТабЧасти(СтрокаТабличнойЧасти, НМА, Истина, УчитыватьКПН И (ПоддержкаУчетаВременныхРазниц ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ));
			//заполним реквизиты налоговового учета
			ЗаполнитьРеквизитыНалоговогоУчета(СтрокаТабличнойЧасти);	
			Если УчестьСуммуНДС Тогда
				СтрокаТабличнойЧасти.Сумма    = СтрокаТабличнойЧасти.Сумма + СтрокаТабличнойЧасти.СуммаНДС;
				СтрокаТабличнойЧасти.СуммаНДС = 0;
			КонецЕсли;
		КонецЦикла;
		        				
		СчетаУчета 	= УправлениеВзаиморасчетами.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
		СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетов;
		СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансов;
		
	КонецЕсли;
	
КонецПроцедуры

#Если Клиент Тогда
 
// Функция формирует табличный документ с печатной формой накладной,
// 
//
// Возвращаемое значение:
//  Табличный документ - Табличный документ - печатная форма накладной
//
Функция ПечатьНакладная()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст ="ВЫБРАТЬ
	              |	ПоступлениеНМА.Номер,
	              |	ПоступлениеНМА.Дата,
	              |	ПоступлениеНМА.ДоговорКонтрагента,
	              |	ПоступлениеНМА.Контрагент,
	              |	ПоступлениеНМА.Организация,
				  |	ПоступлениеНМА.СтруктурноеПодразделение,
	              |	ПоступлениеНМА.СуммаДокумента,
	              |	ПоступлениеНМА.ВалютаДокумента,
	              |	ПоступлениеНМА.УчитыватьНДС,
	              |	ПоступлениеНМА.СуммаВключаетНДС
	              |ИЗ
	              |	Документ.ПоступлениеНМА КАК ПоступлениеНМА
	              |ГДЕ
	              |	ПоступлениеНМА.Ссылка = &ТекущийДокумент";
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ЗапросПоТоварам = Новый Запрос();
	ЗапросПоТоварам.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	ЗапросПоТоварам.Текст =
	"ВЫБРАТЬ
	|	ПоступлениеНМАНМА.НематериальныйАктив,
	|	ПоступлениеНМАНМА.СтавкаНДС,
	|	СУММА(ПоступлениеНМАНМА.Сумма) КАК Сумма,
	|	СУММА(ПоступлениеНМАНМА.СуммаНДС) КАК СуммаНДС,
	|	МИНИМУМ(ПоступлениеНМАНМА.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.ПоступлениеНМА.НМА КАК ПоступлениеНМАНМА
	|ГДЕ
	|	ПоступлениеНМАНМА.Ссылка = &ТекущийДокумент
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеНМАНМА.НематериальныйАктив,
	|	ПоступлениеНМАНМА.СтавкаНДС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ВыборкаСтрок = ЗапросПоТоварам.Выполнить().Выгрузить();

	СтруктурнаяЕдиницаОрганизация = ОбщегоНазначения.ПолучитьСтруктурнуюЕдиницу(Шапка.Организация, Шапка.СтруктурноеПодразделение);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПоступлениеНМА_Накладная";
	Макет       = ПолучитьМакет("Накладная");
	
	// Выводим шапку накладной

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект, "Накладная", глСписокПрефиксовУзлов);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ОбщегоНазначения.ОписаниеОрганизации(ОбщегоНазначения.СведенияОЮрФизЛице(Шапка.Контрагент, Шапка.Дата), "ПолноеНаименование,");
	ОбластьМакета.Параметры.Поставщик = Шапка.Контрагент;
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ОбщегоНазначения.ОписаниеОрганизации(ОбщегоНазначения.СведенияОЮрФизЛице(СтруктурнаяЕдиницаОрганизация, Шапка.Дата), "ПолноеНаименование,");
	ОбластьМакета.Параметры.Получатель = СтруктурнаяЕдиницаОрганизация;
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести табличную часть
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	Сумма    = 0;
	СуммаНДС = 0;

	Для Каждого ВыборкаСтрокТовары Из ВыборкаСтрок Цикл

		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.НематериальныйАктив) Тогда
			Сообщить("В одной из строк не заполнено значение НМА - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;
		
		ОбластьМакета.Параметры.НомерСтроки = ВыборкаСтрок.Индекс(ВыборкаСтрокТовары) + 1;
		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьМакета.Параметры.ТоварНаименование = СокрЛП(ВыборкаСтрокТовары.НематериальныйАктив);
		ОбластьМакета.Параметры.Количество = 1;
		ОбластьМакета.Параметры.Цена = ВыборкаСтрокТовары.Сумма;
		ТабДокумент.Вывести(ОбластьМакета);
		Сумма    = Сумма    + ВыборкаСтрокТовары.Сумма;
		СуммаНДС = СуммаНДС + ВыборкаСтрокТовары.СуммаНДС;

	КонецЦикла;

	// Вывести Итого
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.ИтогСумма = ОбщегоНазначения.ФорматСумм(Сумма);
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести ИтогоНДС
	Если Шапка.УчитыватьНДС Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		ОбластьМакета.Параметры.ИтогСуммаНДС = ОбщегоНазначения.ФорматСумм(СуммаНДС);
		ОбластьМакета.Параметры.НДС = ?(Шапка.СуммаВключаетНДС, "В том числе НДС:", "Сумма НДС:");
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли;

	// Вывести Сумму прописью
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
	ОбластьМакета.Параметры.ИтоговаяСтрока ="Всего наименований " + ВыборкаСтрок.Количество()
	+ ", на сумму " + ОбщегоНазначения.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента);
	ОбластьМакета.Параметры.СуммаПрописью = ОбщегоНазначения.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента);
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести подписи
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;	
	
КонецФункции // ПечатьНакладная()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеПользователями.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ИмяМакета = "Накладная" Тогда
		ТабДокумент = ПечатьНакладная();
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Накладная","Приходная накладная");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


//////////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

// Дополняет полями, нужными для регл. учета
//
Процедура ДополнитьСтруктуруОбязательныхПолейШапкиРегл(СтруктураОбязательныхПолей, СтруктураШапкиДокумента)

	СтруктураОбязательныхПолей.Вставить("СчетУчетаРасчетовСКонтрагентом");
	//СтруктураОбязательныхПолей.Вставить("СчетУчетаРасчетовПоАвансам");

	Если СтруктураШапкиДокумента.УчитыватьКПН Тогда
		СтруктураОбязательныхПолей.Вставить("ВидУчетаНУ");
	КонецЕсли;
	
КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация, 
								 |ВалютаДокумента, Контрагент, ДоговорКонтрагента, 
								 |КурсВзаиморасчетов,КратностьВзаиморасчетов");

	ДополнитьСтруктуруОбязательныхПолейШапкиРегл(СтруктураОбязательныхПолей, СтруктураШапкиДокумента);

	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	ОбщегоНазначения.ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, СтруктураШапкиДокумента.ДоговорОрганизация, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Дополняет полями, нужными для регл. учета
Процедура ДополнитьСтруктуруОбязательныхПолейТабличнойЧастиТоварыРегл(СтруктураОбязательныхПолей, СтруктураШапкиДокумента)

	СтруктураОбязательныхПолей.Вставить("СчетУчетаБУ");

	Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ Тогда
		СтруктураОбязательныхПолей.Вставить("СчетУчетаНУ");
	КонецЕсли;

КонецПроцедуры

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("НематериальныйАктив, Сумма");
	Если УчитыватьНДС Тогда
		Если НЕ СтруктураШапкиДокумента.НДСВключенВСтоимость И НЕ СтруктураШапкиДокумента.ОтложитьПринятиеНДСКЗачету Тогда
			СтруктураОбязательныхПолей.Вставить("СчетУчетаНДС");
		КонецЕсли;	
		Если НЕ СтруктураШапкиДокумента.ОтложитьПринятиеНДСКЗачету Тогда 
			СтруктураОбязательныхПолей.Вставить("СтавкаНДС");
			СтруктураОбязательныхПолей.Вставить("НДСВидОборота");
			СтруктураОбязательныхПолей.Вставить("НДСВидПоступления");
		КонецЕсли;
	КонецЕсли;

	ДополнитьСтруктуруОбязательныхПолейТабличнойЧастиТоварыРегл(СтруктураОбязательныхПолей, СтруктураШапкиДокумента);

	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "НМА", СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
							ТаблицаПоНМА, ТаблицаПоУчастникамСовместнойДеятельности, Отказ, Заголовок);

	// Общие таблицы вызываемых процедур
	ТаблицаАвансов = Новый ТаблицаЗначений;
	
	ДвиженияПоРегистрамРегл(РежимПроведения, СтруктураШапкиДокумента, 
							  ТаблицаПоНМА, ТаблицаАвансов, Отказ, Заголовок);
							  
	Если Не ОтложитьПринятиеНДСКЗачету Тогда
		ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаПоНМА, ТаблицаПоУчастникамСовместнойДеятельности, Отказ, Заголовок);
	КонецЕсли;
							   
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамРегл(РежимПроведения, СтруктураШапкиДокумента,	ТаблицаПоНМА, ТаблицаАвансов, Отказ, Заголовок);

	// Формирование проводок
	// Проводки по поступлению товаров, тары и услуг.
	ДатаДока   = СтруктураШапкиДокумента.Дата;

	//Возможны корректировки сумм при расчетах в у.е.
	ТаблицаАвансов = УправлениеВзаиморасчетами.ЗачетАванса(ЭтотОбъект,СтруктураШапкиДокумента,СтруктураШапкиДокумента.НДСВключенВСтоимость, мВалютаРегламентированногоУчета, Новый Структура ("ТаблицаПоНМА",ТаблицаПоНМА), Отказ,Заголовок,"НА", мУчетнаяПолитикаПоБухгалтерскомуУчету);
	ПроводкиБУ = Движения.Типовой;
    ПроводкиНУ = Движения.Налоговый;	
	
	// Проводки по поступлению НМА
	Для каждого СтрокаТаблицы Из ТаблицаПоНМА Цикл

		Проводка = ПроводкиБУ.Добавить();
		Проводка.Период         = Дата;
		Проводка.Организация    = СтруктураШапкиДокумента.Организация;
		Проводка.Содержание 	= "Поступление НМА";
		Проводка.НомерЖурнала   = "НА";

		Проводка.СчетДт         = СтрокаТаблицы.СчетУчетаБУ;
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "НематериальныеАктивы", СтрокаТаблицы.Номенклатура);
		
		Проводка.СчетКт         = СтруктураШапкиДокумента.СчетУчетаРасчетовСКонтрагентом;
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Контрагенты",        СтруктураШапкиДокумента.Контрагент, Истина);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Договоры",           СтруктураШапкиДокумента.ДоговорКонтрагента);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"ТипыОпераций", 	  СтруктураШапкиДокумента.ТипОперации);

		Проводка.Сумма = СтрокаТаблицы.Сумма;
		
		ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				Проводка, СтруктураШапкиДокумента.СтруктурноеПодразделение, СтруктураШапкиДокумента.СтруктурноеПодразделение);
        		
		Если СтруктураШапкиДокумента.СчетУчетаРасчетовСКонтрагентом.Валютный Тогда
			Проводка.ВалютаКт        = СтруктураШапкиДокумента.ВалютаВзаиморасчетов;
			Проводка.ВалютнаяСуммаКт = СтрокаТаблицы.СуммаВал;
		КонецЕсли;

		// Проводка по НДС
		Если НЕ СтруктураШапкиДокумента.НДСВключенВСтоимость И СтруктураШапкиДокумента.УчитыватьНДС И СтрокаТаблицы.НДС > 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период       = Дата;
			Проводка.Организация  = СтруктураШапкиДокумента.Организация;
			Проводка.Сумма        = СтрокаТаблицы.НДС;
			
			Если ОтложитьПринятиеНДСКЗачету Тогда
				Проводка.СчетДт       = ПланыСчетов.Типовой.НДСНачисленныйПриПокупке;
				Проводка.Содержание   = "Отложенное принятие НДС к зачету"; 
			Иначе
				Проводка.СчетДт       = СтрокаТаблицы.СчетУчетаНДС;
				Проводка.Содержание   = "Выделен НДС";
			КонецЕсли;
			
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"НалогиСборыОтчисления", Справочники.НалогиСборыОтчисления.НалогНаДобавленнуюСтоимость);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"ВидыПлатежейВБюджетИФонды", Перечисления.ВидыПлатежейВБюджетИФонды.Налог);
			
			Проводка.СчетКт       = СтруктураШапкиДокумента.СчетУчетаРасчетовСКонтрагентом;
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Контрагенты",        СтруктураШапкиДокумента.Контрагент);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Договоры",           СтруктураШапкиДокумента.ДоговорКонтрагента);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"ТипыОпераций",       СтруктураШапкиДокумента.ТипОперации);
			
			ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				Проводка, СтруктураШапкиДокумента.СтруктурноеПодразделение, СтруктураШапкиДокумента.СтруктурноеПодразделение);

			Если СтруктураШапкиДокумента.СчетУчетаРасчетовСКонтрагентом.Валютный Тогда
				
				Проводка.ВалютаКт = СтруктураШапкиДокумента.ВалютаВзаиморасчетов;
				Проводка.ВалютнаяСуммаКт = СтрокаТаблицы.НДСВал;
				
			КонецЕсли;
			
		КонецЕсли; // Проводка по НДС

		// Налоговый учет
		Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ Тогда
			Проводка = ПроводкиНУ.Добавить();
			Проводка.Период         = Дата;
			Проводка.Организация    = СтруктураШапкиДокумента.Организация;
			Проводка.Содержание 	= "Поступление НМА";
			Проводка.НомерЖурнала   = "НА";
			
			Проводка.СчетДт         = СтрокаТаблицы.СчетУчетаНУ;
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ВнеоборотныеАктивы", СтрокаТаблицы.Номенклатура);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ВидыДвиженияСтоимостиФА", Перечисления.ВидыДвиженияСтоимостиФА.Поступление);
			
			Проводка.СчетКт         = ПроцедурыНалоговогоУчета.ПолучитьСчетРасчетовСКонтрагентомНУ();
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Контрагенты",        СтруктураШапкиДокумента.Контрагент, Истина);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Договоры",           СтруктураШапкиДокумента.ДоговорКонтрагента);			
			
			ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				Проводка, СтруктураШапкиДокумента.СтруктурноеПодразделение, СтруктураШапкиДокумента.СтруктурноеПодразделение);

			Проводка.Сумма = СтрокаТаблицы.Сумма;
			ПроцедурыНалоговогоУчета.ВидУчетаНУ(Проводка, СтруктураШапкиДокумента.ВидУчетаНУ);
			
			//Проводка по НДС
			Если НЕ СтруктураШапкиДокумента.НДСВключенВСтоимость И СтруктураШапкиДокумента.УчитыватьНДС И СтрокаТаблицы.НДС > 0 Тогда
				
				ПроводкаНУ = ПроводкиНУ.Добавить();
				
				ПроводкаНУ.Период       = Дата;
				ПроводкаНУ.Организация  = СтруктураШапкиДокумента.Организация;
				ПроводкаНУ.Сумма        = СтрокаТаблицы.НДС;
				
				Если  ОтложитьПринятиеНДСКЗачету Тогда
					ПроводкаНУ.СчетДт       = ПроцедурыНалоговогоУчета.ПолучитьСчетУчетаНДСКНачислениюНУ(ПланыСчетов.Типовой.НДСНачисленныйПриПокупке, Дата);					
					ПроводкаНУ.Содержание   = "Отложенное принятие НДС к зачету"; 
				Иначе
					ПроводкаНУ.СчетДт       = ПроцедурыНалоговогоУчета.ПолучитьСчетУчетаНДСКВозмещениюНУ(СтрокаТаблицы.СчетУчетаНДС, Дата);					
					ПроводкаНУ.Содержание   = "Выделен НДС";
				КонецЕсли;   
				
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт,ПроводкаНУ.СубконтоДт,"НалогиСборыОтчисления", Справочники.НалогиСборыОтчисления.НалогНаДобавленнуюСтоимость);
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт,ПроводкаНУ.СубконтоДт,"ВидыПлатежейВБюджетИФонды", Перечисления.ВидыПлатежейВБюджетИФонды.Налог);
				
				ПроводкаНУ.СчетКт       = ПроцедурыНалоговогоУчета.ПолучитьСчетРасчетовСКонтрагентомНУ();
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт,ПроводкаНУ.СубконтоКт,"Контрагенты",        СтруктураШапкиДокумента.Контрагент);
				ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт,ПроводкаНУ.СубконтоКт,"Договоры",           СтруктураШапкиДокумента.ДоговорКонтрагента);
								
				ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
					ПроводкаНУ, СтруктураШапкиДокумента.СтруктурноеПодразделение, СтруктураШапкиДокумента.СтруктурноеПодразделение);
					
				ПроцедурыНалоговогоУчета.ВидУчетаНУ(ПроводкаНУ, СтруктураШапкиДокумента.ВидУчетаНУ);
			КонецЕсли; // Проводка по НДС
			
		КонецЕсли;
		
		// Движения по регистру СостоянияНМАОрганизаций
		Движение = Движения.СостоянияНМАОрганизаций.Добавить();
		Движение.Период               = Дата;
		Движение.НематериальныйАктив  = СтрокаТаблицы.Номенклатура;
		Движение.Организация          = Организация;
		Движение.Состояние            = Перечисления.ВидыСостоянийНМА.Поступил;
		
		//проверка на дублирование состояние НМА
		ТаблицаДвижений = Движения.СостоянияНМАОрганизаций.Выгрузить(); 
		УправлениеВнеоборотнымиАктивами.ПроверкаДублированияЗаписейСостоянийНМА(Ссылка, СтруктураШапкиДокумента.Организация, ТаблицаДвижений, Отказ, Заголовок);
	
		
		//Движение по регистру  СчетаУчетаНМА
		Движение = Движения.СчетаУчетаНМА.Добавить();
		Движение.Период               = Дата;
		Движение.НематериальныйАктив  = СтрокаТаблицы.Номенклатура;
		Движение.Организация          = Организация;
		Движение.СчетУчетаБУ		  = СтрокаТаблицы.СчетУчетаБУ;
		
	КонецЦикла;
			
		Для Каждого СтрокаТаблицы Из НМА Цикл
	
		Если СтрокаТаблицы.НоменклатураГЗ.Пустая() тогда
			Сообщить("В строке № " + СтрокаТаблицы.НомерСтроки +" табличной части НМА не указана номенклатура ГЗ");
			Продолжить;   				
		Иначе
			
			Движение = Движения.ЦС_ИсполнениеПланаГЗ.Добавить();
		
			Движение.Период 			= Дата;
			Движение.Организация 		= Организация;
			Движение.НоменклатураГЗ 	= СтрокаТаблицы.НоменклатураГЗ;
			Движение.ПериодПланирования = НачалоГода(СтрокаТаблицы.ПериодПланирования);
			Движение.Количество 		= 1;
			Движение.Сумма				= СтрокаТаблицы.Сумма;
			
			//Редактирование Soft Mix
			
			Движение.Контрагент 	= Контрагент;
			Движение.Договор		= ДоговорКонтрагента;
			Движение.КазахстанскоеСодержание = СтрокаТаблицы.КазахстанскоеСодержание;
			
			//Конец редактирования Soft Mix
			
		КонецЕсли;
	КонецЦикла;
	Если Не Отказ Тогда
		
	КонецЕсли;	
	//Учет курсовых разниц
	Если (ВалютаДокумента <> мВалютаРегламентированногоУчета) тогда
		ПроцедурыБухгалтерскогоУчета.ПереоценкаСчетовДокументаРегл(ЭтотОбъект,СтруктураШапкиДокумента, мВалютаРегламентированногоУчета,Отказ);
	КонецЕсли; // Учет курсовых разниц

КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура вызывается из тела процедуры ДвиженияПоРегистрамРегл
// Формирует движения по регистрам подсистемы учета НДС "НДСПокупки"
Процедура ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаДокумента, ТаблицаПоУчастникамСовместнойДеятельности, Отказ, Заголовок)
	
	Если Не ПроцедурыБухгалтерскогоУчета.ПроводитьДокументПоРазделуУчета(СтруктураШапкиДокумента.Организация, Перечисления.РазделыУчета.НДС, СтруктураШапкиДокумента.Дата) Тогда
		Возврат;
	КонецЕсли;
	
	Если не СтруктураШапкиДокумента.УчитыватьНДС Тогда
		Возврат;
	КонецЕсли;
	
	// Работа со структурными подразделениями
	Если мПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		ПлательщикНДС 	= ПроцедурыНалоговогоУчета.ПолучитьНалогоплательщикаСтруктурнойЕдиницы(СтруктураШапкиДокумента.Организация,
																	СтруктураШапкиДокумента.Организация,
																	глЗначениеПеременной("глИсчислениеНалоговСтруктурныхЕдиниц"),
																	Перечисления.РазделыНалоговогоУчета.НДС);
	Иначе
		ПлательщикНДС 	= СтруктураШапкиДокумента.Организация;															
	КонецЕсли;																
	
	СтруктураШапкиДокумента.Вставить("ПлательщикНДС", ПлательщикНДС);
	
	Если ТаблицаДокумента.Количество()> 0 Тогда              			
		УчетНДСИАкциза.СформироватьДвиженияПоРегиструНДСКВозмещению(СтруктураШапкиДокумента, ТаблицаДокумента, Движения, Отказ, ТаблицаПоУчастникамСовместнойДеятельности);		
	КонецЕсли; 
			
КонецПроцедуры // ДвиженияРегистровПодсистемыНДС()							  

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	ПериодПланированияГЗ = НачалоГода(ПериодПланированияГЗ);
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);

	УчетНДСИАкциза.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный");

КонецПроцедуры // ПередЗаписью

// Процедура - обработчик события "ПриЗаписи" документа.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	//синхронизируем данные счет-фактуры и документа основания
	УчетНДСИАкциза.СинхронизироватьДанныеДокументаИСчетаФактуры(ЭтотОбъект, Отказ, "СчетФактураПолученный"); 		
	Если Отказ Тогда
		Сообщить("Документ не записан ...", СтатусСообщения.ОченьВажное);
	КонецЕсли;	
КонецПроцедуры // ПриЗаписи
  
// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	// Проверка ручной корректировки
	Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
		Возврат
	КонецЕсли;
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация" , "ДоговорОрганизация");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидДоговора" , "ВидДоговора");
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	
	// для плательщиков КПН в любом случае формируются корреспонденции по отражению в налоговом учете
	// если признак "Отражать в НУ" в документе не установлен, то формируется проводка по постоянной разнице
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоНалоговомуУчету);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль и ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоБухгалтерскомуУчету);	
	СтруктураШапкиДокумента.Вставить("НеобходимостьОтраженияВНУ", 						УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль  ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ));
	СтруктураШапкиДокумента.Вставить("ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль", 	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль);
	СтруктураШапкиДокумента.Вставить("ОрганизацияПлательщикНалогаНаПрибыль", 			ОрганизацияПлательщикНалогаНаПрибыль);
	
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Номенклатура",			"НематериальныйАктив");
	СтруктураПолей.Вставить("Сумма",				"Сумма");
	СтруктураПолей.Вставить("СтавкаНДС",			"СтавкаНДС");
	СтруктураПолей.Вставить("НДС",					"СуммаНДС");
	СтруктураПолей.Вставить("СчетУчетаБУ",			"СчетУчетаБУ");
	СтруктураПолей.Вставить("СчетУчетаНУ",			"СчетУчетаНУ");
	СтруктураПолей.Вставить("СчетУчетаНДС",			"СчетУчетаНДС");
   	СтруктураПолей.Вставить("НДСВидОборота",		"НДСВидОборота");
	СтруктураПолей.Вставить("НДСВидПоступления",	"НДСВидПоступления");
	
	РезультатЗапросаПоНМА = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "НМА", СтруктураПолей);

	// Подготовим таблицы товаров для проведения.
	ТаблицаПоНМА = ПодготовитьТаблицуТоваров(РезультатЗапросаПоНМА, СтруктураШапкиДокумента);

	// Проверить заполнение ТЧ 
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоНМА, СтруктураШапкиДокумента, Отказ, Заголовок);

	// Проверим, не дублируются ли НМА в таб.части
	ТаблицаНМА = НМА.Выгрузить();
	УправлениеВнеоборотнымиАктивами.ПроверитьДублиНМА(ТаблицаНМА ,Отказ, Заголовок);
	
	УправлениеВзаиморасчетами.ПодготовкаТаблицыЗначенийДляЦелейПриобретенияИРеализации(ТаблицаПоНМА	,СтруктураШапкиДокумента,СтруктураШапкиДокумента.НДСВключенВСтоимость);
	
	// Подготовим таблицу УчастникиСовместнойДеятельности для проведения.
	ТаблицаПоУчастникамСовместнойДеятельности = ОбщегоНазначения.СформироватьТаблицуУчастниковСовместнойДеятельности(УчастникиСовместнойДеятельности);

	////Проверим на возможность проведения в БУ и НУ
	УправлениеВзаиморасчетами.ПроверкаВозможностиПроведенияВ_БУ_НУ(СтруктураШапкиДокумента, СтруктураШапкиДокумента.ДоговорКонтрагента, Отказ, Заголовок);

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
							ТаблицаПоНМА, ТаблицаПоУчастникамСовместнойДеятельности, Отказ, Заголовок);
							
		УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Истина, "СчетФактураПолученный");
		
		Если НЕ Отказ Тогда			
			ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ЭтотОбъект, СтруктураШапкиДокумента, Истина);		
		КонецЕсли;   
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Предопределенная процедура обработки удаления проведения документа
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
	Если  НЕ Отказ Тогда
		УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Ложь, "СчетФактураПолученный");
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаЗаполнения"
//
Процедура ОбработкаЗаполнения(Основание)
	// Обработка для работы в версии 8.2
	Если ТипЗнч(Основание) <> Тип("Структура")
		И Основание <> НЕОПРЕДЕЛЕНО Тогда
	
		ЗаполнитьПоДокументуОснования(Основание);	
	КонецЕсли;
КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
мПоддержкаРаботыСоСтруктурнымиПодразделениями = Истина;
//мПоддержкаРаботыСоСтруктурнымиПодразделениями = Константы.ПоддержкаРаботыСоСтруктурнымиПодразделениями.Получить();
мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();