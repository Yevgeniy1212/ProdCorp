﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НадписьВидДокументов = "Вид документов";
	НадписьДополнительныеРеквизитыДляУчетаПервичныхДанныхВБюджетах = "Дополнительные реквизиты для учета первичных данных в бюджетах";
	НадписьОтражениеПервичныхДанныхВБюджетировании = "Отражение первичных данных в бюджетировании";
	мВидДокументов = Объект.ПрограммныйИдентификатор;
	Если ПравоДоступа("Просмотр",Метаданные.РегистрыСведений.фин_ПрименениеСхемОтраженияФактическихДанных) Тогда
		Элементы.ГруппаОтражениеФакта.Видимость = ОпределитьВозможностьРегистрацииФакта(Объект.ПрограммныйИдентификатор);
		Если (НЕ Объект.Ссылка.Пустая()) И ОпределитьВозможностьРегистрацииФакта(Объект.ПрограммныйИдентификатор) Тогда
			ПрочитатьШаблонПроводок();
			Если Объект.ПрограммныйИдентификатор <> "" И Метаданные.Документы[Объект.ПрограммныйИдентификатор].Движения.Содержит(Метаданные.РегистрыНакопления[фин_ОбщегоНазначенияВызовСервераПовтИсп.РегистрФактическихДанныхДляДокумента(Объект.ПрограммныйИдентификатор).ИмяРегистра]) Тогда
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
				|	ОборотыБюджетов.Регистратор
				|ИЗ
				|	РегистрНакопления."+фин_ОбщегоНазначенияВызовСервераПовтИсп.РегистрФактическихДанныхДляДокумента(Объект.ПрограммныйИдентификатор).ИмяРегистра+" КАК ОборотыБюджетов
				|ГДЕ
				|	ОборотыБюджетов.Регистратор ССЫЛКА Документ."+Объект.ПрограммныйИдентификатор;
				РезультатЗапроса = Запрос.Выполнить();
				Если (НЕ РезультатЗапроса.Пустой()) И Объект.ИспользоватьДополнительныеРеквизиты Тогда
					//Элементы.ИспользоватьДополнительныеРеквизиты.Доступность 			= Ложь;
					Элементы.РегистрироватьПервичныеДанныеПоБюджетированию.Доступность = Ложь;
					//Элементы.СписокДополнительныхРеквизитов.ТолькоПросмотр = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	 	Если (НЕ Объект.Ссылка.Пустая()) И Объект.ИспользоватьДополнительныеРеквизиты Тогда

			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	фин_ДополнительныеРеквизитыДокументовДляБюджетирования.РеквизитДокумента,
				|	фин_ДополнительныеРеквизитыДокументовДляБюджетирования.ОбязателенКЗаполнению
				|ИЗ
				|	РегистрСведений.фин_ДополнительныеРеквизитыДокументовДляБюджетирования КАК фин_ДополнительныеРеквизитыДокументовДляБюджетирования
				|ГДЕ
				|	фин_ДополнительныеРеквизитыДокументовДляБюджетирования.ВидДокументов = &ВидДокументов";

			Запрос.УстановитьПараметр("ВидДокументов", Объект.Ссылка);

			Результат = Запрос.Выполнить();

			ВыборкаДетальныеЗаписи = Результат.Выбрать();

			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				НС = СписокДополнительныхРеквизитов.Добавить();
				ЗаполнитьЗначенияСвойств(НС,ВыборкаДетальныеЗаписи);
			КонецЦикла;

		КонецЕсли;
		Элементы.ГруппаОтражениеФакта.ТолькоПросмотр = НЕ ПравоДоступа("Просмотр",Метаданные.РегистрыСведений.фин_ПрименениеСхемОтраженияФактическихДанных);

	Иначе
	    Элементы.ГруппаОтражениеФакта.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

//Процедура ПрочитатьШаблонПроводок
//
&НаСервере
Процедура ПрочитатьШаблонПроводок()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	фин_ПрименениеСхемОтраженияФактическихДанных.Период,
	               |	фин_ПрименениеСхемОтраженияФактическихДанных.Схема КАК НаборШаблонов,
	               |	фин_ПрименениеСхемОтраженияФактическихДанных.ИспользоватьСовместноСШаблонамиРегистров
	               |ИЗ
	               |	РегистрСведений.фин_ПрименениеСхемОтраженияФактическихДанных.СрезПоследних(, ОбъектИнформационнойБазы = &Ссылка) КАК фин_ПрименениеСхемОтраженияФактическихДанных";
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Шаблон = Справочники.фин_СхемыОтраженияФактическихДанных.ПустаяСсылка();
		ДатаДействияШаблона = '19800101';
		ИспользоватьСовместноСШаблонамиРегистров = Ложь;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Шаблон 	= Выборка.НаборШаблонов;
		ДатаДействияШаблона = Выборка.Период;
		ИспользоватьСовместноСШаблонамиРегистров = Выборка.ИспользоватьСовместноСШаблонамиРегистров;
		мЕстьЗаписи = Истина;
	КонецЕсли;
	
	мШаблон 	= Шаблон;
	мДатаВводаВДействие = ДатаДействияШаблона;
	мИспользоватьСовместноСШаблонамиРегистров = ИспользоватьСовместноСШаблонамиРегистров;
	
