﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.Период < Дата('20200101')
			И Запись.Налогоплательщик <> Справочники.Организации.ПустаяСсылка() Тогда
			
			ОбщегоНазначения.СообщитьОбОшибке("Сведения о ставках ВОСМС/ОСМС в разрезе налогоплательщика указываются только с 01.01.2020 года.", Отказ);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
