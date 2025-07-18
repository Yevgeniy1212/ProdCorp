﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяСтруктурнаяЕдиница = Запись.СтруктурнаяЕдиница;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповестим форму выбранной структурной единицы.
	Оповестить("Запись_ОтветственныеЛица", Новый Структура("ИмяЭлемента","ОтветственноеЛицо"), Запись.СтруктурнаяЕдиница);
	Если ТекущаяСтруктурнаяЕдиница <> Запись.СтруктурнаяЕдиница Тогда

		// Оповестим также форму той структурной единицы, данные которой начинали редактировать.
		Оповестить("Запись_ОтветственныеЛица", Новый Структура("ИмяЭлемента","ОтветственноеЛицо"), ТекущаяСтруктурнаяЕдиница);
		ТекущаяСтруктурнаяЕдиница = Запись.СтруктурнаяЕдиница;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИсторияИзменений(Команда)
	
	Отбор = Новый Структура("СтруктурнаяЕдиница", Запись.СтруктурнаяЕдиница);
	ОткрытьФорму(
		"РегистрСведений.фин_ОтветственныеЛица.ФормаСписка", 
		Новый Структура("Отбор", Отбор), 
		ЭтотОбъект, 
		УникальныйИдентификатор, 
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
