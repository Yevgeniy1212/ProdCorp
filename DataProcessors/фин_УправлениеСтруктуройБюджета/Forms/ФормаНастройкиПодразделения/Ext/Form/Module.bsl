﻿
&НаКлиенте
Процедура ДляСпискаПодразделенийПриИзменении(Элемент)
	Если ДляСпискаПодразделений Тогда
		ВключаяПодчиненныеПодразделения=Ложь;
		ПодразделениеПоУмолчанию = фин_ОбщегоНазначенияКлиентПовтИсп.ПустоеЗначениеУправленческоеПодразделение();
	Иначе
		СписокПодразделений.Очистить();
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Элементы.ВключаяПодчиненныеПодразделения.Видимость = НЕ ДляСпискаПодразделений;
	Элементы.ПодразделениеПоУмолчанию.Видимость = Не ДляСпискаПодразделений;
	Элементы.СписокПодразделений.Видимость = ДляСпискаПодразделений;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Параметры.Свойство("ВключаяПодчиненныеПодразделения") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	ВключаяПодчиненныеПодразделения = Параметры.ВключаяПодчиненныеПодразделения;
	ДляСпискаПодразделений = Параметры.ДляСпискаПодразделений;
	ПодразделениеПоУмолчанию = Параметры.ПодразделениеПоУмолчанию;
	СписокПодразделений.ЗагрузитьЗначения(Параметры.СписокПодразделений.ВыгрузитьЗначения());
КонецПроцедуры


&НаКлиенте
Процедура ОК(Команда)
	Закрыть(Новый Структура("ВключаяПодчиненныеПодразделения,ДляСпискаПодразделений,ПодразделениеПоУмолчанию,СписокПодразделений",ВключаяПодчиненныеПодразделения,ДляСпискаПодразделений,ПодразделениеПоУмолчанию,СписокПодразделений));
КонецПроцедуры

