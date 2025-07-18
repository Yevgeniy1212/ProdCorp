﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Заполнение


////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ДополнительныеЗапросы = Новый Массив;
	ДополнительныеЗапросы.Добавить("ТаблицаРегламентныеРасчетыПоМоделям");
	
	ДополнительныеПараметрыЗапросов = Новый Структура;
	ДополнительныеПараметрыЗапросов.Вставить("БюджетированиеПоОрганизациям",фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("БюджетированиеПоОрганизациям"));
	
	ПараметрыПроведения = фин_УправлениеПроведениемДокументовСервер.ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ,,,,,,,ДополнительныеПараметрыЗапросов,ДополнительныеЗапросы);
	
	Возврат ПараметрыПроведения;

КонецФункции 

Функция ТекстЗапросаТаблицаРегламентныеРасчетыПоМоделям(НомераТаблиц,ПараметрыПроведения, Реквизиты)  Экспорт

	ТекстЗапроса="ВЫБРАТЬ
	             |	ВЫБОР
	             |		КОГДА РегламентнаяМодельБюджетирования.ГрупповаяНастройка = ЛОЖЬ
	             |			ТОГДА РегламентнаяМодельБюджетирования.ФинансовыйПоказатель
	             |		ИНАЧЕ фин_АгрегатыФинансовыхПоказателейСостав.ФинансовыйПоказатель
	             |	КОНЕЦ КАК ФинансовыйПоказатель,
	             |	ВЫБОР
	             |		КОГДА &БюджетированиеПоОрганизациям
	             |			ТОГДА РегламентнаяМодельБюджетирования.Ссылка.Организация
	             |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	             |	КОНЕЦ КАК Организация,
	             |	РегламентнаяМодельБюджетирования.Ссылка.Сценарий,
	             |	РегламентнаяМодельБюджетирования.Ссылка.НачалоИспользования,
	             |	РегламентнаяМодельБюджетирования.Ссылка.КонецИспользования,
	             |	РегламентнаяМодельБюджетирования.НомерСтроки КАК НомерСтрокиДокумента,
	             |	РегламентнаяМодельБюджетирования.Ссылка КАК Расчет,
	             |	РегламентнаяМодельБюджетирования.Ссылка.Дата КАК Период,
	             |	РегламентнаяМодельБюджетирования.Ссылка.ПриоритетРасчетаМодели,
	             |	РегламентнаяМодельБюджетирования.Ссылка.ЦиклическийРасчет,
	             |	РегламентнаяМодельБюджетирования.Ссылка.ВложенностьЦикла,
	             |	РегламентнаяМодельБюджетирования.Ссылка.РекурсивнаяМодель
	             |ИЗ
	             |	Документ.фин_РасчетнаяМодельБюджетирования.ОборотыПоСтатьямБюджетов КАК РегламентнаяМодельБюджетирования
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.фин_АгрегатыФинансовыхПоказателей.Состав КАК фин_АгрегатыФинансовыхПоказателейСостав
	             |		ПО РегламентнаяМодельБюджетирования.АгрегатПоказателей = фин_АгрегатыФинансовыхПоказателейСостав.Ссылка
	             |			И (РегламентнаяМодельБюджетирования.ГрупповаяНастройка = ИСТИНА)
	             |ГДЕ
	             |	РегламентнаяМодельБюджетирования.Ссылка = &Ссылка
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	ВЫБОР
	             |		КОГДА РегламентнаяМодельБюджетирования.ГрупповаяНастройка = ЛОЖЬ
	             |			ТОГДА РегламентнаяМодельБюджетирования.ФинансовыйПоказатель
	             |		ИНАЧЕ фин_АгрегатыФинансовыхПоказателейСостав.ФинансовыйПоказатель
	             |	КОНЕЦ КАК ФинансовыйПоказатель,
	             |	ВЫБОР
	             |		КОГДА &БюджетированиеПоОрганизациям
	             |			ТОГДА РегламентнаяМодельБюджетирования.Ссылка.Организация
	             |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	             |	КОНЕЦ,
	             |	ДополнительныеСценарии.Сценарий,
	             |	РегламентнаяМодельБюджетирования.Ссылка.НачалоИспользования,
	             |	РегламентнаяМодельБюджетирования.Ссылка.КонецИспользования,
	             |	РегламентнаяМодельБюджетирования.НомерСтроки,
	             |	РегламентнаяМодельБюджетирования.Ссылка,
	             |	РегламентнаяМодельБюджетирования.Ссылка.Дата,
	             |	РегламентнаяМодельБюджетирования.Ссылка.ПриоритетРасчетаМодели,
	             |	РегламентнаяМодельБюджетирования.Ссылка.ЦиклическийРасчет,
	             |	РегламентнаяМодельБюджетирования.Ссылка.ВложенностьЦикла,
	             |	РегламентнаяМодельБюджетирования.Ссылка.РекурсивнаяМодель
	             |ИЗ
	             |	Документ.фин_РасчетнаяМодельБюджетирования.ОборотыПоСтатьямБюджетов КАК РегламентнаяМодельБюджетирования
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.фин_АгрегатыФинансовыхПоказателей.Состав КАК фин_АгрегатыФинансовыхПоказателейСостав
	             |		ПО РегламентнаяМодельБюджетирования.АгрегатПоказателей = фин_АгрегатыФинансовыхПоказателейСостав.Ссылка
	             |			И (РегламентнаяМодельБюджетирования.ГрупповаяНастройка = ИСТИНА)
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.фин_РасчетнаяМодельБюджетирования.ДополнительныеСценарии КАК ДополнительныеСценарии
	             |		ПО РегламентнаяМодельБюджетирования.Ссылка = ДополнительныеСценарии.Ссылка
	             |			И РегламентнаяМодельБюджетирования.Ссылка.Сценарий <> ДополнительныеСценарии.Сценарий
	             |			И (ДополнительныеСценарии.Сценарий <> ЗНАЧЕНИЕ(Справочник."+фин_ОбщегоНазначенияВызовСервераПовтИсп.ПрефиксОбщихОбъектов()+"СценарииПланирования.ПустаяСсылка))
	             |ГДЕ
	             |	РегламентнаяМодельБюджетирования.Ссылка = &Ссылка";

		ТекстЗапроса = ТекстЗапроса + фин_УправлениеПроведениемДокументовСервер.ТекстРазделителяЗапросовПакета();
		НомераТаблиц.Вставить("ТаблицаРегламентныеРасчетыПоМоделям",  НомераТаблиц.Количество());
	
	Возврат ТекстЗапроса;	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
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
// Прочие служебные процедуры и функции


#КонецЕсли