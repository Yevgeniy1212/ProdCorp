﻿Перем мУчетнаяПолитикаПоБухгалтерскомуУчету Экспорт;
Перем мОтображатьСтруктурныеПодразделения Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Производит автозаполнение табличной части ТребованияНакладные
//
Процедура Автозаполнение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НЕ ЕСТЬNULL(ТребованиеНакладная.Проведен, ЛОЖЬ) КАК Отметка,
	|	ОтчетПроизводстваЗаСменуПродукция.Номенклатура КАК Продукция,
	|	ОтчетПроизводстваЗаСменуПродукция.Количество,
	|	ОтчетПроизводстваЗаСменуПродукция.Спецификация,
	|	ЕСТЬNULL(ТребованиеНакладная.Ссылка, &ПустаяТН) КАК ТребованиеНакладная,
	|	ВЫБОР
	|		КОГДА ТребованиеНакладная.СубконтоЗатратБУ1 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ТребованиеНакладная.СубконтоЗатратБУ1
	|		КОГДА ТребованиеНакладная.СубконтоЗатратБУ2 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ТребованиеНакладная.СубконтоЗатратБУ2
	|		КОГДА ТребованиеНакладная.СубконтоЗатратБУ3 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ТребованиеНакладная.СубконтоЗатратБУ3
	|		ИНАЧЕ &ПустаяСтатьяЗатрат
	|	КОНЕЦ КАК СтатьяЗатрат
	|ИЗ
	|	Документ.ОтчетПроизводстваЗаСмену.Продукция КАК ОтчетПроизводстваЗаСменуПродукция
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТребованиеНакладная КАК ТребованиеНакладная
	|		ПО ОтчетПроизводстваЗаСменуПродукция.Ссылка.Ссылка = ТребованиеНакладная.ДокументОснование
	|			И ОтчетПроизводстваЗаСменуПродукция.Номенклатура = ТребованиеНакладная.Номенклатура
	|ГДЕ
	|	ОтчетПроизводстваЗаСменуПродукция.Ссылка.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ОтчетПроизводстваЗаСмену);
	Запрос.УстановитьПараметр("ПустаяТН", Документы.ТребованиеНакладная.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяСтатьяЗатрат", Справочники.СтатьиЗатрат.ПустаяСсылка());
	ТребованияНакладные.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // Автозаполнение()

// Процедура заполняет счета учета по бухгалтерскому и налоговому учету.
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧасти(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ) Экспорт

	СчетаУчета = ПроцедурыБухгалтерскогоУчета.ПолучитьСчетаУчетаНоменклатуры(Организация, СтрокаТЧ.Номенклатура);

	Если ЗаполнятьБУ = Истина Тогда
		СтрокаТЧ.СчетБУ = СчетаУчета.СчетУчетаБУ;
	ИначеЕсли ЗаполнятьБУ = Ложь Тогда
		СтрокаТЧ.СчетБУ = ПланыСчетов.Типовой.ПустаяСсылка();
	КонецЕсли;

	Если ЗаполнятьНУ = Истина Тогда
		СтрокаТЧ.СчетНУ = СчетаУчета.СчетУчетаНУ;
	ИначеЕсли ЗаполнятьНУ = Ложь Тогда
		СтрокаТЧ.СчетНУ = ПланыСчетов.Налоговый.ПустаяСсылка();
	КонецЕсли;

КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧасти()

// Создает документы ТН по отмеченным строкам
//
// Параметры
//  нет
//
Процедура СоздатьТН() Экспорт

	Основание = "Отчет производства за смену №" + ОтчетПроизводстваЗаСмену.Номер + " от " + Формат(ОтчетПроизводстваЗаСмену.Дата, "ДФ=дд.ММ.гггг");
	
	Для Каждого СтрокаТаблицы Из ТребованияНакладные Цикл
		
		Если СтрокаТаблицы.Отметка И НЕ ЗначениеЗаполнено(СтрокаТаблицы.ТребованиеНакладная) Тогда
			
			ДокументТН = Документы.ТребованиеНакладная.СоздатьДокумент();
			ФормаДокумента = ДокументТН.ПолучитьФорму();
			
			ДокументТН.Дата		 		 		= ДатаФормирования;
			ДокументТН.Организация       		= ОтчетПроизводстваЗаСмену.Организация;
			ДокументТН.СтруктурноеПодразделение = ОтчетПроизводстваЗаСмену.СтруктурноеПодразделение;
			ДокументТН.ДокументОснование 		= ОтчетПроизводстваЗаСмену.Ссылка;
			ДокументТН.СчетЗатратБУ      		= ОтчетПроизводстваЗаСмену.СчетЗатратБУ;
			ДокументТН.СубконтоЗатратБУ1 		= ОтчетПроизводстваЗаСмену.ПодразделениеОрганизации;
			ДокументТН.СубконтоЗатратБУ2 		= ОтчетПроизводстваЗаСмену.НоменклатурнаяГруппа; 
			ДокументТН.СубконтоЗатратБУ3 		= СтрокаТаблицы.СтатьяЗатрат; 
			ДокументТН.Склад  			 		= ОтчетПроизводстваЗаСмену.Склад;
			ДокументТН.Номенклатура      		= СтрокаТаблицы.Продукция;
			#Если Клиент Тогда
				ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(ДокументТН.Организация, ДокументТН.Дата);
				ДокументТН.УчитыватьКПН = ОрганизацияПлательщикНалогаНаПрибыль;
				ДокументТН.ВидУчетаНУ = ?(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОтражатьДокументыВНалоговомУчете"), Справочники.ВидыУчетаНУ.НУ,Справочники.ВидыУчетаНУ.НеОтражаетсяВНУ) ;
				
				Если ЗначениеЗаполнено(ДокументТН.ВидУчетаНУ) Тогда 
					ДокументТН.СубконтоЗатратНУ1 = ОтчетПроизводстваЗаСмену.ПодразделениеОрганизации;
					ДокументТН.СубконтоЗатратНУ2 = ОтчетПроизводстваЗаСмену.НоменклатурнаяГруппа; 
					ДокументТН.СубконтоЗатратНУ3 = СтрокаТаблицы.СтатьяЗатрат; 
			    КонецЕсли;
				
			#КонецЕсли
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	СпецификацииНоменклатурыИсходныеКомплектующие.Номенклатура КАК Номенклатура,
			               |	СпецификацииНоменклатурыИсходныеКомплектующие.Номенклатура.БазоваяЕдиницаИзмерения КАК ЕдиницаИзмерения,
			               |	ВЫБОР
			               |		КОГДА СпецификацииНоменклатуры.Количество = 0
			               |			ТОГДА 0
			               |		ИНАЧЕ ВЫРАЗИТЬ(&КоличествоПродукции * СпецификацииНоменклатурыИсходныеКомплектующие.Количество / СпецификацииНоменклатуры.Количество КАК ЧИСЛО(15, 3))
			               |	КОНЕЦ КАК Количество
			               |ИЗ
			               |	Справочник.СпецификацииНоменклатуры КАК СпецификацииНоменклатуры
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК СпецификацииНоменклатурыИсходныеКомплектующие
			               |		ПО (СпецификацииНоменклатурыИсходныеКомплектующие.Ссылка = СпецификацииНоменклатуры.Ссылка)
			               |ГДЕ
			               |	СпецификацииНоменклатуры.Ссылка = &СсылкаСпецификацииНоменклатуры";
						   
			Запрос.УстановитьПараметр("КоличествоПродукции", 			СтрокаТаблицы.Количество);
			Запрос.УстановитьПараметр("СсылкаСпецификацииНоменклатуры", СтрокаТаблицы.Спецификация);
			
			Результат = Запрос.Выполнить();
			
			ТаблицаМатериалов = Результат.Выгрузить();
			ТаблицаМатериалов.Свернуть("Номенклатура,ЕдиницаИзмерения","Количество");

			ДокументТН.Материалы.Загрузить(ТаблицаМатериалов);

			Для Каждого Стр Из ДокументТН.Материалы Цикл
				ЗаполнитьСчетаУчетаВСтрокеТабЧасти(Стр, "Материалы", Истина,  ДокументТН.УчитыватьКПН);
				Стр.Коэффициент      = 1;
			КонецЦикла;
			
			УправлениеПроизводством.ЗаполнитьСчетНалоговогоУчетаВСтрокеТабличногоПоля(ДокументТН.ЭтотОбъект, , , ДокументТН.Дата);
			#Если Клиент Тогда
			ЭлементыФормы = ФормаДокумента.ЭлементыФормы;
			
			ПроцедурыБухгалтерскогоУчета.ПриВыбореСчетаВТабличномПоле(ДокументТН.СчетЗатратНУ,
	                             ДокументТН.СубконтоЗатратНУ1,
	                             ЭлементыФормы.СубконтоЗатратНУ1,
	                             ДокументТН.СубконтоЗатратНУ2,
	                             ЭлементыФормы.СубконтоЗатратНУ2,
	                             ДокументТН.СубконтоЗатратНУ3,
	                             ЭлементыФормы.СубконтоЗатратНУ3);
			#КонецЕсли
					 
			ДокументТН.Записать();
			
			СтрокаТаблицы.ТребованиеНакладная	= ДокументТН.Ссылка;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // СоздатьРКО()

// Изменяет даты у существующих документов ТН по отмеченным строкам
//
// Параметры
//  НоваяДатаДок - новое значение даты, которую надо установить
//
Процедура ИзменитьДатыТН(НоваяДатаДок) Экспорт
	
	Для Каждого СтрокаТаблицы Из ТребованияНакладные Цикл
		
		Если СтрокаТаблицы.Отметка 
				И ЗначениеЗаполнено(СтрокаТаблицы.ТребованиеНакладная) 
				И НачалоДня(СтрокаТаблицы.ТребованиеНакладная.Дата) <> НачалоДня(НоваяДатаДок) Тогда
			
			ДокументТН 		= СтрокаТаблицы.ТребованиеНакладная.ПолучитьОбъект();
			ДокументТН.Дата	= ДатаФормирования;
			
			Если ДокументТН.Проведен Тогда
			    Попытка 
					ДокументТН.Записать(РежимЗаписиДокумента.Проведение);
				Исключение
					Сообщить("Дата документа " + СтрокаТаблицы.ТребованиеНакладная + " не изменена!", СтатусСообщения.Важное);
				КонецПопытки;
			Иначе
				ДокументТН.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ИзменитьДатыРКО()

мОтображатьСтруктурныеПодразделения = ОбщегоНазначения.ПолучитьПризнакОтображенияСтруктурныхПодразделений();