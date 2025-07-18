﻿Перем мУдалятьДвижения;

// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

Перем мУчетнаяПолитикаПоНалоговомуУчету Экспорт; 
Перем мУчетнаяПолитикаПоБухгалтерскомуУчету Экспорт; 

Перем мОтображатьСтруктурныеПодразделения Экспорт; 

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
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

	// так как нет печатных форм у документа, по умолчанию
	// ТабДокумент = Неопределено
	ТабДокумент = Неопределено;
	
	Если ТабДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;  

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать()

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт

	Возврат Новый Структура();

КонецФункции // ПолучитьСписокПечатныхФорм()

// Функция возвращает процент торговой уступки для переданных
// договора эквайринга и вида оплаты.
//
// Параметры:
//  ДоговорЭквайринга - договор эквайринга, по которому нужно получить % торговой уступки.
//  ВидОплаты - вид оплаты, для которого  нужно получить % торговой уступки.
//
// Возвращаемое значение:
//  Число. Процент торговой уступки. 0 - если не найден.
//
Функция ПолучитьПроцентТорговойУступки(ДоговорЭквайринга, ВидОплаты) Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Тарифы.ПроцентТорговойУступки КАК ПроцентТорговойУступки
	|ИЗ
	|	Справочник.ДоговорыЭквайринга.ТарифыЗаРасчетноеОбслуживание КАК Тарифы
	|ГДЕ
	|	Тарифы.Ссылка = &ДоговорЭквайринга
	|	И Тарифы.ВидОплаты = &ВидОплаты
	|");
		
	Запрос.УстановитьПараметр("ДоговорЭквайринга", ДоговорЭквайринга);
	Запрос.УстановитьПараметр("ВидОплаты", ВидОплаты);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПроцентТорговойУступки = Выборка.ПроцентТорговойУступки;
	Иначе
		ПроцентТорговойУступки = 0;
	КонецЕсли;

	Возврат ПроцентТорговойУступки;

КонецФункции // ПолучитьПроцентТорговойУступки()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Проверяет установленные курсы валют документа перед пересчетом сумм
// Нулевые курсы устанавливаются в 1
//
Процедура ПроверкаКурсовВалют(СтрокаПлатеж) Экспорт

	КурсДокумента      = ?(КурсДокумента      = 0, 1, КурсДокумента);
	КратностьДокумента = ?(КратностьДокумента = 0, 1, КратностьДокумента);
	
	Если Не СтрокаПлатеж = Неопределено Тогда
		СтрокаПлатеж.КурсВзаиморасчетов      = ?(СтрокаПлатеж.КурсВзаиморасчетов      = 0, 1, СтрокаПлатеж.КурсВзаиморасчетов);
		СтрокаПлатеж.КратностьВзаиморасчетов = ?(СтрокаПлатеж.КратностьВзаиморасчетов = 0, 1, СтрокаПлатеж.КратностьВзаиморасчетов);
	КонецЕсли;

КонецПроцедуры // ПроверкаКурсовВалют()

Процедура ПересчитатьСуммуНДС(СтрокаПлатеж) Экспорт

	ЗначениеСтавкиНДС     = УчетНДСИАкциза.ПолучитьСтавкуНДС(СтрокаПлатеж.СтавкаНДС);
	СтрокаПлатеж.СуммаНДС = СтрокаПлатеж.СуммаПлатежа*ЗначениеСтавкиНДС/(100+ЗначениеСтавкиНДС);

