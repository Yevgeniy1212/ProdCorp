﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НадписьОграниченияОбластиДействияПоАналитике = "Ограничение области действия по аналитике";
	НадписьФормируемыеДанные = "Формируемые данные";
	НадписьБазаРаспределения = "База распределения";
	фин_РаботаСДополнительнымиРазрезамиБюджетирования.НастроитьПредставлениеРазрезов(ЭтотОбъект,,"ОбластьДействияЗависимости");
	фин_РаботаСДополнительнымиРазрезамиБюджетирования.НастроитьПредставлениеРазрезов(ЭтотОбъект,,"БазаРаспределения",Ложь);
	ВсеРазрезы = фин_РаботаСДополнительнымиРазрезамиБюджетирования.ВсеРазрезы();
	АктивныеРазрезы = фин_РаботаСДополнительнымиРазрезамиБюджетирования.ПолучитьПолныйСписокРазрезов();
	Для Каждого Разрез Из ВсеРазрезы Цикл
		Если АктивныеРазрезы.НайтиПоЗначению(Перечисления.фин_ФактическиеПоказателиБюджетирования[Разрез])<>Неопределено Тогда
			СписокВсеРазрезы.Добавить(Разрез);
			Элементы["БазаРаспределенияЗначение"+Разрез].ОграничениеТипа = фин_РаботаСДополнительнымиРазрезамиБюджетирования.РазрезПоИзмерению(Перечисления.фин_ФактическиеПоказателиБюджетирования[Разрез]).ТипЗначения;
			Элементы["БазаРаспределения"+Разрез].Заголовок = фин_РаботаСДополнительнымиРазрезамиБюджетирования.ПредставлениеРазреза(Перечисления.фин_ФактическиеПоказателиБюджетирования[Разрез]);
			Элементы["ОтражениеРезультатовЗначение"+Разрез].ОграничениеТипа = фин_РаботаСДополнительнымиРазрезамиБюджетирования.РазрезПоИзмерению(Перечисления.фин_ФактическиеПоказателиБюджетирования[Разрез]).ТипЗначения;
			Элементы["ОтражениеРезультатов"+Разрез].Заголовок = фин_РаботаСДополнительнымиРазрезамиБюджетирования.ПредставлениеРазреза(Перечисления.фин_ФактическиеПоказателиБюджетирования[Разрез]);
		КонецЕсли;
		Если Разрез = "Номенклатура" Тогда
			Продолжить;
		КонецЕсли;
		Элементы["ОтражениеРезультатовГруппа"+Разрез].Видимость = АктивныеРазрезы.НайтиПоЗначению(Перечисления.фин_ФактическиеПоказателиБюджетирования[Разрез])<>Неопределено;
		Элементы["БазаРаспределенияГруппа"+Разрез].Видимость = АктивныеРазрезы.НайтиПоЗначению(Перечисления.фин_ФактическиеПоказателиБюджетирования[Разрез])<>Неопределено;
		
	КонецЦикла;
	фин_РаботаСДополнительнымиРазрезамиБюджетирования.ЗаполнитьСписокРазрезовУчета(СписокВыбораРазрезыУчета);
	ВидимостьАналитики = Объект.ИсточникАналитикиДляРезультирующихСтрок=ПредопределенноеЗначение("Перечисление.фин_ИсточникиЗаполненияАналитикиПриРаспределении.ПустаяСсылка");
	Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
		Элементы["ОтражениеРезультатов"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
		Элементы["ОтражениеРезультатовЗначение"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
	КонецЦикла;
	ВидимостьАналитики = Объект.ВариантОтбораАналитикиБазыРаспределения=ПредопределенноеЗначение("Перечисление.фин_ВариантыОтбораАналитикиБазыРаспределения.ПустаяСсылка");
	Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
		Элементы["БазаРаспределения"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
		Элементы["БазаРаспределенияЗначение"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
	КонецЦикла;
	Элементы.ОтражениеРезультатовГруппаПроводкиУпр.Видимость = Объект.ФормироватьПроводки;
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.Равно);	
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.НеРавно);	
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.ВСписке);	
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.НеВСписке);	
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.ВСпискеПоИерерахии);	
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.ВИерархии);	
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.НеВИерархии);	
	СписокВыбораВидыОграничений.Добавить(Перечисления.фин_ВариантыОграниченияОбластиДанных.НеВСпискеПоИерархии);	
КонецПроцедуры

