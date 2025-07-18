﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Признак резервирования номенклатуры по годовому плану при подаче заказов
Перем мРезервированиеНоменклатурыПоГодовомуПлану Экспорт; // экспортируемая переменная 

#Если Клиент Тогда
	
	// Функция формирует табличный документ с печатной формой Заказ,
	//
	// Возвращаемое значение:
	//  Табличный документ - печатная форма документа
	//
	Функция ПечатьЗаказа()
			
			ВыводитьКоды    = Истина;
			Колонка         = "Код";
			ТекстКодАртикул = "Код";
		
		Если ВыводитьКоды Тогда
			ОбластьШапки  = "ШапкаТаблицыСКодом";
			ОбластьСтроки = "СтрокаСКодом";
		Иначе
			ОбластьШапки  = "ШапкаТаблицы";
			ОбластьСтроки = "Строка";
		КонецЕсли;
		
		// запрос для реквизитов шапки 
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = "ВЫБРАТЬ
		|	ЗаказПодразделения.Организация,
		|	ЗаказПодразделения.ПодразделениеОрганизации,
		|	ЗаказПодразделения.Дата,
		|	ЗаказПодразделения.Номер,
		|	ЗаказПодразделения.Ответственный
		|Из
		|	Документ.гз_ЗаказПодразделения КАК ЗаказПодразделения
		|ГДЕ
		|	ЗаказПодразделения.Ссылка = &Ссылка";	
		Док = Запрос.Выполнить().Выбрать();
		Док.Следующий();
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка",      Ссылка);
		Запрос.УстановитьПараметр("ДатаДок",     Дата);
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Запрос.Текст = "ВЫБРАТЬ
		|	гз_ЗаказПодразделенияСоставЗаявкиТовары.НомерСтроки,
		|	гз_ЗаказПодразделенияСоставЗаявкиТовары.Количество,
		|	гз_ЗаказПодразделенияСоставЗаявкиТовары.Номенклатура
		|ИЗ
		|	Документ.гз_ЗаказПодразделения.СоставЗаявкиТовары КАК гз_ЗаказПодразделенияСоставЗаявкиТовары
		|ГДЕ
		|	гз_ЗаказПодразделенияСоставЗаявкиТовары.Ссылка = &Ссылка";
		
		РезЗапросаСписка = Запрос.Выполнить().Выбрать();
		
		РезультатЗапросаПоНоменклатуре = Запрос.Выполнить().Выгрузить();
		РезультатЗапросаПоНоменклатуре.Свернуть("Номенклатура");
		МассивНоменклатуры = РезультатЗапросаПоНоменклатуре.ВыгрузитьКолонку("Номенклатура");
		
		ЗапросВидаНоменклатуры = Новый Запрос;
		ЗапросВидаНоменклатуры.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
		ЗапросВидаНоменклатуры.Текст =		 "ВЫБРАТЬ
							   |	гз_СвойстваНоменклатуры.Номенклатура
							   |ИЗ
							   |	РегистрСведений.гз_СвойстваНоменклатуры КАК гз_СвойстваНоменклатуры
							   |ГДЕ
							   |	гз_СвойстваНоменклатуры.Номенклатура В(&МассивНоменклатуры)
							   |	И гз_СвойстваНоменклатуры.Работа";
		Результат = ЗапросВидаНоменклатуры.Выполнить().Выгрузить();
			
		ТабДокумент = Новый ТабличныйДокумент;
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_гз_ЗаявкиНаПланированиеГосЗакупок";
		Макет       = ПолучитьМакет("Заказ");
		
		// Выводим шапку 
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = гз_РаботаСДиалогами.мСформироватьЗаголовокДокумента(ЭтотОбъект, "План закупок подразделения", глСписокПрефиксовУзлов);
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Подразделение = СокрЛП(Док.ПодразделениеОрганизации);
		ОбластьМакета.Параметры.Год = Формат(Год,"ДФ=гггг");
		ТабДокумент.Вывести(ОбластьМакета);
		
		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.Колонка = Колонка;
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакета);      
		
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		ОбластьГруппировки = Макет.ПолучитьОбласть("СтрокаГруппировки");
		Сумма = 0;	
		НомСтр = 1;
		ТабДокумент.НачатьАвтогруппировкуСтрок();
		Пока РезЗапросаСписка.Следующий() Цикл
			
			ОбластьМакета.Параметры.Заполнить(РезЗапросаСписка);
			ОбластьМакета.Параметры.ТоварНаименование = СокрЛП(РезЗапросаСписка.Номенклатура.Наименование);
			ОбластьМакета.Параметры.Ед = РезЗапросаСписка.Номенклатура.БазоваяЕдиницаИзмерения;
			
			Если НЕ РезЗапросаСписка.Номенклатура.Пустая() Тогда 
			
				Если Результат.Найти(РезЗапросаСписка.Номенклатура, "Номенклатура")<>Неопределено Тогда 
					ОбластьМакета.Параметры.ВидНоменклатуры = Перечисления.гз_ВидыПредметовЗакупки.Работа			  
				ИначеЕсли РезЗапросаСписка.Номенклатура.Услуга Тогда  
					ОбластьМакета.Параметры.ВидНоменклатуры = Перечисления.гз_ВидыПредметовЗакупки.Услуга			 
				Иначе 
					ОбластьМакета.Параметры.ВидНоменклатуры = Перечисления.гз_ВидыПредметовЗакупки.Товар			 
				КонецЕсли;
				
			КонецЕсли;
						
			Если ВыводитьКоды Тогда
				ОбластьМакета.Параметры.КодАртикул = РезЗапросаСписка.Номенклатура.Код;
			КонецЕсли;   
			
			ОбластьМакета.Параметры.НомерСтроки = НомСтр;
			НомСтр = НомСтр + 1;
			ТабДокумент.Вывести(ОбластьМакета, 0);
		КонецЦикла;
		
		ТабДокумент.ЗакончитьАвтогруппировкуСтрок();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Ответственный = СокрЛП(Док.Ответственный.Наименование);
		ТабДокумент.Вывести(ОбластьМакета);
		
		Возврат ТабДокумент;
			
	КонецФункции //ПечатьЗаявки()
	
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА
	
	// Процедура осуществляет печать документа. Можно направить печать на 
		// экран или принтер, а также распечатать необходимое количество копий.
		//
		//  Название макета печати передается в качестве параметра,
		// по переданному названию находим имя макета в соответствии.
		//
		// Параметры:
		//  НазваниеМакета - строка, название макета.
		//
	Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
			
			Если ЭтоНовый() Тогда
				Предупреждение("Документ можно распечатать только после его записи");
				Возврат;
			ИначеЕсли Не гз_УправлениеПользователямиБК.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
				Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
				Возврат;
			КонецЕсли;
			Если Не гз_РаботаСДиалогами.мПроверитьМодифицированность(ЭтотОбъект) Тогда
				Возврат;
			КонецЕсли;
			Если ИмяМакета = "Заказ" Тогда
				ТабДокумент = ПечатьЗаказа();
			ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда
				ТабДокумент = гз_РаботаСДиалогами.мНапечататьВнешнююФорму(Ссылка, ИмяМакета);
				Если ТабДокумент = Неопределено Тогда
					Возврат
				КонецЕсли;		
			КонецЕсли;
			гз_РаботаСДиалогами.мНапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, гз_РаботаСДиалогами.мСформироватьЗаголовокДокумента(ЭтотОбъект, "Заказ от подразделения "+ ПодразделениеОрганизации));
			
		КонецПроцедуры // Печать()
	
