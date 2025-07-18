﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
&НаКлиенте
Перем НП;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
&НаСервере
Процедура ПодборПоРеквизитам()
	ТаблицаДокументов.Очистить();
	//Формирование текста запроса
	Если ЗначениеЗаполнено(Организация) тогда
		УсловиеЗапросаОрганизация = " и Док.Организация = &Организация ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Контрагент) тогда
		УсловиеЗапросаКонтрагент = " и Док.Контрагент = &Контрагент ";
	КонецЕсли;
	ТекстЗапроса = "";
	Для каждого ТипДокумента Из мТипыДокументов.Типы() Цикл
		МД_Документа = Метаданные.НайтиПоТипу(ТипДокумента);
		Если не ПустаяСтрока(УсловиеЗапросаОрганизация) и МД_Документа.Реквизиты.Найти("Организация")=Неопределено Тогда
			//В документе нет поля "Организация". Отбор по документу не производим.
			Продолжить;
		КонецЕсли;
		Если не ПустаяСтрока(УсловиеЗапросаКонтрагент) и  МД_Документа.Реквизиты.Найти("Контрагент")=Неопределено Тогда
			//В документе нет поля "Контрагент".  Отбор по документу не производим.
			Продолжить;
		КонецЕсли;
		Если не ПустаяСтрока(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса +"
			|
			| Объединить 
			|";
		КонецЕсли; 
		ТекстЗапроса = ТекстЗапроса +  "ВЫБРАТЬ
		|	Док.Ссылка КАК Документ
		|ИЗ 	
		|	Документ."+МД_Документа.Имя+" КАК Док 
		| Где
		|	(Док.Дата >= &НачПериода "+?(НЕ ЗначениеЗаполнено(КонПериода),""," И Док.Дата <= &КонПериода")+") ";
		ТекстЗапроса = ТекстЗапроса +  УсловиеЗапросаОрганизация;
		ТекстЗапроса = ТекстЗапроса +  УсловиеЗапросаКонтрагент;
	КонецЦикла; 
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода",			НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("КонПериода",			КонПериода);
	Запрос.УстановитьПараметр("Организация",		Организация);
	Запрос.УстановитьПараметр("Контрагент",			Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Свернуть("Документ","");
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		МассивПоДоговору = КритерииОтбора.ДокументыПоДоговоруКонтрагента.Найти(ДоговорКонтрагента);
		ДокументыПоДоговору = Новый СписокЗначений;
		ДокументыПоДоговору.ЗагрузитьЗначения(МассивПоДоговору);
		СтрокиКУдалению = Новый Массив;
		Для каждого СтрокаТаблицы Из Результат Цикл
			Если ДокументыПоДоговору.НайтиПоЗначению(СтрокаТаблицы.Документ) = Неопределено Тогда
				СтрокиКУдалению.Добавить(СтрокаТаблицы);
			КонецЕсли; 
		КонецЦикла;
		Для каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			Результат.Удалить(СтрокаКУдалению);
		КонецЦикла; 
	КонецЕсли; 
	ТаблицаДокументов.Загрузить(Результат.Скопировать());
	ЭтаФорма.Элементы.ТаблицаДокументовОстаток.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПодборПоОборотам()
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сообщить("Для выбора по оборотам необходимо указать организацию!");
		Возврат;
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода",  НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("КонПериода",  КонПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	УсловиеЗапроса = "Организация = &Организация";
	ЕстьРасчетныеДокументы = Ложь;
	ОпределениеДокументаСделки = "";
	ВидыСубконто = Новый Массив;
	ИспользованоСубконто = 0; 
	ИмяРегистра = "Типовой";
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ИспользованоСубконто = ИспользованоСубконто+1;
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты);
		УсловиеЗапроса = УсловиеЗапроса+ " и Субконто"+ИспользованоСубконто+" = &Контрагент";
	КонецЕсли;
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ИспользованоСубконто = ИспользованоСубконто+1;
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры);
		УсловиеЗапроса = УсловиеЗапроса+ " и Субконто"+ИспользованоСубконто+" = &ДоговорКонтрагента";
	КонецЕсли;
	Если ЗначениеЗаполнено(Счет) Тогда
		Если не Счет.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами,"ВидСубконто")= Неопределено Тогда
			ИспользованоСубконто = ИспользованоСубконто+1;
			ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами);
			ЕстьРасчетныеДокументы = Истина;
			ОпределениеДокументаСделки = "Выборка.Субконто"+ИспользованоСубконто+" как Документ";
		КонецЕсли;
	КонецЕсли;
	РежимОпределенияОборотов = "Период";
	Если не ЕстьРасчетныеДокументы тогда
		РежимОпределенияОборотов = "Регистратор";
		ОпределениеДокументаСделки = "Выборка.Регистратор как Документ";
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	Если ЗначениеЗаполнено(Счет) Тогда
		Запрос.УстановитьПараметр("Счет", Счет);
		УсловиеВыбораСчетаВТекстеЗапроса = "Счет В ИЕРАРХИИ(&Счет)";
	Иначе
		УсловиеВыбораСчетаВТекстеЗапроса = "";
	КонецЕсли;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	"+ОпределениеДокументаСделки+",
	|	Выборка.СуммаОборот"+?(ОстаткиОбороты=1,"Кт","Дт")+" Как Оборот,
	|	Выборка.СуммаКонечныйОстаток"+?(ОстаткиОбороты=1,"Кт","Дт")+" Как Остаток
	|ИЗ
	|	РегистрБухгалтерии." + ИмяРегистра + ".ОстаткиИОбороты(&НачПериода,&КонПериода,"+РежимОпределенияОборотов+",, "+ УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеЗапроса + ") КАК Выборка
	|Где Не(Выборка.СуммаОборот"+?(ОстаткиОбороты=1,"Кт","Дт")+"=0)
	|";
	Результат = Запрос.Выполнить().Выгрузить();
	//При отсутствии расчетных документов необходимо дополнить список ручными документами по контрагенту
	Если НЕ ЕстьРасчетныеДокументы тогда
		//Преопределение типов для колонки "Документ" (т.к. в типе только регистраторы, а РД не проводится).
		СписокДокументов = Результат.ВыгрузитьКолонку("Документ");
		Результат.Колонки.Удалить(Результат.Колонки.документ);
		Результат.Колонки.Вставить(0,"Документ",мТипыДокументов);
		Результат.ЗагрузитьКолонку(СписокДокументов,"Документ");
		ИспользованоСубконто = ИспользованоСубконто+1;
		ОпределениеДокументаСделки = "Выборка.Субконто"+ИспользованоСубконто+" как Документ";
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами);
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	"+ОпределениеДокументаСделки+",
		|	Выборка.СуммаОборот"+?(ОстаткиОбороты=1,"Кт","Дт")+" Как Оборот,
		|	Выборка.СуммаКонечныйОстаток"+?(ОстаткиОбороты=1,"Кт","Дт")+" Как Остаток
		|ИЗ
		|	РегистрБухгалтерии." + ИмяРегистра + ".ОстаткиИОбороты(&НачПериода,&КонПериода,"+РежимОпределенияОборотов+",, "+ УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеЗапроса + ") КАК Выборка
		|Где Не(Выборка.СуммаОборот"+?(ОстаткиОбороты=1,"Кт","Дт")+" = 0)
		|";
		РезультатДляРД = Запрос.Выполнить().Выгрузить();
		Для каждого ДокументДопЗапроса Из РезультатДляРД Цикл
		    Если ТипЗнч(ДокументДопЗапроса.Документ)=Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом") Тогда
			    СтрокаРезультатов = Результат.Добавить();
				СтрокаРезультатов.Документ	= ДокументДопЗапроса.Документ;
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли;	
	Если не ЕстьРасчетныеДокументы тогда
		Результат.Свернуть("Документ","");
	Иначе
		Результат.Колонки.Удалить(Результат.Колонки.оборот);
	КонецЕсли;
	ОграничениеСпискаДокументовПоТипу(Результат);
	ТаблицаДокументов.Загрузить(Результат);
	ЭтаФорма.Элементы.ТаблицаДокументовОстаток.Видимость = ЕстьРасчетныеДокументы;
