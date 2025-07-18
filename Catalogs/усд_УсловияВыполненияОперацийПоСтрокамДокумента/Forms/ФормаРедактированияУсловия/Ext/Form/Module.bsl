﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ОбъектВладелец") Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Форма не предназначена для самостоятельного использования!'"));
		Возврат;
	КонецЕсли;
	
	ПодготовитьФормуНаСервере(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СоставныеЧастиУсловия.ТекущаяСтрока = СоставныеЧастиУсловия[ИндексСтроки].ПолучитьИдентификатор();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

//Процедура ИмяРеквизитаПриИзменении
//
&НаКлиенте
Процедура ИмяРеквизитаПриИзменении(Элемент)
	
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	
	УправлениеФормой(ЭтотОбъект);
	НастроитьТипПроизвольныхЗначений();
	
	ВыбранныеДанные.ЗначениеДляСравнения 			= Элементы.ЗначениеДляСравнения.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения);
	ВыбранныеДанные.ЗначениеДляСравнения2 			= Элементы.ЗначениеДляСравнения2.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения2);
	
КонецПроцедуры //ИмяРеквизитаПриИзменении

//Процедура ИмяРеквизитаНачалоВыбора
//
&НаКлиенте
Процедура ИмяРеквизитаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("Элемент", Элемент);
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВыбораИмяРеквизита", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.усд_ФормаВыбораРеквизита",Новый Структура("ВидДокументов,ВидДанных,ИмяИсточника",ОбъектВладелец,ВидДанных,ИмяИсточника),ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры   

//ВыборТипТипизатораНачалоВыбора
//
&НаКлиенте
Процедура ВыборТипТипизатораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	ВыбранныеДанные.Типизатор = Неопределено;
КонецПроцедуры //ВыборТипТипизатораНачалоВыбора

//Процедура ВыборТипТипизатораПриИзменении
//
&НаКлиенте
Процедура ВыборТипТипизатораПриИзменении(Элемент)
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	ПредставлениеТипизатора = Строка(ТипЗнч(ВыбранныеДанные.Типизатор));
	УправлениеФормой(ЭтотОбъект);
	НастроитьТипПроизвольныхЗначений();
	ВыбранныеДанные.ЗначениеДляСравнения 			= Элементы.ЗначениеДляСравнения.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения);
	ВыбранныеДанные.ЗначениеДляСравнения2 			= Элементы.ЗначениеДляСравнения2.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения2);
КонецПроцедуры //ВыборТипТипизатораПриИзменении


&НаКлиенте
Процедура ЗначениеДляСравнения3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	ПараметрыФормы = Новый Структура("Отбор",Новый Структура("СсылкаЭкземпляра",?(Найти(ВыбранныеДанные.ИмяРеквизита,"Автовыбор")<>0,ВыбранныеДанные.Типизатор,?(Не ОписаниеТипов = Неопределено,ОписаниеТипов.ПривестиЗначение(Неопределено), Неопределено))));
	ОткрытьФорму("Справочник.фин_СпискиДанных.ФормаВыбора",ПараметрыФормы,Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДляСравнения3ПриИзменении(Элемент)
	
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	Если ЗначениеЗаполнено(ВыбранныеДанные.ПредопределенныйСписок) Тогда
		СписокСравнения.Очистить();
		Элементы.СписокСравнения.Доступность = Ложь;
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВложенноеПолеПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	НастроитьТипПроизвольныхЗначений();
	ВыбранныеДанные.ЗначениеДляСравнения 			= Элементы.ЗначениеДляСравнения.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения);
	ВыбранныеДанные.ЗначениеДляСравнения2 			= Элементы.ЗначениеДляСравнения2.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения2);
КонецПроцедуры

&НаКлиенте
Процедура ТипизаторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение)=Тип("Тип") Тогда
		ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
		ВыбранныеДанные.Типизатор = Новый (ВыбранноеЗначение);
		ВыборТипТипизатораПриИзменении(Элемент);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсточникДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокРегистров();
КонецПроцедуры