&НаКлиенте
Процедура ОбластьДействияЗависимостиПриАктивизацииСтроки(Элемент)
	Элементы.СписокОтбора.ТолькоПросмотр = (Элементы.ОбластьДействияЗависимости.ТекущиеДанные=Неопределено) ИЛИ НЕ СписочныйТип(Элементы.ОбластьДействияЗависимости.ТекущиеДанные.ВидОграничения);
	Элементы.ОбластьДействияЗависимостиУсловиеНаЗначение.ТолькоПросмотр = НЕ Элементы.СписокОтбора.ТолькоПросмотр;
	Если Элементы.ОбластьДействияЗависимости.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущееИзмерение = Элементы.ОбластьДействияЗависимости.ТекущиеДанные.Измерение;
	СписокОтбора.Очистить();
	Если ЗначениеЗаполнено(ТекущееИзмерение) Тогда
		СтрокиСписка = Объект.СпискиОграничений.НайтиСтроки(Новый Структура("Измерение",ТекущееИзмерение));
		Для Каждого СтрокаСписка Из СтрокиСписка Цикл
			СписокОтбора.Добавить(СтрокаСписка.УсловиеНаЗначение);
		КонецЦикла;
		УстановитьТипСписка(Элементы.ОбластьДействияЗависимости.ТекущиеДанные.Разрез);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьТипСписка(Разрез)
	СписокОтбора.ТипЗначения = Разрез.ТипЗначения;
	Элементы.ОбластьДействияЗависимостиУсловиеНаЗначение.ОграничениеТипа = Разрез.ТипЗначения;
КонецПроцедуры

&НаКлиенте
Функция СписочныйТип(ВариантСравнения)
	Массив = Новый Массив;
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.фин_ВариантыОграниченияОбластиДанных.ВСписке"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.фин_ВариантыОграниченияОбластиДанных.ВСпискеПоИерерахии"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.фин_ВариантыОграниченияОбластиДанных.НеВСписке"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.фин_ВариантыОграниченияОбластиДанных.НеВСпискеПоИерархии"));
	Возврат Массив.Найти(ВариантСравнения)<>Неопределено;
КонецФункции

&НаКлиенте
Процедура ОбластьДействияЗависимостиВидОграниченияПриИзменении(Элемент)
	Элементы.СписокОтбора.ТолькоПросмотр = (Элементы.ОбластьДействияЗависимости.ТекущиеДанные=Неопределено) ИЛИ НЕ СписочныйТип(Элементы.ОбластьДействияЗависимости.ТекущиеДанные.ВидОграничения);
	Элементы.ОбластьДействияЗависимостиУсловиеНаЗначение.ТолькоПросмотр = НЕ Элементы.СписокОтбора.ТолькоПросмотр;
	Если СписочныйТип(Элементы.ОбластьДействияЗависимости.ТекущиеДанные.ВидОграничения) Тогда
		Элементы.ОбластьДействияЗависимости.ТекущиеДанные.УсловиеНаЗначение = ПустоеЗначениеТипа(Элементы.ОбластьДействияЗависимости.ТекущиеДанные.Разрез);
	Иначе
		СтрокиУдалить = Объект.СпискиОграничений.НайтиСтроки(Новый Структура("Измерение",Элементы.ОбластьДействияЗависимости.ТекущиеДанные.Измерение));
		Для Каждого СтрокаУдалить Из СтрокиУдалить Цикл
			Объект.СпискиОграничений.Удалить(СтрокаУдалить);
		КонецЦикла;
		СписокОтбора.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПустоеЗначениеТипа(Разрез)
	Возврат ?(ЗначениеЗаполнено(Разрез),Разрез.ТипЗначения.ПривестиЗначение(Неопределено),Неопределено);	
КонецФункции

&НаКлиенте
Процедура ОбластьДействияЗависимостиИзмерениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокВыбораРазрезыУчета;
КонецПроцедуры

