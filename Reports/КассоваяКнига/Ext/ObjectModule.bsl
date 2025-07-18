﻿#Если Клиент Тогда
	
Перем НП Экспорт;
Перем мВалютаРегламентированногоУчета;

Процедура ДобавитьОбороты(РабочаяТаблица, Валюта, ВалПриход, Приход, ВалРасход, Расход)

	СтрокаТаблицы = РабочаяТаблица.Найти(Валюта, "Валюта");

	Если СтрокаТаблицы = Неопределено Тогда

		НоваяСтрока = РабочаяТаблица.Добавить();

		НоваяСтрока.Валюта     = Валюта;
		НоваяСтрока.ВалОстаток = 0;
		НоваяСтрока.Остаток    = 0;
		НоваяСтрока.ВалПриход  = ВалПриход; 
		НоваяСтрока.Приход     = Приход;
		НоваяСтрока.ВалРасход  = ВалРасход;
		НоваяСтрока.Расход     = Расход;

	Иначе

		СтрокаТаблицы.ВалПриход = СтрокаТаблицы.ВалПриход + ВалПриход; 
		СтрокаТаблицы.Приход    = СтрокаТаблицы.Приход    + Приход;
		СтрокаТаблицы.ВалРасход = СтрокаТаблицы.ВалРасход + ВалРасход;
		СтрокаТаблицы.Расход    = СтрокаТаблицы.Расход    + Расход;

	КонецЕсли;

КонецПроцедуры 

Функция ПроверкаПериода()

	ПроверкаПройдена = Истина;
	
	Если ДатаНач > ДатаКон Тогда

		Предупреждение("Неправильно задан период формирования отчета!" + Символы.ПС +
					   "Дата начала больше даты окончания периода.");

		ПроверкаПройдена = Ложь;

	ИначеЕсли ДатаНач = '00010101' Тогда

		Предупреждение("Не указана дата начала отчета");

		ПроверкаПройдена = Ложь;

	ИначеЕсли ДатаКон = '00010101' Тогда

		Предупреждение("Не указана дата конца отчета");

		ПроверкаПройдена=Ложь;

	КонецЕсли;

	Возврат ПроверкаПройдена;

КонецФункции // ПроверкаПериода()

// Функция возвращает номер входного номера листа кассовой книги на начало периода
//
Функция ПолучитьНомерНачальногоЛиста()

	ЛистовЗаГод   = 0;
	НачалоГода = НачалоГода(ДатаНач);
	Если ПересчитатьНомера Тогда

		Номера = РегистрыСведений.НомераЛистовКассовойКниги.СоздатьНаборЗаписей();
		Номера.Отбор.Касса.Значение		= Касса;
		Номера.Отбор.Касса.Использование	= Истина;
		Номера.Прочитать();
		Номера.Очистить();
		Если ПравоДоступа("Изменение", Номера.Метаданные()) Тогда
			Номера.Записать();
		КонецЕсли;

	Иначе
		Если ДатаНач <> НачалоГода Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Дата", ДатаНач-86400);
			Запрос.УстановитьПараметр("Касса", Касса);
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Период,
			|	Касса,
			|	НомерЛиста
			|ИЗ
			|	РегистрСведений.НомераЛистовКассовойКниги.СрезПоследних(&Дата, Касса = &Касса) КАК НомераЛистовКассовойКнигиСрезПоследних";
			Номера = Запрос.Выполнить().Выгрузить();
			
			Если Номера.Количество()>0 Тогда
				Если Номера[0].Период >= НачалоГода Тогда
					ЛистовЗаГод = Номера[0].НомерЛиста;			
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЛистовЗаГод;
	
КонецФункции	

