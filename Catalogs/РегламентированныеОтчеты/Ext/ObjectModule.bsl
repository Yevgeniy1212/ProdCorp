﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция определяет тип указанного в реквизите ИсточникОтчета 
// элемента справочника регламентированного отчета (обработки).
//
// Параметры
//  ФайлВнешнегоОтчета - строка - имя файла, указанное в реквизите элемента;
//  Расширение         - строка - расширение файла;
//
// Возвращаемое значение:
// - число, принимает значения:
//      - 1 - в реквизите указано наименование
//            встроенного в конфигурацию отчета;
//      - 2 - в реквизите указано полное наименование файла.
//      - 0 - в иных случаях.
//
Функция ОпределитьТипОтчета(ФайлВнешнегоОтчета, Расширение = "", НеВыводитьСообщения = Ложь) Экспорт

	ТипОтчета = 0;

	Если Не ПустаяСтрока(ФайлВнешнегоОтчета) Тогда

		ФайлВнешОтчета = Новый Файл(ФайлВнешнегоОтчета);
		Если ФайлВнешОтчета.Существует() Тогда
			ТипОтчета  = 1;
			Расширение = ФайлВнешОтчета.Расширение;
		ИначеЕсли Метаданные.Отчеты.Найти(ФайлВнешнегоОтчета) <> Неопределено Тогда
			ТипОтчета  = 2;
		ИначеЕсли Метаданные.Документы.Найти(ФайлВнешнегоОтчета) <> Неопределено Тогда
			ТипОтчета  = 3;
		КонецЕсли;

		Если ТипОтчета = 0 Тогда
			Если НЕ НеВыводитьСообщения Тогда
				Сообщить("Не найден отчет " + ФайлВнешнегоОтчета, СтатусСообщения.Внимание);
			КонецЕсли;
		КонецЕсли;

	Иначе

		Если НЕ НеВыводитьСообщения Тогда
			Сообщить("Не выбран файл внешнего отчета!", СтатусСообщения.Внимание);
		КонецЕсли;

	КонецЕсли;

	Возврат ТипОтчета;

КонецФункции // ОпределитьТипОтчета()

// Формирует код нового элемента (группы) справочника
// в соответствии с иерархической структурой последнего.
//
Процедура ГенерироватьНовыйКод() Экспорт

	// Код элемента имеет представление:
	//  ГГГЭЭЭ, где
	//    ГГГ - порядковый номер группы или элементов верхнего уровня;
	//    ЭЭЭ - порядковый номер элемента внутри группы.
	//
	// Порядковые номера определяются с лидирующими нулями.

	Если ЭтоГруппа Тогда
		// для группы справочника
		ТекКод      = Код;
		КодГруппы   = Число(Лев(ТекКод, 3)) + 1;
		Код         = Формат(КодГруппы, "ЧЦ=3; ЧВН=;") + "000";

	ИначеЕсли Уровень() = 0 Тогда
		// для элемента справочника корневого уровня
		ТекКод      = Код;
		КодУровня   = Число(Лев(ТекКод, 3)) + 1;

		Код         = Формат(КодУровня, "ЧЦ=3; ЧВН=;") + "000";

	Иначе
		// для элемента справочника второго уровня
		ТекКод      = Код;
		КодГруппы   = Лев(Родитель.Код, 3);
		КодЭлемента = Число(Прав(ТекКод, 3));

		Код         = КодГруппы + Формат(КодЭлемента, "ЧЦ=3; ЧВН=;");

	КонецЕсли;

КонецПроцедуры // ГенерироватьНовыйКод()

