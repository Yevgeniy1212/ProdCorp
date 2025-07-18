﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуПрофилейДляСинхронизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура ТаблицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)	
	Отказ = Истина;	
	ОткрытьФорму("Справочник.ПрофилиИСЭСФ.ФормаВыбора", , Элемент);	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)	
	СтандартнаяОбработка = Ложь;
	ТаблицаОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ТаблицаОбработкаВыбораНаСервере(ВыбранноеЗначение)	
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ПрофилиИСЭСФ") Тогда
		СтрокаТаблицы = Таблица.Добавить();
		СтрокаТаблицы.Пометка = Истина;
		СтрокаТаблицы.СтруктурнаяЕдиница = ВыбранноеЗначение.СтруктурнаяЕдиница;
		СтрокаТаблицы.ПрофильИСЭСФ = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтруктурнаяЕдиницаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтруктурнаяЕдиницаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПрофильИСЭСФНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПрофильИСЭСФОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомментарийОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
    
&НаКлиенте
Процедура Синхронизировать(Команда)
	
	// Очистить комментарий.
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Комментарий = "";	
	КонецЦикла;
	
	// Создать массив профилей ИС ЭСФ из помеченных строк таблицы.
	МассивПрофилейИСЭСФ = Новый Массив;	
	МассивПрофилейИСЭСФСДатойСинхронизации = Новый Массив; // Для получения входящих ЭСФ в версии 5.0, в свзяи с вводом параметра LastEventDate
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если СтрокаТаблицы.Пометка Тогда
			МассивПрофилейИСЭСФ.Добавить(СтрокаТаблицы.ПрофильИСЭСФ);	
			МассивПрофилейИСЭСФСДатойСинхронизации.Добавить(Новый Структура("ПрофильИСЭСФ, ДатаНачалаСинхронизацииВходящихЭСФ, ДатаНачалаСинхронизацииИсходящихЭСФ", СтрокаТаблицы.ПрофильИСЭСФ, СтрокаТаблицы.ДатаНачалаСинхронизацииВходящихЭСФ, СтрокаТаблицы.ДатаНачалаСинхронизацииИсходящихЭСФ));	
		КонецЕсли;
	КонецЦикла;
	
	Если МассивПрофилейИСЭСФ.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Выберите хотя бы один профиль для синхронизации с ИС ЭСФ.'");
		Сообщение.Поле = "Таблица";
		Сообщение.Сообщить();
		Возврат;	
	КонецЕсли;
	
		
	// Получить пароли для пользователей ИС ЭСФ, которые не имеют сохраненных паролей.
	МассивПользователейИСЭСФБезПароля = ЭСФВызовСервера.ПользователиИСЭСФБезПароляАутентификации(МассивПрофилейИСЭСФ);	
	
	ДополнительныеПараметры = Новый Структура("МассивПрофилейИСЭСФ, МассивПользователейИСЭСФБезПароля, МассивПрофилейИСЭСФСДатойСинхронизации", МассивПрофилейИСЭСФ, МассивПользователейИСЭСФБезПароля, МассивПрофилейИСЭСФСДатойСинхронизации);
	
	Если МассивПользователейИСЭСФБезПароля.Количество() > 0 Тогда
		СинхронизироватьЗавершение = Новый ОписаниеОповещения("СинхронизироватьЗавершение", ЭтаФорма, ДополнительныеПараметры);
		ЭСФКлиент.ПаролиАутентификации(СинхронизироватьЗавершение, МассивПользователейИСЭСФБезПароля);
	Иначе
		СинхронизироватьЗавершение(МассивПрофилейИСЭСФ, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СинхронизироватьНаСервере(МассивДанныхПрофилейИСЭСФ, МассивПрофилейИСЭСФСДатойСинхронизации)
	
	ПараметрыЗадания = Новый Структура("МассивДанныхПрофилейИСЭСФ, МассивПрофилейИСЭСФСДатойСинхронизации, ПолучитьОднуПорцию, ТолькоСоздатьОбновитьФайлы, ЗапускатьФоновоеЗадание");
	ПараметрыЗадания.Вставить("МассивДанныхПрофилейИСЭСФ", МассивДанныхПрофилейИСЭСФ);
	ПараметрыЗадания.Вставить("ПолучитьОднуПорцию", Истина);
	ПараметрыЗадания.Вставить("ТолькоСоздатьОбновитьФайлы", Ложь);
	ПараметрыЗадания.Вставить("ЗапускатьФоновоеЗадание", ЭСФКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуЭСФ());
	ПараметрыЗадания.Вставить("МассивПрофилейИСЭСФСДатойСинхронизации", МассивПрофилейИСЭСФСДатойСинхронизации);	
	
	Если ПараметрыЗадания.ЗапускатьФоновоеЗадание Тогда
		
		РезультатРаботыЗадания = Неопределено;
	
		ИмяПроцедурыПолученияЭСФ = "ЭСФВызовСервера.ПолучитьНовыеЭСФ";
		
		СтруктураВыполненияЗадания = ЭСФСерверПереопределяемый.ФоновоеЗаданиеЗапущено(ИмяПроцедурыПолученияЭСФ);
		
		Если НЕ СтруктураВыполненияЗадания.ЗаданиеАктивно Тогда
			
			ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
			НаименованиеЗадания = НСтр("ru = 'Синхронизация ЭСФ'");
			ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
			
			РезультатРаботыЗадания = ЭСФВызовСервера.ВыполнитьВФоне(ИмяПроцедурыПолученияЭСФ, ПараметрыЗадания, ПараметрыВыполнения);
				
		Иначе
			
			ТекстСообщения = НСтр("ru = 'В информационной базе уже запущен процесс получения документов ЭСФ. 
										|Перед запуском нового процесса синхронизации, необходимо дождаться завершения предыдущего (запущено на %1, время запуска %2'");
										
			ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, СтруктураВыполненияЗадания.Расположение, СтруктураВыполненияЗадания.Начало);
										
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Сообщить();
				
		КонецЕсли;
			
	Иначе
		
		ЭСФВызовСервера.ПолучитьНовыеЭСФ(ПараметрыЗадания);
		
	КонецЕсли;
	
	Возврат РезультатРаботыЗадания;

КонецФункции

&НаКлиенте
Процедура УстановитьФлажки(Команда)	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура СинхронизироватьЗавершение(Результат = Неопределено, ДополнительныеПараметры) Экспорт
	
	МассивПрофилейИСЭСФ = ДополнительныеПараметры.МассивПрофилейИСЭСФ;
	МассивПользователейИСЭСФБезПароля = ДополнительныеПараметры.МассивПользователейИСЭСФБезПароля;
	МассивПрофилейИСЭСФСДатойСинхронизации = ДополнительныеПараметры.МассивПрофилейИСЭСФСДатойСинхронизации; 
	
	Если НЕ Результат = Неопределено Тогда
		
		КоллецияПаролей = Результат;
		МассивДанныхПрофилейИСЭСФ = ДанныеПрофилейДляСинхронизацииНаСервере(МассивПрофилейИСЭСФ, КоллецияПаролей);
	
	КонецЕсли;

	Если МассивДанныхПрофилейИСЭСФ = Неопределено ИЛИ МассивДанныхПрофилейИСЭСФ.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//до перехода на сервер нужно получить ИД сессии на клиенте!
	//при этом учеть получение для каждого профиля
	ПараметрыОткрытияСессии = ЭСФКлиентСервер.ПолучитьПараметрыОткрытияСессииСПодписьюПоУмолчанию();
	ПараметрыОткрытияСессии.ТребуетсяДополнительноеОткрытиеСессииВС = Истина;
	Если НЕ ОткрытьСессиюСПодписьюДляПрофилей(МассивДанныхПрофилейИСЭСФ, ПараметрыОткрытияСессии) Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	РезультатРаботыЗадания = СинхронизироватьНаСервере(МассивДанныхПрофилейИСЭСФ, МассивПрофилейИСЭСФСДатойСинхронизации);
	
	Если Параметры.ЗапускатьФоновоеЗадание Тогда
		
		Если ТипЗнч(РезультатРаботыЗадания) = Тип("Структура") Тогда
			РезультатРаботыЗадания.Вставить("ТекстСообщения", НСтр("ru = 'Получение документов из ИС ЭСФ'"));
			
			СтруктураОповещений = Новый Структура("Синхронизация_ЭСФ");
			РезультатРаботыЗадания.Вставить("ДополнительныеОповещения", СтруктураОповещений);
		КонецЕсли;
				
		ЭСФКлиентПереопределяемый.ОбработкаОповещенияЭСФ_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, РезультатРаботыЗадания);
		
	Иначе
		ЭСФКлиент.ОповеститьФормы(ЭСФКлиентСервер.ИмяСобытияЗаписьЭСФ());
		ЭСФКлиент.ОповеститьФормы("Синхронизация_ЭСФ");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПрофилейДляСинхронизацииНаСервере(Знач МассивПрофилейИСЭСФ, Знач КоллецияПаролей)
	
	// Создать массив, содержащий данные профилей ИС ЭСФ.
	МассивДанныхПрофилейИСЭСФ = Новый Массив();
	Для Каждого ПрофильИСЭСФ Из МассивПрофилейИСЭСФ Цикл
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ПрофильИСЭСФ);
		МассивДанныхПрофилейИСЭСФ.Добавить(ДанныеПрофиляИСЭСФ);
	КонецЦикла;
	
	// Заполнить пароли, у пользователей, которые не имеют сохраненных паролей. 
	Для Каждого ДанныеПрофиляИСЭСФ Из МассивДанныхПрофилейИСЭСФ Цикл
		Если ПустаяСтрока(ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации) Тогда
			ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = КоллецияПаролей[ДанныеПрофиляИСЭСФ.ПользовательИСЭСФ.Ссылка];	
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивДанныхПрофилейИСЭСФ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПрофилейДляСинхронизации()
	
	// Запрос организован таким образом, чтобы сработал RLS.
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК СтруктурнаяЕдиница,
	|	Организации.Наименование
	|ПОМЕСТИТЬ СтруктурныеЕдиницы
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	| [ЗапросПоСтруктурнымЕдиницам]
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрофилиИСЭСФ.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПрофилиИСЭСФ.Ссылка КАК ПрофильИСЭСФ
	|ПОМЕСТИТЬ ВТ_ПрофилиСинхронизации	
	|ИЗ
	|	Справочник.ПрофилиИСЭСФ КАК ПрофилиИСЭСФ	
	|ГДЕ
	|	НЕ ПрофилиИСЭСФ.ПометкаУдаления
	|	И ПрофилиИСЭСФ.ИспользоватьДляСинхронизации
	|	И ПрофилиИСЭСФ.СтруктурнаяЕдиница В
	|			(ВЫБРАТЬ
	|				СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|			ИЗ
	|				СтруктурныеЕдиницы КАК СтруктурныеЕдиницы);
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрофилиСинхронизации.СтруктурнаяЕдиница,
	|	ПрофилиСинхронизации.ПрофильИСЭСФ,
	|	ЕСТЬNULL(ПараметрыМетодовИСЭСФВходящихЭСФ.ЗначениеПараметра, ДАТАВРЕМЯ(2010, 1, 1, 0, 0, 0)) КАК ДатаНачалаСинхронизацииВходящихЭСФ,
	|	ЕСТЬNULL(ПараметрыМетодовИСЭСФИсходящихЭСФ.ЗначениеПараметра, ДАТАВРЕМЯ(2010, 1, 1, 0, 0, 0)) КАК ДатаНачалаСинхронизацииИсходящихЭСФ
	|ИЗ
	|	ВТ_ПрофилиСинхронизации КАК ПрофилиСинхронизации
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыМетодовИСЭСФ КАК ПараметрыМетодовИСЭСФВходящихЭСФ
	|		ПО (ПрофилиСинхронизации.СтруктурнаяЕдиница = ПараметрыМетодовИСЭСФВходящихЭСФ.СтруктурнаяЕдиница
	|				И ПараметрыМетодовИСЭСФВходящихЭСФ.ИмяМетода = &ИмяМетода     // дата начала синхронизации
	|				И ПараметрыМетодовИСЭСФВходящихЭСФ.НаправлениеЭСФ = Значение(Перечисление.НаправленияЭСФ.Входящий)
	|				И ПараметрыМетодовИСЭСФВходящихЭСФ.ИмяПараметра = &ИмяПараметра)
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыМетодовИСЭСФ КАК ПараметрыМетодовИСЭСФИсходящихЭСФ
	|		ПО (ПрофилиСинхронизации.СтруктурнаяЕдиница = ПараметрыМетодовИСЭСФИсходящихЭСФ.СтруктурнаяЕдиница
	|				И ПараметрыМетодовИСЭСФИсходящихЭСФ.ИмяМетода = &ИмяМетода     // дата начала синхронизации
	|				И ПараметрыМетодовИСЭСФИсходящихЭСФ.НаправлениеЭСФ = Значение(Перечисление.НаправленияЭСФ.Исходящий)
	|				И ПараметрыМетодовИСЭСФИсходящихЭСФ.ИмяПараметра = &ИмяПараметра)
	
	|
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПрофилиСинхронизации.СтруктурнаяЕдиница.Наименование";
	
	// Не все конфигурации поддерживают структурные единицы.
	Если ЭСФКлиентСерверПереопределяемый.ИспользуютсяСтруктурныеПодразделения() Тогда
		ЗапросПоСтруктурнымЕдиницам = 
		"ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияОрганизаций.Ссылка,
		|	ПодразделенияОрганизаций.Наименование
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|ГДЕ
		|	ПодразделенияОрганизаций.ЯвляетсяСтруктурнымПодразделением";		
	Иначе
		ЗапросПоСтруктурнымЕдиницам = "";
	КонецЕсли;	
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ЗапросПоСтруктурнымЕдиницам]", ЗапросПоСтруктурнымЕдиницам);
	
	Запрос.УстановитьПараметр("ИмяМетода",	"queryUpdates");	
	Запрос.УстановитьПараметр("ИмяПараметра", "LASTEVENTDATE");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
		//СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуПрофилейДляСинхронизации()
	МассивПрофилейИСЭСФ = Новый Массив;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если СтрокаТаблицы.Пометка Тогда
			МассивПрофилейИСЭСФ.Добавить(СтрокаТаблицы.ПрофильИСЭСФ);				
		КонецЕсли;
	КонецЦикла;
	Таблица.Очистить();
	ЗаполнитьТаблицуПрофилейДляСинхронизации();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если МассивПрофилейИСЭСФ.Найти(СтрокаТаблицы.ПрофильИСЭСФ)<>Неопределено Тогда
			СтрокаТаблицы.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;		
КонецПроцедуры

&НаКлиенте
// Открывает сессии с подписью для переданных данных с профилей ИСЭСФ.
//
// Параметры:
//  ДанныеПрофилейИСЭСФ - Массив или Соответствие, или Ссылка  на справочник ПрофилиИСЭСФ,
//   по которым(му) происходит открытие сессий.
//  ПараметрыОткрытияСессии - Структура - параметры для открытия сессии с подписью,
//   функция для получения параметров - ЭСФКлиентСервер.ПолучитьПараметрыОткрытияСессииСПодписьюПоУмолчанию().
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОткрытьСессиюСПодписьюДляПрофилей(ДанныеПрофилейИСЭСФ,ПараметрыОткрытияСессии = Неопределено) Экспорт
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	
	Возврат Контейнер.ОткрытьСессиюСПодписьюДляПрофилей(ДанныеПрофилейИСЭСФ,ПараметрыОткрытияСессии);
	
КонецФункции


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Синхронизация_ЭСФ" Тогда
		ОбновитьТаблицуПрофилейДляСинхронизации(); // Обновление даты синхронизации по результататм работы события
	КонецЕсли;	
КонецПроцедуры

