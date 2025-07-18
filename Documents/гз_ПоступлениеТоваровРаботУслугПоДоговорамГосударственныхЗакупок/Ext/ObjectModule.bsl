﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// хранит заголовок
Перем Заголовок; // заголовок
//хранит соответствие реквизитов шапки реквизитам справочника
Перем мСоответствиеРеквизитовШапкиРеквизитамСправочникаДоговоров Экспорт; // (Регл)
//хранит соответствие реквизитов шапки ресурсам 
Перем мСоответствиеРеквизитовШапкиРесурсамРегистраДоговоров Экспорт; // (Регл)
//хранит соответствие реквизитов товаров ресурсам 
Перем мСоответствиеРеквизитовТЧТоваровУслугРесурсамРегистраТоваровУслуг Экспорт; // (Регл)
//хранит значение валюты регламентированного учета 
Перем мВалютаРегламентированногоУчета Экспорт; // (Регл)
// Хранит значение признака ведения закупок в разрезе складов 
Перем ВедениеУчетаЗакупокВРазрезеСкладов Экспорт; // признак учета закупок в разрезе складов

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Функция выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицу(РезультатЗапроса, СтруктураШапкиДокумента)
	
	Таблица = РезультатЗапроса.Выгрузить();
	
	Возврат Таблица;
	
КонецФункции // ПодготовитьТаблицу()

