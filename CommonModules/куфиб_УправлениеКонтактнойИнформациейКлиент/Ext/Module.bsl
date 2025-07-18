﻿///////////////////////////////////
//Перем мРедактируемаяЗапись Экспорт;

//Перем мФормаВладелец;

//Перем мОграниченныйСписокТиповОбъекта Экспорт;

//Перем мВозвратСтруктуры Экспорт;

///////////////////////////////////

//Функции модуля

// Функция формирует строку с названием адресного элемента,
// которое состоит из наименования и сокращения
//
// Параметры:
//  АдресныйЭлемент - элемент справочника Адресный классфикатор.
//
// Возвращаемое значение:
//  Название адресного элемента
//
Функция ПолучитьНазвание(АдресныйЭлемент) Экспорт

	Если АдресныйЭлемент.Код = 0 Тогда
		Возврат "";
	Иначе
		Возврат СокрЛП(АдресныйЭлемент.Наименование) + " " + СокрЛП(АдресныйЭлемент.Сокращение)
	КонецЕсли;

КонецФункции // ПолучитьНазвание()

Функция ПолучитьИмяФормы(Тип) Экспорт
	Если Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Возврат "УправляемаяФормаЗаписиАдреса";
	ИначеЕсли Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
		Возврат "УправляемаяФормаЗаписиАдресаЭП";
	ИначеЕсли Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
		Возврат "УправляемаяФормаЗаписиВебСтраницы";
	ИначеЕсли Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		Возврат "УправляемаяФормаЗаписиТелефона";
	Иначе
		Возврат "УправляемаяФормаЗаписи";
	КонецЕсли;
КонецФункции

// Функция вызывается при начале выбора объекта контактной информации
//
// Параметры
//  ФормаЗаписи - форма записи регистра сведений КонтактнаяИнформация
//  Элемент - элемент формы записи регистра сведений КонтактнаяИнформация,
//  значение которого выбирается.
//
// Возвращаемое значение:
//   Булево - продолжить стандартную операцию выбора или нет.
//
Функция НачалоВыбораОбъектаКИ(ФормаЗаписи, Элемент, ТекущийПользователь, ТолькоВнешниеОбъекты = Ложь) Экспорт

	//Если Элемент.Значение <> Неопределено Тогда
	Если Элемент <> "" Тогда
		Возврат Истина;
	КонецЕсли; 
	
	СписокТиповОбъектов = Новый СписокЗначений;

	МассивТипов = ?(Элемент.ОграничениеТипа.Типы().Количество()>0, Элемент.ОграничениеТипа.Типы(), Элемент.ТипЗначения.Типы());
	Для каждого Тип Из МассивТипов Цикл
		НовыйТип = Новый(Тип);
		Если ТолькоВнешниеОбъекты И (Тип = Тип("СправочникСсылка.Пользователи") ИЛИ Тип = Тип("СправочникСсылка.Организации")) Тогда
			Продолжить;
		КонецЕсли; 
		СписокТиповОбъектов.Добавить(НовыйТип.Ссылка.Метаданные().Имя, НовыйТип.Ссылка.Метаданные().Синоним);
	КонецЦикла;

	Если СписокТиповОбъектов.Количество() = 1 Тогда
		ВыбранноеЗначениеСписка = СписокТиповОбъектов[0];
	Иначе
		ВыбранноеЗначениеСписка = ФормаЗаписи.ВыбратьИзСписка(СписокТиповОбъектов, Элемент);
	КонецЕсли;
	
	Если ВыбранноеЗначениеСписка = Неопределено Тогда
		Возврат Ложь;
	Иначе
		//Элемент.Значение = Справочники[ВыбранноеЗначениеСписка.Значение].ПустаяСсылка();
		Элемент = ПредопределенноеЗначение("Справочник."+ВыбранноеЗначениеСписка.Значение+".ПустаяСсылка");
		Возврат Истина;
	КонецЕсли;

КонецФункции

