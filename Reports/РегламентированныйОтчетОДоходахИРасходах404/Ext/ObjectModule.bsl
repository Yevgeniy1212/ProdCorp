﻿#Если Клиент Тогда
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит структуру многостраничных разделов.
Перем мСтруктураМногостраничныхРазделов Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов.
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мПериодичность Экспорт;

Перем мТаблицаСтраницНаПечать Экспорт;

Перем ВсегоСтраниц Экспорт;

Перем мСписокСтруктурныхЕдиниц Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура СформироватьРасшифровку(КодСтрокиБаланса) Экспорт
	тз = расшифровка.Выгрузить();
	
	тзКопия = тз.Скопировать(Новый Структура("КодСтроки",КодСтрокиБаланса));
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасшифровкаДоходовРасходов";

	Макет = ПолучитьМакет("МакетРасшифровки");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");

	ОбластьМакета.Параметры.ПредставлениеРасшифровки = "Расшифровка строки "+КодСтрокиБаланса;
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	
	Для Каждого СтрокаТЗ из тзКопия Цикл
		ОбластьМакета.Параметры.Заполнить(СтрокаТЗ);
		ОбластьМакета.Параметры.СчетНаименование = СтрокаТЗ.Счет.Наименование;
		ОбластьМакета.Параметры.КорСчетНаименование = СтрокаТЗ.КорСчет.Наименование;
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итог");
	ОбластьМакета.Параметры.ОборотДТ = тзКопия.Итог("ОборотДТ");
	ОбластьМакета.Параметры.ОборотКТ = тзКопия.Итог("ОборотКТ");
	ТабДокумент.Вывести(ОбластьМакета);
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, , , "Расшифровка");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

мСписокСтруктурныхЕдиниц = Новый СписокЗначений;

ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);
ОписаниеТиповСтрока50  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(50);

ОписаниеТиповСтрока254 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево    = Новый ОписаниеТипов(МассивБулево);

// Таблица значений хранит состав показателей отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя поля табличного документа;
//    - код показатели по составу показателей;
//    - код показателя по форме (имя области табличного документа);
//    - признак многострочности;
//    - тип данных показателя.
//
мТаблицаСоставПоказателей         = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСтруктуре",ОписаниеТиповСтрока50);

// Таблица значений хранит данные дополнительной страницы многостраничных разделов отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя дополнительной страницы (отображается в списке дополнительных страниц);
//    - булево, признак текущей страницы (отображенной в поле табличного документа);
//    - структура, содержащая имена и значения редактируемых ячеек дополнительной страницы.
//
ТаблицаСтраницыРаздела            = Новый ТаблицаЗначений;
ТаблицаСтраницыРаздела.Колонки.Добавить("Представление",              ОписаниеТиповСтрока254, "Наименование");
ТаблицаСтраницыРаздела.Колонки.Добавить("АктивнаяСтраница",           ОписаниеТиповБулево);
ТаблицаСтраницыРаздела.Колонки.Добавить("Данные");

мТаблицаСтраницНаПечать = Новый ТаблицаЗначений;
мТаблицаСтраницНаПечать.Колонки.Добавить("ПолеТабличногоДокумента");
мТаблицаСтраницНаПечать.Колонки.Добавить("ИмяЛиста");
мТаблицаСтраницНаПечать.Колонки.Добавить("ИмяЛистаДляЗаписи");
мСтруктураВариантыЗаполнения      = Новый Структура;
#КонецЕсли