// Процедура выполняет движения по регистрам 
// 
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаТовары,  Отказ)
	СписатьГП = (Константы.гз_СпособУчетаИсполненияГодовогоПлана.Получить() = Перечисления.гз_СпособыУчетаИсполненияГодовогоПлана.ПриФактическомПоступлении ИЛИ Константы.гз_СпособУчетаИсполненияГодовогоПлана.Получить().Пустая());
	УчетИсполненияЗаказов = Константы.гз_ВестиУчетИсполненияЗаказовПодразделений.Получить();
	
	Если СписатьГП Тогда 
		Если ИспользованиеВидовПлановЗакупок.Количество() > 0 Тогда 
			МассивВидовПлановЗакупок = ИспользованиеВидовПлановЗакупок.ВыгрузитьКолонку("ВидПланаЗакупок");
		Иначе 
			Запрос=новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	гз_ИспользуемыеВидыПлановЗакупокСрезПоследних.ВидПланаЗакупок
			|ИЗ
			|	РегистрСведений.гз_ИспользуемыеВидыПлановЗакупок.СрезПоследних(
			|			НачалоПериода(&Год,ГОД),
			|				Организация = &Организация) КАК гз_ИспользуемыеВидыПлановЗакупокСрезПоследних";
			Запрос.УстановитьПараметр("Год", Год);
			Запрос.УстановитьПараметр("Организация", Организация);
			МассивВидовПлановЗакупок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидПланаЗакупок");
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	МАКСИМУМ(гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки) КАК СпособЗакупки
		|ИЗ
		|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
		|ГДЕ
		|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.ДоговорКонтрагента = &ДоговорКонтрагента";
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			СпособЗакупки = Выборка.СпособЗакупки;
		Иначе 
			СпособЗакупки = Справочники.гз_СпособыЗакупки.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ТекСтр Из ТаблицаТовары Цикл
		// движения по фактическому поступлению
		Движение = Движения.гз_ДвижениеНоменклатурыПоДоговорам.Добавить();
		Движение.ДоговорКонтрагента 	= СтруктураШапкиДокумента.ДоговорКонтрагента;
		Движение.Регистратор 			= Ссылка;
		Движение.Период 				= СтруктураШапкиДокумента.Дата;
		Движение.ДоговорКонтрагента	= СтруктураШапкиДокумента.ДоговорКонтрагента;
		Движение.Организация			= СтруктураШапкиДокумента.Организация;
		Движение.Количество  			= ТекСтр.Количество*?(ВозвратПоставщику,-1,1);
		Движение.Номенклатура 			= ТекСтр.Номенклатура;
		Движение.Сумма					= ТекСтр.Сумма*?(ВозвратПоставщику,-1,1);
		
		Если УчетИсполненияЗаказов Тогда
			Движение = Движения.гз_ТРУНераспределенные.ДобавитьПриход();
			Движение.Период 		= СтруктураШапкиДокумента.Дата;
			Движение.Организация 	= СтруктураШапкиДокумента.Организация;
			Движение.МестоПоставки	= ?(ТекСтр.МестоПоставки.Пустая(),СтруктураШапкиДокумента.МестоПоставки,ТекСтр.МестоПоставки);
			Движение.Количество  	= ТекСтр.Количество*?(ВозвратПоставщику,-1,1);
			Движение.Номенклатура 	= ТекСтр.Номенклатура;
			Движение.Сумма			= ТекСтр.Сумма*?(ВозвратПоставщику,-1,1);
		КонецЕсли;
		
		Если ВедениеУчетаЗакупокВРазрезеСкладов Тогда 	 
			
			// Движения по регистру накопления гз_ДвижениеНоменклатурыПоДоговорамПоМестамПоставки
			Движение = Движения.гз_ДвижениеНоменклатурыПоДоговорамПоМестамПоставки.ДобавитьРасход();
			Движение.ДоговорКонтрагента 	= СтруктураШапкиДокумента.ДоговорКонтрагента;
			Движение.Регистратор 			= Ссылка;
			Движение.Период 				= СтруктураШапкиДокумента.Дата;
			Движение.ДоговорКонтрагента	= СтруктураШапкиДокумента.ДоговорКонтрагента;
			Движение.Год					= СтруктураШапкиДокумента.Год;
			Движение.Организация			= СтруктураШапкиДокумента.Организация;
			Движение.Количество  			= ТекСтр.Количество*?(ВозвратПоставщику,-1,1);
			Движение.Номенклатура 			= ТекСтр.Номенклатура;
			Движение.Склад					= ?(ТекСтр.МестоПоставки.Пустая(),СтруктураШапкиДокумента.МестоПоставки.Склад,ТекСтр.МестоПоставки.Склад);
			Движение.Сумма					= ТекСтр.Сумма*?(ВозвратПоставщику,-1,1);
			
		КонецЕсли;
		
		Если СписатьГП Тогда
			Для Каждого ВидПланаЗакупок Из МассивВидовПлановЗакупок Цикл 
				// движения по регистру гз_ДвижениеНоменклатурыПоГодовомуПлану
				Движение = Движения.гз_ДвижениеНоменклатурыПоГодовомуПлану.ДобавитьРасход();
				Движение.Год					 = СтруктураШапкиДокумента.Год;
				Движение.ВидПланаЗакупок		 = ВидПланаЗакупок;
				Движение.Номенклатура			 = ТекСтр.Номенклатура;
				Движение.Количество			 	 = ТекСтр.Количество*?(ВозвратПоставщику,-1,1);
				Движение.Организация			 = СтруктураШапкиДокумента.Организация;
				Движение.Сумма					 = ТекСтр.Сумма*?(ВозвратПоставщику,-1,1);
				Движение.Период				 	 = СтруктураШапкиДокумента.Дата;
				Движение.СпособЗакупки		 	 = СпособЗакупки;
			КонецЦикла;
						
		КонецЕсли;
		
	КонецЦикла;
	
	Если УчетИсполненияЗаказов И ВозвратПоставщику Тогда
		// проверка свободных остатков по данным исполнения
		Движения.гз_ТРУНераспределенные.Записать();
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.МестоПоставки
		|ПОМЕСТИТЬ ВТ_Товары
		|ИЗ
		|	Документ.гз_ПоступлениеТоваровРаботУслугПоДоговорамГосударственныхЗакупок.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Остатки.МестоПоставки,
		|	Остатки.Номенклатура,
		|	Остатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.гз_ТРУНераспределенные.Остатки(
		|			&Дата,
		|			Организация = &Организация
		|				И (МестоПоставки, Номенклатура) В
		|					(ВЫБРАТЬ
		|						ВТ_Товары.МестоПоставки,
		|						ВТ_Товары.Номенклатура
		|					ИЗ
		|						ВТ_Товары)) КАК Остатки
		|ГДЕ
		|	Остатки.КоличествоОстаток < 0";
		Запрос.УстановитьПараметр("Организация",СтруктураШапкиДокумента.Организация);
		Запрос.УстановитьПараметр("Дата",		СтруктураШапкиДокумента.Дата+1);
		Запрос.УстановитьПараметр("Ссылка",		СтруктураШапкиДокумента.Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Отказ = Истина;
			Сообщить("Документ "+Ссылка+" не может быть проведен, так как недостаточно остатков согласно регистру Позиции заказов к исполнению:");
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				Сообщить("	- "+Выборка.Номенклатура+"; место поставки: "+Выборка.МестоПоставки+"; количество: "+Строка(-Выборка.КоличествоОстаток));
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	//Движения по регистру статусы договоров
	Если СтатусДоговора <> Перечисления.гз_СтатусыДоговоров.Статус_0 Тогда
		Движение = Движения.гз_СтатусыДоговоровПоГосударственнымЗакупкам.Добавить();
		Движение.ДоговорКонтрагента = СтруктураШапкиДокумента.ДоговорКонтрагента;
		Движение.Регистратор = Ссылка;
		Движение.Период = Дата;
		Движение.Статус = СтруктураШапкиДокумента.СтатусДоговора;
	КонецЕсли;
	
КонецПроцедуры //ДвиженияПоРегистрам()

// Процедура проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаТовары, СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ИмяТабличнойЧасти = "Товары";
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура,Количество,Сумма");	
	
	// Теперь позовем общую процедуру проверки.
	гз_ОбщегоНазначения.мПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары",СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Процедура проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
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
	СтруктураОбязательныхПолей = Новый Структура("Организация,ДоговорКонтрагента,Год,Контрагент,СтатусДоговора");
	// Теперь позовем общую процедуру проверки.
	гз_ОбщегоНазначения.мПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Заголовок = гз_ОбщегоНазначения.мПредставлениеДокументаПриПроведении(Ссылка);
	
	// 1 - сначала заполним элемент справочника ДоговорКонтрагента
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = гз_ОбщегоНазначения.мСформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	 Если НЕ гз_ОбщегоНазначения.ЭтоДоговорГосЗакупок(ДоговорКонтрагента) Тогда 
		 Сообщить("Выбранный договор не является договором по государственным закупкам!");
		 Отказ = Истина;
	 КонецЕсли;
	
	// Если шапка заполнена некорректно, то договор создавать не будем, а проводки выполнять - тем более
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	// Проверка ручной корректировки
	Если гз_ОбщегоНазначения.мРучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка, Отказ, Заголовок,	ЭтотОбъект) Тогда 
		Возврат;
	КонецЕсли;
	
	// таблица Товары
	СтруктураПолей = Новый Структура;
	Для Каждого Реквизит Из Ссылка.Метаданные().ТабличныеЧасти.Товары.Реквизиты Цикл
		Имя = Реквизит.Имя;
		СтруктураПолей.Вставить(Имя, Имя);
	КонецЦикла; 
	РезультатЗапросаПоТоварам = гз_ПроцедурыОперативногоУчетаЗакупок.мСформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);
	ТаблицаТовары = ПодготовитьТаблицу(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаТовары, СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаТовары,  Отказ);
	