// Функция формирует строку с полным названием адресного элемента,
// которое состоит из наименования и сокращения самого адресного
// элемента и его "родителей"
//
// Параметры:
//  КодЭлемента - Код адресного элемента.
//
// Возвращаемое значение:
//  Название адресного элемента и его родителей через запятую
//
Функция ПолучитьПолноеНазвание(Знач КодЭлемента) Экспорт

	КодОбласти = Цел(КодЭлемента / куфиб_УправлениеКонтактнойИнформацией.МаскаОбласти());
	КодЭлемента = КодЭлемента % куфиб_УправлениеКонтактнойИнформацией.МаскаОбласти();

	КодРайона = Цел(КодЭлемента / куфиб_УправлениеКонтактнойИнформацией.МаскаРайона());
	КодЭлемента = КодЭлемента % куфиб_УправлениеКонтактнойИнформацией.МаскаРайона();

	КодНаселенногоПункта = КодЭлемента;
	КодЭлемента = КодЭлемента;

	Название = "";
	НовыйКод = 0;

	Если КодОбласти > 0 Тогда
		НовыйКод = КодОбласти * куфиб_УправлениеКонтактнойИнформацией.МаскаОбласти();
		Название = Название + ", " + ПолучитьНазвание(куфиб_УправлениеКонтактнойИнформацией.ПолучитьСтруктуруАдресногоЭлемента(НовыйКод));
	КонецЕсли;

	Если КодРайона > 0 Тогда
		НовыйКод = НовыйКод + КодРайона * куфиб_УправлениеКонтактнойИнформацией.МаскаРайона();
		Название = Название + ", " + ПолучитьНазвание(куфиб_УправлениеКонтактнойИнформацией.ПолучитьСтруктуруАдресногоЭлемента(НовыйКод));
	КонецЕсли;

	Если КодНаселенногоПункта > 0 Тогда
		НовыйКод = НовыйКод + КодНаселенногоПункта;
		Название = Название + ", " + ПолучитьНазвание(куфиб_УправлениеКонтактнойИнформацией.ПолучитьСтруктуруАдресногоЭлемента(НовыйКод));
	КонецЕсли;

	Если СтрДлина(Название) > 2 Тогда
		Название = Сред(Название, 3);
	КонецЕсли;

	Возврат Название;

КонецФункции // ПолучитьПолноеНазвание()

// Процедура устанавливает запись контактной информации определенного типа и вида основной
// для объекта в пространстве одного типа.
//
// Параметры:
//  СтруктураПараметров - структура, параметры записи, для которой надо установить признак основной
//   Ключи:
//    Объект, СправочникСсылка, значение измерния Объект регистра сведений
//    Тип, ПеречислениеСсылка.ТипыКонтактнойИнформации
//    Вид, СправочникСсылка.ВидыКонтактнойИнформации
//
Функция УстановитьЗаписьОсновной(НаборЗаписей, ТабличноеПоле, Кнопка) Экспорт
	//НаборЗаписей = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
	//НаборЗаписей.Загрузить(НаборЗаписейРегистра.Выгрузить);
	Если ТабличноеПоле.ТекущиеДанные <> Неопределено
	   И ЗначениеЗаполнено(ТабличноеПоле.ТекущиеДанные.Представление) Тогда
		Если ТабличноеПоле.ТекущиеДанные.ЗначениеПоУмолчанию Тогда
			ТабличноеПоле.ТекущиеДанные.ЗначениеПоУмолчанию = Ложь;
			Кнопка.Пометка = Ложь;
		Иначе
			Для каждого ЗаписьНабора Из НаборЗаписей Цикл
				Если ЗаписьНабора.Тип = ТабличноеПоле.ТекущиеДанные.Тип Тогда
					ЗаписьНабора.ЗначениеПоУмолчанию = Ложь;
				КонецЕсли; 
			КонецЦикла;
			ТабличноеПоле.ТекущиеДанные.ЗначениеПоУмолчанию = Истина;
			Кнопка.Пометка = Истина;
		КонецЕсли; 
	КонецЕсли;
	//Возврат НаборЗаписейРегистра;