// Возвращает структуру значений
// ГлавныйБухгалтер и Кассир с учетом данных регистров "Ответственные лица" и "Ответственные лица организаций"
Функция ПолучитьОтветственныхЛиц(ДатаЛиста)
	СтруктураРезультата = Новый Структура("ГлавныйБухгалтер, Кассир");
	
	Руководители = ОбщегоНазначения.ОтветственныеЛицаОрганизаций(Организация, КонецДня(ДатаЛиста),);
	СтруктураРезультата.ГлавныйБухгалтер = Руководители.ГлавныйБухгалтер;
	СтруктураРезультата.Кассир = Руководители.Кассир;
	
	// Если для Кассы установлен кассир, то приоритет этого значения Выше		
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&Период, СтруктурнаяЕдиница = &СтруктурнаяЕдиница И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Кассир)) КАК ОтветственныеЛицаОрганизаций";
	
	Запрос.УстановитьПараметр("Период", КонецДня(ДатаЛиста));
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Касса);
	
	СрезПоследних = Запрос.Выполнить().Выгрузить();
	
	
	Если СрезПоследних.Количество() > 0 Тогда		
		СтруктураРезультата.Кассир = ОбщегоНазначения.ФамилияИнициалыФизЛица(СрезПоследних[0].ФизическоеЛицо);
	КонецЕсли;
	
    Возврат СтруктураРезультата;
КонецФункции	

// Выводит данные в табличный документ
// в соответствии снастройкой печати разделов кассовой книги.
Процедура ВывестиДанныеВОтчет(ДокументРезультат, ОбластьВкладнойЛист, ОбластьОтчетКассира)
	// Вывод раздела "Вкладной лист кассовой книги"
	Если ПечататьВкладнойЛист Тогда							
		ДокументРезультат.Вывести(ОбластьВкладнойЛист);
	КонецЕсли;
	
	// Вывод раздела "Отчет кассира"
	Если ПечататьОтчетКассира Тогда							
		Если ПечататьВкладнойЛист Тогда					
			ДокументРезультат.Присоединить(ОбластьОтчетКассира);		
		Иначе
			ДокументРезультат.Вывести(ОбластьОтчетКассира);		
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // ВывестиДанныеВОтчет()

// Процедура - выводит шапку таблицы
//
Процедура ВывестиШапкуОтчета(ДокументРезультат, ДатаЛиста, НомерЛиста, ТекущийОстаток, ОбластьВкладнойЛистОтчет, ОбластьОтчетКассираОтчет, ОбластьШапкаОтчет, ОбластьОстатокНаНДОтчет)
		
	// Вывод Шапки листа
	ПериодЛистаСтрокой = "КАССА" + ?(ВыводитьНазваниеКассы, ": " + СокрЛП(Касса.Наименование),"")+ " " + ?(РазбиватьЛистыПоДням, "за " + Формат(ДатаЛиста, "ДФ=dd.MM.yyyy"),
						 "за период с " + Формат(ДатаНач, "ДФ=dd.MM.yyyy") + " по " + Формат(ДатаКон, "ДФ=dd.MM.yyyy"));		
						 
	ОбластьВкладнойЛистОтчет.Параметры.ЗаголовокЛиста = ПериодЛистаСтрокой;							
	ОбластьОтчетКассираОтчет.Параметры.ЗаголовокЛиста = ПериодЛистаСтрокой;
	
	ВывестиДанныеВОтчет(ДокументРезультат, ОбластьВкладнойЛистОтчет, ОбластьОтчетКассираОтчет);
	
	ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста 	= "Лист " + НомерЛиста;
	ОбластьШапкаОтчет.Параметры.ВалютаПредставление = Касса.ВалютаДенежныхСредств.Наименование;
	
	ВывестиДанныеВОтчет(ДокументРезультат, ОбластьШапкаОтчет, ОбластьШапкаОтчет);
	
	ОбластьОстатокНаНДОтчет.Параметры.ОстатокНачало =   ТекущийОстаток;	
	ВывестиДанныеВОтчет(ДокументРезультат, ОбластьОстатокНаНДОтчет, ОбластьОстатокНаНДОтчет);
	
КонецПроцедуры  // ВывестиШапкуОтчета


