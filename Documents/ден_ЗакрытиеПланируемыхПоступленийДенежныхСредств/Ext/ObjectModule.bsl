﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	фин_ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, , , , , ДанныеЗаполнения);
	
	УстановитьВремя(РежимАвтоВремя.ТекущееИлиПоследним);
	
	Если Не ЗначениеЗаполнено(Состояние) Тогда
		Состояние = Перечисления.СостоянияОбъектов.Подготовлен;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	фин_ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ден_ЗакрытиеПланируемыхПоступленийДенежныхСредств.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаПланируемыеПоступленияОстатки, Движения, Отказ, "ПланируемыеПоступленияДС",,, "ден_ПланируемыеПоступленияДенежныхСредств",, ВидДвиженияНакопления.Расход);
	фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаРазмещениеЗаявокНаРасходованиеСредств, Движения, Отказ, "ПланируемыеПоступленияДС",,, "ден_РазмещениеЗаявокНаРасходованиеСредств",, ВидДвиженияНакопления.Расход);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли