﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Список = Новый СписокЗначений;
	Список.Добавить("День");
	Список.Добавить("Неделя");
	Список.Добавить("Декада");
	Список.Добавить("Месяц");
	Список.Добавить("Квартал");
	Список.Добавить("Полугодие");
	Список.Добавить("Год");
	мРезультат = Список.ВыбратьЭлемент("Выберите периодичность");
	Если мРезультат <> Неопределено Тогда 
		Период = мРезультат.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Список = Новый СписокЗначений;
	Список.Добавить("День");
	Список.Добавить("Неделя");
	Список.Добавить("Декада");
	Список.Добавить("Месяц");
	Список.Добавить("Квартал");
	Список.Добавить("Полугодие");
	Список.Добавить("Год");
	ДанныеВыбора = список;
КонецПроцедуры

&НаКлиенте
Процедура РежимСверкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Список = Новый СписокЗначений;
	Список.Добавить(ПредопределенноеЗначение("Перечисление.дог_РежимФормированияСверкиПоДоговорам.ПоВсемДоговорам"));
	Список.Добавить(ПредопределенноеЗначение("Перечисление.дог_РежимФормированияСверкиПоДоговорам.ТолькоПоЗарегистрированнымСРасхождением"));
	ДанныеВыбора = Список;
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьДанныеПоПодчиненнымДоговорамКонтрагентаПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ТаблицаДокументыПланирования, ТаблицаДокументыОплаты, ТаблицаСделки>

