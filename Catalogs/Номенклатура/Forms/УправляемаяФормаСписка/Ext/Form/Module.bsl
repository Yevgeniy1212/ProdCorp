﻿&НаКлиенте
Перем тТипЦенДляПечати;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ КОМАНДНОЙ ПАНЕЛИ
&НаСервере
Процедура ДобавитьВТаблицу(ТабДанных, Товар, ТипЦен)
	
	Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновнаяОрганизация");

	ЦенаПечати = УправлениеЦенообразованием.ПолучитьЦенуНоменклатуры(Товар, ТипЦен, ОбщегоНазначения.ПолучитьРабочуюДату(),,,, Организация);
	Если ЦенаПечати = 0 Тогда
		Сообщить("Для товара " + Товар.НаименованиеПолное + " не установлена цена выбранного типа. Эта позиция не печается. ", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;

	СтрокаДанных = ТабДанных.Добавить();
	СтрокаДанных.Номенклатура             = Товар;
	СтрокаДанных.НоменклатураНаименование = Товар.НаименованиеПолное;
	СтрокаДанных.Единица                  = Товар.БазоваяЕдиницаИзмерения;
	СтрокаДанных.ЕдиницаНаименование      = Товар.БазоваяЕдиницаИзмерения.Наименование;
	СтрокаДанных.Цена                     = ЦенаПечати;

КонецПроцедуры // ДобавитьВТаблицу()

// Процедура - обработчик события "ПриАктивизацииСтроки" элемента формы Список.
//
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Элементы.Дерево.ТекущийЭлемент = Элементы.Список.ТекущийРодитель;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	ОбработкаВыбораНаСервере(ЗначениеВыбора,Источник);	
КонецПроцедуры // ОбработкаВыбора()

&НаСервере
Процедура ОбработкаВыбораНаСервере(ЗначениеВыбора,Источник)
	Если ТипЗнч(ЗначениеВыбора) = Тип("СправочникСсылка.ТипыЦенНоменклатуры") Тогда
		тТипЦенДляПечати = ЗначениеВыбора;
	КонецЕсли;
КонецПроцедуры

//УНИВЕРСАЛЬНЫЙ ПОИСК ОБЪЕКТОВ
///////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура вызывается принажатии кнопки в подменю "Советы" командной панели
// формы.
//
&НаКлиенте
Процедура ДействияФормыОткрытьСоветы(Команда)
	куфиб_РаботаСДиалогами.ОткрытьСоветы(Команда);
КонецПроцедуры //ДействияФормыОткрытьСоветы()

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
    ПараметрыФормы = Новый Структура;
    //ПараметрыФормы.Вставить("ГруппаНовогоПользователя", Элементы.ГруппыПользователей.ТекущаяСтрока);
    Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
        ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
    КонецЕсли;
    
    ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Элементы.Список);
КонецПроцедуры