&НаКлиенте
Процедура ВложенноеПолеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("Элемент", Элемент);
	ОповещениеВыбораИмяВложенногоПоля = Новый ОписаниеОповещения("ПослеЗакрытияВыбораИмяВложенногоПоля", ЭтотОбъект, ДополнительныеПараметры);
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	ОткрытьФорму("ОбщаяФорма.усд_ФормаВыбораРеквизита",Новый Структура("СсылкаНаОбъект",ВыбранныеДанные.Типизатор),ЭтотОбъект,,,, ОповещениеВыбораИмяВложенногоПоля, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <СписокСравнений>

//Процедура СписокСравненийПриНачалеРедактирования
//
&НаКлиенте
Процедура СписокСравненийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И ОписаниеТипов <> Неопределено Тогда
		Элемент.ТекущиеДанные.Значение = ОписаниеТипов.ПривестиЗначение(Элемент.ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры //СписокСравненийПриНачалеРедактирования

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ПараметрыСвязи>

&НаКлиенте
Процедура ПараметрыСвязиРеквизитДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("Элемент", Элементы.ПараметрыСвязи);
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВыбораИмяРеквизита", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.усд_ФормаВыбораРеквизита",Новый Структура("ВидДокументов,ВидДанных,ИмяИсточника",ОбъектВладелец,ВидДанных,ИмяИсточника),ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыСвязиРеквизитДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ВыбранноеЗначение = ВыбранноеЗначение.Путь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

//КомандаОК
//
&НаКлиенте
Процедура КомандаОК(Кнопка)
	
	Сообщение = "";
	Если НЕ ФормированиеРезультата(Сообщение) Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "Условие некорректно: "  +Сообщение + Символы.ПС + "Удалить его из списка условий?", РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет, "Некорректное условие");
	Иначе
		ВернутьРезультат();
	КонецЕсли;
	
КонецПроцедуры //КомандаОК

//Процедура КонструкторЗапроса
//
&НаКлиенте
Процедура КонструкторЗапроса(Команда)

	Конструктор = Новый КонструкторЗапроса();
	Если СокрЛП(ПолеТекстаЗапроса.ПолучитьТекст()) <> "" Тогда
		Конструктор.Текст = ПолеТекстаЗапроса.ПолучитьТекст();
	КонецЕсли;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияКонструктораЗапроса", ЭтотОбъект);
	Попытка
		Конструктор.Показать(Оповещение);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Текст запроса не корректен!'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Описание ошибки в тексте запроса: '") + Символы.ПС + "		" + ОписаниеОшибки);
	КонецПопытки;
		
КонецПроцедуры //КонструкторЗапроса

//Процедура КоманднаяПанель2Проверить
//
&НаКлиенте
Процедура Проверить(Команда)
	
	ПроверитьЗапрос();
	
КонецПроцедуры //КоманднаяПанель2Проверить

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере(Отказ)
	
	НадписьСвязьДокументаИРегистра 	= "Связь документа и регистра";
	НадписьТекстЗапроса 			= "Текст запроса";
	НадписьДанныеДляПроверкиУсловия = "Данные для проверки условия";
	
	ОбъектВладелец 	= Параметры.ОбъектВладелец;
	ВидДанных		= Параметры.ВидДанных;
	ИмяИсточника	= Параметры.ИмяИсточника;
	Адрес 			= Параметры.Адрес;
	СоставныеЧастиУсловия.Загрузить(ПолучитьИзВременногоХранилища(Адрес));
	ИндексСтроки 	= Параметры.ТекущаяСтрока;
	Если НЕ ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Форма не предназначена для самостоятельного использования!'"));
		Возврат;
	КонецЕсли;
	ПрограммныйИдентификатор = ОбъектВладелец.ПрограммныйИдентификатор;
	Если СоставныеЧастиУсловия[ИндексСтроки].СтрокаПараметрыСоединенияСИсточником<>"" Тогда
		Таблица = ЗначениеИзСтрокиВнутр(СоставныеЧастиУсловия[ИндексСтроки].СтрокаПараметрыСоединенияСИсточником);
		Если ТипЗнч(Таблица) = Тип("ТаблицаЗначений") Тогда
			Для Каждого Строка Из Таблица Цикл
				НоваяСтрока = ПараметрыСвязи.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Если СоставныеЧастиУсловия[ИндексСтроки].СтрокаСписокСравнения<>"" Тогда
		СписокЗначений = ЗначениеИзСтрокиВнутр(СоставныеЧастиУсловия[ИндексСтроки].СтрокаСписокСравнения);
		Если ТипЗнч(СписокЗначений) = Тип("ТаблицаЗначений") Тогда
			Для Каждого Строка Из СписокЗначений Цикл
				НоваяСтрока = СписокСравнения.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	ПолеТекстаЗапроса.УстановитьТекст(СоставныеЧастиУсловия[ИндексСтроки].ПроизвольныйИсточник);	
	ПредставлениеТипизатора = Строка(ТипЗнч(СоставныеЧастиУсловия[ИндексСтроки].Типизатор));
	
	Если НЕ СокрЛП(СоставныеЧастиУсловия[ИндексСтроки].ИмяРеквизита) = "" Тогда	
		НастроитьТипПроизвольныхЗначений();		
		ЗаполнитьСпискиВыбораполейРегистра();
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура НастроитьТипПроизвольныхЗначений()
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	
	ОписаниеТипов = фин_ПроцедурыМеханизмовБюджетирования.ОпределитьОписаниеТиповПоПутиРеквизита(Метаданные.Документы.Найти(ПрограммныйИдентификатор),СокрЛП(ВыбранныеДанные.ИмяРеквизита),ВидДанных,СокрЛП(ИмяИсточника), ВыбранныеДанные.Типизатор,ВыбранныеДанные.УсловиеНаВложенноеПоле,ВыбранныеДанные.ВложенноеПоле);
	Элементы.ЗначениеДляСравнения.ОграничениеТипа 	= ОписаниеТипов;
	Элементы.ЗначениеДляСравнения2.ОграничениеТипа 	= ОписаниеТипов;
	ВыбранныеДанные.ЗначениеДляСравнения 	= ОписаниеТипов.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения);
	ВыбранныеДанные.ЗначениеДляСравнения2 	= ОписаниеТипов.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения2);
	Элементы.СписокСравнения.ПодчиненныеЭлементы.СписокСравненияЗначение.ОграничениеТипа = ОписаниеТипов;
	Для Каждого СтрокаСписка Из СписокСравнения Цикл
		 СтрокаСписка.Значение = ОписаниеТипов.ПривестиЗначение(СтрокаСписка.Значение);
	КонецЦикла;
	ТаблицаСписокСравнения = СписокСравнения.Выгрузить();
	ТаблицаСписокСравнения.Свернуть("Значение");
	СписокСравнения.Загрузить(ТаблицаСписокСравнения);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораПолейРегистра()
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	СписокВыбораРесурсовРегистра.Очистить();
	СписокВыбораИзмеренийРегистра.Очистить();
	Если СокрЛП(ВыбранныеДанные.ИсточникДанных) <> "" Тогда
		 Регистр = Метаданные.РегистрыСведений.Найти(ВыбранныеДанные.ИсточникДанных);
		 Если Регистр <>Неопределено Тогда
			 Для Каждого Ресурс Из Регистр.Ресурсы Цикл
				 СписокВыбораРесурсовРегистра.Добавить(Ресурс.Имя,Ресурс.Синоним);
			 КонецЦикла;
			 Для Каждого Ресурс Из Регистр.Реквизиты Цикл
				 СписокВыбораРесурсовРегистра.Добавить(Ресурс.Имя,Ресурс.Синоним);
			 КонецЦикла;
			 Для Каждого Ресурс Из Регистр.Измерения Цикл
				 СписокВыбораИзмеренийРегистра.Добавить(Ресурс.Имя,Ресурс.Синоним);
			 КонецЦикла;
			 Если ВыбранныеДанные.РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПолемРегистраСведений Тогда
				 Если Регистр.Ресурсы.Найти(ВыбранныеДанные.ПолеИсточникаДляСравнения)=Неопределено И 
					 Регистр.Реквизиты.Найти(ВыбранныеДанные.ПолеИсточникаДляСравнения)=Неопределено Тогда
					 ВыбранныеДанные.ПолеИсточникаДляСравнения="";
				 КонецЕсли;
				 Если Регистр.Ресурсы.Найти(ВыбранныеДанные.ПолеИсточникаДляСравнения2)=Неопределено И 
					 Регистр.Реквизиты.Найти(ВыбранныеДанные.ПолеИсточникаДляСравнения2)=Неопределено Тогда
					 ВыбранныеДанные.ПолеИсточникаДляСравнения2="";
				 КонецЕсли;
			 КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	СписокВыбораИзмеренийРегистра.СортироватьПоПредставлению();
	СписокВыбораРесурсовРегистра.СортироватьПоПредставлению();
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокРегистров()
	СписокВыбора = Новый СписокЗначений;
	Если СписокВыбора.Количество() =0 Тогда
		Для Каждого Регистр Из Метаданные.РегистрыСведений Цикл
			 СписокВыбора.Добавить(Регистр.Имя,Регистр.Синоним);
		КонецЦикла;
	КонецЕсли;
	СписокВыбора.СортироватьПоПредставлению();
	Возврат СписокВыбора;