&НаКлиенте
Процедура ТаблицаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	РезультатОбработки = ОбработатьРасшифровку(Расшифровка,,Элемент.Имя);
	Если РезультатОбработки = Неопределено Тогда
		Возврат;
	ИначеЕсли РезультатОбработки.Действие = "ОткрытьЗначение" Тогда
		ОткрытьЗначение(РезультатОбработки.Параметр);
	ИначеЕсли РезультатОбработки.Действие = "ВыбратьРасшифровку" Тогда
		РезультатВыбора = ВыбратьИзСписка(РезультатОбработки.Параметр);
		Если РезультатВыбора<>Неопределено Тогда
			РезультатОбработки = ОбработатьРасшифровку(Расшифровка,РезультатВыбора.Значение,Элемент.Имя);
			Если РезультатОбработки<>Неопределено Тогда
				ОткрытьФорму(РезультатОбработки.Действие,РезультатОбработки.Параметр,ЭтаФорма,УникальныйИдентификатор);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОткрытьФорму(РезультатОбработки.Действие,РезультатОбработки.Параметр,ЭтаФорма,УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура РегистрацияСобытия(Команда)
	нПараметры = ПолучитьПараметрыСобытия(Объект.Договор);
	ОткрытьФорму("Документ.дог_РегистрацияСобытийДоговоров.ФормаОбъекта",нПараметры,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	АдресДанных = ВывестиОтчет(НаДату,Объект.Договор,РезультатОтчета,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента);
	РазместитьРасшифровку(АдресДанных,"РезультатОтчета");
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиРасчетПлатежей(Команда)
	ПараметрыРасчета = ПолучитьПараметрыРасчета();
	ОткрытьФорму("Обработка."+?(ВходящееОбязательство,"ден_ФормированиеПланируемыхПоступленийДенежныхСредств","ден_ФормированиеЗаявокНаРасходованиеСредствПоДоговорам")+".Форма.Форма",ПараметрыРасчета,ЭтаФорма,УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоОстаткамЗадолженности(Команда)
	АдресДанных = ВывестиОтчетОстатки(КонецДня(Дата),Объект.Договор,РезультатОстатки,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента);
	РазместитьРасшифровку(АдресДанных,"РезультатОстатки");
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоАнализуЗадолженности(Команда)
	АдресДанных = ВывестиОтчетАнализ(ДатаНачала,КонецДня(ДатаОкончания),Периодичность,Период,Объект.Договор,РезультатАнализ,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента);
	РазместитьРасшифровку(АдресДанных,"РезультатАнализ");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПланыПлатежей(Команда)
	СформироватьПланыПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСделки(Команда)
	СформироватьСделки();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОплаты(Команда)
	СформироватьОплаты();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСпецификацию(Команда)
	АдресДанных = ВывестиОтчетСпецификация(ДатаСпецификаци,Объект.Договор,РезультатСпецификация,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,ОтображениеДатПоставки);
	РазместитьРасшифровку(АдресДанных,"РезультатСпецификация");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСверка(Команда)
	АдресДанных = ВывестиОтчетСверка(Объект.Договор,РежимСверки,РезультатСверка,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента);
	РазместитьРасшифровку(АдресДанных,"РезультатСверка");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьАнализСроковПоставки(Команда)
	АдресДанных = ВывестиОтчетАнализСроковПоставки(Объект.Договор,РезультатАнализСроков,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,ОтображениеДатПоставки);
	РазместитьРасшифровку(АдресДанных,"РезультатАнализСроков");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОжидаемыеПоставки(Команда)
	АдресДанных = ВывестиОтчетОжидаемыеПоставки(Объект.Договор,РезультатОжидаемыеПоставки,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,ОтображениеДатПоставки);
	РазместитьРасшифровку(АдресДанных,"РезультатОжидаемыеПоставки");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	ТекущиеДанные = Элементы.ДеревоДоговоров.ТекущиеДанные;
	Если ТекущиеДанные<>Неопределено Тогда
		ПоказатьЗначение(,ТекущиеДанные.Договор);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ВидимостьИсполнения()
	Элементы.АнализИсполнения.Видимость = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорыИДополнительныеСоглашенияСрезПоследних.ВидОперацииПоДоговору,
	|	ДоговорыИДополнительныеСоглашенияСрезПоследних.ВидДоговораПоТоварнымОперациям,
	|	ДоговорыИДополнительныеСоглашенияСрезПоследних.ВидОбязательства
	|ИЗ
	|	РегистрСведений.дог_ДоговорыИДополнительныеСоглашения.СрезПоследних(, Договор = &Договор) КАК ДоговорыИДополнительныеСоглашенияСрезПоследних";
	
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("УчитыватьИсполнениеТоварныхДоговоров") Тогда
			Если ВыборкаДетальныеЗаписи.ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации Тогда
				Элементы.АнализИсполнения.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.ВидОперацииПоДоговору = Перечисления.дог_ВидыОперацийПоДоговору.ТоварныеОперации Тогда
			ВходящееОбязательство = (ВыборкаДетальныеЗаписи.ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорРеализации);
		Иначе	
			ВходящееОбязательство = (ВыборкаДетальныеЗаписи.ВидОбязательства = Перечисления.дог_ВидыОбязательствПоДоговору.Входящее);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодчиненныеДоговорыВДерево(ТаблицаДоговоров, СтрокаДерева)
	Для Каждого СтрокаДоговор Из ТаблицаДоговоров Цикл
		//НоваяСтрока= СтрокаДерева.Строки.Добавить();
		НоваяСтрока = СтрокаДерева.ПолучитьЭлементы().Добавить();
		НоваяСтрока.Договор = СтрокаДоговор.Договор;
		НоваяСтрока.ВариантРегистрацииДополнительногоСоглашения = СтрокаДоговор.ВариантРегистрацииДополнительногоСоглашения;
		НоваяСтрока.Картинка = 1;
		ДобавитьДанныеПоРегистрации(НоваяСтрока);
		ПодчиненныеДоговоры = дог_УправлениеДоговорами.ПолучитьПодчиненныеДоговорыПервогоУровня(СтрокаДоговор.Договор,Истина);
		ДобавитьПодчиненныеДоговорыВДерево(ПодчиненныеДоговоры, НоваяСтрока);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеПоРегистрации(СтрокаДерева)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дог_РегистрацияДоговоров.Ссылка
		|ИЗ
		|	Документ.дог_РегистрацияДоговоров КАК дог_РегистрацияДоговоров
		|ГДЕ
		|	дог_РегистрацияДоговоров.ДоговорКонтрагента = &ДоговорКонтрагента
		|	И дог_РегистрацияДоговоров.Проведен";

	Запрос.УстановитьПараметр("ДоговорКонтрагента", СтрокаДерева.Договор);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		//НоваяСтрока= СтрокаДерева.Строки.Добавить();
		НоваяСтрока = СтрокаДерева.ПолучитьЭлементы().Добавить();
		НоваяСтрока.Договор = ВыборкаДетальныеЗаписи.Ссылка;
		НоваяСтрока.Картинка = 0;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыСобытия(Договор)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры.СтруктурноеПодразделение
		|ИЗ
		|	РегистрСведений.дог_ДоговорыИДополнительныеСоглашения.СрезПоследних(
		|			,
		|			Договор = &Договор
		|				И Организация = &Организация) КАК Договоры";

	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Организация", Договор.Организация);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
       	СП = ВыборкаДетальныеЗаписи.СтруктурноеПодразделение;
	Иначе 
		СП = Справочники.ПодразделенияОрганизаций.ПустаяСсылка(); 
	КонецЕсли;

	Возврат Новый Структура("ДоговорКонтрагента,Контрагент,Организация,СтруктурноеПодразделение",Договор,Договор.Владелец,Договор.Организация,СП);	
Конецфункции

&НаСервереБезКонтекста
Функция ВывестиОтчет(Дата, Договор, Результат, УникальныйИдентификатор ,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента)
	Результат.Очистить();
	ОбъектОтчета = Отчеты.дог_ИсполнениеДоговоров.Создать();
	ОбъектОтчета.Дата = Дата;
	ОбъектОтчета.ДоговорКонтрагента = Договор;
	ОбъектОтчета.Контрагент = Договор.Владелец;
	ОбъектОтчета.Организация = Договор.Организация;
	ОбъектОтчета.ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	ВариантОтчета = ОбъектОтчета.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(?(ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,"ТабличныйВид","Основной"));
	ОбъектОтчета.КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.Настройки);
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьЗаголовок",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьПараметрыДанных",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ОбъектОтчета.Скомпоновать(Результат);
	Адрес = ПоместитьВоВременноеХранилище(ОбъектОтчета.ДанныеРасшифровки,УникальныйИдентификатор);
	Возврат Адрес;
КонецФункции

&НаСервере
Функция ПолучитьПараметрыРасчета()
	Возврат Новый Структура("Организация,Контрагент,Договор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента",Объект.Договор.Организация,Объект.Договор.Владелец,Объект.Договор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента);	
КонецФункции

&НаСервереБезКонтекста
Функция ВывестиОтчетОстатки(Дата, Договор, Результат, УникальныйИдентификатор, ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента)
	Результат.Очистить();
	ОбъектОтчета = Отчеты.дог_ОстаткиЗадолженностиБУПоДоговору.Создать();
	ОбъектОтчета.ДатаОтчета = Дата;
	ОбъектОтчета.ДоговорКонтрагента = Договор;
	ОбъектОтчета.Организация = Договор.Организация;
	ОбъектОтчета.Контрагент = Договор.Владелец;
	ОбъектОтчета.ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	ВариантОтчета = ОбъектОтчета.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(?(ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,"ПоДоговорам","Основной"));
	ОбъектОтчета.КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.Настройки);	
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьЗаголовок",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьПараметрыДанных",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	УстановитьПривилегированныйРежим(Истина);
	ОбъектОтчета.Скомпоновать(Результат);
	Адрес = ПоместитьВоВременноеХранилище(ОбъектОтчета.ДанныеРасшифровки,УникальныйИдентификатор);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Адрес;
КонецФункции

&НаСервереБезКонтекста
Функция ВывестиОтчетАнализ(ДатаНачала,ДатаОкончания,Периодичность,Период,Договор,Результат,УникальныйИдентификатор,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента)
	Результат.Очистить();
	Если Периодичность Тогда
		ОбъектОтчета = Отчеты.дог_АнализЗадолженностиБУПоДоговоруВРазрезеПериодов.Создать();
		ОбъектОтчета.ПериодичностьОтчета = Период;
	Иначе
		ОбъектОтчета = Отчеты.дог_АнализЗадолженностиБУПоДоговору.Создать();
	КонецЕсли;
	ОбъектОтчета.НачалоПериода = ДатаНачала;
	ОбъектОтчета.КонецПериода = ДатаОкончания;
	ОбъектОтчета.ДоговорКонтрагента = Договор;
	ОбъектОтчета.Организация = Договор.Организация;
	ОбъектОтчета.Контрагент = Договор.Владелец;
	ОбъектОтчета.ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	ВариантОтчета = ОбъектОтчета.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(?(ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,"ПоДоговорам","Основной"));
	ОбъектОтчета.КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.Настройки);	
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьЗаголовок",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьПараметрыДанных",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	УстановитьПривилегированныйРежим(Истина);
	ОбъектОтчета.Скомпоновать(Результат);
	Адрес = ПоместитьВоВременноеХранилище(ОбъектОтчета.ДанныеРасшифровки,УникальныйИдентификатор);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Адрес;
