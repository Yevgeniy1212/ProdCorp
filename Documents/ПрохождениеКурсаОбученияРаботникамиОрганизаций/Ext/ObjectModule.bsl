﻿
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
			
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПрохождениеКурсаОбучения") Тогда
		
		// Заполнение шапки
		// Заполним реквизиты из стандартного набора.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

		КурсОбучения 		= Основание.КурсОбучения;
		ФактЗавершенияКурса = Основание.ФактЗавершенияКурса;
		ДатаЗавершенияКурса = Основание.ДатаЗавершенияКурса;
		
		// Заполнение табличной части. 
		Для Каждого ТекСтрокаОбучающиесяРаботники Из Основание.ОбучающиесяРаботники Цикл
			НоваяСтрока = ОбучающиесяРаботники.Добавить();
			НоваяСтрока.Сотрудник 				= ТекСтрокаОбучающиесяРаботники.Сотрудник;
			НоваяСтрока.ФизЛицо 				= ТекСтрокаОбучающиесяРаботники.ФизЛицо;
			НоваяСтрока.ДатаПолученияДокумента	= ТекСтрокаОбучающиесяРаботники.ДатаПолученияДокумента;
			НоваяСтрока.РеквизитыДокумента		= ТекСтрокаОбучающиесяРаботники.РеквизитыДокумента;
		КонецЦикла;
	КонецЕсли;
	
	ДокументОснование = Основание;
	
КонецПроцедуры // ОбработкаЗаполненияУпр()

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
	|ВЫБРАТЬ 
	|	ВЫБОР 
	|		КОГДА Организация.ГоловнаяОрганизация = &ПустаяОрганизация ТОГДА Организация 
	|		ИНАЧЕ Организация.ГоловнаяОрганизация 
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	КурсОбучения,
	|   Дата, 
	| 	Ссылка,
	|	ЦельПрохожденияКурсаОбучения,
	|	ДатаЗавершенияКурса,
	|	ФактЗавершенияКурса
	|ИЗ 
	|	Документ." + Метаданные().Имя + "
	|ГДЕ 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "Кандидаты" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса. В запросе данные документа дополняются значениями
//  проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоОбучающиесяРаботники(Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	// угловыми скобками выделены изменяющиеся фрагменты текста запроса
	Запрос.Текст = "ВЫБРАТЬ
	               |	Док.ФизЛицо,
	               |	Док.НомерСтроки КАК НомерСтроки,
	               |	Док.ДатаПолученияДокумента,
	               |	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрокаНомер,
	               |	Док.РеквизитыДокумента
	               |ИЗ
	               |	Документ.ПрохождениеКурсаОбученияРаботникамиОрганизаций.ОбучающиесяРаботники КАК Док
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПрохождениеКурсаОбученияРаботникамиОрганизаций.ОбучающиесяРаботники КАК ПересекающиесяСтроки
	               |		ПО Док.Ссылка = ПересекающиесяСтроки.Ссылка
	               |			И Док.ФизЛицо = ПересекающиесяСтроки.ФизЛицо
	               |			И Док.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
	               |ГДЕ
	               |	Док.Ссылка = &ДокументСсылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Док.НомерСтроки,
	               |	Док.ФизЛицо,
	               |	Док.ДатаПолученияДокумента,
	               |	Док.РеквизитыДокумента";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоКандидаты()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ГоловнаяОрганизация) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении("Не выбрана организация!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ЦельПрохожденияКурсаОбучения) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении("Не выбрана цель обучения!", Отказ, Заголовок);
	КонецЕсли;

	// Заполнение Курса
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.КурсОбучения) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении("Не выбран курс обучения!", Отказ, Заголовок);
	КонецЕсли;

    Если ВыборкаПоШапкеДокумента.ФактЗавершенияКурса И НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаЗавершенияКурса) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении("Установлен флаг завершения курса, но дата завершения курса не выбрана!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "ОбучающиесяРаботники" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по кандидатам, 
//  Отказ 						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиТабличнойЧасти(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Обучающиеся сотрудники"": ";
	
	// ФизЛицо
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) Тогда
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;

	// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
		СтрокаСообщениеОбОшибке = "сотрудник не может быть указан в документе дважды (см. строку " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
		ОбщегоНазначения.ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;	
		
		
КонецПроцедуры // ПроверитьЗаполнениеСтрокиКандидата()

// Создает и заполняет структуру, содержащую имена регистров сведений 
//  по которым надо проводить документ
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров сведений 
//                                           по которым надо проводить документ
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	
	СтруктураПроведенияПоРегистрамСведений.Вставить("ПройденныеУчебныеКурсыРаботникамиОрганизаций");
	

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

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
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, 
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ПройденныеУчебныеКурсыРаботникамиОрганизаций";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период                    = ВыборкаПоШапкеДокумента.ДатаЗавершенияКурса;
		
		// Измерения
		Движение.ФизЛицо	               = ВыборкаПоСтрокамДокумента.ФизЛицо;
		Движение.КурсОбучения      	       = ВыборкаПоШапкеДокумента.КурсОбучения;
		Движение.Организация      	       = ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
		
		// Ресурсы
		Движение.ЦельПрохожденияКурсаОбучения = ВыборкаПоШапкеДокумента.ЦельПрохожденияКурсаОбучения;		
			
        // Реквизиты		
		Если ЗначениеЗаполнено(КурсОбучения.ВидДокументаОбОбразовании) 
		   И ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаПолученияДокумента) Тогда
				
			Движение.ДокументОбОбразовании     = КурсОбучения.ВидДокументаОбОбразовании;
		    Движение.НомерДокумента            = ВыборкаПоСтрокамДокумента.РеквизитыДокумента;
			Движение.ДатаДокумента             = ВыборкаПоСтрокамДокумента.ДатаПолученияДокумента;
		
		КонецЕсли;
		
			
	КонецЕсли; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
    Перем СтруктураПроведенияПоРегистрамНакопления;
	
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

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);
		
			// Учтем факт прохождения обучения.
			Если ВыборкаПоШапкеДокумента.ФактЗавершенияКурса Тогда

				// получим реквизиты табличной части
				РезультатЗапросаПоСтрокамТабличнойЧасти = СформироватьЗапросПоОбучающиесяРаботники(Режим);
				ВыборкаПоСтрокамТЧ = РезультатЗапросаПоСтрокамТабличнойЧасти.Выбрать();

				Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл 

					// проверим очередную строку табличной части
					ПроверитьЗаполнениеСтрокиТабличнойЧасти(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамТЧ, Отказ, Заголовок);

					Если НЕ Отказ Тогда
						// Заполним записи в наборах записей регистров
						ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамТЧ, СтруктураПроведенияПоРегистрамСведений);
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли; // Проводка результатов обучения
			
		КонецЕсли; 

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	
	ЗаполнитьПоДокументуОснования(Основание);	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(ОбучающиесяРаботники);

	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ);
	
КонецПроцедуры
