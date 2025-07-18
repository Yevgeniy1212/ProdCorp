﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.ДокументПриСозданииНаСервере(ЭтотОбъект);
	
	ПодготовитьФормуНаСервере();
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтотОбъект);
	
	// обработка доступности формы на основании данных согласования документов
	усд_УправлениеСогласованиемДокументов.ДоступностьРедактированияДокумента(ЭтотОбъект,Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.ДокументПриЧтенииНаСервере(ЭтотОбъект,ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	общ_ОбщегоНазначенияКлиент.ОбработкаОповещенияФормыДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

&НаКлиенте
Процедура ПозицияКлассификатораПриИзменении(Элемент)
	Если мПозицияКлассификатора<>Объект.ПозицияКлассификатора Тогда
		Заголовок = ?(Объект.ПозицияКлассификатора.Пустая(),"",Объект.ПозицияКлассификатора);
		Объект.ВнутреннийНомер = "";
		мПозицияКлассификатора=Объект.ПозицияКлассификатора;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <>



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		фин_ПроцедурыРаботыСОбъектамиКлиентПереопределяемый.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Генерировать(Команда)
	Объект.ВнутреннийНомер = ГенерироватьНомер(Объект.Ссылка,Объект.ПозицияКлассификатора);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	фин_ПроцедрыРаботыСОбъектамиПереопределяемый.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если НЕ (ЗначениеЗаполнено(Параметры.ЗначениеКопирования) ИЛИ ЗначениеЗаполнено(Параметры.Основание)) Тогда
			// по умолчанию при распределении учитываются все возможные показатели

		КонецЕсли;
		
	КонецЕсли;
	
	НадписьПринадлежностьДокумента = "Принадлежность документа";
	НадписьРеквизитыВходящегоДокумента = "Реквизиты входящего документа";
	мПозицияКлассификатора = Объект.ПозицияКлассификатора;
	Заголовок = ?(Объект.ПозицияКлассификатора.Пустая(),"",Объект.ПозицияКлассификатора);
	Если фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ДлинаВнутреннегоНомера") <> 0 Тогда
		КлассификаторСтроки = Новый КвалификаторыСтроки(фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ДлинаВнутреннегоНомера"),ДопустимаяДлина.Переменная);
		Типы = Новый Массив;
		Типы.Добавить(Тип("Строка"));
		Описание = Новый ОписаниеТипов(Типы,,КлассификаторСтроки);
	    Элементы.ВнутреннийНомер.ОграничениеТипа = Описание;
	КонецЕсли;
	
КонецПроцедуры 

//Процедура ГенерироватьНажатие
//
&НаСервереБезКонтекста
Функция ГенерироватьНомер(Ссылка, ПозицияКлассификатора)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",					Ссылка);
	Запрос.УстановитьПараметр("ПозицияКлассификатора",	ПозицияКлассификатора);
	Запрос.Текст = "ВЫБРАТЬ
	               |	МАКСИМУМ(ВходящийДокумент.ВнутреннийНомер) КАК ВнутреннийНомер
	               |ИЗ
	               |	Документ.усд_ВходящийДокумент КАК ВходящийДокумент
	               |ГДЕ
	               |	ВходящийДокумент.Ссылка <> &Ссылка
	               |	И ВходящийДокумент.ПозицияКлассификатора = &ПозицияКлассификатора";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПоследнийНомер = Выборка.ВнутреннийНомер;
	Иначе
		ПоследнийНомер = "0";
	КонецЕсли;
	Если ПоследнийНомер = NULL ИЛИ ПоследнийНомер="" Тогда
		ПоследнийНомер = "0";
	КонецЕсли;
	Если Строка(Число(ПоследнийНомер)) = СокрЛП(ПоследнийНомер) Тогда
		ПоследнийНомер = Строка(Число(ПоследнийНомер)+1);
	Иначе
		ПоследняяЦифра = Прав(ПоследнийНомер,1);
		Если Строка(Число(ПоследняяЦифра))=ПоследняяЦифра Тогда
			мЧисло = Число(ПоследняяЦифра)+1;
			ПоследнийНомер = Лев(ПоследнийНомер,СтрДлина(ПоследнийНомер)-1);
		Иначе
			мЧисло = 1;
		КонецЕсли;
		ПоследнийНомер = ПоследнийНомер+Строка(мЧисло);
	КонецЕсли;
	Длина = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ДлинаВнутреннегоНомера");
	Если Длина = 0 Тогда
		Длина = 11;
	КонецЕсли;
	Пока СтрДлина(ПоследнийНомер)<Длина Цикл
		ПоследнийНомер = "0"+ПоследнийНомер;
	КонецЦикла;
	Возврат ПоследнийНомер;
	
КонецФункции //ГенерироватьНажатие
