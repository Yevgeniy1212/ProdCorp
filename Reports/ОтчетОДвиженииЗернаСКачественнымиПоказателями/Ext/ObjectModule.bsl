﻿Перем мСписокИсточниковФинансирования Экспорт;
Перем мСписокСтруктурныхЕдиниц Экспорт;
Перем мСписокПодразделений Экспорт;
Перем мДеревоСтруктурныхЕдиниц Экспорт;
Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем ПромежуточныеДанные Экспорт;
Перем РежимРасшифровки Экспорт;
Перем ВедётсяУчетПоПодразделениям Экспорт;

#Если Клиент Тогда

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	СтандартныеОтчеты.ЗаполнитьДанныеОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Результат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ВыводЗаголовкаОтчета(ЭтотОбъект, Результат);
	ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
	//КомпоновщикНастроек.Восстановить();
	//НастройкаКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	
	СтандартныеОтчеты.ВывестиОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	// Выполним дополнительную обработку Результата отчета
	ОбработкаРезультатаОтчета(Результат);
	  ВывестиПодписи(Результат);

	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(Результат, ПолучитьТекстЗаголовка(), Строка(глТекущийПользователь));
	
	Возврат;
	
КонецПроцедуры

Процедура ВывестиПодписи(Результат)
	
	// выводим подвал
	Макет = ПолучитьОбщийМакет("ПодписиОтчета");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подписи");
	
	//организацию берем также первую из списка
	ИскомаяОрганизация = мСписокСтруктурныхЕдиниц[0].Значение;
	Если Не ЗначениеЗаполнено(ИскомаяОрганизация) Тогда
		ИскомаяОрганизация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),
																							           "ОсновнаяОрганизация");             
	КонецЕсли;
																								   
	ОтветЛица = ОбщегоНазначения.ОтветственныеЛицаОрганизаций(ИскомаяОрганизация, КонецПериода, глЗначениеПеременной("глТекущийПользователь").ФизЛицо);
	ОбластьПодвал.Параметры.Заполнить(ОтветЛица);															   
	
	Результат.Вывести(ОбластьПодвал);

КонецПроцедуры


// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	////Если ЗначениеЗаполнено(Период) Тогда
	////	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Период", КонецДня(Период) + 1);
	////Иначе
	////	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Период", Дата(3999, 11, 1));
	////КонецЕсли;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВыборкаДанных = ПолучитьВыборку();
	ВнешниеНаборыДанных.Вставить("ТаблицаДанных", ВыборкаДанных);
	
	Если мДеревоСтруктурныхЕдиниц.Колонки.Количество() = 0 Тогда 
		
		СписокСтруктурныхЕдиниц = Новый СписокЗначений;
		СписокСтруктурныхЕдиниц.ЗагрузитьЗначения(мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
		
		Для Каждого СтрПодразделение Из мСписокПодразделений Цикл 
			СписокСтруктурныхЕдиниц.Добавить(СтрПодразделение.Значение);
		КонецЦикла;		
				
		мДеревоСтруктурныхЕдиниц = СтандартныеОтчеты.СформироватьДеревоСЕ(, СписокСтруктурныхЕдиниц);
		
	КонецЕсли;
	
	ТиповыеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, мДеревоСтруктурныхЕдиниц);
	
КонецПроцедуры

