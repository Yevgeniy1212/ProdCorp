﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = Параметры.Организация;
	Элементы.Организация.ТолькоПросмотр = Параметры.ОргИзменять;
	
	ОбновитьОтбор(Организация);

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьОтбор(Организация);
КонецПроцедуры

Процедура ОбновитьОтбор(Организация)
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ПодразделенияОрганизаций.Ссылка КАК Ссылка,
	               |	ПодразделенияОрганизаций.Представление КАК Представление,
	               |	ПодразделенияОрганизаций.Код КАК Код,
	               |	ПодразделенияОрганизаций.Наименование КАК Наименование,
	               |	ПодразделенияОрганизаций.Родитель КАК Родитель
	               |ИЗ
	               |	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	               |ГДЕ
	               |	ПодразделенияОрганизаций.ЯвляетсяСтруктурнымПодразделением = ИСТИНА
	               |	И ПодразделенияОрганизаций.Владелец = &Организация";
				   
	СтруктурныеПодразделения.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
	СтруктурныеПодразделения.ТекстЗапроса = ТекстЗапроса;
	Элементы.СтруктурныеПодразделения.Обновить();
КонецПроцедуры


&НаКлиенте
Процедура СтруктурныеПодразделенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбраннаяСтрока = Элементы.СтруктурныеПодразделения.ТекущиеДанные;
	
	Если НЕ ВыбраннаяСтрока = Неопределено Тогда
		
			Закрыть(Новый Структура("Организация, СтруктурноеПодразделение",
				Организация, ВыбраннаяСтрока.Ссылка));
	КонецЕсли;
КонецПроцедуры

