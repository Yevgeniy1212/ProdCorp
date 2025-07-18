﻿Перем мСписокИсточниковФинансирования Экспорт;
Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем мСписокПодразделений Экспорт;
Перем мДеревоСтруктурныхЕдиниц Экспорт;
Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем ПромежуточныеДанные Экспорт;
Перем РежимРасшифровки Экспорт;
Перем ВедётсяУчетПоПодразделениям Экспорт;

Перем мСубконтоДоходы Экспорт;
Перем мСубконтоТипыОпераций Экспорт;
Перем мСубконтоСтатьиЗатрат Экспорт;
Перем мСубконтоОС Экспорт;
Перем мСубконтоНМА Экспорт;
Перем мСписокСчетовПоставщиков Экспорт;

#Если Клиент Тогда

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	СтандартныеОтчеты.ЗаполнитьДанныеОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Результат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ВыводЗаголовкаОтчета(ЭтотОбъект, Результат);
	ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
	СтандартныеОтчеты.ВывестиОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	// Выполним дополнительную обработку Результата отчета
	ОбработкаРезультатаОтчета(Результат);
	
	
	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(Результат, ПолучитьТекстЗаголовка(), Строка(глТекущийПользователь));
	
	Возврат;
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	мСубконтоДоходы = Новый Массив;
	мСубконтоДоходы.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Доходы);
	
	мСубконтоТипыОпераций = Новый Массив;
	мСубконтоТипыОпераций.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ТипыОпераций);
	
	мСубконтоСтатьиЗатрат = Новый Массив;
	мСубконтоСтатьиЗатрат.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.СтатьиЗатрат);
	
	мСубконтоОС = Новый Массив;
	мСубконтоОС.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ОсновныеСредства);
	
	мСубконтоНМА = Новый Массив;
	мСубконтоНМА.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.НематериальныеАктивы);
	
	мСписокСчетовПоставщиков = Новый Массив;
	мСписокСчетовПоставщиков.Добавить(ПланыСчетов.Типовой.КраткосрочнаяКредиторскаяЗадолженность);
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПрошлогоГода", НачалоДня(НачалоПериода));
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПрошлогоГода", КонецДня(КонецПериода));
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоЭтого", НачалоПериодаКолонка2);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецЭтого",КонецДня(КонецПериодаКолонка2));
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаАнализа", НачалоПериодаАнализа);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаАнализа", КонецДня(КонецПериодаАнализа));
	//ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаАнализаНаЭтотГод", НачалоПериодаАнализ);
	//ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаАнализаНаЭтотГод",КонецДня(КонецПериодаАнализ));
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Бюджет", ФормируемыйБюджет);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Ед", ЕдиницаИзмерения);
	//ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаАнализа", КонецДня(КонецПериода));
	
	//ВнешниеНаборыДанных = Новый Структура;
	//ВыборкаДанных = ПолучитьВыборку();
	//ВнешниеНаборыДанных.Вставить("ТаблицаДанных", ВыборкаДанных);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[0].Использование = Ложь;
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[1].Использование = Ложь;
	Поле = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("СуммаПрошлыйГод");
	Если Поле <> Неопределено Тогда
		Поле.Заголовок = "План "+Год(НачалоПериода)+" год утвержденный";
	КонецЕсли;
	
	Поле = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("СуммаЭтотГод");
	Если Поле <> Неопределено Тогда
		Поле.Заголовок = "План "+Год(НачалоПериодаКолонка2)+" года";
	КонецЕсли;
	
	Поле = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("ФактАнализа");
	Если Поле <> Неопределено Тогда
		Поле.Заголовок = "Факт "+ОбщегоНазначения.ПолучитьПредставлениеПериода(НачалоПериодаАнализа, КонецПериодаАнализа);
	КонецЕсли;
	
	Поле = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("ПланАнализа");
	Если Поле <> Неопределено Тогда
		Поле.Заголовок = "План "+ОбщегоНазначения.ПолучитьПредставлениеПериода(НачалоПериодаАнализа, КонецПериодаАнализа);
	КонецЕсли;
	
	Если мДеревоСтруктурныхЕдиниц.Колонки.Количество() = 0 Тогда 
		
		СписокСтруктурныхЕдиниц = Новый СписокЗначений;
		СписокСтруктурныхЕдиниц.ЗагрузитьЗначения(мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
		
		Для Каждого СтрПодразделение Из мСписокПодразделений Цикл 
			СписокСтруктурныхЕдиниц.Добавить(СтрПодразделение.Значение);
		КонецЦикла;		
				
		мДеревоСтруктурныхЕдиниц = СтандартныеОтчеты.СформироватьДеревоСЕ(, СписокСтруктурныхЕдиниц);
		
	КонецЕсли;
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "мСписокСчетовПоставщиков", мСписокСчетовПоставщиков);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "мСубконтоОС", мСубконтоОС);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "мСубконтоНМА", мСубконтоНМА);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "мСубконтоСтатьиЗатрат", мСубконтоСтатьиЗатрат);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "мСубконтоДоходы", мСубконтоДоходы);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "мСубконтоТипыОпераций", мСубконтоТипыОпераций);
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПредыдущегоПериода", НачалоДня(Дата(Год(НачалоПериода)-1,1,1)));
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПредыдущегоПериода", КонецДня(Дата(Год(НачалоПериода)-1,12,31)));
	
