﻿Перем мВалютаРегламентированногоУчета Экспорт;

Функция ПодготовитьТаблицуПоступления(ЭтотОбъект)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТекДокумент",ЭтотОбъект.Ссылка);
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	ДС.СтатьяДС КАК СтатьяДДС,
	|	ДС.Проект КАК Проект,
	|	ДС.ПриходВалютнаяСумма КАК ВалютнаяСумма,
	|	ДС.ПриходСумма КАК Сумма
	|ИЗ
	|	Документ.дс_ДвиженияДС.ДвиженияДС КАК ДС
	|Где
	|	ДС.ССылка = &ТекДокумент
	|	И ДС.ВидДвиженияДС = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийДенежныхСредств.Поступление)
	|";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ПодготовитьТаблицуВыбытия(ЭтотОбъект)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТекДокумент",ЭтотОбъект.Ссылка);
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	ДС.СтатьяДС КАК СтатьяДДС,
	|	ДС.Проект КАК Проект,
	|	ДС.РасходВалютнаяСумма КАК ВалютнаяСумма,
	|	ДС.расходСумма КАК Сумма
	|ИЗ
	|	Документ.дс_ДвиженияДС.ДвиженияДС КАК ДС
	|Где
	|	ДС.ССылка = &ТекДокумент
	|	И ДС.ВидДвиженияДС = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийДенежныхСредств.Выбытие)
	|";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

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
	СтруктураОбязательныхПолей = Новый Структура("Организация, СчетОрганизации");
	
	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура выполняет движения по регистрам
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента,
						ТаблицаПоступленияПоПроектам,ТаблицаВыбытияПоПроектам, Отказ, Заголовок)
						
	Если ТаблицаПоступленияПоПроектам.Количество()>0 Тогда
		НаборДвижений = Движения.дс_ДвиженияДенежныхСредств;
														
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		// Заполним таблицу движений.
		ТаблицаПоЗерновымРаспискамПолученным = ТаблицаПоступленияПоПроектам.Скопировать();
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоступленияПоПроектам, ТаблицаДвижений);
		
		// Недостающие поля.
		ТаблицаДвижений.ЗаполнитьЗначения(Организация, "Организация");
		ТаблицаДвижений.ЗаполнитьЗначения(СчетОрганизации, "БанковскийСчет");
		ТаблицаДвижений.ЗаполнитьЗначения(ВалютаДокумента, "Валюта");
		
		НаборДвижений.мПериод            = Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		
		
		Если Не Отказ Тогда
			Движения.дс_ДвиженияДенежныхСредств.ВыполнитьПриход();
		КонецЕсли;
	КонецЕсли;
	
 	Если ТаблицаВыбытияПоПроектам.Количество()>0 Тогда
		НаборДвижений = Движения.дс_ДвиженияДенежныхСредств;
														
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		// Заполним таблицу движений.
		ТаблицаПоЗерновымРаспискамПолученным = ТаблицаВыбытияПоПроектам.Скопировать();
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаВыбытияПоПроектам, ТаблицаДвижений);
		
		// Недостающие поля.
		ТаблицаДвижений.ЗаполнитьЗначения(Организация, "Организация");
		ТаблицаДвижений.ЗаполнитьЗначения(СчетОрганизации, "БанковскийСчет");
		ТаблицаДвижений.ЗаполнитьЗначения(ВалютаДокумента, "Валюта");
		
		НаборДвижений.мПериод            = Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		
		
		Если Не Отказ Тогда
			Движения.дс_ДвиженияДенежныхСредств.ВыполнитьРасход();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрамРегл()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
 
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

 	ТаблицаПоступленияПоПроектам    = ПодготовитьТаблицуПоступления(ЭтотОбъект);
  	ТаблицаВыбытияПоПроектам    = ПодготовитьТаблицуВыбытия(ЭтотОбъект);

	// Движения по документу
	Если Не Отказ Тогда

		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
							ТаблицаПоступленияПоПроектам,ТаблицаВыбытияПоПроектам, Отказ, Заголовок);
							
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Предопределенная процедура обработки удаления проведения документа
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
КонецПроцедуры

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
