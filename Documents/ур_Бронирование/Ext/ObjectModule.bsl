﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мВалютаРегламентированногоУчета Экспорт;

#Если Клиент Тогда
	
// Функция формирует табличный документ унифицированной формы З-8
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Табличный документ по форме З-8.
//
Функция ПечатьБронирование()

		Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекДокумент", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Номер,
	|	Дата КАК ДатаДокумента,
	|	Организация,
	|	ВидОперации
	|ИЗ
	|	Документ.ур_Бронирование КАК ур_Бронирование
	|ГДЕ
	|	Ссылка = &ТекДокумент";
	
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	БронированиеЗерна.НомерСтроки,
	|	БронированиеЗерна.Номенклатура КАК Номенклатура,
	|	БронированиеЗерна.ЗерноваяРасписка.КодМСХ КАК КодМСХ,
	|	БронированиеЗерна.ЗерноваяРасписка.СерияНомерМСХ КАК СерияИНомерМСХ,
	|	БронированиеЗерна.ЗерноваяРасписка.ДатаВыдачи КАК ДатаВыдачи,
	|	БронированиеЗерна.СчетУчетаБУ.Наименование КАК ВидРесурса,
	|	БронированиеЗерна.Количество,
	|	БронированиеЗерна.ТипОперации,
	|	БронированиеЗерна.Получатель,
	|	БронированиеЗерна.Склад КАК Элеватор
	|ИЗ
	|	Документ.ур_Бронирование.Товары КАК БронированиеЗерна
	|ГДЕ
	|	БронированиеЗерна.Ссылка = &ТекДокумент
	|";

	ЗапросТовары = Запрос.Выполнить().Выгрузить();
	
	
	Макет = ПолучитьМакет("Макет");

	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета
	ТабДокумент.ПолеСверху         = 0;
	ТабДокумент.ПолеСлева          = 10;
	ТабДокумент.ПолеСнизу          = 0;
	ТабДокумент.ПолеСправа         = 0;
    ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Бронирование";

	
	// Выводим шапку накладной

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект, "Бронирование", глСписокПрефиксовУзлов);
	ТабДокумент.Вывести(ОбластьМакета);

 	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
  	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");

	Для каждого ВыборкаСтрокТовары из ЗапросТовары Цикл 
		ОбластьСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
		ЗерноваяРасписка = Строка(ВыборкаСтрокТовары.КодМСХ)+" "
						+ Строка(ВыборкаСтрокТовары.СерияИНомерМСХ)+" от "
		                + Строка(формат(ВыборкаСтрокТовары.ДатаВыдачи, "ДФ = dd.MM.yyyy"));
		ОбластьСтрока.Параметры.ЗерноваяРасписка = ЗерноваяРасписка;				
		ОбластьСтрока.Параметры.Номенклатура = ВыборкаСтрокТовары.номенклатура.наименованиеполное;
		ТабДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	// Вывести Итого
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	
	ОбластьИтого.Параметры.Количество = ЗапросТовары.Итог("Количество");
	ТабДокумент.Вывести(ОбластьИтого);
	
	Возврат ТабДокумент;

КонецФункции // ПечатьБронирование()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

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

	// Получить экземпляр документа на печать
	Если ИмяМакета = "Бронирование" Тогда
		ТабДокумент = ПечатьБронирование();
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));
                                                                                                                                                    
КонецПроцедуры // Печать

#КонецЕсли

Процедура ЗаполнитьТабличнуюЧасть(ДокОснование)
	ТекДокумент = ДокОснование.ПолучитьОбъект();
	Товары.Загрузить(ТекДокумент.Товары.Выгрузить());
Конецпроцедуры


// Возвращает доступные варианты печати документа.
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Бронирование","Бронирование");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

 // Процедура выполняет заполнение документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	Попытка
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
	Исключение
	КонецПопытки;
		
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ур_Бронирование") Тогда

		ЗаполнитьТабличнуюЧасть(Основание);
		
	КонецЕсли;
КонецПроцедуры

 ////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