КонецПроцедуры //ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	гз_ОбщегоНазначения.мУдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
	
КонецПроцедуры //ОбработкаУдаленияПроведения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = Товары.Итог("Сумма");
	
	Год = НачалоГода(Год);
	
	Если ОбменДанными.Загрузка ИЛИ ДополнительныеСвойства.Свойство("ВнешняяОбработка") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДоговорКонтрагента.Пустая() Тогда
		Отказ=Истина;
		Сообщить("Документ "+?(ЭтоНовый(),"Регистрация поступлений товаров, работ и услуг по договорам государственных закупок №"+Строка(Номер)+" от "+Строка(Дата),Строка(Ссылка))+" не может быть записан: 
		|	не указан договор контрагента!",СтатусСообщения.ОченьВажное);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры //ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПЕЧАТИ ДОКУМЕНТА

#Если Клиент Тогда
	
	// Процедура осуществляет печать документа. Можно направить печать на 
	// экран или принтер, а также распечатать необходимое количество копий.
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
		КонецЕсли;
		
		Если НЕ гз_РаботаСДиалогами.мПроверитьМодифицированность(ЭтотОбъект) Тогда
			Возврат;
		КонецЕсли;	
		
		ТабДокумент = Новый ТабличныйДокумент;
		
		гз_РаботаСДиалогами.мНапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, гз_РаботаСДиалогами.мСформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));
		
	КонецПроцедуры // Печать()
	
	////////////////////////////////////////////////////////////////////////////////
	// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА
	
	// Функция формирует бухгалтерские документы
	//
	Функция ОформитьПоступлениеБУ(Документ,Вид=Неопределено,Склад = Неопределено) Экспорт
		
		Возврат гз_ПроцедурыОперативногоУчетаЗакупок.ОформитьПоступлениеБУ(мВалютаРегламентированногоУчета,
														ВедениеУчетаЗакупокВРазрезеСкладов,Документ);
														
	КонецФункции //ОформитьПоступлениеБУ()
	
