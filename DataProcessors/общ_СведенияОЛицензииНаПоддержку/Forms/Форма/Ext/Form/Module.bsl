﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПрефиксПродукта", ПрефиксПродукта);
	Если ПрефиксПродукта = "" Тогда
		ПрефиксПродукта = общ_ПроцедурыМеханизмаЗащиты.ПрефиксПрикладногоРешения();
	КонецЕсли;
		
	ОбновитьИнформациюОПодписке();
	
	Организация = "<Укажите название организации>";
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = "Организация: " + Организация;
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
	|Регистрационный номер отраслевого решения: " + ?(ЗначениеЗаполнено(Объект.НомерРегистрационнойАнкеты),Объект.НомерРегистрационнойАнкеты,"<Укажите номер регистрационной анкеты>");
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
	|Категория оформленной поддержки: " + ?(ЗначениеЗаполнено(КатегорияОформленнойПодписки),КатегорияОформленнойПодписки,"<не определено>");
	
	ИмяКонфигурации = Вычислить(ПрефиксПродукта + "ПроцедурыМеханизмаЗащиты.ИмяМетаданных()");
	
	Если ИмяКонфигурации = Метаданные.Имя Тогда
		ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
		|Программный продукт: " + Метаданные.Синоним;
	Иначе
		ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
		|Программный продукт: " + ИмяКонфигурации;
		ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
		|Базовый программный продукт: " + Метаданные.Синоним;
	КонецЕсли;
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
	|Версия отраслевого решения: " + Вычислить(ПрефиксПродукта + "ПроцедурыМеханизмаЗащиты.ВерсияМетаданных()");
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
	|Версия библиотек защиты отраслевого решения: " + Вычислить(ПрефиксПродукта + "ПроцедурыМеханизмаЗащиты.ВерсияБиблиотекЗащиты()");
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ТекущаяВерсия = СистемнаяИнформация.ВерсияПриложения;
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
	|Версия платформы 1С:Предприятие: " + ТекущаяВерсия;
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
	|Режим запуска: " + ТекущийРежимЗапуска();
	
	ФайловаяБаза = ОпределитьЭтаИнформационнаяБазаФайловая();
	
	ИнформацияДляОбращенияНаЛиниюКонсультаций = ИнформацияДляОбращенияНаЛиниюКонсультаций + "
	| " + ?(ФайловаяБаза,"Файловый режим","Клиент-серверный режим
	|Используемый сервер: <Укажите используемый сервер>");
	
	ПочтовыйАдресЛК = Вычислить(ПрефиксПродукта + "ОбщегоНазначения.ПочтовыйАдресЛК()");
	
	Элементы.ВыполнитьАктивациюПодписки.Доступность = Вычислить("фин_ОбщегоНазначенияСервер.ПравоРедактированияСведенийОЛицензииНаПоддержку()");
	
	Элементы.НастройкаСвязиССерверомЛицензий.Видимость = Вычислить("фин_ОбщегоНазначенияСервер.ПравоРедактированияПутиСЛК()");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДекорацияИнформацияНажатие(Элемент)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ЗапуститьПриложение("http://1c-rating.kz/sol/support");
	#Иначе
		ПерейтиПоНавигационнойСсылке("http://1c-rating.kz/sol/support");
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДанныеДляАктивацииВДругихИБЛокальнойСети(Команда)
	
	Попытка
		ОткрытьФорму(ИмяФормыОбработки()+".Форма.ДанныеАктивации",Новый Структура("ПрефиксПродукта",ПрефиксПродукта),ЭтаФорма,УникальныйИдентификатор,ВариантОткрытияОкна.ОтдельноеОкно);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАктивациюПодписки(Команда)
	Попытка
		ОткрытьФорму(ИмяФормыОбработки()+".Форма.Форма",Новый Структура("ПрефиксПродукта",ПрефиксПродукта),ЭтаФорма);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСвязиССерверомЛицензий(Команда)
	
	Результат = ОткрытьФормуМодально("ОбщаяФорма."+ПрефиксПродукта+"НастройкаСвязиССерверомЛицензий",,ЭтаФорма);	
	Если Результат <> Неопределено Тогда
		ОбновитьИнформациюОПодписке();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОПодпискеКлиент() Экспорт
	
	ОбновитьИнформациюОПодписке();
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьИнформациюОПодписке()
	
	ТребуемаяКатегория = Вычислить(ПрефиксПродукта + "ЗащитаКлиентСервер.КатегорияПоддержки()");
	КатегорияПоддержки = "";
	Если ТипЗнч(ТребуемаяКатегория)=Тип("Массив") Тогда
		КатегорияПлатнойПоддержкиОтраслевогоРешения = "";
		Для Каждого ЗначениеМассива Из ТребуемаяКатегория Цикл
			КатегорияПлатнойПоддержкиОтраслевогоРешения = КатегорияПлатнойПоддержкиОтраслевогоРешения+ ?(КатегорияПлатнойПоддержкиОтраслевогоРешения="",""," или ")+ЗначениеМассива;
			КатегорияПоддержки = ""+КатегорияПоддержки+Строка(ЗначениеМассива);
		КонецЦикла;
	Иначе
		КатегорияПлатнойПоддержкиОтраслевогоРешения = ""+ТребуемаяКатегория;
		КатегорияПоддержки = ""+ТребуемаяКатегория;
	КонецЕсли;
	КатегорияПлатнойПоддержкиОтраслевогоРешения = КатегорияПлатнойПоддержкиОтраслевогоРешения + "-ая категория";

	Объект.НомерОсновногоКлюча = Константы[ПрефиксПродукта + "НомерОсновногоКлюча"].Получить();
	Объект.НомерРегистрационнойАнкеты = Константы[ПрефиксПродукта + "НомерРегистрационнойАнкеты"].Получить();
	СписокКлючей = Вычислить(ПрефиксПродукта + "ЗащитаКлиентСервер.СписокНомеровКлючей()");
	
	НомерОсновногоКлюча = Новый СписокЗначений;
	Для Каждого Ключ Из СписокКлючей Цикл
		НомерОсновногоКлюча.Добавить(Ключ);	
	КонецЦикла;
	
	ИнформацияОПодписке = Вычислить(ПрефиксПродукта + "ЗащитаКлиентСервер.ПолучитьСведенияОПоддержке()");
	Внимание = "";
	Если НЕ ЗначениеЗаполнено(ИнформацияОПодписке) Тогда
		СостояниеПодписки = "Лицензия не активирована";
		Внимание = "ВНИМАНИЕ!!! Необходимо активировать Лицензию";
		Элементы.ДанныеДляАктивацииВДругихИБЛокальнойСети.Видимость = Ложь;
	Иначе
		СостояниеПодписки = "Лицензия действительна до: " + Формат(ИнформацияОПодписке.СрокОкончанияПоддержки,"ДФ=dd.MM.yyyy") + ", оформлена на ключ защиты с серийным номером: " + ИнформацияОПодписке.НомерКлюча;
		Элементы.ДанныеДляАктивацииВДругихИБЛокальнойСети.Видимость = Истина;
		Если ИнформацияОПодписке.СрокОкончанияПоддержки < ТекущаяДата() Тогда
			Внимание = "ВНИМАНИЕ!!! Срок действующей Лицензии истек! Необходимо активировать Лицензию";
			Элементы.ДанныеДляАктивацииВДругихИБЛокальнойСети.Видимость = Ложь;
		ИначеЕсли ИнформацияОПодписке.СрокОкончанияПоддержки < ДобавитьМесяц(ТекущаяДата(),1) Тогда
			Внимание = "До окончания срока действия Лицензии осталось менее месяца! Не забудьте продлить Лицензию!";
		ИначеЕсли ИнформацияОПодписке.Свойство("КатегорияПоддержки") И Найти(КатегорияПоддержки,Строка(ИнформацияОПодписке.КатегорияПоддержки))=0 Тогда
			Элементы.ДанныеДляАктивацииВДругихИБЛокальнойСети.Видимость = Ложь;
			Внимание = "Активированная категория поддержки не соответствует категории поддержки данного программного продукта!";
		КонецЕсли;
		Если ИнформацияОПодписке.Свойство("КатегорияПоддержки") Тогда
			КатегорияОформленнойПодписки = Строка(ИнформацияОПодписке.КатегорияПоддержки);
		КонецЕсли;
		Если НомерОсновногоКлюча.НайтиПоЗначению(ИнформацияОПодписке.НомерКлюча) = Неопределено Тогда
			Внимание = Внимание + ?(Внимание = "", "", Символы.ПС) + "Отсутствует ключ защиты, на который оформлена Лицензия!";
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Внимание.Видимость = Внимание <> "";
	
КонецПроцедуры

&НаСервере
Функция ОпределитьЭтаИнформационнаяБазаФайловая()
	
	СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
	
	// в зависимости от того файловый это вариант БД или нет немного по-разному путь в БД формируется
	ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "FILE=");
	
	Возврат ПозицияПоиска = 1;	
	
КонецФункции

&НаСервере
Функция ИмяФормыОбработки()
	
	Возврат Вычислить(ПрефиксПродукта + "ЗащитаКлиентСервер.ПолучитьИмяФормыДляОткрытия()");
	
КонецФункции

#КонецОбласти