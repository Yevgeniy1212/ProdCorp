﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ТипСписка") Тогда
		Список.ТипЗначения = Параметры.ТипСписка;
		Для Каждого ЗначениеСписка Из Параметры.СписокЗначений Цикл
			Список.Добавить(ЗначениеСписка.Значение);
		КонецЦикла;
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(Список);
КонецПроцедуры
