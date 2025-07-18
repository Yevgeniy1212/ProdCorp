﻿
&НаКлиенте
Процедура ПоискПоНаименованиюПриИзменении(Элемент)
	НастроитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНаименованиюОчистка(Элемент, СтандартнаяОбработка)
	НастроитьОтбор();
КонецПроцедуры

&НаСервере
Процедура НастроитьОтбор()
	Список.Отбор.Элементы.Очистить();
	Если ПоискПоНаименованию<>"" Тогда
		НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Наименование");
		НовыйОтбор.ПравоеЗначение = ПоискПоНаименованию;
		НовыйОтбор.Использование = Истина;
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ИсключитьПостоянноКонтролируемые") И Параметры.ИсключитьПостоянноКонтролируемые=Истина Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	НастройкиРегулярногоКонтроля.ФинансовыйПоказатель
			|ИЗ
			|	РегистрСведений.фин_НастройкиРегулярногоКонтроляПоказателей.СрезПоследних(&Дата, ИспользованиеКонтролируемыхЗначений = &ИспользованиеКонтролируемыхЗначений) КАК НастройкиРегулярногоКонтроля
			|ГДЕ
			|	НастройкиРегулярногоКонтроля.ПрименятьКонтроль";

		Запрос.УстановитьПараметр("Дата", Параметры.Дата);
		Запрос.УстановитьПараметр("ИспользованиеКонтролируемыхЗначений", Параметры.ИспользованиеКонтролируемыхЗначений);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();
	    СписокЗапрета = Новый СписокЗначений;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокЗапрета.Добавить(ВыборкаДетальныеЗаписи.ФинансовыйПоказатель);
		КонецЦикла;
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		ЭлементОтбора.ПравоеЗначение = СписокЗапрета;
		ЭлементОтбора.Использование = Истина;
	КонецЕсли;
КонецПроцедуры
