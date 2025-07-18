﻿Функция ИзменятьПлановыйКурсПлатежа(Дата) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	фин_УчетнаяПолитикаПоБюджетированиюСрезПоследних.РазрешитьИзменятьПлановыйКурсПлатежаВРасчетныхДокументах
		|ИЗ
		|	РегистрСведений.фин_УчетнаяПолитикаПоБюджетированию.СрезПоследних(&Дата, ) КАК фин_УчетнаяПолитикаПоБюджетированиюСрезПоследних";

	Запрос.УстановитьПараметр("Дата", Дата);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.РазрешитьИзменятьПлановыйКурсПлатежаВРасчетныхДокументах;
	КонецЦикла;

	Возврат Истина;
КонецФункции