КонецФункции // УстановитьЗаписьОсновной()

// Функция раскладывает номер телефона, по полям для записи в КИ объекта
//
// Параметры
//  
//  НомерТелефона - строка, номер телефона для преобразования
//
// Возвращаемое значение:
//   Список значений
//
Функция РазложитьТелефонПоПолям(НомерТелефона) Экспорт
	КодСтраны			= "";
	НачалоКодаСтраны	= Найти(НомерТелефона, "+");
	Если НачалоКодаСтраны > 0 Тогда
		Для а = (НачалоКодаСтраны + 1) По СтрДлина(НомерТелефона) Цикл
			
			Если Сред(НомерТелефона, а, 1) = " " Тогда
				Прервать;
			КонецЕсли; 
			
			КодСтраны = КодСтраны + Сред(НомерТелефона, а, 1);
			
		КонецЦикла; 
	КонецЕсли; 
	КодСтраны = СокрЛП(КодСтраны);
	КодГорода = "";
	Если СтрЧислоВхождений(НомерТелефона, "(") = 1 И СтрЧислоВхождений(НомерТелефона, ")") = 1 Тогда
		НачалоКодаГорода = Найти(НомерТелефона, "(");
		КонецКодаГорода = Найти(НомерТелефона, ")");
		Если КонецКодаГорода > НачалоКодаГорода Тогда
			КодГорода = Сред(НомерТелефона, (НачалоКодаГорода + 1), (КонецКодаГорода - НачалоКодаГорода - 1));
		КонецЕсли;
	КонецЕсли;
	КодГорода	= СокрЛП(КодГорода);
	СамТелефон	= НомерТелефона;
	Если НЕ ПустаяСтрока(КодСтраны) Тогда
		СамТелефон = СтрЗаменить(СамТелефон, ("+" + КодСтраны), "");
		СамТелефон = СокрЛП(СамТелефон);
	КонецЕсли;
	Если НЕ ПустаяСтрока(КодГорода) Тогда
		СамТелефон = СтрЗаменить(СамТелефон, ("(" + КодГорода + ")"), "");
		СамТелефон = СокрЛП(СамТелефон);
	КонецЕсли;
	а = 1;
	Пока а <= СтрДлина(СамТелефон) Цикл
		Если (КодСимвола(Сред(СамТелефон, а, 1)) >= 48 И КодСимвола(Сред(СамТелефон, а, 1)) <= 57) 
		 ИЛИ КодСимвола(Сред(СамТелефон, а, 1)) = 32 Тогда
			а = а + 1;
			Продолжить;
		КонецЕсли;
		СамТелефон = Сред(СамТелефон, 1, (а - 1)) + Сред(СамТелефон, (а + 1));
	КонецЦикла; 
	Если НЕ ПустаяСтрока(КодСтраны) И Лев(СокрЛ(КодСтраны), 1) <> "+" Тогда
		КодСтраны = СокрЛП(КодСтраны);
		Пока Лев(КодСтраны, 1) = "0" Цикл
			КодСтраны = Сред(КодСтраны, 2);
		КонецЦикла;
		Если НЕ ПустаяСтрока(КодСтраны) Тогда
			КодСтраны = "+" + КодСтраны;
		КонецЕсли;
	КонецЕсли; 
	СтруктураПолейТелефона = Новый Структура("КодСтраны,КодГорода,СамТелефон", КодСтраны, КодГорода, ПривестиНомерТелефонаКШаблону(СамТелефон));
	Возврат СтруктураПолейТелефона;
КонецФункции // РазложитьТелефонПоПолям()