КонецПроцедуры //ПрочитатьШаблонПроводок

&НаКлиенте
Процедура ПрограммныйИдентификаторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокДокументов();
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокДокументов()
	СписокВыбора = Новый СписокЗначений;
	Для Каждого Документ Из Метаданные.Документы Цикл
		СписокВыбора.Добавить(Документ.Имя,Документ.Синоним);
	КонецЦикла;
	СписокВыбора.СортироватьПоПредставлению();
	Возврат СписокВыбора;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Элементы.ГруппаПараметрыОтраженияФакта.Видимость 	= Объект.РегистрироватьПервичныеДанныеПоБюджетированию;
	Элементы.СписокДополнительныхРеквизитов.Видимость 	= Объект.ИспользоватьДополнительныеРеквизиты;
	Элементы.ИспользоватьСовместноСШаблонамиРегистров.Видимость = ПолучитьФункциональнуюОпциюИнтерфейса("фин_УчитыватьФактическиеДанныеПоДвижениямРегистров") И ТипЗнч(Шаблон)<>Тип("ПеречислениеСсылка.фин_АльтернативныеСпособыОтраженияФактическихДанных");
КонецПроцедуры

&НаКлиенте
Процедура ПрограммныйИдентификаторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Объект.Наименование = ПолучитьСиноним(ВыбранноеЗначение);
	Объект.НаименованиеПолное = Объект.Наименование;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСиноним(ВыбранноеЗначение)
	Возврат Метаданные.Документы[ВыбранноеЗначение].Синоним;
КонецФункции

&НаКлиенте
Процедура ПрограммныйИдентификаторПриИзменении(Элемент)
	Если мВидДокументов <> Объект.ПрограммныйИдентификатор И Объект.РегистрироватьПервичныеДанныеПоБюджетированию Тогда
		Объект.РегистрироватьПервичныеДанныеПоБюджетированию = ОпределитьВозможностьРегистрацииФакта(Объект.ПрограммныйИдентификатор);
		УстановитьВидимость();
	КонецЕсли;
	мВидДокументов = Объект.ПрограммныйИдентификатор;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьВозможностьРегистрацииФакта(Имя)
	Возврат фин_РегистрацияФактическихДанныхПоБюджетированию.ОпределитьВозможностьРегистрацииФакта(Имя);
	
КонецФункции


