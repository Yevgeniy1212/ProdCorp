﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтоРегистр = ЭтоРегистр(Объект.Владелец);
	Если Объект.Ссылка.Пустая() И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Если ЭтоРегистр Тогда
			Объект.ВидДанных = Перечисления.фин_ВидыОтраженийПервичныхДокументовВБюджетировании.ПоДвижениямВРегистрах;
		КонецЕсли;
	КонецЕсли;
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.Владелец) Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	МАКСИМУМ(фин_ГруппыПравилОтраженияФактическихДанных.Порядок) КАК Порядок
			|ИЗ
			|	Справочник.фин_ГруппыПравилОтраженияФактическихДанных КАК фин_ГруппыПравилОтраженияФактическихДанных
			|ГДЕ
			|	фин_ГруппыПравилОтраженияФактическихДанных.Владелец = &Владелец";
		
		Запрос.УстановитьПараметр("Владелец", Объект.Владелец);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Объект.Порядок = ?(ВыборкаДетальныеЗаписи.Порядок=Null,1,ВыборкаДетальныеЗаписи.Порядок+1);
		КонецЦикла;
	
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Правила.КомпоновщикНастроек.Настройки.Отбор, "Владелец", Объект.Ссылка, , , Истина);
	УправлениеФормой(ЭтотОбъект);
	фин_БюджетированиеОбщегоНазначения.НастроитьОформлениеТабличногоПоля(Элементы.Правила);
	ПорядокПрименения = фин_ОбщегоНазначенияКлиентСервер.ПредставлениеСпособаИспользованияПравила(Объект);
	ТаблицаДанных = фин_ОбщегоНазначенияКлиентСервер.ПредставлениеТаблицыДанныхПравила(Объект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	Форма.Элементы.ТаблицаДанных.Видимость = НЕ Форма.ЭтоРегистр;
	Форма.Элементы.Правила.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Форма.Объект.Ссылка);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоРегистр(ВладелецЭлемента)
	Возврат ТипЗнч(ВладелецЭлемента.Владелец)=Тип("СправочникСсылка.фин_КлассификаторРегистров");	
КонецФункции

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	ВладелецПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВладелецПриИзмененииНаСервере()
	ЭтоРегистр = ЭтоРегистр(Объект.Владелец);
	Объект.ИмяИсточника = "";
	Объект.ПредставлениеИсточника = "";
	Объект.Условие=ПредопределенноеЗначение("Справочник.усд_УсловияВыполненияОперацийПоСтрокамДокумента.ПустаяСсылка");
	ПорядокПрименения = фин_ОбщегоНазначенияКлиентСервер.ПредставлениеСпособаИспользованияПравила(Объект);
	Если ЭтоРегистр Тогда
		Объект.ВидДанных = Перечисления.фин_ВидыОтраженийПервичныхДокументовВБюджетировании.ПоДвижениямВРегистрах;
	КонецЕсли;
	ТаблицаДанных = фин_ОбщегоНазначенияКлиентСервер.ПредставлениеТаблицыДанныхПравила(Объект);
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВладелецНастроек(Схема)
	Возврат Схема.Владелец;	
КонецФункции

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Правила.КомпоновщикНастроек.Настройки.Отбор, "Владелец", Объект.Ссылка, , , Истина);
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПорядокПримененияНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОписаниеОповещенияПорядокПрименения",ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ВидДанных,ИмяИсточника,СпособИспользования,Условие,Порядок");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы,Объект);
	ПараметрыФормы.Вставить("ОбъектИБ",ВладелецНастроек(Объект.Владелец));
	ПараметрыФормы.Вставить("ТолькоПросмотр",ТолькоПросмотр);
	ОткрытьФорму("Справочник.фин_ГруппыПравилОтраженияФактическихДанных.Форма.НастройкаОграниченияИспользования",ПараметрыФормы,ЭтотОбъект,УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОповещенияПорядокПрименения(Результат, ДополнительныеПараметры) Экспорт
	Если Результат<>Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Объект,Результат);
		Модифицированность=Истина;
		ПорядокПрименения = фин_ОбщегоНазначенияКлиентСервер.ПредставлениеСпособаИспользованияПравила(Объект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДанныхНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОписаниеОповещенияТаблицаДанных",ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ВидДанных,ИмяИсточника,ПредставлениеИсточника");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы,Объект);
	ПараметрыФормы.Вставить("ОбъектИБ",ВладелецНастроек(Объект.Владелец));
	ПараметрыФормы.Вставить("ТолькоПросмотр",ТолькоПросмотр);
	ОткрытьФорму("Справочник.фин_ГруппыПравилОтраженияФактическихДанных.Форма.НастройкаТаблицыДанных",ПараметрыФормы,ЭтотОбъект,УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ОписаниеОповещенияТаблицаДанных(Результат, ДополнительныеПараметры) Экспорт
	Если Результат<>Неопределено Тогда
		Если Объект.ВидДанных<>Результат.ВидДанных ИЛИ Объект.ИмяИсточника<>Результат.ИмяИсточника Тогда
			Объект.Условие=ПредопределенноеЗначение("Справочник.усд_УсловияВыполненияОперацийПоСтрокамДокумента.ПустаяСсылка");
			ПорядокПрименения = фин_ОбщегоНазначенияКлиентСервер.ПредставлениеСпособаИспользованияПравила(Объект);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Объект,Результат);
		ТаблицаДанных = фин_ОбщегоНазначенияКлиентСервер.ПредставлениеТаблицыДанныхПравила(Объект);
		Модифицированность=Истина;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ОтображатьОписаниеУсловий(Команда)
	Элементы.ФормаОтображатьОписаниеУсловий.Пометка = НЕ Элементы.ФормаОтображатьОписаниеУсловий.Пометка;
	Элементы.ПравилаУсловиеОписаниеУсловия.Видимость = Элементы.ФормаОтображатьОписаниеУсловий.Пометка;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ПроверитьЗаписатьОбъект(Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПередНачаломИзменения(Элемент, Отказ)
	ПроверитьЗаписатьОбъект(Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаписатьОбъект(Отказ)
	Если Модифицированность Тогда
		Попытка
			Записать();
		Исключение
			Отказ = Истина;
			ПоказатьПредупреждение(,"Для редактирования правил необходимо записать элемент! 
			|Не удалось автоматически записать по причине: 
			|	"+ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписьГруппыПравил",Новый Структура("Объект,Наименование,Владелец",Объект.Ссылка,Объект.Наименование,Объект.Владелец));
КонецПроцедуры