// Процедура - выводит подвал таблицы
//
Процедура ВывестиПодвалОтчета(ДокументРезультат,ТекущийОстаток, ДатаЛиста, НомерЛиста, КоличествоПриходныхДокументов, КоличествоРасходныхДокументов,
	ОбластьОборотОтчет, ОбластьКонечныйОстатокОтчет,ОбластьПодвалОтчет)
	
	// итоги за день - Обороты	
	ВывестиДанныеВОтчет(ДокументРезультат, ОбластьОборотОтчет, ОбластьОборотОтчет);
	
	// итоги за день - Остаток
	ОбластьКонечныйОстатокОтчет.Параметры.ОстатокКонец = ТекущийОстаток;		
	ВывестиДанныеВОтчет(ДокументРезультат, ОбластьКонечныйОстатокОтчет, ОбластьКонечныйОстатокОтчет);
	
	// итоги за день - подписи
	ОбластьПодвалОтчет.Параметры.НадписьКолПриходных = ?(КоличествоПриходныхДокументов > 0, ЧислоПрописью(КоличествоПриходныхДокументов,"НД=Ложь",",,,,,,,,0")," - ");																
	ОбластьПодвалОтчет.Параметры.НадписьКолРасходных = ?(КоличествоРасходныхДокументов > 0, ЧислоПрописью(КоличествоРасходныхДокументов,"НД=Ложь",",,,,,,,,0")," - ");	
	
	Руководители = ПолучитьОтветственныхЛиц(ДатаЛиста);
	
	ОбластьПодвалОтчет.Параметры.ГлБухгалтер 	= Руководители.ГлавныйБухгалтер;
	ОбластьПодвалОтчет.Параметры.Кассир 		= Руководители.Кассир;
	
	ВывестиДанныеВОтчет(ДокументРезультат, ОбластьПодвалОтчет, ОбластьПодвалОтчет);
	
	ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	
	// обновление номера листа
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ДатаЛиста);
	Запрос.УстановитьПараметр("Касса", Касса);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Касса,
	|	НомерЛиста
	|ИЗ
	|	РегистрСведений.НомераЛистовКассовойКниги.СрезПоследних(&Дата, Касса = &Касса) КАК НомераЛистовКассовойКнигиСрезПоследних";
	ТекНомера = Запрос.Выполнить().Выгрузить();
	
	Если ТекНомера.Количество() = 0 ИЛИ ТекНомера[0].НомерЛиста <> НомерЛиста Тогда
		
		Номера = РегистрыСведений.НомераЛистовКассовойКниги.СоздатьНаборЗаписей();
		
		Номера.Отбор.Касса.Значение 			= Касса; 
		Номера.Отбор.Касса.Использование  		= Истина;
		
		Номера.Отбор.Период.Значение 			= ДатаЛиста; 
		Номера.Отбор.Период.Использование 		= Истина; 
		
		НоваяЗапись = Номера.Добавить();
		
		НоваяЗапись.Касса		= Касса;
		НоваяЗапись.Период 		= ДатаЛиста;
		НоваяЗапись.НомерЛиста 	= НомерЛиста;				
		Если ПравоДоступа("Изменение", Номера.Метаданные()) Тогда
			Номера.Записать();
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры  // ВывестиПодвалОтчета

