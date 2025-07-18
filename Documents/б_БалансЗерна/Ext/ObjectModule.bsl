﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мВалютаРегламентированногоУчета Экспорт;

#Если Клиент Тогда
	
// Функция формирует табличный документ унифицированной формы З-8
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Табличный документ по форме З-8.
//
Функция Печатьтаблицы(ТабДокумент,имяМакета)
	Запрос = Новый Запрос;
	ЗапросКСтатьям = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организация,
	|	б_РасчетнаяТаблица.ФормируемыйБюджет КАК ФормируемыйБюджет,
	|	б_РасчетнаяТаблица.Сценарий КАК Сценарий,
	|	б_РасчетнаяТаблица.ПериодПланирования КАК ПериодПланирования,
	|	б_РасчетнаяТаблица.Номенклатура КАК Номенклатура,
	|	б_РасчетнаяТаблица.Период КАК Период,
	|	б_РасчетнаяТаблица.Страна КАК Страна,
	|	б_РасчетнаяТаблица.Количество КАК Количество,
	|	б_РасчетнаяТаблица.КоличествоВагонов КАК КоличествоВагонов
	|ИЗ
	|	Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации КАК б_РасчетнаяТаблица
	|ГДЕ
	|	б_РасчетнаяТаблица.ссылка = &ТекущийДокумент
	|";
	
	ЗапросШапка = Запрос.Выполнить().Выбрать();
	
	ЗапросШапка.Следующий();
	
	
 	ЗапросКСтатьям.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	
	ЗапросКСтатьям.Текст =
	"ВЫБРАТЬ
	|		б_РасчетнаяТаблица.НомерСтроки,
	|		б_РасчетнаяТаблица.СтанцияНазначения,
	|		б_РасчетнаяТаблица.СтатьяБюджета,
	|		б_РасчетнаяТаблица.Наименование,
	|		б_РасчетнаяТаблица.Цена,
	|		б_РасчетнаяТаблица.Количество,
	|		б_РасчетнаяТаблица.КоличествоВагонов,
	|		б_РасчетнаяТаблица.Коэффициент,
	|		б_РасчетнаяТаблица.СуммаБезНДС,
	|		б_РасчетнаяТаблица.Сумма
	|ИЗ
	|	Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации.РасчетнаяТаблица КАК б_РасчетнаяТаблица
	|ГДЕ
	|	б_РасчетнаяТаблица.ссылка = &ТекущийДокумент
	|Итоги 	
	|		Сумма(СуммаБезНДС),
	|		Сумма(Сумма)
	|ПО Общие
	|";	
	
		Результат = ЗапросКСтатьям.Выполнить();
	Макет = ПолучитьМакет(ИмяМакета);
	
	// Зададим параметры макета
	ТабДокумент.ПолеСверху         = 0;
	ТабДокумент.ПолеСлева          = 10;
	ТабДокумент.ПолеСнизу          = 0;
	ТабДокумент.ПолеСправа         = 0;
    ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасчетнаяТаблица";
	
	// Выводим шапку накладной
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = СокрЛП(ЗапросШапка.ФормируемыйБюджет)+" :"+ДополнительныеПоБюджетированию.ПолучитьНадписьПериодаСтрокой(ЗапросШапка.ПериодПланирования,ЗапросШапка.Сценарий);
	ОбластьМакета.Параметры.Номенклатура = СокрЛП(ЗапросШапка.Номенклатура.НаименованиеПолное);
	ОбластьМакета.Параметры.Страна = СокрЛП(ЗапросШапка.Страна);
	ОбластьМакета.Параметры.ПериодДвижения = "Период: "+СокрЛП(Формат(ЗапросШапка.Период,"ДФ=""MMMM.yyyy"));
	ОбластьМакета.Параметры.Количество = "Объем: "+ЗапросШапка.Количество;
	ОбластьМакета.Параметры.КоличествоВагонов = "Количество вагонов: "+ЗапросШапка.КоличествоВагонов;
	
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ВыборкаОбщийИтог = РЕзультат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Общие");
    ВыборкаОбщийИтог.Следующий();
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	
	Выборка = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итог");
	ОбластьМакета.Параметры.Заполнить(ВыборкаОбщийИтог);

	Возврат ТабДокумент;

