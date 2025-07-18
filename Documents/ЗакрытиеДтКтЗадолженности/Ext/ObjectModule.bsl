﻿Перем мВалютаРегламентированногоУчета Экспорт;

Перем мУчетнаяПолитикаПоНалоговомуУчету Экспорт;
Перем мУчетнаяПолитикаПоБухгалтерскомуУчету Экспорт;

Перем мОтображатьСтруктурныеПодразделения Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Процедура заполняет ТЧ Задолженность остатками по бухгалтерскому учету
//
Процедура ЗаполнитьОстатками() Экспорт
	Запрос = Новый Запрос;
	
	Если НЕ ЗначениеЗаполнено(СчетДт) ТОгда
		Сообщить("Не заполнен счет дебета!");
		возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СчетКт) ТОгда
		Сообщить("Не заполнен счет кредита!");
		возврат;
	КонецЕсли;
	
	ДтСчетРасчетовСКонтрагентами = ?(СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты)<>Неопределено,
									 ?(СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры)<>Неопределено, Истина,
									 Ложь),Ложь);
									 
	КтСчетРасчетовСКонтрагентами = ?(СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты)<>Неопределено,
									 ?(СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры)<>Неопределено, Истина,
									 Ложь),Ложь);
									 
	Если НЕ (ДтСчетРасчетовСКонтрагентами И КтСчетРасчетовСКонтрагентами) Тогда
		Сообщить("В поля счетов расчетов с контрагентами введены некорректные данные!");
		Возврат;
	КонецЕсли;
	
	ЕстьРасчетыПоДокументам = Ложь;
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ТипыОпераций);
	//Если СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами)<>Неопределено ТОгда
	//	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами);
	//	ЕстьРасчетыПоДокументам = Истина;
	//КонецЕсли;
	
 	Запрос.УстановитьПараметр("Счет", СчетДт);
	Запрос.УстановитьПараметр("Организация", Организация);
		
	УсловиеТипОперации = "";
	
	Если мОтображатьСтруктурныеПодразделения Тогда
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", СтруктурноеПодразделение);
		УсловиеСтруктурноеПодразделение = " И СтруктурноеПодразделение = &СтруктурноеПодразделение ";
	Иначе
		УсловиеСтруктурноеПодразделение = "";
	КонецЕсли;

	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	Запрос.УстановитьПараметр("ДатаОкончания", НачалоДня(Дата+86400));
	Запрос.УстановитьПараметр("ВидСчета", ВидСчета.Пассивный);
	Запрос.УстановитьПараметр("Знак", 1);
	
	Запрос.Текст = "ВЫБРАТЬ
		|	ТиповойОстатки.Субконто1 КАК Контрагент,
		|	ТиповойОстатки.Субконто2 КАК Договор,
		|	ТиповойОстатки.Субконто3 КАК ТипОперации,
		|	ТиповойОстатки.Валюта КАК Валюта,";
	Если ЕстьРасчетыПоДокументам Тогда
		//Запрос.Текст = Запрос.Текст+"
		//|	ТиповойОстатки.Субконто3 КАК Сделка,
		//|	ТиповойОстатки.Субконто3.Дата КАК ДатаСделки,";           
	Иначе
		Запрос.Текст = Запрос.Текст+"
		|	НЕОПРЕДЕЛЕНО КАК Сделка,
		|	НЕОПРЕДЕЛЕНО КАК ДатаСделки,";
	КонецЕсли; 
	Запрос.Текст = Запрос.Текст+"
		|	СУММА(ВЫБОР
		|			КОГДА ТиповойОстатки.Счет.Вид = &ВидСчета
		|				ТОГДА ВЫБОР
		|						КОГДА &Знак * ТиповойОстатки.СуммаОстаток > 0
		|							ТОГДА ТиповойОстатки.СуммаОстаток
		|						ИНАЧЕ 0
		|					КОНЕЦ
		|			ИНАЧЕ ТиповойОстатки.СуммаОстаток
		|		КОНЕЦ) КАК Сумма,
		|	СУММА(ВЫБОР
		|			КОГДА ТиповойОстатки.Счет.Вид = &ВидСчета
		|				ТОГДА ВЫБОР
		|						КОГДА &Знак * ТиповойОстатки.ВалютнаяСуммаОстаток > 0
		|							ТОГДА ТиповойОстатки.ВалютнаяСуммаОстаток
		|						ИНАЧЕ 0
		|					КОНЕЦ
		|			ИНАЧЕ ТиповойОстатки.ВалютнаяСуммаОстаток
		|		КОНЕЦ) КАК ВалютнаяСумма
		|ИЗ
		|	РегистрБухгалтерии.Типовой.Остатки(&ДатаОкончания, Счет = &Счет, &ВидыСубконто, Организация = &Организация " +УсловиеТипОперации+ УсловиеСтруктурноеПодразделение + ") КАК ТиповойОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ТиповойОстатки.Субконто1,
		|	ТиповойОстатки.Субконто2,
		|	ТиповойОстатки.Субконто3,
		|	ТиповойОстатки.Валюта,";
	Если ЕстьРасчетыПоДокументам Тогда
		//Запрос.Текст = Запрос.Текст+"
		//|	ТиповойОстатки.Субконто3,
		//|	ТиповойОстатки.Субконто3.Дата";
	Иначе
		Запрос.Текст = Запрос.Текст+"
		|	НЕОПРЕДЕЛЕНО";
	КонецЕсли;                                                         
	Запрос.Текст = Запрос.Текст+"
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСделки
		|ИТОГИ
		|	СУММА(Сумма),
		|	СУММА(ВалютнаяСумма)
		|ПО
		|	Контрагент,
		|	ТипОперации,
		|	Договор,
		|	Валюта";
	ДеревоОстатковДт = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	
	Запрос.УстановитьПараметр("Счет",СчетКт);
	Запрос.УстановитьПараметр("ВидСчета",ВидСчета.Активный);
	Запрос.УстановитьПараметр("Знак",-1);
	
	ДеревоОстатковКт = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Для ИндексКонтрагента = 0 По ДеревоОстатковДт.Строки.Количество()-1 Цикл
		СтрокаПоКонтрагентуДт = ДеревоОстатковДт.Строки[ИндексКонтрагента];
		СтрокаПоКонтрагентуКт = ДеревоОстатковКт.Строки.Найти(СтрокаПоКонтрагентуДт.Контрагент,"Контрагент", Ложь);
		Если СтрокаПоКонтрагентуКт = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для ИндексТипаОперации = 0 По СтрокаПоКонтрагентуДт.Строки.Количество()-1 Цикл
			СтрокаПоТипуОперацииДт = СтрокаПоКонтрагентуДт.Строки[ИндексТипаОперации];
			СтрокаПоТипуОперацииКт = СтрокаПоКонтрагентуКт.Строки.Найти(СтрокаПоТипуОперацииДт.ТипОперации,"ТипОперации", Ложь);
			Если СтрокаПоТипуОперацииКт = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Для ИндексДоговора = 0 По СтрокаПоТипуОперацииДт.Строки.Количество()-1 Цикл
				СтрокаПоДоговоруДт = СтрокаПоТипуОперацииДт.Строки[ИндексДоговора];
				СтрокаПоДоговоруКт = СтрокаПоТипуОперацииКт.Строки.Найти(СтрокаПоДоговоруДт.Договор,"Договор", Ложь);
				Если СтрокаПоДоговоруКт = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Для ИндексВалюты = 0 По СтрокаПоДоговоруДт.Строки.Количество()-1 Цикл
					СтрокаПоВалютеДт = СтрокаПоДоговоруДт.Строки[ИндексВалюты];
					СтрокаПоВалютеКт = СтрокаПоДоговоруКт.Строки.Найти(СтрокаПоВалютеДт.Валюта, "Валюта", Ложь);
					Если СтрокаПоВалютеКт = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					Для ИндексДеталейДт = 0 По СтрокаПоВалютеДт.Строки.Количество() - 1 Цикл
						СтрокаДеталейДт = СтрокаПоВалютеДт.Строки[ИндексДеталейДт];
						Для ИндексДеталейКт = 0 По СтрокаПоВалютеКт.Строки.Количество() - 1 Цикл
							СтрокаДеталейКт = СтрокаПоВалютеКт.Строки[ИндексДеталейКт];
							Если СтрокаДеталейДт.Сумма = 0 Тогда
								Прервать;
							КонецЕсли;
							Если СтрокаДеталейКт.Сумма = 0 Тогда
								Продолжить;
							КонецЕсли;
							Если СтрокаДеталейДт.Сумма >= 0 Тогда
								ЗнакДт = 1;
							Иначе
								ЗнакДт = -1
							КонецЕсли;
							Если СтрокаДеталейКт.Сумма >= 0 Тогда
								ЗнакКт = 1;
							Иначе
								ЗнакКт = -1
							КонецЕсли;
							Если ЗнакДт = ЗнакКт Тогда
								Продолжить;
							КонецЕсли;
							
							Сумма = ЗнакДт*МИН(СтрокаДеталейДт.Сумма*ЗнакДт,СтрокаДеталейКт.Сумма*ЗнакКт);
							СуммаВзаиморасчетов = ЗнакДт*МИН(СтрокаДеталейДт.ВалютнаяСумма*ЗнакДт,СтрокаДеталейКт.ВалютнаяСумма*ЗнакКт);
							СтрокаДеталейДт.Сумма = СтрокаДеталейДт.Сумма - Сумма*ЗнакДт;
							СтрокаДеталейКт.Сумма = СтрокаДеталейКт.Сумма - Сумма*ЗнакКт;
							СтрокаДеталейДт.ВалютнаяСумма = СтрокаДеталейДт.ВалютнаяСумма - СуммаВзаиморасчетов*ЗнакДт;
							СтрокаДеталейКт.ВалютнаяСумма = СтрокаДеталейКт.ВалютнаяСумма - СуммаВзаиморасчетов*ЗнакКт;
							
							НоваяСтрока = Задолженность.Добавить();
							НоваяСтрока.Контрагент = СтрокаДеталейДт.Контрагент;
							НоваяСтрока.ТипОперации = СтрокаДеталейДт.ТипОперации;
							НоваяСтрока.ВалютаВзаиморасчетов = СтрокаДеталейДт.Валюта;
							НоваяСтрока.ДоговорКонтрагентаДт = СтрокаДеталейДт.Договор;
							НоваяСтрока.ДоговорКонтрагентаКт = СтрокаДеталейКт.Договор;
							НоваяСтрока.СделкаПоСчетуДебета = СтрокаДеталейДт.Сделка;
							НоваяСтрока.СделкаПоСчетуКредита = СтрокаДеталейКт.Сделка;
							НоваяСтрока.Сумма = Сумма;
							НоваяСтрока.СуммаВзаиморасчетов = СуммаВзаиморасчетов;
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
Конецпроцедуры

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура();

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация, СчетДт, СчетКт");

	Если СтруктураШапкиДокумента.УчитыватьКПН Тогда
		СтруктураОбязательныхПолей.Вставить("ВидУчетаНУ");
	КонецЕсли;
		
	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Задолженность".
