﻿Перем мДлинаСуток;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ РАБОТЫ ФОРМ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация" , Справочники.Организации.ПустаяСсылка());

	Запрос.Текст = "
	|Выбрать 
	|	Дата, 
	|	Организация,
	|	ВЫБОР КОГДА Организация.ГоловнаяОрганизация = &ПустаяОрганизация ТОГДА Организация ИНАЧЕ Организация.ГоловнаяОрганизация КОНЕЦ КАК ГоловнаяОрганизация,
	| 	Ссылка 
	|Из 
	|	Документ." + Метаданные().Имя + "
	|Где 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);
 	Запрос.УстановитьПараметр("Организация", ВыборкаПоШапкеДокумента.Организация);
  	Запрос.УстановитьПараметр("Уволен", 						Перечисления.ПричиныИзмененияСостояния.Увольнение);
 	Запрос.УстановитьПараметр("парамВнутреннееСовместительство", Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство);

    // Описание текста запроса:
	//
    // 1. Выборка "Начисления": 
	//		Объединяются строки ТЧ Начисления и ДополнительныеНачисления. Сразу проверяем наличие строк-дублей.  
	// 2. Выборка "СуществующиеДвижения": 
	//		Проверяем на наличие существующих конфликтных движений в регистре сведений. 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.ОбособленноеПодразделение = &Организация ИЛИ РаботникиОрганизации.ОбособленноеПодразделение ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОбособленногоПодразделения,
	|	ВЫБОР
	|		КОГДА ТЧСведенияОбУчетеВзаиморасчетов.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	ТЧСведенияОбУчетеВзаиморасчетов.НомерСтроки КАК НомерСтроки,
	|	ТЧСведенияОбУчетеВзаиморасчетов.Сотрудник КАК Сотрудник,
	|	ТЧСведенияОбУчетеВзаиморасчетов.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	ТЧСведенияОбУчетеВзаиморасчетов.ДатаНачала КАК ДатаНачала,
	|	МИНИМУМ(ПовторяющиесяСведенияОбУчетеВзаиморасчетов.НомерСтроки) КАК КонфликтныйНомерСтроки,
	|	РеглУчетВзаиморасчетовССотрудникамиОрганизаций.Регистратор.Представление КАК КонфликтныйДокумент,
	|	РаботникиОрганизации.ПодразделениеОрганизации
	|ИЗ
	|	Документ.общ_ВводСведенийОРеглУчетеВзаиморасчетовССотрудникамиОрганизаций.СведенияОбУчетеВзаиморасчетов КАК ТЧСведенияОбУчетеВзаиморасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.общ_ВводСведенийОРеглУчетеВзаиморасчетовССотрудникамиОрганизаций.СведенияОбУчетеВзаиморасчетов КАК ПовторяющиесяСведенияОбУчетеВзаиморасчетов
	|		ПО ТЧСведенияОбУчетеВзаиморасчетов.Ссылка = ПовторяющиесяСведенияОбУчетеВзаиморасчетов.Ссылка
	|			И ТЧСведенияОбУчетеВзаиморасчетов.НомерСтроки < ПовторяющиесяСведенияОбУчетеВзаиморасчетов.НомерСтроки
	|			И ТЧСведенияОбУчетеВзаиморасчетов.Сотрудник = ПовторяющиесяСведенияОбУчетеВзаиморасчетов.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.общ_РеглУчетВзаиморасчетовССотрудникамиОрганизаций КАК РеглУчетВзаиморасчетовССотрудникамиОрганизаций
	|		ПО ТЧСведенияОбУчетеВзаиморасчетов.Сотрудник = РеглУчетВзаиморасчетовССотрудникамиОрганизаций.Сотрудник
	|			И ТЧСведенияОбУчетеВзаиморасчетов.ДатаНачала = РеглУчетВзаиморасчетовССотрудникамиОрганизаций.Период
	|			И (РеглУчетВзаиморасчетовССотрудникамиОрганизаций.Организация = &ГоловнаяОрганизация)
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ДатыПоследнихНазначений.НомерСтроки КАК НомерСтроки,
	|			РаботникиОрганизации.Сотрудник КАК Сотрудник,
	|			РаботникиОрганизации.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|			РаботникиОрганизации.ОбособленноеПодразделение КАК ОбособленноеПодразделение
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ТЧСведенияОбУчетеВзаиморасчетов.НомерСтроки КАК НомерСтроки,
	|				РаботникиОрганизации.Сотрудник КАК Сотрудник,
	|				МАКСИМУМ(ВЫБОР
	|						КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = &Уволен
	|							ТОГДА ДОБАВИТЬКДАТЕ(РаботникиОрганизации.Период, ДЕНЬ, -1)
	|						ИНАЧЕ РаботникиОрганизации.Период
	|					КОНЕЦ) КАК Период
	|			ИЗ
	|				Документ.общ_ВводСведенийОРеглУчетеВзаиморасчетовССотрудникамиОрганизаций.СведенияОбУчетеВзаиморасчетов КАК ТЧСведенияОбУчетеВзаиморасчетов
	|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|					ПО ТЧСведенияОбУчетеВзаиморасчетов.ДатаНачала >= РаботникиОрганизации.Период
	|						И ТЧСведенияОбУчетеВзаиморасчетов.Сотрудник = РаботникиОрганизации.Сотрудник
	|			ГДЕ
	|				ТЧСведенияОбУчетеВзаиморасчетов.Ссылка = &ДокументСсылка
	|				И РаботникиОрганизации.Организация = &ГоловнаяОрганизация
	|				И РаботникиОрганизации.ОбособленноеПодразделение = &Организация
	|			
	|			СГРУППИРОВАТЬ ПО
	|				РаботникиОрганизации.Сотрудник,
	|				ТЧСведенияОбУчетеВзаиморасчетов.НомерСтроки) КАК ДатыПоследнихНазначений
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|				ПО ДатыПоследнихНазначений.Сотрудник = РаботникиОрганизации.Сотрудник
	|					И (ДатыПоследнихНазначений.Период = ВЫБОР
	|						КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = &Уволен
	|							ТОГДА ДОБАВИТЬКДАТЕ(РаботникиОрганизации.Период, ДЕНЬ, -1)
	|						ИНАЧЕ РаботникиОрганизации.Период
	|					КОНЕЦ)
	|					И (РаботникиОрганизации.Организация = &ГоловнаяОрганизация)
	|					И (РаботникиОрганизации.ОбособленноеПодразделение = &Организация)) КАК РаботникиОрганизации
	|		ПО ТЧСведенияОбУчетеВзаиморасчетов.НомерСтроки = РаботникиОрганизации.НомерСтроки
	|ГДЕ
	|	ТЧСведенияОбУчетеВзаиморасчетов.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.ОбособленноеПодразделение = &Организация ИЛИ РаботникиОрганизации.ОбособленноеПодразделение ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ТЧСведенияОбУчетеВзаиморасчетов.Сотрудник,
	|	ТЧСведенияОбУчетеВзаиморасчетов.СтруктурноеПодразделение,
	|	ТЧСведенияОбУчетеВзаиморасчетов.ДатаНачала,
	|	ТЧСведенияОбУчетеВзаиморасчетов.НомерСтроки,
	|	РеглУчетВзаиморасчетовССотрудникамиОрганизаций.Регистратор.Представление,
	|	РаботникиОрганизации.ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.ОбособленноеПодразделение = &Организация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении("Не указана организация, в которую принимается работник!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

Функция ПодразделениеСоответствуетСтруктурному(СП,Подразделение)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", СП);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПодразделенияОрганизаций.Ссылка
	               |ИЗ
	               |	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	               |ГДЕ
	               |	ПодразделенияОрганизаций.Владелец = &Организация
	               |	И ПодразделенияОрганизаций.Ссылка В ИЕРАРХИИ(&СтруктурноеПодразделение)";
				   
	СписокПодразделений = Новый СписокЗначений;
	СписокПодразделений.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	Возврат СписокПодразделений.НайтиПоЗначению(Подразделение)<>Неопределено;
КонецФункции

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по товарам документа, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) + ": ";

	// Сотрудник
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;                                   
	
	// организация сотрудника
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "указанный сотрудник оформлен на другую организацию!", Отказ, Заголовок);
	КонецЕсли;
	
	// обособленное сотрудника
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОбособленногоПодразделения Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "указанный сотрудник оформлен на другое обособленное подразделение!", Отказ, Заголовок);
	// структурное	
	ИначеЕсли ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.СтруктурноеПодразделение) И НЕ ПодразделениеСоответствуетСтруктурному(ВыборкаПоСтрокамДокумента.СтруктурноеПодразделение,ВыборкаПоСтрокамДокумента.ПодразделениеОрганизации) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "структурное подразделение не соответствует подразделению сотрудника ("+Строка(ВыборкаПоСтрокамДокумента.ПодразделениеОрганизации)+")!", Отказ, Заголовок);
	КонецЕсли;
	
	// ДатаНачала
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаНачала)  Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "не указана дата изменений!", Отказ, Заголовок);
	КонецЕсли;
	
	// Одинаковые строки
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтныйНомерСтроки) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке  + "по сотруднику " + ВыборкаПоСтрокамДокумента.Сотрудник.Наименование + " обнаружено повторное назначение структурного подразделения учета взаиморасчетов в строке №" + ВыборкаПоСтрокамДокумента.КонфликтныйНомерСтроки + "!", Отказ, Заголовок);
	КонецЕсли;
	
	// Движения в регистре на дату из документа
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтныйДокумент) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "на дату "+ ВыборкаПоСтрокамДокумента.ДатаНачала + " способ учета начисления уже зарегистрирован документом " + ВыборкаПоСтрокамДокумента.КонфликтныйДокумент + "!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации)

	//Движения по регистру "РеглУчетПлановыхНачисленийРаботниковОрганизаций"
	Движение = Движения.общ_РеглУчетВзаиморасчетовССотрудникамиОрганизаций.Добавить();
	// Свойства
	Движение.Период                     = ВыборкаПоРаботникиОрганизации.ДатаНачала;
	// Измерения
	Движение.Сотрудник                 	= ВыборкаПоРаботникиОрганизации.Сотрудник;
	Движение.Организация				= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
	Движение.ОбособленноеПодразделение	= ВыборкаПоШапкеДокумента.Организация;
	// Ресурсы
	Движение.СтруктурноеПодразделение   = ВыборкаПоРаботникиОрганизации.СтруктурноеПодразделение;
	// Реквизиты
	

КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	// Проверка ручной корректировки
	Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
		Возврат
	КонецЕсли;

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// выполним выборку по табличной части документа
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента);
			ВыборкаСтрокЗапроса = РезультатЗапросаПоРаботники.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			// обходим строки запроса, проверяем данные и формируем движения
			Пока ВыборкаСтрокЗапроса.Следующий() Цикл
				
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаСтрокЗапроса , Отказ, Заголовок);
				Если НЕ Отказ Тогда
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаСтрокЗапроса);
				КонецЕсли; 
				
			КонецЦикла;					
			
		КонецЕсли;	

	КонецЕсли;

КонецПроцедуры

// Предопределенная процедура обработки события удаления проведения документа
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	МассивТЧ = Новый Массив;
	МассивТЧ.Добавить(СведенияОбУчетеВзаиморасчетов);
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ,"ФизЛицо");
	
КонецПроцедуры

Процедура ПередЗаписьюДокументаЗаполнитьФизЛицоВТабличнойЧасти(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеСотрудникФизлицо = Новый Соответствие;
	ПустоеФизлицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	ПустойСотрудник = Справочники.СотрудникиОрганизаций.ПустаяСсылка();
	Для Каждого ТабличнаяЧасть Из Источник.Метаданные().ТабличныеЧасти Цикл
		Если ТабличнаяЧасть.Реквизиты.Найти("Сотрудник") = Неопределено ИЛИ ТабличнаяЧасть.Реквизиты.Найти("Физлицо") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого СтрокаТабличнойЧасти Из Источник[ТабличнаяЧасть.Имя] Цикл
			Если СтрокаТабличнойЧасти.Сотрудник <> ПустойСотрудник Тогда
				СоответствиеСотрудникФизлицо.Вставить(СтрокаТабличнойЧасти.Сотрудник);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	МассивСотрудников = Новый Массив;
	Для Каждого ЭлементСоответствия Из СоответствиеСотрудникФизлицо Цикл
		МассивСотрудников.Добавить(ЭлементСоответствия.Ключ);
	КонецЦикла;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСотрудников", МассивСотрудников);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СотрудникиОрганизаций.Физлицо,
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Ссылка В(&СписокСотрудников)";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеСотрудникФизлицо.Вставить(Выборка.Сотрудник, Выборка.Физлицо);
	КонецЦикла;

	Для Каждого ТабличнаяЧасть Из Источник.Метаданные().ТабличныеЧасти Цикл
		Если ТабличнаяЧасть.Реквизиты.Найти("Сотрудник") = Неопределено ИЛИ ТабличнаяЧасть.Реквизиты.Найти("Физлицо") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаписыватьТабличнуюЧасть = Ложь;
		Для Каждого СтрокаТабличнойЧасти Из Источник[ТабличнаяЧасть.Имя] Цикл
			Если СтрокаТабличнойЧасти.Сотрудник <> ПустойСотрудник И СтрокаТабличнойЧасти.Физлицо <> СоответствиеСотрудникФизлицо.Получить(СтрокаТабличнойЧасти.Сотрудник) Тогда
				СтрокаТабличнойЧасти.Физлицо = СоответствиеСотрудникФизлицо.Получить(СтрокаТабличнойЧасти.Сотрудник);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // ПередЗаписьюДокументаЗаполнитьФизЛицоВТабличнойЧасти()


мДлинаСуток = 86400;
