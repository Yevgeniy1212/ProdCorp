﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

//Хранит признак ведения учета исполнения заказов подразделений
Перем ВедениеУчетаИсполнениеПлановЗакупок Экспорт; // экспортная переменная

//Хранит признак ведения учета по видам планов закупок
Перем ВедениеУчетаПоВидамПланов Экспорт; // экспортная переменная

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция определяет вид операции формируемого документа
//
// Параметры:
//  Нет.
// Возвращаемое значение:
//  Значение перечисления - вид операции документа Годовой план
//
Функция ОпределитьВидОперации() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Год", ГодовойПлан.Год);
	Запрос.УстановитьПараметр("Организация", ГодовойПлан.Организация);
	Запрос.УстановитьПараметр("ВидОперации", Перечисления.гз_ВидыОперацийДокументовПланированияЗакупок.Планирование);
	Запрос.УстановитьПараметр("ВидПланаЗакупок", ГодовойПлан.ВидПланаЗакупок);
	Запрос.Текст =  "ВЫБРАТЬ
	                |	гз_ГодовойПланЗакупокОбороты.Регистратор
	                |ИЗ
	                |	РегистрНакопления.гз_ГодовойПланЗакупок.Обороты(
	                |			,
	                |			,
	                |			Регистратор,
	                |			Год = &Год
	                |				И Организация = &Организация
	                |				И ВидПланаЗакупок = &ВидПланаЗакупок) КАК гз_ГодовойПланЗакупокОбороты
	                |ГДЕ
	                |	гз_ГодовойПланЗакупокОбороты.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.гз_ВидыОперацийДокументовПланированияЗакупок.Планирование)";
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда 
		Возврат Перечисления.гз_ВидыОперацийДокументовПланированияЗакупок.Корректировка;
	Иначе 
		Возврат Перечисления.гз_ВидыОперацийДокументовПланированияЗакупок.Планирование;
	КонецЕсли;
	
КонецФункции

// Функция формирует запрос для получения таблицы цен номенклатуры
//
// Параметры:
//  МассивНоменклатуры.
//
// Возвращаемое значение:
//  Таблица значений, содержащая колонки Номенклатура и Цена
//  
Функция ПолучитьТаблицуЦенНоменклатуры(МассивНоменклатуры) Экспорт 
	
	Возврат гз_ПроцедурыОперативногоУчетаЗакупок.мПолучитьТаблицуЦенНоменклатуры(МассивНоменклатуры,ГодовойПлан.Организация,ГодовойПлан.Год);
	
КонецФункции //ПолучитьТаблицуЦенНоменклатуры()

// Функция формирует таблицу планов закупок подразделений
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Таблица значений, содержащая планы закупок подразделений
//  
Функция СформироватьТаблицуПлановПодразделений() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Год", ГодовойПлан.Год);
	Запрос.УстановитьПараметр("Организация", ГодовойПлан.Организация);
	Запрос.УстановитьПараметр("СостояниеОтменена", Перечисления.гз_СостояниеДокумента.Отменена);
	Запрос.Текст = "ВЫБРАТЬ
				   |	гз_ПланЗакупокПодразделения.Ссылка,
				   |	гз_ПланЗакупокПодразделения.ПометкаУдаления,
				   |	гз_ПланЗакупокПодразделения.Номер,
				   |	гз_ПланЗакупокПодразделения.Дата,
				   |	гз_ПланЗакупокПодразделения.Проведен,
				   |	гз_ПланЗакупокПодразделения.Автор,
				   |	гз_ПланЗакупокПодразделения.Год,
				   |	гз_ПланЗакупокПодразделения.Комментарий,
				   |	гз_ПланЗакупокПодразделения.Организация,
				   |	гз_ПланЗакупокПодразделения.Ответственный,
				   |	гз_ПланЗакупокПодразделения.ПодразделениеОрганизации,
				   |	гз_ПланЗакупокПодразделения.РучнаяКорректировка,
				   |	гз_ПланЗакупокПодразделения.Состояние,
				   |	гз_ПланЗакупокПодразделения.СоставЗаявкиТовары.(
				   |		Ссылка,
				   |		НомерСтроки,
				   |		Количество,
				   |		Номенклатура,
				   |		ПериодПоставки
				   |	),
				   |	гз_ПланЗакупокПодразделения.Представление,
				   |	гз_ПланЗакупокПодразделения.МоментВремени
				   |ИЗ
				   |	Документ.гз_ПланЗакупокПодразделения КАК гз_ПланЗакупокПодразделения
				   |ГДЕ
				   |	гз_ПланЗакупокПодразделения.Год = &Год
				   |	И гз_ПланЗакупокПодразделения.Организация = &Организация
				   |	И гз_ПланЗакупокПодразделения.Состояние <> &СостояниеОтменена
				   |	И (НЕ гз_ПланЗакупокПодразделения.УчтенаВГодовомПлане)";
				   
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции //СформироватьТаблицуПлановПодразделений()

