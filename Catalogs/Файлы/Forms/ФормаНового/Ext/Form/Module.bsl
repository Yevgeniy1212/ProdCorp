﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступнаКомандаСканировать") Тогда
		Если Параметры.ДоступнаКомандаСканировать Тогда
			Элементы.РежимСоздания.СписокВыбора.Добавить(3, "Со сканера");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьФайлВыполнить()
	Закрыть(РежимСоздания);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьПараметрыИспользования(РежимСозданияПараметр) Экспорт
	РежимСоздания = РежимСозданияПараметр;
КонецПроцедуры	