#КонецЕсли
	
// Процедура выполняет заполнение документа по документу-основанию
	//
Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.гз_ПланЗакупокПодразделения") Тогда
		// Заполним реквизиты из стандартного набора по документу основанию.
		гз_ОбщегоНазначения.мЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		МестоПоставки = Основание.МестоПоставки;
		Год = Основание.Год;
		СкопироватьТовары(Основание);
		//
		ДокументОснование = Основание.Ссылка;
	КонецЕсли;
КонецПроцедуры //ЗаполнитьПоДокументуОснования()

// Процедура выполняет копирование строк в табличную часть документа
//
Процедура СкопироватьТовары(ДокументОснование)Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.Ссылка,
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.НомерСтроки,
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.МестоПоставки,
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.Количество,
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.Номенклатура,
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.ПериодПоставки,
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.Характеристика
	               |ИЗ
	               |	Документ.гз_ПланЗакупокПодразделения.СоставЗаявкиТовары КАК гз_ПланЗакупокПодразделенияСоставЗаявкиТовары
	               |ГДЕ
	               |	гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.Ссылка.Ссылка = &Ссылка
	               |	И гз_ПланЗакупокПодразделенияСоставЗаявкиТовары.ВидКорректировки <> &ВидКорректировки";
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	Запрос.УстановитьПараметр("ВидКорректировки", Перечисления.гз_ВидыКорректировокГодовогоПлана.Удаление);
	СоставЗаявкиТовары.Загрузить(запрос.Выполнить().Выгрузить());
		