// Функция приводит телефонный номер к одному из указанных в настройке шаблонов
//
// Параметры
//  НомерТЛФ – строка, номер телефона, который надо преобразовывать
//
// Возвращаемое значение:
//   Приведенный номер – строка, номер, приведенный к одному из шаблонов
//
Функция ПривестиНомерТелефонаКШаблону(НомерТЛФ) Экспорт
	
	ТолькоЦифрыНомера		= "";
	КоличествоЦифрНомера	= 0;
	
	Для а = 1 По СтрДлина(НомерТЛФ) Цикл
		
		Если СтрЧислоВхождений("1234567890",Сред(НомерТЛФ,а,1)) > 0 Тогда
			КоличествоЦифрНомера	= КоличествоЦифрНомера + 1;
			ТолькоЦифрыНомера		= ТолькоЦифрыНомера + Сред(НомерТЛФ,а,1);
		КонецЕсли;
		
	КонецЦикла;
	
	Если КоличествоЦифрНомера = 0 Тогда
		Возврат НомерТЛФ;
	КонецЕсли;
	
	СтруктураШаблонов = куфиб_УправлениеКонтактнойИнформацией.ПолучитьОпределения("Константы.ШаблоныТелефонныхНомеров.Получить().Получить()",);
	
	Если ТипЗнч(СтруктураШаблонов) <> Тип("Соответствие") Тогда
		Возврат НомерТЛФ;
	КонецЕсли;
	
	ПолученныйШаблон = СтруктураШаблонов.Получить(КоличествоЦифрНомера);
	
	Если ПолученныйШаблон = Неопределено Тогда
		Возврат НомерТЛФ;
	КонецЕсли;
	
	ПриведенныйНомер	= "";
	НомерЦифры			= 0;
	
	Для а=1 По СтрДлина(ПолученныйШаблон) Цикл
		
		Если Сред(ПолученныйШаблон,а,1) = "9" Тогда
			НомерЦифры = НомерЦифры + 1;
			ПриведенныйНомер = ПриведенныйНомер + Сред(ТолькоЦифрыНомера,НомерЦифры,1);
		Иначе
			ПриведенныйНомер = ПриведенныйНомер + Сред(ПолученныйШаблон,а,1);
		КонецЕсли;
		
	КонецЦикла; 

	Возврат ПриведенныйНомер;
	
КонецФункции // ПривестиНомерТелефонаКШаблону()

// Функция проверяет строку на наличие значимых символов
//
// Параметры
//  ВыбСтрока  – строка для проверки
// Возвращаемое значение:
//   Строка - пробел или пустое значение строки
//
Функция ПроверкаПустойСтроки(ВыбСтрока, ПризнакЗапятой=Истина)
	
	Если ПустаяСтрока(ВыбСтрока) Тогда
		Возврат "";
	Иначе
		Возврат ?(ПризнакЗапятой,",","")+" ";
	КонецЕсли; 
	
КонецФункции // ПроверкаПустойСтроки()

//функция сохраняет контактную информацию в структуре для передачи родительской форме
Функция СохранениеКИ(Объект, Параметры) Экспорт
	СтруктураАдреса = Новый Структура;
	СтруктураАдреса.Вставить("Представление",  Объект.Представление);
	Для а = 1 По 10 Цикл
		СтруктураАдреса.Вставить("Поле" + Строка(а), Объект["Поле" + Строка(а)]);
	КонецЦикла;
	СтруктураАдреса.Вставить("Тип",Объект.Тип);
	СтруктураАдреса.Вставить("Вид",Объект.Вид);
	СтруктураАдреса.Вставить("Объект",Объект.Объект);
	СтруктураАдреса.Вставить("Комментарий",Объект.Комментарий);
	СтруктураАдреса.Вставить("НовыйЭлемент",Параметры.НовыйЭлемент);
	
	СтруктураАдреса.Вставить("СтарыйВид",Параметры.СтарыйВид);
	СтруктураАдреса.Вставить("СтарыйТип",Параметры.СтарыйТип);
	СтруктураАдреса.Вставить("СтарыйПредставление",Параметры.СтарыйПредставление);
	
	Возврат СтруктураАдреса;
	
	//ОсновныеДействияФормыОКНаСервере();
КонецФункции