// Процедура генерирует код перемещаемого элемента (группы) справочника,
// а также код расположенного рядом элемента при интерактивном перемещении
// элемента в форме списка справочника.
// Записывает переставляемые элементы с измененными кодами.
// В случае сдвига группы элементов также изменяет коды вложенных в группу
// элементов.
//
// Параметры
//  Направление  – число – напрвление сдвига элемента,
//                 принимает значения:
//                      1 - при сдвиге вниз;
//                     -1 - при сдвиге вверх.
//
Процедура ИзменитьКод(Направление) Экспорт

	ТекущийКод    = Код;

	СписокКодов   = Новый СписокЗначений;

	РегламОтчеты  = Справочники.РегламентированныеОтчеты;
	ВыборкаОтчеты = РегламОтчеты.Выбрать(Родитель, Владелец, , "Код Убыв");

	Пока ВыборкаОтчеты.Следующий() Цикл
		СписокКодов.Добавить(ВыборкаОтчеты.Код);
	КонецЦикла;

	Если СписокКодов.Количество() < 2  Тогда
		// На данном уровне имеется только один элемент или группа справочника.
		// Игнорируем действие пользователя.

		Возврат;
	КонецЕсли; 

	// Открываем транзакцию
	НачатьТранзакцию();

	ПорядковыйНомер = СписокКодов.Индекс(СписокКодов.НайтиПоЗначению(ТекущийКод));

	Если (ПорядковыйНомер = 0) И (Направление < 0) Тогда

		// Попытка перемещения первого по порядку элемента вверх.
		ИндексЭлементаЗамены = СписокКодов.Количество() - 1;
	
	ИначеЕсли (ПорядковыйНомер = СписокКодов.Количество() - 1) И (Направление > 0) Тогда

		// Попытка перемещения последнего по порядку элемента вниз.
		ИндексЭлементаЗамены = 0;

	Иначе

		// в иных случаях
		ИндексЭлементаЗамены = ПорядковыйНомер + Направление;

	КонецЕсли;

	КодЭлементаЗамены     = СписокКодов.Получить(ИндексЭлементаЗамены).Значение;

	ЭлементЗаменыСсылка   = РегламОтчеты.НайтиПоКоду(КодЭлементаЗамены,,Родитель, Владелец);
	Если ЭлементЗаменыСсылка <> РегламОтчеты.ПустаяСсылка() Тогда
		ЭлементЗамены     = ЭлементЗаменыСсылка.ПолучитьОбъект();
		ТекущийКод        = ЭлементЗамены.Код;
		ЭлементЗамены.Код = Код;

		Попытка
			// записываем соседний элемент с новым кодом
			ЭлементЗамены.Записать();

		Исключение
			
			ОбщегоНазначения.СообщитьОбОшибке("Не удалось записать элемент справочника:
			|" + ОписаниеОшибки());
			
			Возврат;
			
		КонецПопытки;

		Если ЭлементЗамены.ЭтоГруппа Тогда

			// Переписываем коды вложенных в группу элементов.
			ВыборкаОтчеты = РегламОтчеты.Выбрать(ЭлементЗаменыСсылка, ЭлементЗамены.Владелец, , "Код Убыв");

			Пока ВыборкаОтчеты.Следующий() Цикл
				ЭлементЗамены2     = ВыборкаОтчеты.ПолучитьОбъект();
				ЭлементЗамены2.Код = Лев(ЭлементЗамены.Код, 3) + Прав(ЭлементЗамены2.Код, 3);

				Попытка
					// записываем новый код вложенного в группу элемента
					ЭлементЗамены2.Записать();

				Исключение
		
					ОбщегоНазначения.СообщитьОбОшибке("Не удалось записать элемент справочника:
					|" + ОписаниеОшибки());
        
					ОтменитьТранзакцию();
					Возврат;
		

				КонецПопытки;

			КонецЦикла;

		КонецЕсли;
	КонецЕсли;

	// записываем перемещаемый элемент с новым кодом
	Код = ТекущийКод;
	Записать();

	Если ЭтоГруппа Тогда

		// Переписываем коды вложенных в группу элементов.
		ВыборкаОтчеты = РегламОтчеты.Выбрать(ЭтотОбъект.Ссылка, Владелец, , "Код Убыв");

		Пока ВыборкаОтчеты.Следующий() Цикл
			ЭлементЗамены2     = ВыборкаОтчеты.ПолучитьОбъект();
			ЭлементЗамены2.Код = Лев(Код, 3) + Прав(ЭлементЗамены2.Код, 3);

			Попытка
				// записываем новый код вложенного в группу элемента
				ЭлементЗамены2.Записать();

			Исключение
	
				ОбщегоНазначения.СообщитьОбОшибке("Не удалось записать элемент справочника:
				|" + ОписаниеОшибки());
    
				ОтменитьТранзакцию();
				Возврат;
	
			КонецПопытки;

		КонецЦикла;

	КонецЕсли;

	// Завершаем транзакцию
	ЗафиксироватьТранзакцию();

КонецПроцедуры // ИзменитьКод()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА

// Процедура - обработчик события "ПередЗаписью" формы.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() Тогда

		ПрежнийРодитель = Ссылка.Родитель;

		Если ПрежнийРодитель <> Родитель Тогда

			// В случае, когда объект сменил родителя (переместили элемент
			// из одной группы в другую), для обеспечения настроенного порядка
			// следования элементов переопределяем код объекта в соответствии
			// с порядком следования элементов текущего уровня иерархии.
			//
			// Принимаем следующие правила:
			// при перемещении объекта из одной группы в другую
			// размещаем его в конец списка вложенных в группу элементов.
			//
			// В соответствии спинятыми правилами формируем новый код объекта:

			СписокКодов    = Новый СписокЗначений;

			РегламОтчеты   = Справочники.РегламентированныеОтчеты;
			ВыборкаОтчеты  = РегламОтчеты.Выбрать(Родитель, Владелец, , "Код Возр");

			Пока ВыборкаОтчеты.Следующий() Цикл
				СписокКодов.Добавить(ВыборкаОтчеты.Код);
			КонецЦикла;

			Если СписокКодов.Количество() = 0  Тогда
				// На данном уровне не имеется элементов справочника.
				// Объекту присваиваем самый первый код.
				НовыйКодГруппы   = "001";
				НовыйКодЭлемента = "001";
			Иначе
				// Перемещенному объекту присваиваем очередной код согласно порядку следования.
				ПредКод          = СписокКодов.Получить(СписокКодов.Количество() - 1).Значение;
				НовыйКодГруппы   = Формат(Число(Лев( ПредКод, 3)) + 1, "ЧЦ=3; ЧВН=;");
				НовыйКодЭлемента = Формат(Число(Прав(ПредКод, 3)) + 1, "ЧЦ=3; ЧВН=;");
			КонецЕсли;

			Если Уровень() > 0 Тогда
				// В случае, когда объект был перемещен в группу.
				НовыйКодГруппы   = Лев(Родитель.Код, 3);
			Иначе
				// В случае, когда объект был перемещен на верхний
				// уровень иерархии (не имеет родителя).
				НовыйКодЭлемента = "000";
			КонецЕсли;

			// В соответствии с принятыми обозначениями код объекта формируется из порядкового
			// кода группы и порядкового кода элемента внутры группы.
			Код = НовыйКодГруппы + НовыйКодЭлемента;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ПередЗаписью()