КонецФункции // ПечатьБронирование()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
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
	ИначеЕсли Не УправлениеПользователями.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Получить экземпляр документа на печать
	Если ИмяМакета = "Макет" Тогда
			ТабДокумент = ПечатьТаблицы( Новый ТабличныйДокумент,"Макет");
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));
                                                                                                                                                    
КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа.
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Макет","Расчетная таблица");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

 
Функция СформироватьТаблицуВлияющихОборотов() Экспорт
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТекДокумент", ЭтотОбъект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	б_БалансЗернаРасчетнаяТаблица.Ссылка.СтатьяБюджетаЗапасы КАК СтатьяБюджета,
	|	б_БалансЗернаРасчетнаяТаблица.Период КАК Период,
	|	СУММА(б_БалансЗернаРасчетнаяТаблица.БалансоваяСтоимость) КАК Сумма,
	|	СУММА(б_БалансЗернаРасчетнаяТаблица.РасходыПоХранению) КАК РасходыПоХранению
	|ИЗ
	|	Документ.б_БалансЗерна.РасчетнаяТаблица КАК б_БалансЗернаРасчетнаяТаблица
	|ГДЕ
	|	б_БалансЗернаРасчетнаяТаблица.Ссылка = &ТекДокумент
	|
	|СГРУППИРОВАТЬ ПО
	|	б_БалансЗернаРасчетнаяТаблица.Ссылка.СтатьяБюджетаЗапасы,
	|	б_БалансЗернаРасчетнаяТаблица.Период";
	
	тз = Запрос.Выполнить().Выгрузить();
	
	тз.Колонки.Добавить("Бюджет");
	
	тз.ЗаполнитьЗначения(ФормируемыйБюджет, "Бюджет");
	
	Возврат тз;	

КонецФункции