&НаКлиенте
Процедура ОбластьДействияЗависимостиИзмерениеПриИзменении(Элемент)
	ОбработатьИзменениеРазрезаУчета(Элементы.ОбластьДействияЗависимости.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеРазрезаУчета(ТекущаяСтрока)
	ТекущиеДанные = Объект.ОбластьДействияЗависимости.НайтиПоИдентификатору(ТекущаяСтрока);
    Разрез = фин_РаботаСДополнительнымиРазрезамиБюджетирования.РазрезПоИзмерению(ТекущиеДанные.Измерение);
	Если ЗначениеЗаполнено(Разрез) Тогда
		ТекущиеДанные.Разрез = Разрез;
		ТекущиеДанные.УсловиеНаЗначение = Разрез.ТипЗначения.ПривестиЗначение(ТекущиеДанные.УсловиеНаЗначение);
		СписокОтбора.ТипЗначения = Разрез.ТипЗначения;
		УстановитьТипСписка(Разрез);
	Иначе
		ТекущиеДанные.УсловиеНаЗначение = Неопределено;
		СписокОтбора.ТипЗначения = Новый ОписаниеТипов("Неопределено");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокОтбораПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьЗначенияСписка();
КонецПроцедуры

&НаКлиенте
Процедура СписокОтбораПослеУдаления(Элемент)
	ОбновитьЗначенияСписка();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗначенияСписка()
	СтрокиУдалить = Объект.СпискиОграничений.НайтиСтроки(Новый Структура("Измерение",Элементы.ОбластьДействияЗависимости.ТекущиеДанные.Измерение));
	Для Каждого СтрокаУдалить Из СтрокиУдалить Цикл
		Объект.СпискиОграничений.Удалить(СтрокаУдалить);
	КонецЦикла;
	Для Каждого ЭлементСписка Из СписокОтбора Цикл
		НоваяСтрока = Объект.СпискиОграничений.Добавить();
		НоваяСтрока.УсловиеНаЗначение = ЭлементСписка.Значение;
		НоваяСтрока.Измерение = Элементы.ОбластьДействияЗависимости.ТекущиеДанные.Измерение;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбластьДействияЗависимостиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Элементы.ОбластьДействияЗависимости.ТекущиеДанные.ВидОграничения = ПредопределенноеЗначение("Перечисление.фин_ВариантыОграниченияОбластиДанных.Равно");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеРезультатовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элементы.ОтражениеРезультатов.ТекущиеДанные;
		ТекущиеДанные.Данные = ПредопределенноеЗначение("Перечисление.фин_РеквизитыДляРасчетаЗависимыхСтатейБюджета.Сумма");
		ТекущиеДанные.Коэффициент = 1;
		Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
			ТекущиеДанные[ЭлементРазрез.Значение] = ПредопределенноеЗначение("Перечисление.фин_ИсточникиЗаполненияАналитикиПриРаспределении.ФиксированноеЗначение");
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбластьДействияЗависимостиУсловиеНаЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущееИзмерение = Элементы.ОбластьДействияЗависимости.ТекущиеДанные.Разрез;
	Если ЗначениеЗаполнено(ТекущееИзмерение) Тогда
		УстановитьТипСписка(ТекущееИзмерение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсточникАналитикиДляРезультирующихСтрокПриИзменении(Элемент)
	ВидимостьАналитики = Объект.ИсточникАналитикиДляРезультирующихСтрок=ПредопределенноеЗначение("Перечисление.фин_ИсточникиЗаполненияАналитикиПриРаспределении.ПустаяСсылка");
	Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
		Элементы["ОтражениеРезультатов"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
		Элементы["ОтражениеРезультатовЗначение"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
	КонецЦикла;
	Если НЕ ВидимостьАналитики Тогда
		Для Каждого СтрокаРезультат Из Объект.ОтражениеРезультатов Цикл
			Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
				СтрокаРезультат["Значение"+ЭлементРазрез.Значение] = Элементы["ОтражениеРезультатовЗначение"+ЭлементРазрез.Значение].ОграничениеТипа.ПривестиЗначение(Неопределено);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура БазаРаспределенияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элементы.БазаРаспределения.ТекущиеДанные;
		ТекущиеДанные.Данные = ПредопределенноеЗначение("Перечисление.фин_РеквизитыДляРасчетаЗависимыхСтатейБюджета.Сумма");
		Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
			ТекущиеДанные[ЭлементРазрез.Значение] = ПредопределенноеЗначение("Перечисление.фин_ВариантыОтбораАналитикиБазыРаспределения.БезОтбора");
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтбораАналитикиБазыРаспределенияПриИзменении(Элемент)
	ВидимостьАналитики = Объект.ВариантОтбораАналитикиБазыРаспределения=ПредопределенноеЗначение("Перечисление.фин_ВариантыОтбораАналитикиБазыРаспределения.ПустаяСсылка");
	Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
		Элементы["БазаРаспределения"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
		Элементы["БазаРаспределенияЗначение"+ЭлементРазрез.Значение].Видимость = ВидимостьАналитики;
	КонецЦикла;
	Если НЕ ВидимостьАналитики Тогда
		Для Каждого СтрокаРезультат Из Объект.БазаРаспределения Цикл
			Для Каждого ЭлементРазрез Из СписокВсеРазрезы Цикл
				СтрокаРезультат["Значение"+ЭлементРазрез.Значение] = Элементы["БазаРаспределенияЗначение"+ЭлементРазрез.Значение].ОграничениеТипа.ПривестиЗначение(Неопределено);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбластьДействияЗависимостиВидОграниченияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	ДанныеВыбора = СписокВыбораВидыОграничений;
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьПроводкиПриИзменении(Элемент)
	Элементы.ОтражениеРезультатовГруппаПроводкиУпр.Видимость = Объект.ФормироватьПроводки;
КонецПроцедуры
