﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)

	Если НЕ ОбменДанными.Загрузка
	   И НЕ ЭтоНовый() 
	   И НазначениеКатегории <> Ссылка.НазначениеКатегории 
	   И ЭтотОбъект.СуществуютСсылки() Тогда

		Сообщить("Существуют объекты, которым назначена категория """ + Наименование + """.
		         |Назначение категории не может быть изменено.", 
		         СтатусСообщения.Внимание);

		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, назначена ли категория каким-либо объектам.
// Если назначена - менять назначение категории нельзя.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если назначена, Ложь - если нет.
//
Функция СуществуютСсылки() Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	РегистрСведений.КатегорииОбъектов.Категория КАК Категория
	|ИЗ
	|	РегистрСведений.КатегорииОбъектов
	|
	|ГДЕ
	|	РегистрСведений.КатегорииОбъектов.Категория = &Категория
	|";

	Запрос.УстановитьПараметр("Категория", Ссылка);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции
