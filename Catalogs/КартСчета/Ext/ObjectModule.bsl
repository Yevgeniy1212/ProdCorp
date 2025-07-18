﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью элемента справочника.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(Владелец) Тогда
		Сообщить("Счет №" + СокрЛП(Наименование) + ": не указан работник - владелец карт-счета", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;	
	
	Если НЕ ЭтоГруппа И СтрДлина(НомерСчета) < 20 Тогда
		Сообщить("Счет №" + СокрЛП(НомерСчета) + ": длина номера счета менее 20 знаков. Рекомендуется проверить правильность введенного номера", СтатусСообщения.Информация);
	КонецЕсли;	
	
	// ISO 20022
	Если НЕ Отказ И НеЯвляетсяВладельцемСчета И НЕ ЗначениеЗаполнено(ФизЛицоВладелецСчета) Тогда
		Сообщить("Поле ""Перечисление третьему лицу"" не заполнено", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если Не НеЯвляетсяВладельцемСчета Тогда
		ФизЛицоВладелецСчета = Неопределено;
		УдалитьФамилия       = "";
		УдалитьИмя           = "";
		УдалитьОтчество      = "";
		УдалитьРНН           = "";
		УдалитьИдентификационныйКодЛичности = "";
	КонецЕсли;
	// ISO 20022
	
КонецПроцедуры