// Процедура выполняется при активизации строки табличного поля, в котором
// отображается контактная информация объектов в их формах, и управляет
// доступностью кнопки командной пенели установки значения по умолчанию.
//
// Параметры:
//  Элемент - ТабличноеПоле
//  КнопкаУстановитьОсновным - Кнопка командной панели
//
Процедура КонтактнаяИнформацияПриАктивизацииСтрокиТаблицы(Элемент, КнопкаУстановитьОсновным) Экспорт
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если Элемент.ТекущиеДанные.ЗначениеПоУмолчанию Тогда
			КнопкаУстановитьОсновным.Пометка     = Истина;
			КнопкаУстановитьОсновным.Доступность = Истина;
		ИначеЕсли НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Представление) Тогда
			КнопкаУстановитьОсновным.Пометка     = Ложь;
			КнопкаУстановитьОсновным.Доступность = Ложь;
		Иначе
			КнопкаУстановитьОсновным.Пометка     = Ложь;
			КнопкаУстановитьОсновным.Доступность = Истина;
		КонецЕсли; 
	Иначе
		КнопкаУстановитьОсновным.Пометка     = Ложь;
		КнопкаУстановитьОсновным.Доступность = Ложь;
	КонецЕсли; 
КонецПроцедуры // КонтактнаяИнформацияПриАктивизацииСтрокиТаблицы()

 //Обработчик события "ПередНачаломДобавления" табличного поля
 //набора записей регистра сведений
 //ТекущиеДанные, РедактированиеТекста, НаборКонтактнойИнформации
Процедура КонтактнаяИнформацияПередНачаломДобавленияОбработкаДоступностиЭлементовОбщее(Отказ,Элемент, ОбъектСсылка, Копирование, РедактироватьКИВДиалоге) Экспорт
Если ЗначениеЗаполнено(ОбъектСсылка) ИЛИ ОбъектСсылка = Неопределено Тогда
	Если Не Копирование Тогда
		Если РедактироватьКИВДиалоге Тогда
			Отказ = Истина;
			Меню = Новый СписокЗначений();
			Для а = 0 По (куфиб_УправлениеКонтактнойИнформацией.ПолучитьОпределения("Перечисления.ТипыКонтактнойИнформации.Количество",)-1) Цикл
				Меню.Добавить(куфиб_УправлениеКонтактнойИнформацией.ПолучитьОпределения("Перечисления.ТипыКонтактнойИнформации[а]",а),куфиб_УправлениеКонтактнойИнформацией.ПолучитьОпределения("Перечисления.ТипыКонтактнойИнформации[а]",а));
			КонецЦикла;
			ВыбранныйПункт = Меню.ВыбратьЭлемент("Выберите тип контактной информации");
			Если ВыбранныйПункт <> Неопределено Тогда
				Тип = ВыбранныйПункт.Значение;
				куфиб_УправлениеКонтактнойИнформациейКлиент.УстановитьПараметрыОкна(Отказ,ОбъектСсылка,Элемент, РедактироватьКИВДиалоге, истина, Тип, Ложь)
			КонецЕсли;
		КонецЕсли;
	Иначе
		куфиб_УправлениеКонтактнойИнформациейКлиент.УстановитьПараметрыОкна(Отказ,ОбъектСсылка,Элемент, РедактироватьКИВДиалоге, ложь, Тип, Ложь)
	КонецЕсли;
Иначе
	Отказ = Истина;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Сначала необходимо записать объект";
	Сообщение.Сообщить();
КонецЕсли;
КонецПроцедуры

 //Обработчик события "ПередНачаломИзменения" табличного поля
 //набора записей регистра сведений
