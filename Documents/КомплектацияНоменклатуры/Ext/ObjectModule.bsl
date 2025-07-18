﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

Перем мУчетнаяПолитикаПоНалоговомуУчету Экспорт;
Перем мУчетнаяПолитикаПоБухгалтерскомуУчету Экспорт;

Перем мОтображатьСтруктурныеПодразделения Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Процедура заполняет табличную часть Комплектующих из регистра сведений
// КомплектующиеНоменклатуры
//
Процедура ЗаполнитьКомплектующие() Экспорт

	Если Комплектующие.Количество() > 0 Тогда

		ТекстВопроса = "Перед заполнением табличная часть будет очищена. Заполнить?";
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли; 
		
		Комплектующие.Очистить();
		НомераГТД.Очистить();
	КонецЕсли;

	ФормаВыбора = Справочники.СпецификацииНоменклатуры.ПолучитьФормуВыбора();
	ФормаВыбора.Заголовок = "Выберите спецификацию для заполнения комплектации";
	ФормаВыбора.РежимВыбора = Истина;

	// По умолчанию поставим отбор по договору и виду операции
	ФормаВыбора.Отбор.Владелец.Значение = Номенклатура;
	ФормаВыбора.Отбор.Владелец.Использование = Истина;

	Спецификация = ФормаВыбора.ОткрытьМодально();
	Если НЕ ЗначениеЗаполнено(Спецификация) Тогда
		Возврат;
	КонецЕсли;
	
	КоэффициентКоличества = ?(Спецификация.Количество = 0, Количество, Количество/Спецификация.Количество);
	
	ПоддержкаУчетаВременныхРазниц = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата, Неопределено) и ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата, Неопределено);
	ВедениеУчетаВременныхРазницБалансовымМетодом = ПроцедурыНалоговогоУчета.ПолучитьПризнакВеденияУчетаВременныхРазницБалансовымМетодом(Организация, Дата, Неопределено);
	Для Каждого Строка Из Спецификация.ИсходныеКомплектующие Цикл
		НоваяСтрока 					= Комплектующие.Добавить();
		НоваяСтрока.Номенклатура        = Строка.Номенклатура;
		НоваяСтрока.Количество          = Строка.Количество * КоэффициентКоличества;
		НоваяСтрока.ЕдиницаИзмерения    = Строка.Номенклатура.БазоваяЕдиницаИзмерения;
		НоваяСтрока.ДоляСтоимости       = 1;
		НоваяСтрока.Коэффициент         = 1;
		НоваяСтрока.КлючСвязи 			= ОбщегоНазначенияКлиентСервер.НовыйКлючСвязиСтрокиТаблицы(Комплектующие);	
		ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(НоваяСтрока, Истина, УчитыватьКПН И ВедениеУчетаВременныхРазницБалансовымМетодом И (ПоддержкаУчетаВременныхРазниц ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ));
	КонецЦикла;	

КонецПроцедуры // ЗаполнитьКомплектующие()

