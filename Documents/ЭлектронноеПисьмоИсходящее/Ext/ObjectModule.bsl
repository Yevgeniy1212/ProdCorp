﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС


//Вызывается при заполнении документа на основании
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Если Не Взаимодействия.КонтактыЗаполнены(Контакты) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из Контакты Цикл
		
		Адрес = Неопределено;
		
		Если ТипЗнч(СтрокаТаблицы) = Тип("Структура") Тогда
			// В документ попадут только те контакты, для которых заданы адреса электронной почты
			МассивАдресов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаТаблицы.Адрес,",");
			Для каждого ЭлементМассиваАдресов Из МассивАдресов Цикл
				Попытка
					Результат = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ЭлементМассиваАдресов);
					Если Результат.Количество() > 0 И НЕ ПустаяСтрока(Результат[0]) Тогда
						Адрес = Результат[0];
					КонецЕсли;
				Исключение
				КонецПопытки;
				Если НЕ Адрес = Неопределено Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Адрес = Неопределено И ЗначениеЗаполнено(СтрокаТаблицы.Контакт) Тогда
				МассивАдресовЭП = ВзаимодействияВызовСервера.ПолучитьАдресаЭлектроннойПочтыКонтакта(СтрокаТаблицы.Контакт);
				Если МассивАдресовЭП.Количество() > 0 Тогда
					Адрес = Новый Структура("Адрес",МассивАдресовЭП[0].АдресЭП);
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ Адрес = Неопределено Тогда
				
				НоваяСтрока = ПолучателиПисьма.Добавить();
				
				НоваяСтрока.Контакт = СтрокаТаблицы.Контакт;
				НоваяСтрока.Представление = СтрокаТаблицы.Представление;
				НоваяСтрока.Адрес = Адрес.Адрес;
			Иначе
				Продолжить;
			КонецЕсли;
			
		Иначе
			НоваяСтрока = ПолучателиПисьма.Добавить();
			НоваяСтрока.Контакт = СтрокаТаблицы;
		КонецЕсли;
		
		Взаимодействия.ДозаполнитьПоляКонтактов(НоваяСтрока.Контакт, НоваяСтрока.Представление,
			НоваяСтрока.Адрес, Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
			
	КонецЦикла;
	
	СформироватьПредставленияКонтактов();
	
КонецПроцедуры

//Формирует представления контактов для всех типов получателей письма
Процедура СформироватьПредставленияКонтактов() Экспорт
	
	СписокПолучателейПисьма =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(ПолучателиПисьма, Ложь);
	СписокПолучателейКопий =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(ПолучателиКопий, Ложь);
	СписокПолучателейСкрытыхКопий =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(ПолучателиСкрытыхКопий, Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеЭлектроннойПочтой.УстановитьПометкуУдаленияУВложенийПисьма(Ссылка, ПометкаУдаления);
	Взаимодействия.ОтработатьПризнакИзмененияПометкиУдаленияПриЗаписиПисьма(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.ДополнительныеСвойства.Вставить("ПометкаУдаления",
		ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления"));
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	УправлениеЭлектроннойПочтой.УдалитьВложенияУПисьма(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если (ТипЗнч(ДанныеЗаполнения) = Тип("Структура")) И (ДанныеЗаполнения.Свойство("Основание")) И
		(ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") ИЛИ
		ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее")) Тогда
		
		Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, Неопределено);
		ЗаполнитьНаОснованииПисьма(ДанныеЗаполнения.Основание, ДанныеЗаполнения.Команда);
		
	Иначе
		Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	Важность = Перечисления.ВариантыВажностиВзаимодействия.Обычная;
	СтатусПисьма = Перечисления.СтатусыИсходящегоЭлектронногоПисьма.Черновик;
	Если ПустаяСтрока(Кодировка) Тогда
		Кодировка = "utf-8";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		УчетнаяЗапись = УправлениеЭлектроннойПочтой.ПолучитьУчетнуюЗаписьДляОтправкиПоУмолчанию();
	КонецЕсли;
	ОтправительПредставление = ПолучитьПредставлениеДляУчетнойЗаписи(УчетнаяЗапись);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

 

Процедура ЗаполнитьНаОснованииПисьма(Основание, ТипОтвета)
	
	ПереноситьОтправителя = Истина;
	ПереноситьВсехПолучателей = Ложь;
	ПереноситьВложения = Ложь;
	ДобавлятьКТеме = "RE: ";
	
	Если ТипОтвета = "ОтветитьВсем" Тогда
		ПереноситьВсехПолучателей = Истина;
	ИначеЕсли ТипОтвета = "Переслать" Тогда
		ДобавлятьКТеме = "FW: ";
		ПереноситьОтправителя = Ложь;
		ПереноситьВложения = Истина;
	КонецЕсли;
	
	ЗаполнитьПараметрыИзПисьма(Основание, ПереноситьОтправителя, ПереноситьВсехПолучателей,
		ДобавлятьКТеме, ПереноситьВложения,ТипОтвета);
	
КонецПроцедуры

Функция ПолучитьПредставлениеДляУчетнойЗаписи(УчетнаяЗапись)

	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Возврат "";
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.ИмяПользователя,
	|	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка = &УчетнаяЗапись";
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Представление = Выборка.ИмяПользователя;
	Если ПустаяСтрока(Представление) Тогда
		Возврат Выборка.АдресЭлектроннойПочты;
	Иначе
		Возврат Представление + " <" + Выборка.АдресЭлектроннойПочты + ">";
	КонецЕсли;

КонецФункции

Процедура ДобавитьПолучателя(Адрес, Представление, Контакт)
	
	НоваяСтрока = ПолучателиПисьма.Добавить();
	НоваяСтрока.Адрес = Адрес;
	НоваяСтрока.Контакт = Контакт;
	НоваяСтрока.Представление = Представление;
	
КонецПроцедуры

Процедура ДобавитьПолучателейИзТаблицы(Таблица)
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		НоваяСтрока = ПолучателиПисьма.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИзПисьма(Письмо, ПереноситьОтправителяВПолучатели, 
	
	ПереноситьВсехПолучателейПисьмаВПолучатели, ДобавлятьКТеме, ПереноситьВложения, ТипОтвета)
	
	ИмяОбъектаМетаданных = Письмо.Метаданные().Имя;
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	|	ЭлектронноеПисьмо.ИдентификаторСообщения,
	|	ЭлектронноеПисьмо.ИдентификаторыОснований,
	|	ЭлектронноеПисьмо.Кодировка,
	|	ЭлектронноеПисьмо.Предмет,
	|	ЭлектронноеПисьмо.Тема,
	|	ЭлектронноеПисьмо.УчетнаяЗапись,
	|	ЭлектронноеПисьмо.ТипТекста,
	|	ЭлектронноеПисьмо.Ссылка" +?(ПереноситьОтправителяВПолучатели,",
	|	ЭлектронноеПисьмо.ОтправительАдрес,
	|	ЭлектронноеПисьмо.ОтправительКонтакт,
	|	ЭлектронноеПисьмо.ОтправительПредставление", "") + "
	|ИЗ
	|	Документ." + ИмяОбъектаМетаданных + " КАК ЭлектронноеПисьмо
	|ГДЕ
	|	ЭлектронноеПисьмо.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Письмо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ИдентификаторОснования       = Выборка.ИдентификаторСообщения;
	ИдентификаторыОснований      = СокрЛП(Выборка.ИдентификаторыОснований + " <" + ИдентификаторОснования + ">");
	Кодировка                    = Выборка.Кодировка;
	Предмет                      = Выборка.Предмет;
	Тема                         = ДобавлятьКТеме + Выборка.Тема;
	УчетнаяЗапись                = Выборка.УчетнаяЗапись;
	ВзаимодействиеОснование      = Выборка.Ссылка;
	ВключатьТелоИсходногоПисьма  = Истина;
	ТипТекста                    = Выборка.ТипТекста;
	
	Если ПереноситьОтправителяВПолучатели Тогда
		ДобавитьПолучателя(Выборка.ОтправительАдрес, Выборка.ОтправительПредставление, Выборка.ОтправительКонтакт);
	КонецЕсли;
	
	Если ПереноситьВсехПолучателейПисьмаВПолучатели Тогда
		
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты
		|ПОМЕСТИТЬ АдресТекущегоПолучателя
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
		|ГДЕ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка В
		|			(ВЫБРАТЬ
		|				ЭлектронноеПисьмо.УчетнаяЗапись
		|			ИЗ
		|				Документ." + ИмяОбъектаМетаданных + " КАК ЭлектронноеПисьмо
		|			ГДЕ
		|				ЭлектронноеПисьмо.Ссылка = &Ссылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЭлектронноеПисьмоПолучателиПисьма.Адрес,
		|	ЭлектронноеПисьмоПолучателиПисьма.Представление,
		|	ЭлектронноеПисьмоПолучателиПисьма.Контакт
		|ИЗ
		|	Документ." + ИмяОбъектаМетаданных + ".ПолучателиПисьма КАК ЭлектронноеПисьмоПолучателиПисьма
		|ГДЕ
		|	ЭлектронноеПисьмоПолучателиПисьма.Ссылка = &Ссылка
		|	И (НЕ ЭлектронноеПисьмоПолучателиПисьма.Адрес В
		|				(ВЫБРАТЬ
		|					АдресТекущегоПолучателя.АдресЭлектроннойПочты
		|				ИЗ
		|					АдресТекущегоПолучателя КАК АдресТекущегоПолучателя))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЭлектронноеПисьмоПолучателиКопий.Адрес,
		|	ЭлектронноеПисьмоПолучателиКопий.Представление,
		|	ЭлектронноеПисьмоПолучателиКопий.Контакт
		|ИЗ
		|	Документ." + ИмяОбъектаМетаданных + ".ПолучателиКопий КАК ЭлектронноеПисьмоПолучателиКопий
		|ГДЕ
		|	ЭлектронноеПисьмоПолучателиКопий.Ссылка = &Ссылка
		|	И (НЕ ЭлектронноеПисьмоПолучателиКопий.Адрес В
		|				(ВЫБРАТЬ
		|					АдресТекущегоПолучателя.АдресЭлектроннойПочты
		|				ИЗ
		|					АдресТекущегоПолучателя КАК АдресТекущегоПолучателя))";
		
		Запрос.УстановитьПараметр("АдресОтправителяЭтогоПисьма",Письмо.УчетнаяЗапись.АдресЭлектроннойПочты);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ДобавитьПолучателейИзТаблицы(РезультатЗапроса.Выгрузить());
		КонецЕсли;
		
	КонецЕсли;
	
	СписокПолучателейПисьма = ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(ПолучателиПисьма, Ложь);
	
КонецПроцедуры
