﻿#Если Клиент Тогда
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей для передачи данных.
Перем мТаблицаПоказателейДляПередачиДанных Экспорт;

// Хранит имя пространства имен, использующееся
// для идентификации модели типов XDTO.
Перем ИмяПакета Экспорт;
// Хранит таблицу форматов
// для корректной выгрузки отчета в XML.
Перем мТаблицаФорматов Экспорт;
// имя файла по умолчанию для выгрузки
Перем ИмяФайлаВыгрузки Экспорт;

// Хранит перечень форм отчета.
Перем СписокФормДерева Экспорт;

// Хранит имя открытой формы отчета.
Перем мФорма Экспорт;

// Хранит макет, содержащий представление многострочных форм
// Равен "Неопределено", если отчет не содержит многострочных форм
//                       и соответственно в таких отчетах макет не создается
Перем мМакет Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета.
Перем мСохраненныйДок Экспорт;

// Хранит все данные отчета.
Перем мДеревоНастройкиСтраниц Экспорт;
Перем мСписокФормБезИерархии Экспорт;
Перем мСписокСохранения Экспорт;

// Переменные хранят границы
// периода построения отчета.
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;
Перем мПериодичность Экспорт;

// Переменная хранит год периода формирования отчета.
Перем мГод Экспорт;
Перем мКвартал Экспорт;
Перем мПолугодие Экспорт;
Перем мОтчетныйПериодПолугодие Экспорт; // признак того, что форма имеет полугодовую периодичность (для форм с 2014 года)

// Хранит название формы навигации.
// При открытии этой формы из других объектов
// также записываем имя в эту переменую.
Перем мФормаНавигации Экспорт;

// Хранит название основной формы.
Перем мОсновнаяФорма Экспорт;   

// Хранит имя выбранной формы отчета.
Перем мВыбраннаяФорма Экспорт;

// Хранит ФИО исполнителя. 
Перем мИсполнитель Экспорт;

Перем мИсчислятьСОБезОграниченияНаСуммуИсчисленногоСН Экспорт;

//Переменная хранит значение реквизита ОтразитьВзносыОСМСПоДоговорамГПХ
Перем мОтразитьВзносыОСМСПоДоговорамГПХ Экспорт;

// Хранит области, на которых последний раз 
// спозиционировался пользователь
// запоминаются при закрытии формы.
Перем мАктивныеОбласти Экспорт;

// Переменная хранит список страниц отчета на печать.
Перем мТаблицаСтраницНаПечать Экспорт;

// Переменная хранит признак налогоплательщика: ИП или ЮЛ
Перем мНалогоплательщикЯвляетсяИП Экспорт;

// Переменная хранит размер минимальной заработной платы по состоянию на мДатаКонцаПериодаОтчета
Перем мРазмерМЗП Экспорт;
Перем мРазмерМЗПДляЦелейНалогообложения Экспорт;

// Переменная хранит ставку СО
Перем мСтавкаСО Экспорт;

// Переменная хранит ставку ОПВ
Перем мСтавкаОПВ Экспорт;

// Переменная хранит ставку ВОСМС
Перем мСтавкаВОСМС Экспорт;

// Хранить признак включения получателей по ИЛ
Перем мПризнакАлиментов Экспорт;

// Хранить признак исключения из списка физлиц, являющихся нерезидентами
Перем мИсключатьНерезидентов Экспорт;

Перем мПризнакСистемыСотрудниковЗУП20 Экспорт; 

Перем мРасчетНаРегистрах Экспорт;

Перем мМесяцЗаполнения Экспорт;

Перем мДатаНачалоПериодаОтчетаУпрощенка Экспорт;

// Переменная хранит размер месячного расчетного показателя по состоянию на мДатаКонцаПериодаОтчета
Перем мРазмерМРПДляЦелейНалогообложения Экспорт;

