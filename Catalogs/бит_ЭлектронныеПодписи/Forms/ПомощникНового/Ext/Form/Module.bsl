﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Скрыть заголовки страниц.
    Элементы.СтраницыПомощника.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Элементы.СтраницыПодвал.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
	ПользовательИБ = ЭСФКлиентСерверПереопределяемый.ТекущийПользователь();
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаВыборСертификата;
	ОбновитьПанельКнопокНазадДалееЗакрыть();
	
	СертификатПолноеИмяФайла = НСтр("ru = 'Сертификат для подписаний.p12'");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
	Если НЕ ЗначениеЗаполнено(ПользовательИБ) Тогда
		Отказ = Истина;
		Сообщить(НСтр("ru = 'Поле ""Пользователь ИБ"" не заполнено.'"), СтатусСообщения.Внимание);	
	КонецЕсли;
			
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьСертификат(Команда)
	
	КонтейнерМетодов = ЭСФКлиентСервер.КонтейнерМетодов();	
	
	Если НЕ КонтейнерМетодов.КриптопровайдерПодключается() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаВыбораФайлаСертификата = Новый ОписаниеОповещения("ОбработкаВыбораФайлаСертификатаЗавершение", ЭтаФорма);
	НачатьПомещениеФайла(ОбработкаВыбораФайлаСертификата, , , , УникальныйИдентификатор); 	
	
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
	
	КонтейнерМетодов = ЭСФКлиентСервер.КонтейнерМетодов();	
	
	Если ЭСФВызовСервераПовтИсп.ВыполнятьКриптографическиеОперацииНаКлиенте() Тогда
		СертификатBase64 = ИзвлечьСертификатАутентификацииНаКлиенте(ДополнительныеПараметры.КлючBase64, Пароль);
		СвойстваСертификата = СвойстваСертификатаНаКлиенте(ДополнительныеПараметры.КлючBase64, Пароль);
	Иначе
		СертификатBase64 = ИзвлечьСертификатАутентификацииНаСервере(ДополнительныеПараметры.КлючBase64, Пароль);
		СвойстваСертификата = СвойстваСертификатаНаСервере(ДополнительныеПараметры.КлючBase64, Пароль);
	КонецЕсли;
			
	ИмяАутентификации = ЭСФКлиентСервер.ИмяАутентификации(СвойстваСертификата.ИИНСубъекта);
	ОписаниеСертификата = КонтейнерМетодов.ОписаниеСертификата(СвойстваСертификата);
	ОбновитьПанельКнопокНазадДалееЗакрыть();

КонецПроцедуры


&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого Строка Из СписокСтруктурныхЕдиниц Цикл
		Строка.Пометка = Истина;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого Строка Из СписокСтруктурныхЕдиниц Цикл
		Строка.Пометка = Ложь;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ИндексТекущейСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.Индекс(Элементы.СтраницыПомощника.ТекущаяСтраница);
	
	Если ИндексТекущейСтраницы > 0 Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.Получить(ИндексТекущейСтраницы - 1);
	КонецЕсли;
	
	ОбновитьПанельКнопокНазадДалееЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаВыборСертификата И ПустаяСтрока(СертификатBase64) Тогда
		Сообщить(НСтр("ru = 'Выберите сертификат для входа в ИС ЭСФ.'"), СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;
	
	МаксимальныйИндексСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.Количество() - 1;
	ИндексТекущейСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.Индекс(Элементы.СтраницыПомощника.ТекущаяСтраница);
	
	Если ИндексТекущейСтраницы < МаксимальныйИндексСтраницы Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.Получить(ИндексТекущейСтраницы + 1);
	КонецЕсли;
	
	ОбновитьПанельКнопокНазадДалееЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ПользовательИС = СоздатьПользователя();
	
	Если НЕ ПользовательИС.Пустая() Тогда
		
		ОповеститьОбИзменении(ПользовательИС);
		
		ПоказатьЗначение(, ПользовательИС);
		
		ЭтаФорма.Закрыть(ПользовательИС);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьПользователя()
	
	Если ПроверитьЗаполнение() Тогда
		
		НачатьТранзакцию();
		
		Попытка
			ОбъектПользовательИС = Справочники.бит_ЭлектронныеПодписи.СоздатьЭлемент();
			ОбъектПользовательИС.Наименование         = СокрЛП(ПользовательИБ);
			ОбъектПользовательИС.Владелец             = ПользовательИБ;
			//ОбъектПользовательИСЭСФ.ИмяАутентификации    = ИмяАутентификации;
			ОбъектПользовательИС.ПарольАутентификации = ПарольАутентификации;
			ОбъектПользовательИС.ОписаниеСертификата  = ОписаниеСертификата;
			
			Если НЕ ПустаяСтрока(СертификатBase64) Тогда
				ОбъектПользовательИС.СертификатАутентификации = Новый ХранилищеЗначения(СертификатBase64);
			КонецЕсли;
			
			ОбъектПользовательИС.Записать();			
			ПользовательИС = ОбъектПользовательИС.Ссылка;
									
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
	Иначе
		ПользовательИС = Справочники.ПользователиИСЭСФ.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ПользовательИС;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Извлечение сертификата

&НаКлиенте
Функция ИзвлечьСертификатАутентификацииНаКлиенте(Знач КлючBase64, Знач Пароль)
	
 	Возврат ИзвлечьСертификатАутентификации(ЭтаФорма, КлючBase64, Пароль);
	
КонецФункции

&НаСервере
Функция ИзвлечьСертификатАутентификацииНаСервере(Знач КлючBase64, Знач Пароль)
	
	Возврат ИзвлечьСертификатАутентификации(ЭтаФорма, КлючBase64, Пароль);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзвлечьСертификатАутентификации(Форма, Знач КлючBase64, Знач Пароль)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	СертификатBase64 = Контейнер.ОткрытыйСертификатBase64(КлючBase64, Пароль);
	Возврат СертификатBase64;
		
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

&НаКлиенте
Процедура ОбновитьПанельКнопокНазадДалееЗакрыть()
		
	ИндексТекущейСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.Индекс(Элементы.СтраницыПомощника.ТекущаяСтраница);
	МаксимальныйИндексСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.Количество() - 1;
	
	Если Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаВыборСертификата Тогда
	
		Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаДалее;
		Элементы.Далее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		Если ИндексТекущейСтраницы = 0 Тогда
			
			Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаДалее;
			Элементы.Далее.КнопкаПоУмолчанию = Истина;
			
		ИначеЕсли ИндексТекущейСтраницы > 0 И ИндексТекущейСтраницы < МаксимальныйИндексСтраницы Тогда
			
			Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаНазадДалее;
			Элементы.Далее2.КнопкаПоУмолчанию = Истина;
			
		Иначе // ИндексТекущейСтраницы = МаксимальныйИндексСтраницы
			
			Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.СтраницаГотово;	
			Элементы.Готово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючBase64(Знач АдресКлюча) Экспорт
	КлючДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресКлюча);
	КлючBase64 = Base64Строка(КлючДвоичныеДанные);
	Возврат КлючBase64;
КонецФункции