КонецФункции

&НаСервере
Процедура СформироватьПланыПлатежей()
	мЭтотОбъект = РеквизитФормыВЗначение("Объект");	
	мЭтотОбъект.ДокументыПланирования(ТаблицаДокументыПланирования,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,ПодчиненныеДоговорыТекущего);
КонецПроцедуры

&НаСервере
Процедура СформироватьОплаты()
	мЭтотОбъект = РеквизитФормыВЗначение("Объект");	
	мЭтотОбъект.ДокументыОплаты(ТаблицаДокументыОплаты,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,ПодчиненныеДоговорыТекущего);
КонецПроцедуры

&НаСервере
Процедура СформироватьСделки()
	мЭтотОбъект = РеквизитФормыВЗначение("Объект");	
	мЭтотОбъект.ДокументыСделок(ТаблицаСделки,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,ПодчиненныеДоговорыТекущего);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВывестиОтчетСпецификация(Дата, Договор, Результат, УникальныйИдентификатор, ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента, ОтображениеДатПоставки)
	Результат.Очистить();
	ОбъектОтчета = Отчеты.дог_АктуальнаяСпецификацияДоговора.Создать();
	ОбъектОтчета.Дата = Дата;
	ОбъектОтчета.ДоговорКонтрагента = Договор;
	ОбъектОтчета.Организация = Договор.Организация;
	ОбъектОтчета.Контрагент = Договор.Владелец;
	ОбъектОтчета.ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	Постфикс = ?(ОтображениеДатПоставки="","Горизонтально",ОтображениеДатПоставки);
	ВариантОтчета = ОбъектОтчета.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(?(ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,"ДоговорыВместеДаты","ДоговорыРаздельноДаты")+Постфикс);
	ОбъектОтчета.КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.Настройки);	
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьЗаголовок",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьПараметрыДанных",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	УстановитьПривилегированныйРежим(Истина);
	ОбъектОтчета.Скомпоновать(Результат);
	Адрес = ПоместитьВоВременноеХранилище(ОбъектОтчета.ДанныеРасшифровки,УникальныйИдентификатор);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Адрес;
