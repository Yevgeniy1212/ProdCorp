﻿
// Процедура заполняет реквизиты адресации у задачи
//
Процедура ЗаписатьАдресациюЗадачиДополнительно(Задача, Подразделение) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

// Процедура добавляет задачи, специфические для конкретной конфигурации
//
Процедура ДобавитьЗадачи(
			ВидЗадачиПользователей,
			ТекущаяДата,
			АктуальныйПериодРегистрации,
			СписокГоловныхОрганизаций,
			СписокОрганизаций) Экспорт
			
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ДополнитьТекстОписанияЗадачи(ТекстСообщения, РеквизитыАдресации) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ДополнитьОтборНабораЗаписей(НаборЗаписей) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // ДополнитьОтборНабораЗаписей()

Процедура УстановитьОтборНабораЗаписей(НаборЗаписей, СтрокаТаблицы) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // УстановитьОтборНабораЗаписей()

Процедура ДополнитьСтруктуруПоиска(СтруктураПоиска, СтрокаТаблицы) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // ДополнитьСтруктуруПоиска()


#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура ФормаЗадачиПередОткрытиемДополнительно(Форма, ЗадачаОбъект, ДополнительныеДействия) Экспорт
	
	Форма.ЭлементыФормы.ОсновнаяПанель.ОтображениеЗакладок = ОтображениеЗакладок.НеИспользовать;
	
КонецПроцедуры // ФормаЗадачиПередОткрытиемДополнительно

Процедура ФормаЗадачиДополнительноВыбор(Форма, Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // ФормаЗадачиДополнительноВыбор

Процедура УстановитьОтборТаблицаНастройкиРолиИИсполнителиДополнительно(ЭлементыФормы) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // УстановитьОтборТаблицаНастройкиРолиИИсполнителиДополнительно()

#КонецЕсли