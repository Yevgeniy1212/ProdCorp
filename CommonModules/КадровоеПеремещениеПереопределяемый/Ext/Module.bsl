﻿
Процедура ДополнитьСтруктуруПечатныхФорм(СтруктураПечатныхФорм, ДокументОбъект) Экспорт
	
	// В этой конфигурации структура печатных форм не дополняется
	
КонецПроцедуры

Функция ПечатьДополнительныхФорм(ИмяМакета, Объект) Экспорт
	
	Возврат Новый ТабличныйДокумент;
	
КонецФункции

Процедура ДобавитьДополнительноПоСтроке(ДокументОбъект, СтрокаТабличнойЧасти) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ДобавитьДополнительныеДвижения(ДокументОбъект, Отказ, Заголовок) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура ФормаДокументаПередОткрытиемДополнительно(Форма, ДополнительныеДействия, ДополнительныеОбработчики) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ФормаДокументаРаботникиПриПолученииДанныхДополнительно(ПолеРаботники, ОформленияСтрок) Экспорт
	
	// В этой конфигурации структура печатных форм не дополняется
	
КонецПроцедуры // УстановитьЗначенияКолонкиТабельныйНомерСтрока()

Процедура ДозаполнитьСтрокуДаннымиРаботникаДоНазначения(СтрокаТабличнойЧасти, Выборка) Экспорт
	
	// В этой конфигурации структура печатных форм не дополняется
	
КонецПроцедуры

Процедура ВыполнитьДополнительныеДействия(Форма, Кнопка) Экспорт
	
	// В этой конфигурации структура печатных форм не дополняется
	
КонецПроцедуры

Процедура ОбработатьДополнительноПриИзменении(Форма, Элемент) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура УдалитьДополнительноПоСтроке(Форма, Сотрудник) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

#КонецЕсли

Функция СформироватьЗапросПоДаннымРаботникаДоНазначения(Запрос, Ссылка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(Работники.Период) КАК Период,
	|	ТаблицаСотрудников.Сотрудник КАК Сотрудник,
	|	ТаблицаСотрудников.Сотрудник.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ДатыПоследнихДвиженийРаботников
	|ИЗ
	|	ВТ_ТаблицаСотрудников КАК ТаблицаСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Работники КАК Работники
	|		ПО (Работники.Период <= ТаблицаСотрудников.ДатаНачала)
	|			И ТаблицаСотрудников.Сотрудник.ФизЛицо = Работники.ФизЛицо
	|			И (Работники.Регистратор <> &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСотрудников.Сотрудник,
	|	ТаблицаСотрудников.Сотрудник.ФизЛицо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Период,
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДатыПоследнихДвиженийРаботников.Сотрудник КАК Сотрудник,
	|	ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|	ДанныеПоРаботникуДоНазначения.Подразделение КАК Подразделение,
	|	ДанныеПоРаботникуДоНазначения.Должность КАК Должность
	|ИЗ
	|	ДатыПоследнихДвиженийРаботников КАК ДатыПоследнихДвиженийРаботников
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники КАК ДанныеПоРаботникуДоНазначения
	|		ПО (ДанныеПоРаботникуДоНазначения.Период = ДатыПоследнихДвиженийРаботников.Период)
	|			И ДатыПоследнихДвиженийРаботников.ФизЛицо = ДанныеПоРаботникуДоНазначения.ФизЛицо
	|			И (ДанныеПоРаботникуДоНазначения.Регистратор <> &Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка",	Ссылка);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции

Процедура ДополнитьСтруктуруПроведенияПоРегистрамСведений(СтруктураПроведенияПоРегистрамСведений) Экспорт
	
	СтруктураПроведенияПоРегистрамСведений.Вставить("УчетЗаработкаРаботников");
	
КонецПроцедуры