КонецПроцедуры //СкопироватьТовары()

// Функция возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Заказ","Заказ подразделения");
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Функция формирует таблицу заявок
//
// Возвращаемое значение:
//  Таблица заявок
//  
Функция СформироватьТаблицуЗаявок(УчетПоВсемОрганизациям) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.Текст="ВЫБРАТЬ
	|	гз_СостоянияТекущихЗаявокСрезПоследних.Заявка,
	|	гз_СостоянияТекущихЗаявокСрезПоследних.Состояние
	|Из
	|	РегистрСведений.гз_СостоянияТекущихЗаявок.СрезПоследних(,"+?(УчетПоВсемОрганизациям,"","Организация = &Организация")+") КАК гз_СостоянияТекущихЗаявокСрезПоследних
	|ГДЕ гз_СостоянияТекущихЗаявокСрезПоследних.Состояние <> ЗНАЧЕНИЕ(Перечисление.гз_СостоянияЗаказа.Зарегистрирован)";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // СформироватьТаблицуЗаявок()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(РежимПроведения,СтруктураШапкиДокумента, Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "Организация"; // , ОперацияСОбъектамиОС - НЕ обязательна к заполнению
	
	СтруктураОбязательныхПолей = Новый Структура(ОбязательныеРеквизитыШапки);
	СтруктураОбязательныхПолей.Вставить("ПодразделениеОрганизации");
	
	// Теперь позовем общую процедуру проверки.
	гз_ОбщегоНазначения.мПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры //ПроверитьЗаполнениеШапки()

// Процедура проверяет правильность заполнения реквизитов документа
//
Процедура ПроверкаРеквизитовТЧ(ТабЗаявки, СтруктураШапкиДокумента,Отказ, Заголовок, ТипТЧ) Экспорт
	
	РеквизитыТабЗаявки = "Номенклатура, Количество"; //через запятую
	ЗаполнитьРеквизитУслуга(ТабЗаявки);
	
	гз_ОбщегоНазначения.мПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "СоставЗаявки"+ТипТЧ, Новый Структура(РеквизитыТабЗаявки), Отказ, Заголовок);
	
КонецПроцедуры // ПроверкаРеквизитовТЧ()

// Процедура заполнения реквизита услуга
//
Процедура ЗаполнитьРеквизитУслуга(ТЧ)
	
	ТЧ.Колонки.Добавить("Услуга");
	Для Каждого ТекСтрТЧ Из ТЧ Цикл
		ТекСтрТЧ.Услуга = ТекСтрТЧ.Номенклатура.Услуга;
	КонецЦикла;
	
КонецПроцедуры //ЗаполнитьРеквизитУслуга()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура формирования движений регистров
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,  ТаблицаПоЗаявкеТовары,  Отказ, Заголовок)
	
	Если Не Отказ Тогда
		ОрганизацияДляДвижения 	= СтруктураШапкиДокумента.Организация;
		ДатаДляДвижения 		= СтруктураШапкиДокумента.Дата;
		Подразделение 			= СтруктураШапкиДокумента.ПодразделениеОрганизации;
		// Движение по регистру по Товарам
		ДвиженияПоРегистрамТовары(ТаблицаПоЗаявкеТовары, Отказ, Год, ОрганизацияДляДвижения, ДатаДляДвижения, Подразделение, МестоПоставки);
		
		// запись состояния заявки
		СтрокаДвижений 					= Движения.гз_СостоянияТекущихЗаявок.Добавить();
		СтрокаДвижений.Организация 		= СтруктураШапкиДокумента.Организация;
		СтрокаДвижений.Подразделение 	= СтруктураШапкиДокумента.ПодразделениеОрганизации;
		СтрокаДвижений.Заявка 			= СтруктураШапкиДокумента.Ссылка;
		СтрокаДвижений.Период 			= СтруктураШапкиДокумента.Дата;
		СтрокаДвижений.Состояние		= Перечисления.гз_СостоянияЗаказа.Зарегистрирован;
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирования движений регистров по ТЧ Товары
//
Процедура ДвиженияПоРегистрамТовары(ТаблицаПоЗаявкеТовары, Отказ, Год, ОрганизацияДляДвижения, ДатаДляДвижения, Подразделение, МестоПоставки)
	УчетИсполненияЗаказов = Константы.гз_ВестиУчетИсполненияЗаказовПодразделений.Получить();
	
	Для Каждого ТекСтр Из ТаблицаПоЗаявкеТовары Цикл 
		Если мРезервированиеНоменклатурыПоГодовомуПлану Тогда 
			Движение = Движения.гз_РезервированиеПозицийГодовогоПлана.ДобавитьПриход();
			Движение.Заказ					 = Ссылка;
			Движение.Номенклатура			 = ТекСтр.Номенклатура;
			Движение.Организация			 = ОрганизацияДляДвижения;
			Движение.Период					 = ДатаДляДвижения;
			Движение.Количество		         = ТекСтр.Количество;
		КонецЕсли;
		Если УчетИсполненияЗаказов Тогда
            Движение = Движения.гз_НеисполненныеПозицииЗаказов.ДобавитьПриход();
			Движение.Период 		= Дата;
			Движение.Год			= Год;
			Движение.ЗаказПодразделения	= Ссылка;
			Движение.Организация 	= Организация;
			Движение.Подразделение	= ПодразделениеОрганизации;
			Движение.МестоПоставки 	= ?(ТекСтр.МестоПоставки.Пустая(),МестоПоставки,ТекСтр.МестоПоставки);
			Движение.Номенклатура 	= ТекСтр.Номенклатура;
			Движение.Количество 	= ТекСтр.Количество;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры //ДвиженияПоРегистрамТовары()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения" объекта.