КонецФункции

//Процедура УправлениеФормой
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
		
	ВыбранныеДанные = Форма.СоставныеЧастиУсловия[Форма.ИндексСтроки];
	Если ВыбранныеДанные.РежимСравнения = ПредопределенноеЗначение("Перечисление.усд_РежимыСравненияДляУсловий.СравнениеСПолемПроизвольногоИсточника") Тогда
	    Элементы.ГруппаСтраницы.ТекущаяСтраница 	= Элементы.ГруппаСравнениеСПолемРегистраСведений;
	ИначеЕсли ВыбранныеДанные.РежимСравнения = ПредопределенноеЗначение("Перечисление.усд_РежимыСравненияДляУсловий.СравнениеСПолемРегистраСведений") Тогда
	    Элементы.ГруппаСтраницы.ТекущаяСтраница		= Элементы.ГруппаСравнениеСПолемРегистраСведений;
	ИначеЕсли ВыбранныеДанные.РежимСравнения = ПредопределенноеЗначение("Перечисление.усд_РежимыСравненияДляУсловий.СравнениеСПроизвольнымЗначением") Тогда
	    Элементы.ГруппаСтраницы.ТекущаяСтраница 	= Элементы.ГруппаСравнениеСПроизвольнымЗначением;
	Иначе
		ВыбранныеДанные.РежимСравнения = ПредопределенноеЗначение("Перечисление.усд_РежимыСравненияДляУсловий.СравнениеСПроизвольнымЗначением");
	    Элементы.ГруппаСтраницы.ТекущаяСтраница		= Элементы.ГруппаСравнениеСПроизвольнымЗначением;
	КонецЕсли;
	
	Если ВыбранныеДанные.ВидСравнения = ПредопределенноеЗначение("Перечисление.усд_ВидыСравненияДляУсловий.ВИнтервале") 
			ИЛИ ВыбранныеДанные.ВидСравнения = ПредопределенноеЗначение("Перечисление.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы") Тогда
		Элементы.ЗначениеДляСравнения2.Видимость 		= Истина;	
		Элементы.ПолеИсточникаДляСравнения2.Видимость 	= Истина;	
		Элементы.ПолеИсточникаДляСравнения4.Видимость 	= Истина;
	Иначе		
		Элементы.ЗначениеДляСравнения2.Видимость 		= Ложь;	
		Элементы.ПолеИсточникаДляСравнения2.Видимость 	= Ложь;	
		Элементы.ПолеИсточникаДляСравнения4.Видимость 	= Ложь;	
	КонецЕсли;
	
	ЭтоСписок  = Ложь;
	мВидСравнения = ВыбранныеДанные.ВидСравнения;
	Если мВидСравнения = ПредопределенноеЗначение("Перечисление.усд_ВидыСравненияДляУсловий.ВСписке") 
		ИЛИ мВидСравнения = ПредопределенноеЗначение("Перечисление.усд_ВидыСравненияДляУсловий.ВСпискеПоИерархии")
		ИЛИ мВидСравнения = ПредопределенноеЗначение("Перечисление.усд_ВидыСравненияДляУсловий.НеВСписке")
		ИЛИ мВидСравнения = ПредопределенноеЗначение("Перечисление.усд_ВидыСравненияДляУсловий.НеВСпискеПоИерархии") Тогда
		ЭтоСписок = Истина;
	КонецЕсли;
	
	Элементы.ГруппаСписокЗначений.Видимость 		= ЭтоСписок;
	Элементы.ГруппаПроизвольноеЗначение.Видимость 	= НЕ ЭтоСписок;
	ПредставлениеТипизатора = Строка(ТипЗнч(ВыбранныеДанные.Типизатор));
	Если ЭтоСписок  Тогда
		Элементы.СписокСравнения.Видимость					= НЕ ЗначениеЗаполнено(ВыбранныеДанные.ПредопределенныйСписок);
		Элементы.СоставПредопределенногоСписка.Видимость	= ЗначениеЗаполнено(ВыбранныеДанные.ПредопределенныйСписок);
	КонецЕсли;
	Если Найти(ВыбранныеДанные.ИмяРеквизита,"АвтовыборПоТипу:") <>0 Тогда
		Элементы.ГруппаТипизатор.Видимость 		= Истина;
		Элементы.ГруппаВложенноеПоле.Видимость 	= Истина;
		Элементы.ВложенноеПоле.ТолькоПросмотр 	= НЕ ВыбранныеДанные.УсловиеНаВложенноеПоле;
	Иначе
		Элементы.ГруппаТипизатор.Видимость 		= Ложь;
		Элементы.ГруппаВложенноеПоле.Видимость 	= Ложь;
	КонецЕсли;
