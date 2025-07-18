﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Процедура ОбработкаПроведения
// 
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	фин_ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	ПараметрыПроведения = Документы.фин_УстановкаЛимитовИЦелевыхЗначений.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПроведения.Реквизиты[0].ВидОграниченияОборотов <> Перечисления.фин_ВидыОграниченийОборотовБюджета.ПредварительныйБюджет Тогда
		мТаблицаОборотов = ПараметрыПроведения.ТаблицаОборотов;
		ТаблицаОборотов = фин_УправлениеБюджетированием.ПодготовитьТаблицуОборотовКонтролирующегоСценария(мТаблицаОборотов);
	Иначе
		ТаблицаОборотов = ПараметрыПроведения.ТаблицаГраницыЗначений;
	КонецЕсли;
	Если ТаблицаОборотов<>Неопределено Тогда
		ТаблицаОборотов.Сортировать("Период Возр");
	КонецЕсли;
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	ИмяНабораДвижений = ?(ПараметрыПроведения.Реквизиты[0].ВидКонтролируемыхЗначений=Перечисления.фин_ВидыКонтролируемогоЗначенияБюджета.Ограничивающее,"фин_КонтролируемыеФинансовыеПоказатели","фин_ЦелевыеЗначенияПоБюджетам");
	Если НЕ ЗначениеЗаполнено(ПараметрыПроведения.Реквизиты[0].ИсправляемыйДокумент) Тогда
		фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаОборотов, Движения, Отказ,Неопределено,,,ИмяНабораДвижений);	
		фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаОборотов, Движения, Отказ,Неопределено,,,"фин_УстановкаОграниченийПоБюджетам");	
	Иначе
		ТаблицаДополнения = фин_УправлениеБюджетированием.ПодготовитьТаблицуИсправленийКЛимитам(ТаблицаОборотов,ПараметрыПроведения.ТаблицаДанныеИсправляемыхДокументов,ПараметрыПроведения.Реквизиты[0]);
		фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаДополнения, Движения, Отказ,Неопределено,,,ИмяНабораДвижений);	
		ТаблицаДополненийКПеречнюЛимитов = фин_УправлениеБюджетированием.ПодготовитьТаблицуИзмененныхОграниченийПриКорректировке(ТаблицаОборотов,ПараметрыПроведения.Реквизиты[0].ИсправляемыйДокумент);
		фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаДополненийКПеречнюЛимитов, Движения, Отказ,Неопределено,,,"фин_УстановкаОграниченийПоБюджетам");	
	КонецЕсли;
КонецПроцедуры //ОбработкаПроведения

// Процедура ПередЗаписью
// 
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ЭтоНовый() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	фин_УстановкаЛимитовИЦелевыхЗначений.Ссылка
			|ИЗ
			|	Документ.фин_УстановкаЛимитовИЦелевыхЗначений КАК фин_УстановкаЛимитовИЦелевыхЗначений
			|ГДЕ
			|	фин_УстановкаЛимитовИЦелевыхЗначений.Проведен
			|	И фин_УстановкаЛимитовИЦелевыхЗначений.ИсправляемыйДокумент = &ИсправляемыйДокумент";

		Запрос.УстановитьПараметр("ИсправляемыйДокумент", Ссылка);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ "+Строка(Ссылка)+" не может быть изменен:
			|		имеются исправления для данного документа!");
           Отказ = Истина;
		   Возврат;
		КонецЕсли;
	КонецЕсли;
	Если НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_ВестиУчетПоПроектам") Тогда
		Для Каждого Граница из ГраницыЗначений Цикл
			Граница.Проект = фин_ОбщегоНазначенияВызовСервераПовтИсп.ПустоеЗначениеРазреза("Проект");
		КонецЦикла;
	КонецЕсли;
	Если ВидОграниченияОборотов = Перечисления.фин_ВидыОграниченийОборотовБюджета.ПредварительныйБюджет Тогда
		КонтролирующийСценарий 				= фин_ОбщегоНазначенияВызовСервераПовтИсп.ПустаяСсылкаСценарий();
		ДатаНачалаКонтролирующегоСценария 	= '00010101';
		ДатаКонцаКонтролирующегоСценария 	= '00010101';
		ВидОтклоненияКонтролируемыхЗначений	= Перечисления.фин_ВидыОтклоненийКонтролируемыхЗначенийБюджетов.ПустаяСсылка();
	КонецЕсли;
	Если ВидОграниченияОборотов = Перечисления.фин_ВидыОграниченийОборотовБюджета.КонтролирующийСценарийВыборочно Тогда
		ДатаНачалаКонтролирующегоСценария 	= '00010101';
		ДатаКонцаКонтролирующегоСценария 	= '00010101';
		ВидОтклоненияКонтролируемыхЗначений = Перечисления.фин_ВидыОтклоненийКонтролируемыхЗначенийБюджетов.ПустаяСсылка();
	КонецЕсли;
	Если ИспользованиеКонтролируемыхЗначений = Перечисления.фин_ИспользованиеКонтролируемыхЗначенийБюджетов.ПриИсполнении Тогда
		Сценарий = фин_ОбщегоНазначенияВызовСервераПовтИсп.ПустаяСсылкаСценарий();
	КонецЕсли;