// Процедура записывает данные отражения в учете в информационную базу.
//
&НаСервере
Процедура ЗаписатьСпособОтражения(Отказ)

	Если Объект.ИспользоватьДополнительныеРеквизиты Тогда
		
		НаборЗаписей = РегистрыСведений.фин_ДополнительныеРеквизитыДокументовДляБюджетирования.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВидДокументов.Установить(Объект.Ссылка);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		Для Каждого ДопРеквизит Из СписокДополнительныхРеквизитов Цикл
			Запись 					= НаборЗаписей.Добавить();
			Запись.ВидДокументов 	= Объект.Ссылка;
			Запись.РеквизитДокумента 		= ДопРеквизит.РеквизитДокумента;
			Запись.ОбязателенКЗаполнению 	= ДопРеквизит.ОбязателенКЗаполнению;
		КонецЦикла;
		Попытка
			НаборЗаписей.Записать();
			
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось записать назначения дополнительных реквизитов : " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мШаблон) И Не ЗначениеЗаполнено(Шаблон) Тогда
		Возврат;
	ИначеЕсли Шаблон = мШаблон
				И ДатаДействияШаблона = мДатаВводаВДействие
				И мИспользоватьСовместноСШаблонамиРегистров = ИспользоватьСовместноСШаблонамиРегистров Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(мШаблон) И Не ЗначениеЗаполнено(Шаблон) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя назначить пустой шаблон! Для отмены отражения первичных данных
		|необходимо снять признак ""Регистрировать первичные данные по бюджетированию""",Объект,"Шаблон");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ДатаДействияШаблона = '00010101' Тогда
		Если мЕстьЗаписи=Истина Тогда
			ДатаДействияШаблона = ТекущаяДата();
		Иначе
			ДатаДействияШаблона = '19800101';
		КонецЕсли;
	КонецЕсли;	
	НаборЗаписей = РегистрыСведений.фин_ПрименениеСхемОтраженияФактическихДанных.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ДатаДействияШаблона);
	НаборЗаписей.Отбор.ОбъектИнформационнойБазы.Установить(Объект.Ссылка);
	//НаборЗаписей.Прочитать();
	Запись 					= НаборЗаписей.Добавить();
	Запись.Период			= ДатаДействияШаблона;
	Запись.ОбъектИнформационнойБазы 	= Объект.Ссылка;
	Запись.Схема 	= Шаблон;
	Запись.ИспользоватьСовместноСШаблонамиРегистров = ИспользоватьСовместноСШаблонамиРегистров;

	Попытка
		НаборЗаписей.Записать();
		
		мШаблон = Шаблон;
		мДатаВводаВДействие = ДатаДействияШаблона;
		мИспользоватьСовместноСШаблонамиРегистров = ИспользоватьСовместноСШаблонамиРегистров;
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось записать данные отражения по схеме отражения : " + ОписаниеОшибки());
		Отказ = Истина;
	КонецПопытки;

КонецПроцедуры // ЗаписатьСпособОтражения()

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	УстановитьВидимость();
	Оповестить("ЗаписьВидаДокумента",Новый Структура("ПрограммныйИдентификатор,Объект,Наименование",Объект.ПрограммныйИдентификатор,Объект.Ссылка,Объект.Наименование));
	//Если ВладелецФормы <> Неопределено И ТипЗнч(ВладелецФормы)=Тип("Форма") И ВладелецФормы.Открыта() И Найти(ВладелецФормы.Заголовок,"Бюджетирование:")<>0 Тогда
	//	Попытка
	//	
	//		ВладелецФормы.ОбновитьДанные();
	//	
	//	Исключение
	//	
	//	КонецПопытки;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаДействияШаблонаПриИзменении(Элемент)
	Если ДатаДействияШаблона = '00010101' Тогда
		ДатаДействияШаблона = '19800101';
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ПравоДоступа("Просмотр",Метаданные.РегистрыСведений.фин_ПрименениеСхемОтраженияФактическихДанных) Тогда
		ЗаписатьСпособОтражения(Отказ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РегистрироватьПервичныеДанныеПоБюджетированиюПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДополнительныеРеквизитыПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	ОткрытьФорму("РегистрСведений.фин_ПрименениеСхемОтраженияФактическихДанных.ФормаСписка",Новый Структура("Отбор",Новый Структура("ОбъектИнформационнойБазы",Объект.Ссылка)),ЭтотОбъект,,?(фин_ОбщегоНазначенияКлиентПовтИсп.РежимОтдельногоОткрытияОкон(),ВариантОткрытияОкна.ОтдельноеОкно,Окно));
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если ПравоДоступа("Просмотр",Метаданные.РегистрыСведений.фин_ПрименениеСхемОтраженияФактическихДанных) Тогда
		Если (НЕ ТекущийОбъект.Ссылка.Пустая()) И ОпределитьВозможностьРегистрацииФакта(ТекущийОбъект.ПрограммныйИдентификатор) Тогда
			Элементы.ГруппаОтражениеФакта.Видимость = ОпределитьВозможностьРегистрацииФакта(ТекущийОбъект.ПрограммныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаСервере
Функция СписокВыбораВариантов()
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(Перечисления.фин_АльтернативныеСпособыОтраженияФактическихДанных.ПоНастройкамДляРегистров);
	СписокБанкКасса = Новый СписокЗначений;
	СписокБанкКасса.Добавить("ПлатежноеПоручениеВходящее");
	СписокБанкКасса.Добавить("ПлатежноеПоручениеИсходящее");
	СписокБанкКасса.Добавить("ПлатежныйОрдерПоступлениеДенежныхСредств");
	СписокБанкКасса.Добавить("ПлатежныйОрдерСписаниеДенежныхСредств");
	СписокБанкКасса.Добавить("ПриходныйКассовыйОрдер");
	СписокБанкКасса.Добавить("РасходныйКассовыйОрдер");
	Если СписокБанкКасса.НайтиПоЗначению(Объект.ПрограммныйИдентификатор)<>Неопределено Тогда
		СписокВыбора.Добавить(Перечисления.фин_АльтернативныеСпособыОтраженияФактическихДанных.ПоДокументамПланированияДвиженийДенежныхСредств);
	КонецЕсли;
	Возврат СписокВыбора;
КонецФункции

&НаКлиенте
Процедура ШаблонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение)=Тип("ПеречислениеСсылка.фин_АльтернативныеСпособыОтраженияФактическихДанных") И ЗначениеЗаполнено(ВыбранноеЗначение) И СписокВыбораВариантов().НайтиПоЗначению(ВыбранноеЗначение)=Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(,"Выбранный способ не применим для текущего вида документов!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблонПриИзменении(Элемент)
	Если ТипЗнч(Шаблон)=Тип("ПеречислениеСсылка.фин_АльтернативныеСпособыОтраженияФактическихДанных") Тогда
		ИспользоватьСовместноСШаблонамиРегистров = Ложь;	
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ПравоДоступа("Изменение",Метаданные.РегистрыСведений.фин_ПрименениеСхемОтраженияФактическихДанных) Тогда
		Если ТекущийОбъект.Ссылка.Пустая() Тогда
			ОбновитьПовторноИспользуемыеЗначения();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
