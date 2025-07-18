﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("дог_РежимКонтроляСроковПоставокПоДоговорам")<>Перечисления.дог_РежимУчетаИсполненияСроковПоставкиПоДоговорам.Регламентно Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Настройки учетной политики по договорным отношениям не предполагают использование данного вида документа!'"), , , , Отказ);
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) И НЕ ЗначениеЗаполнено(Контрагент) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе должен быть указан контрагент!'"), ЭтотОбъект, "Контрагент", "Объект", Отказ);
		
	КонецЕсли;

	ВыборкаДетальныеЗаписи = Документы.дог_РегламентныйРасчетИсполненияГрафиковПоставки.ПроверитьПредыдущиеРасчеты(ЭтотОбъект);
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Расчет за указанный период и с указанными параметрами уже произведен документом: '") + Строка(ВыборкаДетальныеЗаписи.Регистратор), , , , Отказ);
	КонецЕсли;	
	
КонецПроцедуры

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	фин_ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.дог_РегламентныйРасчетИсполненияГрафиковПоставки.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаРасчетИсполнения, Движения, Отказ, "РасчетИсполнения", "дог_УправлениеДоговорами", "СформироватьДвиженияРегламентныйРасчетИсполненияГрафиковПоставки"); 	
	          
КонецПроцедуры // ОбработкаПроведения()

#КонецЕсли