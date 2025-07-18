﻿
#Если Клиент Тогда
	
Перем ИтогоСуммаБезНДС;
Перем ИтогоСуммаНДС;
Перем ИтогоСумма;
Перем мВалютаРегламентированногоУчета;
Перем СписокОснований;
Перем мСписокСтруктурныхЕдиниц Экспорт;

Функция  СформироватьСписокДокументовОснований(СФ)
	Если Не ЗначениеЗаполнено(СФ) Тогда
		Возврат "";
	КонецЕсли;
	НомерСтроки = 1;
	СписокДокументов = "";
	СписокОснований = Новый СписокЗначений;
	КоличествоСтрок = СФ.ДокументыОснования.Количество();
	
	Для Каждого Осн Из СФ.ДокументыОснования Цикл
		РасчетныйДокумент = Осн.ДокументОснование;
		РасчетныйДокументПредставление = "";			
		Если ЗначениеЗаполнено(Осн.ДокументОснование) Тогда
			
			//Возможны проблемы с RLS
			Попытка
				РасчетныйДокументПредставление = РасчетныйДокумент.Метаданные().Синоним +" " 
				+ ОбщегоНазначения.ПолучитьНомерНаПечать(РасчетныйДокумент, глСписокПрефиксовУзлов) + " от " 
				+ Формат(РасчетныйДокумент.Дата, "ДФ=dd.MM.yyyy");
			Исключение
			КонецПопытки;
		КонецЕсли;
	
		СписокДокументов = СписокДокументов + РасчетныйДокументПредставление + ?(НомерСтроки = КоличествоСтрок, "", ", ");
		СписокОснований.Добавить(Осн.ДокументОснование);
		НомерСтроки = НомерСтроки  + 1;
	КонецЦикла;
	
	Возврат СписокДокументов;
		
КонецФункции