Перем мИППенсионер Экспорт;
Перем мМесяцИППенсионер Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Записывает страницы для печати в мТаблицаСтраницНаПечать,
// и вызывают общую форму "ПечатьРегламентированныхОтчетов" для 
// печати уазанных листов формы
// Параметры:
//  ВидПечати - строка, задающая способ печати:
//              "ПоказатьБланк" - с предварительным просмтром;
//              "ПечататьСразу" - непосредственный вывод на печать.
//
Процедура Печать(ВидПечати) Экспорт 
	
	Перем СтруктураГруппы;            
	
	//очистим таблицу значений
	мТаблицаСтраницНаПечать.Очистить();
	Стр = 1;
	
	Если Не мФорма.ПризнакМногострочности Тогда 
				
		Для Каждого Страница Из мФорма.ЭлементыФормы["Панель" + мФорма.ИмяФормы].Страницы Цикл
			ТабДок = Новый ТабличныйДокумент;
			ИмяОбласти = Страница.Имя;
			ТекПТД = мФорма.ИмяФормы + "ПолеТабличногоДокумента" + Страница.Имя;
			ТекОбласть = мФорма.ЭлементыФормы[ТекПТД].ПолучитьОбласть(ИмяОбласти);
			ТабДок.Вывести(ТекОбласть);
			ТабДок.ОриентацияСтраницы = РегламентированнаяОтчетность.ОпределитьОриентациюСтраницы(мФорма.ИмяФормы,мСписокФормБезИерархии);
			ТабДок.ЧерноБелаяПечать   = Ложь;
			ТабДок.АвтоМасштаб = Истина;
		
			Строка = мТаблицаСтраницНаПечать.Добавить();
			Строка.ПолеТабличногоДокумента = ТабДок;
			Строка.ИмяЛиста = "Страница № " + Строка(Стр);
			Строка.ИмяЛистаДляЗаписи = "Рег. отчет " + мФормаНавигации.Заголовок+ " - стр. " + Строка(Стр);
			Стр = Стр + 1;
		КонецЦикла;
	
	Иначе
	    
	    Пока Стр < мФорма.ВсегоСтраниц + 1 Цикл		 
		 	Для Каждого Страница Из мФорма.ЭлементыФормы["Панель" + мФорма.ИмяФормы].Страницы Цикл
			 
			 	ТабДок = Новый ТабличныйДокумент;
			 	ИмяГруппы = Страница.Имя;
				мМногострочнаяСтруктура = РегламентированнаяОтчетность.ПолучитьМногострочнуюСтруктуру(мФорма.ИмяФормы,мСписокФормБезИерархии);
			 	мМногострочнаяСтруктура.Свойство(ИмяГруппы, СтруктураГруппы);		
			 	РегламентированнаяОтчетность.ВывестиРазделВТабличныйДокументФормы(мФорма, Стр,ИмяГруппы, СтруктураГруппы,мФорма.ИмяФормы);
			 	ТекущееТабПоле = мФорма.ИмяФормы + "ПолеТабличногоДокумента" + ИмяГруппы;
			 	ТабДок.Вывести(мФорма.ЭлементыФормы[ТекущееТабПоле]);
			 	ТабДок.ОриентацияСтраницы = РегламентированнаяОтчетность.ОпределитьОриентациюСтраницы(мФорма.ИмяФормы,мСписокФормБезИерархии);
			 	ТабДок.АвтоМасштаб        = Истина;
			 	ТабДок.ЧерноБелаяПечать   = Ложь;
			 
			 	//добавляем значения в таблицу страниц для печати
			 	Строка = мТаблицаСтраницНаПечать.Добавить();
			 	Строка.ПолеТабличногоДокумента = ТабДок;
				Строка.ИмяЛиста = ИмяГруппы + ". Страница № " + Строка(Стр);
				Строка.ИмяЛистаДляЗаписи = "Рег. отчет " + мФормаНавигации.Заголовок+ " " +ИмяГруппы + ". cтр. № " + Строка(Стр);
			КонецЦикла;
			Стр = Стр + 1;		 
	 	КонецЦикла;
		                                          		
		РегламентированнаяОтчетность.ВывестиСтраницуМногострочнойФормы(мФорма);
		
	КонецЕсли;
	
	РегламентированнаяОтчетность.ПечатьРегламентированногоОтчета(мТаблицаСтраницНаПечать,  мФорма, ВидПечати);
	
КонецПроцедуры // Печать()