Процедура ПолучитьСоставГодовогоПлана() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Год",ГодовойПлан.Год);
	Запрос.УстановитьПараметр("Организация",ГодовойПлан.Организация);
	Запрос.УстановитьПараметр("ВидыПлановЗакупок",ВидыПлановЗакупок.ВыгрузитьКолонку("ВидПланаЗакупок"));
	Если ГодовойПлан.ВидОперации = Перечисления.гз_ВидыОперацийДокументовПланированияЗакупок.Планирование Тогда 
		Запрос.Текст = "ВЫБРАТЬ
		               |	гз_ГодовойПланЗакупокОбороты.МестоПоставки,
		               |	гз_ГодовойПланЗакупокОбороты.ВидНоменклатуры,
		               |	гз_ГодовойПланЗакупокОбороты.Номенклатура,
		               |	гз_ГодовойПланЗакупокОбороты.СпособЗакупки,
		               |	гз_ГодовойПланЗакупокОбороты.ПериодПоставки,
		               |	гз_ГодовойПланЗакупокОбороты.КоличествоОборот КАК Количество,
		               |	гз_ГодовойПланЗакупокОбороты.СуммаОборот КАК Сумма,
		               |	гз_ГодовойПланЗакупокОбороты.ПериодПоставки КАК ДатаНачалаПоставки,
		               |	КОНЕЦПЕРИОДА(гз_ГодовойПланЗакупокОбороты.ПериодПоставки, МЕСЯЦ) КАК ДатаОкончанияПоставки,
		               |	ЗНАЧЕНИЕ(перечисление.гз_видыкорректировокГодовогоПлана.Добавление) КАК ВидКорректировки,
		               |	ВЫБОР
		               |		КОГДА гз_ГодовойПланЗакупокОбороты.КоличествоОборот = 0
		               |			ТОГДА 0
		               |		ИНАЧЕ гз_ГодовойПланЗакупокОбороты.СуммаОборот / гз_ГодовойПланЗакупокОбороты.КоличествоОборот
		               |	КОНЕЦ КАК Цена
		               |ИЗ
		               |	РегистрНакопления.гз_ГодовойПланЗакупок.Обороты(
		               |			,
		               |			,
		               |			,
		               |			Год = &Год
		               |				И Организация = &Организация
		               |				И ВидПланаЗакупок В (&ВидыПлановЗакупок)) КАК гз_ГодовойПланЗакупокОбороты";
		ГодовойПлан.СоставЗаявкиТовары.Загрузить(Запрос.Выполнить().Выгрузить());
		Если СведениеПЗП Тогда 
			Запрос.Текст = "ВЫБРАТЬ
			               |	гз_ПланыЗакупокОбороты.Подразделение КАК ПодразделениеОрганизации,
			               |	гз_ПланыЗакупокОбороты.МестоПоставки,
			               |	гз_ПланыЗакупокОбороты.Номенклатура,
			               |	гз_ПланыЗакупокОбороты.ПериодПоставки,
			               |	гз_ПланыЗакупокОбороты.КоличествоОборот КАК Количество
			               |ИЗ
			               |	РегистрНакопления.гз_ПланыЗакупок.Обороты(
			               |			,
			               |			,
			               |			,
			               |			Год = &Год
			               |				И Организация = &Организация
			               |				И ВидПланаЗакупок В (&ВидыПлановЗакупок)) КАК гз_ПланыЗакупокОбороты";
			ГодовойПлан.КорректировкаПлановЗакупок.Загрузить(Запрос.Выполнить().Выгрузить());
		КонецЕсли;
	ИначеЕсли ГодовойПлан.ВидОперации = Перечисления.гз_ВидыОперацийДокументовПланированияЗакупок.Корректировка Тогда 
		Запрос.Текст = "ВЫБРАТЬ
		               |	МАКСИМУМ(гз_ГодовойПланЗакупокОбороты.Период) КАК Период
		               |ИЗ
		               |	РегистрНакопления.гз_ГодовойПланЗакупок.Обороты(
		               |			,
		               |			,
		               |			Регистратор,
		               |			Год = &Год
		               |				И Организация = &Организация
		               |				И ВидПланаЗакупок  = &ВидПланаЗакупок) КАК гз_ГодовойПланЗакупокОбороты";
		Запрос.УстановитьПараметр("ВидПланаЗакупок",ГодовойПлан.ВидПланаЗакупок);
		Выборка = Запрос.Выполнить().Выбрать();
			
		Если Выборка.Следующий() Тогда 
			Период = Выборка.Период;
		КонецЕсли;
				
		Запрос.Текст = "ВЫБРАТЬ
		               |	гз_ГодовойПланЗакупокОбороты.МестоПоставки,
		               |	гз_ГодовойПланЗакупокОбороты.ВидНоменклатуры,
		               |	гз_ГодовойПланЗакупокОбороты.Номенклатура,
		               |	гз_ГодовойПланЗакупокОбороты.СпособЗакупки,
		               |	гз_ГодовойПланЗакупокОбороты.ПериодПоставки,
		               |	гз_ГодовойПланЗакупокОбороты.КоличествоОборот КАК Количество,
		               |	гз_ГодовойПланЗакупокОбороты.СуммаОборот КАК Сумма,
		               |	гз_ГодовойПланЗакупокОбороты.ПериодПоставки КАК ДатаНачалаПоставки,
		               |	КОНЕЦПЕРИОДА(гз_ГодовойПланЗакупокОбороты.ПериодПоставки, МЕСЯЦ) КАК ДатаОкончанияПоставки,
		               |	ЗНАЧЕНИЕ(перечисление.гз_видыкорректировокГодовогоПлана.Добавление) КАК ВидКорректировки,
		               |	ВЫБОР
		               |		КОГДА гз_ГодовойПланЗакупокОбороты.КоличествоОборот = 0
		               |			ТОГДА 0
		               |		ИНАЧЕ гз_ГодовойПланЗакупокОбороты.СуммаОборот / гз_ГодовойПланЗакупокОбороты.КоличествоОборот
		               |	КОНЕЦ КАК Цена
		               |ИЗ
		               |	РегистрНакопления.гз_ГодовойПланЗакупок.Обороты(
		               |			&Период,
		               |			,
		               |			,
		               |			Год = &Год
		               |				И Организация = &Организация
		               |				И ВидПланаЗакупок В (&ВидыПлановЗакупок)) КАК гз_ГодовойПланЗакупокОбороты";

		Запрос.УстановитьПараметр("Период",Период);
		ГодовойПлан.СоставЗаявкиТовары.Загрузить(Запрос.Выполнить().Выгрузить());
		
		Если СведениеПЗП Тогда 
		
			Запрос.Текст = "ВЫБРАТЬ
			               |	гз_ПланыЗакупокОбороты.МестоПоставки,
			               |	гз_ПланыЗакупокОбороты.Номенклатура,
			               |	гз_ПланыЗакупокОбороты.ПериодПоставки,
			               |	гз_ПланыЗакупокОбороты.КоличествоОборот КАК Количество,
			               |	гз_ПланыЗакупокОбороты.Подразделение КАК ПодразделениеОрганизации
			               |ИЗ
			               |	РегистрНакопления.гз_ПланыЗакупок.Обороты(&Период, , ,Год = &Год
			               |				И Организация = &Организация
			               |				И ВидПланаЗакупок В (&ВидыПлановЗакупок)) КАК гз_ПланыЗакупокОбороты";
			ГодовойПлан.КорректировкаПлановЗакупок.Загрузить(Запрос.Выполнить().Выгрузить());
		КонецЕсли;
		
	КонецЕсли;
		
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ВедениеУчетаПоВидамПланов = Константы.гз_ВестиУчетПоВидамПлановЗакупок.Получить();
ВедениеУчетаИсполнениеПлановЗакупок = Константы.гз_ВестиУчетИсполненияЗаказовПодразделений.Получить();