// Формирование отчета в виде табличного документа.
// Параметры:
//  ТабличныйДокумент - макет отчета.
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
		
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	Макет = ПолучитьМакет("Макет");

	// Вывод шапки
		// Вывод шапки	
	Секция =  Макет.ПолучитьОбласть("Шапка|ОбластьОтчета");
	
	Секция.Параметры.НачалоПериода = Формат(НачалоПериода, "ДФ=dd.MM.yyyy");
	Секция.Параметры.КонецПериода = Формат(КонецПериода, "ДФ=dd.MM.yyyy");
	Секция.Параметры.НазваниеОрганизации = РаботаСДиалогами.ВыгрузитьСписокВСтроку(мСписокСтруктурныхЕдиниц);
	
	ТабличныйДокумент.Вывести(Секция);
	
	Если ОтображатьДоговора Тогда
		ДопСекция =  Макет.ПолучитьОбласть("Шапка|ОбластьДоговора");
		ТабличныйДокумент.Присоединить(ДопСекция);
	КонецЕсли;    
	
	Если ОтображатьКомментарий Тогда
		ДопСекция =  Макет.ПолучитьОбласть("Шапка|ОбластьКомментария");
		ТабличныйДокумент.Присоединить(ДопСекция);
	КонецЕсли;
	
	
	//выводим шапку таблицы	
	СекцияШапкаТаблицы =  Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьОтчета");	
	
	// именуем область для возможности повтора шапки таблицы при печати
	СекцияШапкаТаблицы.Область("R1:R3").Имя = "ШапкаТаблицы";
	
	ТабличныйДокумент.Вывести(СекцияШапкаТаблицы);
	
	Если ОтображатьДоговора Тогда
		ДопСекция =  Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьДоговора");
		ТабличныйДокумент.Присоединить(ДопСекция);
	КонецЕсли;    
	
	Если ОтображатьКомментарий Тогда
		ДопСекция =  Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьКомментария");
		ТабличныйДокумент.Присоединить(ДопСекция);
	КонецЕсли;
	
	// Выполнение запроса.
	Результат = ПодготовитьОтчетКВыводуНаПечать();
	
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	СекцияДоп 	= Макет.ПолучитьОбласть("ДопСтрока|ОбластьОтчета");
	Итог 		=  Макет.ПолучитьОбласть("Итог|ОбластьОтчета");
	
	СекцияДопКом      = Макет.ПолучитьОбласть("ДопСтрока|ОбластьКомментария");
	СекцияДопДоговора =  Макет.ПолучитьОбласть("ДопСтрока|ОбластьДоговора");
	
	ИтогКом        =  Макет.ПолучитьОбласть("Итог|ОбластьКомментария");
	ИтогДоговора   =  Макет.ПолучитьОбласть("Итог|ОбластьКомментария");
	
		
	Если Результат.Пустой() Тогда
		Секция 	=  Макет.ПолучитьОбласть("Строка|ОбластьОтчета");		
        ТабличныйДокумент.Вывести(Секция);
		
		Если ОтображатьДоговора тогда
			СекцияДоговора =  Макет.ПолучитьОбласть("Строка|ОбластьДоговора");		
			ТабличныйДокумент.Присоединить(СекцияДоговора);
		КонецЕсли;
		Если ОтображатьКомментарий Тогда
			СекцияКом      = Макет.ПолучитьОбласть("Строка|ОбластьКомментария");
			ТабличныйДокумент.Присоединить(СекцияКом);
		КонецЕсли;

		УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ТабличныйДокумент, , Строка(глТекущийПользователь));
	    Возврат;
		
	КонецЕсли; 
	Секция 	=  Макет.ПолучитьОбласть("Строка|ОбластьОтчета");
	СекцияДоговора =  Макет.ПолучитьОбласть("Строка|ОбластьДоговора");
	СекцияКом      = Макет.ПолучитьОбласть("Строка|ОбластьКомментария");
	
	Счетчик 			= 0;
	ИтогоСуммаБезНДС 	= 0;
	ИтогоСуммаНДС 	 	= 0;
	ИтогоСумма		 	= 0;
	
	ИтогоСуммаБезНДСОбщ = 0;
	ИтогоСуммаНДСОбщ = 0;
	ИтогоСуммаОбщ = 0;
				
	Если ГруппироватьПоСпособуВыписки Тогда
		СекцияСпособВыписки = ?(ОтображатьКомментарий, Макет.ПолучитьОбласть("СпособВыписки"), Макет.ПолучитьОбласть("СпособВыписки|ОбластьОтчета"));
	КонецЕсли;
	
	Если  ГруппироватьПоКонтрагентам Тогда
		//Режим построения с группировкой по контрагенту
		СекцияКонтрагента	      = Макет.ПолучитьОбласть("Контрагент|ОбластьОтчета");
		ГруппировкаПоКонтрагенту = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ГруппировкаПоКонтрагенту.Следующий() Цикл
			
			СекцияКонтрагента.Параметры.КонтрагентНаименование = ГруппировкаПоКонтрагенту.ПоставщикНаименование;
			СекцияКонтрагента.Параметры.Контрагент			   = ГруппировкаПоКонтрагенту.Поставщик;
			
			ТабличныйДокумент.Вывести(СекцияКонтрагента,1);
			ТабличныйДокумент.НачатьГруппуСтрок();
			
			Если ОтображатьДоговора тогда
				СекцияКонтрагентаДоговор  =  Макет.ПолучитьОбласть("Контрагент|ОбластьДоговора");
				ТабличныйДокумент.Присоединить(СекцияКонтрагентаДоговор,1);
			КонецЕсли;
			Если ОтображатьКомментарий Тогда
				СекцияКонтрагентаКом      = Макет.ПолучитьОбласть("Контрагент|ОбластьКомментария");
				ТабличныйДокумент.Присоединить(СекцияКонтрагентаКом,1);
			КонецЕсли;

			Если ГруппироватьПоСпособуВыписки Тогда
				
				ГруппировкаСпособВыписки = ГруппировкаПоКонтрагенту.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ГруппировкаСпособВыписки.Следующий() Цикл
					СекцияСпособВыписки.Параметры.СпособВыписки = ГруппировкаСпособВыписки.СпособВыписки;
					ТабличныйДокумент.Вывести(СекцияСпособВыписки, 1);
					ТабличныйДокумент.НачатьГруппуСтрок();
					
					Документ = ГруппировкаСпособВыписки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					
					Пока Документ.Следующий() Цикл
						Секция.Параметры.Заполнить(Документ);
						ВыводСтроки(ТабличныйДокумент,Документ, Секция,СекцияДоговора, СекцияКом, СекцияДоп, СекцияДопДоговора, СекцияДопКом, Счетчик);
					КонецЦикла; 
					ТабличныйДокумент.ЗакончитьГруппуСтрок();
				КонецЦикла;
				
			Иначе
				
				Документ = ГруппировкаПоКонтрагенту.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока Документ.Следующий() Цикл				
					Секция.Параметры.Заполнить(Документ);						
					
					ВыводСтроки(ТабличныйДокумент,Документ, Секция,СекцияДоговора, СекцияКом, СекцияДоп, СекцияДопДоговора, СекцияДопКом, Счетчик);
					
				КонецЦикла; 
				
			КонецЕсли;
			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
		КонецЦикла; 
		
	Иначе
		
		Если ГруппироватьПоСпособуВыписки Тогда
			
			ГруппировкаСпособВыписки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ГруппировкаСпособВыписки.Следующий() Цикл
				СекцияСпособВыписки.Параметры.СпособВыписки = ГруппировкаСпособВыписки.СпособВыписки;
					
				ИтогоСуммаБезНДС = 0;
				ИтогоСуммаНДС = 0;
				ИтогоСумма = 0;

				ТабличныйДокумент.Вывести(СекцияСпособВыписки, 1);
				ТабличныйДокумент.НачатьГруппуСтрок();
				
				Документ = ГруппировкаСпособВыписки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока Документ.Следующий() Цикл
					Секция.Параметры.Заполнить(Документ);
					ВыводСтроки(ТабличныйДокумент,Документ, Секция,СекцияДоговора, СекцияКом, СекцияДоп, СекцияДопДоговора, СекцияДопКом, Счетчик);
				КонецЦикла; 
				
				ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
				Итог.Параметры.ИтогоСуммаБезНДС = ИтогоСуммаБезНДС;
				Итог.Параметры.ИтогоСуммаНДС    = ИтогоСуммаНДС;
				Итог.Параметры.ИтогоСумма	   = ИтогоСумма;
				
				ИтогоСуммаБезНДСОбщ = ИтогоСуммаБезНДСОбщ + ИтогоСуммаБезНДС;
				ИтогоСуммаНДСОбщ = ИтогоСуммаНДСОбщ + ИтогоСуммаНДС;
				ИтогоСуммаОбщ = ИтогоСуммаОбщ + ИтогоСумма;

				ТабличныйДокумент.Вывести(Итог);

			КонецЦикла;
		Иначе
			
			// Простой режим
			Документ = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока Документ.Следующий() Цикл			
				Секция.Параметры.Заполнить(Документ);	
				
				
				ВыводСтроки(ТабличныйДокумент,Документ, Секция,СекцияДоговора, СекцияКом, СекцияДоп, СекцияДопДоговора, СекцияДопКом, Счетчик);
				
			КонецЦикла;  
			
		КонецЕсли;
		
	КонецЕсли;
	
	Итог.Параметры.ИтогоСуммаБезНДС = ИтогоСуммаБезНДС;
	Итог.Параметры.ИтогоСуммаНДС    = ИтогоСуммаНДС;
	Итог.Параметры.ИтогоСумма	   = ИтогоСумма;
	
	//Итог.Параметры.ИтогоСуммаБезНДС = ИтогоСуммаБезНДСОбщ;
	//Итог.Параметры.ИтогоСуммаНДС    = ИтогоСуммаНДСОбщ;
	//Итог.Параметры.ИтогоСумма	   = ИтогоСуммаОбщ;

	ТабличныйДокумент.Вывести(Итог);
	
	Если ОтображатьДоговора Тогда
		ТабличныйДокумент.Присоединить(ИтогДоговора); 					
	КонецЕсли;
	
	Если ОтображатьКомментарий Тогда				
		ТабличныйДокумент.Присоединить(ИтогКом);
	КонецЕсли;  	
	
	ИскомаяОрганизация = Неопределено;
	
	//выберм первую организацию в списке организаций
	Если ТипЗнч(мСписокСтруктурныхЕдиниц) = Тип("СписокЗначений") Тогда
		Если мСписокСтруктурныхЕдиниц.Количество() > 0 Тогда
			ИскомаяОрганизация = мСписокСтруктурныхЕдиниц[0].Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если ИскомаяОрганизация = Неопределено Тогда
		ИскомаяОрганизация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	КонецЕсли;  	
	
	ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
	
	ОтветЛица = ОбщегоНазначения.ОтветственныеЛицаОрганизаций(ИскомаяОрганизация, КонецДня(КонецПериода), глЗначениеПеременной("глТекущийПользователь").ФизЛицо);
	ОбластьПодписи.Параметры.Заполнить(ОтветЛица);
	ТабличныйДокумент.Вывести(ОбластьПодписи);

	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Области.ШапкаТаблицы;
	
	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ТабличныйДокумент, , Строка(глТекущийПользователь));
	