// Функция получает основные сведения о выбранной организации
// 
Функция ЗаполнитьСведенияОНалогоплательщике()Экспорт
	
	Если (Налогоплательщик  = Неопределено) Или (Налогоплательщик = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации")) Тогда
		Возврат 0;
	КонецЕсли;
	
	// Составляем список данных, необходимых для вывода в отчетную форму
	Сведения = Новый СписокЗначений;
	
	Сведения.Добавить("", "НаимЮЛПол"); // Полное название организации
	
	Сведения.Добавить("", "РННЮЛ"); // РНН

	Сведения.Добавить("", "ОКЭД"); // ОКЭД
	
	Сведения.Добавить("", "ИИН_БИН"); // БИН/ИИН
    	
	Сведения.Добавить("", "ФИОРук"); // ФИО руководителя
	
	Сведения.Добавить("", "ФИОБух"); // ФИО бухгалтера
	
	// Теперь получаем данные из глобальной общей функции
	ОргСведения = ОбщегоНазначения.ПолучитьСведенияОбОрганизации(Налогоплательщик, ТекущаяДата(), Сведения);
	
	// Добавим сведения о кодах налоговых органов
	НКСведения = ОбщегоНазначения.СведенияОЮрФизЛице(НалоговыйКомитет, ДатаПодписи);
	
	ОргСведения.Вставить("КодНалоговогоОргана", 		СокрЛП(Лев(НКСведения.РНН, 4)));
	
	ПризнакРезидентства = ?(Лев(Налогоплательщик.КБЕ,1) = "2", Ложь, Истина);
	ОргСведения.Вставить("ПризнакРезидентства", ПризнакРезидентства);
	
	Возврат ОргСведения;
	
КонецФункции // ЗаполнитьСведенияОбОрганизации

// Вызывает диалог выбора файла для выбора файла данных
//
Функция ВыборФайла() Экспорт
	
	Префикс = Число(Лев(Прав(мВыбраннаяФорма,7),4));
	
	Режим                 = РежимДиалогаВыбораФайла.Открытие;
	Диалог                = Новый ДиалогВыбораФайла(Режим);
	Диалог.Заголовок      = "Выберите файл";
	Диалог.ПолноеИмяФайла = "910";
	Если Префикс >= 2009 Тогда
		Диалог.Фильтр         = "*.xml|*.xml|Все файлы(*.*)|*.*";
		Диалог.Расширение     = "xml";
	Иначе
		Диалог.Фильтр         = "*.efn|*.efn|Все файлы(*.*)|*.*";
		Диалог.Расширение     = "efn";
	КонецЕсли;	
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	КонецЕсли;	
	Возврат ИмяФайла;
 
КонецФункции // ВыборФайла()

 //Функция управляет показом в форме периода построения отчета.
 //
Функция ПоказатьОсновнойПериод(ТекДатаНачала,ТекДатаОкончания) Экспорт
	Если мОтчетныйПериодПолугодие Тогда
		мКвартал 	= ?(Месяц(ТекДатаНачала)< 6, 1, 4); // для первого полугодия - 1 квартал, для второго - 4 квартал
		мГод     	= Формат(Год(ТекДатаНачала), "ЧГ="); // удаляем разделительный пробел, так как 		
		мПолугодие  = ?(мКвартал = 1, 1, 2);		
		
		СтрПериодОтчета = СокрЛП(мПолугодие) + " полугодие " + СокрЛП(мГод) + " года";		
	Иначе	
		СтрПериодОтчета = ПредставлениеПериода(ТекДатаНачала,ТекДатаОкончания, "ФП = истина");
		мКвартал = Лев(СтрПериодОтчета,1);
		мГод     = Лев(Прав(СтрПериодОтчета,7),4);
		мПолугодие  = ?(мКвартал = "1", 1, 2);		
	КонецЕсли;
	
	Возврат СтрПериодОтчета;
		
КонецФункции // ПоказатьОсновнойПериод()

// Процедура выполняет иниализацию общих переменных, используемых в расчете
//
Процедура ИнициализироватьВспомогательныеПеременные() Экспорт

	мНалогоплательщикЯвляетсяИП = (Налогоплательщик.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо);
	
	// размер минимальной заработной платы
	Запрос = Новый Запрос;
	Если мДатаНачалаПериодаОтчета >= Дата(2022,1,1) Тогда
		Запрос.УстановитьПараметр("ДатаАктуальности", мДатаНачалаПериодаОтчета);		
	ИначеЕсли мДатаНачалаПериодаОтчета >= Дата(2010,1,1) Тогда
		// с 2010 года в статье 436 указано, что для расчетов используется показатель по состоянию на начало года
		Запрос.УстановитьПараметр("ДатаАктуальности", НачалоГода(мДатаКонцаПериодаОтчета));		
	Иначе	
		// до 2010 года уточнения в кодексе не было, поэтому берем показатель на конец отчетного периода
		Запрос.УстановитьПараметр("ДатаАктуальности", мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныеРасчетныеПоказатели.РазмерМЗП,
	               |	РегламентированныеРасчетныеПоказатели.РазмерМЗПДляЦелейНалогообложения,
				   |	РегламентированныеРасчетныеПоказатели.РазмерМРП
	               |ИЗ
	               |	РегистрСведений.РегламентированныеРасчетныеПоказатели.СрезПоследних(&ДатаАктуальности, ) КАК РегламентированныеРасчетныеПоказатели";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		мРазмерМЗП = Выборка.РазмерМЗП;
		мРазмерМЗПДляЦелейНалогообложения = Выборка.РазмерМЗПДляЦелейНалогообложения;
		мРазмерМРПДляЦелейНалогообложения = Выборка.РазмерМРП;
	Иначе
		мРазмерМЗП = 0;
		мРазмерМЗПДляЦелейНалогообложения = 0;
		мРазмерМРПДляЦелейНалогообложения = 0;
	КонецЕсли;

	// ставки взносов, отчислений
	Если мДатаНачалаПериодаОтчета < Дата(2020,1,1) Тогда
		мСтавкаОПВ = ПроцедурыНалоговогоУчета.ПолучитьСтавкуНалога(Налогоплательщик, Справочники.НалогиСборыОтчисления.ОбязательныеПенсионныеВзносы, мДатаКонцаПериодаОтчета);
		мСтавкаСО = ПроцедурыНалоговогоУчета.ПолучитьСтавкуНалога(Налогоплательщик, Справочники.НалогиСборыОтчисления.ОбязательныеСоциальныеОтчисления, мДатаКонцаПериодаОтчета);
		Если Не мРасчетНаРегистрах Тогда
			мСтавкаВОСМС = ПроцедурыНалоговогоУчета.ПолучитьСтавкуОСМС(мДатаНачалаПериодаОтчета, Перечисления.ЮрФизЛицо.ЮрЛицо, "Взносы");
		Иначе
			мСтавкаВОСМС = ПроцедурыНалоговогоУчета.ПолучитьСтавкуОСМС(мДатаНачалаПериодаОтчета, Вычислить("Справочники.ВидыДоходов.ДоходыОтНалоговогоАгента"), "Взносы");
		КонецЕсли;
	Иначе

		Запрос.УстановитьПараметр("парамНалогоплательщик", Налогоплательщик);
		Запрос.УстановитьПараметр("парамПериод", мДатаКонцаПериодаОтчета);
		Запрос.Текст = "ВЫБРАТЬ
		               |	УчетнаяПолитикаНалоговыйУчетСрезПоследних.СтавкаОПВДляИП,
		               |	УчетнаяПолитикаНалоговыйУчетСрезПоследних.СтавкаСОДляИП,
		               |	УчетнаяПолитикаНалоговыйУчетСрезПоследних.СтавкаВОСМСДляИП
		               |ИЗ
		               |	РегистрСведений.УчетнаяПолитикаНалоговыйУчет.СрезПоследних(&парамПериод, Организация = &парамНалогоплательщик) КАК УчетнаяПолитикаНалоговыйУчетСрезПоследних";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			мСтавкаОПВ 	 = Выборка.СтавкаОПВДляИП;
			мСтавкаСО 	 = Выборка.СтавкаСОДляИП;
			мСтавкаВОСМС = Выборка.СтавкаВОСМСДляИП;
		КонецЕсли;
		
	КонецЕсли;	
		
	мСтавкаОПВ = ?(ЗначениеЗаполнено(мСтавкаОПВ), мСтавкаОПВ, 0);
	мСтавкаСО = ?(ЗначениеЗаполнено(мСтавкаСО), мСтавкаСО, 0);
	мСтавкаВОСМС = ?(ЗначениеЗаполнено(мСтавкаВОСМС), мСтавкаВОСМС, 0);
		
	//Месяц начиная с которого заполняется отчет  
	Запрос.УстановитьПараметр("парамНалогоплательщик", Налогоплательщик);
	Запрос.Текст = "ВЫБРАТЬ
	               |	МИНИМУМ(УчетнаяПолитикаНалоговыйУчет.Период) КАК Период
	               |ИЗ
	               |	РегистрСведений.УчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчет
	               |ГДЕ
	               |	УчетнаяПолитикаНалоговыйУчет.ОрганизацияЯвляетсяПлательщикомСН = ЛОЖЬ
	               |	И УчетнаяПолитикаНалоговыйУчет.Организация = &парамНалогоплательщик";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если  ТипЗнч(Выборка.Период) = Тип("Дата") 
			И Выборка.Период > мДатаНачалаПериодаОтчета Тогда
			мМесяцЗаполнения = (Месяц(Выборка.Период ) - Месяц(мДатаНачалаПериодаОтчета)) + 1;
			мДатаНачалоПериодаОтчетаУпрощенка = Выборка.Период;
		Иначе
			мМесяцЗаполнения = 1;
			мДатаНачалоПериодаОтчетаУпрощенка = Неопределено;
		КонецЕсли;
	КонецЕсли;
	  
	Запрос.УстановитьПараметр("парамФизЛицоИП", Налогоплательщик.ИндивидуальныйПредприниматель);
	Запрос.УстановитьПараметр("парамПериод", мДатаКонцаПериодаОтчета);
	Запрос.Текст = "ВЫБРАТЬ
	               |	СведенияОПенсионномОбеспеченииФизЛицСрезПоследних.Пенсионер КАК Пенсионер,
	               |	СведенияОПенсионномОбеспеченииФизЛицСрезПоследних.Период КАК Период
	               |ИЗ
	               |	РегистрСведений.СведенияОПенсионномОбеспеченииФизЛиц.СрезПоследних(&парамПериод, ФизЛицо = &парамФизЛицоИП) КАК СведенияОПенсионномОбеспеченииФизЛицСрезПоследних";
				   
	Выборка = Запрос.Выполнить().Выбрать();

	мИППенсионер = Ложь;
	мМесяцИППенсионер = 0;
	
	Если Выборка.Следующий() Тогда
		мИППенсионер = Выборка.Пенсионер;
		Если Выборка.Период > мДатаНачалаПериодаОтчета Тогда
			мМесяцИППенсионер = (Месяц(Выборка.Период ) - Месяц(мДатаНачалаПериодаОтчета)) + 1;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ИнициализироватьВспомогательныеПеременные()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

// Вспомогательные переменные для обеспечения расчета
мНалогоплательщикЯвляетсяИП = Ложь;
мРазмерМЗП = 0;
мСтавкаОПВ = 0;
мСтавкаСО = 0;
мСтавкаВОСМС = 0;
мМесяцЗаполнения = 1;
мДатаНачалоПериодаОтчетаУпрощенка = Неопределено;

//заполняем всеми формами, которые входят в отчет
//в качестве кода формы назначает имя  форм, входящих в отчет
СписокФормДерева  = Новый ДеревоЗначений;
СписокФормДерева.Колонки.Добавить("Страницы");
СписокФормДерева.Колонки.Добавить("КодФормы");
СписокФормДерева.Колонки.Добавить("ИмяФормы");
СписокФормДерева.Колонки.Добавить("ПоказатьСтраницу");
СписокФормДерева.Колонки.Добавить("Выгружать");
СписокФормДерева.Колонки.Добавить("Многострочность");
СписокФормДерева.Колонки.Добавить("ПризнакОсновной");
СписокФормДерева.Колонки.Добавить("ЗаголовокФормы"); 
СписокФормДерева.Колонки.Добавить("АвтополучениеИтогов");    
СписокФормДерева.Колонки.Добавить("Автозаполнение");    
СписокФормДерева.Колонки.Добавить("КоличествоНаЛисте");    
СписокФормДерева.Колонки.Добавить("ОриентацияСтр");    
СписокФормДерева.Колонки.Добавить("Значение");    
                                                         
мТаблицаФорматов  = Новый ТаблицаЗначений;                        
мТаблицаФорматов.Колонки.Добавить("ИмяФормы");       
мТаблицаФорматов.Колонки.Добавить("ИмяСтраницы");                 
мТаблицаФорматов.Колонки.Добавить("Элемент");            
мТаблицаФорматов.Колонки.Добавить("Тип");                    
мТаблицаФорматов.Колонки.Добавить("ПроверкаНаПустое");        
мТаблицаФорматов.Колонки.Добавить("НеРедактируется");    
мТаблицаФорматов.Колонки.Добавить("Мин");      
мТаблицаФорматов.Колонки.Добавить("Макс");               
мТаблицаФорматов.Колонки.Добавить("ФиксированнаяДлина");                    
мТаблицаФорматов.Колонки.Добавить("Длина");
мТаблицаФорматов.Колонки.Добавить("Дополнение");
мТаблицаФорматов.Колонки.Добавить("НаименованиеФормы");

мТаблицаПоказателейДляПередачиДанных = Новый ТаблицаЗначений;
мТаблицаПоказателейДляПередачиДанных.Колонки.Добавить("КодФормыИсточник");       
мТаблицаПоказателейДляПередачиДанных.Колонки.Добавить("ИмяОбластиИсточник");       
мТаблицаПоказателейДляПередачиДанных.Колонки.Добавить("КодФормыПриемник");       
мТаблицаПоказателейДляПередачиДанных.Колонки.Добавить("ИмяОбластиПриемник");       
                                                     
ИмяПакета = "http://www.fno910.rating.kz";
ИмяФайлаВыгрузки = "910.efn";

мПризнакСистемыСотрудниковЗУП20  = Ложь;
Если Метаданные.РегистрыСведений.РаботникиОрганизаций.Измерения.Найти("ФизЛицо") = Неопределено Тогда
	мПризнакСистемыСотрудниковЗУП20 = Истина;
КонецЕсли;


// определим ФИО исполнителя
Запрос =  Новый Запрос;
Запрос.УстановитьПараметр("Исполнитель", глТекущийПользователь.ФизЛицо);
Запрос.Текст = "
|ВЫБРАТЬ
|	ФИОФИзЛиц.Фамилия,
|	ФИОФИзЛиц.Имя,
|	ФИОФИзЛиц.Отчество
|ИЗ
|	РегистрСведений.ФИОФизЛиц.СрезПоследних(, ФизЛицо = &Исполнитель) КАК ФИОФизЛиц
|";

Выборка = Запрос.Выполнить().Выбрать();
Если Выборка.Следующий() Тогда
	мИсполнитель = Выборка.Фамилия + ?(Выборка.Имя <> "", " " + Выборка.Имя, "") + ?(Выборка.Отчество <> "", " " + Выборка.Отчество, "");
Иначе
	Если глТекущийПользователь.ФизЛицо.Пустая() Тогда
		мИсполнитель = глТекущийПользователь.Наименование;
	Иначе
		мИсполнитель = глТекущийПользователь.ФизЛицо.Наименование;
	КонецЕсли;
КонецЕсли;

мПризнакАлиментов = Ложь;
мИсключатьНерезидентов = Ложь;

мТаблицаСтраницНаПечать = Новый ТаблицаЗначений;
мТаблицаСтраницНаПечать.Колонки.Добавить("ПолеТабличногоДокумента");
мТаблицаСтраницНаПечать.Колонки.Добавить("ИмяЛиста");
мТаблицаСтраницНаПечать.Колонки.Добавить("ИмяЛистаДляЗаписи");

мИсчислятьСОБезОграниченияНаСуммуИсчисленногоСН = Ложь;

мОтразитьВзносыОСМСПоДоговорамГПХ = Ложь;

мОтчетныйПериодПолугодие = Ложь;

мРасчетНаРегистрах = Метаданные.РегистрыРасчета.Найти("ОсновныеНачисленияРаботниковОрганизаций") <> Неопределено;
#КонецЕсли