// Заполняет таблицу зависимых оборотов рекурсивно зависимыми от статьи
// переданной в качестве параметра.
//
// Параметры
//  Статья  – <Справочник.СтатьиОборотовБюджета> – статья оборотов, для которой выбираются зависимые
//  ДатаДвижения - дата движения по влияющей статье
//  КоличествоПоСтатье - количественный оборот по влияющей статье
//  СуммаПоСтатье - суммовой оборот по влияющей статье
//
Процедура ЗаполнитьЗависимымиОборотами(ТекБюджет,
										ТекСтатьяБюджета,
										ТекПериод,
										СуммаПоСтатье)
										
	Запрос = Новый Запрос;
										
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗависимостиСтатейБюджета.ЗависимыйБюджет,
	|	ЗависимостиСтатейБюджета.ЗависимаяСтатьяБюджета,
	|	ЗависимостиСтатейБюджета.Коэффициент,
	|	ЗависимостиСтатейБюджета.ПериодОтражения
	|ИЗ
	|	РегистрСведений.ЗависимостиСтатейБюджета КАК ЗависимостиСтатейБюджета
	|ГДЕ
	|	ЗависимостиСтатейБюджета.ВлияющийБюджет = &ТекБюджет
	|	И ЗависимостиСтатейБюджета.ВлияющаяСтатьяБюджета = &ТекСтатьяБюджета
	|";
	
	Запрос.УстановитьПараметр("ТекБюджет",ТекБюджет);
	Запрос.УстановитьПараметр("ТекСтатьяБюджета",ТекСтатьяБюджета);

	РезультатЗапроса=Запрос.Выполнить();

	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	Иначе
		
		ТабЗависимыхСтатей=РезультатЗапроса.Выгрузить();
		
		Для Каждого ТекущаяЗависимость Из ТабЗависимыхСтатей Цикл
				НовыйЗависимыйОборот				=ЗависимыеОбороты.Добавить();
				НовыйЗависимыйОборот.Период			=?(ТекущаяЗависимость.ПериодОтражения>0,Дата(Год(ТекПериод),ТекущаяЗависимость.ПериодОтражения,1),ТекПериод);
				
				Если ТекущаяЗависимость.ЗависимаяСтатьяБюджета.КодСтрокиБюджета = "414.2" 
					И ТекущаяЗависимость.ЗависимыйБюджет.Наименование = "Прогнозный бухгалтерский баланс" Тогда

					НовыйЗависимыйОборот.Период	=?(ТекущаяЗависимость.ПериодОтражения>0, НачалоМесяца(КонецГода(Дата(Год(ТекПериод),ТекущаяЗависимость.ПериодОтражения,1))),НачалоМесяца(КонецГода(ТекПериод)));
					
				КонецЕсли;
				
				
				Если ТекущаяЗависимость.ЗависимаяСтатьяБюджета.КодСтрокиБюджета = "1.1.1" 
					И ТекущаяЗависимость.ЗависимыйБюджет.Наименование = "1 БК" Тогда

					НовыйЗависимыйОборот.Период	=?(ТекущаяЗависимость.ПериодОтражения>0, НачалоМесяца(КонецГода(Дата(Год(ТекПериод),ТекущаяЗависимость.ПериодОтражения,1))),НачалоМесяца(КонецГода(ТекПериод)));
					
				КонецЕсли;

				Если ТекущаяЗависимость.ЗависимаяСтатьяБюджета.КодСтрокиБюджета = "1.1.2" 
					И ТекущаяЗависимость.ЗависимыйБюджет.Наименование = "1 БК" Тогда

					НовыйЗависимыйОборот.Период	=?(ТекущаяЗависимость.ПериодОтражения>0, НачалоМесяца(КонецГода(Дата(Год(ТекПериод),ТекущаяЗависимость.ПериодОтражения,1))),НачалоМесяца(КонецГода(ТекПериод)));
					
				КонецЕсли;

				
				НовыйЗависимыйОборот.Бюджет			=ТекущаяЗависимость.ЗависимыйБюджет;
				НовыйЗависимыйОборот.СтатьяБюджета	=ТекущаяЗависимость.ЗависимаяСтатьяБюджета;
				НовыйЗависимыйОборот.Сумма			=СуммаПоСтатье*ТекущаяЗависимость.Коэффициент;
				
				ЗаполнитьЗависимымиОборотами(НовыйЗависимыйОборот.Бюджет,
											НовыйЗависимыйОборот.СтатьяБюджета,
											НовыйЗависимыйОборот.Период,
											НовыйЗависимыйОборот.Сумма)
		КонецЦикла;
	Конецесли;
	
		

КонецПроцедуры
									
// Инициирует процесс заполнения ТЧ "ЗависимыеОбороты"
//
Процедура РассчитатьЗависимыеОбороты() Экспорт
	
	ЗависимыеОбороты.Очистить();
	
	тз = СформироватьТаблицуВлияющихОборотов();
	
	Для Каждого СтрокаТЗ из тз Цикл
		ЗаполнитьЗависимымиОборотами(СтатьяБюджетаЗапасы.Владелец,
									СтатьяБюджетаЗапасы,
									СтрокаТЗ.Период,
									СтрокаТЗ.Сумма);
									
		ЗаполнитьЗависимымиОборотами(СтатьяБюджетаХранение.Владелец,
									СтатьяБюджетаХранение,
									СтрокаТЗ.Период,
									СтрокаТЗ.РасходыПоХранению);
							
	КонецЦикла;
	
	
