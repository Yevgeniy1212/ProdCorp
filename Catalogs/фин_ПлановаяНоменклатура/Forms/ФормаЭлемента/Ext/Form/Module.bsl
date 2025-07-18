﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически();
	Если СокрЛП(Объект.НаименованиеПолное)<>"" Тогда
		СписокВыбораНаименований.Добавить(Объект.НаименованиеПолное);
	КонецЕсли;
	мТипПозиции = Объект.ТипПозицииВПланеЗакупок;
	Если Объект.Ссылка.Пустая() И Объект.ТипПозицииВПланеЗакупок.Пустая() Тогда
		 Объект.ТипПозицииВПланеЗакупок = Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.Товар;
	КонецЕсли;
	УстановитьВидимость();
    Если Метаданные.РегистрыСведений.Найти("узп_СоответствиеВнеоборотныхАктивовПлановойНоменклатуре")<>Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СоответствиеВнеоборотныхАктивовПлановойНоменклатуре.ВнеоборотныйАктив КАК ОСНМА,
			|	СоответствиеВнеоборотныхАктивовПлановойНоменклатуре.ХарактеристикаПлановойНоменклатуры КАК Характеристика
			|ИЗ
			|	РегистрСведений.узп_СоответствиеВнеоборотныхАктивовПлановойНоменклатуре КАК СоответствиеВнеоборотныхАктивовПлановойНоменклатуре
			|ГДЕ
			|	СоответствиеВнеоборотныхАктивовПлановойНоменклатуре.ПлановаяНоменклатура = &ПлановаяНоменклатура";

		Запрос.УстановитьПараметр("ПлановаяНоменклатура", Объект.Ссылка);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	        НС = СоответствиеОС.Добавить();
			ЗаполнитьЗначенияСвойств(НС,ВыборкаДетальныеЗаписи);
		КонецЦикла;
	КонецЕсли;
	
    Если Метаданные.РегистрыСведений.Найти("узп_СоответствиеПлановойИРегламентированнойНоменклатуры")<>Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СоответствиеНоменклатуры.РегламентированнаяНоменклатура,
			|	СоответствиеНоменклатуры.ХарактеристикаПлановойНоменклатуры КАК Характеристика
			|ИЗ
			|	РегистрСведений.узп_СоответствиеПлановойИРегламентированнойНоменклатуры.СрезПоследних КАК СоответствиеНоменклатуры
			|ГДЕ
			|	СоответствиеНоменклатуры.ПлановаяНоменклатура = &ПлановаяНоменклатура";

		Запрос.УстановитьПараметр("ПлановаяНоменклатура", Объект.Ссылка);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	        НС = СоответствиеРегламентированнойНоменклатуре.Добавить();
			ЗаполнитьЗначенияСвойств(НС,ВыборкаДетальныеЗаписи);
		КонецЦикла;
	КонецЕсли;
    НадписьДополнительно = "Дополнительно";
	НадписьОсновное = "Основное";
	НадписьСоответствиеФактическимДанным = "Соответствие фактическим данным";
	Элементы.СоответствиеРегламентированнойНоменклатуреХарактеристика.Видимость = НЕ Метаданные.РегистрыСведений.узп_СоответствиеПлановойИРегламентированнойНоменклатуры.Ресурсы.ХарактеристикаПлановойНоменклатуры.Тип.СодержитТип(Тип("Строка"));
	Элементы.ОсновнойПоставщик.Видимость = Метаданные.Документы.Найти("узп_ПланЗакупок")<>Неопределено;
	Элементы.НоменклатурнаяГруппа.Видимость = НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.РежимИнтеграции()=Перечисления.фин_РежимыИнтеграцииСУчетнойСистемой.УправлениеТорговлейДляКазахстана_3;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	Элементы.СоответствиеОС.Видимость= (Метаданные.РегистрыСведений.Найти("узп_СоответствиеВнеоборотныхАктивовПлановойНоменклатуре")<>Неопределено) И (Объект.ТипПозицииВПланеЗакупок=Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.НематериальныйАктив 
										ИЛИ Объект.ТипПозицииВПланеЗакупок=Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.ОсновноеСредство);
	Элементы.СоответствиеРегламентированнойНоменклатуре.Видимость=(Метаданные.РегистрыСведений.Найти("узп_СоответствиеПлановойИРегламентированнойНоменклатуры")<>Неопределено) И (Объект.ТипПозицииВПланеЗакупок=Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.Услуга 
										ИЛИ Объект.ТипПозицииВПланеЗакупок=Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.Товар);
	Элементы.НадписьСоответствиеФактическимДанным.Видимость = Элементы.СоответствиеОС.Видимость ИЛИ Элементы.СоответствиеРегламентированнойНоменклатуре.Видимость;
КонецПроцедуры

// Процедура проверяет, совпадало ли ранее полное наименование с наименованием,
// и присваивает соответствующее значение переменной мФормироватьНаименованиеПолноеАвтоматически.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

	Если ПустаяСтрока(Объект.НаименованиеПолное) 
	 ИЛИ Объект.НаименованиеПолное = Объект.Наименование Тогда
		мФормироватьНаименованиеПолноеАвтоматически = Истина;

	Иначе
		мФормироватьНаименованиеПолноеАвтоматически = Ложь;

	КонецЕсли;

