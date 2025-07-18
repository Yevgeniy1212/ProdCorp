﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Пояснение = Параметры.Пояснение;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабМакет = Обработки.ПереносФайловВТома.ПолучитьМакет("МакетОтчета");
	
	ОбластьЗаголовок = ТабМакет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.Описание = "Файлы с ошибками:";
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ОбластьСтрока = ТабМакет.ПолучитьОбласть("Строка");
	
	Для Каждого Выборка Из Параметры.МассивФайловСОшибками Цикл
		ОбластьСтрока.Параметры.Название = Выборка.ИмяФайла;
		ОбластьСтрока.Параметры.Версия = Выборка.Версия;
		ОбластьСтрока.Параметры.Ошибка = Выборка.Ошибка;
		ТабДок.Вывести(ОбластьСтрока);
	КонецЦикла;     
	
	Отчет.Вывести(ТабДок);
	
КонецПроцедуры