Функция ПолучитьВыборку()
	
	запрос = Новый Запрос;
	
	Запрос.Текст  =
	"ВЫБРАТЬ
	|	ур_ЗерноНаСкладахОстаткиИОбороты.Организация,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.Видзерна,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.ВидРесурса,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.ВидРесурса.ТипРесурса КАК ТипРесурса,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.Склад,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.Склад.Область КАК Область,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.ЗерноваяРасписка,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.Культура,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.Класс,
	|	ур_ЗерноНаСкладахОстаткиИОбороты.ГодУрожая,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ур_ВариантыВыводаОтчетовПоУчетуЗерна.килограммы)
	|			ТОГДА ЕСТЬNULL(ОстаткиЗабронированные.Забронировано, 0) * 1000
	|		ИНАЧЕ ЕСТЬNULL(ОстаткиЗабронированные.Забронировано, 0)
	|	КОНЕЦ КАК Забронировано,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ур_ВариантыВыводаОтчетовПоУчетуЗерна.килограммы)
	|			ТОГДА ЕСТЬNULL(ОстаткиЗалога.Заложено, 0) * 1000
	|		ИНАЧЕ ЕСТЬNULL(ОстаткиЗалога.Заложено, 0)
	|	КОНЕЦ КАК Заложено,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ур_ВариантыВыводаОтчетовПоУчетуЗерна.килограммы)
	|			ТОГДА ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесКонечныйОстаток, 0) * 1000
	|		ИНАЧЕ ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесКонечныйОстаток, 0)
	|	КОНЕЦ КАК ОстатокНаКонец,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ур_ВариантыВыводаОтчетовПоУчетуЗерна.килограммы)
	|			ТОГДА ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесНачальныйОстаток, 0) * 1000
	|		ИНАЧЕ ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесНачальныйОстаток, 0)
	|	КОНЕЦ КАК ОстатокНаНачало,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ур_ВариантыВыводаОтчетовПоУчетуЗерна.килограммы)
	|			ТОГДА ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесПриход, 0) * 1000
	|		ИНАЧЕ ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесПриход, 0)
	|	КОНЕЦ КАК Приход,
	|	ВЫБОР
	|		КОГДА &ЕдиницаИзмерения = ЗНАЧЕНИЕ(Перечисление.ур_ВариантыВыводаОтчетовПоУчетуЗерна.килограммы)
	|			ТОГДА ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесРасход, 0) * 1000
	|		ИНАЧЕ ЕСТЬNULL(ур_ЗерноНаСкладахОстаткиИОбороты.ЗачтенныйВесРасход, 0)
	|	КОНЕЦ КАК Расход
	|ИЗ
	|	РегистрНакопления.ур_ЗерноНаСкладах.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , ) КАК ур_ЗерноНаСкладахОстаткиИОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ур_ЗабронированноеЗерноОстатки.Организация КАК Организация,
	|			ур_ЗабронированноеЗерноОстатки.ВидРесурса КАК ВидРесурса,
	|			ур_ЗабронированноеЗерноОстатки.Склад КАК Склад,
	|			ур_ЗабронированноеЗерноОстатки.Зерноваярасписка КАК Зерноваярасписка,
	|			ур_ЗабронированноеЗерноОстатки.Культура КАК Культура,
	|			ур_ЗабронированноеЗерноОстатки.Класс КАК Класс,
	|			ур_ЗабронированноеЗерноОстатки.ЗачтенныйвесОстаток КАК Забронировано
	|		ИЗ
	|			РегистрНакопления.ур_ЗабронированноеЗерно.Остатки(&КонецПериода, ) КАК ур_ЗабронированноеЗерноОстатки) КАК ОстаткиЗабронированные
	|		ПО ур_ЗерноНаСкладахОстаткиИОбороты.Организация = ОстаткиЗабронированные.Организация
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.ВидРесурса = ОстаткиЗабронированные.ВидРесурса
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.Склад = ОстаткиЗабронированные.Склад
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.ЗерноваяРасписка = ОстаткиЗабронированные.Зерноваярасписка
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.Культура = ОстаткиЗабронированные.Культура
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.Класс = ОстаткиЗабронированные.Класс
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ур_ЗерноВЗалогеОстатки.Организация КАК Организация,
	|			ур_ЗерноВЗалогеОстатки.ВидРесурса КАК ВидРесурса,
	|			ур_ЗерноВЗалогеОстатки.Склад КАК Склад,
	|			ур_ЗерноВЗалогеОстатки.Зерноваярасписка КАК Зерноваярасписка,
	|			ур_ЗерноВЗалогеОстатки.Культура КАК Культура,
	|			ур_ЗерноВЗалогеОстатки.Класс КАК Класс,
	|			ур_ЗерноВЗалогеОстатки.ГодУрожая КАК ГодУрожая,
	|			ур_ЗерноВЗалогеОстатки.ЗачтенныйвесОстаток КАК Заложено
	|		ИЗ
	|			РегистрНакопления.ур_ЗерноВЗалоге.Остатки(&КонецПериода, ) КАК ур_ЗерноВЗалогеОстатки) КАК ОстаткиЗалога
	|		ПО ур_ЗерноНаСкладахОстаткиИОбороты.Организация = ОстаткиЗалога.Организация
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.ВидРесурса = ОстаткиЗалога.ВидРесурса
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.Склад = ОстаткиЗалога.Склад
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.ЗерноваяРасписка = ОстаткиЗалога.Зерноваярасписка
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.Культура = ОстаткиЗалога.Культура
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.Класс = ОстаткиЗалога.Класс
	|			И ур_ЗерноНаСкладахОстаткиИОбороты.ГодУрожая = ОстаткиЗалога.ГодУрожая
	|ГДЕ
	|	НЕ ур_ЗерноНаСкладахОстаткиИОбороты.Склад.Наименование ПОДОБНО &ПараметрСтанция1
	|	И НЕ ур_ЗерноНаСкладахОстаткиИОбороты.Склад.Наименование ПОДОБНО &ПараметрСтанция2
	|	И НЕ ур_ЗерноНаСкладахОстаткиИОбороты.Склад.Наименование ПОДОБНО &ПараметрСтанция3
	|	И НЕ ур_ЗерноНаСкладахОстаткиИОбороты.Склад.Наименование ПОДОБНО &ПараметрСтанция4
	|	И НЕ ур_ЗерноНаСкладахОстаткиИОбороты.Склад.Наименование ПОДОБНО &ПараметрСтанция5";
	
	////Запрос.УстановитьПараметр("Период",КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("НачалоПериода",НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",КонецПериода);
	Запрос.УстановитьПараметр("ПараметрСтанция1","%ст.%");
	Запрос.УстановитьПараметр("ПараметрСтанция2","%станция%");
	Запрос.УстановитьПараметр("ПараметрСтанция3","%Курык%");
	Запрос.УстановитьПараметр("ПараметрСтанция4","%границе Достык%");
	Запрос.УстановитьПараметр("ПараметрСтанция5","%порту%");
	Запрос.УстановитьПараметр("ЕдиницаИзмерения",ЕдиницаИзмеренияОтчета);
	
	Возврат Запрос.Выполнить();
КонецФункции

Процедура ИнициализацияОтчета() Экспорт
	
	СтандартныеОтчеты.ИнициализацияОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	СтандартныеОтчеты.ВыводЗаголовкаСпециализированногоОтчета(ОтчетОбъект, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт     
		
	ЗаголовокОтчета = "Отчет о количественно-качественном наличии зерна (БЕЗ СТАНЦИЙ) " + " на " + Формат(КонецПериода, "ДФ=dd.MM.yyyy")+" ("+ЕдиницаИзмеренияОтчета+")";

	Возврат ?(ОрганизацияВНачале, ЗаголовокОтчета, ЗаголовокОтчета + " " + СтандартныеОтчеты.ПолучитьТекстОрганизация(ЭтотОбъект));
		
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