﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполнить АдресСертификата, если это копирование.
	СтрокаСертификатАутентификации = Параметры.ЗначениеКопирования.СертификатАутентификации.Получить();	
	Если СтрокаСертификатАутентификации <> Неопределено Тогда
		ХранилищеЗначенияСертификатАутентификации = НовыйХранилищеЗначения(СтрокаСертификатАутентификации, 9);
		АдресСертификата = ПоместитьВоВременноеХранилище(ХранилищеЗначенияСертификатАутентификации, УникальныйИдентификатор);
	КонецЕсли;
	
	ОбновитьОтборСпискаПрофилей();
	
	СертификатПолноеИмяФайла = НСтр("ru = 'Сертификат для входа в ИС ЭСФ.p12'");
	
	Элементы.СписокПрофилейОчиститьТикетВыбраннойСессии.Видимость = ЭСФВызовСервера.ИспользоватьОткрытиеСессииСПодписью();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ТекущийОбъект.СертификатАутентификации <> Неопределено Тогда
		АдресСертификата = ПоместитьВоВременноеХранилище(ТекущийОбъект.СертификатАутентификации, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоАдресВременногоХранилища(АдресСертификата) Тогда
		СертификатАутентификации = ПолучитьИзВременногоХранилища(АдресСертификата);
		ТекущийОбъект.СертификатАутентификации = СертификатАутентификации;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьОтборСпискаПрофилей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ГиперссылкаЗарегистрироватьНажатие(Элемент)
	ЗапуститьПриложение(ЭСФКлиентСервер.АдресВебПриложенияИСЭСФ());
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура СписокПрофилейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ТекстВопроса = НСтр(
			"ru = 'Перед выполнением необходимо записать элемент.
			|Записать элемент?'");
		
		ПередДобавлениеСтрокиЗаписатьЭлементЗавершение = Новый ОписаниеОповещения("ПередДобавлениеСтрокиЗаписатьЭлементЗавершение", ЭтаФорма);
		ПоказатьВопрос(ПередДобавлениеСтрокиЗаписатьЭлементЗавершение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Отказ = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередДобавлениеСтрокиЗаписатьЭлементЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		Записать();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьСертификат(Команда)
	
	Если ЭСФВызовСервера.ИспользоватьОткрытиеСессииСПодписью() Тогда
		
		КонтейнерМетодов = ЭСФКлиентСервер.КонтейнерМетодов();	
		ОтветСтруктура = ЭСФКлиент.ПолучитьДанныеСертификатаЧерезНЦА("000000000000", "1CService", "");

		Если ОтветСтруктура <> Неопределено Тогда

			СвойстваСертификата = КонтейнерМетодов.СвойстваСертификатаИзJSON(ОтветСтруктура.responseObject);
			ИмяАутентификации = ЭСФКлиентСервер.ИмяАутентификации(СвойстваСертификата.ИИНСубъекта);
			ОписаниеСертификата = КонтейнерМетодов.ОписаниеСертификата(СвойстваСертификата);
			Если ОтветСтруктура.responseObject.Свойство("pem") Тогда
				ОткрытыйСертификатBase64 = Сред(ОтветСтруктура.responseObject.pem,30,СтрДлина(ОтветСтруктура.responseObject.pem)-58);
				ХранилищеЗначенияСертификатАутентификации = НовыйХранилищеЗначения(ОткрытыйСертификатBase64, 9);
				АдресСертификата = ПоместитьВоВременноеХранилище(ХранилищеЗначенияСертификатАутентификации, ЭтаФорма.УникальныйИдентификатор);
			КонецЕсли;
			Объект.ИмяАутентификации = ИмяАутентификации;
			Объект.ОписаниеСертификата = ОписаниеСертификата;
		
		КонецЕсли;
		
	Иначе
			
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	
	Если НЕ Контейнер.КриптопровайдерПодключается() Тогда
		Возврат;
	КонецЕсли;
	
	// Выбрать файл сертификата аутентификации.
	ОбработкаВыбораФайлаСертификата = Новый ОписаниеОповещения("ОбработкаВыбораФайлаСертификатаЗавершение", ЭтаФорма);
	НачатьПомещениеФайла(ОбработкаВыбораФайлаСертификата, , , , УникальныйИдентификатор); 	
	
КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораФайлаСертификатаЗавершение(ФайлВыбран, АдресКлюча, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт

	Если ФайлВыбран Тогда
		СертификатПолноеИмяФайла = ВыбранноеИмяФайла;
		ИнфомацияПоФайлу = ЭСФВызовСервера.ИнфомацияПоФайлу(ВыбранноеИмяФайла);
		Если ВРег(ИнфомацияПоФайлу.Расширение) = ".P12" Тогда
			КлючBase64 = КлючBase64(АдресКлюча);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Файл должен иметь расширение ""*.p12"".'"));
			Возврат;
		КонецЕсли;	
	Иначе
		Возврат;	
	КонецЕсли;	
	
	// Получить пароль сертификата аутентификации.
	ДополнительныеПараметры = Новый Структура("КлючBase64", КлючBase64);	
	ОбработкаВводаПароляСертификатаЗавершение = Новый ОписаниеОповещения("ОбработкаВводаПароляСертификатаЗавершение", ЭтаФорма, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбменЭСФ.Форма.ВводПароля",,,,,, ОбработкаВводаПароляСертификатаЗавершение);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВводаПароляСертификатаЗавершение(Пароль, ДополнительныеПараметры) Экспорт
	
	Если Пароль = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	
	Если ЭСФВызовСервераПовтИсп.ВыполнятьКриптографическиеОперацииНаКлиенте() Тогда
		ИзвлечьСертификатАутентификацииНаКлиенте(ДополнительныеПараметры.КлючBase64, Пароль);
		СвойстваСертификата = СвойстваСертификатаНаКлиенте(ДополнительныеПараметры.КлючBase64, Пароль);
	Иначе
		ИзвлечьСертификатАутентификацииНаСервере(ДополнительныеПараметры.КлючBase64, Пароль);
		СвойстваСертификата = СвойстваСертификатаНаСервере(ДополнительныеПараметры.КлючBase64, Пароль);
	КонецЕсли;
	
	Объект.ИмяАутентификации = ЭСФКлиентСервер.ИмяАутентификации(СвойстваСертификата.ИИНСубъекта);
	Объект.ОписаниеСертификата = Контейнер.ОписаниеСертификата(СвойстваСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьСертификат(Команда)
	Если НЕ ПустаяСтрока(АдресСертификата) Тогда		
		АдресСтрокиСертификата = ПолучитьСертификат(АдресСертификата);
		ПолучитьФайл(АдресСтрокиСертификата, НСтр("ru = 'Сертификат.cer'"), Истина);
	Иначе
		ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Файл сертификата аутентификации не выбран.'"));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСертификат(АдресСертификата)
	
		ХранилищеЗначения = ПолучитьИзВременногоХранилища(АдресСертификата);
		СтрокаСертификат = ХранилищеЗначения.Получить();
		СтрокаСертификат = "-----BEGIN CERTIFICATE-----" + Символы.ПС + СтрокаСертификат + Символы.ПС + "-----END CERTIFICATE-----";
		АдресСтрокиСертификата = ПоместитьВоВременноеХранилище(СтрокаСертификат);	
		
	    Возврат АдресСтрокиСертификата;
	
КонецФункции

&НаКлиенте
Процедура Проверить(Команда)
	
	ПроверитьПослеЗаписи = Новый ОписаниеОповещения("ПроверитьПослеЗаписи", Этаформа);
	Если Объект.Ссылка.Пустая() ИЛИ ЭтаФорма.Модифицированность Тогда
		ЭСФКлиент.ВопросЗаписатьОбъектПередВыполнением(ПроверитьПослеЗаписи, "справочника");
	Иначе
		ПроверитьПослеЗаписи(КодВозвратаДиалога.ОК, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПослеЗаписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Если ЭСФКлиент.ОбъектЗаписан(ЭтаФорма) Тогда
			
			ОбработчикОповщенияВыбораДанных = Новый ОписаниеОповещения("ОбработчикОповщенияВыбораДанных", ЭтаФорма);
			
			ПользователиИСЭСФ = Новый Массив;
			ПользователиИСЭСФ.Добавить(Объект.Ссылка);
			
			ЭСФКлиент.ПаролиАутентификации(ОбработчикОповщенияВыбораДанных, ПользователиИСЭСФ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповщенияВыбораДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда	
		
		ПарольАутентификации = Результат[Объект.Ссылка];
		
		МассивОшибочныхПрофилей = Новый Массив;
		Если ЭСФВызовСервера.ИспользоватьОткрытиеСессииСПодписью() Тогда
			УдалосьВойтиПодВсемиПрофилями = УдалосьВойтиПодВсемиПрофилямиНаКлиенте(ПарольАутентификации, МассивОшибочныхПрофилей);
		Иначе
			УдалосьВойтиПодВсемиПрофилями = УдалосьВойтиПодВсемиПрофилями(ПарольАутентификации, МассивОшибочныхПрофилей);
		КонецЕсли;
		
		Если УдалосьВойтиПодВсемиПрофилями Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Вход в ИС ЭСФ успешно выполнен от имени всех указанных организаций.'")); 	
		Иначе
			ТекстПредупреждения = НСтр(
				"ru = 'Не удалось выполнить вход в ИС ЭСФ от имени организаций:
				|%СписокОрганизаций%'");
			СписокОрганизаций = "";
			Для Каждого ПрофильИСЭСФ Из МассивОшибочныхПрофилей Цикл
				СписокОрганизаций = СписокОрганизаций + ПрофильИСЭСФ + Символы.ПС;	
			КонецЦикла;
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%СписокОрганизаций%", СокрЛП(СписокОрганизаций));
			ПоказатьПредупреждение(, ТекстПредупреждения); 	
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


///////////////////////////////////////////////////////////////////////////////
// Извлечение сертификата

&НаКлиенте
Функция ИзвлечьСертификатАутентификацииНаКлиенте(Знач КлючBase64, Знач Пароль)
	
 	ИзвлечьСертификатАутентификации(ЭтаФорма, КлючBase64, Пароль);
	
КонецФункции

&НаСервере
Функция ИзвлечьСертификатАутентификацииНаСервере(Знач КлючBase64, Знач Пароль)
	
	ИзвлечьСертификатАутентификации(ЭтаФорма, КлючBase64, Пароль);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзвлечьСертификатАутентификации(Форма, Знач КлючBase64, Знач Пароль)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	ОткрытыйСертификатBase64 = Контейнер.ОткрытыйСертификатBase64(КлючBase64, Пароль);	
	ХранилищеЗначенияСертификатАутентификации = НовыйХранилищеЗначения(ОткрытыйСертификатBase64, 9);
	Форма.АдресСертификата = ПоместитьВоВременноеХранилище(ХранилищеЗначенияСертификатАутентификации, Форма.УникальныйИдентификатор);
	
КонецФункции


///////////////////////////////////////////////////////////////////////////////
// Свойства сертификата

&НаКлиенте
Функция СвойстваСертификатаНаКлиенте(Знач КлючBase64, Знач Пароль)
	Возврат СвойстваСертификата(КлючBase64, Пароль);	
КонецФункции

&НаСервере
Функция СвойстваСертификатаНаСервере(Знач КлючBase64, Знач Пароль)
	Возврат СвойстваСертификата(КлючBase64, Пароль);	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СвойстваСертификата(Знач КлючBase64, Знач Пароль)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	СвойстваСертификата = Контейнер.СвойстваСертификата(КлючBase64, Пароль);
	Возврат СвойстваСертификата;
	
КонецФункции


///////////////////////////////////////////////////////////////////////////////
// Прочие служебные процедуры и функции

&НаСервере
Функция УдалосьВойтиПодВсемиПрофилями(Знач ПарольАутентификации, МассивОшибочныхПрофилей = Неопределено)
	
	Удалось = Истина;
	
	Если МассивОшибочныхПрофилей = Неопределено Тогда
		МассивОшибочныхПрофилей = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрофилиИСЭСФ.Ссылка КАК ПрофильИСЭСФ
	|ИЗ
	|	Справочник.ПрофилиИСЭСФ КАК ПрофилиИСЭСФ
	|ГДЕ
	|	НЕ ПрофилиИСЭСФ.ПометкаУдаления
	|	И ПрофилиИСЭСФ.Владелец = &ПользовательИСЭСФ";
	
	Запрос.УстановитьПараметр("ПользовательИСЭСФ", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		Удалось = Ложь;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр(
			"ru = 'Не удалось войти в ИС ЭСФ, так как для пользователя ИС ЭСФ 
            |не указано ни одной организации, от имени которых он имеет право работать.'");
		Сообщение.Поле = "СписокПрофилей";
		Сообщение.Сообщить();
		
	Иначе
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Попытка
					
				ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(Выборка.ПрофильИСЭСФ);	
				ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ПарольАутентификации;
								
				ИдентификаторСессии = ЭСФСервер.ОткрытьСессию(ДанныеПрофиляИСЭСФ);
				ЭСФСервер.ЗакрытьСессию(ДанныеПрофиляИСЭСФ, ИдентификаторСессии);		
								
			Исключение
				
				Удалось = Ложь;

				МассивОшибочныхПрофилей.Добавить(Выборка.ПрофильИСЭСФ);
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр(
					"ru = 'Не удалось войти в ИС ЭСФ, под профилем: ""%ПрофильИСЭСФ%"".
                     |
                     |%ТекстОшибки%
                     |
                     |
                     |'");
				Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%ПрофильИСЭСФ%", Выборка.ПрофильИСЭСФ);
				Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%ТекстОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				Сообщение.Поле = "НеЗапрашиватьПарольНаВремяСеанса";
				Сообщение.Сообщить();
				
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Удалось;
	
КонецФункции

&НаКлиенте
Функция УдалосьВойтиПодВсемиПрофилямиНаКлиенте(Знач ПарольАутентификации, МассивОшибочныхПрофилей = Неопределено)
	
	Удалось = Истина;
	
	Если МассивОшибочныхПрофилей = Неопределено Тогда
		МассивОшибочныхПрофилей = Новый Массив;
	КонецЕсли;
	
	ВыборкаПрофилиИСЭСФ = ПолучитьПрофилиИСЭСФПоПользователю();

	Если ВыборкаПрофилиИСЭСФ.Количество() = 0 Тогда
		
		Удалось = Ложь;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр(
			"ru = 'Не удалось войти в ИС ЭСФ, так как для пользователя ИС ЭСФ 
			|не указано ни одной организации, от имени которых он имеет право работать.'");
		Сообщение.Поле = "СписокПрофилей";
		Сообщение.Сообщить();
		
	Иначе
		
		Для Каждого ПрофильИСЭСФ Из ВыборкаПрофилиИСЭСФ Цикл
			
			Попытка
				
				ДанныеПрофиляИСЭСФ = ЭСФВызовСервера.ДанныеПрофиляИСЭСФ(ПрофильИСЭСФ);
				ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ПарольАутентификации;
				
				ИдентификаторСессии = ЭСФКлиент.ОткрытьСессиюСПодписьюПользователя(ПрофильИСЭСФ);
				
				Если ИдентификаторСессии <> Неопределено Тогда
					Удалось = Истина;
					ЭСФВызовСервера.ЗакрытьСессию(ДанныеПрофиляИСЭСФ, ИдентификаторСессии);
				Иначе
					Удалось = Ложь;
				КонецЕсли;
				
				
			Исключение
				
				Удалось = Ложь;

				МассивОшибочныхПрофилей.Добавить(ПрофильИСЭСФ);
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр(
					"ru = 'Не удалось войти в ИС ЭСФ, под профилем: ""%ПрофильИСЭСФ%"".
                     |
                     |%ТекстОшибки%
                     |
                     |
                     |'");
				Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%ПрофильИСЭСФ%", ПрофильИСЭСФ);
				Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%ТекстОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				Сообщение.Поле = "НеЗапрашиватьПарольНаВремяСеанса";
				Сообщение.Сообщить();
				
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Удалось;
	
КонецФункции

&НаСервере
Функция ПолучитьПрофилиИСЭСФПоПользователю()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрофилиИСЭСФ.Ссылка КАК ПрофильИСЭСФ
	|ИЗ
	|	Справочник.ПрофилиИСЭСФ КАК ПрофилиИСЭСФ
	|ГДЕ
	|	НЕ ПрофилиИСЭСФ.ПометкаУдаления
	|	И ПрофилиИСЭСФ.Владелец = &ПользовательИСЭСФ";
	
	Запрос.УстановитьПараметр("ПользовательИСЭСФ", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Результат = Результат.Выгрузить().ВыгрузитьКолонку("ПрофильИСЭСФ");
	Иначе
		Результат = Новый Массив;
	КонецЕсли;
	
	Возврат Результат;
	

КонецФункции

&НаСервереБезКонтекста
Функция НовыйХранилищеЗначения(Знач Значение, Знач СтепеньСжатия)
	Возврат Новый ХранилищеЗначения(Значение, Новый СжатиеДанных(СтепеньСжатия));	
КонецФункции

&НаСервере
Процедура ОбновитьОтборСпискаПрофилей()
	
	СписокПрофилей.Отбор.Элементы.Очистить();
	
	Элемент = СписокПрофилей.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Владелец");
	Элемент.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Элемент.ПравоеЗначение   = Объект.Ссылка;
	Элемент.Использование    = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючBase64(Знач АдресКлюча) Экспорт
	КлючДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресКлюча);
	КлючBase64 = Base64Строка(КлючДвоичныеДанные);
	Возврат КлючBase64;
КонецФункции

&НаКлиенте
Процедура ЗакрытьВыбраннуюСессию(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.ПарольАутентификации) Тогда
		
		ОбработчикОповщенияВыбораДанных = Новый ОписаниеОповещения("ОбработчикОповщенияЗакрытьФормуВводПароля", ЭтаФорма);
		
		ПользователиИСЭСФ = Новый Массив;
		ПользователиИСЭСФ.Добавить(Объект.Ссылка);
		
		ЭСФКлиент.ПаролиАутентификации(ОбработчикОповщенияВыбораДанных, ПользователиИСЭСФ);
		
	Иначе
		Пароль = Объект.ПарольАутентификации; 
		ЗакрытьВыбраннуюСессиюНаСервере(Пароль);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТикетВыбраннойСессии(Команда)
	
	ОчиститьТикетВыбраннойСессииНаСервере();
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.АктивныеСессииИСЭСФ"));
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьТикетВыбраннойСессииНаСервере()
	
	Для Каждого Профиль Из Элементы.СписокПрофилей.ВыделенныеСтроки Цикл
		ЭСФСервер.СохранитьТикетСессии(Профиль, "ESF", Неопределено);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповщенияЗакрытьФормуВводПароля(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда	
		
		ПарольАутентификации = Результат[Объект.Ссылка];
		ЗакрытьВыбраннуюСессиюНаСервере(ПарольАутентификации);
				
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗакрытьВыбраннуюСессиюНаСервере(Пароль)
	
	МассивВыделенныхПрофилей = Элементы.СписокПрофилей.ВыделенныеСтроки;
	
	Для Каждого Профиль Из МассивВыделенныхПрофилей Цикл		
		ЭСФСервер.ЗакрытьСессиюПоДаннымПрофиля(Профиль, Пароль);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьАктивныеСессии(Команда)
	
	МассивВыделенныхПрофилей = Элементы.СписокПрофилей.ВыделенныеСтроки;
	
	ПараметрыОткрытия = Новый Структура();
	Отбор = Новый Структура("ПрофильИСЭСФ", МассивВыделенныхПрофилей);
	ПараметрыОткрытия.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("РегистрСведений.АктивныеСессииИСЭСФ.ФормаСписка", ПараметрыОткрытия);
	
КонецПроцедуры
