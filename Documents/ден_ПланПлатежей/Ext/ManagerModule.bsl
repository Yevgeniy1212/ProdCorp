﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Проведение

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр платежей
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РеестрПлатежей";
	КомандаПечати.Представление = НСтр("ru = 'Реестр платежей'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;//Проведение документа запрещено //НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.ЕстьДополнительноеПравоПользователя("ПечатьНепроведенныхДокументов");
	КомандаПечати.Порядок = 50;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеестрПлатежей") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РеестрПлатежей",
			НСтр("ru = 'Реестр платежей'"),
			ПечатьРеестрПлатежей(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.ден_ПланПлатежей.Печать");
	КонецЕсли;
		
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.

Функция ПечатьРеестрПлатежей(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет = Документы.ден_ПланПлатежей.ПолучитьМакет("Печать");
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "РеестрПлатежей";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ден_ПланПлатежей.Автор,
	|	ден_ПланПлатежей.Дата,
	|	ден_ПланПлатежей.Номер,
	|	ден_ПланПлатежей.Организация
	|ИЗ
	|	Документ.ден_ПланПлатежей КАК ден_ПланПлатежей
	|ГДЕ
	|	ден_ПланПлатежей.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок 	= Макет.ПолучитьОбласть("Заголовок");
	Шапка 				= Макет.ПолучитьОбласть("Шапка");
	ОбластьПлатежиШапка = Макет.ПолучитьОбласть("ПлатежиШапка");
	ОбластьПлатежи 		= Макет.ПолучитьОбласть("Платежи");
	Подвал 				= Макет.ПолучитьОбласть("Подвал");
 	ШапкаСчетКасса 		= Макет.ПолучитьОбласть("ШапкаСчетКасса");
	ПодвалСчет 			= Макет.ПолучитьОбласть("ПодвалСчет");

	ТабДокумент.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ОбластьЗаголовок.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(Шапка, Выборка.Уровень());

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Платежи.ЗРС КАК ЗРС,
			|	Платежи.ДатаПлатежа,
			|	Платежи.Сумма,
			|	Платежи.ЗРС.БанковскийСчетКасса КАК БанковскийСчетКасса
			|ИЗ
			|	Документ.ден_ПланПлатежей.Платежи КАК Платежи
			|ИТОГИ ПО
			|	БанковскийСчетКасса";

		Результат = Запрос.Выполнить();

		ВыборкаЗРС = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Пока ВыборкаЗРС.Следующий() Цикл
			// Вставить обработку выборки ВыборкаЗРС
			НачальныйОстаток = 0;
			
            ШапкаСчетКасса.Параметры.БанковскийСчетКасса  = ВыборкаЗРС.БанковскийСчетКасса;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ТиповойОстатки.СуммаОстатокДт КАК Остаток
				|ИЗ
				|	РегистрБухгалтерии.Типовой.Остатки(
				|			&Дата,
				|			Счет =&Счет,
				|			&Субконто,Организация = &Организация И 
				|			Субконто1 = &ОбъектУчета) КАК ТиповойОстатки";
            Субконто = Новый СписокЗначений;
			Субконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДенежныеСредства);
			Запрос.УстановитьПараметр("Счет", 			ПланыСчетов.Типовой.ДенежныеСредстваНаТекущихБанковскихСчетах);
			Запрос.УстановитьПараметр("Дата", 			НачалоДня(Выборка.Дата));
			Запрос.УстановитьПараметр("ОбъектУчета", 	ВыборкаЗРС.БанковскийСчетКасса);
			Запрос.УстановитьПараметр("Субконто", 		Субконто);
 			Запрос.УстановитьПараметр("Организация", 	Выборка.Организация);

			РезультатОст = Запрос.Выполнить();

			ВыборкаОст = РезультатОст.Выбрать();

			Пока ВыборкаОст.Следующий() Цикл
				НачальныйОстаток = ВыборкаОст.Остаток;
			КонецЦикла;

            ШапкаСчетКасса.Параметры.НачальныйОстаток  = НачальныйОстаток;
			ТабДокумент.Вывести(ШапкаСчетКасса);
			
			ВыборкаДетальныеЗаписи = ВыборкаЗРС.Выбрать();
 			ТабДокумент.Вывести(ОбластьПлатежиШапка);

			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ОбластьПлатежи.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
				ОбластьПлатежи.Параметры.Заполнить(ВыборкаДетальныеЗаписи.ЗРС);
				ТабДокумент.Вывести(ОбластьПлатежи, ВыборкаДетальныеЗаписи.Уровень());
				НачальныйОстаток = НачальныйОстаток - ВыборкаДетальныеЗаписи.Сумма;
			КонецЦикла;
            ПодвалСчет.Параметры.конечныйОстаток  = НачальныйОстаток;
			ТабДокумент.Вывести(ПодвалСчет);
		КонецЦикла;
		
		Подвал.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(Подвал);

		ВставлятьРазделительСтраниц = Истина;
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецЕсли