﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
//

Перем мИмяПланаСчетов;

#Если Клиент Тогда
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает основную форму отчета, связанную с данным экземпляром отчета
//
// Параметры
//	Нет
//
Функция ПолучитьОсновнуюФорму() Экспорт
	
	ОснФорма = ПолучитьФорму();
	ОснФорма.ОбщийОтчет = ОбщийОтчет;
	ОснФорма.ЭтотОтчет = ЭтотОбъект;
	Возврат ОснФорма;
	
КонецФункции // ПолучитьОсновнуюФорму()

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительОтчета() Экспорт

	Возврат ОбщийОтчет.ПолучитьПостроительОтчета();

КонецФункции // ПолучитьПостроительОтчета()

// Настраивает отчет по переданной структуре параметров
//
// Параметры:
//	Нет.
//
Процедура Настроить(Параметры) Экспорт

	ОбщийОтчет.Настроить(Параметры, ЭтотОбъект);

КонецПроцедуры

// Выполняет настройку отчета по умолчанию для заданного вида отчета
//
// Параметры: 
// 
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ОбщийОтчет.ИмяРегистра = "-";
	ОбщийОтчет.мНазваниеОтчета = "Справка-расчет ""Резервы по вознаграждениям работникам""";
	
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	// структура представлений полей
	СтруктураПредставлениеПолей = Новый Структура();
	
	РезервыТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТиповойОбороты.Ссылка.Организация КАК Организация,
	|	ТиповойОбороты.СчетКт КАК Счет,
	|	ВЫБОР
	|		КОГДА ТиповойОбороты.СчетКт ССЫЛКА ПланСчетов.Типовой
	|			ТОГДА ВЫРАЗИТЬ(ТиповойОбороты.СубконтоКт1 КАК Справочник.Резервы)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Резервы.ПустаяСсылка)
	|	КОНЕЦ КАК Резерв,
	|	ВЫБОР
	|		КОГДА ТиповойОбороты.СчетКт ССЫЛКА ПланСчетов.Типовой
	|			ТОГДА ВЫРАЗИТЬ(ТиповойОбороты.СубконтоКт2 КАК Справочник.ФизическиеЛица) 
	|		ИНАЧЕ ВЫРАЗИТЬ(ТиповойОбороты.СубконтоКт1 КАК Справочник.ФизическиеЛица)
	|	КОНЕЦ КАК ФизЛицо,
	|	ТиповойОбороты.Ссылка КАК Регистратор,
	|	NULL КАК ВидРасчета,
	|	СУММА(ВЫБОР
	|			КОГДА ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныйНалог)
	|					ИЛИ ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныеОтчисления)
	|					ИЛИ ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПрофессиональныеПенсионныеВзносы)
	|					ИЛИ ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОтчисленияОСМС)
	|					ИЛИ ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПенсионныеВзносыРаботодателя)
	|				ТОГДА 0
	|			КОГДА ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныйНалог)
	|					ИЛИ ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныеОтчисления)
	|					ИЛИ ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПрофессиональныеПенсионныеВзносы)
	|					ИЛИ ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОтчисленияОСМС)
	|					ИЛИ ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПенсионныеВзносыРаботодателя)
	|				ТОГДА 0
	|			КОГДА ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныйНалог)
	|					ИЛИ ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныеОтчисления)
	|					ИЛИ ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПрофессиональныеПенсионныеВзносы)
	|					ИЛИ ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОтчисленияОСМС)
	|					ИЛИ ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПенсионныеВзносыРаботодателя)
	|				ТОГДА 0
	|			ИНАЧЕ ТиповойОбороты.Сумма
	|	  	КОНЕЦ) КАК СуммаРезервПоВознаграждениям,
	|	СУММА(ВЫБОР
	|			КОГДА ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныйНалог)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныйНалог)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныйНалог)
	|				ТОГДА ТиповойОбороты.Сумма
	|			ИНАЧЕ 0
	|	  	КОНЕЦ) КАК СуммаРезервСН,
	|	СУММА(ВЫБОР
	|			КОГДА ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныеОтчисления)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныеОтчисления)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СоциальныеОтчисления)
	|				ТОГДА ТиповойОбороты.Сумма
	|			ИНАЧЕ 0
	|	  	КОНЕЦ) КАК СуммаРезервСО,
	|	СУММА(ВЫБОР
	|			КОГДА ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПрофессиональныеПенсионныеВзносы)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПрофессиональныеПенсионныеВзносы)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПрофессиональныеПенсионныеВзносы)
	|				ТОГДА ТиповойОбороты.Сумма
	|			ИНАЧЕ 0
	|	  	КОНЕЦ) КАК СуммаРезервОППВ,
	|	СУММА(ВЫБОР
	|			КОГДА ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПенсионныеВзносыРаботодателя)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПенсионныеВзносыРаботодателя)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОбязательныеПенсионныеВзносыРаботодателя)
	|				ТОГДА ТиповойОбороты.Сумма
	|			ИНАЧЕ 0
	|	  	КОНЕЦ) КАК СуммаРезервОПВР,
	|	СУММА(ВЫБОР
	|			КОГДА ТиповойОбороты.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОтчисленияОСМС)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОтчисленияОСМС)
	|				ТОГДА ТиповойОбороты.Сумма
	|			КОГДА ТиповойОбороты.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ОтчисленияОСМС)
	|				ТОГДА ТиповойОбороты.Сумма
	|			ИНАЧЕ 0
	|	  	КОНЕЦ) КАК СуммаРезервООСМС,
	|	СУММА(ТиповойОбороты.Сумма) КАК СуммаРезерв,
	|	0 КАК РасчетнаяБаза
	|ИЗ
	|	Документ.ОтражениеЗарплатыВРеглУчете.ОтражениеВУчете КАК ТиповойОбороты
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|								РазмерыОтчисленийВРезервы.СчетУчета
	|							ИЗ
	|								РегистрСведений.РазмерыОтчисленийВРезервы КАК РазмерыОтчисленийВРезервы) КАК РазмерыОтчисленийВРезервы
	|		ПО ТиповойОбороты.СчетКт = РазмерыОтчисленийВРезервы.СчетУчета
	|	
	|ГДЕ
	|	ТиповойОбороты.Ссылка.Проведен
	|	И ТиповойОбороты.Ссылка.ПериодРегистрации МЕЖДУ &ДатаНач И &ДатаКон
	|	И ТиповойОбороты.Сумма <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТиповойОбороты.Ссылка.Организация,
	|	ТиповойОбороты.СчетКт,
	|	ТиповойОбороты.СубконтоКт1,
	|	ТиповойОбороты.СубконтоКт2,
	|	ТиповойОбороты.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РазмерыОтчисленийВРезервы.Организация,
	|	РазмерыОтчисленийВРезервы.СчетУчета КАК Счет,
	|	РазмерыОтчисленийВРезервы.Резерв,
	|	ОтражениеВУчете.ФизЛицо,
	|	ОтражениеВУчете.Регистратор,
	|	ОтражениеВУчете.ВидРасчета,
	|	0 КАК СуммаРезервПоВознаграждениям,
	|	0 КАК СуммаРезервСН,
	|	0 КАК СуммаРезервСО,
	|	0 КАК СуммаРезервОППВ,
	|	0 КАК СуммаРезервОПВР,
	|	0 КАК СуммаРезервООСМС,
	|	0 КАК СуммаРезерв,
	|	СУММА(ОтражениеВУчете.Сумма) КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		РазмерыОтчисленийВРезервы.Организация,
	|		РазмерыОтчисленийВРезервы.Резерв,
	|		РазмерыОтчисленийВРезервы.СчетУчета
	|	ИЗ
	|		РегистрСведений.РазмерыОтчисленийВРезервы КАК РазмерыОтчисленийВРезервы
	|	ГДЕ
	|		РазмерыОтчисленийВРезервы.Размер <> 0) КАК РазмерыОтчисленийВРезервы
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Резервы.БазовыеВидыРасчета КАК БазовыеВидыРасчета
	|		ПО РазмерыОтчисленийВРезервы.Резерв = БазовыеВидыРасчета.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|								БУОсновныеНачисления.ФизЛицо,
	|								БУОсновныеНачисления.ОбособленноеПодразделение КАК Организация,
	|								БУОсновныеНачисления.ВидРасчета,
	|								БУОсновныеНачисления.Регистратор,
	|								СУММА(БУОсновныеНачисления.Результат) КАК Сумма
	|							ИЗ
	|								РегистрРасчета.БУОсновныеНачисления КАК БУОсновныеНачисления
	|							ГДЕ
	|								БУОсновныеНачисления.ПериодРегистрации МЕЖДУ &ДатаНач И &ДатаКон
	|                           СГРУППИРОВАТЬ ПО
	|								БУОсновныеНачисления.ФизЛицо,
	|								БУОсновныеНачисления.ОбособленноеПодразделение,
	|								БУОсновныеНачисления.ВидРасчета,
	|								БУОсновныеНачисления.Регистратор
	|							
	|							ОБЪЕДИНИТЬ ВСЕ
	|
	|							ВЫБРАТЬ
	|								БУДополнительныеНачисления.ФизЛицо,
	|								БУДополнительныеНачисления.ОбособленноеПодразделение КАК Организация,
	|								БУДополнительныеНачисления.ВидРасчета,
	|								БУДополнительныеНачисления.Регистратор,
	|								СУММА(БУДополнительныеНачисления.Результат) КАК Сумма
	|							ИЗ
	|								РегистрРасчета.БУДополнительныеНачисления КАК БУДополнительныеНачисления
	|							ГДЕ
	|								БУДополнительныеНачисления.ПериодРегистрации МЕЖДУ &ДатаНач И &ДатаКон
	|                           СГРУППИРОВАТЬ ПО
	|								БУДополнительныеНачисления.ФизЛицо,
	|								БУДополнительныеНачисления.ОбособленноеПодразделение,
	|								БУДополнительныеНачисления.ВидРасчета,
	|								БУДополнительныеНачисления.Регистратор) КАК ОтражениеВУчете
	|		ПО РазмерыОтчисленийВРезервы.Организация = ОтражениеВУчете.Организация
	|			И БазовыеВидыРасчета.ВидРасчета = ОтражениеВУчете.ВидРасчета
	|
	|СГРУППИРОВАТЬ ПО
	|	РазмерыОтчисленийВРезервы.Организация,
	|	РазмерыОтчисленийВРезервы.СчетУчета,
	|	РазмерыОтчисленийВРезервы.Резерв,
	|	ОтражениеВУчете.ФизЛицо,
	|	ОтражениеВУчете.Регистратор,
	|	ОтражениеВУчете.ВидРасчета
	|";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Данные.СуммаРезервПоВознаграждениям КАК СуммаРезервПоВознаграждениям,
	|	Данные.СуммаРезервСН КАК СуммаРезервСН,
	|	Данные.СуммаРезервСО КАК СуммаРезервСО,
	|	Данные.СуммаРезервОППВ КАК СуммаРезервОППВ,
	|	Данные.СуммаРезервОПВР КАК СуммаРезервОПВР,
	|	Данные.СуммаРезервООСМС КАК СуммаРезервООСМС,
	|	Данные.СуммаРезерв КАК СуммаРезерв,
	|	Данные.РасчетнаяБаза КАК РасчетнаяБаза,
	|	РазмерыОтчисленийВРезервы.Размер КАК Размер,
	|	РазмерыОтчисленийВРезервы.РазмерСоциальногоНалога КАК РазмерСоциальногоНалога,
	|	РазмерыОтчисленийВРезервы.РазмерСоциальныхОтчислений КАК РазмерСоциальныхОтчислений,
	|	РазмерыОтчисленийВРезервы.РазмерПрофессиональныхПенсионныхВзносов КАК РазмерПрофессиональныхПенсионныхВзносов,
	|	РазмерыОтчисленийВРезервы.РазмерПенсионныхВзносовРаботодателя КАК РазмерПенсионныхВзносовРаботодателя,
	|	РазмерыОтчисленийВРезервы.РазмерОтчисленийОСМС КАК РазмерОтчисленийОСМС
	|
	|{ВЫБРАТЬ
	|	Данные.Физлицо.* КАК Физлицо,
	|	Данные.Организация.* КАК Организация";
	Если мИмяПланаСчетов = "Типовой" Тогда
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Резерв.* КАК Резерв";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Счет КАК Счет,
	|	Данные.Регистратор КАК Регистратор,
	|	Данные.ВидРасчета.* КАК ВидРасчета
	|	//СВОЙСТВА
	|}
	|
	|ИЗ
	|	(" + РезервыТекстЗапроса + ") КАК Данные
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмерыОтчисленийВРезервы.СрезПоследних(&ДатаКон) КАК РазмерыОтчисленийВРезервы
	|		ПО Данные.Организация = РазмерыОтчисленийВРезервы.Организация
	|			И Данные.Резерв = РазмерыОтчисленийВРезервы.Резерв
	|
	|	{//СОЕДИНЕНИЯ}
	|
	|{ГДЕ
	|	Данные.Физлицо.* КАК Физлицо,
	|	Данные.Организация.* КАК Организация";
	Если мИмяПланаСчетов = "Типовой" Тогда
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Резерв.* КАК Резерв";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Счет КАК Счет,
	|	Данные.Регистратор КАК Регистратор,
	|	Данные.ВидРасчета.* КАК ВидРасчета
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|}
	|{УПОРЯДОЧИТЬ ПО
	|	Данные.Физлицо.* КАК Физлицо,
	|	Данные.Организация.* КАК Организация";
	Если мИмяПланаСчетов = "Типовой" Тогда
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Резерв.* КАК Резерв";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Счет КАК Счет,
	|	Данные.ВидРасчета.* КАК ВидРасчета
	|	//СВОЙСТВА
	|}             		
	|
	|ИТОГИ 
	|	СУММА(СуммаРезервПоВознаграждениям), 
	|	СУММА(СуммаРезервСН), 
	|	СУММА(СуммаРезервСО), 
	|	СУММА(СуммаРезервОППВ), 
	|	СУММА(СуммаРезервОПВР),
	|	СУММА(СуммаРезервООСМС),
	|	СУММА(СуммаРезерв), 
	|	СУММА(РасчетнаяБаза),
	|	МАКСИМУМ(Размер), 
	|	МАКСИМУМ(РазмерСоциальногоНалога), 
	|	МАКСИМУМ(РазмерСоциальныхОтчислений),
	|	МАКСИМУМ(РазмерПрофессиональныхПенсионныхВзносов),
	|	МАКСИМУМ(РазмерПенсионныхВзносовРаботодателя),
	|	МАКСИМУМ(РазмерОтчисленийОСМС)
	|
	|ПО ОБЩИЕ
	|
	|{ИТОГИ ПО
	|	Данные.Физлицо.* КАК Физлицо,
	|	Данные.Организация.* КАК Организация";
	Если мИмяПланаСчетов = "Типовой" Тогда
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Резерв.* КАК Резерв";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + ",
	|	Данные.Счет КАК Счет,
	|	Данные.ВидРасчета.* КАК ВидРасчета,
	|	Данные.Регистратор
	|	//СВОЙСТВА
	|}
	|";
							  
	//представление полей запроса
	СтруктураПредставлениеПолей.Вставить("ФизЛицо", "Сотрудник");
	СтруктураПредставлениеПолей.Вставить("ВидРасчета", "Вид расчета");
	
	Если ОбщийОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Свойства и категории, назначаемые пользователем:
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта
		
		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "Данные.ФизЛицо";
		НоваяСтрока.Представление = "Сотрудник";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ФизическиеЛица;
		
		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "Данные.Организация";
		НоваяСтрока.Представление = "Организация";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Организации;
		
		
		// Добавим строки запроса, необходимые для использования свойств и категорий
		ТекстПоляКатегорий = "";
		ТекстПоляСвойств = "";
		
		УправлениеОтчетами.ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, 
		ОбщийОтчет.мСоответствиеНазначений, ПостроительОтчета.Параметры
		,, ТекстПоляКатегорий, ТекстПоляСвойств,,,,,,ОбщийОтчет.мСтруктураДляОтбораПоКатегориям);		
		
	КонецЕсли;	
	
	ПостроительОтчета.Текст = ТекстЗапроса;
	
	Если ОбщийОтчет.ИспользоватьСвойстваИКатегории Тогда	
		УправлениеОтчетами.УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, ОбщийОтчет.мСоответствиеНазначений, СтруктураПредставлениеПолей);
	КонецЕсли;                					  

	// группировки по умолчанию
	ПостроительОтчета.ИзмеренияСтроки.Добавить("Организация");
	ПостроительОтчета.ИзмеренияСтроки.Добавить("Счет");
	Если мИмяПланаСчетов = "Типовой" Тогда
		ПостроительОтчета.ИзмеренияСтроки.Добавить("Резерв");
	КонецЕсли;
	ПостроительОтчета.ИзмеренияСтроки.Добавить("ФизЛицо");
	
	// сортировки по умолчанию
	ПостроительОтчета.Порядок.Добавить("Организация.Наименование");
	Если мИмяПланаСчетов = "Типовой" Тогда
	ПостроительОтчета.Порядок.Добавить("Резерв.Наименование");
	КонецЕсли;
	
	// список показателей и форматы их представления
	ОбщийОтчет.ЗаполнитьПоказатели("Размер", "Процент отчислений в резерв по вознаграждениям", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РазмерСоциальногоНалога", "Процент отчислений в резерв по социальному налогу", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РазмерСоциальныхОтчислений", "Процент отчислений в резерв по социальным отчислениям", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РазмерПрофессиональныхПенсионныхВзносов", "Процент отчислений в резерв по профессиональным пенсионным взносам", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РазмерПенсионныхВзносовРаботодателя", "Процент отчислений в резерв по пенсионным взносам работодателя", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РазмерОтчисленийОСМС", "Процент отчислений в резерв по отчислениям ОСМС", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РасчетнаяБаза", "Расчетная база", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаРезервПоВознаграждениям", "Сумма резерва по вознаграждениям", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаРезервСН", "Сумма резерва по социальному налогу", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаРезервСО", "Сумма резерва по социальным отчислениям", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаРезервОППВ", "Сумма резерва по профессиональным пенсионным взносам", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаРезервОПВР", "Сумма резерва по пенсионным взносам работодателя", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаРезервООСМС", "Сумма резерва по отчислениям ОСМС", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаРезерв", "Общая сумма резерва", Истина, "ЧЦ=15; ЧДЦ=2");
	
	// отборы по умолчанию
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Организация");
	МассивОтбора.Добавить("ФизЛицо");
	Если мИмяПланаСчетов = "Типовой" Тогда
	МассивОтбора.Добавить("Резерв");
	КонецЕсли;
	МассивОтбора.Добавить("Счет");
	УправлениеОтчетами.ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	// поля по умолчанию
	ПостроительОтчета.ВыбранныеПоля.Очистить();

	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	
	УправлениеОтчетами.УпорядочитьПоляПостроителяОтчета(ПостроительОтчета);
	
	// настройки отчета
	ОбщийОтчет.РаскрашиватьИзмерения = Истина;
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Истина;
	ОбщийОтчет.ВыводитьПоказателиВСтроку = Истина;
	ОбщийОтчет.мРежимВводаПериода = 0; // произвольный период
	
КонецПроцедуры

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//	ЕстьОшибки - флаг того, что при формировании произошли ошибки
//
//Процедура СформироватьОтчет(ДокументРезультат, ЕстьОшибки = Ложь) Экспорт
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт

	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПроцедуры

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

//++КУФИБ
//ПрограммаБухучета 	= Константы.ПрограммаБухучета.Получить();
мИмяПланаСчетов 	= "Типовой";//ПроцедурыБухгалтерскогоУчета.ПолучитьИмяПланаСчетовПоПрограммеБухучета(ПрограммаБухучета);
//--КУФИБ