// Функция формирует табличный документ
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьКомплектацияНоменклатуры()

	ВыводитьКоды    = Истина;
	ТекстКодАртикул = "Код";
	
	Если ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	""" + ТекстКодАртикул + ":""        КАК ИмяКодАртикул,
	|	Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|	ВЫРАЗИТЬ(Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК Комплект,
	|	Номенклатура,
	|	ЕдиницаИзмерения,
	|	Количество,
	|	Ответственный,
	|	Организация
	|ИЗ
	|	Документ.КомплектацияНоменклатуры КАК КомплектацияНоменклатуры
	|
	|ГДЕ
	|	КомплектацияНоменклатуры.Ссылка = &ТекущийДокумент";
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|	ВЫРАЗИТЬ(Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК Товар,
	|	Номенклатура,
	|	Количество,
	|	ЕдиницаИзмерения,
	|	НомерСтроки
	|
	|ИЗ
	|	Документ.КомплектацияНоменклатуры.Комплектующие КАК КомплектацияНоменклатурыКомплектующие
	|
	|ГДЕ
	|	КомплектацияНоменклатурыКомплектующие.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки ВОЗР
	|";

	ЗапросКомплектующие = Запрос.Выполнить().Выгрузить();

	Макет        = ПолучитьМакет("Комплектация");
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КомплектацияНоменклатуры_Комплектация";

	// Выводим шапку накладной
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект, ?(ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Комплектация, "Комплектация", "Разукомплектация")+" номенклатуры");
	ТабДокумент.Вывести(ОбластьМакета);

	Если ВыводитьКоды Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("КомплектКод");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли;

	ОбластьМакета = Макет.ПолучитьОбласть("Комплект");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.Комплект           = СокрЛП(Шапка.Комплект);
	ОбластьМакета.Параметры.КоличествоНаПечать = "" + Шапка.Количество + " ("+Шапка.ЕдиницаИзмерения+")";
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
	Если ВыводитьКоды Тогда
		ОбластьМакета.Параметры.ИмяКодАртикул = ТекстКодАртикул;
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьМакета);

	Для каждого ВыборкаСтрокКомплектующие Из ЗапросКомплектующие Цикл

		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокКомплектующие.Номенклатура) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("В одной из строк не заполнено значение комплектующей - строка при печати пропущена.");
			Продолжить;
		КонецЕсли;

		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокКомплектующие);
		ОбластьМакета.Параметры.НомерСтроки = ЗапросКомплектующие.Индекс(ВыборкаСтрокКомплектующие) + 1;
		ОбластьМакета.Параметры.Товар       = СокрЛП(ВыборкаСтрокКомплектующие.Номенклатура);
		ТабДокумент.Вывести(ОбластьМакета);

	КонецЦикла;

	// Вывести подписи
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.ОтветственныйПредставление = "/"+ Шапка.Ответственный + "/";
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьПеремещениеТоваров()

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
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
    	
	Если ИмяМакета = "Комплектация" Тогда
		// Получить экземпляр документа на печать
		ТабДокумент = ПечатьКомплектацияНоменклатуры();
		
	КонецЕсли;


	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Ссылка);

КонецПроцедуры // Печать()

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Комплектация","Комплектация номенклатуры");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


// Дополняет новую строку реквизитами регламентированного учета из исходной строки
//
// Параметры:
// НоваяСтрока    - строка, которую необходимо дополнить
// ИсходнаяСтрока - строка, из которой берутся исходные данные
//
Процедура ДополнитьСтрокуРегл(НоваяСтрока, ИсходнаяСтрока)

	НоваяСтрока.СчетУчетаБУ         = ИсходнаяСтрока.СчетУчетаБУ;
	НоваяСтрока.СчетУчетаНУ         = ИсходнаяСтрока.СчетУчетаНУ;

КонецПроцедуры // ДополнитьСтрокуРегл

// Заполняет табличную часть при оперативном проведении
//
// Параметры:
//  Отказ - отказ от дальнейшего проведения.
//
Процедура ЗаполнитьТабличныеЧастиПередПроведением(Отказ) Экспорт
    	
КонецПроцедуры // ЗаполнитьТабличныеЧастиПередПроведением()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ РАБОТЫ ФОРМ

// Процедура заполняет начальными значениями документ
Процедура ЗаполнитьНачальнымиЗначениями() Экспорт

	// Вызвать общую процедуру для заполнения основных реквизитов
	//ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект, глТекущийПользователь);

	// Дозаполнить особенные для формы реквизиты

КонецПроцедуры // ЗаполнитьНачальнымиЗначениями()

Процедура ЗаполнитьСчетаБУРегл(СтрокаТЧ, СчетаУчета, ЗаполнятьБУ, ЗаполнятьНУ)

	Если ЗаполнятьБУ = Истина Тогда
		СтрокаТЧ.СчетУчетаБУ = СчетаУчета.СчетУчетаБУ;

	ИначеЕсли ЗаполнятьБУ = Ложь Тогда
		СтрокаТЧ.СчетУчетаБУ = ПланыСчетов.Типовой.ПустаяСсылка();

	КонецЕсли;

	Если ЗаполнятьНУ = Истина Тогда
		СтрокаТЧ.СчетУчетаНУ = СчетаУчета.СчетУчетаНУ;

	ИначеЕсли ЗаполнятьНУ = Ложь Тогда
		СтрокаТЧ.СчетУчетаНУ = ПланыСчетов.Налоговый.ПустаяСсылка();
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(СтрокаТЧ, ЗаполнятьБУ, ЗаполнятьНУ) Экспорт

	СчетаУчета = ПроцедурыБухгалтерскогоУчета.ПолучитьСчетаУчетаНоменклатуры(Организация, СтрокаТЧ.Номенклатура);

	ЗаполнитьСчетаБУРегл(СтрокаТЧ, СчетаУчета, ЗаполнятьБУ, ЗаполнятьНУ);

КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл()

/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - текст для дополнительной информации об ошибки проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
	Новый Структура("Организация, Склад, ВидОперации, Номенклатура, Количество, СчетУчетаБУ");
	
	Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ  Тогда
		СтруктураОбязательныхПолей.Вставить("СчетУчетаНУ");
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.УчитыватьКПН Тогда
		СтруктураОбязательныхПолей.Вставить("ВидУчетаНУ");
	КонецЕсли;
			
	// Теперь вызовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Комплектуемая номенклатура не может быть услугой или набором
	Если СтруктураШапкиДокумента.Услуга = Истина Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Комплектуемая номенклатура не может быть услугой!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоКомплектующим - результат запроса по табличной части "Комплектующие",
//  СтруктураШапкиДокумента         - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуКомплектующих(РезультатЗапросаПоКомплектующим, СтруктураШапкиДокумента)

	ТаблицаКомплектующих = РезультатЗапросаПоКомплектующим.Выгрузить();
	
	ТаблицаКомплектующих.Колонки.Добавить("Сумма");
	ТаблицаКомплектующих.Колонки.Добавить("СуммаВал");
	ТаблицаКомплектующих.Колонки.Добавить("ДоговорКонтрагента");
	ТаблицаКомплектующих.Колонки.Добавить("Регистратор");
	ТаблицаКомплектующих.Колонки.Добавить("Склад");
	ТаблицаКомплектующих.Колонки.Добавить("Организация");
	ТаблицаКомплектующих.Колонки.Добавить("СтруктурноеПодразделение");
			
	ТаблицаКомплектующих.Колонки.Добавить("ДокументОприходования");
	ТаблицаКомплектующих.Колонки.Добавить("ДоговорПоставщика");
	ТаблицаКомплектующих.Колонки.Добавить("КоэффОплаты");

	КоэффОплаты      = 1;

	ТаблицаКомплектующих.ЗаполнитьЗначения(0,            "Сумма");
	ТаблицаКомплектующих.ЗаполнитьЗначения(0,            "СуммаВал");
	ТаблицаКомплектующих.ЗаполнитьЗначения(КоэффОплаты,  "КоэффОплаты");
	ТаблицаКомплектующих.ЗаполнитьЗначения(Неопределено, "ДоговорКонтрагента");
	ТаблицаКомплектующих.ЗаполнитьЗначения(ЭтотОбъект,   "Регистратор");
	ТаблицаКомплектующих.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, "Склад");
	ТаблицаКомплектующих.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация,   "Организация");
	
	ТаблицаКомплектующих.ЗаполнитьЗначения(СтруктураШапкиДокумента.СтруктурноеПодразделение,   "СтруктурноеПодразделение");
	
		
	Для Каждого СтрокаТаблицы ИЗ ТаблицаКомплектующих Цикл
		Если (СтрокаТаблицы.Коэффициент<>0) Тогда
			СтрокаТаблицы.Количество = СтрокаТаблицы.Количество*СтрокаТаблицы.Коэффициент;
		КонецЕсли;
	КонецЦикла;

	Возврат ТаблицаКомплектующих;

КонецФункции // ПодготовитьТаблицуКомплектующих()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоКомплектующим - результат запроса по табличной части "Комплектующие",
//  СтруктураШапкиДокумента         - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений по комплектам.
//
Функция ПодготовитьТаблицуКомплектов(РезультатЗапросаПоКомплектующим, СтруктураШапкиДокумента)

	// подготовим структуру таблицы
	ТаблицаКомплектов = РезультатЗапросаПоКомплектующим.Выгрузить();
	ТаблицаКомплектов.Очистить();

	НоваяСтрока = ТаблицаКомплектов.Добавить();
	НоваяСтрока.Номенклатура                 = СтруктураШапкиДокумента.Номенклатура;
	НоваяСтрока.Услуга                       = СтруктураШапкиДокумента.Услуга;
	Если (СтруктураШапкиДокумента.Коэффициент<>0) Тогда
		НоваяСтрока.Количество = СтруктураШапкиДокумента.Количество*СтруктураШапкиДокумента.Коэффициент;
	Иначе
		НоваяСтрока.Количество                   = СтруктураШапкиДокумента.Количество;
	КонецЕсли;
	
	НоваяСтрока.СчетУчетаБУ                  = СтруктураШапкиДокумента.СчетУчетаБУ;
	НоваяСтрока.СчетУчетаНУ                  = СтруктураШапкиДокумента.СчетУчетаНУ;
	НоваяСтрока.НомерСтроки                  = 0;
	
	Возврат ТаблицаКомплектов;

КонецФункции // ПодготовитьТаблицуКомплектов()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоКомплектующим  - таблица значений, содержащая данные для проведения и проверки ТЧ Комплектующие
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиКомплектующих(ТаблицаПоКомплектующим, СтруктураШапкиДокумента, Отказ, Заголовок)

	ИмяТабличнойЧасти = "Комплектующие";

	Если Комплектующие.Количество() = 0 Тогда
		ОбщегоНазначения.ОшибкаПриПроведении("Не заполнена табличная часть ""Комплектующие"".", Отказ, Заголовок);
	КонецЕсли;

	// Укажем, что надо проверить:
	Если ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Разукомплектация Тогда
		СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество, ДоляСтоимости");
	Иначе
		СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество");
	КонецЕсли;

	ДополнитьСтруктуруОбязательныхПолейТабличнойЧастиКомплектующиеРегл(ТаблицаПоКомплектующим, СтруктураШапкиДокумента, Отказ, Заголовок, СтруктураОбязательныхПолей);

	// Теперь вызовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Комплектующие",СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Комплектующие", ТаблицаПоКомплектующим, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиКомплектующих()

Процедура ДополнитьСтруктуруОбязательныхПолейТабличнойЧастиКомплектующиеРегл(ТаблицаПоКомплектующим, СтруктураШапкиДокумента, Отказ, Заголовок, СтруктураОбязательныхПолей)

	СтруктураОбязательныхПолей.Вставить("СчетУчетаБУ");
	Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ  Тогда
		СтруктураОбязательныхПолей.Вставить("СчетУчетаНУ");		
	КонецЕсли;  	
	
КонецПроцедуры

Процедура ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл(СтруктураПолей, СтруктураШапкиДокумента)

	СтруктураПолей.Вставить("СчетУчетаБУ"               , "СчетУчетаБУ");
	СтруктураПолей.Вставить("СчетУчетаНУ"               , "СчетУчетаНУ");
	
КонецПроцедуры // ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоКомплектующим    - таблица значений, содержащая данные для проведения и проверки ТЧ ТаблицаПоКомплектующим
//  ТаблицаПоКомплектам       - таблица значений, содержащая данные для проведения и проверки по комплектам,
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоКомплектующим, ТаблицаПоКомплектам, Отказ, Заголовок);

	// Проведение по партиям остановим в том случае, если не хватит хоть одного комплектующего.
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Комплектация Тогда
		
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСчетСписанияБУ");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ1");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ2");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ3");
							
		ТаблицаПоКомплектующим.Колонки.Добавить("КоличествоДт");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(Окр(ТаблицаПоКомплектам[0].Количество/ТаблицаПоКомплектующим.Количество(),3, 1), "КоличествоДт");
				
		
		РазницаСписанияКоэффициентов = ТаблицаПоКомплектам[0].Количество - ТаблицаПоКомплектующим.Итог("КоличествоДт"); 		
		//разница списания коэфициентов,  как результат округления
		//поэтому будем с каждой строки списывать(дописывать) по 0.001 (т.к. округления каждой строки, шло до тысячных долей, поэтому больше чем 0.001 для каждой строки
		//не может быть расхождений) пока разница не сойдется в ноль   		
		Для Каждого Строка Из ТаблицаПоКомплектующим Цикл
			Если РазницаСписанияКоэффициентов <> 0 Тогда
				Если РазницаСписанияКоэффициентов  > 0 Тогда
					КоэффициентРазницы = 1;
				Иначе
					КоэффициентРазницы = -1;
				КонецЕсли; 				
				Строка.КоличествоДт = Строка.КоличествоДт + (КоэффициентРазницы * 0.001);
				РазницаСписанияКоэффициентов = РазницаСписанияКоэффициентов - (КоэффициентРазницы * 0.001);
			Иначе
				Прервать;						
			КонецЕсли; 			
		КонецЦикла; 

		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].СчетУчетаБУ, 	"КорСчетСписанияБУ");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].Номенклатура, 	"КорСубконтоСписанияБУ1");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, 		"КорСубконтоСписанияБУ2");		
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, 	    "КорСубконтоСписанияБУ3");
		
		Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ  Тогда
			ТаблицаПоКомплектующим.Колонки.Добавить("КорСчетСписанияНУ");
			ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияНУ1");
			ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияНУ2");
			ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияНУ3");
			
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].СчетУчетаНУ, 	"КорСчетСписанияНУ");
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].Номенклатура, 	"КорСубконтоСписанияНУ1");
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, 		"КорСубконтоСписанияНУ2");
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, 	    "КорСубконтоСписанияНУ3")
		КонецЕсли;
		
				
		УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(ТаблицаПоКомплектующим, Истина, СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ , Отказ, , "Комплектация");
		
	Иначе
		
		ТаблицаПоКомплектующим.Колонки.СчетУчетаБУ.Имя = 	"КорСчетСписанияБУ";
		ТаблицаПоКомплектующим.Колонки.Номенклатура.Имя = 	"КорСубконтоСписанияБУ1";
		ТаблицаПоКомплектующим.Колонки.Количество.Имя = 	"КоличествоДт";
		
		ТаблицаПоКомплектующим.Колонки.Добавить("СчетУчетаБУ");
		ТаблицаПоКомплектующим.Колонки.Добавить("Номенклатура");
		
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ2");
		ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияБУ3");

		
		Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ Тогда
			ТаблицаПоКомплектующим.Колонки.СчетУчетаНУ.Имя = 	"КорСчетСписанияНУ";
			
			ТаблицаПоКомплектующим.Колонки.Добавить("СчетУчетаНУ");
						
			ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияНУ1");
			ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияНУ2");
			ТаблицаПоКомплектующим.Колонки.Добавить("КорСубконтоСписанияНУ3");
			
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].СчетУчетаНУ, 							   "СчетУчетаНУ");
			ТаблицаПоКомплектующим.ЗагрузитьКолонку(ТаблицаПоКомплектующим.ВыгрузитьКолонку("КорСубконтоСписанияБУ1"), "КорСубконтоСписанияНУ1");
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, 								   "КорСубконтоСписанияНУ2");
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, 	    						   "КорСубконтоСписанияНУ3");

		КонецЕсли;
		
		ТаблицаПоКомплектующим.Колонки.Добавить("Количество");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(0, "Количество");
		
		Если ТаблицаПоКомплектующим.Итог("ДоляСтоимости") = 0 Тогда
			ТаблицаПоКомплектующим.ЗаполнитьЗначения(1, "ДоляСтоимости");
		КонецЕсли;
		
		КоэффДоли = ТаблицаПоКомплектам[0].Количество / (ТаблицаПоКомплектующим.Итог("ДоляСтоимости"));
		
		Для Каждого Строка Из ТаблицаПоКомплектующим Цикл
			Строка.Количество = Окр(КоэффДоли * Строка.ДоляСтоимости, 3, 1);
		КонецЦикла;
		
		РазницаСписанияКоэффициентов = ТаблицаПоКомплектам[0].Количество - ТаблицаПоКомплектующим.Итог("Количество" );
					
		//разница списания коэфициентов,  как результат округления
		//поэтому будем с каждой строки списывать(дописывать) по 0.001 (т.к. округления каждой строки, шло до тысячных долей, поэтому больше чем 0.001 для каждой строки
		//не может быть расхождений) пока разница не сойдется в ноль   				
		Для Каждого Строка Из ТаблицаПоКомплектующим Цикл
			Если РазницаСписанияКоэффициентов <> 0 Тогда
				Если РазницаСписанияКоэффициентов  > 0 Тогда
					КоэффициентРазницы = 1;
				Иначе
					КоэффициентРазницы = -1;
				КонецЕсли; 				
				Строка.Количество = Строка.Количество + (КоэффициентРазницы * 0.001);
				РазницаСписанияКоэффициентов = РазницаСписанияКоэффициентов - (КоэффициентРазницы * 0.001);
			Иначе
				Прервать;						
			КонецЕсли; 			
		КонецЦикла; 
		
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].СчетУчетаБУ, 	"СчетУчетаБУ");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(ТаблицаПоКомплектам[0].Номенклатура, 	"Номенклатура");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Склад, 		"КорСубконтоСписанияБУ2");
		ТаблицаПоКомплектующим.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, 	    "КорСубконтоСписанияБУ3");
		
		УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(ТаблицаПоКомплектующим, Истина, СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ , Отказ, , "Комплектация");
		
	КонецЕсли
	    
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(Отказ, Заголовок, СтруктураШапкиДокумента)

	мУчетнаяПолитика   = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитики(КонецМесяца(Дата), Отказ, СтруктураШапкиДокумента.Организация, "Бух");
	мУчетнаяПолитикаНал = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитики(КонецМесяца(Дата), Отказ, СтруктураШапкиДокумента.Организация, "Нал");
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

Функция ПодготовитьТаблицуПоНомерамГТД()   
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Если ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Комплектация Тогда 
				
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	1 КАК НомерСтроки,
		|	"""" КАК ИмяСписка,
		|	Реквизиты.Номенклатура,
		|	Реквизиты.НомерГТД,
		|	(Реквизиты.Количество*Реквизиты.Коэффициент) КАК Количество,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения
		|ИЗ
		|	Документ.КомплектацияНоменклатуры КАК Реквизиты
		|ГДЕ
		|	Реквизиты.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки"; 
		
	 Иначе  		 		 
		 ТекстЗапроса =
		"ВЫБРАТЬ
		|	ТаблицаТовары.НомерСтроки,
		|	""Комплектующие"" КАК ИмяСписка,
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.НомерГТД,
		|	ТаблицаТовары.Количество * ТаблицаТовары.Коэффициент КАК Количество,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения
		|ИЗ
		|	Документ.КомплектацияНоменклатуры.Комплектующие КАК ТаблицаТовары
		|ГДЕ
		|	ТаблицаТовары.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаТовары.НомерСтроки"		
				
	КонецЕсли;

	Запрос.Текст =  ТекстЗапроса;
		
	Возврат Запрос.Выполнить().Выгрузить();	 
	
