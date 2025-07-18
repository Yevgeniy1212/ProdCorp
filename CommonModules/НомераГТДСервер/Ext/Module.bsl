﻿
#Область ПрограммныйИнтерфейс

#Область ЗаполнениеПоОстаткамТабличнойЧастиНомераГТД

Функция ПустыеПараметрыДляЗаполненияНомеровГТДПоОстаткам() Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	
	ПараметрыЗаполнения.Вставить("Дата");
	ПараметрыЗаполнения.Вставить("Регистратор");
	ПараметрыЗаполнения.Вставить("Организация");
	ПараметрыЗаполнения.Вставить("АдресТовары");
	ПараметрыЗаполнения.Вставить("СтруктурноеПодразделение");
	ПараметрыЗаполнения.Вставить("СпособЗаполнения");
	
	Возврат ПараметрыЗаполнения;	
	
КонецФункции

Процедура ЗаполнитьПараметрыДляЗаполненияНомеровГТДПоОстаткам(ПараметрыЗаполнения, Объект, Товары) Экспорт
	
	Если ТипЗнч(Объект) = Тип("Структура")  Тогда
		Проведен = Объект.Ссылка.Проведен;
	Иначе
		Проведен = Объект.Проведен;
	КонецЕсли;
	
	ПараметрыЗаполнения.Дата = ?(Объект.Дата = НачалоДня(ТекущаяДата()) И НЕ Проведен, Неопределено, Объект.Дата);
	ПараметрыЗаполнения.Регистратор = Объект.Ссылка;
	ПараметрыЗаполнения.Организация = Объект.Организация;
	ПараметрыЗаполнения.АдресТовары = ПоместитьВоВременноеХранилище(Товары);	
			
	Если ТипЗнч(Объект) = Тип("Структура") Тогда
		ПараметрыЗаполнения.СтруктурноеПодразделение = Объект.СтруктурноеПодразделение; 		
	Иначе 		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("СтруктурноеПодразделениеОтправитель", Объект.Метаданные()) Тогда
			ПараметрыЗаполнения.СтруктурноеПодразделение = Объект.СтруктурноеПодразделениеОтправитель;	
		Иначе		
			ПараметрыЗаполнения.СтруктурноеПодразделение = Объект.СтруктурноеПодразделение;
		КонецЕсли;		
	КонецЕсли; 	

	
КонецПроцедуры

Процедура ЗаполнитьТаблицуНомераГТД(Объект, ИмяТаблицы = "Товары", СпособЗаполнения = Неопределено, ПоказыватьСообщения = Ложь) Экспорт
	
	Если СпособЗаполнения = Неопределено Тогда
		СпособЗаполнения = НомераГТДКлиентСервер.СпособЗаполнения_СначалаПустыми();
	КонецЕсли;
	
	Если НЕ НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Объект.Дата) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы ИЗ Объект[ИмяТаблицы] Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.КлючСвязи) Тогда
			СтрокаТаблицы.КлючСвязи = ОбщегоНазначенияКлиентСервер.НовыйКлючСвязиСтрокиТаблицы(Объект[ИмяТаблицы]);
		КонецЕсли;
	КонецЦикла;
	
	Если ТипЗнч(Объект[ИмяТаблицы]) = Тип("ТаблицаЗначений") Тогда
		Товары = Объект[ИмяТаблицы];
	Иначе
		Товары = Объект[ИмяТаблицы].Выгрузить();
	КонецЕсли;
	
	Если ТипЗнч(Объект.НомераГТД) = Тип("ТаблицаЗначений") Тогда
		НомераГТД = Объект.НомераГТД;
	Иначе
		НомераГТД = Объект.НомераГТД.Выгрузить();
		
	КонецЕсли;
		
	УдалитьНомераГТДСНесуществующимКлючомСвязи(Товары, НомераГТД);	
	ИзменитьКоэффициентыИКоличестваВТаблицеНомераГТДПоТаблицеТовары(Товары, НомераГТД);
	УменьшитьКоличествоВНомерахГТДДоКоличестваВТоварах(Товары, НомераГТД);
	УдалитьНомераГТДСНулевымКоличеством(Товары, НомераГТД);
	
	// Заполнить параметры для дозаполнения табличной части НомераГТД
	// по данным табличных частей активов (например табличной части Товары).
	ПараметрыЗаполнения = ПустыеПараметрыДляЗаполненияНомеровГТДПоОстаткам();
	ЗаполнитьПараметрыДляЗаполненияНомеровГТДПоОстаткам(ПараметрыЗаполнения, Объект, Товары);
	ПараметрыЗаполнения.СпособЗаполнения = СпособЗаполнения;
	
	ДобавитьНедостающееКоличествоНомеровГТДПоОстаткам(ПараметрыЗаполнения, Товары, НомераГТД, ПоказыватьСообщения);	
	
	СгруппироватьТаблицуНомеровГТД(НомераГТД);
	
	Если ТипЗнч(Объект.НомераГТД) <> Тип("ТаблицаЗначений") Тогда
		Объект.НомераГТД.Загрузить(НомераГТД);
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьНомераГТДСНесуществующимКлючомСвязи(Товары, НомераГТД) Экспорт
	
	// Создать массив ключей связи, которые указаны в таблице Товары.
	МассивКлючейСвязиТоваров = Новый Массив;
	Для Каждого СтрокаТовары Из Товары Цикл
		МассивКлючейСвязиТоваров.Добавить(СтрокаТовары.КлючСвязи);	
	КонецЦикла;
	
	// Удалить из таблицы НомераГТД строки, в которых указаны ключи связи, которых нет в таблице Товары.
	Пока Истина Цикл
		
		БылаУдаленаСтрока = Ложь;
		
		Для Каждого СтрокаНомерГТД Из НомераГТД Цикл
			Если МассивКлючейСвязиТоваров.Найти(СтрокаНомерГТД.КлючСвязи) = Неопределено Тогда
				БылаУдаленаСтрока = Истина;
				НомераГТД.Удалить(СтрокаНомерГТД);
			КонецЕсли;			
		КонецЦикла;
		
		Если НЕ БылаУдаленаСтрока Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Если пользователь изменит коэффициент в таблице Товары,