КонецПроцедуры //УправлениеФормой

&НаКлиенте
Процедура ПослеЗакрытияКонструктораЗапроса(Текст, ДополнительныеПараметры) Экспорт 
	
	Если НЕ Текст = Неопределено Тогда
		ПолеТекстаЗапроса.УстановитьТекст(Текст);
		ПроверитьЗапрос();
		ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
		Если Элементы.ПолеИсточникаДляСравнения3.СписокВыбора.НайтиПоЗначению(ВыбранныеДанные.ПолеИсточникаДляСравнения) = Неопределено Тогда
			ВыбранныеДанные.ПолеИсточникаДляСравнения = "";	
		КонецЕсли;
		Если Элементы.ПолеИсточникаДляСравнения4.СписокВыбора.НайтиПоЗначению(ВыбранныеДанные.ПолеИсточникаДляСравнения) = Неопределено Тогда
			ВыбранныеДанные.ПолеИсточникаДляСравнения2 = "";	
		КонецЕсли;		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗапрос()
	
	ВыполнитьПроверкуЗапроса();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуЗапроса()
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолеТекстаЗапроса.ПолучитьТекст();
	Если ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Если ТипЗнч(ОбъектВладелец)=Тип("СправочникСсылка.фин_ВидыДокументов") Тогда
			ОбъектМетаданных = Метаданные.Документы.Найти(ПрограммныйИдентификатор);
			Если Строка(ОбъектМетаданных.Проведение)="Разрешить" Тогда
				Запрос.УстановитьПараметр("Проведен",Истина);
			КонецЕсли;
			Запрос.УстановитьПараметр("Дата",ТекущаяДата());
			Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
				 Запрос.УстановитьПараметр(Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
			КонецЦикла;
			Если ВидДанных = Перечисления.фин_ВидыОтраженийПервичныхДокументовВБюджетировании.ПоТабличнойЧасти Тогда
				ОбъектПоиска = Метаданные.Документы.Найти(ПрограммныйИдентификатор).ТабличныеЧасти.Найти(ИмяИсточника);
				Для Каждого Реквизит Из ОбъектПоиска.Реквизиты Цикл
					Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
				КонецЦикла;
			КонецЕсли;
			Если ВидДанных = Перечисления.фин_ВидыОтраженийПервичныхДокументовВБюджетировании.ПоДвижениямВРегистрах Тогда
				ИмяРегистра = Сред(ИмяИсточника,Найти(ИмяИсточника,".")+1);
				ОбъектПоиска = Метаданные["Регистры"+?(Найти(ИмяИсточника,"Сведений.")<>0,"Сведений",?(Найти(ИмяИсточника,"Накопления.")<>0,"Накопления",?(Найти(ИмяИсточника,"Бухгалтерии.")<>0,"Бухгалтерии","Расчета")))].Найти(ИмяРегистра);
				Если Найти(ИмяИсточника,"Бухгалтерии.")<>0 Тогда
					Для Каждого Реквизит Из ОбъектПоиска.Измерения Цикл
						Если Реквизит.Балансовый Тогда
							Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
						Иначе
							Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя+"Дт",Реквизит.Тип.ПривестиЗначение(Неопределено));
							Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя+"Кт",Реквизит.Тип.ПривестиЗначение(Неопределено));
						КонецЕсли;
					КонецЦикла;
					Для Каждого Реквизит Из ОбъектПоиска.Ресурсы Цикл
						Если Реквизит.Балансовый Тогда
							Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
						Иначе
							Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя+"Дт",Реквизит.Тип.ПривестиЗначение(Неопределено));
							Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя+"Кт",Реквизит.Тип.ПривестиЗначение(Неопределено));
						КонецЕсли;
					КонецЦикла;
					Для Каждого Реквизит Из ОбъектПоиска.Реквизиты Цикл
						Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
					КонецЦикла;
					СписокСвойств = Новый СписокЗначений;
					СписокСвойств.Добавить("СчетДт","Счет Дт");
					СписокСвойств.Добавить("СчетКт","Счет Кт");
					СписокСвойств.Добавить("СубконтоДт1","Субконто Дт (1)");
					СписокСвойств.Добавить("СубконтоДт2","Субконто Дт (2)");
					СписокСвойств.Добавить("СубконтоДт3","Субконто Дт (3)");
					СписокСвойств.Добавить("СубконтоКт1","Субконто Кт (1)");
					СписокСвойств.Добавить("СубконтоКт2","Субконто Кт (2)");
					СписокСвойств.Добавить("СубконтоКт3","Субконто Кт (3)");
					СписокСвойств.Добавить("ВидСубконтоДт1","Вид Субконто Дт (1)");
					СписокСвойств.Добавить("ВидСубконтоДт2","Вид Субконто Дт (2)");
					СписокСвойств.Добавить("ВидСубконтоДт3","Вид Субконто Дт (3)");
					СписокСвойств.Добавить("ВидСубконтоКт1","Вид Субконто Кт (1)");
					СписокСвойств.Добавить("ВидСубконтоКт2","Вид Субконто Кт (2)");
					СписокСвойств.Добавить("ВидСубконтоКт3","Вид Субконто Кт (3)");
					Для Каждого Реквизит Из СписокСвойств Цикл
						Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Значение,ПолучитьТипСвойстваРегистраБухгалтерии(Реквизит,ОбъектПоиска));
					КонецЦикла;
				 Иначе
					Для Каждого Реквизит Из ОбъектПоиска.Измерения Цикл
						Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
					КонецЦикла;
					Для Каждого Реквизит Из ОбъектПоиска.Ресурсы Цикл
						Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
					КонецЦикла;
					Для Каждого Реквизит Из ОбъектПоиска.Реквизиты Цикл
						Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ОбъектМетаданных = Справочники.фин_КлассификаторРегистров.ПолучитьОбъектМетаданныхРегистраПоСсылке(ОбъектВладелец);
			Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
				 Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
			КонецЦикла;
			Для Каждого Реквизит Из ОбъектМетаданных.Измерения Цикл
				 Запрос.УстановитьПараметр("ТЧ_"+Реквизит.Имя,Реквизит.Тип.ПривестиЗначение(Неопределено));
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Попытка
		Результат = Запрос.Выполнить();
		ПоляПроизвольногоИсточника.Очистить();
		Для Каждого Колонка Из Результат.Колонки Цикл
			ПоляПроизвольногоИсточника.Добавить(Колонка.Имя);
		КонецЦикла;
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Текст запроса не корректен!'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Описание ошибки в тексте запроса: '") + Символы.ПС + "		" + ОписаниеОшибки);
	КонецПопытки;
	