КонецПроцедуры //ПередЗаписью

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.фин_УстановкаЛимитовИЦелевыхЗначений") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	фин_УстановкаЛимитовИЦелевыхЗначений.Ссылка
			|ИЗ
			|	Документ.фин_УстановкаЛимитовИЦелевыхЗначений КАК фин_УстановкаЛимитовИЦелевыхЗначений
			|ГДЕ
			|	фин_УстановкаЛимитовИЦелевыхЗначений.Проведен
			|	И фин_УстановкаЛимитовИЦелевыхЗначений.ИсправляемыйДокумент = &ИсправляемыйДокумент";

		Запрос.УстановитьПараметр("ИсправляемыйДокумент", ДанныеЗаполнения.Ссылка);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ "+Строка(ДанныеЗаполнения.Ссылка)+" не может быть исправлен более одного раза:
			|		уже имеются исправления для данного документа!");
		   Возврат;
		КонецЕсли;
		// Заполнение шапки
		ВидКонтролируемыхЗначений 				= ДанныеЗаполнения.ВидКонтролируемыхЗначений;
		ВидОграниченияОборотов 					= ДанныеЗаполнения.ВидОграниченияОборотов;
		ВидОтклоненияКонтролируемыхЗначений 	= ДанныеЗаполнения.ВидОтклоненияКонтролируемыхЗначений;
		ДатаКонцаКонтролирующегоСценария 		= ДанныеЗаполнения.ДатаКонцаКонтролирующегоСценария;
		ДатаНачалаКонтролирующегоСценария 		= ДанныеЗаполнения.ДатаНачалаКонтролирующегоСценария;
		ИспользованиеКонтролируемыхЗначений 	= ДанныеЗаполнения.ИспользованиеКонтролируемыхЗначений;
		КонтролирующийСценарий 					= ДанныеЗаполнения.КонтролирующийСценарий;
		Организация 							= ДанныеЗаполнения.Организация;
		Отклонение 								= ДанныеЗаполнения.Отклонение;
		ИсправляемыйДокумент 					= ДанныеЗаполнения.Ссылка;
		Сценарий 								= ДанныеЗаполнения.Сценарий;
		ГраницыЗначений.Загрузить(ДанныеЗаполнения.ГраницыЗначений.Выгрузить());
		РазрезыКонтроля.Загрузить(ДанныеЗаполнения.РазрезыКонтроля.Выгрузить());
	КонецЕсли;
	фин_ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект,фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаРегламентированногоУчета"));
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ВидОграниченияОборотов = Перечисления.фин_ВидыОграниченийОборотовБюджета.ПредварительныйБюджет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КонтролирующийСценарий");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаКонтролирующегоСценария");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаКонцаКонтролирующегоСценария");
		МассивНепроверяемыхРеквизитов.Добавить("ВидОтклоненияКонтролируемыхЗначений");
	ИначеЕсли ВидОграниченияОборотов = Перечисления.фин_ВидыОграниченийОборотовБюджета.КонтролирующийСценарийВыборочно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаКонтролирующегоСценария");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаКонцаКонтролирующегоСценария");
		МассивНепроверяемыхРеквизитов.Добавить("ВидОтклоненияКонтролируемыхЗначений");
	КонецЕсли;
	Если ИспользованиеКонтролируемыхЗначений = Перечисления.фин_ИспользованиеКонтролируемыхЗначенийБюджетов.ПриИсполнении Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Сценарий");
	КонецЕсли;
	фин_ЗаполнениеДокументов.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ИспользованиеКонтролируемыхЗначений=Перечисления.фин_ИспользованиеКонтролируемыхЗначенийБюджетов.ПриИсполнении И фин_ОбщегоНазначенияВызовСервераПовтИсп.ИмеютсяЛимитыНаИсполнение()= Ложь Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
КонецПроцедуры

#КонецЕсли
