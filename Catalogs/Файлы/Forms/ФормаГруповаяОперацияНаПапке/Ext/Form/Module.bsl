﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Информация = Параметры.Информация;
	Заголовок = Параметры.Заголовок;
	СУчетомПодпапок = Параметры.СУчетомПодпапок;
КонецПроцедуры