// то необходимо обновить коэффициент в таблице НомераГТД.
Процедура ИзменитьКоэффициентыИКоличестваВТаблицеНомераГТДПоТаблицеТовары(Товары, НомераГТД) Экспорт
	
	ЕстьКоэффициент = (Товары.Колонки.Найти("Коэффициент") <> Неопределено);
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		ПараметрыОтбора = Новый Структура();
		ПараметрыОтбора.Вставить("КлючСвязи", СтрокаТовары.КлючСвязи);
		МассивСтрокНомераГТД = НомераГТД.НайтиСтроки(ПараметрыОтбора);	
		Коэффициент = 1;
		Если ЕстьКоэффициент Тогда
			Коэффициент = СтрокаТовары.Коэффициент;
		КонецЕсли;
		
		Для Каждого СтрокаНомерГТД Из МассивСтрокНомераГТД Цикл			
			Если СтрокаНомерГТД.Коэффициент <> Коэффициент Тогда				
				СтрокаНомерГТД.Количество = (СтрокаНомерГТД.Коэффициент / Коэффициент) * СтрокаНомерГТД.Количество;
				СтрокаНомерГТД.Коэффициент = Коэффициент;
			КонецЕсли;			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УменьшитьКоличествоВНомерахГТДДоКоличестваВТоварах(Товары, НомераГТД) Экспорт
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		ТребуемоеКоличество = СтрокаТовары.Количество;
		НакопленноеКоличество = 0;
		
		ПараметрыОтбора = Новый Структура();
		ПараметрыОтбора.Вставить("КлючСвязи", СтрокаТовары.КлючСвязи);
		МассивСтрокНомеровГТД = НомераГТД.НайтиСтроки(ПараметрыОтбора);		
		
		Для Каждого СтрокаНомерГТД Из МассивСтрокНомеровГТД Цикл
			
			НакопленноеКоличество = НакопленноеКоличество + СтрокаНомерГТД.Количество;
			
			Если ТребуемоеКоличество < НакопленноеКоличество Тогда
				УменьшениеКоличестваНомераГТД = НакопленноеКоличество - ТребуемоеКоличество;
				Если УменьшениеКоличестваНомераГТД < СтрокаНомерГТД.Количество Тогда 
					СтрокаНомерГТД.Количество = СтрокаНомерГТД.Количество - УменьшениеКоличестваНомераГТД;
				Иначе
					СтрокаНомерГТД.Количество = 0;	
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьНомераГТДСНулевымКоличеством(Товары, НомераГТД) Экспорт
	
	Пока Истина Цикл
		
		УдаленНомерГТД = Ложь;
		
		Для Каждого СтрокаНомерГТД Из НомераГТД Цикл
			Если СтрокаНомерГТД.Количество = 0 Тогда
				НомераГТД.Удалить(СтрокаНомерГТД);
				УдаленНомерГТД = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ УдаленНомерГТД Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьНедостающееКоличествоНомеровГТДПоОстаткам(ПараметрыЗаполнения, Товары, НомераГТД, ПоказыватьСообщения) Экспорт
	     			
	ОстаткиПоНомерамГТД = ПолучитьОстаткиПоНомерамГТД(Товары, ПараметрыЗаполнения);
	
	УменьшитьВОстаткахКоличествоПоНомерамГТДКоторыеЕстьВДокументе(ОстаткиПоНомерамГТД, НомераГТД);
	
	УвеличитьКоличествоВНомерахГТДДоКоличестваВТоварах(Товары, НомераГТД, ОстаткиПоНомерамГТД, ПоказыватьСообщения);
	
КонецПроцедуры

