﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.СправочникПриСозданииНаСервере(ЭтаФорма);
		
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)    // пример обработки внешнего оповещения
	
	Если ИмяСобытия = "ЗаполнениеГрафикаЗаново" Тогда
		Объект.ГрафикПлатежей.Очистить();
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаполнениеГрафикаЗаново" ИЛИ ИмяСобытия = "ЗаполнениеГрафика" Тогда
	 	Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			Для Каждого СтрокаТЧ Из Параметр Цикл
				ЗаполнитьЗначенияСвойств(Объект.ГрафикПлатежей.Добавить(),СтрокаТЧ);
			КонецЦикла;
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ДобавитьВГрафикСтрокиИзВыбранногоГрафика(ВыбранноеЗначение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ГрафикПлатежей>

&НаКлиенте
Процедура ГрафикПлатежейПорядокРасчетаДатыПлатежаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ГрафикПлатежей.ТекущиеДанные;
	Если ТекущаяСтрока.ПорядокРасчетаДатыПлатежа = ПредопределенноеЗначение("Перечисление.дог_ПорядкиРасчетаДатыПлатежа.ОтДатыСобытияПоДоговору") Тогда
		ТекущаяСтрока.ДатаОплаты = ПредопределенноеЗначение("Справочник.дог_СобытияПоДоговору.ПустаяСсылка");
	ИначеЕсли ТекущаяСтрока.ПорядокРасчетаДатыПлатежа = ПредопределенноеЗначение("Перечисление.дог_ПорядкиРасчетаДатыПлатежа.ФиксированнаяДата") Тогда
		ТекущаяСтрока.ДатаОплаты = Дата('00010101');
		ТекущаяСтрока.Сдвиг = 0;
		Если ТекущаяСтрока.СпособРасчетаСуммыПлатежа = ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.НаОснованииСобытия") Тогда
			ТекущаяСтрока.СпособРасчетаСуммыПлатежа = ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПоСуммеДоговора");
		КонецЕсли;
	Иначе
		ТекущаяСтрока.ДатаОплаты = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПлатежейСпособРасчетаСуммыПлатежа1ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ГрафикПлатежей.ТекущиеДанные;
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.СпособРасчетаСуммыПлатежа) Тогда
		ТекущиеДанные.МинимальнаяСуммаПлатежа = 0;
		ТекущиеДанные.Сумма = 0;
		ТекущиеДанные.ПроцентОтСуммы = 0;
		ТекущиеДанные.Сценарий = ПредопределенноеЗначение("Справочник.СценарииПланирования.ПустаяСсылка");
		ТекущиеДанные.ФинансовыйПоказательСценария = ПредопределенноеЗначение("Справочник.фин_ФинансовыеПоказатели.ПустаяСсылка");
		ТекущиеДанные.ДатаСценария = Дата('00010101');
	ИначеЕсли ТекущиеДанные.СпособРасчетаСуммыПлатежа = ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ФиксированнойСуммой") Тогда
		ТекущиеДанные.МинимальнаяСуммаПлатежа = 0;
		ТекущиеДанные.ПроцентОтСуммы = 0;
		ТекущиеДанные.Сценарий = ПредопределенноеЗначение("Справочник.СценарииПланирования.ПустаяСсылка");
		ТекущиеДанные.ФинансовыйПоказательСценария = ПредопределенноеЗначение("Справочник.фин_ФинансовыеПоказатели.ПустаяСсылка");
		ТекущиеДанные.ДатаСценария = Дата('00010101');
	ИначеЕсли ТекущиеДанные.СпособРасчетаСуммыПлатежа = ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПоСуммеДоговора")
		ИЛИ ТекущиеДанные.СпособРасчетаСуммыПлатежа = ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.НаОснованииСобытия") Тогда
		ТекущиеДанные.Сумма = 0;
		ТекущиеДанные.Сценарий = ПредопределенноеЗначение("Справочник.СценарииПланирования.ПустаяСсылка");
		ТекущиеДанные.ФинансовыйПоказательСценария = ПредопределенноеЗначение("Справочник.фин_ФинансовыеПоказатели.ПустаяСсылка");
		ТекущиеДанные.ДатаСценария = Дата('00010101');
   ИначеЕсли ТекущиеДанные.СпособРасчетаСуммыПлатежа = ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПлановаяСумма") Тогда
		ТекущиеДанные.Сумма = 0;
	Иначе //ПоЗадолженностиНаНачалоПериода,ЗадолженностьНаДатуПлатежа
		ТекущиеДанные.Сумма = 0;
		ТекущиеДанные.Сценарий = ПредопределенноеЗначение("Справочник.СценарииПланирования.ПустаяСсылка");
		ТекущиеДанные.ФинансовыйПоказательСценария = ПредопределенноеЗначение("Справочник.фин_ФинансовыеПоказатели.ПустаяСсылка");
		ТекущиеДанные.ДатаСценария = Дата('00010101');
    КонецЕсли;
	
	Если ТекущиеДанные.СпособРасчетаСуммыПлатежа <> ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПоЗадолженностиНаНачалоПериода") Тогда
		ТекущиеДанные.Периодичность = ПредопределенноеЗначение("Перечисление.фин_Периодичность.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПлатежейСценарийПриИзменении(Элемент)
	
	ПривестиДатуСценарияКНачалу();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПлатежейДатаСценарияПриИзменении(Элемент)
	
	ПривестиДатуСценарияКНачалу();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПлатежейСпособРасчетаСуммыПлатежа1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ГрафикПлатежей.ТекущиеДанные;
	Если ТекущиеДанные.ПорядокРасчетаДатыПлатежа = ПредопределенноеЗначение("Перечисление.дог_ПорядкиРасчетаДатыПлатежа.ФиксированнаяДата") Тогда
		СтандартнаяОбработка = Ложь;
		СписокСпособов = Новый СписокЗначений;
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ФиксированнойСуммой"));
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ЗадолженностьНаДатуПлатежа"));
		Если РасчетПлатежаПлановойСуммой Тогда
			СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПлановаяСумма"));
		КонецЕсли;
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПоЗадолженностиНаНачалоПериода"));
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПоСуммеДоговора"));
		ДанныеВыбора = СписокСпособов;
	ИначеЕсли НЕ РасчетПлатежаПлановойСуммой Тогда
		СтандартнаяОбработка = Ложь;
		СписокСпособов = Новый СписокЗначений;
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ФиксированнойСуммой"));
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ЗадолженностьНаДатуПлатежа"));
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.НаОснованииСобытия"));
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПоЗадолженностиНаНачалоПериода"));
		СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ПоСуммеДоговора"));
		ДанныеВыбора = СписокСпособов;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПлатежейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элементы.ГрафикПлатежей.ТекущиеДанные;
		ТекущиеДанные.СпособРасчетаСуммыПлатежа = ПредопределенноеЗначение("Перечисление.дог_СпособыРасчетаСуммыПлатежей.ФиксированнойСуммой");
		ТекущиеДанные.ПорядокРасчетаДатыПлатежа = ПредопределенноеЗначение("Перечисление.дог_ПорядкиРасчетаДатыПлатежа.ФиксированнаяДата");
		ТекущиеДанные.ДатаОплаты = '00010101';
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПлатежейЭтапОплатыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	МассивГрафикиПлатежей = Новый Массив;
	МассивГрафикиПлатежей.Добавить(Объект.Ссылка);
	МассивГрафикиПлатежей.Добавить(ПредопределенноеЗначение("Справочник.дог_ГрафикиОплатыПоДоговорам.ПустаяСсылка"));
	СтруктураПараметров = Новый Структура("Отбор",Новый Структура("ГрафикПлатежей",МассивГрафикиПлатежей));
	ОткрытьФорму("Справочник.дог_ЭтапыОплаты.ФормаВыбора",СтруктураПараметров,Элемент);
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

&НаКлиенте
Процедура Заполнить(Команда)
	
	ПараметрыОткрытия = Новый Структура("ЗаполнитьЗаново", Истина);
	ОткрытьФорму("Справочник.дог_ГрафикиОплатыПоДоговорам.Форма.ФормаЗаполненияГрафика", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПлатежиВГрафик(Команда)
	
	ПараметрыОткрытия = Новый Структура("ЗаполнитьЗаново", Ложь);
	ОткрытьФорму("Справочник.дог_ГрафикиОплатыПоДоговорам.Форма.ФормаЗаполненияГрафика", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзДругогоГрафика(Команда)

	ОткрытьФорму("Справочник.дог_ГрафикиОплатыПоДоговорам.ФормаВыбора", , ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЭтапыОплаты(Команда)
	
	ЗаполнитьЭтапыОплатыНаСервере();
	
КонецПроцедуры

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
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Объект.ГрафикПлатежей.Количество()>0 Тогда
			Для Каждого СтрокаГрафик Из Объект.ГрафикПлатежей Цикл
				Если ЗначениеЗаполнено(СтрокаГрафик.ЭтапОплаты) И ЗначениеЗаполнено(СтрокаГрафик.ЭтапОплаты.ГрафикПлатежей) Тогда
					СтрокаГрафик.ЭтапОплаты = Справочники.дог_ЭтапыОплаты.ПустаяСсылка();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	РасчетПлатежаПлановойСуммой = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("дог_ПоддержкаРасчетаГрафиковПлатежейПоБюджетам");
	
	ОписаниеТиповПериодичность = Новый ОписаниеТипов("ПеречислениеСсылка.фин_Периодичность");
	Элементы.ГрафикПлатежейПериодичность.ОграничениеТипа = ОписаниеТиповПериодичность;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВГрафикСтрокиИзВыбранногоГрафика(ВыбранныйГрафик)
	
	Для Каждого СтрокаТЧ Из ВыбранныйГрафик.ГрафикПлатежей Цикл
		ЗаполнитьЗначенияСвойств(Объект.ГрафикПлатежей.Добавить(),СтрокаТЧ);	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПривестиДатуСценарияКНачалу()
	
	ПривестиДатуСценарияКНачалуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПривестиДатуСценарияКНачалуНаСервере()
	
	ТекущиеДанные = Элементы.ГрафикПлатежей.ТекущиеДанные;
	ТекущиеДанные.ДатаСценария = фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.ДатаНачалаПериода(ТекущиеДанные.ДатаСценария,ТекущиеДанные.Сценарий);	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭтапыОплатыНаСервере()
	
	Если Объект.Ссылка.Пустая() Тогда
		мОбъект = РеквизитФормыВЗначение("Объект");
		мОбъект.ДополнительныеСвойства.Вставить("РежимСозданияЭтапов");
		Попытка
			Если мОбъект.ПроверитьЗаполнение() Тогда
				мОбъект.Записать();
				ЗначениеВРеквизитФормы(мОбъект, "Объект");
			Иначе
				Возврат;
			КонецЕсли;
		Исключение
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	ГруппаЭлементов = Справочники.дог_ЭтапыОплаты.ПустаяСсылка();

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дог_ЭтапыОплаты.Ссылка
		|ИЗ
		|	Справочник.дог_ЭтапыОплаты КАК дог_ЭтапыОплаты
		|ГДЕ
		|	дог_ЭтапыОплаты.ЭтоГруппа
		|	И НЕ дог_ЭтапыОплаты.ПометкаУдаления
		|	И дог_ЭтапыОплаты.ГрафикПлатежей = &ГрафикПлатежей";

	Запрос.УстановитьПараметр("ГрафикПлатежей", Объект.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ГруппаЭлементов =  ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		Если ЗначениеЗаполнено(Объект.Назначение) И ТипЗнч(Объект.Назначение)<>Тип("Строка") Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	дог_ЭтапыОплаты.Ссылка
				|ИЗ
				|	Справочник.дог_ЭтапыОплаты КАК дог_ЭтапыОплаты
				|ГДЕ
				|	дог_ЭтапыОплаты.ЭтоГруппа
				|	И НЕ дог_ЭтапыОплаты.ПометкаУдаления
				|	И дог_ЭтапыОплаты.Назначение = &Назначение";

			Запрос.УстановитьПараметр("Назначение", Объект.Назначение);

			Результат = Запрос.Выполнить();

			ВыборкаДетальныеЗаписи = Результат.Выбрать();

			Если ВыборкаДетальныеЗаписи.Следующий() Тогда
				ГруппаЭлементов =  ВыборкаДетальныеЗаписи.Ссылка;
			КонецЕсли;
		КонецЕсли;
		НоваяГруппа = Справочники.дог_ЭтапыОплаты.СоздатьГруппу();
		НоваяГруппа.ГрафикПлатежей = Объект.Ссылка;
		НоваяГруппа.Назначение = Объект.Назначение;
		НоваяГруппа.Родитель = ГруппаЭлементов;
		НоваяГруппа.Наименование = Объект.Наименование;
		НоваяГруппа.УстановитьНовыйКод();
		НоваяГруппа.Записать();
		ГруппаЭлементов = НоваяГруппа.Ссылка;
	КонецЕсли;
	Для Каждого СтрокаГрафик Из Объект.ГрафикПлатежей Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаГрафик.ЭтапОплаты) Тогда
			НовыйЭлемент = Справочники.дог_ЭтапыОплаты.СоздатьЭлемент();
			НовыйЭлемент.ГрафикПлатежей = Объект.Ссылка;
			НовыйЭлемент.Наименование = "Этап № "+Строка(СтрокаГрафик.НомерСтроки);
			НовыйЭлемент.Родитель = ГруппаЭлементов;
			НовыйЭлемент.УстановитьНовыйКод();
			НовыйЭлемент.Записать();
			СтрокаГрафик.ЭтапОплаты = НовыйЭлемент.Ссылка;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
