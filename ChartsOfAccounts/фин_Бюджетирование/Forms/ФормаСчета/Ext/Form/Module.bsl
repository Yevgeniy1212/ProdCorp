﻿
&НаКлиенте
Процедура ВидыСубконтоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Элементы.ВидыСубконто.ТекущиеДанные.Суммовой = Истина;
		Элементы.ВидыСубконто.ТекущиеДанные.Валютный = Объект.Валютный;
		Элементы.ВидыСубконто.ТекущиеДанные.Количественный = Объект.Количественный;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры


&НаКлиенте
Процедура УстановитьВидимость()
	Элементы.ВидыСубконтоВалютный.Видимость = Объект.Валютный;
	Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВалютныйПриИзменении(Элемент)
	Если Объект.Валютный=Ложь Тогда
		Для Каждого СтрокаСубконто Из Объект.ВидыСубконто Цикл
			СтрокаСубконто.Валютный = Ложь;
		КонецЦикла;
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура КоличественныйПриИзменении(Элемент)
	Если Объект.Количественный=Ложь Тогда
		Для Каждого СтрокаСубконто Из Объект.ВидыСубконто Цикл
			СтрокаСубконто.Количественный = Ложь;
		КонецЦикла;
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры


&НаКлиенте
Процедура ОтложенныйСборФакта(Команда)
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(,"Элемент еще не записан!");
		Возврат;	
	КонецЕсли;
	ОткрытьФорму("РегистрСведений.фин_ПравилаОтложенногоСбораФактическихДанных.ФормаСписка",Новый Структура("Отбор",Новый Структура("ФинансовыйПоказатель",Объект.Ссылка)),ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НадписьИспользуемыеСубконто = "Используемые субконто";
	НадписьУчетПоСчету = "Учет по счету";
КонецПроцедуры