КонецПроцедуры // ПересчитатьСуммуНДС()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	Если Основание = Неопределено ИЛИ НЕ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Основание)) Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента = мВалютаРегламентированногоУчета;
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

	Дата = ОбщегоНазначения.ПолучитьРабочуюДату();
		
	ПараметрыДокументаОснования = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(Основание);
	ВидДокументаОснования       = Основание.Метаданные().Имя;

	ДокументОснование = ПараметрыДокументаОснования.Ссылка;
		
	Если ВидДокументаОснования = "СчетНаОплатуПокупателю" Тогда
		
		СчетаУчета = УправлениеВзаиморасчетами.ПолучитьСчетаРасчетовСКонтрагентом(ПараметрыДокументаОснования.Организация, 
		                                                ПараметрыДокументаОснования.Контрагент, ПараметрыДокументаОснования.ДоговорКонтрагента);
		ПараметрыДокументаОснования.Вставить("СчетУчетаРасчетовСКонтрагентом", СчетаУчета.СчетРасчетовПокупателя);
		ПараметрыДокументаОснования.Вставить("СчетУчетаРасчетовПоАвансам",     СчетаУчета.СчетАвансовПокупателя);
		
	КонецЕсли;

	Если ВидДокументаОснования = "РеализацияТоваровУслуг"
		ИЛИ ВидДокументаОснования = "АктОбОказанииПроизводственныхУслуг" 
		ИЛИ ВидДокументаОснования = "РеализацияУслугПоПереработке"
		ИЛИ ВидДокументаОснования = "ВозвратТоваровОтПокупателя" 		
		ИЛИ ВидДокументаОснования = "СчетНаОплатуПокупателю" Тогда
		
		Если ВидДокументаОснования = "ВозвратТоваровОтПокупателя"  Тогда
			ВидОперации = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ВозвратДенежныхСредствПокупателю;
		Иначе
			ВидОперации = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ОплатаПокупателя;
		КонецЕсли; 
		
		Контрагент 			  = ПараметрыДокументаОснования.Контрагент;
		ДоговорКонтрагента 	  = ПараметрыДокументаОснования.ДоговорКонтрагента;
		ВидРасчетовПоДоговору = УправлениеВзаиморасчетами.ОпределениеВидаРасчетовПоПараметрамДоговора(ДоговорКонтрагента,мВалютаРегламентированногоУчета);
		
		Контрагент 			  = ПараметрыДокументаОснования.Контрагент;
		ДоговорКонтрагента 	  = ПараметрыДокументаОснования.ДоговорКонтрагента;
		
		ДоговорЭквайринга = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойДоговорЭквайринга");
		Если ЗначениеЗаполнено(ДоговорЭквайринга) Тогда
			
			ДоговорВзаиморасчетовЭквайрера = ДоговорЭквайринга.ДоговорВзаиморасчетов;
			Эквайрер = ДоговорЭквайринга.Эквайрер;
			
			СчетаУчетаЭквайра = УправлениеВзаиморасчетами.ПолучитьСчетаРасчетовСКонтрагентом(ПараметрыДокументаОснования.Организация, 
			                                                Эквайрер, ДоговорВзаиморасчетовЭквайрера);
			СчетУчетаРасчетовСЭквайрером = СчетаУчетаЭквайра.СчетРасчетовПокупателя;
			
		КонецЕсли;
		
		ВидРасчетовПоДоговору = УправлениеВзаиморасчетами.ОпределениеВидаРасчетовПоПараметрамДоговора(ДоговорВзаиморасчетовЭквайрера, мВалютаРегламентированногоУчета);
		
		Если ВидРасчетовПоДоговору = Перечисления.ВидыРасчетовПоДоговорам.РасчетыВИностраннойВалюте Тогда
			ВалютаДокумента = ДоговорВзаиморасчетовЭквайрера.ВалютаВзаиморасчетов;
		КонецЕсли;
		
		СтруктураКурсаДокумента = ОбщегоНазначения.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		КурсДокумента           = СтруктураКурсаДокумента.Курс;
		КратностьДокумента      = СтруктураКурсаДокумента.Кратность;
		
		СтруктураКурсаВзаиморасчетов  = ОбщегоНазначения.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		
		ТаблицаПлатежей = РасшифровкаПлатежа.Выгрузить();
		
		СуммаДокументаОснования = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание);
		СуммаДокументаОснования.Колонки.Сумма.Имя = "СуммаПлатежа";
		
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(СуммаДокументаОснования, ТаблицаПлатежей);
		Если ТаблицаПлатежей.Количество() = 0 тогда
			ТаблицаПлатежей.Добавить();
		КонецЕсли;
		
		ТаблицаПлатежей.ЗаполнитьЗначения(ДоговорКонтрагента,                     "ДоговорКонтрагента");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Курс,      "КурсВзаиморасчетов");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Кратность, "КратностьВзаиморасчетов");
		
		Если ПараметрыДокументаОснования.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Основание, "Сделка");
		КонецЕсли;
		
		ТаблицаПлатежей.ЗагрузитьКолонку(ТаблицаПлатежей.ВыгрузитьКолонку("СуммаПлатежа"),"СуммаВзаиморасчетов");
		
		Для каждого СтрокаПлатеж Из ТаблицаПлатежей Цикл
			ПроверкаКурсовВалют(СтрокаПлатеж);
		КонецЦикла;
		
		ТаблицаПлатежей.ЗаполнитьЗначения(ПараметрыДокументаОснования.СчетУчетаРасчетовСКонтрагентом, "СчетУчетаРасчетовСКонтрагентомБУ");
		
		Если ВидДокументаОснования = "ВозвратТоваровОтПокупателя" Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(ПараметрыДокументаОснования.СчетУчетаРасчетовПоВозвратам, "СчетУчетаРасчетовПоАвансам");        			
		Иначе
			ТаблицаПлатежей.ЗаполнитьЗначения(ПараметрыДокументаОснования.СчетУчетаРасчетовПоАвансам,   "СчетУчетаРасчетовПоАвансам");        			
		КонецЕсли;
		
		РасшифровкаПлатежа.Загрузить(ТаблицаПлатежей);
		СуммаДокумента 	= РасшифровкаПлатежа.Итог("СуммаПлатежа");
		СтрокаПлатеж 	= РасшифровкаПлатежа[0];
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОплатаОтПокупателяПлатежнойКартой") Тогда

		ВидОперации  = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ВозвратДенежныхСредствПокупателю;
		
		ВидОплаты 		   			   = Основание.ВидОплаты;
		ДоговорЭквайринга			   = Основание.ДоговорЭквайринга;
		ДоговорВзаиморасчетовЭквайрера = Основание.ДоговорВзаиморасчетовЭквайрера;
		Контрагент   				   = Основание.Контрагент;
		ПроцентТорговойУступки		   = Основание.ПроцентТорговойУступки;
        СуммаТорговойУступки		   = Основание.СуммаТорговойУступки;
		Эквайрер 					   = Основание.Эквайрер;
		СчетУчетаРасчетовСЭквайрером   = Основание.СчетУчетаРасчетовСЭквайрером;
		СуммаДокумента 				   = Основание.СуммаДокумента;
		
		Для Каждого СтрокаПлатежОснование Из Основание.РасшифровкаПлатежа Цикл
			СтрокаПлатеж = РасшифровкаПлатежа.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПлатеж, СтрокаПлатежОснование);
			ПроверкаКурсовВалют(СтрокаПлатеж);
		КонецЦикла;
		
	КонецЕсли;
	
	ЕстьРасчетыСКонтрагентами = Истина;
	ЕстьРасчетыПоКредитам     = Ложь;
	Ответственный             = глЗначениеПеременной("глТекущийПользователь");
	