КонецФункции

Функция ПодготовитьТаблицуСписанияПоНомерамГТД()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка); 
	
	Запрос.Текст =
	  "ВЫБРАТЬ
	  |	1 КАК НомерСтроки,
	  |	1 КАК КлючСвязи,
	  |	"""" КАК ИмяСписка,
	  |	Реквизиты.Номенклатура,
	  |	Реквизиты.НомерГТД,
	  |	Реквизиты.Количество,
	  |	Реквизиты.Коэффициент,
	  |	Реквизиты.Ссылка КАК Ссылка
	  |ПОМЕСТИТЬ ТОВАРЫ
	  |ИЗ
	  |	Документ.КомплектацияНоменклатуры КАК Реквизиты
	  |ГДЕ
	  |	Реквизиты.Ссылка = &Ссылка
	  |;
	  |
	  |////////////////////////////////////////////////////////////////////////////////
	  |ВЫБРАТЬ
	  |	НомераГТД.НомерГТД,
	  |	Товары.Номенклатура КАК Номенклатура,
	  |	НомераГТД.Количество * Товары.Коэффициент КАК Количество,
	  |	НомераГТД.КлючСвязи,
	  |	Товары.Коэффициент,
	  |	Товары.НомерСтроки КАК НомерСтроки,
	  |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения
	  |ИЗ
	  |	Документ.КомплектацияНоменклатуры.НомераГТД КАК НомераГТД
	  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТОВАРЫ КАК Товары
	  |		ПО НомераГТД.КлючСвязи = Товары.КлючСвязи
	  |			И НомераГТД.Ссылка = Товары.Ссылка
	  |
	  |УПОРЯДОЧИТЬ ПО
	  |	НомерСтроки,
	  |	Товары.КлючСвязи" ;
	    				
	Возврат Запрос.Выполнить().Выгрузить();		
		 
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = "Проведение документа """ + СокрЛП(Ссылка) + """: ";

	// Проверка ручной корректировки
	Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Номенклатура", "Услуга", "Услуга");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// для плательщиков КПН в любом случае формируются корреспонденции по отражению в налоговом учете
	// если признак "Отражать в НУ" в документе не установлен, то формируется проводка по постоянной разнице
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоНалоговомуУчету);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль и ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоБухгалтерскомуУчету);	
	ВедениеУчетаВременныхРазницБалансовымМетодом = ПроцедурыНалоговогоУчета.ПолучитьПризнакВеденияУчетаВременныхРазницБалансовымМетодом(Организация, Дата, мУчетнаяПолитикаПоБухгалтерскомуУчету);
	       
	СтруктураШапкиДокумента.Вставить("НеобходимостьОтраженияВНУ", 						УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ) И ВедениеУчетаВременныхРазницБалансовымМетодом);
	СтруктураШапкиДокумента.Вставить("ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль", 	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль);
	СтруктураШапкиДокумента.Вставить("ОрганизацияПлательщикНалогаНаПрибыль", 			ОрганизацияПлательщикНалогаНаПрибыль);
	СтруктураШапкиДокумента.Вставить("ВедениеУчетаВременныхРазницБалансовымМетодом", 	ВедениеУчетаВременныхРазницБалансовымМетодом);
	
		
	//Надо позвать проверку заполнения реквизитов шапки
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"                 , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"                       , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Количество"                   , "Количество");
	СтруктураПолей.Вставить("Коэффициент"                  , "Коэффициент");
	СтруктураПолей.Вставить("НомерСтроки"                  , "НомерСтроки");
	СтруктураПолей.Вставить("ДоляСтоимости"                , "ДоляСтоимости");
	
	ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл(СтруктураПолей, СтруктураШапкиДокумента);

	РезультатЗапросаПоКомплектующим = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Комплектующие", СтруктураПолей);

	// Подготовим таблицы для проведения.
	ТаблицаПоКомплектующим = ПодготовитьТаблицуКомплектующих(РезультатЗапросаПоКомплектующим, СтруктураШапкиДокумента);
	ТаблицаПоКомплектам    = ПодготовитьТаблицуКомплектов(РезультатЗапросаПоКомплектующим, СтруктураШапкиДокумента);;

	// Проверить заполнение ТЧ "Товары".
	ПроверитьЗаполнениеТабличнойЧастиКомплектующих(ТаблицаПоКомплектующим, СтруктураШапкиДокумента, Отказ, Заголовок);

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоКомплектующим, ТаблицаПоКомплектам, Отказ, Заголовок);
		
		Если НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Дата) Тогда  
			СтруктураШапкиДокумента.Вставить("ИмяСписка", "Комплектующие"); 
			// Движения по товарам организаций (Расход)
			Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Разукомплектация Тогда 
				ТаблицаНомераРазукомплектация = ПодготовитьТаблицуСписанияПоНомерамГТД();
				// Списание источников происхождения.
				НомераГТДСервер.СформироватьДвиженияТоварыОрганизацийРасход(ТаблицаНомераРазукомплектация, СтруктураШапкиДокумента, Движения, Отказ);
			Иначе
				НомераГТДСервер.СформироватьДвиженияТоварыОрганизацийРасход(Неопределено, СтруктураШапкиДокумента, Движения, Отказ);
			КонецЕсли; 	          			
			ТаблицаНомераГТД = ПодготовитьТаблицуПоНомерамГТД();		
			НомераГТДСервер.СформироватьДвиженияТоварыОрганизацийПриход(ТаблицаНомераГТД,СтруктураШапкиДокумента, Движения, Отказ);		
		КонецЕсли;
	
		Если Не Отказ Тогда			
			ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ЭтотОбъект, СтруктураШапкиДокумента, Истина);
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры	// ОбработкаПроведения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Разукомплектация Тогда
			
		ТаблицаТовары = Новый ТаблицаЗначений;
		ТаблицаТовары.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ТаблицаТовары.Колонки.Добавить("Количество",   Новый ОписаниеТипов("Число"));
		ТаблицаТовары.Колонки.Добавить("НомерСтроки",  Новый ОписаниеТипов("Число"));
		ТаблицаТовары.Колонки.Добавить("Коэффициент",  Новый ОписаниеТипов("Число"));
		ТаблицаТовары.Колонки.Добавить("КлючСвязи",    Новый ОписаниеТипов("Число"));
		
		НоваяСтрока 			= ТаблицаТовары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭтотОбъект);
		НоваяСтрока.КлючСвязи   = 1;
		НоваяСтрока.НомерСтроки = 1;
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("Организация", Организация);
		СтруктураДанных.Вставить("СтруктурноеПодразделение", СтруктурноеПодразделение);
		СтруктураДанных.Вставить("Ссылка", Ссылка);
		СтруктураДанных.Вставить("Дата", Дата);
		СтруктураДанных.Вставить("Товары", ТаблицаТовары);		
		СтруктураДанных.Вставить("НомераГТД", НомераГТД);		
		
		НомераГТДСервер.ЗаполнитьТаблицуНомераГТД(СтруктураДанных);
			
		Иначе   		
			НомераГТДСервер.ЗаполнитьТаблицуНомераГТД(ЭтотОбъект,"Комплектующие"); 		
		КонецЕсли;

	// Посчитать суммы документа    	 
	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью()

//Процедура- обработчик события "ПриКопировании" Формы
Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЗначениеЗаполнено(ОбъектКопирования.НомераГТД) Тогда
		НомераГТД.Очистить();
	КонецЕсли;  	

КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	// Обработка для работы в версии 8.2
	Если ТипЗнч(Основание) <> Тип("Структура")
		И Основание <> НЕОПРЕДЕЛЕНО Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			
			// Заполнение шапки
			Комментарий    = Основание.Комментарий;
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Предопределенная процедура обработки удаления проведения документа
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();