КонецПроцедуры

//Функция ПолучитьТипСвойстваРегистраБухгалтерии
//
&НаСервере
Функция ПолучитьТипСвойстваРегистраБухгалтерии(мРеквизит,ОбъектПоиска) Экспорт
	Если Прав(мРеквизит,1)="1" ИЛИ Прав(мРеквизит,1)="2" ИЛИ Прав(мРеквизит,1)="3" Тогда
		мРеквизит = Лев(мРеквизит,СтрДлина(мРеквизит)-1);
	КонецЕсли;
	Если Прав(мРеквизит,2)="Дт" ИЛИ Прав(мРеквизит,2)="Кт" Тогда
		мРеквизит = Лев(мРеквизит,СтрДлина(мРеквизит)-2);
	КонецЕсли;
	Если мРеквизит="Счет" Тогда 
		ОписаниеТипов = Новый ОписаниеТипов("ПланСчетовСсылка."+ОбъектПоиска.ПланСчетов.Имя);
	ИначеЕсли Найти(мРеквизит,"ВидСубконто") Тогда
		ОписаниеТипов = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка."+ОбъектПоиска.ПланСчетов.ВидыСубконто.Имя);
	Иначе
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(ОбъектПоиска.ПланСчетов.ВидыСубконто.Тип));
		ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВыбораИмяРеквизита(Результат, ДополнительныеПараметры) Экспорт 
	
	
	Если Результат <> Неопределено Тогда
		Если ДополнительныеПараметры.Элемент.Имя = "ИмяРеквизита" Тогда 
			ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
			ВыбранныеДанные.ИмяРеквизита = Результат.Путь;
			ВыбранныеДанные.ПредставлениеРеквизита = Результат.Заголовок;
			ИмяРеквизитаПриИзменении(ДополнительныеПараметры.Элемент);
		Иначе
			ДополнительныеПараметры.Элемент.ТекущиеДанные.РеквизитДокумента = Результат.Путь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловиеНаВложенноеПолеПриИзменении(Элемент)
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	Если ВыбранныеДанные.УсловиеНаВложенноеПоле = Ложь Тогда
		ВыбранныеДанные.ВложенноеПоле = "";
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);
	НастроитьТипПроизвольныхЗначений();
	ВыбранныеДанные.ЗначениеДляСравнения 			= Элементы.ЗначениеДляСравнения.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения);
	ВыбранныеДанные.ЗначениеДляСравнения2 			= Элементы.ЗначениеДляСравнения2.ОграничениеТипа.ПривестиЗначение(ВыбранныеДанные.ЗначениеДляСравнения2);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВыбораИмяВложенногоПоля(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
		ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
		ВыбранныеДанные.ВложенноеПоле = Результат.Путь;
		ВложенноеПолеПриИзменении(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеИсточникаДляСравненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокВыбораРесурсовРегистра;
КонецПроцедуры

&НаКлиенте
Процедура ПолеИсточникаДляСравнения2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокВыбораРесурсовРегистра;
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыСвязиИзмерениеРегистраНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокВыбораИзмеренийРегистра;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Ответ, ПараметрыВопроса) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СоставныеЧастиУсловия.Удалить(СоставныеЧастиУсловия.Получить(ИндексСтроки));
		ВернутьРезультат(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ФормированиеРезультата(Сообщение)
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	Отказ = Ложь;
	Если ВыбранныеДанные.ИмяРеквизита ="" Тогда
		Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан реквизит документа;";
		Отказ = Истина;
	КонецЕсли;
	Если ВыбранныеДанные.РежимСравнения.Пустая() Тогда
		Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан режим сравнения;";
		Отказ = Истина;
	КонецЕсли;
	Если ВыбранныеДанные.ВидСравнения.Пустая() Тогда
		Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан вид сравнения;";
		Отказ = Истина;
	КонецЕсли;
	Если Найти(ВыбранныеДанные.ИмяРеквизита,"АвтовыборПоТипу:")<>0 И ВыбранныеДанные.Типизатор = Неопределено Тогда
		Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан тип для автовыбора;";
		Отказ = Истина;
	КонецЕсли;
	Если Найти(ВыбранныеДанные.ИмяРеквизита,"АвтовыборПоТипу:")<>0 И ВыбранныеДанные.УсловиеНаВложенноеПоле И  ВыбранныеДанные.ВложенноеПоле ="" Тогда
		Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано вложенное поле;";
		Отказ = Истина;
	КонецЕсли;
	Если ВыбранныеДанные.РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПолемПроизвольногоИсточника Тогда
			

		ВыбранныеДанные.ПроизвольныйИсточник = ПолеТекстаЗапроса.ПолучитьТекст();
		Если СокрЛП(ВыбранныеДанные.ПроизвольныйИсточник)="" Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан текст произвольного источника;";
			Отказ = Истина;
		КонецЕсли;
		Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения)="" Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано поле источника для сравнения;";
			Отказ = Истина;
		КонецЕсли;
		Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения2)="" 
			И (ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы 
				ИЛИ ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервале) Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан поле источника с верхней границей;";
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ВыбранныеДанные.РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПолемРегистраСведений Тогда
		ВыбранныеДанные.ПроизвольныйИсточник = "";
		ВыбранныеДанные.ЗначениеДляСравнения = Неопределено;
		ВыбранныеДанные.ЗначениеДляСравнения2 = Неопределено;
		Если СокрЛП(ВыбранныеДанные.ИсточникДанных)="" Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан регистр сведений;";
			Отказ = Истина;
		КонецЕсли;
		Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения)="" Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано поле источника для сравнения;";
			Отказ = Истина;
		КонецЕсли;
		Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения2)="" 
			И (ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы 
				ИЛИ ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервале) Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан поле источника с верхней границей;";
			Отказ = Истина;
		КонецЕсли;
		ВыбранныеДанные.СтрокаСписокСравнения = ЗначениеВСтрокуВнутр(Ложь);
	ИначеЕсли ВыбранныеДанные.РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПроизвольнымЗначением Тогда
		ВыбранныеДанные.ИсточникДанных ="";
		ВыбранныеДанные.СтрокаПараметрыСоединенияСИсточником = "";
		ВыбранныеДанные.ПроизвольныйИсточник = "";
		ВыбранныеДанные.ПолеИсточникаДляСравнения ="";
		ВыбранныеДанные.ПолеИсточникаДляСравнения2 ="";
		мВидСравнения = ВыбранныеДанные.ВидСравнения;
		ЭтоСписок = Ложь;
		Если мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВСписке 
			ИЛИ мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВСпискеПоИерархии
			ИЛИ мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеВСписке
			ИЛИ мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеВСпискеПоИерархии Тогда
			ЭтоСписок = Истина;
		КонецЕсли;
		Если ЭтоСписок Тогда
			Если СписокСравнения.Количество()=0 И НЕ ЗначениеЗаполнено(ВыбранныеДанные.ПредопределенныйСписок) Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан список значений для сравнения;";
				Отказ = Истина;
			КонецЕсли;
		Иначе
			Если ВыбранныеДанные.ЗначениеДляСравнения=Неопределено Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано значения для сравнения;";
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		Если ВыбранныеДанные.ЗначениеДляСравнения2=Неопределено 
			И (ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы 
				ИЛИ ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервале) Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано значение верхней границы;";
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат НЕ Отказ;
КонецФункции

