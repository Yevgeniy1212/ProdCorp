﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЪЕКТА

Процедура ПередЗаписьюДополнительно(Объект) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМ СПИСКОВ
	
Процедура ПередОткрытиемФормыСпискаДополнительно(Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ ВИДА РАСЧЕТА

Процедура УстановитьЭлементыУправленияСвойствамиПоказателей(Форма) Экспорт
	
	РаботаСДиалогами.УстановитьОтборыИСверткуПоказателей(Форма.ЭлементыФормы, Форма.Показатели, Форма.ПроизвольнаяФормулаРасчета);
	
КонецПроцедуры

Процедура ПередОткрытиемФормыВидаРасчетаДополнительно(Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

#КонецЕсли