Процедура КонтактнаяИнформацияПередНачаломИзмененияОбщее(Элемент, Отказ, мКнопкаРедактироватьКИВДиалоге, ДоступностьОбъекта = Истина, Форма = Неопределено) Экспорт
	Если мКнопкаРедактироватьКИВДиалоге.Пометка Тогда
		Отказ = Истина;
		//ОбработкаРедактирования = Обработки.РедактированиеКонтактнойИнформации.Создать();
		//ОбработкаРедактирования.ДоступностьОбъекта = ДоступностьОбъекта;
		//ОбработкаРедактирования.РедактироватьЗапись(Элемент.ТекущиеДанные, , Форма);
	Иначе
		куфиб_УправлениеКонтактнойИнформацией.УстановитьВозможностьРедактированияТекстаКИ(Элемент);
	КонецЕсли; 
КонецПроцедуры


// Процедура открывает форму справочника ВидыКонтактнойИнформации для выбора.
//
// Параметры:
//  РеджимВыбора - булево, задает режим выбора для открываемой формы.
//  ВладелецФормы - задает владельца для открываемой формы.
//  ЗначениеОтбораПоТипу - задает значение отбора по типу конт.инф.
//  ЗначениеОтбораПоВидуОбъектаКИ - задает значение отбора по виду объекта конт.инф.
Процедура ОткрытьФормуВыбораВидаКИ(РежимВыбора, ВладелецФормы, ЗначениеОтбораПоТипу = Неопределено, ЗначениеОтбораПоВидуОбъектаКИ = Неопределено) Экспорт
	//ПараметрыФормы = Новый Структура;
	//СтрокаПараметра = Новый Структура;
	//Если ЗначениеОтбораПоТипу <> Неопределено Тогда
	//	СтрокаПараметра.Вставить("Тип", ЗначениеОтбораПоТипу);
	//КонецЕсли;
	//Если ЗначениеОтбораПоВидуОбъектаКИ <> Неопределено Тогда
	//	СтрокаПараметра.Вставить("ВидОбъектаКонтактнойИнформации",ЗначениеОтбораПоВидуОбъектаКИ);
	//КонецЕсли;
	//ПараметрыФормы.Вставить("Отбор", СтрокаПараметра);
	//ВыбФорма = ПолучитьФорму("Справочник.ВидыКонтактнойИнформации.ФормаВыбора",ПараметрыФормы ,ВладелецФормы);
	//Если ТипЗнч(ВладелецФормы) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") И ЗначениеЗаполнено(ВладелецФормы) Тогда
	//	ВыбФорма.ПараметрТекущаяСтрока = ВладелецФормы;
	//КонецЕсли; 
	//ВыбФорма.Открыть();
	ПараметрыФормы = Новый Структура;
	СтрокаПараметра = Новый Структура;
	Если ЗначениеОтбораПоТипу <> Неопределено Тогда
		СтрокаПараметра.Вставить("Тип", ЗначениеОтбораПоТипу);
	КонецЕсли;
	Если ЗначениеОтбораПоВидуОбъектаКИ <> Неопределено Тогда
		СтрокаПараметра.Вставить("ВидОбъектаКонтактнойИнформации",ЗначениеОтбораПоВидуОбъектаКИ);
	КонецЕсли;
	ПараметрыФормы.Вставить("Отбор", СтрокаПараметра);
	//ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ВыбФорма = ОткрытьФорму("Справочник.ВидыКонтактнойИнформации.Форма.УправляемаяФормаВыбора",ПараметрыФормы ,ВладелецФормы);
	Если ТипЗнч(ВладелецФормы) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") И ЗначениеЗаполнено(ВладелецФормы) Тогда
		ВыбФорма.ПараметрТекущаяСтрока = ВладелецФормы;
	КонецЕсли;
	
	//ВыбФорма.Открыть();
КонецПроцедуры // ОткрытьФормуВыбораВидаКИ()