&НаКлиенте
Процедура ВернутьРезультат(Удаление = Ложь)
	Поместить(Удаление);
	ВладелецФормы.ОбработатьРедактированиеУсловия();
	Закрыть();	
КонецПроцедуры

&НаСервере
Процедура Поместить(Удаление = Ложь)
	Сообщение = "";
	Если НЕ Удаление Тогда 
		ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
		
		Отказ = Ложь;
		Если ВыбранныеДанные.ИмяРеквизита ="" Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан реквизит документа;";
			Отказ = Истина;
		КонецЕсли;
		Если ВыбранныеДанные.РежимСравнения.Пустая() Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан режим сравнения;";
			Отказ = Истина;
		КонецЕсли;
		Если ВыбранныеДанные.ВидСравнения.Пустая() Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан вид сравнения;";
			Отказ = Истина;
		КонецЕсли;
		Если Найти(ВыбранныеДанные.ИмяРеквизита,"АвтовыборПоТипу:")<>0 И ВыбранныеДанные.Типизатор = Неопределено Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан тип для автовыбора;";
			Отказ = Истина;
		КонецЕсли;
		Если Найти(ВыбранныеДанные.ИмяРеквизита,"АвтовыборПоТипу:")<>0 И ВыбранныеДанные.УсловиеНаВложенноеПоле И  ВыбранныеДанные.ВложенноеПоле ="" Тогда
			Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано вложенное поле;";
			Отказ = Истина;
		КонецЕсли;
		Если ВыбранныеДанные.РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПолемПроизвольногоИсточника Тогда
			ВыбранныеДанные.ПроизвольныйИсточник = ПолеТекстаЗапроса.ПолучитьТекст();
			ВыбранныеДанные.ИсточникДанных ="";
			ВыбранныеДанные.СтрокаПараметрыСоединенияСИсточником = ЗначениеВСтрокуВнутр(Ложь);
			ВыбранныеДанные.ЗначениеДляСравнения = Неопределено;
			ВыбранныеДанные.ЗначениеДляСравнения2 = Неопределено;
			Если СокрЛП(ВыбранныеДанные.ПроизвольныйИсточник)="" Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан текст произвольного источника;";
				Отказ = Истина;
			КонецЕсли;
			Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения)="" Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано поле источника для сравнения;";
				Отказ = Истина;
			КонецЕсли;
			Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения2)="" 
				И (ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы 
				ИЛИ ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервале) Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан поле источника с верхней границей;";
				Отказ = Истина;
			КонецЕсли;
			ВыбранныеДанные.СтрокаСписокСравнения = ЗначениеВСтрокуВнутр(Ложь);
		ИначеЕсли ВыбранныеДанные.РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПолемРегистраСведений Тогда
			ВыбранныеДанные.СтрокаПараметрыСоединенияСИсточником = ЗначениеВСтрокуВнутр(ДанныеФормыВЗначение(ПараметрыСвязи,Тип("ТаблицаЗначений")));
			ВыбранныеДанные.ПроизвольныйИсточник = "";
			ВыбранныеДанные.ЗначениеДляСравнения = Неопределено;
			ВыбранныеДанные.ЗначениеДляСравнения2 = Неопределено;
			Если СокрЛП(ВыбранныеДанные.ИсточникДанных)="" Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан регистр сведений;";
				Отказ = Истина;
			КонецЕсли;
			Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения)="" Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано поле источника для сравнения;";
				Отказ = Истина;
			КонецЕсли;
			Если СокрЛП(ВыбранныеДанные.ПолеИсточникаДляСравнения2)="" 
				И (ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы 
				ИЛИ ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервале) Тогда
				Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан поле источника с верхней границей;";
				Отказ = Истина;
			КонецЕсли;
			ВыбранныеДанные.СтрокаСписокСравнения = ЗначениеВСтрокуВнутр(Ложь);
		ИначеЕсли ВыбранныеДанные.РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПроизвольнымЗначением Тогда
			ВыбранныеДанные.ИсточникДанных ="";
			ВыбранныеДанные.СтрокаПараметрыСоединенияСИсточником = ЗначениеВСтрокуВнутр(Ложь);
			ВыбранныеДанные.ПроизвольныйИсточник = "";
			ВыбранныеДанные.ПолеИсточникаДляСравнения ="";
			ВыбранныеДанные.ПолеИсточникаДляСравнения2 ="";
			мВидСравнения = ВыбранныеДанные.ВидСравнения;
			ЭтоСписок = Ложь;
			Если мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВСписке 
				ИЛИ мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВСпискеПоИерархии
				ИЛИ мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеВСписке
				ИЛИ мВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеВСпискеПоИерархии Тогда
				ЭтоСписок = Истина;
			КонецЕсли;
			Если ЭтоСписок Тогда
				Если СписокСравнения.Количество()=0 И НЕ ЗначениеЗаполнено(ВыбранныеДанные.ПредопределенныйСписок) Тогда
					Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указан список значений для сравнения;";
					Отказ = Истина;
				КонецЕсли;
			Иначе
				Если ВыбранныеДанные.ЗначениеДляСравнения=Неопределено Тогда
					Сообщение=Сообщение+Символы.ПС+Символы.Таб+"- не указано значения для сравнения;";
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
			Если ВыбранныеДанные.ЗначениеДляСравнения2=Неопределено 
				И (ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы 
				ИЛИ ВыбранныеДанные.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервале) Тогда
				Сообщение = Сообщение+Символы.ПС+Символы.Таб+"- не указано значение верхней границы;";
				Отказ = Истина;
			КонецЕсли;
			ВыбранныеДанные.СтрокаСписокСравнения = ЗначениеВСтрокуВнутр(ДанныеФормыВЗначение(СписокСравнения,Тип("ТаблицаЗначений")));
		КонецЕсли;
		
		ВыбранныеДанные.ОписаниеУсловия = Справочники.усд_УсловияВыполненияОперацийПоСтрокамДокумента.ПолучитьОписаниеУсловия(ВыбранныеДанные);
	КонецЕсли;
	ПоместитьВоВременноеХранилище(СоставныеЧастиУсловия.Выгрузить(),Адрес);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлементСписка(Команда)
	Если Элементы.СоставПредопределенногоСписка.ТекущиеДанные<>Неопределено Тогда
		ПоказатьЗначение(,Элементы.СоставПредопределенногоСписка.ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидСравненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбранныеДанные = СоставныеЧастиУсловия[ИндексСтроки];
	ДанныеВыбора = СписокВидовСравнения(ВыбранныеДанные.РежимСравнения);
КонецПроцедуры


&НаСервереБезКонтекста
Функция СписокВидовСравнения(РежимСравнения)
	СписокВидов = Новый СписокЗначений;
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.Равно);
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.НеРавно);
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.Больше);
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.БольшеИлиРавно);
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.Меньше);
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.МеньшеИлиРавно);
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервале);
	СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.ВИнтервалеВключаяГраницы);
	Если РежимСравнения = Перечисления.усд_РежимыСравненияДляУсловий.СравнениеСПроизвольнымЗначением Тогда
		СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.ВИерархии);
		СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.ВСписке);
		СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.ВСпискеПоИерархии);
		СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.НеВИерархии);
		СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.НеВСписке);
		СписокВидов.Добавить(Перечисления.усд_ВидыСравненияДляУсловий.НеВСпискеПоИерархии);
	КонецЕсли;
	Возврат СписокВидов;
КонецФункции