//Проверить заполненость обязательных реквизитов зерновой расписки
Процедура ПроверитьЗаполнениеЗерновыхРасписок(ТаблицаПоЗерновымРаспискам, Отказ, Заголовок)
	СтрокаНачалаСообщенияОбОшибке = "";
	Для каждого СтрокаЗР ИЗ ТаблицаПоЗерновымРаспискам Цикл
		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаЗР.НомерСтроки) +
		""" Зерновая расписка """;
		
		если Не ЗначениеЗаполнено(СтрокаЗР.ВидРесурса) Тогда
			
			СтрокаСообщения = "Не заполнено значение реквизита вид ресурса !";
			ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ, Заголовок);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаЗР.ГодУрожая) Тогда
			
			СтрокаСообщения = "Не заполнено значение реквизита Год урожая !";
			ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ, Заголовок);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаЗР.Культура) Тогда
			
			СтрокаСообщения = "Не заполнено значение реквизита Вид культуры !";
			ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ, Заголовок);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаЗР.Класс) Тогда
			
			СтрокаСообщения = "Не заполнено значение реквизита класс культуры !";
			ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ, Заголовок);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеСтроки(ЭтотОбъект,СтруктураШапкиДокумента,Отказ,Заголовок)
	СтрокаНачалаСообщенияОбОшибке = "";
	
	Для каждого СтрокаЗР ИЗ Товары Цикл
		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаЗР.НомерСтроки) +
		""" Зерновая расписка """;
			Если УправлениеРесурсами.КонтрольОстатковБронированияНаЗерновыхРасписках(ЭтотОбъект,СтруктураШапкиДокумента,СтрокаЗР,Отказ) Тогда
				СтрокаСообщения = "Нет достаточного объема !";
				ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ, Заголовок);
			КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация");
	
	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура выполняет движения по регистрам
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента,
						ТаблицаПоЗерновымРаспискам, Отказ, Заголовок)
						
	Если ВидОперации = перечисления.ур_ВидыОперацийБронирования.Разбронировать Тогда
														
		// Выполнить движения по регистру накопления "Зерно на складах"
		
		НаборДвижений = Движения.ур_ЗабронированноеЗерно;
														
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		// Заполним таблицу движений.
		ТаблицаПоЗерновымРаспискамПолученным = ТаблицаПоЗерновымРаспискам.Скопировать();
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоЗерновымРаспискамПолученным, ТаблицаДвижений);
		
		// Недостающие поля.
		ТаблицаДвижений.ЗаполнитьЗначения(Организация, "Организация");
		
		НаборДвижений.мПериод            = Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		
		Если Не Отказ Тогда
			Движения.ур_ЗабронированноеЗерно.ВыполнитьРасход();
		КонецЕсли;
	ИначеЕсли ВидОперации = перечисления.ур_ВидыОперацийБронирования.Заложить Тогда	
														
		// Выполнить движения по регистру накопления "Зерно на складах"
		
		НаборДвижений = Движения.ур_ЗабронированноеЗерно;
														
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		// Заполним таблицу движений.
		ТаблицаПоЗерновымРаспискамПолученным = ТаблицаПоЗерновымРаспискам.Скопировать();
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоЗерновымРаспискамПолученным, ТаблицаДвижений);
		
		// Недостающие поля.
		ТаблицаДвижений.ЗаполнитьЗначения(Организация, "Организация");
		
		НаборДвижений.мПериод            = Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		
		Если Не Отказ Тогда
			Движения.ур_ЗабронированноеЗерно.ВыполнитьПриход();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрамРегл()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)
    // Обработка для работы в версии 8.2
	Если ТипЗнч(Основание) <> Тип("Структура")
		И Основание <> НЕОПРЕДЕЛЕНО Тогда
	
		ЗаполнитьПоДокументуОснования(Основание);
    КонецЕсли;
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = "Проведение документа """ + СокрЛП(Ссылка) + """: ";
	
	
	// Проверка ручной корректировки
	Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
		Возврат
	КонецЕсли;
	
	
	СтруктураШапкиДокумента   = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

 	ТаблицаПоЗерновымРаспискам    = УправлениеРесурсами.ПодготовитьТаблицуЗерновыхРасписокПриБронировании(ЭтотОбъект);
	ПроверитьЗаполнениеЗерновыхРасписок(ТаблицаПоЗерновымРаспискам, Отказ, Заголовок);
	
	Если ВидОперации = Перечисления.ур_ВидыОперацийБронирования.Разбронировать Тогда
		ПроверитьЗаполнениеСтроки(ЭтотОбъект,СтруктураШапкиДокумента,Отказ, Заголовок);
	КонецЕсли;
	
	// Движения по документу
	Если Не Отказ Тогда

		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
							ТаблицаПоЗерновымРаспискам, Отказ, Заголовок);
							
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Предопределенная процедура обработки удаления проведения документа
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мВалютаРегламентированногоУчета   = Константы.ВалютаРегламентированногоУчета.Получить();