//
Процедура ОбработкаПроведения(Отказ,РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = гз_ОбщегоНазначения.мПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки
	Если гз_ОбщегоНазначения.мРучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
		Возврат
	КонецЕсли;
	
	// Проверка согласованности
	Если Состояние <> Перечисления.гз_СостояниеДокумента.Утверждена Тогда
		Сообщить(Заголовок + " документ можно провести только после утверждения.");
		Отказ = истина;
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = гз_ОбщегоНазначения.мСформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(РежимПроведения,СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "Оплата НМА".
	
	ТаблицаСоставаЗаявкиТовары = СоставЗаявкиТовары.Выгрузить();
	
	ПроверкаРеквизитовТЧ(ТаблицаСоставаЗаявкиТовары, СтруктураШапкиДокумента,Отказ, Заголовок, "Товары");
	
	// Проверим, не дублируются ли Номенклатура в таб.части
	
	Если НЕ Отказ Тогда
		// Формирование движений регистров, бухгалтерских и налоговых проводок.
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаСоставаЗаявкиТовары, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры //ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения" объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	гз_ОбщегоНазначения.мУдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
КонецПроцедуры //ОбработкаУдаленияПроведения()

// Процедура - обработчик события "ОбработкаЗаполнения" объекта.
//
Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.гз_ПланЗакупокПодразделения") Тогда
		ЗаполнитьПоДокументуОснования(Основание);
	КонецЕсли;
	
КонецПроцедуры //ОбработкаЗаполнения()

// Процедура - обработчик события "ПередЗаписью" объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() ИЛИ ДополнительныеСвойства.Свойство("ВнешняяОбработка") Тогда
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.Текст="ВЫБРАТЬ
	|	гз_СостоянияТекущихЗаявокСрезПоследних.Заявка,
	|	гз_СостоянияТекущихЗаявокСрезПоследних.Состояние
	|Из
	|	РегистрСведений.гз_СостоянияТекущихЗаявок.СрезПоследних(,Организация = &Организация) КАК гз_СостоянияТекущихЗаявокСрезПоследних
	|ГДЕ гз_СостоянияТекущихЗаявокСрезПоследних.Состояние <> ЗНАЧЕНИЕ(Перечисление.гз_СостоянияЗаказа.Зарегистрирован)";
	ТаблицаЗаявок = Запрос.Выполнить().Выгрузить();
	
	СтруктураПоиска 		= Новый Структура("Заявка");
	СтруктураПоиска.Заявка 	= Ссылка; 
	Если ТаблицаЗаявок.НайтиСтроки(СтруктураПоиска).Количество() >0 Тогда
		Отказ = Истина;
		Сообщить("На основании данного документа уже сформировано объявление о проведении конкурса по государственным закупкам, поэтому запись документа выполнена не будет.");
	КонецЕсли;
КонецПроцедуры //ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мРезервированиеНоменклатурыПоГодовомуПлану = Константы.гз_РезервироватьПозицииГодовогоПланаПриПодачеЗаказов.Получить();