КонецФункции

&НаКлиенте
Процедура РазместитьРасшифровку(АдресДанных, ИмяЭлемента)
	Если СписокАдресов.НайтиПоЗначению(ИмяЭлемента)<>Неопределено Тогда
		СписокАдресов.Удалить(СписокАдресов.НайтиПоЗначению(ИмяЭлемента));
	КонецЕсли;
	СписокАдресов.Добавить(ИмяЭлемента,АдресДанных);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВывестиОтчетСверка(Договор, РежимСверки, Результат, УникальныйИдентификатор, ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента)
	Результат.Очистить();
	ОбъектОтчета = Отчеты.дог_СверкаДанныхПоДоговорам.Создать();
	ОбъектОтчета.ДоговорКонтрагента = Договор;
	ОбъектОтчета.РежимСверки = РежимСверки;
	ОбъектОтчета.Контрагент = Договор.Владелец;
	ОбъектОтчета.ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьЗаголовок",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	ОбъектОтчета.КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВыводитьПараметрыДанных",ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	УстановитьПривилегированныйРежим(Истина);
	ОбъектОтчета.Скомпоновать(Результат,Новый ДеревоЗначений,Новый СписокЗначений,Новый СписокЗначений);
	Адрес = ПоместитьВоВременноеХранилище(ОбъектОтчета.ДанныеРасшифровки,УникальныйИдентификатор);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Адрес;
