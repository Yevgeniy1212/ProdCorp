﻿Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	Автор = ПараметрыСеанса.ТекущийПользователь;
	Состояние = Перечисления.ЦС_СостоянияСогласованияПлатежей.ВРаботе;	
	Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь,"ОсновнаяОрганизация");
	
КонецПроцедуры

Функция ПолучитьАдресатаДляТекущегоЭтапа(Постановщик,ТочкаЭтапа);
	
	Если ТочкаЭтапа = Справочники.ЦС_ЭтапыМаршрутовБП.ВозвращеноАвтору Тогда
		Возврат Постановщик;
	КонецЕсли;

	Если ТочкаЭтапа = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеСКурирующимЧП Тогда
		Возврат КурирующийЧП;
	КонецЕсли;

	Если ТочкаЭтапа = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеССогласующим Тогда
		Возврат Согласующий;
	КонецЕсли;
	
	//SmartTec Рамиль +
	Если ТочкаЭтапа = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеДиректораФД Тогда
		Возврат ДиректорФД;
	КонецЕсли;
	
	Если ТочкаЭтапа = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеМенеджераФД Тогда
		Возврат МенеджерФД;
	КонецЕсли;
	//SmartTec Рамиль -

	Если ТочкаЭтапа = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеСРуководителемСП Тогда
		
		Если ЗначениеЗаполнено(ЭтотОбъект.ДиректорСТП) Тогда
			Возврат ЭтотОбъект.ДиректорСТП;
		КонецЕсли;
		
		Сотрудник = Справочники.СотрудникиОрганизаций.НайтиПоРеквизиту("Физлицо", Постановщик.ФизЛицо);
		Подразделение = Сотрудник.ТекущееПодразделениеОрганизации;
		
			Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Бит_АдресацияУведомленийПоКомандировкам.Адресат,
		|	Бит_АдресацияУведомленийПоКомандировкам.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.Бит_АдресацияУведомленийПоКомандировкам КАК Бит_АдресацияУведомленийПоКомандировкам
		|ГДЕ
		|	(Бит_АдресацияУведомленийПоКомандировкам.Пользователь = &Пользователь
		|			ИЛИ Бит_АдресацияУведомленийПоКомандировкам.Пользователь = &ПустойПользователь)
		|	И Бит_АдресацияУведомленийПоКомандировкам.ЭтапМаршрута = &ЭтапМаршрута
		|	И Бит_АдресацияУведомленийПоКомандировкам.Подразделение = &Подразделение
		|
		|УПОРЯДОЧИТЬ ПО
		|	Пользователь УБЫВ";
		
		Запрос.УстановитьПараметр("Пользователь", Постановщик);
		Запрос.УстановитьПараметр("ПустойПользователь", Справочники.Пользователи.ПустаяСсылка());
		Запрос.УстановитьПараметр("Подразделение", Подразделение);

		Запрос.УстановитьПараметр("ЭтапМаршрута", ТочкаЭтапа);
		
		Результат = Запрос.Выполнить();
		Выборка = результат.Выбрать();
		Если Выборка.Следующий() тогда
			Возврат Выборка.Адресат;
		КонецЕсли;
		
	КонецЕсли;

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Бит_АдресацияУведомленийПоКомандировкам.Адресат,
	|	Бит_АдресацияУведомленийПоКомандировкам.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.Бит_АдресацияУведомленийПоКомандировкам КАК Бит_АдресацияУведомленийПоКомандировкам
	|ГДЕ
	|	(Бит_АдресацияУведомленийПоКомандировкам.Пользователь = &Пользователь
	|			ИЛИ Бит_АдресацияУведомленийПоКомандировкам.Пользователь = &ПустойПользователь)
	|	И Бит_АдресацияУведомленийПоКомандировкам.ЭтапМаршрута = &ЭтапМаршрута
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователь УБЫВ";
	
	Запрос.УстановитьПараметр("Пользователь", Постановщик);
	Запрос.УстановитьПараметр("ПустойПользователь", Справочники.Пользователи.ПустаяСсылка());

	Запрос.УстановитьПараметр("ЭтапМаршрута", ТочкаЭтапа);
	
	Результат = Запрос.Выполнить();
	Выборка = результат.Выбрать();
	Если Выборка.Следующий() тогда
		Возврат Выборка.Адресат;
	КонецЕсли;
	
КонецФункции

