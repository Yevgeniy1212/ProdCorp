﻿// Выполняет назначаемую команду на клиенте, используя только неконтекстные серверные вызов.
//   Возвращает Ложь если для выполнения команды требуется серверный вызов.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма, из которой вызвана команда.
//   ИмяЭлемента - Строка - Имя команды формы, которая была нажата.
//
// Возвращаемое значение:
//   Булево - Способ выполнения.
//       Истина - Команда обработки выполняется неконтекстно.
//       Ложь - Для выполнения требуется контекстный вызов сервера.
//
Функция ВыполнитьНазначаемуюКомандуНаКлиенте(Форма, ИмяЭлемента) Экспорт
	Режим = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_РежимИнтеграцииСУчетнойСистемой");
	Если Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.БухгалтерияДляКазахстана_3_0")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.УправлениеТорговлейДляКазахстана_3")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.Самостоятельный") Тогда 
		
		Возврат Вычислить("ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(Форма, ИмяЭлемента)");
		
	КонецЕсли;
КонецФункции


// Отображает результат выполнения команды.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма, для которой требуется вывод.
//   РезультатВыполнения - Структура - См. СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения()
//
Процедура ПоказатьРезультатВыполненияКоманды(Форма, РезультатВыполнения) Экспорт
	Режим = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_РежимИнтеграцииСУчетнойСистемой");
	
	Если Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.БухгалтерияДляКазахстана_3_0")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.УправлениеТорговлейДляКазахстана_3")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.Самостоятельный") Тогда 
	
		Выполнить("СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(Форма, РезультатВыполнения)");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик динамически подключаемой команды печати.
//
// Команда  - КомандаФормы - подключаемая команда формы, выполняющая обработчик Подключаемый_ВыполнитьКомандуПечати.
//            (альтернативный вызов*) Структура    - строка таблицы КомандыПечати, преобразованная в структуру.
// Источник - ТаблицаФормы, ДанныеФормыСтруктура - источник объектов печати (Форма.Объект, Форма.Элементы.Список).
//            (альтернативный вызов*) Массив - список объектов печати.
//
// *Альтернативный вызов - указанные типы используются в случае, если вызов выполняется не из штатного
//                         обработчика Подключаемый_ВыполнитьКомандуПечати.
//
Процедура ВыполнитьПодключаемуюКомандуПечати(Знач Команда, Знач Форма, Знач Источник) Экспорт
	Режим = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_РежимИнтеграцииСУчетнойСистемой");
	
	Если Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.БухгалтерияДляКазахстана_3_0")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.УправлениеТорговлейДляКазахстана_3")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.КомплексноеУправлениеФинансамиИБюджетированиеДляКазахстана")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.Самостоятельный") Тогда 
	
		Выполнить("УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, Форма, Источник)");
		
	Иначе
		
		Выполнить("общ_УниверсальныеМеханизмыПечатиКлиент.ПечатьПоДополнительнойКнопке(Источник,Команда.Заголовок)");
		
	КонецЕсли;
	
КонецПроцедуры

// Используется для открытия формы группового изменения объектов.
//
// Параметры:
//  Список - ТаблицаФормы - элемент формы списка, содержащий ссылки на изменяемые объекты.
//
Процедура ИзменитьВыделенные(Список) Экспорт
	Режим = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_РежимИнтеграцииСУчетнойСистемой");
	
	Если Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.БухгалтерияДляКазахстана_3_0")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.УправлениеТорговлейДляКазахстана_3")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.Самостоятельный") Тогда 
		
		Выполнить("ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Список)");
		
	КонецЕсли;
	
КонецПроцедуры


//// Продолжение процедуры УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов.
//Процедура ПроверитьПроведенностьДокументовДиалогПроведения(Параметры) Экспорт
//	
//	Выполнить("УправлениеПечатьюСлужебныйКлиент.ПроверитьПроведенностьДокументовДиалогПроведения(Параметры)");
//	
//КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции для обработки действий пользователя в процессе редактирования
// многострочного текста, например комментария в документах.