КонецФункции

&НаСервере
Функция ОбработатьРасшифровку(Расшифровка, ВариантРасшифровки = Неопределено, ИмяПоля)
	СоответствиеОтчетовИПолей = Новый Соответствие;
	СоответствиеОтчетовИПолей.Вставить("РезультатСверка","дог_СверкаДанныхПоДоговорам");
	СоответствиеОтчетовИПолей.Вставить("РезультатСпецификация","дог_АктуальнаяСпецификацияДоговора");
	СоответствиеОтчетовИПолей.Вставить("РезультатАнализ","дог_АнализЗадолженностиБУПоДоговору");
	СоответствиеОтчетовИПолей.Вставить("РезультатОстатки","дог_ОстаткиЗадолженностиБУПоДоговору");
	СоответствиеОтчетовИПолей.Вставить("РезультатОтчета","дог_ИсполнениеДоговоров");
	ИмяОтчета = СоответствиеОтчетовИПолей.Получить(ИмяПоля);
	Если ИмяОтчета = "дог_АнализЗадолженностиБУПоДоговору" И Периодичность Тогда
		ИмяОтчета = "дог_АнализЗадолженностиБУПоДоговоруВРазрезеПериодов";
	КонецЕсли;
	ПоискАдреса = СписокАдресов.НайтиПоЗначению(ИмяПоля);
	Если ПоискАдреса = Неопределено Тогда
		Если ЗначениеЗаполнено(Расшифровка) Тогда
			Возврат Новый Структура("Действие,Параметр","ОткрытьЗначение",Расшифровка);
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	Адрес = ПоискАдреса.Представление;
	ДанныеДляОбработки = ПолучитьИзВременногоХранилища(Адрес);
	ИнформацияДляРасшифровки = ДанныеДляОбработки.Элементы.Получить(Расшифровка);
	Если ИнформацияДляРасшифровки <> Неопределено Тогда
		ДействиеРасшифровки = СокрЛП(Строка(ИнформацияДляРасшифровки.ОсновноеДействие));
		Данные = ИнформацияДляРасшифровки.ПолучитьПоля();
		Если ДействиеРасшифровки= "Нет" Тогда
			Возврат Неопределено;
		ИначеЕсли ДействиеРасшифровки = "Открыть значение" Тогда
			Возврат Новый Структура("Действие,Параметр","ОткрытьЗначение",Данные[0].Значение);
		ИначеЕсли ДействиеРасшифровки = "Расшифровать" Тогда
			Если ИмяОтчета = "дог_АнализЗадолженностиБУПоДоговору" 
				ИЛИ ИмяОтчета = "дог_АнализЗадолженностиБУПоДоговоруВРазрезеПериодов"
				ИЛИ ИмяОтчета = "дог_ОстаткиЗадолженностиБУПоДоговору" Тогда
				ТаблицаОтбора = Новый ТаблицаЗначений;
				ТаблицаОтбора.Колонки.Добавить("Поле");
				ТаблицаОтбора.Колонки.Добавить("ВидСравнения");
				ТаблицаОтбора.Колонки.Добавить("Значение");
				ЗаполнитьОтборИзГруппировок(ТаблицаОтбора,ИнформацияДляРасшифровки,ДанныеДляОбработки);
				Если ТаблицаОтбора.Количество()=0 Тогда
					Возврат Неопределено;
				КонецЕсли;
				ИмяПоляРасшифровки = ИнформацияДляРасшифровки.ПолучитьПоля()[0].Поле;
				ВидОбязательства = Неопределено;
				ГруппаОбязательств = Неопределено;
				СрокЗадолженности = Неопределено;
				Счет = Неопределено;
				СтрокиПеременной = ТаблицаОтбора.НайтиСтроки(Новый Структура("Поле","ВидОбязательства"));
				Если СтрокиПеременной.Количество()>0 Тогда
					ВидОбязательства = СтрокиПеременной[0].Значение;
				КонецЕсли;
				СтрокиПеременной = ТаблицаОтбора.НайтиСтроки(Новый Структура("Поле","ГруппаОбязательств"));
				Если СтрокиПеременной.Количество()>0 Тогда
					ГруппаОбязательств = СтрокиПеременной[0].Значение;
				КонецЕсли;
				СтрокиПеременной = ТаблицаОтбора.НайтиСтроки(Новый Структура("Поле","СрокЗадолженности"));
				Если СтрокиПеременной.Количество()>0 Тогда
					СрокЗадолженности = СтрокиПеременной[0].Значение;
				КонецЕсли;
				СтрокиПеременной = ТаблицаОтбора.НайтиСтроки(Новый Структура("Поле","Счет"));
				Если СтрокиПеременной.Количество()>0 Тогда
					Счет = СтрокиПеременной[0].Значение;
				КонецЕсли;
				ПериодРасшифровкиНачало = ДатаНачала;
				ПериодРасшифровкиКонец = КонецДня(ДатаОкончания);
				Если ИмяОтчета = "дог_АнализЗадолженностиБУПоДоговоруВРазрезеПериодов" Тогда
					СтрокиПеременной = ТаблицаОтбора.НайтиСтроки(Новый Структура("Поле","ПериодичностьОтчета"));
					Если СтрокиПеременной.Количество()>0 Тогда
						ПериодРасшифровкиНачало = СтрокиПеременной[0].Значение;
						ПериодРасшифровкиКонец = фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.ДатаКонцаПериода(ПериодРасшифровкиНачало,Перечисления.фин_Периодичность[ЭтаФорма["Период"]]);
					КонецЕсли;
				ИначеЕсли ИмяОтчета = "дог_ОстаткиЗадолженностиБУПоДоговору" Тогда
					ПериодРасшифровкиКонец = КонецДня(Дата);
				КонецЕсли;
				ТекстРасшифровки = дог_УправлениеДоговорами.ПолучитьРасшифровкуДляОтчетаПоЗадолженности(ИмяОтчета,Объект.Договор.Организация,Объект.Договор.Владелец,Объект.Договор,ИмяПоляРасшифровки,ВидОбязательства,ГруппаОбязательств,СрокЗадолженности,ПериодРасшифровкиНачало,ПериодРасшифровкиКонец,Счет);
				Если ТекстРасшифровки<>"" Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстРасшифровки, , , "Объект");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ЗаполнитьОтборИзГруппировок(ТаблицаОтбора, ИнформацияДляРасшифровки, ДанныеРасшифровки)
	РодительскиеПоля = ИнформацияДляРасшифровки.ПолучитьРодителей();
	Для Каждого ПолеРодитель Из РодительскиеПоля Цикл
		ДанныеРодителя = ДанныеРасшифровки.Элементы.Получить(ПолеРодитель.Идентификатор);
		Если НЕ ТипЗнч(ДанныеРодителя)=Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка") Тогда
			Для Каждого ПолеРодителя Из ДанныеРодителя.ПолучитьПоля() Цикл
				Если ПолеРодителя.Поле = "ЕдиницаИзмерения" Тогда
					Продолжить;
				КонецЕсли;
				НС = ТаблицаОтбора.Добавить();
				НС.Поле = ПолеРодителя.Поле;
				НС.Значение = ПолеРодителя.Значение;
				НС.ВидСравнения = ?(ЗначениеЗаполнено(ПолеРодителя.Значение),?(ПолеРодителя.Иерархия,"ВИерархии","Равно"),"Незаполнено");
			КонецЦикла;
		КонецЕсли;
		ЗаполнитьОтборИзГруппировок(ТаблицаОтбора,ДанныеРодителя,ДанныеРасшифровки);
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВывестиОтчетОжидаемыеПоставки(Договор, Результат, УникальныйИдентификатор, ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента, ОтображениеДатПоставки)
	Результат.Очистить();

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дог_ДоговорыИДополнительныеСоглашенияСрезПоследних.ВидДоговораПоТоварнымОперациям
		|ИЗ
		|	РегистрСведений.дог_ДоговорыИДополнительныеСоглашения.СрезПоследних(, Договор = &Договор) КАК дог_ДоговорыИДополнительныеСоглашенияСрезПоследних";

	Запрос.УстановитьПараметр("Договор", Договор);

	мРезультат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = мРезультат.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если ВыборкаДетальныеЗаписи.ВидДоговораПоТоварнымОперациям = Перечисления.дог_ВидыДоговоровПоТоварнымОперациям.ДоговорРеализации Тогда
			ОбъектОтчета = Отчеты.дог_ГрафикОтгрузкиПокупателям.Создать();
		Иначе
			ОбъектОтчета = Отчеты.дог_ГрафикПоступленияТоваровИУслугОтПоставщиков.Создать();
		КонецЕсли;
	Иначе
		Возврат "";
	КонецЕсли;
	Постфикс = ?(ОтображениеДатПоставки="","Горизонтально",ОтображениеДатПоставки);
	ОбъектОтчета.ДоговорКонтрагента = Договор;
	ОбъектОтчета.Контрагент = Договор.Владелец;
