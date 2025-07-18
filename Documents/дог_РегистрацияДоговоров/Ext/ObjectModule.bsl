﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	фин_ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.дог_РегистрацияДоговоров.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Документы.дог_РегистрацияДоговоров.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Движения, ПараметрыПроведения.ТаблицаТовары, ПараметрыПроведения.ТаблицаУслуги, ПараметрыПроведения.ТаблицаОС);	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Документы.дог_РегистрацияДоговоров.ИзменитьДанныеДоговора(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка=Истина Тогда
		Возврат;
	КонецЕсли;
	Если ДополнительныеСвойства.Свойство("ВнешняяОбработка") Тогда
		Возврат;
	КонецЕсли;
	Если ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор Тогда
		ВариантРегистрацииДополнительногоСоглашения = Перечисления.дог_ВариантыРегистрацииДополнительныхСоглашений.ПустаяСсылка();	
	КонецЕсли;
	Если ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.НетоварныеОперации Тогда
		КонтролироватьСрокиПоставки = Ложь;	
	КонецЕсли;
	
	АктуальныйРегистратор = Документы.дог_РегистрацияДоговоров.ЭтоАктуальныйРегистратор(ЭтотОбъект, ДоговорКонтрагента, Истина);
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) И ТипЗнч(ДоговорКонтрагента)=Тип("СправочникСсылка.ДоговорыКонтрагентов") И НЕ АктуальныйРегистратор Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Проведение документа невозможно, т.к. существуют более поздние соглашения по договору!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		// Создаем договор, если он не заполнен
		Если (ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор ИЛИ ВариантРегистрацииДополнительногоСоглашения<>Перечисления.дог_ВариантыРегистрацииДополнительныхСоглашений.КорректировкаСуществующегоДоговораКонтрагента) И (НЕ ЗначениеЗаполнено(ДоговорКонтрагента) ИЛИ ТипЗнч(ДоговорКонтрагента)=Тип("Строка")) Тогда
			НовыйДоговор = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
			ЗаполнитьОбъектДоговораПоДокументу(НовыйДоговор);
			
			//+++ Oleg SmartT. 2021-03-09	
			НовыйДоговор.Наименование = СтрЗаменить(НовыйДоговор.Наименование, "Договор ", "");
			НовыйДоговор.СуммаДоговора = ОбщаяСуммаДоговора;
			//--- Oleg SmartT. 2021-03-09	
			
			Попытка
				НовыйДоговор.Записать();
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при записи нового договора """+ДоговорКонтрагента+""":
					|	"+ОписаниеОшибки());
				Отказ = Истина;
			КонецПопытки;		
			ДоговорКонтрагента = НовыйДоговор.Ссылка;
		ИначеЕсли фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("дог_УправлениеКарточкойДоговораДокументамиРегистрации") И ЗначениеЗаполнено(ДоговорКонтрагента) И ТипЗнч(ДоговорКонтрагента)=Тип("СправочникСсылка.ДоговорыКонтрагентов")  Тогда
			НовыйДоговор = ДоговорКонтрагента.ПолучитьОбъект();
			НовыйДоговор.ПометкаУдаления = Ложь;
			ЗаполнитьОбъектДоговораПоДокументу(НовыйДоговор);
			Попытка
				НовыйДоговор.Записать();
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка изменении параметров договора """+ДоговорКонтрагента+""":
					|	"+ОписаниеОшибки());
				Отказ = Истина;
			КонецПопытки;		
		КонецЕсли;
	ИначеЕсли фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("дог_УправлениеКарточкойДоговораДокументамиРегистрации") И (РежимЗаписи=РежимЗаписиДокумента.ОтменаПроведения ИЛИ РежимЗаписи=РежимЗаписиДокумента.Запись) И ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор И ПометкаУдаления И ЗначениеЗаполнено(ДоговорКонтрагента) И ТипЗнч(ДоговорКонтрагента)=Тип("СправочникСсылка.ДоговорыКонтрагентов") И НЕ ДоговорКонтрагента.ПометкаУдаления Тогда
		НовыйДоговор = ДоговорКонтрагента.ПолучитьОбъект();
		Попытка
			НовыйДоговор.УстановитьПометкуУдаления(Истина);
			НовыйДоговор.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось установить пометку удаления для элемента справочника ""Договоры контрагентов"":
			|	"""+ДоговорКонтрагента+""":
			|	"+ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;		
	ИначеЕсли фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("дог_УправлениеКарточкойДоговораДокументамиРегистрации") И РежимЗаписи=РежимЗаписиДокумента.Запись И ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор И (НЕ ПометкаУдаления) И ЗначениеЗаполнено(ДоговорКонтрагента) И ТипЗнч(ДоговорКонтрагента)=Тип("СправочникСсылка.ДоговорыКонтрагентов") И ДоговорКонтрагента.ПометкаУдаления Тогда
		НовыйДоговор = ДоговорКонтрагента.ПолучитьОбъект();
		Попытка
			НовыйДоговор.УстановитьПометкуУдаления(Ложь);
			НовыйДоговор.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось снять пометку удаления для элемента справочника ""Договоры контрагентов"":
			|	"""+ДоговорКонтрагента+""":
			|	"+ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;		
	КонецЕсли;
	Если ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации
		И ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорПоставки Тогда

	ИначеЕсли ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.НетоварныеОперации Тогда
		ОС.Очистить();
		Товары.Очистить();
		Услуги.Очистить();
	КонецЕсли;
	Если ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.ПоИндивидуальномуГрафику Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Таб.ЭтапОплаты
			|ПОМЕСТИТЬ ТабДок
			|ИЗ
			|	&Таблица КАК Таб
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТабДок.ЭтапОплаты) КАК ЭтапОплаты
			|ИЗ
			|	ТабДок КАК ТабДок";
	    Запрос.УстановитьПараметр("Таблица",ГрафикПлатежей);
		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();
	    Колво = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			КолВо = ВыборкаДетальныеЗаписи.ЭтапОплаты;
		КонецЦикла;
		Если Колво<>ГрафикПлатежей.Количество() Тогда 
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В графике платежей присутствуют одинаковые этапы оплаты!");
		КонецЕсли;
	Иначе
		ГрафикПлатежей.Очистить();
	КонецЕсли;
	МассивТЧ = Новый Массив;
	МассивТЧ.Добавить("Товары");
	МассивТЧ.Добавить("Услуги");
	МассивТЧ.Добавить("ОС");
	Для Каждого ТЧ Из МассивТЧ Цикл
		Для Каждого СтрокаТЧ Из ЭтотОбъект[ТЧ] Цикл
			Если ЕдиныйСрокПоставкиПоЗаказу Тогда
				СтрокаТЧ.ДатаПоставки = СрокПоставки;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Подразделение) Тогда
				СтрокаТЧ.Подразделение = Справочники.Подразделения.ПустаяСсылка();
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Заказ) Тогда
				СтрокаТЧ.Заказ = ?(ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорРеализации,Документы.узп_ЗаказПокупателя.ПустаяСсылка(),Документы.узп_ЗаказПоставщику.ПустаяСсылка());
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьОбъектДоговораПоДокументу(НовыйДоговор)
	НовыйДоговор.Владелец = Контрагент;
	Если ВидДоговораПрочее Тогда
		НовыйДоговор.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее;
	ИначеЕсли (ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации И ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорПоставки)
		ИЛИ (ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации И ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ЗаказНаПриобретение)
		ИЛИ (ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.НетоварныеОперации И ВидОбязательства = Перечисления.дог_ВидыОбязательствПоДоговору.Исходящее) Тогда
		НовыйДоговор.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
	ИначеЕсли (ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации 
		И (ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорРеализации ИЛИ ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ЗаказНаПриобретение))
		ИЛИ (ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.НетоварныеОперации И ВидОбязательства = Перечисления.дог_ВидыОбязательствПоДоговору.Входящее) Тогда
		НовыйДоговор.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем;
	Иначе
		НовыйДоговор.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее;
	КонецЕсли;
	НовыйДоговор.ДатаДоговора = ДатаДоговора;
	НовыйДоговор.ДатаНачалаДействияДоговора = ДатаНачала;
	НовыйДоговор.ДатаОкончанияДействияДоговора = ДатаОкончания;
	НовыйДоговор.Наименование = ?(фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("дог_РежимФормированияНаименованияКарточкиДоговора")=Перечисления.общ_РежимыФормирования.Автоматически,"Договор № "+ВходящийНомер+" от "+Формат(ДатаДоговора,"ДФ=dd.MM.yyyy; ДП='Пустая дата'"),ДоговорКонтрагента);
	НовыйДоговор.Организация = Организация;
	НовыйДоговор.ТипЦен = ТипЦен;
	НовыйДоговор.НомерДоговора = ВходящийНомер;
	НовыйДоговор.ВедениеВзаиморасчетов = ВедениеВзаиморасчетов;
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		НовыйДоговор.ВалютаВзаиморасчетов = ВалютаДокумента;
	Иначе
		НовыйДоговор.ВалютаВзаиморасчетов = фин_ОбщегоНазначенияСервер.ПолучитьЗначениеПоУмолчанию(Пользователи.ТекущийПользователь(), "ОсновнаяВалютаВзаиморасчетов");
		Если НЕ ЗначениеЗаполнено(НовыйДоговор.ВалютаВзаиморасчетов) Тогда
			НовыйДоговор.ВалютаВзаиморасчетов = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаРегламентированногоУчета");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Товары.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	Если НЕ УчитыватьНДС Тогда	
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтавкаНДС");
		
	КонецЕсли;
	
	Если ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.Разовая Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодичностьОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("График");
	ИначеЕсли ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.Регулярная Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("График");
    ИначеЕсли ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.ПоГрафику Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодичностьОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОплаты");
    ИначеЕсли ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.ПоИндивидуальномуГрафику Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодичностьОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("График");
	ИначеЕсли ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.ПоСуммеЗадолженности Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодичностьОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("График");
	КонецЕсли;

	Если НЕ ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидДоговораПоТоварнымОперациям");
	КонецЕсли;
	//Если НЕ ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.НетоварныеОперации Тогда
	//	МассивНепроверяемыхРеквизитов.Добавить("ВидОбязательства");
	//КонецЕсли;
		
	//ДополнительныеПараметры
	Присутствующие = Новый Массив;
	Для каждого СтрокаТаблицы Из ДополнительныеПараметры Цикл
        Присутствующие.Добавить(СтрокаТаблицы.ДополнительныйПараметр);
		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТаблицы.НомерСтроки) +
			                               """ табличной части ""Дополнительные параметры"": ";

		Если (НЕ ЗначениеЗаполнено(СтрокаТаблицы.ЗначениеДополнительногоПараметра) И ТипЗнч(СтрокаТаблицы.ЗначениеДополнительногоПараметра)<>Тип("Булево"))
				И  СтрокаТаблицы.ДополнительныйПараметр.Обязательный Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + "не заполнен обязательный параметр. ", ЭтотОбъект, "ДополнительныеПараметры", "Объект", Отказ);                    
		КонецЕсли;
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дог_ДополнительныеПараметрыДоговоров.Ссылка
		|ИЗ
		|	ПланВидовХарактеристик.дог_ДополнительныеПараметрыДоговоров КАК дог_ДополнительныеПараметрыДоговоров
		|ГДЕ
		|	(НЕ дог_ДополнительныеПараметрыДоговоров.Ссылка В (&Присутствующие))
		|	И дог_ДополнительныеПараметрыДоговоров.Обязательный";

	Запрос.УстановитьПараметр("Присутствующие", Присутствующие);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	СтрокаНачалаСообщенияОбОшибке = "В табличной части ""Дополнительные параметры"" отсутствует обязательный параметр: ";

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + (ВыборкаДетальныеЗаписи.Ссылка),ЭтотОбъект, "ДополнительныеПараметры", "Объект", Отказ);
	КонецЦикла;
	
	// Повторяющиеся ОС
	Если ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорРеализации Тогда
		ТаблицаОС = ОС.Выгрузить(, "Номенклатура");
		ТаблицаОС.Свернуть("Номенклатура");
		Если ТаблицаОС.Количество()<ОС.Количество() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В табличной части """"ОС/НМА"""" есть повторяющиеся внеоборотные активы!'"),ЭтотОбъект,"ОС","Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// Проверка на повторное основное соглашение
	Если ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор Тогда		
		Основной = Истина;
	Иначе
		Основной = Ложь;
	КонецЕсли;	
	ПроверитьНаПовторноеОсновноеСоглашение(Отказ, Основной);
	
	
	// проверим допустимый лимит наличного расчета
	Документы.дог_РегистрацияДоговоров.ПроверитьДоступныйЛимитНаличногоРасчета(ЭтотОбъект, Отказ);	
	
	Если ВидОперации = Перечисления.дог_ВидыОперацийДоговор.ДополнительноеСоглашение И 
		СпособКорректировкиТоварнойСпецификацииДоговора = Перечисления.дог_СпособыКорректировкиТоварнойСпецификацииДоговора.УказаниеИзменяемыхНоменклатурныхПозиций Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.Количество");
	КонецЕсли;
	
	Если НЕ ЕдиныйСрокПоставкиПоЗаказу Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СрокПоставки");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаПоставки");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.ДатаПоставки");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.ДатаПоставки");
	КонецЕсли;
	
	Если ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.ПоСуммеЗадолженности Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособРасчетаСуммыПлатежа");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВариантРегистрацииДополнительногоСоглашения");
		МассивНепроверяемыхРеквизитов.Добавить("ПервоначальныйДоговор");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.дог_ВидыОперацийДоговор.ДополнительноеСоглашение И 
		ВариантРегистрацииДополнительногоСоглашения = Перечисления.дог_ВариантыРегистрацииДополнительныхСоглашений.КорректировкаСуществующегоДоговораКонтрагента Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПервоначальныйДоговор");
	КонецЕсли;
	
	Если ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.ПоИндивидуальномуГрафику Тогда
		
		Для Каждого СтрокаГрафик Из ГрафикПлатежей Цикл
			Если СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.НаОснованииСобытия И СтрокаГрафик.ПорядокРасчетаДатыПлатежа<>Перечисления.дог_ПорядкиРасчетаДатыПлатежа.ОтДатыСобытияПоДоговору Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Строка №"+Строка(СтрокаГрафик.НомерСтроки)+":Нельзя установить расчет суммы на основании события при фиксированной дате платежа",ЭтотОбъект,"ГрафикПлатежей["+Строка(ГрафикПлатежей.Индекс(СтрокаГрафик))+"].СпособРасчетаСуммыПлатежа",,Отказ);
			КонецЕсли;
			Если (СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.НаОснованииСобытия
				ИЛИ СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ПлановаяСумма
				ИЛИ СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ЗадолженностьНаДатуПлатежа
				ИЛИ СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ПоЗадолженностиНаНачалоПериода
				ИЛИ СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ПоСуммеДоговора) И СтрокаГрафик.ПроцентОтСуммы=0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан процент оплаты в строке "+Строка(СтрокаГрафик.НомерСтроки)+" списка ""График платежей""",ЭтотОбъект,"ГрафикПлатежей["+Строка(ГрафикПлатежей.Индекс(СтрокаГрафик))+"].ПроцентОтСуммы",,Отказ);
			КонецЕсли;
			Если СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ФиксированнойСуммой И СтрокаГрафик.Сумма=0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана сумма оплаты в строке "+Строка(СтрокаГрафик.НомерСтроки)+" списка ""График платежей""",ЭтотОбъект,"ГрафикПлатежей["+Строка(ГрафикПлатежей.Индекс(СтрокаГрафик))+"].Сумма",,Отказ);
			КонецЕсли;
			Если СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ПлановаяСумма И СтрокаГрафик.Сценарий.Пустая() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан сценарий расчета оплаты в строке "+Строка(СтрокаГрафик.НомерСтроки)+" списка ""График платежей""",ЭтотОбъект,"ГрафикПлатежей["+Строка(ГрафикПлатежей.Индекс(СтрокаГрафик))+"].Сценарий",,Отказ);
			КонецЕсли;
			Если СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ПлановаяСумма И СтрокаГрафик.ФинансовыйПоказательСценария.Пустая() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан финансовый показатель расчета оплаты в строке "+Строка(СтрокаГрафик.НомерСтроки)+" списка ""График платежей""",ЭтотОбъект,"ГрафикПлатежей["+Строка(ГрафикПлатежей.Индекс(СтрокаГрафик))+"].ФинансовыйПоказательСценария",,Отказ);
			КонецЕсли;
			Если СтрокаГрафик.СпособРасчетаСуммыПлатежа=Перечисления.дог_СпособыРасчетаСуммыПлатежей.ПлановаяСумма И СтрокаГрафик.ДатаСценария='00010101' Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана период планирования по сценарию для расчета оплаты в строке "+Строка(СтрокаГрафик.НомерСтроки)+" списка ""График платежей""",ЭтотОбъект,"ГрафикПлатежей["+Строка(ГрафикПлатежей.Индекс(СтрокаГрафик))+"].ДатаСценария",,Отказ);
			КонецЕсли;
		КонецЦикла;
		
	Иначе 
		МассивНепроверяемыхРеквизитов.Добавить("ГрафикПлатежей");
	КонецЕсли;
	
	фин_ЗаполнениеДокументов.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	//+++ Oleg SmartT. 2021-11-29	
	Отказ = (ЯвляетсяПролонгацией И КоличествоПролонгаций=0) ИЛИ (Не ЯвляетсяПролонгацией И КоличествоПролонгаций>0);
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Установите отметку пролонгации или количество пролонгации",ЭтотОбъект,,,Отказ);
	КонецЕсли;
	//--- Oleg SmartT. 2021-11-29	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	КонецЕсли;
	
	фин_ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаРегламентированногоУчета"));	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснования(ДанныеЗаполнения) Экспорт
	
	УчетПоПроектам = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("узп_ВестиУчетЗакупокПоПроектам");
	
	СтрокиЗаполнения = Новый Структура;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.узп_ЗаказПоставщику") Тогда
		// Заполнение шапки
		
		ВалютаДокумента = ДанныеЗаполнения.ВалютаДокумента;
		ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
		Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДоговорКонтрагента);
			ЭтотОбъект.ДатаНачала = ДоговорКонтрагента.ДатаНачалаДействияДоговора;
			ЭтотОбъект.ДатаОкончания = ДоговорКонтрагента.ДатаОкончанияДействияДоговора;
		КонецЕсли;
		ЕдиныйСрокПоставкиПоЗаказу = ДанныеЗаполнения.ЕдиныйСрокПоставкиПоЗаказу;
		Контрагент = ДанныеЗаполнения.Контрагент;
		Организация = ДанныеЗаполнения.Организация;
		Подразделение = ДанныеЗаполнения.Подразделение;
		СрокПоставки = ДанныеЗаполнения.СрокПоставки;
		СтруктурноеПодразделение = ДанныеЗаполнения.СтруктурноеПодразделение;
		ОбщаяСуммаДоговора = ДанныеЗаполнения.СуммаДокумента;
		ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор;
		ВидОперацииЗаявки  = Перечисления.ден_ВидыОперацийПланируемоеПоступлениеДС.ОплатаПокупателя;
		ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации;
		ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорПоставки;
		ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.Разовая;
		СпособОплаты = Перечисления.ден_ВидыДенежныхСредств.Безналичные;
		СуммаПлатежа = ДанныеЗаполнения.СуммаДокумента;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		УчитыватьНДС = ДанныеЗаполнения.УчитыватьНДС;
		ТипЦен = ДанныеЗаполнения.ТипЦен;
		СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			Если ?(ТипЗнч(ТекСтрокаТовары.Номенклатура)=Тип("СправочникСсылка.фин_ПлановаяНоменклатура"),ТекСтрокаТовары.Номенклатура.ТипПозицииВПланеЗакупок<>Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.Товар,ТекСтрокаТовары.Номенклатура.Услуга) Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Коэффициент = ТекСтрокаТовары.Коэффициент;
			НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			Номенклатура = дог_УправлениеДоговорами.ПолучитьРегламентированнуюНоменклатуру(ТекСтрокаТовары.Номенклатура,ТекСтрокаТовары.Характеристика,ДанныеЗаполнения.Дата);
			Если ТипЗнч(Номенклатура)=Тип("Массив") ИЛИ НЕ ЗначениеЗаполнено(Номенклатура) Тогда
				Если СтрокиЗаполнения.Свойство("Товары") Тогда
					СтрокиЗаполненияУслуги = СтрокиЗаполнения.Товары;
				Иначе
					СтрокиЗаполненияУслуги = Новый Соответствие;
				КонецЕсли;
				СтрокиЗаполненияУслуги.Вставить(НоваяСтрока.НомерСтроки,Новый Структура("Номенклатура,ПлановаяНоменклатура,Характеристика",Номенклатура,ТекСтрокаТовары.Номенклатура,ТекСтрокаТовары.Характеристика));
				СтрокиЗаполнения.Вставить("Товары",СтрокиЗаполненияУслуги);
			Иначе
				НоваяСтрока.Номенклатура = Номенклатура;
			КонецЕсли;
			НоваяСтрока.ОбъектРемонта = ТекСтрокаТовары.ОбъектРемонта;
			НоваяСтрока.Подразделение = ТекСтрокаТовары.Подразделение;
			НоваяСтрока.ДатаПоставки = ТекСтрокаТовары.СрокПоставки;
			НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовары.СтавкаНДС;
			НоваяСтрока.СуммаНДС = ТекСтрокаТовары.СуммаНДС;
			НоваяСтрока.Заказ = ДанныеЗаполнения.Ссылка;
			НоваяСтрока.ЗаявкаМТС = ТекСтрокаТовары.ЗаявкаМТС;
			Если УчетПоПроектам Тогда
				НоваяСтрока.Проект = ТекСтрокаТовары.Проект;
			КонецЕсли;
			
		КонецЦикла;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			Если ?(ТипЗнч(ТекСтрокаТовары.Номенклатура)=Тип("СправочникСсылка.фин_ПлановаяНоменклатура"),ТекСтрокаТовары.Номенклатура.ТипПозицииВПланеЗакупок=Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.Товар,Истина) Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = ОС.Добавить();
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.Характеристика = ТекСтрокаТовары.Характеристика;
			НоваяСтрока.Подразделение = ТекСтрокаТовары.Подразделение;
			НоваяСтрока.ДатаПоставки = ТекСтрокаТовары.СрокПоставки;
			НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовары.СтавкаНДС;
			НоваяСтрока.СуммаНДС = ТекСтрокаТовары.СуммаНДС;
			НоваяСтрока.Заказ = ДанныеЗаполнения.Ссылка;
			НоваяСтрока.ЗаявкаМТС = ТекСтрокаТовары.ЗаявкаМТС;
			Если УчетПоПроектам Тогда
				НоваяСтрока.Проект = ТекСтрокаТовары.Проект;
			КонецЕсли;
			
		КонецЦикла;
		Для Каждого ТекСтрокаУслуги Из ДанныеЗаполнения.Услуги Цикл
			НоваяСтрока = Услуги.Добавить();
			НоваяСтрока.Количество = ТекСтрокаУслуги.Количество;
			Номенклатура = дог_УправлениеДоговорами.ПолучитьРегламентированнуюНоменклатуру(ТекСтрокаУслуги.Номенклатура,ТекСтрокаУслуги.Характеристика,ДанныеЗаполнения.Дата);
			Если ТипЗнч(Номенклатура)=Тип("Массив") ИЛИ НЕ ЗначениеЗаполнено(Номенклатура) Тогда
				Если СтрокиЗаполнения.Свойство("Услуги") Тогда
					СтрокиЗаполненияУслуги = СтрокиЗаполнения.Услуги;
				Иначе
					СтрокиЗаполненияУслуги = Новый Соответствие;
				КонецЕсли;
				СтрокиЗаполненияУслуги.Вставить(НоваяСтрока.НомерСтроки,Новый Структура("Номенклатура,ПлановаяНоменклатура,Характеристика",Номенклатура,ТекСтрокаУслуги.Номенклатура,ТекСтрокаУслуги.Характеристика));
				СтрокиЗаполнения.Вставить("Услуги",СтрокиЗаполненияУслуги);
			Иначе
				НоваяСтрока.Номенклатура = Номенклатура;
			КонецЕсли;
			НоваяСтрока.ОбъектРемонта = ТекСтрокаУслуги.ОбъектРемонта;
			НоваяСтрока.Подразделение = ТекСтрокаУслуги.Подразделение;
			НоваяСтрока.ДатаПоставки = ТекСтрокаУслуги.СрокПоставки;
			НоваяСтрока.Сумма = ТекСтрокаУслуги.Сумма;
			НоваяСтрока.Цена = ТекСтрокаУслуги.Цена;
			НоваяСтрока.СтавкаНДС = ТекСтрокаУслуги.СтавкаНДС;
			НоваяСтрока.СуммаНДС = ТекСтрокаУслуги.СуммаНДС;
			НоваяСтрока.Заказ = ДанныеЗаполнения.Ссылка;
			НоваяСтрока.ЗаявкаМТС = ТекСтрокаУслуги.ЗаявкаМТС;
			Если УчетПоПроектам тогда
				НоваяСтрока.Проект = ТекСтрокаУслуги.Проект;
			КонецЕсли;
			
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.узп_ЗаказПокупателя") Тогда
		// Заполнение шапки
		ВалютаДокумента = ДанныеЗаполнения.ВалютаДокумента;
		ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
		Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДоговорКонтрагента);
			ЭтотОбъект.ДатаНачала = ДоговорКонтрагента.ДатаНачалаДействияДоговора;
			ЭтотОбъект.ДатаОкончания = ДоговорКонтрагента.ДатаОкончанияДействияДоговора;
		КонецЕсли;
		ЕдиныйСрокПоставкиПоЗаказу = ДанныеЗаполнения.ЕдиныйСрокПоставкиПоЗаказу;
		Контрагент = ДанныеЗаполнения.Контрагент;
		Организация = ДанныеЗаполнения.Организация;
		Подразделение = ДанныеЗаполнения.Подразделение;
		СрокПоставки = ДанныеЗаполнения.СрокПоставки;
		СтруктурноеПодразделение = ДанныеЗаполнения.СтруктурноеПодразделение;
		ОбщаяСуммаДоговора = ДанныеЗаполнения.СуммаДокумента;
		ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор;
		ВидОперацииЗаявки  = Перечисления.ден_ВидыОперацийПланируемоеПоступлениеДС.ОплатаПокупателя;
		ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации;
		ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорРеализации;
		ВидОплаты = Перечисления.дог_ВидыОплатыПоДоговору.Разовая;
		СпособОплаты = Перечисления.ден_ВидыДенежныхСредств.Безналичные;
		СуммаПлатежа = ДанныеЗаполнения.СуммаДокумента;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
			НоваяСтрока.Коэффициент = ТекСтрокаТовары.Коэффициент;
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			Номенклатура = дог_УправлениеДоговорами.ПолучитьРегламентированнуюНоменклатуру(ТекСтрокаТовары.Номенклатура,ТекСтрокаТовары.Характеристика,ДанныеЗаполнения.Дата);
			Если ТипЗнч(Номенклатура)=Тип("Массив") ИЛИ НЕ ЗначениеЗаполнено(Номенклатура) Тогда
				Если СтрокиЗаполнения.Свойство("Товары") Тогда
					СтрокиЗаполненияУслуги = СтрокиЗаполнения.Услуги;
				Иначе
					СтрокиЗаполненияУслуги = Новый Соответствие;
				КонецЕсли;
				СтрокиЗаполненияУслуги.Вставить(НоваяСтрока.НомерСтроки,Новый Структура("Номенклатура,ПлановаяНоменклатура,Характеристика",Номенклатура,ТекСтрокаУслуги.Номенклатура,ТекСтрокаУслуги.Характеристика));
				СтрокиЗаполнения.Вставить("Товары",СтрокиЗаполненияУслуги);
			Иначе
				НоваяСтрока.Номенклатура = Номенклатура;
			КонецЕсли;
			НоваяСтрока.ДатаПоставки = ТекСтрокаТовары.СрокПоставки;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовары.СтавкаНДС;
			НоваяСтрока.СуммаНДС = ТекСтрокаТовары.СуммаНДС;
			НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
			НоваяСтрока.Заказ = ДанныеЗаполнения.Ссылка;
			//НоваяСтрока.Проект = ТекСтрокаТовары.Проект;
		КонецЦикла;
		Для Каждого ТекСтрокаУслуги Из ДанныеЗаполнения.Услуги Цикл
			НоваяСтрока = Услуги.Добавить();
			НоваяСтрока.Количество = ТекСтрокаУслуги.Количество;
			НоваяСтрока.ДатаПоставки = ТекСтрокаУслуги.СрокПоставки;
			НоваяСтрока.Сумма = ТекСтрокаУслуги.Сумма;
			НоваяСтрока.Цена = ТекСтрокаУслуги.Цена;
			Номенклатура = дог_УправлениеДоговорами.ПолучитьРегламентированнуюНоменклатуру(ТекСтрокаУслуги.Номенклатура,ТекСтрокаУслуги.Характеристика,ДанныеЗаполнения.Дата);
			Если ТипЗнч(Номенклатура)=Тип("Массив") ИЛИ НЕ ЗначениеЗаполнено(Номенклатура) Тогда
				Если СтрокиЗаполнения.Свойство("Услуги") Тогда
					СтрокиЗаполненияУслуги = СтрокиЗаполнения.Услуги;
				Иначе
					СтрокиЗаполненияУслуги = Новый Соответствие;
				КонецЕсли;
				СтрокиЗаполненияУслуги.Вставить(НоваяСтрока.НомерСтроки,Новый Структура("Номенклатура,ПлановаяНоменклатура,Характеристика",Номенклатура,ТекСтрокаУслуги.Номенклатура,ТекСтрокаУслуги.Характеристика));
				СтрокиЗаполнения.Вставить("Услуги",СтрокиЗаполненияУслуги);
			Иначе
				НоваяСтрока.Номенклатура = Номенклатура;
			КонецЕсли;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовары.СтавкаНДС;
			НоваяСтрока.СуммаНДС = ТекСтрокаТовары.СуммаНДС;
			НоваяСтрока.Заказ = ДанныеЗаполнения.Ссылка;
			//НоваяСтрока.Проект = ТекСтрокаТовары.Проект;
		КонецЦикла;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.ОС Цикл
			НоваяСтрока = ОС.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.ДатаПоставки = ТекСтрокаТовары.СрокПоставки;
			НоваяСтрока.Цена = ТекСтрокаТовары.Сумма;
			НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
			НоваяСтрока.Количество = 1;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовары.СтавкаНДС;
			НоваяСтрока.СуммаНДС = ТекСтрокаТовары.СуммаНДС;
			НоваяСтрока.Заказ = ДанныеЗаполнения.Ссылка;
			//НоваяСтрока.Проект = ТекСтрокаТовары.Проект;
		КонецЦикла;
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.узп_ЗаказПоставщику") ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.узп_ЗаказПокупателя") Тогда
		ПоместитьПередаваемыеДанные(Метаданные().Имя, ДанныеЗаполнения.Ссылка, СтрокиЗаполнения);
	КонецЕсли;
	
	фин_ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаРегламентированногоУчета"), , , , ДанныеЗаполнения);
	
КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  Отказ                   - флаг отказа в проведении,
//
Процедура ПроверитьНаПовторноеОсновноеСоглашение(Отказ, Основной)
	
	Если ВидОперации = Перечисления.дог_ВидыОперацийДоговор.Договор ИЛИ (ВидОперации = Перечисления.дог_ВидыОперацийДоговор.ДополнительноеСоглашение И ВариантРегистрацииДополнительногоСоглашения = Перечисления.дог_ВариантыРегистрацииДополнительныхСоглашений.КорректировкаСуществующегоДоговораКонтрагента) Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	РегистрацияДоговоров.Ссылка
			|ИЗ
			|	Документ.дог_РегистрацияДоговоров КАК РегистрацияДоговоров
			|ГДЕ
			|	РегистрацияДоговоров.Проведен
			|	И РегистрацияДоговоров.ВидОперации = &ВидОперации
			|	И РегистрацияДоговоров.Ссылка <> &Ссылка
			|	И РегистрацияДоговоров.ДоговорКонтрагента = &ДоговорКонтрагента
			|	"+?(Основной,""," И РегистрацияДоговоров.Дата <= &Дата");

		Запрос.УстановитьПараметр("ВидОперации", Перечисления.дог_ВидыОперацийДоговор.Договор);
		Запрос.УстановитьПараметр("Дата", Дата);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);

		Результат = Запрос.Выполнить();
	    Если Основной Тогда
			Если НЕ Результат.Пустой() Тогда
				Текст = НСтр("ru = 'По данному договору уже заключено основное соглашение!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,,,Отказ);
			КонецЕсли;
		Иначе
			Если Результат.Пустой() Тогда
				Текст = НСтр("ru = 'По данному договору не заключено основное соглашение!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,,,Отказ);
			КонецЕсли;	
		КонецЕсли;
	Иначе
		Если дог_УправлениеДоговорами.ДоговорЗарегистрирован(ДоговорКонтрагента) Тогда
			Текст = НСтр("ru = 'Указанный договор контрагента уже зарегистрирован!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,,,Отказ);
		КонецЕсли;
		Если НЕ дог_УправлениеДоговорами.ДоговорЗарегистрирован(ПервоначальныйДоговор) Тогда
			Текст = НСтр("ru = 'Договор контрагента, указанный в качестве первоначального, не зарегистрирован!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,,,Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры //ПроверитьНаПовторноеОсновноеСоглашение

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ТРЕБУЮЩИЕ ПРИВЕЛИГИРОВАННОГО РЕЖИМА

Функция ПоместитьПередаваемыеДанные(Группа, Ключ, Данные) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ТекущиеДанные = ПараметрыСеанса.дог_ПередаваемыеДанные;
	Исключение
		ТекущиеДанные = Новый Соответствие;
	КонецПопытки;
	
	НовыеДанные = Новый Соответствие;
	Для Каждого Элемент Из ТекущиеДанные Цикл
		НовыеДанные.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	мДанныеГруппы = НовыеДанные.Получить(Ключ);
	Если мДанныеГруппы = Неопределено Тогда
		ДанныеГруппы = Новый Структура;
	Иначе
		ДанныеГруппы = Новый Структура;
		Для Каждого Элемент Из мДанныеГруппы Цикл
			ДанныеГруппы.Вставить(Элемент.Ключ,Элемент.Значение);
		КонецЦикла;
	КонецЕсли;
	ДанныеГруппы.Вставить(Группа, ЗначениеВСтрокуВнутр(Данные));
	НовыеДанные.Вставить(Ключ, Новый ФиксированнаяСтруктура(ДанныеГруппы));
	ПараметрыСеанса.дог_ПередаваемыеДанные = Новый ФиксированноеСоответствие(НовыеДанные);
	
КонецФункции

Функция ИзвлечьПередаваемыеДанные(Группа, Ключ) Экспорт
	
	Возврат Документы.дог_РегистрацияДоговоров.ИзвлечьПередаваемыеДанные(Группа, Ключ);
	
КонецФункции

#КонецЕсли