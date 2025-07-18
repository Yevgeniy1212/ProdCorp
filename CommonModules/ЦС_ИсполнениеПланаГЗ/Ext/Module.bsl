﻿
Процедура ЦС_ПланыГЗИсполнениеОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка тогда 
		Возврат;
	КонецЕсли;
	
	Исполнение = Источник.Движения.ЦС_ИсполнениеПланаГЗ;
	Исполнение.Очистить();
	Исполнение.Записывать = Истина;
	
	Коэф=1;
	
	Если ТипЗнч(Источник) = тип("ДокументОбъект.ВозвратТоваровПоставщику") тогда
		Коэф=-1;
	КонецЕсли;
	
	Если Источник.Дата < Дата("20150101000000") тогда
		Возврат;
	КонецЕсли;
	
	
	Для Каждого строкаТЧ из Источник.Товары Цикл
		
		Если Строкатч.номенклатураГЗ.Пустая() тогда
			Сообщить("В строке № " + СтрокаТЧ.НомерСтроки +" табличной части товары не указана номенклатура ГЗ");
			продолжить;
		КонецЕсли;
		
		Движение 					= Исполнение.Добавить();
		Движение.Период 			= источник.дата;
		Движение.Организация 		= источник.организация;
		Движение.НоменклатураГЗ 	= строкатч.номенклатурагз;
		Движение.ПериодПланирования = НачалоГода(строкаТЧ.периодпланирования);
		Движение.Количество 		= Коэф * строкатч.количество;
		Движение.Сумма				= Коэф * СтрокаТЧ.Сумма;
		
		//Редактирование Soft Mix
		
		Движение.Контрагент 	= источник.Контрагент;
		Движение.Договор		= источник.ДоговорКонтрагента;
		Движение.КазахстанскоеСодержание = СтрокаТЧ.КазахстанскоеСодержание;
		
		//Конец редактирования Soft Mix
		
	КонецЦикла;
	
	Для Каждого строкаТЧ из Источник.Услуги Цикл
		
		Если Строкатч.номенклатураГЗ.Пустая() тогда
			Сообщить("В строке № " + СтрокаТЧ.НомерСтроки +" табличной части услуги не указана номенклатура ГЗ");
			продолжить;

		КонецЕсли;
		
		Движение 					= Исполнение.Добавить();
		Движение.Период 			= источник.дата;
		Движение.Организация 		= источник.организация;
		Движение.НоменклатураГЗ 	= строкатч.номенклатурагз;
		Движение.ПериодПланирования = НачалоГода(строкаТЧ.периодпланирования);
		
		Движение.Сумма				= Коэф * СтрокаТЧ.Сумма;
		
		//Редактирование Soft Mix
		
		Движение.Контрагент 	= источник.Контрагент;
		Движение.Договор		= источник.ДоговорКонтрагента;
		Движение.КазахстанскоеСодержание = СтрокаТЧ.КазахстанскоеСодержание;
		
		//Конец редактирования Soft Mix
		
	КонецЦикла;
	
	Попытка
		
		Для Каждого строкаТЧ из Источник.ОС Цикл
			
			Если Строкатч.номенклатураГЗ.Пустая() тогда
				Сообщить("В строке № " + СтрокаТЧ.НомерСтроки +" табличной части ОС не указана номенклатура ГЗ");
				продолжить;

			КонецЕсли;
			
			Движение 					= Исполнение.Добавить();
			Движение.Период 			= источник.дата;
			Движение.Организация 		= источник.организация;
			Движение.НоменклатураГЗ 	= строкатч.номенклатурагз;
			Движение.ПериодПланирования = НачалоГода(строкаТЧ.периодпланирования);
			
			Движение.Количество 		= Коэф;
			Движение.Сумма				= Коэф * СтрокаТЧ.Сумма;
			
			//Редактирование Soft Mix
			
			Движение.Контрагент 	= источник.Контрагент;
			Движение.Договор		= источник.ДоговорКонтрагента;
			Движение.КазахстанскоеСодержание = СтрокаТЧ.КазахстанскоеСодержание;
			
			//Конец редактирования Soft Mix
			
		КонецЦикла;
	
	Исключение
		
	КонецПопытки;
	
КонецПроцедуры