КонецПроцедуры // УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

// Процедура проверяет, необходимо ли формировать полное наименование автоматически или нет,
// и, если необходимо, формирует его.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СформироватьНаименованиеПолноеАвтоматически()

	Если мФормироватьНаименованиеПолноеАвтоматически Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;

КонецПроцедуры // СформироватьНаименованиеПолноеАвтоматически()


&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если СокрЛП(Объект.НаименованиеПолное)<>"" И СписокВыбораНаименований.НайтиПоЗначению(Объект.НаименованиеПолное)=Неопределено Тогда
		СписокВыбораНаименований.Добавить(Объект.НаименованиеПолное);
	КонецЕсли;
	СформироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры


&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокВыбораНаименований;
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеОСОСНМАНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.ТипПозицииВПланеЗакупок=ПредопределенноеЗначение("Перечисление.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.НематериальныйАктив") Тогда
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы");
	Иначе
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ОсновныеСредства");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеРегламентированнойНоменклатуреНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",Новый Структура("Отбор",Новый Структура("Услуга",Объект.ТипПозицииВПланеЗакупок=ПредопределенноеЗначение("Перечисление.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.Услуга"))),Элемент,УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ТипПозицииВПланеЗакупокПриИзменении(Элемент)
	Если мТипПозиции <> Объект.ТипПозицииВПланеЗакупок Тогда
		СоответствиеОС.Очистить();
		СоответствиеРегламентированнойНоменклатуре.Очистить();
		мТипПозиции = Объект.ТипПозицииВПланеЗакупок;
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	ОткрытьФорму("РегистрСведений.узп_СоответствиеПлановойИРегламентированнойНоменклатуры.Форма.ФормаИстории",Новый Структура("ПлановаяНоменклатура",Объект.Ссылка),ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Метаданные.РегистрыСведений.Найти("узп_СоответствиеВнеоборотныхАктивовПлановойНоменклатуре")=Неопределено Тогда
		Возврат;
	КонецЕсли;
	НачатьТранзакцию();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоответствиеВнеоборотныхАктивовПлановойНоменклатуре.ВнеоборотныйАктив
		|ИЗ
		|	РегистрСведений.узп_СоответствиеВнеоборотныхАктивовПлановойНоменклатуре КАК СоответствиеВнеоборотныхАктивовПлановойНоменклатуре
		|ГДЕ
		|	СоответствиеВнеоборотныхАктивовПлановойНоменклатуре.ПлановаяНоменклатура = &ПлановаяНоменклатура";

	Запрос.УстановитьПараметр("ПлановаяНоменклатура", Объект.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.узп_СоответствиеВнеоборотныхАктивовПлановойНоменклатуре.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВнеоборотныйАктив.Установить(ВыборкаДетальныеЗаписи.ВнеоборотныйАктив);
		НаборЗаписей.Очистить();
		Попытка
			НаборЗаписей.Записать();
		Исключение
			Сообщить("Возникла ошибка при записи соответствий внеобортным активам!");
			Отказ = Истина;
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки;
	КонецЦикла;

	Для Каждого СтрокаСоответствия Из СоответствиеОС Цикл
		НаборЗаписей = РегистрыСведений.узп_СоответствиеВнеоборотныхАктивовПлановойНоменклатуре.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВнеоборотныйАктив.Установить(СтрокаСоответствия.ОСНМА);
		НаборЗаписей.Очистить();
		НЗ = НаборЗаписей.Добавить();
		НЗ.ВнеоборотныйАктив =СтрокаСоответствия.ОСНМА;
		НЗ.ПлановаяНоменклатура = Объект.Ссылка;
		НЗ.ХарактеристикаПлановойНоменклатуры = СтрокаСоответствия.Характеристика;
		Попытка
			НаборЗаписей.Записать();
		Исключение
			Сообщить("Возникла ошибка при записи соответствий внеобортным активам!");
			Отказ = Истина;
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки;
	КонецЦикла;

	ЗафиксироватьТранзакцию();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьСоответствия();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСоответствия()
	СоответствиеРегламентированнойНоменклатуре.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоответствиеНоменклатуры.РегламентированнаяНоменклатура,
	|	СоответствиеНоменклатуры.ХарактеристикаПлановойНоменклатуры КАК Характеристика
	|ИЗ
	|	РегистрСведений.узп_СоответствиеПлановойИРегламентированнойНоменклатуры.СрезПоследних КАК СоответствиеНоменклатуры
	|ГДЕ
	|	СоответствиеНоменклатуры.ПлановаяНоменклатура = &ПлановаяНоменклатура";
	
	Запрос.УстановитьПараметр("ПлановаяНоменклатура", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НС = СоответствиеРегламентированнойНоменклатуре.Добавить();
		ЗаполнитьЗначенияСвойств(НС,ВыборкаДетальныеЗаписи);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПлановаяЕдиницаИзмеренияПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.БазоваяЕдиницаИзмерения) Тогда
		Объект.БазоваяЕдиницаИзмерения = Объект.ПлановаяЕдиницаИзмерения;
	КонецЕсли;
КонецПроцедуры


