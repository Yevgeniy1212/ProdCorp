﻿&НаКлиенте
Перем мОтображатьСтруктурныеПодразделения Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ИЗМЕНЕНИЯ ЗНАЧЕНИЙ РЕКВИЗИТОВ ШАПКИ


// Процедура - обработчик события "ПриИзменении" элемента "СтруктурноеПодразделениеОрганизация"
//
&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("Владелец", СтруктурноеПодразделениеОрганизация );
	//ПриИзмененииЗначенияОрганизации(Элемент);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ОБЩИХ ДЛЯ ВСЕЙ ФОРМЫ
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Список.Параметры.УстановитьЗначениеПараметра("Владелец",Организация)
	Список.Параметры.УстановитьЗначениеПараметра("Владелец", СтруктурноеПодразделение);
	// проставляем организацию пользователя по умолчанию
	Если Параметры.Свойство("ВыборПоВладельцу") Тогда
		Организация = Параметры.ВыборПоВладельцу
	КонецЕсли;
	Если Параметры.Свойство("ОтборПоВладельцу") Тогда
		Организация = Параметры.ОтборПоВладельцу;
	КонецЕсли;
	Если Организация.Пустая() Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяОрганизация");
		Если Не Организация.Пустая() Тогда
			//Список.Параметры.УстановитьЗначениеПараметра("Владелец",Организация)
			//Список.Отбор.Владелец.Использование = Истина;
			//ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
			//ЭлементОтбора.ПравоеЗначение = Организация;
			//ЭлементОтбора.Использование = Истина;
			//Список.Отбор.Владелец= Организация;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктурноеПодразделение) Тогда
		//Список.Параметры.УстановитьЗначениеПараметра("Владелец",СтруктурноеПодразделение)
		//Список.Отбор.Ссылка.Использование = Истина;
		//Список.Отбор.Ссылка.ВидСравнения = ВидСравнения.ВИерархии;
		//Список.Отбор.Ссылка.Значение = СтруктурноеПодразделение;
		//Элементы.СправочникСписок.НастройкаОтбора.Ссылка.Доступность = Истина;
	КонецЕсли;
	Если мОтображатьСтруктурныеПодразделения Тогда
		Элементы.СтруктурноеПодразделениеОрганизация.ТолькоПросмотр = (Параметры.Свойство("ВыборПоВладельцу") Или Параметры.Свойство("ОтборПоВладельцу"));
	Иначе
		// Проверка ведения однофирменности
		Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	КонецЕсли;
	// Выбор страницы панели ПанельСтруктурныеПодразделения, заполнение реквизита формы "СтруктурноеПодразделение"
    ПанельСтруктурногоПодразделения = Элементы.ПанельСтруктурногоПодразделения;
    //куфиб_РаботаСДиалогами.УстановитьВидимостьСтруктурногоПодразделенияВУправляемойФорме(Организация, СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, мОтображатьСтруктурныеПодразделения, Элементы.СтруктурноеПодразделениеОрганизация, Ложь);
	Если мОтображатьСтруктурныеПодразделения Тогда
		Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделение)Тогда
			СтруктурноеПодразделениеОрганизация = Организация;
		Иначе
			СтруктурноеПодразделениеОрганизация = ?(ЗначениеЗаполнено(СтруктурноеПодразделение), СтруктурноеПодразделение, Организация);
		КонецЕсли;	
		//ПанельСтруктурногоПодразделения.ТекущаяСтраница = Элементы.СтруктурнаяЕдиница;
		Элементы.СтруктурнаяЕдиница.Видимость = Истина;
		Элементы.Организация.Видимость = Ложь;
	Иначе 
		Если ЗначениеЗаполнено(СтруктурноеПодразделение)Тогда
			СтруктурноеПодразделениеОрганизация = ?(ЗначениеЗаполнено(СтруктурноеПодразделение), СтруктурноеПодразделение, Организация);
			ПанельСтруктурногоПодразделения.ТекущаяСтраница = Элементы.СтруктурнаяЕдиница;
    	Иначе
			//ПанельСтруктурногоПодразделения.ТекущаяСтраница = Элементы.Организация;
			Элементы.СтруктурнаяЕдиница.Видимость = Ложь;
			Элементы.Организация.Видимость = Истина;
		КонецЕсли;	
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("Владелец",СтруктурноеПодразделениеОрганизация);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Организация") тогда
		Если ТипЗнч(Параметры.Организация) = ТипЗнч(СтруктурноеПодразделение) Тогда
			СтруктурноеПодразделение = Параметры.Организация;
		КонецЕсли;
		Если ТипЗнч(Параметры.Организация) = ТипЗнч(Организация) Тогда
			Организация = Параметры.Организация;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры



мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();
