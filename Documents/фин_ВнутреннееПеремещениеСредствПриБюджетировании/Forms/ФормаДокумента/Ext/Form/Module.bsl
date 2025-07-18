﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.ДокументПриСозданииНаСервере(ЭтотОбъект);
	
	ПодготовитьФормуНаСервере();
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.ДокументПриЧтенииНаСервере(ЭтотОбъект,ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_фин_ВнутреннееПеремещениеСредствПриБюджетировании", ПараметрыЗаписи, Объект.Ссылка);	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	общ_ОбщегоНазначенияКлиент.ОбработкаОповещенияФормыДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	СценарийПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ФинансовыйПоказательПриИзменении(Элемент)
	ФинансовыйПоказательПриИзмененииНаСервере()	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаИсточникПриИзменении(Элемент)
	Если Объект.ВалютаИсточник <> СтараяВалютаИсточник Тогда
		ОписаниеОбработкаИзмененияВалюты = Новый ОписаниеОповещения("ОбработкаИзмененияВалюты",ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОбработкаИзмененияВалюты,"Изменилась валюта источника. Пересчитать сумму источника?",РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаИзмененияВалюты(Ответ,ДополнительныеПараметры) Экспорт
	// Надо предложить пересчитать сумму.
	ВалютаИсточникПриИзмененииНаСервере(Ответ = КодВозвратаДиалога.Да);
	СтараяВалютаИсточник=Объект.ВалютаИсточник;
	СформироватьНадписьСуммыПриемник();
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриемникПриИзменении(Элемент)
	ВалютаПриемникПриИзмененииНаСервере();
	//ОбновитьКурсыДокумента();
	СформироватьНадписьСуммыПриемник();	

КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	СформироватьНадписьСуммыПриемник();
КонецПроцедуры

&НаКлиенте
Процедура НадписьПериодПланированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораПериодаПланирования",ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.фин_ВыборБюджетногоПериода",Новый Структура("НачалоПериодаПланирования,КонецПериодаПланирования,Периодичность,РазрешитьПроизвольныйПериод",Объект.ПериодПланирования,ГоризонтПланирования,Объект.Сценарий,Ложь),ЭтотОбъект,УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно,,ОписаниеОповещения);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПараметрыИсточника


&НаКлиенте
Процедура ПараметрыИсточникаИзмерениеПриИзменении(Элемент)
	ИзмерениеПриИзменении(Элементы.ПараметрыИсточника)	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыИсточникаИзмерениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ДанныеВыбора = ИзмерениеНачалоВыбораИзСписка();
	//Элементы.ПараметрыИсточникаИзмерение.СписокВыбора.
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПараметрыПриемника

&НаКлиенте
Процедура ПараметрыПриемникаИзмерениеПриИзменении(Элемент)
	ИзмерениеПриИзменении(Элементы.ПараметрыПриемника);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПриемникаИзмерениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ДанныеВыбора = ИзмерениеНачалоВыбораИзСписка();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьПризнакОтображенияСтруктурныхПодразделений();
		
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Состояние = фин_БюджетированиеОбщегоНазначения.СостояниеОбъектаПоУмолчанию();
		
		Если НЕ (ЗначениеЗаполнено(Параметры.ЗначениеКопирования) ИЛИ ЗначениеЗаполнено(Параметры.Основание)) Тогда
			// по умолчанию при распределении учитываются все возможные показатели
			Если Объект.Сценарий.Пустая() Тогда
				ОсновнойСценарий 		= фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_ОсновнойСценарийПланирования");
				Объект.Сценарий = ОсновнойСценарий;
				Объект.ПериодПланирования=ТекущаяДата();
				Объект.ВалютаИсточник=фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаУправленческогоУчета");
				Объект.ВалютаПриемник=фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаУправленческогоУчета");
			Иначе
				Объект.ВалютаИсточник=Объект.Сценарий.Валюта;
				Объект.ВалютаПриемник=Объект.Сценарий.Валюта;
				Если Объект.ПериодПланирования='00010101' Тогда
					Объект.ПериодПланирования=фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.ДатаНачалаПериода(ТекущаяДата(),фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьПериодичностьСценария(Объект.Сценарий));
				КонецЕсли;
			КонецЕсли;	
			Если фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию("УчетПоВсемОрганизациям") Тогда
				Объект.Организация = фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
			КонецЕсли;

		КонецЕсли;
		Документы.фин_ВнутреннееПеремещениеСредствПриБюджетировании.ОбновитьКурсыДокумента(Объект);
		
	КонецЕсли;
	
	СформироватьНадписьСуммыПриемник();
	СтараяВалютаИсточник = Объект.ВалютаИсточник;
	фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.УстановитьГоризонтПланированияИПредставлениеБюджетногоПериода(НадписьПериодПланирования,ГоризонтПланирования,Объект.ПериодПланирования,Объект.Сценарий);
	
	// обработка доступности формы на основании данных согласования документов
	усд_УправлениеСогласованиемДокументов.ДоступностьРедактированияДокумента(ЭтотОбъект,Объект);
	
	оф_Источник = "Источник";
	оф_Приемник = "Приемник";
	
//	ТекущийДокументОснование = Объект.ДокументОснование;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если ПолеОбъекта(Объект.ФинансовыйПоказатель,"УчетПоСумме") Тогда
		Элементы.Сумма.Доступность			= Истина;
		Элементы.ВалютаИсточник.Доступность	= Истина;
		Элементы.ВалютаПриемник.Доступность	= Истина;
	Иначе
		Элементы.Сумма.Доступность			= Ложь;
		Элементы.ВалютаИсточник.Доступность	= Ложь;
		Элементы.ВалютаПриемник.Доступность	= Ложь;
	КонецЕсли;
	Если ПолеОбъекта(Объект.ФинансовыйПоказатель,"УчетПоКоличеству") Тогда
		Элементы.КоличествоИсточник.Доступность			= Истина;
		Элементы.КоличествоПриемник.Доступность			= Истина;
	Иначе
		Элементы.КоличествоИсточник.Доступность			= Ложь;
		Элементы.КоличествоПриемник.Доступность			= Ложь;
	КонецЕсли;
	
	Элементы.Организация.Видимость = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("БюджетированиеПоОрганизациям");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолеОбъекта(ОбъектДанных,Поле)
	Возврат ОбъектДанных[Поле];	
КонецФункции


// Формирует информационную надпись суммы сценария
//
// Параметры: нет
//
&НаСервере
Процедура СформироватьНадписьСуммыПриемник()
	СуммаПриемник=фин_ОбщегоНазначенияКлиентСервер.ПересчитатьИзВалютыВВалюту(Объект.Сумма, Объект.ВалютаИсточник, Объект.ВалютаПриемник, Объект.КурсИсточник, Объект.КурсПриемник, 
	               Объект.КратностьИсточник, Объект.КратностьПриемник);
	НадписьСуммаПриемник="Сумма приемника: "+СуммаПриемник+" "+Объект.ВалютаПриемник;
	//Элементы.НадписьСуммаПриемник.Заголовок=НадписьСуммаПриемник;
	НадписьВалютаИсточник=Объект.ВалютаИсточник.Наименование;
КонецПроцедуры //СформироватьНадписьСуммыПриемник

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ РАБОТЫ С ПЛАНОВЫМ ПЕРИОДОМ

&НаСервере
Процедура СценарийПриИзмененииНаСервере()
	Если НЕ Объект.Сценарий.Пустая() Тогда
		Объект.ПериодПланирования=фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.ДатаНачалаПериода(Объект.ПериодПланирования,фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьПериодичностьСценария(Объект.Сценарий));
		УстановитьЗначениеРеквизитовПоУмолчанию(Объект.ВалютаИсточник,Объект.Сценарий.Валюта);
		УстановитьЗначениеРеквизитовПоУмолчанию(Объект.ВалютаПриемник,Объект.Сценарий.Валюта);
	Иначе
		УстановитьЗначениеРеквизитовПоУмолчанию(Объект.ВалютаИсточник,фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаУправленческогоУчета"));
		УстановитьЗначениеРеквизитовПоУмолчанию(Объект.ВалютаПриемник,фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаУправленческогоУчета"));
	КонецЕсли;
	СтараяВалютаИсточник=Объект.ВалютаИсточник;
	УправлениеФормой(ЭтотОбъект);
	Документы.фин_ВнутреннееПеремещениеСредствПриБюджетировании.ОбновитьКурсыДокумента(Объект);
	
	СформироватьНадписьСуммыПриемник();
	ДетализацияПланирования = фин_ОбщегоНазначенияВызовСервераПовтИсп.ДетализацияПланирования(Объект.Сценарий);
	
	Если (НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.ЭтоУТ3()) И ДетализацияПланирования=фин_ОбщегоНазначенияВызовСервераПовтИсп.ДетализацияПланированияНоменклатурныеГруппы() 
		И НЕ ТипЗнч(Объект.НоменклатураИсточник)=фин_ОбщегоНазначенияВызовСервераПовтИсп.ТипНоменклатурныеГруппыСсылка() Тогда
		Объект.НоменклатураИсточник=Новый(фин_ОбщегоНазначенияВызовСервераПовтИсп.ТипНоменклатурныеГруппыСсылка());
	ИначеЕсли НЕ ТипЗнч(Объект.НоменклатураИсточник)=Тип("СправочникСсылка.Номенклатура") Тогда
		Объект.НоменклатураИсточник=Новый(Тип("СправочникСсылка.Номенклатура"));
	КонецЕсли;
	
	Если (НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.ЭтоУТ3()) И ДетализацияПланирования=фин_ОбщегоНазначенияВызовСервераПовтИсп.ДетализацияПланированияНоменклатурныеГруппы() 
		И НЕ ТипЗнч(Объект.НоменклатураПриемник)=фин_ОбщегоНазначенияВызовСервераПовтИсп.ТипНоменклатурныеГруппыСсылка() Тогда
		Объект.НоменклатураПриемник=Новый(фин_ОбщегоНазначенияВызовСервераПовтИсп.ТипНоменклатурныеГруппыСсылка());
	ИначеЕсли НЕ ТипЗнч(Объект.НоменклатураПриемник)=Тип("СправочникСсылка.Номенклатура") Тогда
		Объект.НоменклатураПриемник=Новый(Тип("СправочникСсылка.Номенклатура"));
	КонецЕсли;
	фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.УстановитьГоризонтПланированияИПредставлениеБюджетногоПериода(НадписьПериодПланирования,ГоризонтПланирования,Объект.ПериодПланирования,Объект.Сценарий);
	
КонецПроцедуры

// Устанавливает значение реквизита указанным для выбранного элемента справочника
// "СтатьиОборотов" значением по умолчанию.
//
// Параметры
//  Объект  – реквизит документа, для которого устанавливается значение.
//  Значение - значение по умолчанию
//
&НаСервере
Процедура УстановитьЗначениеРеквизитовПоУмолчанию(Объект,Значение)
	Если Объект=Неопределено ИЛИ Объект.Пустая() Тогда
        Если ТипЗнч(Объект)=ТипЗнч(Значение) ИЛИ ТипЗнч(Значение) = Тип("СправочникСсылка.Номенклатура")
             ИЛИ (НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.ЭтоУТ3() И ТипЗнч(Значение) = фин_ОбщегоНазначенияВызовСервераПовтИсп.ТипНоменклатурныеГруппыСсылка()) Тогда
			Объект=Значение;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры //УстановитьЗначениеРеквизитовПоУмолчанию

&НаСервере
Процедура ФинансовыйПоказательПриИзмененииНаСервере()
	Если НЕ Объект.ФинансовыйПоказатель.ОсновнаяВалюта.Пустая() Тогда
		УстановитьЗначениеРеквизитовПоУмолчанию(Объект.ВалютаИсточник,Объект.ФинансовыйПоказатель.ОсновнаяВалюта);
	Иначе
		УстановитьЗначениеРеквизитовПоУмолчанию(Объект.ВалютаИсточник,Объект.Сценарий.Валюта);
	КонецЕсли;
	УстановитьЗначениеРеквизитовПоУмолчанию(Объект.ВалютаПриемник,Объект.Сценарий.Валюта);
	Документы.фин_ВнутреннееПеремещениеСредствПриБюджетировании.ОбновитьКурсыДокумента(Объект);
	СформироватьНадписьСуммыПриемник();
    Если НЕ Объект.ФинансовыйПоказатель.УчетПоСумме Тогда
        Объект.Сумма=0;
		Объект.ВалютаИсточник=ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
		Объект.ВалютаПриемник=ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
	КонецЕсли;
	Если НЕ Объект.ФинансовыйПоказатель.УчетПоКоличеству Тогда
		Объект.КоличествоИсточник=0;
		Объект.КоличествоПриемник=0;
	КонецЕсли;
	СтараяВалютаИсточник=Объект.ВалютаИсточник;
	УправлениеФормой(ЭтотОбъект);
	СтрокиУдалить = Новый Массив;
	Для Каждого СтрокаОбласть Из Объект.ПараметрыИсточника Цикл
		Если СтрокаОбласть.Измерение=ПредопределенноеЗначение("Перечисление.фин_ФактическиеПоказателиБюджетирования.Проект") ИЛИ СтрокаОбласть.Измерение=ПредопределенноеЗначение("Перечисление.фин_ФактическиеПоказателиБюджетирования.УправленческоеПодразделение") Тогда
			Продолжить;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ФинансовыйПоказатель) Тогда
			СтрокиУдалить.Добавить(СтрокаОбласть);
		ИначеЕсли Объект.ФинансовыйПоказатель.РазрезыУчета.НайтиСтроки(Новый Структура("Измерение",СтрокаОбласть.Измерение)).Количество()=0 Тогда
			СтрокиУдалить.Добавить(СтрокаОбласть);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаУдалить Из СтрокиУдалить Цикл
		Объект.ПараметрыИсточника.Удалить(СтрокаУдалить);
	КонецЦикла;
	
	СтрокиУдалить = Новый Массив;
	Для Каждого СтрокаОбласть Из Объект.ПараметрыПриемника Цикл
		Если СтрокаОбласть.Измерение=ПредопределенноеЗначение("Перечисление.фин_ФактическиеПоказателиБюджетирования.Проект") ИЛИ СтрокаОбласть.Измерение=ПредопределенноеЗначение("Перечисление.фин_ФактическиеПоказателиБюджетирования.УправленческоеПодразделение") Тогда
			Продолжить;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.ФинансовыйПоказатель) Тогда
			СтрокиУдалить.Добавить(СтрокаОбласть);
		ИначеЕсли Объект.ФинансовыйПоказатель.РазрезыУчета.НайтиСтроки(Новый Структура("Измерение",СтрокаОбласть.Измерение)).Количество()=0 Тогда
			СтрокиУдалить.Добавить(СтрокаОбласть);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаУдалить Из СтрокиУдалить Цикл
		Объект.ПараметрыПриемника.Удалить(СтрокаУдалить);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ВалютаИсточникПриИзмененииНаСервере(Разрешен)
	Если (НЕ Объект.Сумма=0 И Разрешен) Тогда
		Документы.фин_ВнутреннееПеремещениеСредствПриБюджетировании.ОбновитьКурсыИСуммуДокумента(Объект,СтараяВалютаИсточник);
	Иначе
		Документы.фин_ВнутреннееПеремещениеСредствПриБюджетировании.ОбновитьКурсыДокумента(Объект);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ВалютаПриемникПриИзмененииНаСервере()
	Документы.фин_ВнутреннееПеремещениеСредствПриБюджетировании.ОбновитьКурсыДокумента(Объект);
КонецПроцедуры

&НаКлиенте
Процедура ИзмерениеПриИзменении(Элемент)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные.Измерение.Пустая() Тогда
		ТекущиеДанные.Разрез = "";
		Возврат;
	Иначе 
		ТекущиеДанные.Разрез = фин_РаботаСДополнительнымиРазрезамиБюджетирования.РазрезПоИзмерению(ТекущиеДанные.Измерение);
		//ТекущиеДанные.Значение = ТекущиеДанные.Разрез.ТипЗначения.ПривестиЗначение(ТекущиеДанные.Значение);
		ТекущиеДанные.Значение = ПривестиЗначениеРазреза(ТекущиеДанные.Разрез,ТекущиеДанные.Значение);
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИзмерениеНачалоВыбораИзСписка()
	СписокВыбора = Новый СписокЗначений;
	СписокРазрезов = Новый СписокЗначений;
	СписокРазрезов.Добавить(ПредопределенноеЗначение("Перечисление.фин_ФактическиеПоказателиБюджетирования.УправленческоеПодразделение"));
	СписокРазрезов.Добавить(ПредопределенноеЗначение("Перечисление.фин_ФактическиеПоказателиБюджетирования.Проект"));
	Если ЗначениеЗаполнено(Объект.ФинансовыйПоказатель) Тогда
		Для Каждого РазрезУчета Из Объект.ФинансовыйПоказатель.РазрезыУчета Цикл
			СписокРазрезов.Добавить(РазрезУчета.Измерение);
		КонецЦикла;
	КонецЕсли;
	Для Каждого РазрезЭлемент Из СписокРазрезов Цикл
		СписокВыбора.Добавить(РазрезЭлемент.Значение,фин_РаботаСДополнительнымиРазрезамиБюджетирования.ПредставлениеРазреза(РазрезЭлемент.Значение));
	КонецЦикла;
    Возврат СписокВыбора;

КонецФункции

&НаСервереБезКонтекста
Функция ПривестиЗначениеРазреза(Разрез, Значение)
	Если ЗначениеЗаполнено(Разрез) Тогда
		Возврат Разрез.ТипЗначения.ПривестиЗначение(Значение)
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции


&НаКлиенте
Процедура ОбработкаВыбораПериодаПланирования(РезультатВыбора,ДополнительныеПараметры) Экспорт
	Если РезультатВыбора<>Неопределено Тогда
		Модифицированность=Истина;
		Объект.ПериодПланирования = РезультатВыбора.НачалоПериода;
		фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.УстановитьГоризонтПланированияИПредставлениеБюджетногоПериода(НадписьПериодПланирования,ГоризонтПланирования,Объект.ПериодПланирования,Объект.Сценарий);
	КонецЕсли;
КонецПроцедуры