// Формирование отчета
Процедура СформироватьОтчет(ДокументРезультат) Экспорт
	
	// Стандартные проверки
	Отказ = НЕ ПроверкаПериода();	
	
	Если Организация.Пустая() Тогда
		Сообщить("Не выбрана организация.", СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;
	
	Если Касса.Пустая() Тогда
		Сообщить("Не выбрана касса.", СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;
	
	// Отчет для которого не заданы разделы для печати нет смысла формировать
	Если НЕ ПечататьВкладнойЛист И НЕ ПечататьОтчетКассира Тогда
		Сообщить("Не выбраны разделы отчета для печати.", СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
		
	ДокументРезультат.Очистить();	
	НомерЛиста = ПолучитьНомерНачальногоЛиста();

	Макет = ПолучитьМакет("КассоваяКнига");
	
	ОбластьВкладнойЛистОтчет 			= Макет.ПолучитьОбласть("ВкладнойЛист|Отчет");
	ОбластьОтчетКассираОтчет 			= Макет.ПолучитьОбласть("ОтчетКассира|Отчет");
	ОбластьШапкаОтчет 					= Макет.ПолучитьОбласть("Шапка|Отчет");
	ОбластьОстатокНаНДОтчет 			= Макет.ПолучитьОбласть("ОстатокНаНД|Отчет");
	ОбластьСтрокаОтчет 					= Макет.ПолучитьОбласть("Строка|Отчет");
	ОбластьОборотОтчет 					= Макет.ПолучитьОбласть("Оборот|Отчет");
	ОбластьКонечныйОстатокОтчет 		= Макет.ПолучитьОбласть("КонечныйОстаток|Отчет");
	ОбластьПодвалОтчет 					= Макет.ПолучитьОбласть("Подвал|Отчет");
	
	
	СписокСчетовКассы = Новый СписокЗначений();
	СписокСчетовКассы.Добавить(ПланыСчетов.Типовой.ДенежныеСредстваВКассе);
	ОтчетВВалюте = НЕ Касса.ВалютаДенежныхСредств.Пустая() И НЕ Касса.ВалютаДенежныхСредств = мВалютаРегламентированногоУчета;
	ИмяРесурса = ?(ОтчетВВалюте, ".ВалютнаяСумма", ".Сумма");
	
	ЗапросПоОстаткам = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                                |	СУММА(ТиповойОстатки" + ИмяРесурса + "Остаток) КАК СуммаОстаток
	                                |ИЗ
	                                |	РегистрБухгалтерии.Типовой.Остатки(
	                                |		&ДатаНач,
	                                |		Счет В ИЕРАРХИИ (&СчетаКассы),
	                                |		&ВидСубконтоКасса,
	                                |		Организация = &Организация
	                                |			И Субконто1 = &Касса
	                                |			И ((НЕ &ВВалюте)
	                                |				ИЛИ Валюта = &Валюта)) КАК ТиповойОстатки");
									
	ЗапросПоОстаткам.УстановитьПараметр("ДатаНач",			ДатаНач);	
	ЗапросПоОстаткам.УстановитьПараметр("ВВалюте", 			ОтчетВВалюте);
	ЗапросПоОстаткам.УстановитьПараметр("Валюта", 			Касса.ВалютаДенежныхСредств);		
	ЗапросПоОстаткам.УстановитьПараметр("СчетаКассы", 		СписокСчетовКассы);
	ЗапросПоОстаткам.УстановитьПараметр("ВидСубконтоКасса", ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДенежныеСредства);
	ЗапросПоОстаткам.УстановитьПараметр("Организация", 		Организация);
	ЗапросПоОстаткам.УстановитьПараметр("Касса", 			Касса);									
	
	ТекущийОстаток = 0;
	Результат = ЗапросПоОстаткам.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ВыборкаПоОстаткам = Результат.Выбрать();
		ВыборкаПоОстаткам.Следующий();
		ТекущийОстаток = ВыборкаПоОстаткам.СуммаОстаток;
	КонецЕсли;	
									
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	НАЧАЛОПЕРИОДА(ТиповойОбороты.Период, ДЕНЬ) КАК Период,
	                      |	ТиповойОбороты.Регистратор КАК Документ,
						  |	ТиповойОбороты.Регистратор.Дата КАК ДатаДокумента,
						  |	ТиповойОбороты.Регистратор.Номер КАК НомерДокумента,
	                      |	ПРЕДСТАВЛЕНИЕ(ТиповойОбороты.Регистратор) КАК ПредставлениеДокумента,
	                      |	ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0) КАК Приход,
	                      |	ЕСТЬNULL(ТиповойОбороты.СуммаОборотКт, 0) КАК Расход,
	                      |	ВЫБОР
	                      |		КОГДА ТиповойОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	                      |			ТОГДА ВЫРАЗИТЬ(ТиповойОбороты.Регистратор.ПринятоОт КАК СТРОКА(1000))
	                      |		КОГДА ТиповойОбороты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	                      |			ТОГДА ВЫРАЗИТЬ(ТиповойОбороты.Регистратор.Выдать КАК СТРОКА(1000))
	                      |	КОНЕЦ КАК Контрагент,
	                      |	ПРЕДСТАВЛЕНИЕ(ТиповойОбороты.КорСчет) КАК ПредставлениеСчета,
	                      |	ВЫБОР
	                      |		КОГДА &ВыводитьОснования
	                      |			ТОГДА ВЫБОР
	                      |					КОГДА ТиповойОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	                      |							ИЛИ ТиповойОбороты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	                      |						ТОГДА ВЫРАЗИТЬ(ТиповойОбороты.Регистратор.Основание КАК СТРОКА(1000))
	                      |				КОНЕЦ
	                      |	КОНЕЦ КАК Основание,
	                      |	ВЫБОР
	                      |		КОГДА ТиповойОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	                      |			ТОГДА 1
	                      |		КОГДА ТиповойОбороты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	                      |			ТОГДА 2
	                      |		ИНАЧЕ 3
	                      |	КОНЕЦ КАК ИндексСортировкиВида
	                      |ИЗ
	                      |	РегистрБухгалтерии.Типовой.Обороты(
	                      |		&ДатаНач,
	                      |		&ДатаКон,
	                      |		Регистратор,
	                      |		Счет В ИЕРАРХИИ (&СчетаКассы),
	                      |		&ВидСубконтоКасса,
	                      |		Организация = &Организация
	                      |		    И Субконто1 = &Касса
	                      |		    И ((НЕ &ВВалюте)
	                      |		        ИЛИ Валюта = &Валюта),
	                      |		,
	                      |		) КАК ТиповойОбороты
	                      |
	                      |УПОРЯДОЧИТЬ ПО ТиповойОбороты.Регистратор.Дата
	                      |ИТОГИ
	                      |	СУММА(Приход),
	                      |	СУММА(Расход)
	                      |ПО
						  |	Период,
	                      |	Документ
	                      |АВТОУПОРЯДОЧИВАНИЕ");	
	
	// Настройка текста запроса в соответствии с настройками пользователя					  
	Запрос.Текст = СтрЗаменить(Запрос.Текст, ".Сумма", ИмяРесурса);
	Если НЕ РазбиватьЛистыПоДням Тогда		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "НАЧАЛОПЕРИОДА(ТиповойОбороты.Период, ДЕНЬ)", "&ДатаНач");
	КонецЕсли;	
					
	Если СортироватьПоВиду ИЛИ СортироватьПоНомеру Тогда
		БлокСортировки = "УПОРЯДОЧИТЬ ПО НАЧАЛОПЕРИОДА(ТиповойОбороты.Регистратор.Дата, ДЕНЬ)" + 
						?(СортироватьПоВиду  , ", ИндексСортировкиВида", "") + 
						?(СортироватьПоНомеру, ", НомерДокумента", "");
	Иначе
		БлокСортировки = "УПОРЯДОЧИТЬ ПО НАЧАЛОПЕРИОДА(ТиповойОбороты.Регистратор.Дата, ДЕНЬ), ДатаДокумента";
	КонецЕсли;
					
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "УПОРЯДОЧИТЬ ПО ТиповойОбороты.Регистратор.Дата",БлокСортировки); 
	
	// установка параетров запроса	
	Запрос.УстановитьПараметр("ДатаНач",			ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон",			КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("ВВалюте",			ОтчетВВалюте);
	Запрос.УстановитьПараметр("Валюта", 			Касса.ВалютаДенежныхСредств);		
	Запрос.УстановитьПараметр("СчетаКассы", 		СписокСчетовКассы);
	Запрос.УстановитьПараметр("ВидСубконтоКасса", 	ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДенежныеСредства);
	Запрос.УстановитьПараметр("Организация", 		Организация);
	Запрос.УстановитьПараметр("Касса", 				Касса);
	Запрос.УстановитьПараметр("ВыводитьОснования", 	ВыводитьОснования);
	
	// обработка результата запроса
	Результат = Запрос.Выполнить();	
	
	Если Результат.Пустой() Тогда
		// Выводим только шапку таблицы
		НомерЛиста = НомерЛиста + 1;

		ДатаЛиста = ДатаНач;
		ВывестиШапкуОтчета(ДокументРезультат, ДатаЛиста, НомерЛиста, ТекущийОстаток, ОбластьВкладнойЛистОтчет, ОбластьОтчетКассираОтчет, ОбластьШапкаОтчет, ОбластьОстатокНаНДОтчет);
		ВывестиПодвалОтчета(ДокументРезультат,ТекущийОстаток, ДатаЛиста, НомерЛиста, 0, 0,
							ОбластьОборотОтчет, ОбластьКонечныйОстатокОтчет,ОбластьПодвалОтчет)

	Иначе			
		// Были движения за период
		ВыборкаПериоды = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПериоды.Следующий() Цикл
			Если ВыборкаПериоды.Приход = 0 И ВыборкаПериоды.Расход = 0 Тогда
				Продолжить;
			КонецЕсли;
			ДатаЛиста = ВыборкаПериоды.Период;
			КоличествоРасходныхДокументов = 0;				
			КоличествоПриходныхДокументов = 0;
			
			НомерЛиста = НомерЛиста + 1;
			// Вывод Шапки листа
			ВывестиШапкуОтчета(ДокументРезультат, ДатаЛиста, НомерЛиста, ТекущийОстаток, ОбластьВкладнойЛистОтчет, ОбластьОтчетКассираОтчет, ОбластьШапкаОтчет, ОбластьОстатокНаНДОтчет);	
						
			// По документам
			ВыборкаДокументы = ВыборкаПериоды.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			КоличествоСтрок = ВыборкаДокументы.Количество();
			НомерСтроки = 0;
			Пока ВыборкаДокументы.Следующий() Цикл
				Если ВыборкаДокументы.Приход = 0 И ВыборкаДокументы.Расход = 0 Тогда
					Продолжить;
				КонецЕсли;
				НомерСтроки = НомерСтроки + 1;
				
				// Проверим вывод
				МассивСтрок = Новый Массив;
				МассивСтрок.Добавить(ОбластьСтрокаОтчет);
				//если строка последняя, то нужно проверить не только его помещение на листе,
				//но и сроки по оборотам, остатку и подвалу
				Если НомерСтроки = КоличествоСтрок Тогда					
					МассивСтрок.Добавить(ОбластьОборотОтчет);
					МассивСтрок.Добавить(ОбластьКонечныйОстатокОтчет);
					МассивСтрок.Добавить(ОбластьПодвалОтчет);
				КонецЕсли;
				
				Если НЕ УниверсальныеМеханизмы.ПроверитьВыводДляТабличногоДокумента(ДокументРезультат, МассивСтрок) Тогда
					НомерЛиста = НомерЛиста + 1;
					ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста = "Лист " + НомерЛиста;
					
					ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
					ВывестиДанныеВОтчет(ДокументРезультат, ОбластьШапкаОтчет, ОбластьШапкаОтчет);
				КонецЕсли;
				
				Если НомераДокументовПоПараметрамУчета Тогда
				    НомерДокумента = ОбщегоНазначения.ПолучитьНомерНаПечать(ВыборкаДокументы.Документ);
				Иначе
				    НомерДокумента = СокрЛП(ВыборкаДокументы.НомерДокумента);
				КонецЕсли;
				
				ПредставлениеДокумента = СокрЛП(ВыборкаДокументы.Документ.Метаданные().Синоним) + " № " + НомерДокумента + " от " + Формат(ВыборкаДокументы.ДатаДокумента, "ДФ=дд.ММ.гг");			
				ОбластьСтрокаОтчет.Параметры.Заполнить(ВыборкаДокументы);
				ОбластьСтрокаОтчет.Параметры.НомерДокПечатнойФормы = ПредставлениеДокумента;
				
				ОбластьСтрокаОтчет.Параметры.Контрагент = СокрЛП(ВыборкаДокументы.Контрагент) + " "+ СокрЛП(ВыборкаДокументы.Основание);
				
				// По счетам
				ВыборкаСчета = ВыборкаДокументы.Выбрать();
				СчетаСтрокой = "";
				Пока ВыборкаСчета.Следующий() Цикл
					СчетаСтрокой = СчетаСтрокой + "," + СокрЛП(ВыборкаСчета.ПредставлениеСчета);
				КонецЦикла;	
				// Обрезаем первую запятую
				СчетаСтрокой = Сред(СчетаСтрокой,2);
				ОбластьСтрокаОтчет.Параметры.КоррСчет = СчетаСтрокой;
				
				ВывестиДанныеВОтчет(ДокументРезультат, ОбластьСтрокаОтчет, ОбластьСтрокаОтчет);
				
				Если ВыборкаДокументы.Расход <> 0 Тогда
					КоличествоРасходныхДокументов = КоличествоРасходныхДокументов + 1;				
				Иначе				
					КоличествоПриходныхДокументов = КоличествоПриходныхДокументов + 1;
				КонецЕсли;	
			КонецЦикла;// Выборка периодов
			// итоги за день - Обороты
			ОбластьОборотОтчет.Параметры.Заполнить(ВыборкаПериоды);
			
			// итоги за день - Остаток
			ТекущийОстаток = ТекущийОстаток + ВыборкаПериоды.Приход - ВыборкаПериоды.Расход;		
			ОбластьКонечныйОстатокОтчет.Параметры.ОстатокКонец = ТекущийОстаток;		
				
			
			ВывестиПодвалОтчета(ДокументРезультат,ТекущийОстаток, ДатаЛиста, НомерЛиста, КоличествоПриходныхДокументов, КоличествоРасходныхДокументов,
							ОбластьОборотОтчет, ОбластьКонечныйОстатокОтчет,ОбластьПодвалОтчет)
										
		КонецЦикла; // Выборка периодов
	КонецЕсли;

	Если ПечататьТитульныйЛист ТОгда
		ЛистовЗаГод = НомерЛиста;
		СформироватьТитульныйЛист(ЛистовЗаГод);
	КонецЕсли;	
КонецПроцедуры	

// Формирование обложки книги
Процедура СформироватьТитульныйЛист(ЛистовЗаГод)
	
	// Печать обложки и титульного листа
	Т1			   		  = Новый ТабличныйДокумент;
	Т1.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Макет1 		   		  = ПолучитьМакет("Обложка");
	ОбластьОбложка		  = Макет1.ПолучитьОбласть("Обложка");
	
	СведенияОбОрганизации = ОбщегоНазначения.СведенияОЮрФизЛице(Организация, КонецДня(ДатаКон));
	ТекстРНН_БИН 		  = "";
	
	ОбластьОбложка.Параметры.НазваниеОрганизации = ?(Организация.НаименованиеПолное="",Организация.Наименование,Организация.НаименованиеПолное);
	ОбластьОбложка.Параметры.РНН_БИН			 = ОбщегоНазначения.ОписаниеОрганизации(СведенияОбОрганизации, "БИН_ИИН,", Ложь, КонецДня(ДатаКон), "ru");
	ОбластьОбложка.Параметры.НадписьОбложка 	 = " на " + Формат(Год(ДатаКон), "ЧГ=0") + " г.";
	Т1.Вывести(ОбластьОбложка);
	// Последний лист кассовой книги	
	ОбластьПослДеньГода = Макет1.ПолучитьОбласть("ПослДеньГода");
	
	Руководители = ОбщегоНазначения.ОтветственныеЛицаОрганизаций(Организация, КонецДня(ДатаКон),);
	
	ОбластьПослДеньГода.Параметры.ГлБухгалтер  = Руководители.ГлавныйБухгалтер;
	ОбластьПослДеньГода.Параметры.Руководитель = Руководители.Руководитель;
	Т1.Вывести(ОбластьПослДеньГода);
	Т1.ОтображатьСетку	   = Ложь;
	Т1.ОтображатьЗаголовки = Ложь;
	
	Т1.Показать("Обложка и титульный лист кассовой книги","");
КонецПРоцедуры


НП = Новый НастройкаПериода;
мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

#КонецЕсли