КонецПроцедуры

&НаСервере
Процедура ПодборПоОстаткам()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонПериода",  КонПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	УсловиеЗапроса = "Организация = &Организация";
	ЕстьРасчетныеДокументы     = Ложь;
	ОпределениеДокументаСделки = "";
	ВидыСубконто = Новый Массив;
	Если НЕ ЗначениеЗаполнено(Счет) тогда
		Сообщить("Для выбора по остаткам необходимо указать счет!");
		Возврат;
	КонецЕсли;
	ИмяРегистра = "Типовой";
	Для каждого ВидСубконтоСчета из Счет.ВидыСубконто Цикл
		Если не ВидСубконтоСчета.ТолькоОбороты тогда
			ВидыСубконто.Добавить(ВидСубконтоСчета.ВидСубконто);
			Если ВидСубконтоСчета.ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты тогда
				УсловиеЗапроса = УсловиеЗапроса +" и Субконто"+ВидСубконтоСчета.НомерСтроки+" = &субконто"+ВидСубконтоСчета.НомерСтроки;
				Запрос.УстановитьПараметр("Субконто"+ВидСубконтоСчета.НомерСтроки, Контрагент);
			ИначеЕсли ВидСубконтоСчета.ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры тогда
				УсловиеЗапроса = УсловиеЗапроса +" и Субконто"+ВидСубконтоСчета.НомерСтроки+" = &субконто"+ВидСубконтоСчета.НомерСтроки;
				Запрос.УстановитьПараметр("Субконто"+ВидСубконтоСчета.НомерСтроки, ДоговорКонтрагента);
			ИначеЕсли ВидСубконтоСчета.ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами тогда
				ЕстьРасчетныеДокументы = Истина;
				ОпределениеДокументаСделки = "Выборка.Субконто"+ВидСубконтоСчета.НомерСтроки+" как Документ,";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если НЕ ЕстьРасчетныеДокументы тогда
		Сообщить("На счете не ведется учет по расчетным документам! Выбор по остаткам на счете не может использоваться.");
		РежимВыбораДокументов = Перечисления.РежимОтбораДокументов.ПоОборотам;
		ТаблицаДокументов.Очистить();
		Возврат;
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	Если ЗначениеЗаполнено(Счет) Тогда
		Запрос.УстановитьПараметр("Счет", Счет);
		УсловиеВыбораСчетаВТекстеЗапроса = "Счет В ИЕРАРХИИ(&Счет)";
	Иначе 
		УсловиеВыбораСчетаВТекстеЗапроса = "";
	КонецЕсли;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	"+ОпределениеДокументаСделки+"
	|	Выборка.СуммаОстаток"+?(ОстаткиОбороты=1,"Кт","Дт")+" Как Остаток
	|ИЗ
	|	РегистрБухгалтерии." + ИмяРегистра + ".Остатки(&КонПериода, "+ УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеЗапроса + ") КАК Выборка";
	Результат = Запрос.Выполнить().Выгрузить();
	ОграничениеСпискаДокументовПоТипу(Результат);
	ТаблицаДокументов.Загрузить(Результат);
	ЭтаФорма.Элементы.ТаблицаДокументовОстаток.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда) Экспорт
	Если РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОборотам") Тогда
		ПодборПоОборотам();
	ИначеЕсли РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОстаткам") Тогда
		ПодборПоОстаткам();
	Иначе
		ПодборПоРеквизитам();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ
