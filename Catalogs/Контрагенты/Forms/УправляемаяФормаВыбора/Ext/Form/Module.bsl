﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик события "Нажатие" элемента формы "ДействияФормы.Выбрать".
//
&НаКлиенте
Процедура ДействияФормыВыбрать(Кнопка)
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(ВладелецФормы) = Тип("ПолеВвода")
	  И ((ВладелецФормы.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Группы И НЕ Элементы.Список.ТекущиеДанные.ЭтоГруппа)
	  ИЛИ (ВладелецФормы.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы И Элементы.Список.ТекущиеДанные.ЭтоГруппа)) Тогда
		Возврат;
	КонецЕсли; 
	КонтрагентВыбора = Элементы.Список.ТекущиеДанные.Ссылка;
	ОповеститьОВыборе(КонтрагентВыбора);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПриАктивизацииСтроки" элемента формы "Список".
//
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Элементы.Дерево.ТекущийЭлемент = Элементы.Список.ТекущийРодитель;
КонецПроцедуры

 ////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик события нажатие по кнопке Отчет командной панели ДействияФормы.
//
&НаКлиенте
Процедура ДействияФормыОтчет(Кнопка)
	Если Элементы.Список.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
		Если Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
			Предупреждение("Нельзя формировать отчет по группе!");
			Возврат;
		Иначе
			ДействияФормыОтчетНаСервере()	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДействияФормыОтчетНаСервере()
	Отчет = Отчеты.ОтчетПоДаннымКонтрагента.Создать();
	Отчет.КонтрагентОтчета	= Элементы.Список.ТекущиеДанные.Ссылка;
	Отчет.ДатаОтчета 	= ТекущаяДата();
	ФормаОтчета 		= Отчет.ПолучитьФорму();
	Отчет.СформироватьОтчет(ФормаОтчета.Элементы.ПолеТабличногоДокумента);
	ФормаОтчета.Открыть();
КонецПроцедуры


//УНИВЕРСАЛЬНЫЙ ПОИСК ОБЪЕКТОВ
///////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытиеФормыПоиска"
		И Источник = ЭтаФорма Тогда
	КонецЕсли;  		
КонецПроцедуры