Процедура УстановитьПараметрыОкна(Отказ,ОбъектСсылка,Элемент,РедактироватьКИВДиалоге, НовыйЭлемент, Тип, РедактироватьОбъект) Экспорт
Если ЗначениеЗаполнено(ОбъектСсылка) ИЛИ ОбъектСсылка = Неопределено Тогда
	Если РедактироватьКИВДиалоге Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		Если Не НовыйЭлемент тогда
			ВыбраннаяФорма = куфиб_УправлениеКонтактнойИнформациейКлиент.ПолучитьИмяФормы(Элемент.ТекущиеДанные.Тип);
			ПараметрыФормы.Вставить("Объект",ОбъектСсылка);
			ПараметрыФормы.Вставить("Вид",Элемент.ТекущиеДанные.Вид);
			ПараметрыФормы.Вставить("Тип",Элемент.ТекущиеДанные.Тип);
			ПараметрыФормы.Вставить("ЗначениеПоУмолчанию",Элемент.ТекущиеДанные.ЗначениеПоУмолчанию);
			ПараметрыФормы.Вставить("Комментарий",Элемент.ТекущиеДанные.Комментарий);
			ПараметрыФормы.Вставить("Поле1",Элемент.ТекущиеДанные.Поле1);
			ПараметрыФормы.Вставить("Поле2",Элемент.ТекущиеДанные.Поле2);
			ПараметрыФормы.Вставить("Поле3",Элемент.ТекущиеДанные.Поле3);
			ПараметрыФормы.Вставить("Поле4",Элемент.ТекущиеДанные.Поле4);
			ПараметрыФормы.Вставить("Поле5",Элемент.ТекущиеДанные.Поле5);
			ПараметрыФормы.Вставить("Поле6",Элемент.ТекущиеДанные.Поле6);
			ПараметрыФормы.Вставить("Поле7",Элемент.ТекущиеДанные.Поле7);
			ПараметрыФормы.Вставить("Поле8",Элемент.ТекущиеДанные.Поле8);
			ПараметрыФормы.Вставить("Поле9",Элемент.ТекущиеДанные.Поле9);
			ПараметрыФормы.Вставить("Поле10",Элемент.ТекущиеДанные.Поле10);
			ПараметрыФормы.Вставить("ПользовательЛичногоКонтакта",Элемент.ТекущиеДанные.ПользовательЛичногоКонтакта);
			ПараметрыФормы.Вставить("Представление",Элемент.ТекущиеДанные.Представление);
			ПараметрыФормы.Вставить("РедактироватьОбъект",РедактироватьОбъект);
		Иначе
			ВыбраннаяФорма = куфиб_УправлениеКонтактнойИнформациейКлиент.ПолучитьИмяФормы(Тип);
			ПараметрыФормы.Вставить("Объект",ОбъектСсылка);
			ПараметрыФормы.Вставить("Тип",Тип);
			ПараметрыФормы.Вставить("РедактироватьОбъект",РедактироватьОбъект);
		КонецЕсли;
		ПараметрыФормы.Вставить("НовыйЭлемент", НовыйЭлемент);
		
		ОткрытьФорму("Обработка.общ_РедактированиеКонтактнойИнформации.Форма."+ВыбраннаяФорма,ПараметрыФормы,Элемент);
	КонецЕсли;
Иначе
	Отказ = Истина;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Сначала необходимо записать объект";
	Сообщение.Сообщить();
КонецЕсли;

КонецПроцедуры

// Обработчик события "ПриНачалеРедактирования" табличного поля
// набора записей регистра сведений
//
Процедура КонтактнаяИнформацияПриНачалеРедактированияОбщая(Элемент, НоваяСтрока, ПоследнееЗначениеЭлементаТайпингаВидаКИ) Экспорт
	Если НоваяСтрока Тогда
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Тип) Тогда
			Элемент.ТекущиеДанные.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес");
		КонецЕсли; 
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Вид) Тогда
			Элемент.ТекущиеДанные.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ПустаяСсылка");
		КонецЕсли; 
	КонецЕсли; 
	
	ПоследнееЗначениеЭлементаТайпингаВидаКИ = Элемент.ТекущиеДанные.Вид;
	
КонецПроцедуры