&НаСервере
Процедура УправлениеВидимостью()
	ДоступностьСчета = (РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОборотам") 
					или РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОстаткам"));
	Элементы.Счет.Доступность					= ДоступностьСчета;
	Элементы.ОстаткиОбороты.Доступность		= ДоступностьСчета;
	Если РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОборотам") Тогда
	    Элементы.ОстаткиОбороты.Заголовок = "Обороты:";
	ИначеЕсли РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОстаткам") Тогда
	    Элементы.ОстаткиОбороты.Заголовок = "Остатки:";
	Иначе
		Элементы.ОстаткиОбороты.Заголовок = "Ост./Об.:";
	КонецЕсли; 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Если даты не заполнены, то период устанавливается по умолчанию
	Если НЕ ЗначениеЗаполнено(КонПериода) и не мПереданИнтервал = Истина Тогда
		КонПериода = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(НачПериода) и не мПереданИнтервал = Истина Тогда
		НачПериода = НачалоМесяца(КонПериода);
	КонецЕсли;
	//СохранятьРежимОтбораДокументов = ВосстановитьЗначение("ДокДокументРасчетовСКонтрагентамиПодбор_СохранятьРежимОтбораДокументов");
	//ФормироватьСписокПриОткрытии   = ВосстановитьЗначение("ДокДокументРасчетовСКонтрагентамиПодбор_ФормироватьСписокПриОткрытии");
	Если СохранятьРежимОтбораДокументов тогда
//		РежимОтбораДокументов = ВосстановитьЗначение("ДокДокументРасчетовСКонтрагентамиПодбор_РежимОтбораДокументов");
	Иначе
		РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоРеквизитам");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(мТипыДокументов) тогда
		Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
			мТипыДокументов = ПолучитьТипДокумента();
		ИначеЕсли ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("ПолеВводаФормы") Тогда
			Если НЕ ЭтаФорма.ВладелецФормы.ОграничениеТипа.Типы().Количество() = 0 тогда
				мТипыДокументов = ЭтаФорма.ВладелецФормы.ОграничениеТипа;
			Иначе
				Попытка
					мТипыДокументов = ЭтаФорма.ВладелецФормы.ТипЗначения;
				Исключение
					мТипыДокументов = Новый ОписаниеТипов("ДокументСсылка.ДокументРасчетовСКонтрагентом");
				КонецПопытки;
			КонецЕсли;
		Иначе
			мТипыДокументов = Новый ОписаниеТипов("ДокументСсылка.ДокументРасчетовСКонтрагентом");
		КонецЕсли;		
	КонецЕсли;
	
	

	УправлениеВидимостью(); 
	//НП = Новый НастройкаПериода;
	НП = Новый ДиалогРедактированияСтандартногоПериода();
	Если ТипЗнч(Счет) = Тип("Неопределено") тогда
		Счет = ПредопределенноеЗначение("ПланСчетов.Типовой.ПустаяСсылка");
	КонецЕсли;
	Если ФормироватьСписокПриОткрытии тогда
		ОбновитьСписок(Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьТипДокумента()
	Возврат ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами.ТипЗначения;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ
&НаКлиенте
Процедура КоманднаяПанель1Выбрать(Кнопка)

	Если Элементы.ТаблицаДокументов.ТекущаяСтрока	= Неопределено тогда
		Сообщить("Документ расчетов не выбран");
	Иначе
		ОповеститьОВыборе(Элементы.ТаблицаДокументов.ТекущиеДанные.Документ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанель1СоздатьИВыбрать(Кнопка)
	СоздатьДокумент();
КонецПроцедуры

&НаКлиенте
Функция СоздатьДокумент()
	ПараметрыФормы = Новый Структура("Дата,Организация,Контрагент,ДоговорКонтрагента",?(НЕ ЗначениеЗаполнено(КонПериода),ТекущаяДата(),КонПериода),Организация,Контрагент,ДоговорКонтрагента);
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаОбъекта", ПараметрыФормы, Элементы.ТаблицаДокументов);
	
	//Док = Документы.ДокументРасчетовСКонтрагентом.СоздатьДокумент();
	//Док.Дата        = ?(НЕ ЗначениеЗаполнено(КонПериода),ТекущаяДата(),КонПериода);
	//Док.Организация = Организация;
	//Док.Контрагент	= Контрагент;
	//Док.ДоговорКонтрагента	= ДоговорКонтрагента;
	//Док.ПолучитьФорму("ФормаДокумента").ОткрытьМодально();
	//Возврат Док.Ссылка;
КонецФункции

&НаКлиенте
Процедура ТаблицаДокументовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если НЕ ВыбранноеЗначение.Ссылка.Пустая() Тогда
		ОповеститьОВыборе(ВыбранноеЗначение.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьДокумент(Кнопка)
    СтрокаДанных = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если Не СтрокаДанных = Неопределено Тогда
		ОткрытьЗначение(СтрокаДанных.Документ);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Если не ПолучитьОрганизациюДоговорКонтрагента(ДоговорКонтрагента) = Организация тогда
		ДоговорКонтрагента = ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьОрганизациюДоговорКонтрагента(ДоговорКонтрагента)
	Возврат ДоговорКонтрагента.Организация;	
КонецФункции

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	Если не ПолучитьВладельцаКонтрагента(ДоговорКонтрагента) = Контрагент тогда
		ДоговорКонтрагента = ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьВладельцаКонтрагента(ДоговорКонтрагента)
	Возврат ДоговорКонтрагента.Владелец;	
КонецФункции

&НаКлиенте
Процедура РежимОтбораДокументовПриИзменении(Элемент)
	ТаблицаДокументов.Очистить();
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	СтПериод = Новый СтандартныйПериод;
	СтПериод.ДатаНачала = НачПериода;
	СтПериод.ДатаОкончания = КонПериода;
	НП.Период=СтПериод;
	Если НП.Редактировать() Тогда
		СтПериод = НП.Период;
		НачПериода = СтПериод.ДатаНачала;
		КонПериода = СтПериод.ДатаОкончания;
	КонецЕсли;
КонецПроцедуры // КнопкаНастройкаПериодаНажатие()

&НаСервере
Процедура ОграничениеСпискаДокументовПоТипу(Результат)
	СтрокиКУдалению = новый Массив();
	Для каждого СтрокаВыборки из Результат Цикл
		Если (не мТипыДокументов.СодержитТип(ТипЗнч(СтрокаВыборки.Документ))) или НЕ ЗначениеЗаполнено(СтрокаВыборки.Документ) тогда
			СтрокиКУдалению.Добавить(СтрокаВыборки);
		КонецЕсли;
	КонецЦикла;
	Для каждого СтрокаВыборки из СтрокиКУдалению Цикл
		Результат.Удалить(СтрокаВыборки);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДокументВыбор(Элемент=Неопределено, ВыбраннаяСтрока, Колонка=Неопределено, СтандартнаяОбработка)
	ОповеститьОВыборе(Элемент.ТекущиеДанные.Документ);
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	Если Параметры.Свойство("Контрагент") Тогда
		Контрагент = Параметры.Контрагент;
	КонецЕсли;
	Если Параметры.Свойство("ДоговорКонтрагента") Тогда
		ДоговорКонтрагента = Параметры.ДоговорКонтрагента;
	КонецЕсли;
	Если Параметры.Свойство("КонецПериода") Тогда
		КонПериода = Параметры.КонецПериода;
		мПереданИнтервал = Истина;
	КонецЕсли;
	
	оф_ДокументыРасчетовСКонтрагентамиЗаголовок = "Документы расчетов с контрагентами";
	оф_ОтборЗаголовок = "Отбор";
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец",Контрагент));
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора",ПараметрыФормы,Элемент);
КонецПроцедуры
