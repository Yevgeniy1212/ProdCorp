﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
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
		
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПроверитьПредыдущиеРасчеты(Объект) Экспорт 
	
	Если НЕ (ЗначениеЗаполнено(Объект.Контрагент) ИЛИ ЗначениеЗаполнено(Объект.ДоговорКонтрагента)) Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПроизведенныеРасчеты.Регистратор
			|ИЗ
			|	РегистрСведений.дог_ПроизведенныеРасчетыИсполненияГрафиковПоставки КАК ПроизведенныеРасчеты
			|ГДЕ
			|	ПроизведенныеРасчеты.Организация = &Организация
			|	И ПроизведенныеРасчеты.СтруктурноеПодразделение = &СтруктурноеПодразделение
			|	И ПроизведенныеРасчеты.Контрагент = &Контрагент
			|	И ПроизведенныеРасчеты.Договор = &Договор
			|	И ПроизведенныеРасчеты.ПериодРасчета = &ПериодРасчета
			|	И ПроизведенныеРасчеты.Регистратор <> &Регистратор";

		Запрос.УстановитьПараметр("Договор", Объект.ДоговорКонтрагента);
		Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("ПериодРасчета", НачалоМесяца(Объект.Дата));
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
		Запрос.УстановитьПараметр("Регистратор", Объект.Ссылка);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Возврат ВыборкаДетальныеЗаписи;
	ИначеЕсли ЗначениеЗаполнено(Объект.Контрагент) И НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПроизведенныеРасчеты.Регистратор
			|ИЗ
			|	РегистрСведений.дог_ПроизведенныеРасчетыИсполненияГрафиковПоставки КАК ПроизведенныеРасчеты
			|ГДЕ
			|	ПроизведенныеРасчеты.Организация = &Организация
			|	И ПроизведенныеРасчеты.СтруктурноеПодразделение = &СтруктурноеПодразделение
			|	И ПроизведенныеРасчеты.Контрагент = &Контрагент
			|	И ПроизведенныеРасчеты.Договор = &Договор
			|	И ПроизведенныеРасчеты.ПериодРасчета = &ПериодРасчета
			|	И ПроизведенныеРасчеты.Регистратор <> &Регистратор
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПроизведенныеРасчеты.Регистратор
			|ИЗ
			|	РегистрСведений.дог_ПроизведенныеРасчетыИсполненияГрафиковПоставки КАК ПроизведенныеРасчеты
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.дог_ГрафикиПоставокПоДоговорам КАК дог_ГрафикиПоставокПоДоговорам
			|		ПО ПроизведенныеРасчеты.Регистратор = дог_ГрафикиПоставокПоДоговорам.Регистратор
			|			И (дог_ГрафикиПоставокПоДоговорам.Контрагент = &Контрагент)
			|ГДЕ
			|	ПроизведенныеРасчеты.Организация = &Организация
			|	И ПроизведенныеРасчеты.СтруктурноеПодразделение = &СтруктурноеПодразделение
			|	И ПроизведенныеРасчеты.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
			|	И ПроизведенныеРасчеты.Договор = &Договор
			|	И ПроизведенныеРасчеты.ПериодРасчета = &ПериодРасчета
			|	И ПроизведенныеРасчеты.Регистратор = &Регистратор";

		Запрос.УстановитьПараметр("Договор", Объект.ДоговорКонтрагента);
		Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("ПериодРасчета", НачалоМесяца(Объект.Дата));
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
		Запрос.УстановитьПараметр("Регистратор", Объект.Ссылка);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Возврат ВыборкаДетальныеЗаписи;		
	Иначе

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПроизведенныеРасчеты.Регистратор
			|ИЗ
			|	РегистрСведений.дог_ПроизведенныеРасчетыИсполненияГрафиковПоставки КАК ПроизведенныеРасчеты
			|ГДЕ
			|	ПроизведенныеРасчеты.Организация = &Организация
			|	И ПроизведенныеРасчеты.СтруктурноеПодразделение = &СтруктурноеПодразделение
			|	И ПроизведенныеРасчеты.Контрагент = &Контрагент
			|	И ПроизведенныеРасчеты.Договор = &Договор
			|	И ПроизведенныеРасчеты.ПериодРасчета = &ПериодРасчета
			|	И ПроизведенныеРасчеты.Регистратор <> &Регистратор
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПроизведенныеРасчеты.Регистратор
			|ИЗ
			|	РегистрСведений.дог_ПроизведенныеРасчетыИсполненияГрафиковПоставки КАК ПроизведенныеРасчеты
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.дог_ГрафикиПоставокПоДоговорам КАК дог_ГрафикиПоставокПоДоговорам
			|		ПО ПроизведенныеРасчеты.Регистратор = дог_ГрафикиПоставокПоДоговорам.Регистратор
			|			И (дог_ГрафикиПоставокПоДоговорам.ДоговорКонтрагента = &Договор)
			|ГДЕ
			|	ПроизведенныеРасчеты.Организация = &Организация
			|	И ПроизведенныеРасчеты.СтруктурноеПодразделение = &СтруктурноеПодразделение
			|	И (ПроизведенныеРасчеты.Контрагент = &Контрагент
			|			ИЛИ ПроизведенныеРасчеты.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))
			|	И ПроизведенныеРасчеты.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
			|	И ПроизведенныеРасчеты.ПериодРасчета = &ПериодРасчета
			|	И ПроизведенныеРасчеты.Регистратор <> &Регистратор";

		Запрос.УстановитьПараметр("Договор", Объект.ДоговорКонтрагента);
		Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("ПериодРасчета", НачалоМесяца(Объект.Дата));
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
		Запрос.УстановитьПараметр("Регистратор", Объект.Ссылка);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Возврат ВыборкаДетальныеЗаписи;		
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
		
	ПараметрыПроведения = фин_УправлениеПроведениемДокументовСервер.ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ);
	
	ПараметрыПроведения.Реквизиты.Колонки.Добавить("ЕстьРасчетИсполнения", Новый ОписаниеТипов("Булево"));
	ПараметрыПроведения.Реквизиты[0].ЕстьРасчетИсполнения = Истина;
	
	ТаблицаРасчетИсполнения = Новый ТаблицаЗначений;
	ТаблицаРасчетИсполнения.Колонки.Добавить("ПустойРеквизит", Новый ОписаниеТипов("Булево"));
	ТаблицаРасчетИсполнения.Добавить();	
	
	ПараметрыПроведения.Вставить("ТаблицаРасчетИсполнения", ТаблицаРасчетИсполнения);
	
	Возврат ПараметрыПроведения;

КонецФункции
	
#КонецЕсли	