// Открывает форму редактирования произвольного многострочного текста.
//
// Параметры:
//  ОповещениеОЗакрытии     - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана 
//                            после закрытия формы ввода текста с теми же параметрами, что и для метода
//                            ПоказатьВводСтроки.
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать;
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//
// Пример:
//
//   Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект);
//   ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элемент.ТекстРедактирования);
//
//   &НаКлиенте
//   Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
//      Если ВведенныйТекст = Неопределено Тогда
//		   Возврат;
//   	КонецЕсли;	
//	
//	   Объект.МногострочныйКомментарий = ВведенныйТекст;
//	   Модифицированность = Истина;
//   КонецПроцедуры
//
Процедура ПоказатьФормуРедактированияМногострочногоТекста(Знач ОповещениеОЗакрытии, 
	Знач МногострочныйТекст, Знач Заголовок = Неопределено) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если ВвестиСтроку(МногострочныйТекст, Заголовок, , Истина) Тогда 
			КомментарийЗавершениеВвода(МногострочныйТекст, ОповещениеОЗакрытии.ДополнительныеПараметры);
		КонецЕсли;		
	#Иначе
	Если Заголовок = Неопределено Тогда
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст,,, Истина);
	Иначе
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст, Заголовок,, Истина);
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

// Открывает форму редактирования многострочного комментария.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать.
//  ФормаВладелец 			- УправляемаяФорма - форма, в поле которой выполняется ввод комментария.
//  ИмяРеквизита            - Строка - имя реквизита формы, в который будет помещен введенный пользователем
//                                     комментарий.
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//                                     По умолчанию: "Комментарий".
//
// Пример использования:
//
//	 ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
//
Процедура ПоказатьФормуРедактированияКомментария(Знач МногострочныйТекст, Знач ФормаВладелец, Знач ИмяРеквизита, Знач Заголовок = Неопределено) Экспорт
	
	Режим = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_РежимИнтеграцииСУчетнойСистемой");
	
	Если Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.БухгалтерияДляКазахстана_3_0")
		ИЛИ Режим=ПредопределенноеЗначение("Перечисление.фин_РежимыИнтеграцииСУчетнойСистемой.УправлениеТорговлейДляКазахстана_3") Тогда 
		Выполнить("ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(МногострочныйТекст, ФормаВладелец, ИмяРеквизита, Заголовок)");
		Возврат;
	КонецЕсли;	
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ФормаВладелец, ИмяРеквизита);
	Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	ЗаголовокФормы = ?(Заголовок <> Неопределено, Заголовок, НСтр("ru='Комментарий'"));
	ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, МногострочныйТекст, ЗаголовокФормы);
	
КонецПроцедуры

Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	РеквизитФормы = ДополнительныеПараметры.ФормаВладелец;
	
	ПутьКРеквизитуФормы = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДополнительныеПараметры.ИмяРеквизита, ".");
	// Если реквизит вида "Объект.Комментарий" и т.п.
	Если ПутьКРеквизитуФормы.Количество() > 1 Тогда
		Для Индекс = 0 По ПутьКРеквизитуФормы.Количество() - 2 Цикл 
			РеквизитФормы = РеквизитФормы[ПутьКРеквизитуФормы[Индекс]];
		КонецЦикла;
	КонецЕсли;	
	
	РеквизитФормы[ПутьКРеквизитуФормы[ПутьКРеквизитуФормы.Количество() - 1]] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	
КонецПроцедуры


//// Продолжение процедуры УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов.
//Процедура ПроверитьПроведенностьДокументовДиалогПроведения(Параметры) Экспорт
//	
//	Выполнить("УправлениеПечатьюСлужебныйКлиент.ПроверитьПроведенностьДокументовДиалогПроведения(Параметры)");
//	
//КонецПроцедуры