//
// Параметры:
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиЗадолженность(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Контрагент, ДоговорКонтрагентаДт, ДоговорКонтрагентаКт");
	
	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Задолженность",СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаЗадолженности          - таблица значений, содержащая данные для проведения и проверки ТЧ Задолженность
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаЗадолженности, Отказ, Заголовок);
    
	Для Каждого СтрокаТаблицы ИЗ ТаблицаЗадолженности Цикл
		
		Проводка = Движения.Типовой.Добавить();
		
		Проводка.Период = Дата;
		Проводка.Организация = СтруктураШапкиДокумента.Организация;
		Проводка.Содержание = "Закрытие дт/кт задолженности";
		
		Проводка.СчетДт = СтруктураШапкиДокумента.СчетКт;
		Проводка.СчетКт = СтруктураШапкиДокумента.СчетДт;
		
		Проводка.ВалютаДт = СтрокаТаблицы.Валюта;
		Проводка.ВалютаКт = СтрокаТаблицы.Валюта;
		
		Проводка.Сумма = СтрокаТаблицы.Сумма;
		Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.СуммаВал;
		Проводка.ВалютнаяСуммаКт = СтрокаТаблицы.СуммаВал;
		
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"Контрагенты", СтрокаТаблицы.Контрагент,Истина);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"Договоры",    СтрокаТаблицы.ДоговорКредит);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"ТипыОпераций",    СтрокаТаблицы.Типоперации);
		
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Контрагенты", СтрокаТаблицы.Контрагент,Истина);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"Договоры",    СтрокаТаблицы.ДоговорДебет);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт,Проводка.СубконтоКт,"ТипыОпераций",    СтрокаТаблицы.Типоперации);
		
		ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				Проводка, СтруктураШапкиДокумента.СтруктурноеПодразделение, СтруктураШапкиДокумента.СтруктурноеПодразделение);
				
		//формирование проводок по НУ
		//
		Если СтруктураШапкиДокумента.НеобходимостьОтраженияВНУ Тогда
			//если договра равны, то проводки не делаем
			Если  СтрокаТаблицы.ДоговорКредит =  СтрокаТаблицы.ДоговорДебет Тогда
				Продолжить;
			КонецЕсли;
			
			ПроводкаНУ = Движения.Налоговый.Добавить();
			
			ПроводкаНУ.Период = Дата;
			ПроводкаНУ.Организация = СтруктураШапкиДокумента.Организация;
			ПроводкаНУ.Содержание = "Закрытие дт/кт задолженности";
			
			ПроводкаНУ.СчетДт = ПроцедурыНалоговогоУчета.ПолучитьСчетРасчетовСКонтрагентомНУ();
			ПроводкаНУ.СчетКт = ПроцедурыНалоговогоУчета.ПолучитьСчетРасчетовСКонтрагентомНУ();
							
			ПроводкаНУ.Сумма = СтрокаТаблицы.Сумма;
						
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт,ПроводкаНУ.СубконтоДт,"Контрагенты", СтрокаТаблицы.Контрагент,Истина);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт,ПроводкаНУ.СубконтоДт,"Договоры",    СтрокаТаблицы.ДоговорКредит);
						
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт,ПроводкаНУ.СубконтоКт,"Контрагенты", СтрокаТаблицы.Контрагент,Истина);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт,ПроводкаНУ.СубконтоКт,"Договоры",    СтрокаТаблицы.ДоговорДебет);
						
			ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				ПроводкаНУ, СтруктураШапкиДокумента.СтруктурноеПодразделение, СтруктураШапкиДокумента.СтруктурноеПодразделение);
				
			ПроцедурыНалоговогоУчета.ВидУчетаНУ(ПроводкаНУ, СтруктураШапкиДокумента.ВидУчетаНУ);	
		КонецЕсли;
				
	КонецЦикла;

КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПередЗаписью" документа
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = Задолженность.Итог("Сумма");
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = "Проведение документа """ + СокрЛП(Ссылка) + """: ";

	// Проверка ручной корректировки
	Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
		Возврат
	КонецЕсли;
		
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// для плательщиков КПН в любом случае формируются корреспонденции по отражению в налоговом учете
	// если признак "Отражать в НУ" в документе не установлен, то формируется проводка по постоянной разнице
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоНалоговомуУчету);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль и ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата, мУчетнаяПолитикаПоБухгалтерскомуУчету);	
	СтруктураШапкиДокумента.Вставить("НеобходимостьОтраженияВНУ", 						УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ));
	СтруктураШапкиДокумента.Вставить("ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль", 	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль);
	СтруктураШапкиДокумента.Вставить("ОрганизацияПлательщикНалогаНаПрибыль", 			ОрганизацияПлательщикНалогаНаПрибыль);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Контрагент"       		    , "Контрагент");
	СтруктураПолей.Вставить("ТипОперации"       		    , "ТипОперации");
	СтруктураПолей.Вставить("ДоговорДебет"             	, "ДоговорКонтрагентаДт");
	СтруктураПолей.Вставить("ДоговорКредит"         	, "ДоговорКонтрагентаКт");
	СтруктураПолей.Вставить("СделкаДебет"        		, "СделкаПоСчетуДебета");
	СтруктураПолей.Вставить("СделкаКредит"        		, "СделкаПоСчетуКредита");

	
	СтруктураПолей.Вставить("Сумма" 	, "Сумма");
	СтруктураПолей.Вставить("Валюта" 	, "ВалютаВзаиморасчетов");
	СтруктураПолей.Вставить("СуммаВал" 	, "СуммаВзаиморасчетов");
	

	РезультатЗапросаПоЗадолженности = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Задолженность", СтруктураПолей);
	
	ТаблицаЗадолженности = РезультатЗапросаПоЗадолженности.Выгрузить();

	// Проверить заполнение ТЧ "Задолженность".
	ПроверитьЗаполнениеТабличнойЧастиЗадолженность(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаЗадолженности, Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ Отказ Тогда			
		ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ЭтотОбъект, СтруктураШапкиДокумента, Истина);
	КонецЕсли;

КонецПроцедуры

// Предопределенная процедура обработки удаления проведения документа
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();