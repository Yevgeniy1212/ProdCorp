﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Адрес") Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Форма не предназначена для работы в самостоятельном режиме");
		Возврат;
	КонецЕсли;
	Адрес = Параметры.Адрес;
	ПараметрыКарточки = ПолучитьИзВременногоХранилища(Параметры.Адрес);
	Если ПараметрыКарточки.Свойство("ТолькоПросмотр") И ПараметрыКарточки.ТолькоПросмотр<>Неопределено Тогда
		ТолькоПросмотр = ПараметрыКарточки.ТолькоПросмотр;
	КонецЕсли;
	Для Каждого Реквизит Из ПолучитьРеквизиты() Цикл
		Если ПараметрыКарточки.Свойство(Реквизит.Имя) Тогда
			Если ТипЗнч(ПараметрыКарточки[Реквизит.Имя])=Тип("ТаблицаЗначений") Тогда
				Для Каждого СтрокаИсходная Из ПараметрыКарточки[Реквизит.Имя] Цикл
					НС = ЭтотОбъект[Реквизит.Имя].Добавить();
					ЗаполнитьЗначенияСвойств(НС,СтрокаИсходная);
				КонецЦикла;
			Иначе
				ЭтотОбъект[Реквизит.Имя] = ПараметрыКарточки[Реквизит.Имя];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	//оформление
	НадписьКарточкаЭтапа = "Условный переход";
	НадписьПредшествующиеЭтапы = "Предшествующие этапы";
	НадписьУсловныеПереходы = "Условные переходы";
	
	мУровень		= Уровень;
	Элементы.Идентификатор.ТолькоПросмотр = НЕ РежимСоздания;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	Идентификатор = фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.УдалитьНедопустимыеСимволыНомера(Идентификатор);
КонецПроцедуры

&НаКлиенте
Процедура УровеньПриИзменении(Элемент)
	мУровень = Уровень;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ПредыдущиеЭтапы>

&НаКлиенте
Процедура ПредыдущиеЭтапыЭтапПриИзменении(Элемент)
	
	Элементы.Уровень.МинимальноеЗначение = ДоступныйУровень();
	Если мПредыдущийЭтап<>Элементы.ПредыдущиеЭтапы.ТекущиеДанные.Этап Тогда
		Элементы.ПредыдущиеЭтапы.ТекущиеДанные.Условие = ПредопределенноеЗначение("Справочник.усд_УсловияВыполненияОперацийПоДокументам.ПустаяСсылка");
	КонецЕсли;
	Если Уровень<Элементы.Уровень.МинимальноеЗначение Тогда
		Уровень = Элементы.Уровень.МинимальноеЗначение;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Изменен уровень этапа! Этап должен располагаться после предшествующего ему",,"Уровень",,);
	КонецЕсли;
	мПредыдущийЭтап = Элементы.ПредыдущиеЭтапы.ТекущиеДанные.Этап;
	мУровень = Уровень;
	мУсловие = Элементы.ПредыдущиеЭтапы.ТекущиеДанные.Условие;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийЭтапНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Список = СписокЭтапов();
	Список.Вставить(0,"Старт");
	ДанныеВыбора = Список;
КонецПроцедуры

&НаКлиенте
Процедура УсловиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Список = СписокУсловий(Элементы.ПредыдущиеЭтапы.ТекущиеДанные.Этап);
	Список.Вставить(0,ПредопределенноеЗначение("Справочник.усд_УсловияВыполненияОперацийПоДокументам.ПустаяСсылка"),"<безусловно>");
	ДанныеВыбора = Список;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <Переходы>

&НаКлиенте
Процедура ПереходыЭтапНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Список = Новый СписокЗначений;
	Для Каждого СтрокаЭтап Из ЭтапыИУровни Цикл
		//Если СтрокаЭтап.Уровень>Уровень Тогда
			Список.Добавить(СтрокаЭтап.Этап);
		//КонецЕсли;
	КонецЦикла;
	Список.Добавить("Финиш");
	ДанныеВыбора = Список;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Безусловные = Переходы.НайтиСтроки(Новый Структура("Условие",ПредопределенноеЗначение("Справочник.усд_УсловияВыполненияОперацийПоДокументам.ПустаяСсылка"))).Количество();
	Если Безусловные = 0 Тогда
		ПоказатьПредупреждение(, "Обязательно следует создать строку безусловного перехода!");
		Возврат;
	ИначеЕсли Безусловные>1 Тогда
		ПоказатьПредупреждение(, "Переход может иметь только одну строку безусловного перехода!");
		Возврат;
	КонецЕсли;	
	Если СокрЛП(Идентификатор)="" Тогда
		ПоказатьПредупреждение(, "Не указан идентификатор!");
		Возврат;
	КонецЕсли;	
	ОповеститьОВыборе(ПараметрыКарточкиЭтапа());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПараметрыКарточкиЭтапа()
	 СтруктураПараметров = Новый Структура;
	 
	 СтруктураПараметров.Вставить("РежимСоздания",РежимСоздания);
	 СтруктураПараметров.Вставить("Идентификатор",Идентификатор);
	 // сведения о переходах этапа
	 СтруктураПараметров.Вставить("ПредыдущиеЭтапы",ПредыдущиеЭтапы.Выгрузить());
	 СтруктураПараметров.Вставить("Переходы",Переходы.Выгрузить());
	 
	 //сведения этапа
	 СтруктураПараметров.Вставить("Уровень",									Уровень);
	 СтруктураПараметров.Вставить("Представление",								Представление);
	 #Если ТолстыйКлиентОбычноеПриложение Тогда
		 Возврат СтруктураПараметров;
	 #Иначе
		 Попытка
		 	ПоместитьВоВременноеХранилище(СтруктураПараметров,Адрес);
			Исключение
				Возврат ПоместитьВоВременноеХранилище(СтруктураПараметров,УникальныйИдентификатор);
			КонецПопытки;
		 Возврат Адрес;
	 #КонецЕсли
 КонецФункции
 
 &НаКлиенте
Функция ДоступныйУровень()
	
	МинимальныйУровень = 0;
	Для Каждого СтрокаЭтап ИЗ ПредыдущиеЭтапы Цикл
		МинимальныйУровень = Макс(МинимальныйУровень,УровеньЭтапа(СтрокаЭтап.Этап));
	КонецЦикла;
	Возврат МинимальныйУровень;
	
КонецФункции

&НаСервере
Функция СписокЭтапов()
	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(ЭтапыИУровни.Выгрузить().ВыгрузитьКолонку("Этап"));
	Возврат Список;
КонецФункции

&НаКлиенте
Функция УровеньЭтапа(ПараметрЭтап)
    УровеньЭтапа = 0;
	СтрокиЭтап = ЭтапыИУровни.НайтиСтроки(Новый Структура("Этап",ПараметрЭтап));
	Если СтрокиЭтап.Количество()>0 Тогда
		УровеньЭтапа=СтрокиЭтап[0].Уровень;
	КонецЕсли;
	Возврат УровеньЭтапа;
КонецФункции

&НаСервере
Функция СписокУсловий(ЭтапДляУсловий)
	Условия = УсловияПоЭтапам.Выгрузить(Новый Структура("Этап",ЭтапДляУсловий)).ВыгрузитьКолонку("Условие");
	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(Условия);
	Возврат Список;
КонецФункции

