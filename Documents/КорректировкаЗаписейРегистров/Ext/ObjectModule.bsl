﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
//

Перем мСтараяПометкаУдаления;

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

	//так как нет печатных форм у документа, по умолчанию
	//ТабДокумент = Неопределено
	ТабДокумент = Неопределено;
	
	Если ТабДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;  

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать()

#КонецЕсли

// Возвращает доступные варианты печати документа.
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура устанавливает/снимает признак активности движений документа.
//
Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл   
		Движение.Прочитать();
		Для Каждого Строка Из Движение Цикл
			Строка.Активность = ФлагАктивности;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // УстановитьАктивностьДвижений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПриКопировании" документа.
//                                                             
Процедура ПриКопировании(ОбъектКопирования)
	
	Если ТипЗнч(ОбъектКопирования) <> Тип("ДокументОбъект.КорректировкаЗаписейРегистров") Тогда
		Возврат;
	КонецЕсли; 
	
	Для каждого Набор Из ОбъектКопирования.Движения Цикл
		
		Набор.Прочитать();
		Если Набор.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НаборТекущегоОбъекта = Движения[Набор.Метаданные().Имя];
		ЭтоРегистрНакопления = Метаданные.РегистрыНакопления.Найти(Набор.Метаданные().Имя) <> Неопределено;
		
		Для каждого ЗаписьНабора Из Набор Цикл
		
			НоваяЗапись = НаборТекущегоОбъекта.Добавить();
			НоваяЗапись.Активность  = ЗаписьНабора.Активность;
			Если ЭтоРегистрНакопления Тогда
				Если НаборТекущегоОбъекта.Метаданные().ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
					НоваяЗапись.ВидДвижения = ЗаписьНабора.ВидДвижения;
				КонецЕсли;
			КонецЕсли;
			НоваяЗапись.Период      = ТекущаяДата();
			
			Для каждого Измерение Из Набор.Метаданные().Измерения Цикл
				НоваяЗапись[Измерение.Имя] = ЗаписьНабора[Измерение.Имя];
			КонецЦикла; 
			Для каждого Ресурс Из Набор.Метаданные().Ресурсы Цикл
				НоваяЗапись[Ресурс.Имя] = ЗаписьНабора[Ресурс.Имя];
			КонецЦикла; 
			Для каждого Реквизит Из Набор.Метаданные().Реквизиты Цикл
				НоваяЗапись[Реквизит.Имя] = ЗаписьНабора[Реквизит.Имя];
			КонецЦикла; 
		
		КонецЦикла; 
		
	КонецЦикла; 
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ПередЗаписью" документа
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	// прочитаем флаг пометки удаления, сохранный в базе (до изменения)
	мСтараяПометкаУдаления = Ссылка.ПометкаУдаления;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ПриЗаписи" документа.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ПометкаУдаления <> мСтараяПометкаУдаления Тогда // поменялся признак пометки удаления у документа

		Если ПометкаУдаления Тогда
			
			// удалим движения документа из регистров
			ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
			
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ПриЗаписи()

мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();