КонецПроцедуры

// Формирует структуру полей, обязательных для заполнения при отражении фактического
// движения средств по банку.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейОплатаУпр()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("Организация");
	СтруктураПолей.Вставить("СуммаДокумента");
	СтруктураПолей.Вставить("Контрагент");
	СтруктураПолей.Вставить("ДоговорЭквайринга");
	СтруктураПолей.Вставить("Эквайрер");
	СтруктураПолей.Вставить("ДоговорВзаиморасчетовЭквайрера");
	СтруктураПолей.Вставить("ВидОплаты");
	СтруктураПолей.Вставить("СчетУчетаРасчетовСЭквайрером");
	Если УчитыватьКПН Тогда
		СтруктураПолей.Вставить("ВидУчетаНУ");
	КонецЕсли;

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Проверяет значение, необходимое при проведении
Процедура ПроверитьЗначение(Значение, Отказ, Заголовок, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда 
		
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита """+ИмяРеквизита+"""",Отказ, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗначение()

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураШапкиДокумента)

	ДвиженияПоРегистрамРегл(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);
 	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамРегл(Режим, Отказ, Заголовок, СтруктураШапкиДокумента)

	ПроводкиБУ = Движения.Типовой;
	ПроводкиНУ = Движения.Налоговый;
	
	СчетУчетаРасчетовСЭквайреромНУ = ПроцедурыНалоговогоУчета.ПолучитьСчетРасчетовСКонтрагентомНУ(СчетУчетаРасчетовСЭквайрером);

	СтруктураШапкиДокумента.Вставить("КоррСчет",   СчетУчетаРасчетовСЭквайрером);		
	СтруктураШапкиДокумента.Вставить("КоррСчетНУ", СчетУчетаРасчетовСЭквайреромНУ);
	
	ВидСубконтоКонтрагент = СчетУчетаРасчетовСЭквайрером.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты, "ВидСубконто");
	Если НЕ ВидСубконтоКонтрагент = Неопределено Тогда
		КолонкаЭквайрера = "КоррСубконто" + Формат(ВидСубконтоКонтрагент.НомерСтроки, "ЧГ=");
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("На выбранном счете расчетов с эквайрером отсутствует аналитика по контрагентам!", Отказ, Заголовок);
	КонецЕсли;
	
	ВидСубконтоДоговоры = СчетУчетаРасчетовСЭквайрером.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры, "ВидСубконто");
	Если НЕ ВидСубконтоДоговоры = Неопределено Тогда
		КолонкаДоговора  = "КоррСубконто" + Формат(ВидСубконтоДоговоры.НомерСтроки, "ЧГ=");
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("На выбранном счете расчетов с эквайрером отсутствует аналитика по договорам!", Отказ, Заголовок);
	КонецЕсли;
	
	ВидСубконтоДокументыРасчетов = СчетУчетаРасчетовСЭквайрером.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами, "ВидСубконто");
	Если НЕ ВидСубконтоДокументыРасчетов = Неопределено Тогда
		КолонкаДокументыРасчетов  = "КоррСубконто" + Формат(ВидСубконтоДокументыРасчетов.НомерСтроки, "ЧГ=");
	КонецЕсли;
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ Тогда 
		ВидСубконтоКонтрагентыНУ = СчетУчетаРасчетовСЭквайреромНУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты, "ВидСубконто");
		Если НЕ ВидСубконтоКонтрагентыНУ = Неопределено Тогда
			КолонкаЭквайрераНУ = "КоррСубконтоНУ" + Формат(ВидСубконтоКонтрагентыНУ.НомерСтроки, "ЧГ=");
		Иначе
			ОбщегоНазначения.СообщитьОбОшибке("На счете расчетов с эквайрером (НУ), соответствующему выбранному счету расчетов с эквайрером (БУ) отсутствует аналитика по контрагентам!",Отказ, Заголовок);
		КонецЕсли;
		
		ВидСубконтоДоговорыНУ = СчетУчетаРасчетовСЭквайреромНУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры, "ВидСубконто");
		Если НЕ ВидСубконтоДоговорыНУ = Неопределено Тогда
			КолонкаДоговораНУ  = "КоррСубконтоНУ" + Формат(ВидСубконтоДоговорыНУ.НомерСтроки, "ЧГ=");
		Иначе
			ОбщегоНазначения.СообщитьОбОшибке("На счете расчетов с эквайрером (НУ), соответствующему выбранному счету расчетов с эквайрером (БУ) отсутствует аналитика по договорам!",Отказ, Заголовок);
		КонецЕсли;
		
		ВидСубконтоДокументыРасчетовНУ = СчетУчетаРасчетовСЭквайреромНУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами, "ВидСубконто");
		Если НЕ ВидСубконтоДокументыРасчетовНУ = Неопределено Тогда
			КолонкаДокументыРасчетовНУ  = "КоррСубконтоНУ" + Формат(ВидСубконтоДокументыРасчетовНУ.НомерСтроки, "ЧГ=");
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;		
		
	КонецЕсли;
	
	РеестрПлатежей = УправлениеДенежнымиСредствами.ПодготовитьТаблицуОплат(СтруктураШапкиДокумента);
	ПереворачиватьОтрицательныеПроводки = Истина;
	
	//заполним кор.субконто в таблице платежей
	РеестрПлатежей.ЗаполнитьЗначения(Эквайрер, КолонкаЭквайрера);
	РеестрПлатежей.ЗаполнитьЗначения(ДоговорВзаиморасчетовЭквайрера, КолонкаДоговора);
	Если НЕ ВидСубконтоДокументыРасчетов = Неопределено Тогда
		РеестрПлатежей.ЗаполнитьЗначения(Ссылка, КолонкаДокументыРасчетов);
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ Тогда
		РеестрПлатежей.ЗаполнитьЗначения(Эквайрер, КолонкаЭквайрераНУ);
		РеестрПлатежей.ЗаполнитьЗначения(ДоговорВзаиморасчетовЭквайрера, КолонкаДоговораНУ);
		Если НЕ ВидСубконтоДокументыРасчетовНУ = Неопределено Тогда
			РеестрПлатежей.ЗаполнитьЗначения(Ссылка, КолонкаДокументыРасчетовНУ);
		КонецЕсли;
	КонецЕсли;
	
	СодержаниеПроводки = "Перенос задолженности";
		
	УправлениеДенежнымиСредствами.ДвижениеДенег(ЭтотОбъект, СтруктураШапкиДокумента, Истина, Отказ, Заголовок, СодержаниеПроводки, , РеестрПлатежей, ПереворачиватьОтрицательныеПроводки);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок)

	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейОплатаУпр(), Отказ, Заголовок);

	Если НЕ РасшифровкаПлатежа.Итог("СуммаПлатежа") = СуммаДокумента Тогда

		Сообщить(Заголовок+"
			|не совпадают сумма документа и ее расшифровка.");
		Отказ = Истина;

	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаРегл(СтруктураШапкиДокумента,Отказ, Заголовок)

    ВыводитьНомераСтрокВСообщении = РасшифровкаПлатежа.Количество() > 1;
    
    Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
        
        СтруктураПолейТЧ = Новый Структура("СчетУчетаРасчетовСКонтрагентомБУ, ДоговорКонтрагента, СуммаВзаиморасчетов");
        
        ОбщегоНазначения.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "РасшифровкаПлатежа", СтруктураПолейТЧ, Отказ, Заголовок, ВыводитьНомераСтрокВСообщении);
        
    КонецЕсли;
    
    ВидСубконтоКонтрагент = ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты;
    ВидСубконтоДоговоры = ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры;
    
    Для Каждого СтрокаОплаты из РасшифровкаПлатежа Цикл
        
        ДополнениеКСообщению = ?(ВыводитьНомераСтрокВСообщении, "Строка " + СтрокаОплаты.НомерСтроки + " - ", "");
        
        УправлениеВзаиморасчетами.ПроверкаВозможностиПроведенияВ_БУ_НУ(СтруктураШапкиДокумента, СтрокаОплаты.ДоговорКонтрагента,
                                        Отказ, Заголовок, ДополнениеКСообщению);
                                        
        Если Не Отказ Тогда
            
            Если ЗначениеЗаполнено(Организация) 
                И Организация <> СтрокаОплаты.ДоговорКонтрагента.Организация Тогда
                ОбщегоНазначения.СообщитьОбОшибке(ДополнениеКСообщению + "Выбран договор контрагента, не соответствующий организации, указанной в документе!", Отказ, Заголовок);
            КонецЕсли;
            
            СубконтоКонтрагент = СтрокаОплаты.СчетУчетаРасчетовСКонтрагентомБУ.ВидыСубконто.Найти(ВидСубконтоКонтрагент, "ВидСубконто");
            Если СубконтоКонтрагент = Неопределено Тогда
                ОбщегоНазначения.СообщитьОбОшибке(ДополнениеКСообщению + "На выбранном cчете учета расчетов с контрагентом отсутствует аналитика по контрагентам!", Отказ, Заголовок);
            КонецЕсли;
            
            СубконтоДоговоры = СтрокаОплаты.СчетУчетаРасчетовСКонтрагентомБУ.ВидыСубконто.Найти(ВидСубконтоДоговоры, "ВидСубконто");
            Если СубконтоДоговоры = Неопределено Тогда
                ОбщегоНазначения.СообщитьОбОшибке(ДополнениеКСообщению + "На выбранном счете учета расчетов с контрагентом отсутствует аналитика по договорам!", Отказ, Заголовок);
            КонецЕсли;
            
            Если ЗначениеЗаполнено(СтрокаОплаты.СчетУчетаРасчетовПоАвансам) Тогда
                
                СубконтоКонтрагент = СтрокаОплаты.СчетУчетаРасчетовПоАвансам.ВидыСубконто.Найти(ВидСубконтоКонтрагент, "ВидСубконто");
                Если СубконтоКонтрагент = Неопределено Тогда
                    ОбщегоНазначения.СообщитьОбОшибке(ДополнениеКСообщению + "На выбранном cчете учета расчетов по авансам отсутствует аналитика по контрагентам!", Отказ, Заголовок);
                КонецЕсли;
                
                СубконтоДоговоры = СтрокаОплаты.СчетУчетаРасчетовПоАвансам.ВидыСубконто.Найти(ВидСубконтоДоговоры, "ВидСубконто");
                Если СубконтоДоговоры = Неопределено Тогда
                    ОбщегоНазначения.СообщитьОбОшибке(ДополнениеКСообщению + "На выбранном счете учета расчетов по авансам отсутствует аналитика по договорам!", Отказ, Заголовок);
                КонецЕсли;
                
            КонецЕсли;
            
        КонецЕсли;
        
    КонецЦикла; 
    
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)
	
	ЗаполнитьПоДокументуОснования(Основание);
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Перем Заголовок, СтруктураШапкиДокумента;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если мУдалятьДвижения Тогда
		// Проверка ручной корректировки
		Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка, Отказ, Заголовок, ЭтотОбъект) Тогда
			Возврат
		КонецЕсли;
	КонецЕсли;
	
	//Проверяем заполнение табличных частей
	СтруктураШапкиДокумента   = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента.Вставить("ВалютаРегламентированногоУчета",   мВалютаРегламентированногоУчета);
	
	// для плательщиков КПН в любом случае формируются корреспонденции по отражению в налоговом учете
	ОрганизацияПлательщикНалогаНаПрибыль           = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоНалоговомуУчету);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль = ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоБухгалтерскомуУчету);	
	ВедениеУчетаВременныхРазницБалансовымМетодом   = ПроцедурыНалоговогоУчета.ПолучитьПризнакВеденияУчетаВременныхРазницБалансовымМетодом(Организация, Дата, мУчетнаяПолитикаПоБухгалтерскомуУчету);
	       
	СтруктураШапкиДокумента.Вставить("НеобходимостьОтраженияВНУ", 						УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ) И ВедениеУчетаВременныхРазницБалансовымМетодом);
	СтруктураШапкиДокумента.Вставить("ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль", 	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль);
	СтруктураШапкиДокумента.Вставить("ОрганизацияПлательщикНалогаНаПрибыль", 			ОрганизацияПлательщикНалогаНаПрибыль);
	СтруктураШапкиДокумента.Вставить("ВедениеУчетаВременныхРазницБалансовымМетодом", 	ВедениеУчетаВременныхРазницБалансовымМетодом);
	
	СтруктураШапкиДокумента.Вставить("КорСчет",               СчетУчетаРасчетовСЭквайрером);
	СтруктураШапкиДокумента.Вставить("ВидЗадолженности",      Перечисления.ВидыЗадолженности.Дебиторская);
	СтруктураШапкиДокумента.Вставить("ВедениеВзаиморасчетов", ДоговорВзаиморасчетовЭквайрера.ВедениеВзаиморасчетов);
	СтруктураШапкиДокумента.Вставить("ВалютаВзаиморасчетов",  ДоговорВзаиморасчетовЭквайрера.ВалютаВзаиморасчетов);
			
	СтруктураКурсаДокумента   = ОбщегоНазначения.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента             = СтруктураКурсаДокумента.Курс;
	КратностьДокумента        = СтруктураКурсаДокумента.Кратность;

	ЕстьРасчетыСКонтрагентами = Истина;
	ЕстьРасчетыПоКредитам     = Ложь;

	ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок);
	ПроверитьЗаполнениеДокументаРегл(СтруктураШапкиДокумента,Отказ, Заголовок);

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)

	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);

КонецПроцедуры // ОбработкаУдаленияПроведения

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();