КонецПроцедуры // РассчитатьЗависимые()

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
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.фин_ВидыОперацийБюджет.Бюджет Тогда
		СтруктураОбязательныхПолей = Новый Структура("Организация, 
			|ФормируемыйБюджет,
			|Сценарий,
			|ПериодПланирования,
			|НоменклатураНом");
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.фин_ВидыОперацийБюджет.Корректировка Тогда
		СтруктураОбязательныхПолей = Новый Структура("Организация, 
			|ФормируемыйБюджет,
			|Сценарий,
			|ВидКорректировки,
			|ПериодПланирования,
			|НоменклатураНом");
	КонецЕсли;	
	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

Функция ПодготовитьТаблицу(РезультатЗапросаПоРасчетнойТаблице,СтруктураШапкиДокумента)
	
	ТаблицаПоРасчетнойТаблице = РезультатЗапросаПоРасчетнойТаблице.Выгрузить();
	
	ТаблицаПоРасчетнойТаблице.Колонки.Добавить("Бюджет");
	ТаблицаПоРасчетнойТаблице.Колонки.Добавить("Сценарий");
	ТаблицаПоРасчетнойТаблице.Колонки.Добавить("Организация");
	
	ТаблицаПоРасчетнойТаблице.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация, "Организация");
	ТаблицаПоРасчетнойТаблице.ЗаполнитьЗначения(СтруктураШапкиДокумента.ФормируемыйБюджет, "Бюджет");
	ТаблицаПоРасчетнойТаблице.ЗаполнитьЗначения(СтруктураШапкиДокумента.Сценарий, "Сценарий");
	
	Возврат ТаблицаПоРасчетнойТаблице;
КонецФункции

Функция СформироватьТаблицуДляДоходовИРасходов(СтруктураШапкиДокумента)
	
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.фин_ВидыОперацийБюджет.Бюджет Тогда
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ТекДокумент",ЭтотОбъект.Ссылка);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РасчетнаяТаблица.ссылка.ФормируемыйБюджет КАК Бюджет,
		|	РасчетнаяТаблица.СтатьяБюджета КАК СтатьяБюджета,
		|	РасчетнаяТаблица.Ссылка.Период КАК Период,
		|	Сумма(РасчетнаяТаблица.СуммаБезНДС) КАК Сумма
		|ИЗ
		|	Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации.РасчетнаяТаблица КАК РасчетнаяТаблица
		|ГДЕ
		|	РасчетнаяТаблица.ссылка = &ТекДокумент
		|СГРУППИРОВАТЬ ПО РасчетнаяТаблица.ссылка.ФормируемыйБюджет,РасчетнаяТаблица.СтатьяБюджета,РасчетнаяТаблица.ссылка.Период
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|ВЫБРАТЬ
		|	ЗависимыеОбороты.Бюджет КАК Бюджет,
		|	ЗависимыеОбороты.СтатьяБюджета КАК СтатьяБюджета,
		|	ЗависимыеОбороты.Ссылка.Период КАК Период,
		|	Сумма(ЗависимыеОбороты.Сумма) КАК Сумма
		|ИЗ
		|	Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации.ЗависимыеОбороты КАК ЗависимыеОбороты
		|ГДЕ
		|	ЗависимыеОбороты.ссылка = &ТекДокумент
		|СГРУППИРОВАТЬ ПО ЗависимыеОбороты.Бюджет,ЗависимыеОбороты.СтатьяБюджета,ЗависимыеОбороты.Ссылка.Период
		|";
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.фин_ВидыОперацийБюджет.Корректировка Тогда
		
		//СписокСтатейБюджета = Новый Массив;
		//СписокСтатейБюджета.Добавить(СтруктураШапкиДокумента.СтатьяБюджета);
		//СписокСтатейБюджета.Добавить(СтруктураШапкиДокумента.СтатьяБюджетаСебестоимости);
		
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ТекДокумент",ЭтотОбъект.Ссылка);
		Запрос.УстановитьПараметр("Началопериода",СтруктураШапкиДокумента.ПериодПланирования);
		Запрос.УстановитьПараметр("Конецпериода",КонецГода(СтруктураШапкиДокумента.ПериодПланирования));
		Запрос.УстановитьПараметр("Организация",СтруктураШапкиДокумента.Организация);
		Запрос.УстановитьПараметр("ФормируемыйБюджет",СтруктураШапкиДокумента.ФормируемыйБюджет);
		//Запрос.УстановитьПараметр("СписокСтатейБюджета",СписокСтатейБюджета);
		Запрос.УстановитьПараметр("Статус",Перечисления.СостоянияОбъектов.Утвержден);
		//
		//Запрос.Текст =
		//"ВЫБРАТЬ
		//|	ПоДокументу.СтатьяБюджета КАК СтатьяБюджета,
		//|	ПоДокументу.Период КАК Период,
		//|	ПоДокументу.ИСумма - ПоДокументу.Сумма КАК Сумма
		//|ИЗ
		//|	(ВЫБРАТЬ
		//|		РасчетнаяТаблица.ссылка.ФормируемыйБюджет КАК Бюджет,
		//|		РасчетнаяТаблица.СтатьяБюджета КАК СтатьяБюджета,
		//|		РасчетнаяТаблица.Период КАК Период,
		//|		Сумма(РасчетнаяТаблица.СуммаБезНДС) КАК Сумма,
		//|		Сумма(РасчетнаяТаблица.ИСуммаБезНДС) КАК ИСумма
		//|	ИЗ
		//|		Документ.б_РасчетнаяТаблицаРеализации.РасчетнаяТаблица КАК РасчетнаяТаблица
		//|	ГДЕ
		//|		РасчетнаяТаблица.ссылка = &ТекДокумент
		//|	СГРУППИРОВАТЬ ПО РасчетнаяТаблица.ссылка.ФормируемыйБюджет,РасчетнаяТаблица.СтатьяБюджета,РасчетнаяТаблица.Период
		//|	) ПоДокументу
		//|
		//|Левое Соединение	РегистрНакопления.б_Бюджет.Обороты(
		//|			&Началопериода,
		//|			&КонецПериода,
		//|			Месяц,
		//|			Организация = &Организация
		//|				И Бюджет = &ФормируемыйБюджет
		//|				И Статус = &Статус
		//|				И СтатьяБюджета в (&СписокСтатейБюджета)) КАК б_ГодовойБюджетОбороты	
		//|		ПО ПоДокументу.СтатьяБюджета = б_ГодовойБюджетОбороты.СтатьяБюджета
		//|          И ПоДокументу.Период = б_ГодовойБюджетОбороты.Период
		//|";
		Запрос.УстановитьПараметр("ТекДокумент",ЭтотОбъект.Ссылка);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РасчетнаяТаблица.ссылка.ФормируемыйБюджет КАК Бюджет,
		|	РасчетнаяТаблица.СтатьяБюджета КАК СтатьяБюджета,
		|	РасчетнаяТаблица.Ссылка.Период КАК Период,
		|	Сумма(РасчетнаяТаблица.СуммаБезНДС)-Сумма(РасчетнаяТаблица.иСуммаБезНДС) КАК Сумма
		|ИЗ
		|	Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации.РасчетнаяТаблица КАК РасчетнаяТаблица
		|ГДЕ
		|	РасчетнаяТаблица.ссылка = &ТекДокумент
		|СГРУППИРОВАТЬ ПО РасчетнаяТаблица.ссылка.ФормируемыйБюджет,РасчетнаяТаблица.СтатьяБюджета,РасчетнаяТаблица.ссылка.Период
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|ВЫБРАТЬ
		|	ЗависимыеОбороты.Бюджет КАК Бюджет,
		|	ЗависимыеОбороты.СтатьяБюджета КАК СтатьяБюджета,
		|	ЗависимыеОбороты.Ссылка.Период КАК Период,
		|	Сумма(ЗависимыеОбороты.Сумма) КАК Сумма
		|ИЗ
		|	Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации.ЗависимыеОбороты КАК ЗависимыеОбороты
		|ГДЕ
		|	ЗависимыеОбороты.ссылка = &ТекДокумент
		|СГРУППИРОВАТЬ ПО ЗависимыеОбороты.Бюджет,ЗависимыеОбороты.СтатьяБюджета,ЗависимыеОбороты.ссылка.Период
		|";
	КонецЕсли;
	
	тз = Запрос.Выполнить().Выгрузить();
	
	тз.Колонки.Добавить("Организация");
	тз.Колонки.Добавить("Статус");
	
	тз.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация, "Организация");
	тз.ЗаполнитьЗначения(СтруктураШапкиДокумента.Состояние, "Статус");
	
	Возврат тз;	