#КонецЕсли

// Процедура заполнения документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание)  Экспорт
	
	гз_ПроцедурыОперативногоУчетаЗакупок.ЗаполнитьРегистрациюПоступленийПоДокументуОснования(Основание, 
															ЭтотОбъект, мВалютаРегламентированногоУчета);	
КонецПроцедуры //ЗаполнитьПоДокументуОснования()

// Функция возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура();
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура - обработчик стандартного события ОбработкаЗаполнения
//
Процедура ОбработкаЗаполнения(Основание)
	Если НЕ Документы.ТипВсеСсылки().Типы().Найти(ТипЗнч(Основание)) = Неопределено Тогда 
		ЗаполнитьПоДокументуОснования(Основание);
	КонецЕсли;
КонецПроцедуры //ОбработкаЗаполнения()

// Функция формирует список для отбора списка соглашений
//
// Возвращаемое значение:
//  Массив
//  
Функция СформироватьСписокДляОтбораСпискаСоглашений() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	гз_РегистрацияДоговораПоГосударственнымЗакупкам.Ссылка
	|ИЗ
	|	Документ.гз_РегистрацияДоговораПоГосударственнымЗакупкам КАК гз_РегистрацияДоговораПоГосударственнымЗакупкам
	|ГДЕ
	|	гз_РегистрацияДоговораПоГосударственнымЗакупкам.ДоговорКонтрагента = &ДоговорКонтрагента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	гз_РегистрацияДоговораПоГосударственнымЗакупкам.Ссылка
	|ИЗ
	|	Документ.гз_РегистрацияДоговораПоГосударственнымЗакупкам КАК гз_РегистрацияДоговораПоГосударственнымЗакупкам
	|ГДЕ
	|	гз_РегистрацияДоговораПоГосударственнымЗакупкам.ОсновноеСоглашение.ДоговорКонтрагента = &ДоговорКонтрагента
	|			И гз_РегистрацияДоговораПоГосударственнымЗакупкам.ОсновноеСоглашение <> ЗНАЧЕНИЕ(Документ.гз_РегистрацияДоговораПоГосударственнымЗакупкам.ПустаяСсылка)";
	Запрос.УстановитьПараметр("ДоговорКонтрагента",	ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Ссылка",				Ссылка);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Таблица.Свернуть("Ссылка");
	Возврат Таблица.ВыгрузитьКолонку("Ссылка");
	
КонецФункции //СформироватьСписокДляОтбораСпискаСоглашений()

// Функция формирует массив договоров из регистра сведений гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
//
// Возвращаемое значение:
//  МассивДоговоров
//  
Функция ПолучитьМассивДоговоров() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.ДоговорКонтрагента
	|ИЗ
	|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам";
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДоговорКонтрагента");
	
КонецФункции //ПолучитьМассивДоговоров()

// Функция формирует запрос для получения таблицы цен номенклатуры
//
// Параметры:
//  МассивНоменклатуры.
//
// Возвращаемое значение:
//  Таблица значений, содержащая колонки Номенклатура и Цена
//  
Функция ПолучитьТаблицуЦенНоменклатуры(МассивНоменклатуры) Экспорт 
	
	Возврат гз_ПроцедурыОперативногоУчетаЗакупок.мПолучитьТаблицуЦенНоменклатуры(МассивНоменклатуры,Организация,Год);
	
КонецФункции //ПолучитьТаблицуЦенНоменклатуры()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ВедениеУчетаЗакупокВРазрезеСкладов  = Константы.гз_ВестиУчетЗакупокВРазрезеМестПоставки.Получить();
мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();


