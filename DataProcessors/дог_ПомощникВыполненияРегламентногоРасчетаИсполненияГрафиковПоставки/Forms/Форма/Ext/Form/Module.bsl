﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе 
		Результат = общ_РаботаСоСтруктурнымиПодразделениями.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаКлиенте(Истина, Результат);
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	общ_РаботаСоСтруктурнымиПодразделениями.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПериодов = ПолучитьСписокПериодов(Объект.ПериодРасчета);
	Если СписокПериодов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыбораИзСписка = Новый Структура("ПредставлениеПериода", Элементы.ПредставлениеПериода);
	ОписаниеВыбора = Новый ОписаниеОповещения("ВыбратьПериодПланирования", ЭтаФорма, ПараметрыВыбораИзСписка);
	ПоказатьВыборИзСписка(ОписаниеВыбора,СписокПериодов, Элементы.ПредставлениеПериода, СписокПериодов[0]);
	
	//ВыбратьПериодПланирования(Объект.ПериодРасчета);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьАктуализацию(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Организация""!'"), , "СтруктурноеПодразделениеОрганизация", "");
		Возврат;
	КонецЕсли;
	ВыполнитьАктуализациюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВыбрать(Команда)
	
	ОписаниеВыбораДаты = Новый ОписаниеОповещения("ПослеЗакрытияПериодВыбрать", ЭтаФорма);
	ПоказатьВводДаты(ОписаниеВыбораДаты, НачалоМесяца(Объект.ПериодРасчета), "Выберите месяц", ЧастиДаты.Дата);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаКлиенте(ОчищатьНекорректныеЗначения, Параметры)

	Параметры.Вставить("ОчищатьНекорректныеЗначения", ОчищатьНекорректныеЗначения);
	
	СтруктураРезультатаВыполнения = Неопределено;
	СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(Параметры, СтруктураРезультатаВыполнения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	общ_РаботаСоСтруктурнымиПодразделениями.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
		СтруктурноеПодразделениеОрганизацияПриИзмененииНаКлиенте(Истина, Результат);
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено, СтруктураРезультатаВыполнения)
	
	Если СтруктураПараметров = Неопределено	ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
				И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		общ_РаботаСоСтруктурнымиПодразделениями.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
		
	ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;
	
	общ_РаботаСоСтруктурнымиПодразделениями.ПриИзмененииЗначенияОрганизации(Объект, , СтруктураРезультатаВыполнения);
	
	УправлениеФормой(ЭтаФорма);
			
КонецПроцедуры

&НаСервере
Процедура ВыполнитьАктуализациюСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЕстьОбщееЗакрытие = Ложь;
	Для Каждого СтрокаДокумент Из Объект.АктуализируемыеДанные Цикл
		Если СтрокаДокумент.Документ.Контрагент.Пустая() И СтрокаДокумент.Документ.ДоговорКонтрагента.Пустая() Тогда
			ЕстьОбщееЗакрытие = Истина;
		КонецЕсли;
		Попытка
			СтрокаДокумент.Документ.ПолучитьОбъект().Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось обновить данные по документу: '") + Строка(СтрокаДокумент.Документ));
		КонецПопытки;
	КонецЦикла;
	
	Если НЕ ЕстьОбщееЗакрытие Тогда
		НовыйДокумент = Документы.дог_РегламентныйРасчетИсполненияГрафиковПоставки.СоздатьДокумент();
		НовыйДокумент.Организация = Объект.Организация;
		НовыйДокумент.СтруктурноеПодразделение = Объект.СтруктурноеПодразделение;
		НовыйДокумент.Дата = КонецМесяца(Объект.ПериодРасчета);
		НовыйДокумент.УстановитьНовыйНомер();
		Попытка
			НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
			СтрокаТЧ = Объект.АктуализируемыеДанные.Добавить();
			СтрокаТЧ.Документ = НовыйДокумент.Ссылка;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось выполнить операцию: '") + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дог_РегламентныйРасчетИсполненияГрафиковПоставки.Ссылка КАК Документ
		|ИЗ
		|	Документ.дог_РегламентныйРасчетИсполненияГрафиковПоставки КАК дог_РегламентныйРасчетИсполненияГрафиковПоставки
		|ГДЕ
		|	дог_РегламентныйРасчетИсполненияГрафиковПоставки.Организация = &Организация
		|	И дог_РегламентныйРасчетИсполненияГрафиковПоставки.СтруктурноеПодразделение = &СтруктурноеПодразделение
		|	И НАЧАЛОПЕРИОДА(дог_РегламентныйРасчетИсполненияГрафиковПоставки.Дата, МЕСЯЦ) = &Дата
		|	И дог_РегламентныйРасчетИсполненияГрафиковПоставки.Проведен";

	Запрос.УстановитьПараметр("Организация", 				Объект.Организация);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", 	Объект.СтруктурноеПодразделение);
	Запрос.УстановитьПараметр("Дата", 				НачалоМесяца(Объект.ПериодРасчета));

	Результат = Запрос.Выполнить();

	Объект.АктуализируемыеДанные.Загрузить(Результат.Выгрузить());

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодПланирования(Результат, ВходящиеПараметры) Экспорт 
	
	Если Результат<>Неопределено Тогда
		Если ТипЗнч(Результат.Значение) = Тип("Число") Тогда
			//ВыбратьПериодПланирования(Дата(Результат.Значение, 1, 1), "");
			ПериодРасчета = Дата(Результат.Значение, 1, 1);
			СписокПериодов = ПолучитьСписокПериодов(ПериодРасчета);
			Если СписокПериодов.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
	
			ПараметрыВыбораИзСписка = Новый Структура("ПредставлениеПериода", ВходящиеПараметры.ПредставлениеПериода);
			ОписаниеВыбора = Новый ОписаниеОповещения("ВыбратьПериодПланирования", ЭтаФорма, ПараметрыВыбораИзСписка);
			ПоказатьВыборИзСписка(ОписаниеВыбора, СписокПериодов, ВходящиеПараметры.ПредставлениеПериода, СписокПериодов[0]);			
		Иначе
			Объект.ПериодРасчета = Результат.Значение;
			УправлениеФормой(ЭтаФорма);
			ЗаполнитьНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокПериодов(ПериодПланирования)
	Возврат фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.ПолучитьПериодыДляВыбора(ПериодПланирования, Перечисления.фин_Периодичность.Месяц);	
КонецФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Объект.Организация = фин_ОбщегоНазначенияСервер.ПолучитьЗначениеПоУмолчанию(ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	
	Для Каждого Реквизит Из Метаданные.Обработки.дог_АктуализацияДанныхПоИсполнениюДоговоров.Реквизиты Цикл
		Если Параметры.Свойство(Реквизит.Имя) Тогда
			Объект[Реквизит.Имя] = Параметры[Реквизит.Имя];
		КонецЕсли;
	КонецЦикла;
	Объект.ПериодРасчета = НачалоМесяца(ТекущаяДата());
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьПризнакОтображенияСтруктурныхПодразделений();
			
	общ_РаботаСоСтруктурнымиПодразделениями.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	общ_РаботаСоСтруктурнымиПодразделениями.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
		
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;	
	Форма.ПредставлениеПериода = Формат(Объект.ПериодРасчета, "ДФ='ММММ гггг'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПериодВыбрать(Результат, ВходящиеПараметры) Экспорт
	
	Если НЕ Результат = Неопределено Тогда
		Объект.ПериодРасчета = НачалоМесяца(Результат);
		УправлениеФормой(ЭтаФорма);
		ЗаполнитьНаСервере();		
	КонецЕсли;
	
КонецПроцедуры