Функция ПолучитьОстаткиПоНомерамГТД(Товары, Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварыОрганизацийОстатки.Товар КАК Номенклатура,
	|	ТоварыОрганизацийОстатки.НомерГТД КАК НомерГТД,
	|	ТоварыОрганизацийОстатки.КоличествоОстаток,
	|	ВЫБОР
	|		КОГДА ТоварыОрганизацийОстатки.НомерГТД = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|			ТОГДА 1
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ТоварыОрганизацийОстатки.НомерГТД.ПризнакПроисхождения = """"
	|					ТОГДА 2
	|				ИНАЧЕ 3
	|			КОНЕЦ
	|	КОНЕЦ КАК Приоритет
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизацийБУ.Остатки(
	|			&Период,
	|			Организация = &Организация
	|				И СтруктурноеПодразделение = &СтруктурноеПодразделение
	|				И Товар В (&Товары)) КАК ТоварыОрганизацийОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Остатки.Номенклатура,
	|	ВТ_Остатки.НомерГТД,
	|	ВТ_Остатки.КоличествоОстаток
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_Остатки.Приоритет УБЫВ,
	|	ВТ_Остатки.НомерГТД";
	
	Если Найти(Запрос.Текст, "ВТ_Остатки.Приоритет УБЫВ") = 0 Тогда
		ВызватьИсключение НСтр("ru = 'В тексте запроса отсутствует требуемая строка.'");
	КонецЕсли;
	
	Если Параметры.СпособЗаполнения = НомераГТДКлиентСервер.СпособЗаполнения_СначалаПустыми() Тогда		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТ_Остатки.Приоритет УБЫВ", "ВТ_Остатки.Приоритет ВОЗР");  	
	ИначеЕсли Параметры.СпособЗаполнения = НомераГТДКлиентСервер.СпособЗаполнения_СначалаЗаполненными() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВТ_Остатки.Приоритет УБЫВ", "ВТ_Остатки.Приоритет УБЫВ");  	
	Иначе		
		ВызватьИсключение НСтр("ru = 'Необрабатываемое значение параметра ""СпособЗаполнения"".'");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Товары", Товары.ВыгрузитьКолонку("Номенклатура")); 	
	Запрос.УстановитьПараметр("Организация", Параметры.Организация); 
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", Параметры.СтруктурноеПодразделение); 
	
	Если Параметры.Дата = Неопределено Тогда 		
		Запрос.УстановитьПараметр("Период", Неопределено);
	Иначе  		
		МоментВремени = Новый МоментВремени(Параметры.Дата, Параметры.Регистратор);	
		Если ЗначениеЗаполнено(Параметры.Регистратор) Тогда
			Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени, ВидГраницы.Исключая));
		Иначе  	
			Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени, ВидГраницы.Включая));
		КонецЕсли;
	КонецЕсли;
	
	ОстаткиПоНомерамГТД = Запрос.Выполнить().Выгрузить();
	
	Возврат ОстаткиПоНомерамГТД;
	
КонецФункции

Процедура УменьшитьВОстаткахКоличествоПоНомерамГТДКоторыеЕстьВДокументе(ОстаткиПоНомерамГТД, НомераГТД) Экспорт
	
	Для Каждого СтрокаНомераГТД Из НомераГТД Цикл
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Номенклатура", СтрокаНомераГТД.Номенклатура);
		ПараметрыОтбора.Вставить("НомерГТД", СтрокаНомераГТД.НомерГТД);
		
		МассивСтрокОстатковПоНомерамГТД = ОстаткиПоНомерамГТД.НайтиСтроки(ПараметрыОтбора);
		
		Если МассивСтрокОстатковПоНомерамГТД.Количество() > 0 Тогда
			
			СтрокаОстаткиПоНомерамГТД = МассивСтрокОстатковПоНомерамГТД[0];
			СтрокаОстаткиПоНомерамГТД.КоличествоОстаток = СтрокаОстаткиПоНомерамГТД.КоличествоОстаток - (СтрокаНомераГТД.Количество * СтрокаНомераГТД.Коэффициент);
			
			// Условие ниже никогда не должно выполняться.
			// Добавлено для повышения надежности системы.
			Если СтрокаОстаткиПоНомерамГТД.КоличествоОстаток < 0 Тогда
				СтрокаОстаткиПоНомерамГТД.КоличествоОстаток = 0;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УвеличитьКоличествоВНомерахГТДДоКоличестваВТоварах(Товары, НомераГТД, ОстаткиПоНомерамГТД, ПоказыватьСообщения) Экспорт
		
	ЕстьРеквизитНовыйНомерГТД = (НомераГТД.Колонки.Найти("НовыйНомерГТД") <> Неопределено);
	ЕстьКоэффициент 		  = (Товары.Колонки.Найти("Коэффициент") <> Неопределено);
	
	Для Каждого СтрокаТовары Из Товары Цикл		
		
		Коэффициент = 1;
		Если ЕстьКоэффициент Тогда
			Коэффициент = СтрокаТовары.Коэффициент;
		КонецЕсли;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("КлючСвязи", СтрокаТовары.КлючСвязи);
		МассивСтрокНомераГТД = НомераГТД.НайтиСтроки(ПараметрыОтбора);
		
		КоличествоВНомерахГТД = 0;
		Для Каждого СтрокаНомераГТД Из МассивСтрокНомераГТД Цикл
			КоличествоВНомерахГТД = КоличествоВНомерахГТД + (СтрокаНомераГТД.Количество * Коэффициент);	
		КонецЦикла;	 		
		
		КоличествоОсталосьПогасить = (СтрокаТовары.Количество * Коэффициент) - КоличествоВНомерахГТД;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Номенклатура", СтрокаТовары.Номенклатура);
		ОстаткиПоТовару = ОстаткиПоНомерамГТД.НайтиСтроки(ПараметрыОтбора);
		
		Для Каждого СтрокаОстаткиПоТовару Из ОстаткиПоТовару Цикл
			
			Если СтрокаОстаткиПоТовару.КоличествоОстаток > 0 Тогда
				
				Если КоличествоОсталосьПогасить > 0 Тогда
					
					КоличествоСписать = Мин(КоличествоОсталосьПогасить, СтрокаОстаткиПоТовару.КоличествоОстаток);				
					
					СтрокаНомераГТД = НомераГТД.Добавить();
					СтрокаНомераГТД.КлючСвязи = СтрокаТовары.КлючСвязи;
					СтрокаНомераГТД.Номенклатура = СтрокаТовары.Номенклатура;
					СтрокаНомераГТД.НомерГТД = СтрокаОстаткиПоТовару.НомерГТД;
					СтрокаНомераГТД.Коэффициент = Коэффициент;
					СтрокаНомераГТД.Количество = КоличествоСписать / Коэффициент;				
					
					Если ЕстьРеквизитНовыйНомерГТД Тогда
						СтрокаНомераГТД.НовыйНомерГТД = СтрокаНомераГТД.НомерГТД;
					КонецЕсли;
											
					КоличествоОсталосьПогасить = КоличествоОсталосьПогасить - КоличествоСписать;
					СтрокаОстаткиПоТовару.КоличествоОстаток = СтрокаОстаткиПоТовару.КоличествоОстаток - КоличествоСписать;

				Иначе
					
					Прервать;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		// Если на остатках больше ничего нет, то дополнить таблицу пустыми номерами ГТД.
		Если КоличествоОсталосьПогасить > 0 Тогда
			
			СтрокаНомераГТД = НомераГТД.Добавить();
			СтрокаНомераГТД.КлючСвязи = СтрокаТовары.КлючСвязи;
			СтрокаНомераГТД.Номенклатура = СтрокаТовары.Номенклатура;
			СтрокаНомераГТД.НомерГТД = Справочники.НомераГТД.ПустаяСсылка();
			СтрокаНомераГТД.Коэффициент = Коэффициент;
			СтрокаНомераГТД.Количество = КоличествоОсталосьПогасить / Коэффициент;
			
			Если ЕстьРеквизитНовыйНомерГТД Тогда
				СтрокаНомераГТД.НовыйНомерГТД = СтрокаНомераГТД.НомерГТД;
			КонецЕсли;
			
			Если ПоказыватьСообщения Тогда
				
				ТекстСообщения = НСтр("ru = 'Товар ""%1"". Недостаточно остатков по регистру ""Товары организаций (БУ)"" для заполнения всех номеров ГТД. Недостача: %2.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаНомераГТД.Номенклатура, СтрокаНомераГТД.Количество);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

Процедура СгруппироватьТаблицуНомеровГТД(НомераГТД) Экспорт
	
	//////////////////////////////////////////////////////////////////////////////
	// Установить номера строк, т.к. они нужны для сортировки.
	НомерСтроки = 1;
	
	ЕстьРеквизитНовыйНомерГТД = (НомераГТД.Колонки.Найти("НовыйНомерГТД") <> Неопределено);
	Для Каждого СтрокаНомераГТД Из НомераГТД Цикл
		СтрокаНомераГТД.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	//////////////////////////////////////////////////////////////////////////////
	// Сначала списываются товары, у которых в регистре ТоварыОрганизаций пустой номер ГТД.
	// Поэтому данные строки должны быть всегда для каждого ключа связи в таблице НомераГТД.
	// Если в регистре ТоварыОрганизаций не хватает остатков по товару, то таблица НомераГТД
	// добивается пустыми номерами ГТД, эти строки должны быть всегда внизу таблицы НомераГТД.
	
	НомераГТД.Колонки.Добавить("ПервыйПустойНомерГТД", Новый ОписаниеТипов("Булево"));
	
	КоллекцияКлючейСвязи = Новый Соответствие;
	Для Каждого СтрокаНомераГТД Из НомераГТД Цикл
		КоллекцияКлючейСвязи.Вставить(СтрокаНомераГТД.КлючСвязи);
	КонецЦикла;
	
	Для Каждого КлючСвязи Из КоллекцияКлючейСвязи Цикл
		ПараметрыОтборка = Новый Структура;
		ПараметрыОтборка.Вставить("КлючСвязи", КлючСвязи.Ключ);
		МассивНайденныхСтрок = НомераГТД.НайтиСтроки(ПараметрыОтборка);
		Если МассивНайденныхСтрок.Количество() > 0 Тогда
			Для Каждого СтрокаНоменГТД Из МассивНайденныхСтрок Цикл
				Если СтрокаНоменГТД.НомерГТД.Пустая() Тогда
					СтрокаНоменГТД.ПервыйПустойНомерГТД = Истина;
				Иначе
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	//////////////////////////////////////////////////////////////////////////////
	// Сгруппировать таблицу НомераГТД.
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НомераГТД.НомерСтроки,
	|	НомераГТД.КлючСвязи,
	|	НомераГТД.Номенклатура,
	|	НомераГТД.НомерГТД, " + ?(ЕстьРеквизитНовыйНомерГТД, "
	|	НомераГТД.НовыйНомерГТД, ", "") + "	
	|	НомераГТД.Коэффициент,
	|	НомераГТД.Количество,
	|	НомераГТД.ПервыйПустойНомерГТД
	|ПОМЕСТИТЬ ВТ_НомераГТД
	|ИЗ
	|	&НомераГТД КАК НомераГТД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ВТ_НомераГТД.НомерСтроки) КАК НомерСтроки,
	|	ВТ_НомераГТД.КлючСвязи КАК КлючСвязи,
	|	ВТ_НомераГТД.Номенклатура,
	|	ВТ_НомераГТД.НомерГТД, " + ?(ЕстьРеквизитНовыйНомерГТД,"
	|	ВТ_НомераГТД.НовыйНомерГТД, ", "") + "	
	|	ВТ_НомераГТД.Коэффициент,
	|	СУММА(ВТ_НомераГТД.Количество) КАК Количество,
	|	ВТ_НомераГТД.ПервыйПустойНомерГТД КАК ПервыйПустойНомерГТД
	|ИЗ
	|	ВТ_НомераГТД КАК ВТ_НомераГТД
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_НомераГТД.КлючСвязи,
	|	ВТ_НомераГТД.Номенклатура,
	|	ВТ_НомераГТД.НомерГТД, " + ?(ЕстьРеквизитНовыйНомерГТД,"
	|	ВТ_НомераГТД.НовыйНомерГТД, ", "") + "	
	|	ВТ_НомераГТД.НомерГТД,
	|	ВТ_НомераГТД.Коэффициент,
	|	ВТ_НомераГТД.ПервыйПустойНомерГТД
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючСвязи,
	|	ПервыйПустойНомерГТД УБЫВ,
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("НомераГТД", НомераГТД);	
	СгруппированныеНомераГТД = Запрос.Выполнить().Выгрузить();	
	
	НомераГТД.Колонки.Удалить("ПервыйПустойНомерГТД");
	
	НомераГТД.Очистить();
	Для Каждого СтрокаСгруппированныеНомераГТД Из СгруппированныеНомераГТД Цикл
		СтрокаНомераГТД = НомераГТД.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаНомераГТД, СтрокаСгруппированныеНомераГТД, , "НомерСтроки"); 
	КонецЦикла;
	
КонецПроцедуры

Функция ИзмениласьТЧТоварыОтносительноТЧНомеровГТД(Товары, НомераГТД) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
		                      |	ТаблицаТоваров.КлючСвязи КАК КлючСвязи,
		                      |	ТаблицаТоваров.Количество * ТаблицаТоваров.Коэффициент КАК Количество
		                      |ПОМЕСТИТЬ ВТ_Товары
		                      |ИЗ
		                      |	&Товары КАК ТаблицаТоваров
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	ТаблицаНомераГТД.КлючСвязи,
		                      |	ТаблицаНомераГТД.Количество * ТаблицаНомераГТД.Коэффициент КАК Количество
		                      |ПОМЕСТИТЬ ВТ_НомераГТД
		                      |ИЗ
		                      |	&НомераГТД КАК ТаблицаНомераГТД
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	ТаблицаТоваров.НомерСтроки,
		                      |	ТаблицаТоваров.КлючСвязи КАК КлючСвязи,
		                      |	ЕСТЬNULL(ТаблицаТоваров.Количество, 0) - ЕСТЬNULL(ТаблицаНомераГТД.Количество, 0) КАК Количество
		                      |ИЗ
		                      |	ВТ_Товары КАК ТаблицаТоваров
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		                      |			ТаблицаНомераГТД.КлючСвязи КАК КлючСвязи,
		                      |			СУММА(ТаблицаНомераГТД.Количество) КАК Количество
		                      |		ИЗ
		                      |			ВТ_НомераГТД КАК ТаблицаНомераГТД
		                      |		
		                      |		СГРУППИРОВАТЬ ПО
		                      |			ТаблицаНомераГТД.КлючСвязи) КАК ТаблицаНомераГТД
		                      |		ПО ТаблицаТоваров.КлючСвязи = ТаблицаНомераГТД.КлючСвязи
		                      |ГДЕ
		                      |	ЕСТЬNULL(ТаблицаТоваров.Количество, 0) - ЕСТЬNULL(ТаблицаНомераГТД.Количество, 0) <> 0")
							  ;

	Запрос.УстановитьПараметр("Товары", Товары); 
	Запрос.УстановитьПараметр("НомераГТД", НомераГТД); 

	ТаблицаПоРахождениямТоваровИНомеровГТД = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаПоРахождениямТоваровИНомеровГТД;
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеПоДокументамОснования

Функция ЗаполнитьТабличныеЧастиСУчетомНомеровГТД(СтруктураПоиска, СтрокаТоваров, ТабличнаяЧасть, ТабличнаяЧастьГТД, ЗаполнятьНомераГТД = Ложь) Экспорт
	
	СтрокиТовары = ТабличнаяЧасть.НайтиСтроки(СтруктураПоиска);
	
	Если СтрокиТовары.Количество() = 0 Тогда
		КлючСвязи = ОбщегоНазначенияКлиентСервер.НовыйКлючСвязиСтрокиТаблицы(ТабличнаяЧасть);
		СтрокаТабличнойЧасти = ТабличнаяЧасть.Добавить();			
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТоваров);
		СтрокаТабличнойЧасти.КлючСвязи = КлючСвязи;
	Иначе 
		СтрокаТабличнойЧасти = СтрокиТовары[0]; 
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТоваров.Количество;
	КонецЕсли;  
	
	Если ЗаполнятьНомераГТД Тогда		
		
		СтрокаТабличнойЧастиГТД = ТабличнаяЧастьГТД.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧастиГТД, СтрокаТоваров);
		СтрокаТабличнойЧастиГТД.КлючСвязи = СтрокаТабличнойЧасти.КлючСвязи;		
		
	КонецЕсли;
	
	Возврат СтрокаТабличнойЧасти; 
	
КонецФункции

Функция ПустыеПараметрыФормыРедактированияНомеровГТД() Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ДокументМодифицирован");
	
	ПараметрыФормы.Вставить("АдресТовары");
	ПараметрыФормы.Вставить("АдресНомераГТД");
	ПараметрыФормы.Вставить("ПоказыватьТолькоОстатки");
	
	ПараметрыФормы.Вставить("Ссылка");
	ПараметрыФормы.Вставить("Дата");
	ПараметрыФормы.Вставить("Организация");
	ПараметрыФормы.Вставить("СтруктурноеПодразделение");  	
	ПараметрыФормы.Вставить("ЗаполнятьОстатки", Истина);

	
	Возврат ПараметрыФормы;
	
КонецФункции

Функция ЗаполнитьПараметрыФормыРедактированияНомеровГТД(Объект, Форма, ИмяТаблицы = "Товары") Экспорт
	
	ПараметрыФормы = ПустыеПараметрыФормыРедактированияНомеровГТД();
	
	Для Каждого СтрокаТовары ИЗ Объект[ИмяТаблицы] Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТовары.КлючСвязи) Тогда
			СтрокаТовары.КлючСвязи = ОбщегоНазначенияКлиентСервер.НовыйКлючСвязиСтрокиТаблицы(Объект[ИмяТаблицы]);
		КонецЕсли;
	КонецЦикла;  	

	ЗаполнитьЗначенияСвойств(ПараметрыФормы, Объект);
	
	Если Объект.Метаданные().Реквизиты.Найти("СтруктурноеПодразделениеОтправитель") <> Неопределено Тогда
		ПараметрыФормы.СтруктурноеПодразделение = Объект.СтруктурноеПодразделениеОтправитель;	
	КонецЕсли;
	
	ПараметрыФормы.АдресТовары = АдресТаблицыЗначений(Форма, ИмяТаблицы);
	ПараметрыФормы.АдресНомераГТД = АдресТаблицыЗначений(Форма, "НомераГТД");
	ПараметрыФормы.ПоказыватьТолькоОстатки = Истина;
	ПараметрыФормы.ДокументМодифицирован = Форма.Модифицированность;
		
	Возврат ПараметрыФормы;
	
КонецФункции

#КонецОбласти

#Область ТоварыОрганизаций

Функция ВедетсяУчетПоТоварамОрганизаций(ДатаДокумента) Экспорт
	
	ДатаПереходаНаУчетПоТоварамОрганизацийВРазрезеНомеровГТДБУ = Константы.ДатаПереходаНаУчетПоТоварамОрганизацийВРазрезеНомеровГТДБУ.Получить();
	
	Возврат (ДатаПереходаНаУчетПоТоварамОрганизацийВРазрезеНомеровГТДБУ <> Дата(1,1,1) И ДатаДокумента >= ДатаПереходаНаУчетПоТоварамОрганизацийВРазрезеНомеровГТДБУ);
	
КонецФункции

Функция ПодготовитьТаблицуТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты, Отказ) Экспорт
	
	Параметры = Новый Структура;    
	
	СписокОбязательныхКолонок = ""
	+ "Ссылка,"                  	     // <ДокументСсылка.*> - документ-регистратор движений
	+ "Дата,"                       	 // <Дата> - период движений - дата документа
	+ "Организация,"                  	 // <СправочникСсылка.Организация> - организация, в которую приходуется товар
	+ "СтруктурноеПодразделение" ;
	
	Параметры.Вставить("Реквизиты", ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты, СписокОбязательныхКолонок));
	КолонкаДата = Параметры.Реквизиты.Колонки.Найти("Дата");
	Если КолонкаДата <> Неопределено Тогда
		КолонкаДата.Имя = "Период";
	КонецЕсли;
	
	КолонкаСсылка = Параметры.Реквизиты.Колонки.Найти("Ссылка");
	Если КолонкаСсылка <> Неопределено Тогда
		КолонкаСсылка.Имя = "Регистратор";
	КонецЕсли;
			
	СписокОбязательныхКолонок = ""
	+ "НомерСтроки,"       				// <Число> - номер строки в списке
	+ "Номенклатура,"      				// <СправочникСсылка.Номенклатура> 
	+ "НомерГТД,"        				// <СправочникСсылка.НомераГТД> 
	+ "Количество,"                     // <Число,15,3> - количество 
	+ "ВидДвижения";
	                     	
	Параметры.Вставить("ТаблицаТовары", ПолучитьТаблицуПараметровПроведения(ТаблицаТовары, СписокОбязательныхКолонок));
	
	КолонкаНоменклатура = Параметры.ТаблицаТовары.Колонки.Найти("Номенклатура");
	Если КолонкаНоменклатура <> Неопределено Тогда
		КолонкаНоменклатура.Имя = "Товар";
	КонецЕсли;                            
	
	//добавим колонку "ИмяСписка"
	Параметры.ТаблицаТовары.Колонки.Добавить("ИмяСписка", Новый ОписаниеТипов("Строка"));
	
	Возврат Параметры; 
		
КонецФункции

Процедура СформироватьДвиженияТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты, Движения, Отказ) Экспорт 
		
	Параметры = ПодготовитьТаблицуТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты,  Отказ);
		
	Если Параметры.ТаблицаТовары.Количество() = 0 ИЛИ  Параметры.Реквизиты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = Параметры.Реквизиты[0];
	
	Если НЕ ВедетсяУчетПоТоварамОрганизаций(Реквизиты.Период) Тогда
		Возврат;
	КонецЕсли;
		
	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаТовары Цикл
		Движение = Движения.ТоварыОрганизацийБУ.Добавить();
		Движение.Период           		  = Реквизиты.Период;
		Движение.Организация      		  = Реквизиты.Организация;
		Движение.СтруктурноеПодразделение = Реквизиты.СтруктурноеПодразделение;  
		ЗаполнитьЗначенияСвойств(Движение,СтрокаТаблицы);
	КонецЦикла;

	Движения.ТоварыОрганизацийБУ.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты, ВыводитьСообщения = Истина, Отказ) Экспорт
	
	Если ТаблицаТовары = Неопределено ИЛИ ТаблицаТовары.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Параметры =  ПодготовитьТаблицуТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты, Отказ);
		
	Реквизиты = Параметры.Реквизиты[0];

	Если НЕ ВедетсяУчетПоТоварамОрганизаций(Реквизиты.Период) Тогда
		Возврат;
	КонецЕсли;
		
	КонтролироватьОстаток = КонтролироватьОстатокТоваровПоНомерамГТД(Реквизиты); 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаТовары", Параметры.ТаблицаТовары);
		 	
	Запрос.УстановитьПараметр("ДатаОстатка", Новый Граница(Реквизиты.Период)); 	
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", Реквизиты.СтруктурноеПодразделение);
			
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	ТаблицаТовары.Товар КАК Товар,
	|	ТаблицаТовары.НомерГТД КАК НомерГТД
	|ПОМЕСТИТЬ Вт_Товары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Товар,
	|	НомерГТД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыОрганизацийОстатки.Товар,
	|	ТоварыОрганизацийОстатки.НомерГТД,
	|	ТоварыОрганизацийОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизацийБУ.Остатки(
	|			&ДатаОстатка,
	|			Организация = &Организация
	|				И СтруктурноеПодразделение = &СтруктурноеПодразделение
	|				И (Товар, НомерГТД) В
	|					(ВЫБРАТЬ
	|						Вт_Товары.Товар,
	|						Вт_Товары.НомерГТД
	|					ИЗ
	|						Вт_Товары)) КАК ТоварыОрганизацийОстатки";
	
	ТаблицаОстатков = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаДокумента Из Параметры.ТаблицаТовары Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Товар", СтрокаДокумента.Товар);
		СтруктураПоиска.Вставить("НомерГТД", СтрокаДокумента.НомерГТД);
		
		СтрокиОстатка = ТаблицаОстатков.НайтиСтроки(СтруктураПоиска);
		КоличествоОсталосьПогасить = СтрокаДокумента.Количество;	
		
		Для Каждого СтрокаОстатка Из СтрокиОстатка Цикл
			
			Если КоличествоОсталосьПогасить <= 0 Тогда
				Прервать;
			КонецЕсли;
			
			Если СтрокаОстатка.КоличествоОстаток <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаОстатка = СтрокиОстатка[0];
			КоличествоДок = МИН(КоличествоОсталосьПогасить,СтрокаОстатка.КоличествоОстаток);			
			
			Если СтрокаОстатка.КоличествоОстаток <= КоличествоДок Тогда
				СтрокаОстатка.КоличествоОстаток = 0;
			Иначе
				СтрокаОстатка.КоличествоОстаток = СтрокаОстатка.КоличествоОстаток - КоличествоДок;
			КонецЕсли;
			
			КоличествоОсталосьПогасить = КоличествоОсталосьПогасить - КоличествоДок;
				
		КонецЦикла;
		
		Если КоличествоОсталосьПогасить > 0 И ВыводитьСообщения И КонтролироватьОстаток Тогда
			
			Если СтрокаДокумента.НомерГТД.Пустая() Тогда
				ПредставлениеНомераГТД = НСтр("ru = 'Пустой источник происхождения'");
			Иначе
				ПредставлениеНомераГТД = СтрокаДокумента.НомерГТД;
			КонецЕсли;
		
			ТекстОшибки = НСтр("ru='Товары организаций (БУ). По организации %1 не списано %2 %3 товара <%4>, источник происхождения: <%5>"
			+ ?(ЗначениеЗаполнено(Реквизиты.СтруктурноеПодразделение), ", структурное подразделение: %6.", ".")+"' ");
						
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстОшибки,
				Реквизиты.Организация,
				КоличествоОсталосьПогасить,
				СтрокаДокумента.Товар.БазоваяЕдиницаИзмерения,
				СтрокаДокумента.Товар,
				ПредставлениеНомераГТД,
				Реквизиты.СтруктурноеПодразделение);
							
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Реквизиты.Регистратор, , , Отказ);	
					
		КонецЕсли;
		
	КонецЦикла; 	
	
КонецПроцедуры

Функция ПолучитьТаблицуПараметровПроведения(ИсходнаяТаблица, СписокКолонок) Экспорт

	Если ИсходнаяТаблица = Неопределено Тогда
		
		ТаблицаРезультат = Новый ТаблицаЗначений;
		Колонки = Новый Структура(СписокКолонок);
		Для каждого Колонка Из Колонки Цикл
			ТаблицаРезультат.Колонки.Добавить(Колонка.Ключ);
		КонецЦикла;
		Возврат ТаблицаРезультат;
		
	ИначеЕсли ТипЗнч(ИсходнаяТаблица) = Тип("Структура") Тогда
		
		ТаблицаРезультат = Новый ТаблицаЗначений;
		Колонки = Новый Структура(СписокКолонок);
		Для каждого Колонка Из Колонки Цикл
			ТаблицаРезультат.Колонки.Добавить(Колонка.Ключ);
		КонецЦикла;
		НоваяСтрока = ТаблицаРезультат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ИсходнаяТаблица, СписокКолонок);
		Возврат ТаблицаРезультат;

	Иначе

		Возврат ИсходнаяТаблица.Скопировать(, СписокКолонок);

	КонецЕсли;

КонецФункции

Функция ПодготовитьТаблицуПоНомерамГТД(ДокументСсылка, ИмяСписка = "Товары")   Экспорт
	
	Запрос = Новый Запрос;
	ИмяДокумента = ДокументСсылка.Метаданные().Имя;
	
	Запрос = Новый Запрос;	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаНомераГТД.НомерСтроки КАК НомерСтроки,
	|	ТаблицаНомераГТД.КлючСвязи,
	|	ТаблицаНомераГТД.НомерГТД КАК НомерГТД,
	|	ТаблицаНомераГТД.Количество КАК Количество
	|ПОМЕСТИТЬ НомераГТД
	|ИЗ
	|	&ТаблицаНомераГТД КАК ТаблицаНомераГТД
	|ГДЕ
	|	ТаблицаНомераГТД.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.КлючСвязи,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Коэффициент КАК Коэффициент,
	|	ТаблицаТовары.Количество КАК Количество,
	|	&ИмяСписка КАК ИмяСписка
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(НомераГТД.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаТовары.ИмяСписка КАК ИмяСписка,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	НомераГТД.НомерГТД КАК НомерГТД,
	|	СУММА(НомераГТД.Количество * ТаблицаТовары.Коэффициент) КАК Количество,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НомераГТД КАК НомераГТД
	|		ПО ТаблицаТовары.КлючСвязи = НомераГТД.КлючСвязи
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.ИмяСписка,
	|	ТаблицаТовары.Номенклатура,
	|	НомераГТД.НомерГТД
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	ТаблицаНомераГТД = "Документ." + ИмяДокумента + ".НомераГТД";
	ТаблицаТовары = "Документ." + ИмяДокумента + "." + ИмяСписка;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаТовары", ТаблицаТовары);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаНомераГТД", ТаблицаНомераГТД);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ИмяСписка", ИмяСписка);
		
	Возврат Запрос.Выполнить().Выгрузить();	 
	
КонецФункции

Процедура СформироватьДвиженияТоварыОрганизацийПриход(ТаблицаТовары, ТаблицаРеквизиты, Движения, Отказ) Экспорт 
	
	Если ТаблицаТовары.Колонки.Найти("ВидДвижения") = Неопределено Тогда
		ТаблицаТовары.Колонки.Добавить("ВидДвижения");		
	КонецЕсли;
	
	ТаблицаТовары.ЗаполнитьЗначения(ВидДвиженияНакопления.Приход , "ВидДвижения");
	
	СформироватьДвиженияТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты, Движения, Отказ);
	
КонецПроцедуры

Процедура СформироватьДвиженияТоварыОрганизацийРасход(ТаблицаТовары, ТаблицаРеквизиты, Движения, Отказ) Экспорт 
	
	Если Тип(ТаблицаРеквизиты) = Тип("Структура") Тогда
		Период = ТаблицаРеквизиты.Дата;
	Иначе
		Период = ТаблицаРеквизиты[0].Дата;
	КонецЕсли;

	Если НЕ ВедетсяУчетПоТоварамОрганизаций(Период) Тогда
		Возврат;
	КонецЕсли;

	Если ТаблицаТовары = Неопределено Тогда
		//Подготовим таблицу Номера ГТД	
		Если Тип(ТаблицаРеквизиты) = Тип("Структура") Тогда
			ДокументСсылка = ТаблицаРеквизиты.Ссылка;
		Иначе
			ДокументСсылка = ТаблицаРеквизиты[0].Ссылка;
		КонецЕсли;
		
		ИмяСписка = "Товары";
		Если ТипЗнч(ТаблицаРеквизиты) =  Тип("Структура") И ТаблицаРеквизиты.Свойство("ИмяСписка") Тогда
			ИмяСписка = ТаблицаРеквизиты.ИмяСписка;
		КонецЕсли;
				
		ТаблицаТовары = ПодготовитьТаблицуПоНомерамГТД(ДокументСсылка,ИмяСписка);	
		
	КонецЕсли;

	Если ТаблицаТовары.Колонки.Найти("ВидДвижения") = Неопределено Тогда
		ТаблицаТовары.Колонки.Добавить("ВидДвижения");
		ТаблицаТовары.ЗаполнитьЗначения(ВидДвиженияНакопления.Расход , "ВидДвижения");
	КонецЕсли;
	
	//контроль остатков по ТоварамОрганизации
	ВыполнитьКонтрольТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты, Истина, Отказ);
	
	Если Не Отказ Тогда
		СформироватьДвиженияТоварыОрганизаций(ТаблицаТовары, ТаблицаРеквизиты, Движения, Отказ);
	КонецЕсли;      	
	
КонецПроцедуры

Функция КонтролироватьОстатокТоваровПоНомерамГТД(Объект) Экспорт
	
	КонтролироватьОстаток = ПроцедурыБухгалтерскогоУчета.ПроводитьДокументПоРазделуУчета(Объект.Организация, Перечисления.РазделыУчета.ОценкаТМЗ, Объект.Период);
	
	Возврат  КонтролироватьОстаток;
	
КонецФункции

Функция ПодготовитьТаблицуНомеровГТД(Товары, НомераГТД) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", Товары);  	
	Запрос.УстановитьПараметр("НомераГТД", НомераГТД);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Товары.Номенклатура,
	               |	Товары.КлючСвязи,
	               |	Товары.Склад,
	               |	Товары.Коэффициент,
	               |	Товары.НомерСтроки КАК НомерСтроки
	               |ПОМЕСТИТЬ Товары
	               |ИЗ
	               |	&Товары КАК Товары
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	НомераГТД.КлючСвязи,
	               |	НомераГТД.НомерГТД,
	               |	НомераГТД.НовыйНомерГТД,
	               |	НомераГТД.Количество
	               |ПОМЕСТИТЬ НомераГТД
	               |ИЗ
	               |	&НомераГТД КАК НомераГТД
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	НомераГТД.НомерГТД,
	               |	НомераГТД.Количество,
	               |	НомераГТД.КлючСвязи,
	               |	НомераГТД.НовыйНомерГТД,
	               |	Товары.Номенклатура,
	               |	Товары.Склад,
	               |	Товары.Коэффициент,
	               |	Товары.НомерСтроки КАК НомерСтроки
	               |ИЗ
	               |	НомераГТД КАК НомераГТД
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Товары КАК Товары
	               |		ПО НомераГТД.КлючСвязи = Товары.КлючСвязи
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки,
	               |	Товары.КлючСвязи";
			   
		
	Если НомераГТД.Колонки.Найти("НовыйНомерГТД") = Неопределено  Тогда			
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "НомераГТД.НовыйНомерГТД,", "");		
	КонецЕсли;      	
	
	ТаблицаНомераГТД = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаНомераГТД;			   
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция АдресТаблицыЗначений(Форма, ИмяТаблицы) Экспорт
		
	ТабЗнач = Форма[ИмяТаблицы].Выгрузить();	
	АдресТабЗнач = ПоместитьВоВременноеХранилище(ТабЗнач);
	Возврат АдресТабЗнач;
	
КонецФункции

Функция ЕстьКолонка(ТабличнаяЧасть, ИмяКолонки) Экспорт
	
	ЕстьКолонка = Истина;
	
	Попытка	
		Значение = ТабличнаяЧасть.Найти("", ИмяКолонки);	
	Исключение		
		ЕстьКолонка = Ложь;	
	КонецПопытки;
	
	Возврат ЕстьКолонка;
	
КонецФункции

#КонецОбласти