// Обработчик события "ПриИзменении" представления КИ табличного поля
// набора записей регистра сведений
//
Процедура КонтактнаяИнформацияПредставлениеПриИзмененииОбщая(Элемент, ТабличноеПоле) Экспорт
	Если ТабличноеПоле.ТекущиеДанные.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		СтруктураПолей = РазложитьТелефонПоПолям(Элемент.ТекстРедактирования);
		ТабличноеПоле.ТекущиеДанные.Поле3 = СтруктураПолей.СамТелефон;
		ТабличноеПоле.ТекущиеДанные.Поле1 = СтруктураПолей.КодСтраны;
		ТабличноеПоле.ТекущиеДанные.Поле2 = СтруктураПолей.КодГорода;
		СформироватьПредставлениеТелефона(ТабличноеПоле.ТекущиеДанные);
	КонецЕсли; 
КонецПроцедуры // КонтактнаяИнформацияПредставлениеПриИзмененииОбщая()

// Процедура формирует строковое представление телефона
//
Процедура СформироватьПредставлениеТелефона(НаборПолей) Экспорт

	НаборПолей.Представление = НаборПолей.Поле1;
	НаборПолей.Представление = НаборПолей.Представление + ?((Не ПустаяСтрока(НаборПолей.Поле2)),(ПроверкаПустойСтроки(НаборПолей.Представление, Ложь)+"(" + НаборПолей.Поле2 + ")"),"");
	НаборПолей.Представление = НаборПолей.Представление + ?((Не ПустаяСтрока(НаборПолей.Поле3)),(ПроверкаПустойСтроки(НаборПолей.Представление, ПустаяСтрока(НаборПолей.Поле2)) + ПривестиНомерТелефонаКШаблону(НаборПолей.Поле3)),"");
	
	Если НЕ ПустаяСтрока(НаборПолей.Представление) Тогда
		НаборПолей.Представление = НаборПолей.Представление + ?((Не ПустаяСтрока(НаборПолей.Поле4)),(ПроверкаПустойСтроки(НаборПолей.Представление) + "доб. " + ПривестиНомерТелефонаКШаблону(НаборПолей.Поле4)),"");
	Иначе
		НаборПолей.Представление = ПривестиНомерТелефонаКШаблону(НаборПолей.Поле4);
	КонецЕсли; 

КонецПроцедуры // СформироватьПредставление()

// Обработчик события "ПередОкончаниемРедактирования" табличного поля
// набора записей регистра сведений
//
Процедура КонтактнаяИнформацияПередОкончаниемРедактированияОбщая(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ, мТекстТайпингаВидаКИ, мОбработкаТайпингаВидаКИ) Экспорт
	Если мОбработкаТайпингаВидаКИ И НЕ НоваяСтрока Тогда
		мОбработкаТайпингаВидаКИ = Ложь;
		Отказ = Истина;
		Элемент.ТекущаяКолонка = Элемент.Колонки.Вид;
		Элемент.Колонки.Вид.ЭлементУправления.ВыделенныйТекст = мТекстТайпингаВидаКИ;
		мТекстТайпингаВидаКИ = "";
	КонецЕсли; 
КонецПроцедуры

// Обработчик события "ПриИзменении" Типа КИ табличного поля
// набора записей регистра сведений
//
Процедура КонтактнаяИнформацияТипПриИзмененииОбщее(Элемент, ТабличноеПоле) Экспорт
	Если (ТабличноеПоле.ТекущиеДанные <> Неопределено)
	   И ЗначениеЗаполнено(ТабличноеПоле.ТекущиеДанные.Вид)
	   И ТипЗнч(ТабличноеПоле.ТекущиеДанные.Вид) = Тип("СправочникСсылка.ВидыКонтактнойИнформации")
	   И ТабличноеПоле.ТекущиеДанные.Вид.Тип <> Элемент.Значение Тогда
		ТабличноеПоле.ТекущиеДанные.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ПустаяСсылка");
	КонецЕсли; 
КонецПроцедуры


/////////////////////////////////////////////////////////////
//Функция ОпределениеПеременныхМодуля(ИдентификаторФормы)
//КонецФункции