Процедура ОбработатьЭтап(Постановщик, ТочкаЭтапа,ФормируемыеЗадачи,Отказ, ЯвныйАдресат = Неопределено)
	
	Если ТочкаЭтапа = Справочники.ЦС_ЭтапыМаршрутовБП.ОтправленНаДоработкуАвтором тогда 
		Адресат = Постановщик;
	Иначе    
		Если ЯвныйАдресат = Неопределено тогда
			Адресат = ПолучитьАдресатаДляТекущегоЭтапа(Постановщик,ТочкаЭтапа);
		Иначе
			Адресат = ЯвныйАдресат;	
		КонецЕсли;
		
	КонецЕсли;
	
	Если Адресат = Неопределено или Адресат.Пустая() тогда 
		Отказ = Истина;
		Сообщить("Для текущего пользователя на этапе " + ТочкаЭтапа + " не найден адресат");
		Возврат;
	КонецЕсли;
	
	Для Каждого Задача из ФормируемыеЗадачи Цикл
		
		Если ТипЗнч(Адресат) = Тип("СправочникСсылка.Пользователи") тогда
			Задача.Пользователь = Адресат;
		Иначе
			Задача.Подразделение = Адресат;
		КонецЕсли;
		ЦС_ОбщегоНазначенияСервер.ОтправитьПисьмоПоИзменениюЗаявок(Задача.бизнеспроцесс, Адресат, Задача);
	КонецЦикла;
	
	ЭтотОбъект.Записать();

КонецПроцедуры

Процедура ОбработатьВыборВарианта(ТочкаВыбораВарианта, Результат,МаркерЭтапа)
	
	Если МаркерЭтапа = "Разрешено" тогда
		Результат = ТочкаВыбораВарианта.Варианты.Разрешено;
	ИначеЕсли МаркерЭтапа = "Возвращено" тогда
		Результат = ТочкаВыбораВарианта.Варианты.Возвращено;
	ИначеЕсли МаркерЭтапа = "Отказано" тогда
		Результат = ТочкаВыбораВарианта.Варианты.Отказано;
	КонецЕсли;
	
КонецПроцедуры


Процедура ПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	ТекущаяТочка = ТочкаМаршрутаБизнесПроцесса;
	
	Если ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.СогласованиеСРП") Тогда
		Этап = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеСРуководителемСП;
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.СогласованиеСКурирующимЧП")	Тогда
		Этап = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеСКурирующимЧП;
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.СогласованиеССогласующим")	Тогда
		Этап = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеССогласующим;
		//SmartTec Рамиль +
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.СогласованиеМенеджераФД") Тогда
		Если МенеджерФД = Справочники.Пользователи.ПустаяСсылка() Тогда
			ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.СогласованиеСКурирующимЧП");
			Этап = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеСКурирующимЧП;
		Иначе
			Этап = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеМенеджераФД;
		КонецЕсли;
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.СогласованиеДиректораФД") Тогда
		Если ДиректорФД = Справочники.Пользователи.ПустаяСсылка() Тогда
			ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.СогласованиеСКурирующимЧП");
			Этап = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеСКурирующимЧП;
		Иначе
			Этап = Справочники.ЦС_ЭтапыМаршрутовБП.СогласованиеДиректораФД;
		КонецЕсли;
		//SmartTec Рамиль -
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.ПередачаВКазначейство") Тогда
		Этап = Справочники.ЦС_ЭтапыМаршрутовБП.ПередачаВКазначейство;
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.РаботаСЗаявкойАвтором") Тогда
		Этап = Справочники.ЦС_ЭтапыМаршрутовБП.ВозвращеноАвтору;
	КонецЕсли;	
	
	ОбработатьЭтап(Автор, Этап, ФормируемыеЗадачи, Отказ);
	
КонецПроцедуры

Процедура РезультатПроверкиВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	ТекущаяТочка = ТочкаВыбораВарианта;
	
	Если ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.РезультатПроверкиСТП") Тогда
		МаркерЭтапа = ЗаявкаПрошлаСогласованиеРук;
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.РезультатПроверкиКурирующимЧП")	Тогда
		МаркерЭтапа = ЗаявкаПрошлаСогласованиеКурирующимЧП; 
		//SmartTec Рамиль +
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.РезультатПроверкиМенеджераФД") Тогда
		// {{ Начало Аксиома: Попов В.С. 01.06.2024 18:47
		//МаркерЭтапа = "Разрешено";
		МаркерЭтапа = ЗаявкаПрошлаСогласованиеМенеджераФД;
		// }} Окончание  Аксиома: Попов В.С.
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.РезультатПроверкиДиректораФД") Тогда
		// {{ Начало Аксиома: Попов В.С. 01.06.2024 18:47
		//МаркерЭтапа = "Разрешено";
		МаркерЭтапа = ЗаявкаПрошлаСогласованиеДиректораФД;
		// }} Окончание  Аксиома: Попов В.С.
		//SmartTec Рамиль -
	ИначеЕсли ТекущаяТочка = ПредопределенноеЗначение("БизнесПроцесс.СогласованиеПлатежей.ТочкаМаршрута.РезультатПроверкиСогласующий")	Тогда
		МаркерЭтапа = ЗаявкаПрошлаСогласованиеСогласующим; 	
	КонецЕсли;
	
	ОбработатьВыборВарианта(ТочкаВыбораВарианта, Результат, МаркерЭтапа);	
		
КонецПроцедуры

Процедура Условие1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Если ЗначениеЗаполнено(Согласующий) Тогда
		Результат = Истина
	Иначе
		Результат = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура Условие2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Если ЗначениеЗаполнено(МенеджерФД) Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	КомментарииПроцесса.Очистить();
КонецПроцедуры