//	ОбъектОтчета.Организация = Договор.Организация;
	ОбъектОтчета.ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	ВариантОтчета = ОбъектОтчета.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(?(ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,"ДоговорыВместеДаты","ДоговорыРаздельноДаты")+Постфикс);
	ОбъектОтчета.КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.Настройки);
	СписокОрганизация = Новый СписокЗначений;
	СписокОрганизация.Добавить(Договор.Организация);
	СписокСЕ = Новый СписокЗначений;
	ОбъектОтчета.Скомпоновать(Результат,Новый ДеревоЗначений,СписокОрганизация,СписокСЕ);
	Адрес = ПоместитьВоВременноеХранилище(ОбъектОтчета.ДанныеРасшифровки,УникальныйИдентификатор);
	Возврат Адрес;
КонецФункции

&НаСервереБезКонтекста
Функция ВывестиОтчетАнализСроковПоставки(Договор, Результат, УникальныйИдентификатор, ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента, ОтображениеДатПоставки)
	Результат.Очистить();

	ОбъектОтчета = Отчеты.дог_АнализИсполненияСроковПоставокПоДоговору.Создать();
	Постфикс = ?(ОтображениеДатПоставки="","Горизонтально",ОтображениеДатПоставки);
	ОбъектОтчета.ДоговорКонтрагента = Договор;
	ОбъектОтчета.Контрагент = Договор.Владелец;