//	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ФормируемыйБюджет", ФормируемыйБюджет);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ЕдиницаИзмерения", ЕдиницаИзмерения);
	
	ТиповыеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, мДеревоСтруктурныхЕдиниц);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	СтандартныеОтчеты.ИнициализацияОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура ВыводПодписиОтчета(Результат)
	
	//Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	//ОбластьПодписи        = Макет.ПолучитьОбласть("ПодписиПроверил");
	//Результат.Вывести(ОбластьПодписи);
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	СтандартныеОтчеты.ВыводЗаголовкаСпециализированногоОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
		
	ЗаголовокОтчета = "Сравнительный анализ "+СокрЛП(ФормируемыйБюджет.Наименование) + СтандартныеОтчеты.ПолучитьПредставлениеПериода(ЭтотОбъект);

	Возврат ?(ОрганизацияВНачале, ЗаголовокОтчета, ЗаголовокОтчета + " " + СтандартныеОтчеты.ПолучитьТекстОрганизация(ЭтотОбъект));
		
КонецФункции

Функция ПолучитьВыборку ()
	
	Запрос = Новый Запрос;
         
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФактБУ.Организация КАК Организация,
	|	ФактБУ.СтатьяБюджета КАК СтатьяБюджета,
	|	ФактБУ.Статус,
	|	ФактБУ.ДокументДвижения КАК ДокументДвижения,
	|	СУММА(ФактБУ.СуммаПервоначальная) КАК СуммаПервоначальная,
	|	СУММА(ФактБУ.СуммаПослеКорректировки) КАК СуммаПослеКорректировки,
	|	СУММА(ФактБУ.СуммаПервоначальнаяАнализа) КАК СуммаПервоначальнаяАнализа,
	|	СУММА(ФактБУ.СуммаПослеКорректировкиАнализа) КАК СуммаПослеКорректировкиАнализа,
	|	СУММА(ФактБУ.ПризнакКоличество) КАК ПризнакКоличество
	|ПОМЕСТИТЬ ФактическийОборот
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЕСТЬNULL(ТиповойОбороты.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
	|		б_СоответствияСтатейБюджетаСчетамБУ.СтатьяБюджета КАК СтатьяБюджета,
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияОбъектов.Утвержден) КАК Статус,
	|		ТиповойОбороты.Регистратор КАК ДокументДвижения,
	|		0 КАК СуммаПервоначальная,
	|		0 КАК СуммаПослеКорректировки,
	|		0 КАК СуммаПервоначальнаяАнализа,
	|		ВЫБОР
	|			КОГДА б_СоответствияСтатейБюджетаСчетамБУ.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|				ТОГДА ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0) * б_СоответствияСтатейБюджетаСчетамБУ.ПризнакСуммы
	|			ИНАЧЕ ЕСТЬNULL(ТиповойОбороты.СуммаОборотКт, 0) * б_СоответствияСтатейБюджетаСчетамБУ.ПризнакСуммы
	|		КОНЕЦ КАК СуммаПослеКорректировкиАнализа,
	|		0 КАК ПризнакКоличество
	|	ИЗ
	|		РегистрСведений.б_СоответствияСтатейБюджетаСчетамБУ КАК б_СоответствияСтатейБюджетаСчетамБУ
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|					&НачалопериодаАнализа,
	|					&КонецПериодаАнализа,
	|					Регистратор,
	|					Счет В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							СоответствияСтатейБюджетаСчетамБУ.Счет
	|						ИЗ
	|							РегистрСведений.б_СоответствияСтатейБюджетаСчетамБУ КАК СоответствияСтатейБюджетаСчетамБУ),
	|					,
	|					,
	|					,
	|					) КАК ТиповойОбороты
	|			ПО (ТиповойОбороты.Счет = б_СоответствияСтатейБюджетаСчетамБУ.Счет)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЕСТЬNULL(ТиповойОбороты.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)),
	|		б_СоответствияСтатейБюджетаДоходамБУ.СтатьяБюджета,
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияОбъектов.Утвержден),
	|		ТиповойОбороты.Регистратор,
	|		0,
	|		0,
	|		0,
	|		ВЫБОР
	|			КОГДА б_СоответствияСтатейБюджетаДоходамБУ.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|				ТОГДА ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0) * б_СоответствияСтатейБюджетаДоходамБУ.ПризнакСуммы
	|			ИНАЧЕ ЕСТЬNULL(ТиповойОбороты.СуммаОборотКт, 0) * б_СоответствияСтатейБюджетаДоходамБУ.ПризнакСуммы
	|		КОНЕЦ,
	|		0
	|	ИЗ
	|		РегистрСведений.б_СоответствияСтатейБюджетаДоходамБУ КАК б_СоответствияСтатейБюджетаДоходамБУ
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|					&НачалопериодаАнализа,
	|					&КонецПериодаАнализа,
	|					Регистратор,
	|					Счет В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							СоответствияСтатейБюджетаДоходамБУ.Счет
	|						ИЗ
	|							РегистрСведений.б_СоответствияСтатейБюджетаДоходамБУ КАК СоответствияСтатейБюджетаДоходамБУ),
	|					&мСубконтоДоходы,
	|					,
	|					,
	|					) КАК ТиповойОбороты
	|			ПО (ТиповойОбороты.Счет = б_СоответствияСтатейБюджетаДоходамБУ.Счет)
	|				И (ТиповойОбороты.Субконто1 = б_СоответствияСтатейБюджетаДоходамБУ.Доход)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЕСТЬNULL(ТиповойОбороты.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)),
	|		б_СоответствияСтатейБюджетаТипамОперацийБУ.СтатьяБюджета,
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияОбъектов.Утвержден),
	|		ТиповойОбороты.Регистратор,
	|		0,
	|		0,
	|		0,
	|		ВЫБОР
	|			КОГДА б_СоответствияСтатейБюджетаТипамОперацийБУ.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|				ТОГДА ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0) * б_СоответствияСтатейБюджетаТипамОперацийБУ.ПризнакСуммы
	|			ИНАЧЕ ЕСТЬNULL(ТиповойОбороты.СуммаОборотКт, 0) * б_СоответствияСтатейБюджетаТипамОперацийБУ.ПризнакСуммы
	|		КОНЕЦ,
	|		0
	|	ИЗ
	|		РегистрСведений.б_СоответствияСтатейБюджетаТипамОперацийБУ КАК б_СоответствияСтатейБюджетаТипамОперацийБУ
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|					&НачалопериодаАнализа,
	|					&КонецПериодаАнализа,
	|					Регистратор,
	|					Счет В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							СоответствияСтатейБюджетаТипамОперацийБУ.Счет
	|						ИЗ
	|							РегистрСведений.б_СоответствияСтатейБюджетаТипамОперацийБУ КАК СоответствияСтатейБюджетаТипамОперацийБУ),
	|					&мСубконтоТипыОпераций,
	|					,
	|					,
	|					) КАК ТиповойОбороты
	|			ПО (ТиповойОбороты.Счет = б_СоответствияСтатейБюджетаТипамОперацийБУ.Счет)
	|				И (ТиповойОбороты.Субконто1 = б_СоответствияСтатейБюджетаТипамОперацийБУ.ТипОперации)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЕСТЬNULL(ТиповойОбороты.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)),
	|		б_СоответствияСтатейБюджетаСтатьямЗатратБУ.СтатьяБюджета,
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияОбъектов.Утвержден),
	|		ТиповойОбороты.Регистратор,
	|		0,
	|		0,
	|		0,
	|		ВЫБОР
	|			КОГДА б_СоответствияСтатейБюджетаСтатьямЗатратБУ.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|				ТОГДА ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0) * б_СоответствияСтатейБюджетаСтатьямЗатратБУ.ПризнакСуммы
	|			ИНАЧЕ ЕСТЬNULL(ТиповойОбороты.СуммаОборотКт, 0) * б_СоответствияСтатейБюджетаСтатьямЗатратБУ.ПризнакСуммы
	|		КОНЕЦ,
	|		0
	|	ИЗ
	|		РегистрСведений.б_СоответствияСтатейБюджетаСтатьямЗатратБУ КАК б_СоответствияСтатейБюджетаСтатьямЗатратБУ
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|					&НачалопериодаАнализа,
	|					&КонецПериодаАнализа,
	|					Регистратор,
	|					Счет В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							СоответствияСтатейБюджетаСтатьямЗатратБУ.Счет
	|						ИЗ
	|							РегистрСведений.б_СоответствияСтатейБюджетаСтатьямЗатратБУ КАК СоответствияСтатейБюджетаСтатьямЗатратБУ),
	|					&мСубконтоСтатьиЗатрат,
	|					,
	|					,
	|					) КАК ТиповойОбороты
	|			ПО (ТиповойОбороты.Счет = б_СоответствияСтатейБюджетаСтатьямЗатратБУ.Счет)
	|				И (ТиповойОбороты.Субконто1 = б_СоответствияСтатейБюджетаСтатьямЗатратБУ.СтатьяЗатрат)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЕСТЬNULL(ТиповойОбороты.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)),
	|		б_СоответствияСтатейБюджетаГруппамОСБУ.СтатьяБюджета,
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияОбъектов.Утвержден),
	|		ТиповойОбороты.Регистратор,
	|		0,
	|		0,
	|		0,
	|		ВЫБОР
	|			КОГДА б_СоответствияСтатейБюджетаГруппамОСБУ.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|				ТОГДА ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0) * б_СоответствияСтатейБюджетаГруппамОСБУ.ПризнакСуммы
	|			ИНАЧЕ ЕСТЬNULL(ТиповойОбороты.СуммаОборотКт, 0) * б_СоответствияСтатейБюджетаГруппамОСБУ.ПризнакСуммы
	|		КОНЕЦ,
	|		0
	|	ИЗ
	|		РегистрСведений.б_СоответствияСтатейБюджетаГруппамОСБУ КАК б_СоответствияСтатейБюджетаГруппамОСБУ
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|					&НачалопериодаАнализа,
	|					&КонецПериодаАнализа,
	|					Регистратор,
	|					Счет В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							СоответствияСтатейБюджетаГруппамОСБУ.Счет
	|						ИЗ
	|							РегистрСведений.б_СоответствияСтатейБюджетаГруппамОСБУ КАК СоответствияСтатейБюджетаГруппамОСБУ),
	|					&мСубконтоОС,
	|					,
	|					КорСчет В ИЕРАРХИИ (&мСписокСчетовПоставщиков),
	|					) КАК ТиповойОбороты
	|			ПО (ТиповойОбороты.Счет = б_СоответствияСтатейБюджетаГруппамОСБУ.Счет)
	|				И (ТиповойОбороты.Субконто1.ГруппаОС = б_СоответствияСтатейБюджетаГруппамОСБУ.ГруппаОС)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЕСТЬNULL(ТиповойОбороты.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)),
	|		б_СоответствияСтатейБюджетаВидамНМАБУ.СтатьяБюджета,
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияОбъектов.Утвержден),
	|		ТиповойОбороты.Регистратор,
	|		0,
	|		0,
	|		0,
	|		ВЫБОР
	|			КОГДА б_СоответствияСтатейБюджетаВидамНМАБУ.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|				ТОГДА ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0) * б_СоответствияСтатейБюджетаВидамНМАБУ.ПризнакСуммы
	|			ИНАЧЕ ЕСТЬNULL(ТиповойОбороты.СуммаОборотКт, 0) * б_СоответствияСтатейБюджетаВидамНМАБУ.ПризнакСуммы
	|		КОНЕЦ,
	|		0
	|	ИЗ
	|		РегистрСведений.б_СоответствияСтатейБюджетаВидамНМАБУ КАК б_СоответствияСтатейБюджетаВидамНМАБУ
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|					&НачалопериодаАнализа,
	|					&КонецПериодаАнализа,
	|					Регистратор,
	|					Счет В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							СоответствияСтатейБюджетаВидамНМАБУ.Счет
	|						ИЗ
	|							РегистрСведений.б_СоответствияСтатейБюджетаВидамНМАБУ КАК СоответствияСтатейБюджетаВидамНМАБУ),
	|					&мСубконтоНМА,
	|					,
	|					КорСчет В ИЕРАРХИИ (&мСписокСчетовПоставщиков),
	|					) КАК ТиповойОбороты
	|			ПО (ТиповойОбороты.Счет = б_СоответствияСтатейБюджетаВидамНМАБУ.Счет)
	|				И (ТиповойОбороты.Субконто1.ВидНМА = б_СоответствияСтатейБюджетаВидамНМАБУ.ВидНМА)) КАК ФактБУ
	|ГДЕ
	|	ФактБУ.СтатьяБюджета.Владелец = &ФормируемыйБюджет
	|
	|СГРУППИРОВАТЬ ПО
	|	ФактБУ.Организация,
	|	ФактБУ.СтатьяБюджета,
	|	ФактБУ.Статус,
	|	ФактБУ.ДокументДвижения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОборотыБюджета.Организация КАК Организация,
	|	ОборотыБюджета.СтатьяБюджета КАК СтатьяБюджета,
	|	ОборотыБюджета.Статус,
	|	ОборотыБюджета.ДокументДвижения КАК ДокументДвижения,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000000)
	|			ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПервоначальная, 0) / 1000000
	|		ИНАЧЕ ВЫБОР
	|				КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000)
	|					ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПервоначальная, 0) / 1000
	|				ИНАЧЕ ЕСТЬNULL(ОборотыБюджета.СуммаПервоначальная, 0)
	|			КОНЕЦ
	|	КОНЕЦ КАК СуммаПервоначальная,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000000)
	|			ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПослеКорректировки, 0) / 1000000
	|		ИНАЧЕ ВЫБОР
	|				КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000)
	|					ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПослеКорректировки, 0) / 1000
	|				ИНАЧЕ ЕСТЬNULL(ОборотыБюджета.СуммаПослеКорректировки, 0)
	|			КОНЕЦ
	|	КОНЕЦ КАК СуммаПослеКорректировки,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000000)
	|			ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПервоначальнаяАнализа, 0) / 1000000
	|		ИНАЧЕ ВЫБОР
	|				КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000)
	|					ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПервоначальнаяАнализа, 0) / 1000
	|				ИНАЧЕ ЕСТЬNULL(ОборотыБюджета.СуммаПервоначальнаяАнализа, 0)
	|			КОНЕЦ
	|	КОНЕЦ КАК СуммаПервоначальнаяАнализа,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000000)
	|			ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПослеКорректировкиАнализа, 0) / 1000000
	|		ИНАЧЕ ВЫБОР
	|				КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ПорядкиОкругленияОтчетности.ОКР1000)
	|					ТОГДА ЕСТЬNULL(ОборотыБюджета.СуммаПослеКорректировкиАнализа, 0) / 1000
	|				ИНАЧЕ ЕСТЬNULL(ОборотыБюджета.СуммаПослеКорректировкиАнализа, 0)
	|			КОНЕЦ
	|	КОНЕЦ КАК СуммаПослеКорректировкиАнализа
	|ИЗ
	|	(ВЫБРАТЬ
	|		БюджетОбороты.Организация КАК Организация,
	|		БюджетОбороты.СтатьяБюджета КАК СтатьяБюджета,
	|		БюджетОбороты.Статус КАК Статус,
	|		БюджетОбороты.Регистратор КАК ДокументДвижения,
	|		ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(БюджетОбороты.Регистратор) = ТИП(Документ.б_РасчетнаяТаблица)
	|					ИЛИ ТИПЗНАЧЕНИЯ(БюджетОбороты.Регистратор) = ТИП(Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации)
	|					ИЛИ ТИПЗНАЧЕНИЯ(БюджетОбороты.Регистратор) = ТИП(Документ.б_РасчетнаяТаблицаРеализации)
	|				ТОГДА ВЫБОР
	|						КОГДА МЕСЯЦ(&КонецПериодаАнализа) >= 8
	|							ТОГДА ВЫБОР
	|									КОГДА БюджетОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийБюджет.Бюджет)
	|											ИЛИ БюджетОбороты.Регистратор.ВидКорректировки = &КоррекВесна
	|										ТОГДА БюджетОбороты.СуммаОборот
	|									ИНАЧЕ 0
	|								КОНЕЦ
	|						ИНАЧЕ ВЫБОР
	|								КОГДА БюджетОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийБюджет.Бюджет)
	|									ТОГДА БюджетОбороты.СуммаОборот
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК СуммаПервоначальная,
	|		0 КАК СуммаПослеКорректировки,
	|		0 КАК СуммаПервоначальнаяАнализа,
	|		0 КАК СуммаПослеКорректировкиАнализа,
	|		0 КАК ПризнакКоличество
	|	ИЗ
	|		РегистрНакопления.б_Бюджет.Обороты(&Началопериода, &КонецПериода, Регистратор, Бюджет = &ФормируемыйБюджет) КАК БюджетОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		БюджетОбороты.Организация,
	|		БюджетОбороты.СтатьяБюджета,
	|		БюджетОбороты.Статус,
	|		БюджетОбороты.Регистратор,
	|		0,
	|		БюджетОбороты.СуммаОборот,
	|		0,
	|		0,
	|		0
	|	ИЗ
	|		РегистрНакопления.б_Бюджет.Обороты(&Началопериода, &КонецПериода, Регистратор, Бюджет = &ФормируемыйБюджет) КАК БюджетОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		БюджетОбороты.Организация,
	|		БюджетОбороты.СтатьяБюджета,
	|		БюджетОбороты.Статус,
	|		БюджетОбороты.Регистратор,
	|		0,
	|		0,
	|		ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(БюджетОбороты.Регистратор) = ТИП(Документ.б_РасчетнаяТаблица)
	|					ИЛИ ТИПЗНАЧЕНИЯ(БюджетОбороты.Регистратор) = ТИП(Документ.б_РасчетнаяТаблицаРасходовПоПеремещениюРеализации)
	|					ИЛИ ТИПЗНАЧЕНИЯ(БюджетОбороты.Регистратор) = ТИП(Документ.б_РасчетнаяТаблицаРеализации)
	|				ТОГДА ВЫБОР
	|						КОГДА МЕСЯЦ(&КонецПериодаАнализа) >= 8
	|							ТОГДА ВЫБОР
	|									КОГДА БюджетОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийБюджет.Бюджет)
	|											ИЛИ БюджетОбороты.Регистратор.ВидКорректировки = &КоррекВесна
	|										ТОГДА БюджетОбороты.СуммаОборот
	|									ИНАЧЕ 0
	|								КОНЕЦ
	|						ИНАЧЕ ВЫБОР
	|								КОГДА БюджетОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийБюджет.Бюджет)
	|									ТОГДА БюджетОбороты.СуммаОборот
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		0,
	|		0
	|	ИЗ
	|		РегистрНакопления.б_Бюджет.Обороты(&НачалопериодаАнализа, &КонецПериодаАнализа, Регистратор, Бюджет = &ФормируемыйБюджет) КАК БюджетОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		БюджетФактОбороты.Организация,
	|		БюджетФактОбороты.СтатьяБюджета,
	|		БюджетФактОбороты.Статус,
	|		БюджетФактОбороты.Регистратор,
	|		0,
	|		0,
	|		0,
	|		0,
	|		БюджетФактОбороты.ПризнакКоличествоОборот
	|	ИЗ
	|		РегистрНакопления.б_БюджетФакт.Обороты(&НачалоПредыдущегопериода, &КонецПредыдущегоПериода, Регистратор, Бюджет = &ФормируемыйБюджет) КАК БюджетФактОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Фактпериода.Организация,
	|		Фактпериода.СтатьяБюджета,
	|		Фактпериода.Статус,
	|		Фактпериода.ДокументДвижения,
	|		Фактпериода.СуммаПервоначальная,
	|		Фактпериода.СуммаПослеКорректировки,
	|		Фактпериода.СуммаПервоначальнаяАнализа,
	|		Фактпериода.СуммаПослеКорректировкиАнализа,
	|		Фактпериода.ПризнакКоличество
	|	ИЗ
	|		ФактическийОборот КАК Фактпериода
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЕСТЬNULL(ФактическийОборотПоБУ.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)),
	|		ЗависимостиСтатейБюджета.ЗависимаяСтатья,
	|		ФактическийОборотПоБУ.Статус,
	|		ЕСТЬNULL(ФактическийОборотПоБУ.ДокументДвижения, NULL),
	|		0,
	|		0,
	|		0,
	|		ЕСТЬNULL(ФактическийОборотПоБУ.СуммаПослеКорректировкиАнализа, 0) * ЗависимостиСтатейБюджета.ПризнакСуммы,
	|		0
	|	ИЗ
	|		РегистрСведений.б_ЗависимыеСтатьиДляФакторногоАнализа КАК ЗависимостиСтатейБюджета
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ФактическийОборот КАК ФактическийОборотПоБУ
	|			ПО ЗависимостиСтатейБюджета.ВлияющаяСтатья = ФактическийОборотПоБУ.СтатьяБюджета
	|	ГДЕ
	|		ЗависимостиСтатейБюджета.Бюджет = &ФормируемыйБюджет) КАК ОборотыБюджета";

	Запрос.УстановитьПараметр("Организация",мСписокСтруктурныхЕдиниц);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения",ЕдиницаИзмерения);
	Запрос.УстановитьПараметр("ФормируемыйБюджет",ФормируемыйБюджет);
	Запрос.УстановитьПараметр("НачалоПериода",НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода",КонецДня(КонецГода(КонецПериода)));
	Запрос.УстановитьПараметр("НачалоПериодаАнализа",НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериодаАнализа",КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("НачалоПредыдущегопериода", НачалоДня(Дата(Год(НачалоПериода)-1,1,1)));
	Запрос.УстановитьПараметр("КонецПредыдущегоПериода",КонецДня(Дата(Год(НачалоПериода)-1,12,31)));
	
	Запрос.УстановитьПараметр("мСписокСчетовПоставщиков",мСписокСчетовПоставщиков);
	Запрос.УстановитьПараметр("мСубконтоОС",мСубконтоОС);
	Запрос.УстановитьПараметр("мСубконтоНМА",мСубконтоНМА);
	Запрос.УстановитьПараметр("мСубконтоСтатьиЗатрат",мСубконтоСтатьиЗатрат);
	Запрос.УстановитьПараметр("мСубконтоДоходы",мСубконтоДоходы);
	Запрос.УстановитьПараметр("мСубконтоТипыОпераций",мСубконтоТипыОпераций);
	Запрос.УстановитьПараметр("КоррекВесна", Справочники.б_ВидыКорректировок.НайтиПоРеквизиту("НомерМесяца",4));
	
	Возврат Запрос.Выполнить();


КонецФункции

Процедура ОбработкаРезультатаОтчета(Результат)
	
	ТиповыеОтчеты.ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);

КонецПроцедуры

// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	//ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	ЗаполнитьНачальныеНастройки();
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	
	СтруктураНастроек.Вставить("мСписокПодразделений", мСписокПодразделений);
	СтруктураНастроек.Вставить("мСписокСтруктурныхЕдиниц", мСписокСтруктурныхЕдиниц);
	СтруктураНастроек.Вставить("мДеревоСтруктурныхЕдиниц", мДеревоСтруктурныхЕдиниц);
	
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);

КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры


Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли
мСписокИсточниковФинансирования = Новый СписокЗначений;
мСписокСтруктурныхЕдиниц = Новый СписокЗначений;
мСписокПодразделений = Новый СписокЗначений;
мДеревоСтруктурныхЕдиниц = Новый ДеревоЗначений;

ВедётсяУчетПоПодразделениям = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();

РежимРасшифровки = Ложь;