КонецПроцедуры // СформироватьОтчет()

// Функция вызывается из тела процедуры "Сформировать".
// Функция осуществляет первичную обработку результатов запроса к движениям регистра НДСПродажи,
// и по данным запроса заполняет таблицу значений, на основании которой, будет напечатана книга продаж
// Параметры:
// 	Результат - ссылка на результаты выполнения запроса к данным регистра "НДСПродажи"
//  МоментОпределенияНалоговойБазыНДС
Функция ПодготовитьОтчетКВыводуНаПечать()
	
		
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", 	КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("Организация", 	мСписокСтруктурныхЕдиниц);
	Запрос.УстановитьПараметр("Контрагент", 	КонтрагентДляОтбора);
	//ЦС
	Запрос.УстановитьПараметр("ТипОперации", 	ТипОперации);
	//ЦС
	ПризнакОтбораПоКонтрагенту = ОтбиратьПоКонтрагенту И НЕ КонтрагентДляОтбора = Справочники.Контрагенты.ПустаяСсылка();
	//ЦС
	ПризнакОтбораПоТипуОперации = ОтбиратьПоТипуОперации И НЕ ТипОперации = Справочники.ТипыОпераций.ПустаяСсылка();
	//ЦС	

	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
					  
	СписокСчетовФактурТекст = "";
	
	Если ИсключатьПрекратившиеДействие Тогда
		СписокСчетовФактурТекст = СписокСчетовФактурТекст + "
	                          |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                          |	СчетаФактурыПрекратившиеДействиеСрезПоследних.СчетФактура.Ссылка КАК Ссылка
	                          |ПОМЕСТИТЬ ВТ_ПрекратившиеДействие
	                          |ИЗ
	                          |	РегистрСведений.СчетаФактурыПрекратившиеДействие.СрезПоследних(&КонецПериода,
	                          |                                                                СчетФактура.Организация В (&Организация)
	                          |                                                                И СчетФактура.Дата МЕЖДУ &НачалоПериода И &КонецПериода) КАК СчетаФактурыПрекратившиеДействиеСрезПоследних
	                          |;";		
	КонецЕсли;
	
	СписокСчетовФактурТекст = СписокСчетовФактурТекст + "
	                          |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                          |	СчетФактураПолученный.Ссылка,
							  |	СчетФактураПолученный.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
							  |	СчетФактураПолученный.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов
	                          |ПОМЕСТИТЬ СчетФактураПолученный
	                          |ИЗ
	                          |	Документ.СчетФактураПолученный КАК СчетФактураПолученный
							  |ГДЕ
	                          |	СчетФактураПолученный.Проведен
	                          |	И СчетФактураПолученный.Организация В(&Организация)
	                          |	И СчетФактураПолученный.Дата МЕЖДУ &НачалоПериода И &КонецПериода " +?(ПризнакОтбораПоТипуОперации," И СчетФактураПолученныйДокументыОснования.ДокументОснование.ТипОперации в Иерархии(&ТипОперации)","")+ ?(ПризнакОтбораПоКонтрагенту, " И (СчетФактураПолученный.Контрагент В ИЕРАРХИИ (&Контрагент) ИЛИ СчетФактураПолученный.Поставщик В ИЕРАРХИИ (&Контрагент))","");
	Если ИсключатьПрекратившиеДействие Тогда
		СписокСчетовФактурТекст = СписокСчетовФактурТекст + "
	                          |	И НЕ СчетФактураПолученный.Ссылка В(ВЫБРАТЬ ВТ_ПрекратившиеДействие.Ссылка ИЗ ВТ_ПрекратившиеДействие)";
	КонецЕсли;
	
	Запрос.Текст = СписокСчетовФактурТекст;
	Запрос.Выполнить();
	
	Запрос.Текст   =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                  |	ДанныеТЧ.Ссылка КАК СФ,
	                  |	ДанныеТЧ.Ссылка.Дата КАК Дата,
	                  |	ДанныеТЧ.Ссылка.НомерВходящегоДокумента КАК Номер,
					  |	ДанныеТЧ.Ссылка.ДатаСовершенияОборотаПоРеализации КАК ДатаОборота,
					  | ВЫБОР
					  |		КОГДА НЕ ЕСТЬNULL(ЭСФ.ДатаВыпискиНаБумажномНосителе, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
            		  |			ТОГДА ""Обоими способами""
        			  |		ИНАЧЕ ДанныеТЧ.Ссылка.СпособПолучения
			    	  |	КОНЕЦ КАК СпособВыписки,
	                  |	ДанныеТЧ.Ссылка.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	                  |	ДанныеТЧ.Ссылка.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	                  |	ВЫБОР КОГДА ДанныеТЧ.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидыСчетовФактур.Дополнительный) Тогда ИСТИНА Иначе ЛОЖЬ Конец Дополнительная,
	                  |	ДанныеТЧ.Ссылка.Контрагент КАК Контрагент,
					  |	ДанныеТЧ.Ссылка.Поставщик КАК Поставщик,					  
					  |	ДанныеТЧ.Ссылка.ДоговорКонтрагента КАК ДоговорКонтрагента,
	                  |	ДанныеТЧ.Ссылка.СуммаВключаетНДС КАК СуммаВключаетНДС,
	                  |	ДанныеТЧ.Ссылка.ВалютаДокумента КАК ВалютаДокумента,
	                  |	ДанныеТЧ.Ссылка.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
	                  |	ДанныеТЧ.Ссылка.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
	                  |	ВЫРАЗИТЬ(ДанныеТЧ.Ссылка.Комментарий КАК СТРОКА(250)) КАК Комментарий,
	                  |	ВЫБОР
	                  |		КОГДА ВЫРАЗИТЬ(ДанныеТЧ.Ссылка.Поставщик.НаименованиеПолное КАК СТРОКА(1000)) = """"
	                  |			ТОГДА ДанныеТЧ.Ссылка.Поставщик.Наименование
	                  |		ИНАЧЕ ВЫРАЗИТЬ(ДанныеТЧ.Ссылка.Поставщик.НаименованиеПолное КАК СТРОКА(1000))
	                  |	КОНЕЦ КАК ПоставщикНаименование,
	                  |	ЕСТЬNULL(ДанныеТЧ.СтавкаНДС, 0) КАК СтавкаНДС,
	                  |	ЕСТЬNULL(ДанныеТЧ.СуммаНДС, 0) КАК СуммаНДС,
	                  |	ВЫБОР
	                  |		КОГДА ДанныеТЧ.Ссылка.СуммаВключаетНДС
	                  |			ТОГДА ЕСТЬNULL(ДанныеТЧ.Сумма, 0)
	                  |		ИНАЧЕ ЕСТЬNULL(ДанныеТЧ.Сумма, 0) + ЕСТЬNULL(ДанныеТЧ.СуммаНДС, 0)
	                  |	КОНЕЦ КАК Сумма,
	                  |	ВЫБОР
	                  |		КОГДА ДанныеТЧ.Ссылка.СуммаВключаетНДС
	                  |			ТОГДА ЕСТЬNULL(ДанныеТЧ.Сумма, 0) - ЕСТЬNULL(ДанныеТЧ.СуммаНДС, 0)
	                  |		ИНАЧЕ ЕСТЬNULL(ДанныеТЧ.Сумма, 0)
	                  |	КОНЕЦ КАК СуммаБезНДС
	                  |ИЗ
	                  |	(ВЫБРАТЬ
	                  |		СУММА(ДанныеОснований.Сумма) КАК Сумма,
	                  |		ДанныеОснований.СтавкаНДС КАК СтавкаНДС,
	                  |		СУММА(ДанныеОснований.СуммаНДС) КАК СуммаНДС,
	                  |		СчетФактураПолученный.Ссылка КАК Ссылка
	                  |	ИЗ
					  |		СчетФактураПолученный КАК СчетФактураПолученный
	                  |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                  |			СчетФактураПолученныйТовары.СтавкаНДС КАК СтавкаНДС,
	                  |			СчетФактураПолученныйТовары.Сумма КАК Сумма,
	                  |			СчетФактураПолученныйТовары.СуммаНДС КАК СуммаНДС,
	                  |			СчетФактураПолученныйТовары.Ссылка КАК Ссылка
	                  |		ИЗ
	                  |			Документ.СчетФактураПолученный.Товары КАК СчетФактураПолученныйТовары
					  |		ГДЕ
	                  |			СчетФактураПолученныйТовары.Ссылка В (ВЫБРАТЬ СчетФактураПолученный.Ссылка ИЗ СчетФактураПолученный) 
	                  |		
	                  |		ОБЪЕДИНИТЬ ВСЕ
	                  |		
	                  |		ВЫБРАТЬ
	                  |			СчетФактураПолученныйУслуги.СтавкаНДС,
	                  |			СчетФактураПолученныйУслуги.Сумма,
	                  |			СчетФактураПолученныйУслуги.СуммаНДС,
	                  |			СчетФактураПолученныйУслуги.Ссылка
	                  |		ИЗ
	                  |			Документ.СчетФактураПолученный.Услуги КАК СчетФактураПолученныйУслуги
					  |		ГДЕ
	                  |			СчетФактураПолученныйУслуги.Ссылка В (ВЫБРАТЬ СчетФактураПолученный.Ссылка ИЗ СчетФактураПолученный)
	                  |		
	                  |		ОБЪЕДИНИТЬ ВСЕ
	                  |		
	                  |		ВЫБРАТЬ
	                  |			СчетФактураПолученныйОС.СтавкаНДС,
	                  |			СчетФактураПолученныйОС.Сумма,
	                  |			СчетФактураПолученныйОС.СуммаНДС,
	                  |			СчетФактураПолученныйОС.Ссылка
	                  |		ИЗ
	                  |			Документ.СчетФактураПолученный.ОС КАК СчетФактураПолученныйОС
					  |		ГДЕ
	                  |			СчетФактураПолученныйОС.Ссылка В (ВЫБРАТЬ СчетФактураПолученный.Ссылка ИЗ СчетФактураПолученный)
	                  |		
	                  |		ОБЪЕДИНИТЬ ВСЕ
	                  |		
	                  |		ВЫБРАТЬ
	                  |			СчетФактураПолученныйНМА.СтавкаНДС,
	                  |			СчетФактураПолученныйНМА.Сумма,
	                  |			СчетФактураПолученныйНМА.СуммаНДС,
	                  |			СчетФактураПолученныйНМА.Ссылка
	                  |		ИЗ
	                  |			Документ.СчетФактураПолученный.НМА КАК СчетФактураПолученныйНМА
					  |		ГДЕ
	                  |			СчетФактураПолученныйНМА.Ссылка В (ВЫБРАТЬ СчетФактураПолученный.Ссылка ИЗ СчетФактураПолученный)) КАК ДанныеОснований
	                  |	ПО СчетФактураПолученный.Ссылка = ДанныеОснований.Ссылка
	                  |	
	                  |	СГРУППИРОВАТЬ ПО
	                  |		ДанныеОснований.СтавкаНДС,
	                  |		СчетФактураПолученный.Ссылка) КАК ДанныеТЧ	                  
					  | ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭСФ КАК ЭСФ
					  |		ПО ДанныеТЧ.Ссылка = ЭСФ.СчетФактура
					  |
	                  |УПОРЯДОЧИТЬ ПО
	                  |	Дата,
	                  |	Номер
	                  |ИТОГИ
	                  |	СУММА(СуммаНДС),
	                  |	СУММА(Сумма),
	                  |	СУММА(СуммаБезНДС)
	                  |ПО
	                  |	ОБЩИЕ";
          	
	Если ГруппироватьПоКонтрагентам Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ОБЩИЕ", ?(ГруппироватьПоСпособуВыписки, "Поставщик, СпособВыписки, СФ,СтавкаНДС", "Поставщик, СФ,СтавкаНДС"));
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "УПОРЯДОЧИТЬ ПО", "УПОРЯДОЧИТЬ ПО
		|ПоставщикНаименование, ");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ОБЩИЕ", ?(ГруппироватьПоСпособуВыписки, "СпособВыписки, СФ,СтавкаНДС",  "СФ,СтавкаНДС"));

	КонецЕсли; 
	
	Возврат Запрос.Выполнить();

КонецФункции

 Процедура ВыводСтроки(ТабличныйДокумент,СтрокаДокумента, Секция,СекцияДоговора, СекцияКом, ДопСекция,ДопСекцияДоговора, ДопСекцияКом, НомерПП)
	
		//группировка по документу Счет-фактура
		ВыборкаПоДокументамСФ = СтрокаДокумента.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		УстановитьПараметр = истина;
		Пока ВыборкаПоДокументамСФ.Следующий() Цикл    				
			
		//по Ставке 		
		ВыборкаПоДокументамВРазрезеНДС =ВыборкаПоДокументамСФ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоДокументамВРазрезеНДС.Следующий() Цикл
			ДокументОснование = СформироватьСписокДокументовОснований(ВыборкаПоДокументамВРазрезеНДС.СФ);
			
				
			Если УстановитьПараметр Тогда			
				НомерПП = НомерПП +1;
                Секция.Параметры.НомерПоПорядку = НомерПП;
				
				Секция.Параметры.РасчетныйДокументПредставление = ДокументОснование; 
				Секция.Параметры.СписокОснований  	= СписокОснований; 
				Секция.Параметры.СчетФактура 		= ВыборкаПоДокументамВРазрезеНДС.СФ;
				Секция.Параметры.НомерДатаРегистрации = СокрЛП(ВыборкаПоДокументамВРазрезеНДС.Номер) + " / " + Формат(ВыборкаПоДокументамВРазрезеНДС.Дата, "ДФ=dd.MM.yy"); 
				//Секция.Параметры.НомерДата			  = СокрЛП(ВыборкаПоДокументамВРазрезеНДС.НомерВходящегоДокумента) + " от " 
														//+ Формат(ВыборкаПоДокументамВРазрезеНДС.ДатаВходящегоДокумента, "ДФ=dd.MM.yy");
				Секция.Параметры.Дата  = Формат(ВыборкаПоДокументамВРазрезеНДС.ДатаВходящегоДокумента, "ДФ=dd.MM.yy");
				Секция.Параметры.ДатаОборота  = Формат(ВыборкаПоДокументамВРазрезеНДС.ДатаОборота, "ДФ=dd.MM.yy");
				
				СведенияОПоставщике  = ОбщегоНазначения.СведенияОЮрФизЛице(ВыборкаПоДокументамВРазрезеНДС.Поставщик, ВыборкаПоДокументамВРазрезеНДС.ДатаВходящегоДокумента);									  
				
				Секция.Параметры.Поставщик			   = ВыборкаПоДокументамВРазрезеНДС.Поставщик;	
												
				Секция.Параметры.ПоставщикНаименование = ВыборкаПоДокументамВРазрезеНДС.Поставщик.Наименование;
//				Секция.Параметры.РННПоставщика 				  	= ОбщегоНазначения.ОписаниеОрганизации(СведенияОПоставщике, "РНН,", Ложь);
				Секция.Параметры.БИНПоставщика 					= ОбщегоНазначения.ОписаниеОрганизации(СведенияОПоставщике, "БИН_ИИН,", Ложь);
//				Секция.Параметры.СвидетельствоПоНДСПоставщика 	= ОбщегоНазначения.ОписаниеОрганизации(СведенияОПоставщике, "СвидетельствоПоНДС,");
				
				Секция.Параметры.СуммаБезНДС = ОбщегоНазначения.ПересчитатьИзВалютыВВалюту( ВыборкаПоДокументамВРазрезеНДС.СуммаБезНДС, ВыборкаПоДокументамВРазрезеНДС.ВалютаДокумента, мВалютаРегламентированногоУчета, 
				ВыборкаПоДокументамВРазрезеНДС.КурсВзаиморасчетов, 1, ВыборкаПоДокументамВРазрезеНДС.КратностьВзаиморасчетов = 1, 1); 
				
				Секция.Параметры.СтавкаНДС   = ВыборкаПоДокументамВРазрезеНДС.СтавкаНДС;												 
				
				Секция.Параметры.СуммаНДС    = ОбщегоНазначения.ПересчитатьИзВалютыВВалюту( ВыборкаПоДокументамВРазрезеНДС.СуммаНДС, ВыборкаПоДокументамВРазрезеНДС.ВалютаДокумента, мВалютаРегламентированногоУчета, 
				ВыборкаПоДокументамВРазрезеНДС.КурсВзаиморасчетов, 1, ВыборкаПоДокументамВРазрезеНДС.КратностьВзаиморасчетов = 1, 1); 
				
				Секция.Параметры.Сумма  	 = ОбщегоНазначения.ПересчитатьИзВалютыВВалюту( ВыборкаПоДокументамВРазрезеНДС.Сумма, ВыборкаПоДокументамВРазрезеНДС.ВалютаДокумента, мВалютаРегламентированногоУчета, 
				ВыборкаПоДокументамВРазрезеНДС.КурсВзаиморасчетов, 1, ВыборкаПоДокументамВРазрезеНДС.КратностьВзаиморасчетов = 1, 1); 
				
				ИтогоСуммаБезНДС = ИтогоСуммаБезНДС + Секция.Параметры.СуммаБезНДС;
				ИтогоСуммаНДС 	 = ИтогоСуммаНДС 	+ Секция.Параметры.СуммаНДС;
				ИтогоСумма		 = ИтогоСумма		+ Секция.Параметры.Сумма;
				ТабличныйДокумент.Вывести(Секция,2);
				Если ОтображатьДоговора Тогда
					СекцияДоговора.Параметры.ДоговорКонтрагента = ВыборкаПоДокументамВРазрезеНДС.ДоговорКонтрагента;
					ТабличныйДокумент.Присоединить(СекцияДоговора,2); 					
				КонецЕсли;
				
				Если ОтображатьКомментарий Тогда				
					СекцияКом.Параметры.Комментарий = ВыборкаПоДокументамВРазрезеНДС.Комментарий;
					ТабличныйДокумент.Присоединить(СекцияКом,2);
				КонецЕсли;

								
			Иначе
				ДопСекция.Параметры.РасчетныйДокументПредставление = ДокументОснование;
				ДопСекция.Параметры.СписокОснований  	= СписокОснований; 
				ДопСекция.Параметры.СуммаБезНДС = ОбщегоНазначения.ПересчитатьИзВалютыВВалюту( ВыборкаПоДокументамВРазрезеНДС.СуммаБезНДС, ВыборкаПоДокументамВРазрезеНДС.ВалютаДокумента, мВалютаРегламентированногоУчета, 
				ВыборкаПоДокументамВРазрезеНДС.КурсВзаиморасчетов, 1, ВыборкаПоДокументамВРазрезеНДС.КратностьВзаиморасчетов = 1, 1); 
				
				ДопСекция.Параметры.СтавкаНДС   = ВыборкаПоДокументамВРазрезеНДС.СтавкаНДС;												 
				
				ДопСекция.Параметры.СуммаНДС    = ОбщегоНазначения.ПересчитатьИзВалютыВВалюту( ВыборкаПоДокументамВРазрезеНДС.СуммаНДС, ВыборкаПоДокументамВРазрезеНДС.ВалютаДокумента, мВалютаРегламентированногоУчета, 
				ВыборкаПоДокументамВРазрезеНДС.КурсВзаиморасчетов, 1, ВыборкаПоДокументамВРазрезеНДС.КратностьВзаиморасчетов = 1, 1); 
				
				ДопСекция.Параметры.Сумма  	 	= ОбщегоНазначения.ПересчитатьИзВалютыВВалюту( ВыборкаПоДокументамВРазрезеНДС.Сумма, ВыборкаПоДокументамВРазрезеНДС.ВалютаДокумента, мВалютаРегламентированногоУчета, 
				ВыборкаПоДокументамВРазрезеНДС.КурсВзаиморасчетов, 1, ВыборкаПоДокументамВРазрезеНДС.КратностьВзаиморасчетов = 1, 1); 
				
				
				
				ИтогоСуммаБезНДС = ИтогоСуммаБезНДС + ДопСекция.Параметры.СуммаБезНДС;
				ИтогоСуммаНДС 	 = ИтогоСуммаНДС 	+ ДопСекция.Параметры.СуммаНДС;
				ИтогоСумма		 = ИтогоСумма		+ ДопСекция.Параметры.Сумма;
				ТабличныйДокумент.Вывести(ДопСекция,2);	
				
				Если ОтображатьДоговора Тогда
					ТабличныйДокумент.Присоединить(ДопСекцияДоговора,2); 					
				КонецЕсли;
				
				Если ОтображатьКомментарий Тогда				
					ТабличныйДокумент.Присоединить(ДопСекцияКом,2);
				КонецЕсли;  
				
			КонецЕсли;
		УстановитьПараметр = Ложь;
	КонецЦикла;					
КонецЦикла;
		
КонецПроцедуры


Процедура СформироватьОтчетОПроверке(ТабличныйДокумент) Экспорт
	
	ТабДокумент = ТабличныйДокумент;
	ТабДокумент.Очистить();
	Макет  = ПолучитьМакет("МакетПроверки");
		
	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	ОбластьОшибокНеВыявлено = Макет.ПолучитьОбласть("ОшибокНеВыявлено");
	
	ОбластьШапкаСоответствияРеквизитов 	= Макет.ПолучитьОбласть("ШапкаСоответствияРеквизитов");
	ОбластьСтрокаСоответствияРеквизитов = Макет.ПолучитьОбласть("СтрокаСоответствияРеквизитов");	
	ОбластьИтогиСоответствияРеквизитов = Макет.ПолучитьОбласть("ИтогиСоответствияРеквизитов");
	
	ОбластьШапкаСоответствияСумм 				= Макет.ПолучитьОбласть("ШапкаСоответствияСумм");
	ОбластьСтрокаСсылкаСоответствияСумм 		= Макет.ПолучитьОбласть("СтрокаСсылкаСоответствияСумм");
	ОбластьСтрокаРегистраторСоответствияСумм 	= Макет.ПолучитьОбласть("СтрокаРегистраторСоответствияСумм");
	ОбластьИтогиСоответствияСумм 				= Макет.ПолучитьОбласть("ИтогиСоответствияСумм");
	
	
	ОбластьШапка.Параметры.НазваниеОрганизации = РаботаСДиалогами.ВыгрузитьСписокВСтроку(мСписокСтруктурныхЕдиниц);;
	ОбластьШапка.Параметры.Дата1 = Формат(НачалоПериода, "ДФ=dd.MM.yyyy");
	ОбластьШапка.Параметры.Дата2 = Формат(КонецПериода, "ДФ=dd.MM.yyyy");
	ТабДокумент.Вывести(ОбластьШапка);
		
	// Проверка Наличия выписанных счетов фактур
	ТаблицаРезультат = УчетНДСИАкциза.ОпределитьНаличиеСчетовФактур(?(НЕ ЗначениеЗаполнено(НачалоПериода), Неопределено, НачалоПериода), 
                                                               ?(НЕ ЗначениеЗаполнено(КонецПериода), Неопределено, КонецДня(КонецПериода)),
                                                               ?(мСписокСтруктурныхЕдиниц.Количество() = 0, Неопределено, мСписокСтруктурныхЕдиниц),
                                                               Неопределено, Ложь, Неопределено, "СчетФактураПолученный");
	Если ТаблицаРезультат.Количество() > 0 Тогда
		ТабДокумент.НачатьАвтоГруппировкуСтрок();
		ТабДокумент.Вывести(ОбластьШапкаСоответствияРеквизитов,0);
		
		// Выведем строки таблицы.
		Номер = 0;
		Для Каждого СтрокаРезультат Из ТаблицаРезультат Цикл
			// не проведенные документы не отражаем
			Если НЕ СтрокаРезультат.СчетФактураПроведен Тогда
				Продолжить;
			КонецЕсли;					
			СчетФактура = СтрокаРезультат.СчетФактура;
			Нарушение = "";
			КонтрагентНаименование = "";
			ДокументОснование  = ?(ТипЗнч(СтрокаРезультат.ДокументОснование) = Тип("ДокументСсылка.Сторнирование"), СтрокаРезультат.ДокументОснование.ДокументОснование, СтрокаРезультат.ДокументОснование);
			Если ЗначениеЗаполнено(ДокументОснование) Тогда
				// проверка соответствия реквизитов
				МетаданныеОснования = ДокументОснование.Метаданные();
				
				Если  ЗначениеЗаполнено(СчетФактура) И ОбщегоНазначения.ЕстьРеквизитДокумента("Организация",МетаданныеОснования) Тогда
					ОрганизацияОснования = ДокументОснование.Организация;
					Если НЕ ОрганизацияОснования = СчетФактура.Организация Тогда
						Нарушение = Нарушение + "Несоответствие организации. ";
					КонецЕсли;					
				КонецЕсли;
				
				Если ОбщегоНазначения.ЕстьРеквизитДокумента("Контрагент",МетаданныеОснования) Тогда
					КонтрагентОснования = ДокументОснование.Контрагент;
					КонтрагентНаименование = СокрЛП(КонтрагентОснования.Наименование);
					// Отбор по конрагенту, тольк при наличии реквизита метаданных
					Если ОтбиратьПоКонтрагенту И НЕ КонтрагентОснования = КонтрагентДляОтбора  И НЕ  УчетНДСИАкциза.ПолучитьПлательщикаНДСВСчетеФактуре(КонтрагентОснования) = КонтрагентДляОтбора Тогда
						Продолжить;
					КонецЕсли;	
					
					Если ЗначениеЗаполнено(СчетФактура) И (НЕ КонтрагентОснования = СчетФактура.Контрагент) Тогда
						Нарушение = Нарушение + "Несоответствие контрагентов. ";
					КонецЕсли;					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СчетФактура) И ОбщегоНазначения.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеОснования) Тогда
					ВалютаОснования  = ДокументОснование.ВалютаДокумента;
					Если НЕ ВалютаОснования = СчетФактура.ВалютаДокумента Тогда
						Нарушение = Нарушение + "Несоответствие валюты. ";
					КонецЕсли;					
				КонецЕсли;
				
				Если НЕ ЗначениеЗаполнено(СчетФактура) Тогда
					Нарушение = Нарушение + "Отсутствует счет-фактура. ";
				Иначе
					Если НЕ СтрокаРезультат.СчетФактураПроведен = ИСТИНА Тогда
						Нарушение = Нарушение + "Счет-фактура не проведен.";
					КонецЕсли;
				КонецЕсли;

			КонецЕсли;    
			
			
			Если Не ЗначениеЗаполнено(Нарушение) Тогда
				Продолжить;
			КонецЕсли;
			Номер = Номер+ 1;
			
			ОбластьСтрокаСоответствияРеквизитов.Параметры.Заполнить(СтрокаРезультат);
			ОбластьСтрокаСоответствияРеквизитов.Параметры.Нарушение = Нарушение;
			ОбластьСтрокаСоответствияРеквизитов.Параметры.КонтрагентНаименование = КонтрагентНаименование;
			ОбластьСтрокаСоответствияРеквизитов.Параметры.Дата = СтрокаРезультат.ДокументОснование.Дата;
						
			ОбластьСтрокаСоответствияРеквизитов.Параметры.Номер = Номер;
			ТабДокумент.Вывести(ОбластьСтрокаСоответствияРеквизитов,1);	
			
		КонецЦикла;		
		ОбластьИтогиСоответствияРеквизитов.Параметры.Номер = Номер;
		ТабДокумент.Вывести(ОбластьИтогиСоответствияРеквизитов,0);	
	Иначе		
		ТабДокумент.Вывести(ОбластьОшибокНеВыявлено,0);				
	КонецЕсли;
	ТабДокумент.ЗакончитьАвтоГруппировкуСтрок();
	
	// Второй этап проверки
	ТабДокумент.НачатьАвтоГруппировкуСтрок();
	
	ТабДокумент.Вывести(ОбластьШапкаСоответствияСумм, 0);
	
	РезультатПроверкиСумм = УчетНДСИАкциза.ПроверитьСоответствиеСуммСчетовФактурПолученныхИДокументовОтгрузки(НачалоПериода, КонецДня(КонецПериода), мСписокСтруктурныхЕдиниц,?(ОтбиратьПоКонтрагенту, КонтрагентДляОтбора, Неопределено), Истина);
	Если НЕ РезультатПроверкиСумм.Пустой() Тогда
		
		
		ИтогоСуммаНДС 				= 0;
		ИтогоСуммаНДСОтгрузки	 	= 0;		
		ИтогоСуммаБезНДС			= 0;
		ИтогоСуммаБезНДСОтгрузки	= 0;		
				
		ВыборкаСсылка = РезультатПроверкиСумм.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаСсылка.Следующий() Цикл
			СуммаНДСОтклонение = ВыборкаСсылка.СуммаНДС - ВыборкаСсылка.СуммаНДСОтгрузки;
			СуммаБезНДСОтклонение = ВыборкаСсылка.СуммаБезНДС - ВыборкаСсылка.СуммаБезНДСОтгрузки;
			Если СуммаНДСОтклонение = 0 И СуммаБезНДСОтклонение  = 0 Тогда 
				Продолжить
			КонецЕсли;
						
			ОбластьСтрокаСсылкаСоответствияСумм.Параметры.Заполнить(ВыборкаСсылка);
			
			ОбластьСтрокаСсылкаСоответствияСумм.Параметры.СуммаНДСОтклонение = СуммаНДСОтклонение;
			ОбластьСтрокаСсылкаСоответствияСумм.Параметры.СуммаБезНДСОтклонение = СуммаБезНДСОтклонение;
			ТабДокумент.Вывести(ОбластьСтрокаСсылкаСоответствияСумм, 1);				
			// Итоги на уровне счета фактуры
			ИтогоСуммаНДС 				= ИтогоСуммаНДС + ВыборкаСсылка.СуммаНДС;
			ИтогоСуммаНДСОтгрузки	 	= ИтогоСуммаНДСОтгрузки + ВыборкаСсылка.СуммаНДСОтгрузки;
			
			ИтогоСуммаБезНДС			= ИтогоСуммаБезНДС + ВыборкаСсылка.СуммаБезНДС;
			ИтогоСуммаБезНДСОтгрузки	= ИтогоСуммаБезНДСОтгрузки + ВыборкаСсылка.СуммаБезНДСОтгрузки;			
			
			// Детали по документам отгрузки
			ВыборкаРегистратор = ВыборкаСсылка.Выбрать();
			Пока ВыборкаРегистратор.Следующий() Цикл
				ОбластьСтрокаРегистраторСоответствияСумм.Параметры.Заполнить(ВыборкаРегистратор);
				ТабДокумент.Вывести(ОбластьСтрокаРегистраторСоответствияСумм, 2);							
			КонецЦикла;
		КонецЦикла;
		ТабДокумент.ЗакончитьАвтоГруппировкуСтрок();
		
		ОбластьИтогиСоответствияСумм.Параметры.СуммаНДС 			= ИтогоСуммаНДС;
		ОбластьИтогиСоответствияСумм.Параметры.СуммаНДСОтгрузки 	= ИтогоСуммаНДСОтгрузки;
		ОбластьИтогиСоответствияСумм.Параметры.СуммаНДСОтклонение 	= ИтогоСуммаНДС - ИтогоСуммаНДСОтгрузки;
		
		ОбластьИтогиСоответствияСумм.Параметры.СуммаБезНДС 			 = ИтогоСуммаБезНДС;
		ОбластьИтогиСоответствияСумм.Параметры.СуммаБезНДСОтгрузки 	 = ИтогоСуммаБезНДСОтгрузки;
		ОбластьИтогиСоответствияСумм.Параметры.СуммаБезНДСОтклонение = ИтогоСуммаБезНДС - ИтогоСуммаБезНДСОтгрузки;
		
		ТабДокумент.Вывести(ОбластьИтогиСоответствияСумм);						
	Иначе
		ТабДокумент.Вывести(ОбластьОшибокНеВыявлено);				
	КонецЕсли;	
	ТабДокумент.ПоказатьУровеньГруппировокСтрок(0);
	
	ТабДокумент.Показать();																   
КонецПроцедуры

#КонецЕсли