//	ОбъектОтчета.Организация = Договор.Организация;
	ОбъектОтчета.ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	ВариантОтчета = ОбъектОтчета.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(?(ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,"ДоговорыВместеДатыПоставки","ДоговорыРаздельноДатыПоставки")+Постфикс);
	ОбъектОтчета.КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.Настройки);
	СписокОрганизация = Новый СписокЗначений;
	СписокОрганизация.Добавить(Договор.Организация);
	СписокСЕ = Новый СписокЗначений;
	ОбъектОтчета.Скомпоновать(Результат,Новый ДеревоЗначений,СписокОрганизация,СписокСЕ);
	Адрес = ПоместитьВоВременноеХранилище(ОбъектОтчета.ДанныеРасшифровки,УникальныйИдентификатор);
	Возврат Адрес;
КонецФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("Договор") Тогда
		Объект.Договор = Параметры.Договор;
	КонецЕсли;
	
	Если НЕ Объект.Договор.Пустая() Тогда
		Элементы.Договор.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Договор.Шрифт = Новый Шрифт(,9,Истина);
		Элементы.Договор.ЦветТекста = Новый Цвет(83,106,194);
	КонецЕсли;	
	
	НаДату = ТекущаяДата();
	Дата = НаДату;
	Период = "Месяц";
	ДатаНачала = НачалоГода(Дата);
	ДатаОкончания = Дата;
	ВидимостьИсполнения();
	ДатаСпецификаци = ТекущаяДата();
	РежимСверки = Перечисления.дог_РежимФормированияСверкиПоДоговорам.ТолькоПоЗарегистрированнымСРасхождением;
	НадписьСобытия = "События по договору";
	НадписьОтчеты = "Отчеты по договору";
	Элементы.СверкаДанных.Видимость=ПравоДоступа("Просмотр",Метаданные.Отчеты.дог_СверкаДанныхПоДоговорам);
	ОтображениеДатПоставки = "Горизонтально";	

	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ПодчиненныеДоговорыТекущего.ЗагрузитьЗначения(дог_УправлениеДоговорами.ПолучитьВсеПодчиненныеДоговоры(Объект.Договор));
	ПодчиненныеДоговорыТекущего.Добавить(Объект.Договор);
	СобытияПоДоговору.Отбор.Элементы.Очистить();
	Если ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента Тогда
		НовыйОтбор = СобытияПоДоговору.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		НовыйОтбор.Использование = Истина;
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДоговорКонтрагента");
		НовыйОтбор.ПравоеЗначение = ПодчиненныеДоговорыТекущего;
		НовыйОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Иначе
		НовыйОтбор = СобытияПоДоговору.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.Использование = Истина;
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДоговорКонтрагента");
		НовыйОтбор.ПравоеЗначение = Объект.Договор;
		НовыйОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	Элементы.СобытияПоДоговоруДоговорКонтрагента.Видимость = ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента;
	
	Элементы.СтруктурноеПодразделениеОрганизация.Видимость = Ложь;
	Если фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьПризнакОтображенияСтруктурныхПодразделений() Тогда
		Элементы.СтруктурноеПодразделениеОрганизация.Видимость = Истина;
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Договоры.СтруктурноеПодразделение
			|ИЗ
			|	РегистрСведений.дог_ДоговорыИДополнительныеСоглашения.СрезПоследних(
			|			,
			|			Договор = &Договор
			|				И Организация = &Организация) КАК Договоры";

		Запрос.УстановитьПараметр("Договор", Объект.Договор);
		Запрос.УстановитьПараметр("Организация", Объект.Договор.Организация);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
	       	СтруктурноеПодразделениеОрганизация = ВыборкаДетальныеЗаписи.СтруктурноеПодразделение;
		Иначе 
			СтруктурноеПодразделениеОрганизация = Объект.Договор.Организация; 
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда
			СтруктурноеПодразделениеОрганизация = Объект.Договор.Организация; 
		КонецЕсли;
	КонецЕсли;
	
	//Дерево = РеквизитФормыВЗначение("ДеревоДоговоров",Тип("ДеревоЗначений"));
	//Дерево.Строки.Очистить();
	ДеревоДоговоров.ПолучитьЭлементы().Очистить();
	ОсновноеСоглашение = дог_УправлениеДоговорами.ПолучитьПервоначальныйДоговорКонтрагента(Объект.Договор);
	//МассивСтрок = Дерево.Строки;
	МассивСтрок = ДеревоДоговоров.ПолучитьЭлементы();
	Элементы.ОсновноеСоглашение.Видимость = ЗначениеЗаполнено(ОсновноеСоглашение) И ОсновноеСоглашение<>Объект.Договор;
	Если ЗначениеЗаполнено(ОсновноеСоглашение) И ОсновноеСоглашение<>Объект.Договор Тогда
		//СтрокаКорень = Дерево.Строки.Добавить();
		СтрокаКорень = ДеревоДоговоров.ПолучитьЭлементы().Добавить();
		СтрокаКорень.Договор = ОсновноеСоглашение;
		СтрокаКорень.Картинка = 1;
		//МассивСтрок = СтрокаКорень.Строки;
		//МассивСтрок = СтрокаКорень.Строки;
		ДобавитьДанныеПоРегистрации(СтрокаКорень);
	КонецЕсли;
	мСтрокаКорень = МассивСтрок.Добавить();
	мСтрокаКорень.Договор = Объект.Договор;
	мСтрокаКорень.Картинка = 1;
	ДобавитьДанныеПоРегистрации(мСтрокаКорень);
	ПодчиненныеДоговоры = дог_УправлениеДоговорами.ПолучитьПодчиненныеДоговорыПервогоУровня(Объект.Договор,Истина);
	ДобавитьПодчиненныеДоговорыВДерево(ПодчиненныеДоговоры,мСтрокаКорень);
	//ЗначениеВРеквизитФормы(Дерево,"ДеревоДоговоров");
	
	ВидимостьИсполнения();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец"));
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);
КонецПроцедуры