КонецФункции

// Процедура выполняет движения по регистрам
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента,
									 Отказ, Заголовок)
									
	// Выполнить движения по регистру накопления 	
	НаборДвижений = Движения.б_Бюджет;
	
	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	// Заполним таблицу движений.
	ТаблицаДанных = СформироватьТаблицуДляДоходовИРасходов(СтруктураШапкиДокумента);
	ТаблицаДанных.Колонки.Добавить("Активность");
	ТаблицаДанных.ЗаполнитьЗначения(Истина, "Активность");
	
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаДанных, ТаблицаДвижений);
	
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Если Не Отказ Тогда
		Движения.б_Бюджет.ВыполнитьДвижения();
		
		ДвиженияПоБюджету = Движения.фин_Бюджетирование;
		
		ТабПроводокДокумента = ДополнительныеПоБюджетированию.ВыполнитьДвижениеПроводокПоБюджетированию(ЭтотОбъект, ДвиженияПоБюджету, СтруктураШапкиДокумента, ТаблицаДанных);
		
		//Перем ДеревоПолейЗапросаПоШапке;

		// регистр б_БалансЗерна 
		Движения.б_БалансЗерна.Очистить();
		Для Каждого ТекСтрокаРасчетнаяТаблица Из РасчетнаяТаблица Цикл
			Движение = Движения.б_БалансЗерна.Добавить();
			Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
			Движение.Номенклатура = Номенклатура;
			Движение.НоменклатураНом = НоменклатураНом;

			Движение.ОстатокНаНачало = ТекСтрокаРасчетнаяТаблица.ОстатокНаНачало;
			Движение.Закуп = ТекСтрокаРасчетнаяТаблица.Закуп;
			Движение.ВозвратТоварногоКредита = ТекСтрокаРасчетнаяТаблица.ВозвратТоварногоКредита;
			Движение.РеализацияВнутреннийРынок = ТекСтрокаРасчетнаяТаблица.РеализацияВнутреннийРынок;
			Движение.РеализацияТоварныйКредит = ТекСтрокаРасчетнаяТаблица.РеализацияТоварныйКредит;
			Движение.РеализацияНаЭкспорт = ТекСтрокаРасчетнаяТаблица.РеализацияНаЭкспорт;
			Движение.ВыбытиеВсего = ТекСтрокаРасчетнаяТаблица.ВыбытиеВсего;
			Движение.ОстатокНаКонец = ТекСтрокаРасчетнаяТаблица.ОстатокНаКонец;
			Движение.РасценкаЗаХранение = ТекСтрокаРасчетнаяТаблица.РасценкаЗаХранение;
			Движение.РасходыПоХранению = ТекСтрокаРасчетнаяТаблица.РасходыПоХранению;
			Движение.СредневзвешеннаяЦена = ТекСтрокаРасчетнаяТаблица.СредневзвешеннаяЦена;
			Движение.БалансоваяСтоимость = ТекСтрокаРасчетнаяТаблица.БалансоваяСтоимость;
			Движение.Цена = ТекСтрокаРасчетнаяТаблица.Цена;
		КонецЦикла;

		// регистр б_Бюджет 
		Движения.б_Бюджет.Очистить();
		Для Каждого ТекСтрокаРасчетнаяТаблица Из РасчетнаяТаблица Цикл
			
			Если ЗначениеЗаполнено(СтатьяБюджета) Тогда

				Движение = Движения.б_Бюджет.Добавить();
				Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
				Движение.Организация = Организация;
				Движение.СтатьяБюджета = СтатьяБюджета;
				Движение.Бюджет = ФормируемыйБюджет;
				Движение.Сумма = ТекСтрокаРасчетнаяТаблица.Закуп*ТекСтрокаРасчетнаяТаблица.Цена;
				Движение.Количество = ТекСтрокаРасчетнаяТаблица.Закуп;
				
			КонецЕсли;

			Если ЗначениеЗаполнено(СтатьяБюджетаЗапасы) Тогда

				//баланс зерна
				Движение = Движения.б_Бюджет.Добавить();
				Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
				Движение.Организация = Организация;
				Движение.СтатьяБюджета = СтатьяБюджетаЗапасы;
				Движение.Бюджет = СтатьяБюджетаЗапасы.Владелец;
				Движение.Сумма = ТекСтрокаРасчетнаяТаблица.БалансоваяСтоимость;
				
			КонецЕсли;

			Если ЗначениеЗаполнено(СтатьяБюджетаХранение) Тогда
			
				Движение = Движения.б_Бюджет.Добавить();
				Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
				Движение.Организация = Организация;
				Движение.СтатьяБюджета = СтатьяБюджетаХранение;
				Движение.Бюджет = СтатьяБюджетаХранение.Владелец;
				Движение.Сумма = ТекСтрокаРасчетнаяТаблица.РасходыПоХранению;
			
			КонецЕсли;

		КонецЦикла;
				
			
		Для Каждого ТекСтрокаЗависимыеОбороты Из ЗависимыеОбороты Цикл
			
			Движение = Движения.б_Бюджет.Добавить();
			Движение.Период = ТекСтрокаЗависимыеОбороты.Период;
			Движение.Организация = Организация;
			Движение.СтатьяБюджета = ТекСтрокаЗависимыеОбороты.СтатьяБюджета;
			Движение.Бюджет = ТекСтрокаЗависимыеОбороты.Бюджет;
			Движение.Сумма = ТекСтрокаЗависимыеОбороты.Сумма;
												
		КонецЦикла;

		
		//Корректировка
		
		Если ВидОперации = Перечисления.фин_ВидыОперацийБюджет.Корректировка 
			И ЗначениеЗаполнено(КорректировкаДокумента) Тогда

				Для Каждого ТекСтрокаРасчетнаяТаблица Из КорректировкаДокумента.РасчетнаяТаблица Цикл
					Движение = Движения.б_БалансЗерна.Добавить();
					Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
					Движение.Номенклатура = КорректировкаДокумента.Номенклатура;
					Движение.НоменклатураНом = КорректировкаДокумента.НоменклатураНом;

					Движение.ОстатокНаНачало = -ТекСтрокаРасчетнаяТаблица.ОстатокНаНачало;
					Движение.Закуп = -ТекСтрокаРасчетнаяТаблица.Закуп;
					Движение.ВозвратТоварногоКредита = -ТекСтрокаРасчетнаяТаблица.ВозвратТоварногоКредита;
					Движение.РеализацияВнутреннийРынок = -ТекСтрокаРасчетнаяТаблица.РеализацияВнутреннийРынок;
					Движение.РеализацияТоварныйКредит = -ТекСтрокаРасчетнаяТаблица.РеализацияТоварныйКредит;
					Движение.РеализацияНаЭкспорт = -ТекСтрокаРасчетнаяТаблица.РеализацияНаЭкспорт;
					Движение.ВыбытиеВсего = -ТекСтрокаРасчетнаяТаблица.ВыбытиеВсего;
					Движение.ОстатокНаКонец = -ТекСтрокаРасчетнаяТаблица.ОстатокНаКонец;
					Движение.РасценкаЗаХранение = -ТекСтрокаРасчетнаяТаблица.РасценкаЗаХранение;
					Движение.РасходыПоХранению = -ТекСтрокаРасчетнаяТаблица.РасходыПоХранению;
					Движение.СредневзвешеннаяЦена = -ТекСтрокаРасчетнаяТаблица.СредневзвешеннаяЦена;
					Движение.БалансоваяСтоимость = -ТекСтрокаРасчетнаяТаблица.БалансоваяСтоимость;
					Движение.Цена = -ТекСтрокаРасчетнаяТаблица.Цена;
				КонецЦикла;

				// регистр б_Бюджет 
				Для Каждого ТекСтрокаРасчетнаяТаблица Из КорректировкаДокумента.РасчетнаяТаблица Цикл
					
					Если ЗначениеЗаполнено(КорректировкаДокумента.СтатьяБюджета) Тогда

						Движение = Движения.б_Бюджет.Добавить();
						Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
						Движение.Организация = КорректировкаДокумента.Организация;
						Движение.СтатьяБюджета = КорректировкаДокумента.СтатьяБюджета;
						Движение.Бюджет = КорректировкаДокумента.ФормируемыйБюджет;
						Движение.Сумма = -ТекСтрокаРасчетнаяТаблица.Закуп*ТекСтрокаРасчетнаяТаблица.Цена;
						Движение.Количество = -ТекСтрокаРасчетнаяТаблица.Закуп;
						
					КонецЕсли;

					Если ЗначениеЗаполнено(КорректировкаДокумента.СтатьяБюджетаЗапасы) Тогда

						//баланс зерна
						Движение = Движения.б_Бюджет.Добавить();
						Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
						Движение.Организация = КорректировкаДокумента.Организация;
						Движение.СтатьяБюджета = КорректировкаДокумента.СтатьяБюджетаЗапасы;
						Движение.Бюджет = КорректировкаДокумента.СтатьяБюджетаЗапасы.Владелец;
						Движение.Сумма = -ТекСтрокаРасчетнаяТаблица.БалансоваяСтоимость;
						
					КонецЕсли;

					Если ЗначениеЗаполнено(КорректировкаДокумента.СтатьяБюджетаХранение) Тогда
					
						Движение = Движения.б_Бюджет.Добавить();
						Движение.Период = ТекСтрокаРасчетнаяТаблица.Период;
						Движение.Организация = КорректировкаДокумента.Организация;
						Движение.СтатьяБюджета = КорректировкаДокумента.СтатьяБюджетаХранение;
						Движение.Бюджет = КорректировкаДокумента.СтатьяБюджетаХранение.Владелец;
						Движение.Сумма = -ТекСтрокаРасчетнаяТаблица.РасходыПоХранению;
					
					КонецЕсли;

				КонецЦикла;
						
					
				Для Каждого ТекСтрокаЗависимыеОбороты Из КорректировкаДокумента.ЗависимыеОбороты Цикл
					
					Движение = Движения.б_Бюджет.Добавить();
					Движение.Период = ТекСтрокаЗависимыеОбороты.Период;
					Движение.Организация = КорректировкаДокумента.Организация;
					Движение.СтатьяБюджета = ТекСтрокаЗависимыеОбороты.СтатьяБюджета;
					Движение.Бюджет = ТекСтрокаЗависимыеОбороты.Бюджет;
					Движение.Сумма = -ТекСтрокаЗависимыеОбороты.Сумма;
				КонецЦикла;
							
			
		КонецЕсли;
		
	КонецЕсли;

Конецпроцедуры

 ////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)
    // Обработка для работы в версии 8.2
	Если ТипЗнч(Основание) <> Тип("Структура")
		И Основание <> НЕОПРЕДЕЛЕНО Тогда
	
		//ЗаполнитьПоДокументуОснования(Основание);
    КонецЕсли;
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НЕ РежимЗаписи=РежимЗаписиДокумента.ОтменаПроведения Тогда 
		РассчитатьЗависимыеОбороты();
	КонецЕсли;

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

		
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = "Проведение документа """ + СокрЛП(Ссылка) + """: ";
	
	
	// Проверка ручной корректировки
	Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента   = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Движения по документу
	Если Не Отказ Тогда

		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
							 Отказ, Заголовок);
							
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Предопределенная процедура обработки удаления проведения документа
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мВалютаРегламентированногоУчета   = Константы.ВалютаРегламентированногоУчета.Получить();
