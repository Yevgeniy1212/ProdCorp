﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	фин_БюджетированиеОбщегоНазначения.НастроитьОформлениеТабличногоПоля(Элементы.Список);
	Если Параметры.Свойство("Вид",Вид) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.КомпоновщикНастроек.Настройки.Отбор, "Вид", Вид, , , ЗначениеЗаполнено(Вид));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидФормулыПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, "Вид", Вид, , , ЗначениеЗаполнено(Вид));
КонецПроцедуры
