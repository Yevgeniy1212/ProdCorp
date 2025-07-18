﻿
Процедура ПриКопировании(ОбъектКопирования)
	Если ЗначениеЗаполнено(ОбъектКопирования.Идентификатор) Тогда
		Идентификатор = Неопределено;
	КонецЕсли; 
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	НоменклатураГСВС.Ссылка
	                      |ИЗ
	                      |	Справочник.НоменклатураГСВС КАК НоменклатураГСВС
	                      |ГДЕ
	                      |	(НЕ &ЕстьИдентификатор ИЛИ НоменклатураГСВС.Идентификатор = &Идентификатор)
	                      |	И НоменклатураГСВС.КодГСВС = &КодГСВС
	                      |	И (&ЭтоНовый ИЛИ НоменклатураГСВС.Ссылка <> &Ссылка)");
Запрос.УстановитьПараметр("ЕстьИдентификатор",ЗначениеЗаполнено(Идентификатор));						  
Запрос.УстановитьПараметр("Идентификатор", Идентификатор);	
Запрос.УстановитьПараметр("КодГСВС", КодГСВС);
Запрос.УстановитьПараметр("Ссылка", Ссылка);
Запрос.УстановитьПараметр("ЭтоНовый", ЭтоНовый() );
Результат = Запрос.Выполнить();
Если Не Результат.Пустой() ТОгда
	ТекстСообщения = НСТР("ru = 'Нельзя записать элемент, поскольку в справочнике уже есть запись %Идентификатор% с таким кодом ГСВС: %КодГСВС%.'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Идентификатор%",?(ЗначениеЗаполнено(Идентификатор), "с таким идентификатором: "+ Строка(Идентификатор) + " или", ""));
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КодГСВС%",КодГСВС);
	ЭСФКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Отказ = Истина;
КонецЕсли;

КонецПроцедуры
