﻿Перем ЗаполнениеПараметров Экспорт;
Перем СохраненнаяНастройка Экспорт;
Перем ДополнительныеПараметры Экспорт;
Перем ПараметрыОформления Экспорт;
Перем СтруктураПеревода;
Перем КЭШ;
Перем ДоступныеПоказатели Экспорт;
Перем ДоступныеГруппировки Экспорт;
Перем ПереченьОсновныхРеквизитов Экспорт;
Перем ДополнительныеПредставления Экспорт;
Перем ДанныеРасшифровки Экспорт;
Перем ОтборыРасшифровки Экспорт;
Перем ТаблицаОтбора Экспорт;

Процедура Скомпоновать(ДокументРезультат,Отбор) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран счет! Отчет не сформирован");
		Возврат;
	КонецЕсли;
	Если Показатели.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбраны показатели отчета! Отчет не сформирован");
		Возврат;
	КонецЕсли;
	
	ТекстФильтрОстатки = "";
	МассивСубконто = Новый Массив;
	
	Для Каждого СтрокаОтбор Из Отбор Цикл
		Если СтрокаОтбор.ВидСравнения.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		ТекстУсловия = " = &ПараметрОтбора"+Строка(Отбор.Индекс(СтрокаОтбор));
		Если СтрокаОтбор.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВСписке Тогда
			ТекстУсловия = " В (&ПараметрОтбора"+Строка(Отбор.Индекс(СтрокаОтбор))+")";
		ИначеЕсли СтрокаОтбор.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеВСписке  Тогда
			ТекстУсловия = " НЕ В (&ПараметрОтбора"+Строка(Отбор.Индекс(СтрокаОтбор))+")";
		ИначеЕсли СтрокаОтбор.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВСпискеПоИерархии ИЛИ СтрокаОтбор.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.ВИерархии  Тогда
			ТекстУсловия = " В ИЕРАРХИИ (&ПараметрОтбора"+Строка(Отбор.Индекс(СтрокаОтбор))+")";
		ИначеЕсли СтрокаОтбор.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеВСпискеПоИерархии ИЛи СтрокаОтбор.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеВИерархии  Тогда
			ТекстУсловия = " НЕ В ИЕРАРХИИ (&ПараметрОтбора"+Строка(Отбор.Индекс(СтрокаОтбор))+")";
		ИначеЕсли СтрокаОтбор.ВидСравнения = Перечисления.усд_ВидыСравненияДляУсловий.НеРавно  Тогда
			ТекстУсловия = " <> &ПараметрОтбора"+Строка(Отбор.Индекс(СтрокаОтбор));
		КонецЕсли;
		Если СтрокаОтбор.ПолеОтбора = Перечисления.фин_ФактическиеПоказателиБюджетирования.Валюта Тогда
			ТекстФильтрОстатки = ТекстФильтрОстатки + ?(ТекстФильтрОстатки="",""," И ") +"Валюта "+ТекстУсловия;
		ИначеЕсли СтрокаОтбор.ПолеОтбора = Перечисления.фин_ФактическиеПоказателиБюджетирования.Организация Тогда
			ТекстФильтрОстатки = ТекстФильтрОстатки + ?(ТекстФильтрОстатки="",""," И ") +"Организация "+ТекстУсловия;
		Иначе
			НомерСубконто = 0;
			Разрез = фин_РаботаСДополнительнымиРазрезамиБюджетирования.РазрезПоИзмерению(СтрокаОтбор.ПолеОтбора);
			Если МассивСубконто.Найти(Разрез)=Неопределено Тогда
				МассивСубконто.Добавить(Разрез);
				НомерСубконто = МассивСубконто.Количество();
			Иначе
				НомерСубконто = МассивСубконто.Найти(Разрез)+1;
			КонецЕсли;
			ТекстФильтрОстатки = ТекстФильтрОстатки + ?(ТекстФильтрОстатки="",""," И ") +"Субконто"+Строка(НомерСубконто)+" "+ТекстУсловия;
		КонецЕсли;
	КонецЦикла;
	
	СоответствиеПолейИзмерениям = Новый Соответствие;
	ДополнительныеПоля = Новый Массив;
	ГруппировочныеПоля = Новый Массив;
	Для Каждого Группировка Из Группировки Цикл
		СтрокиГрупп = Группировки.НайтиСтроки(Новый Структура("Измерение",Группировка.Измерение));
		Если СтрокиГрупп.Количество()>1 Тогда
			Если Группировка <> СтрокиГрупп[0] Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если Группировка.Измерение=Перечисления.фин_ФактическиеПоказателиБюджетирования.Валюта
			ИЛИ Группировка.Измерение=Перечисления.фин_ФактическиеПоказателиБюджетирования.Организация Тогда
			ДополнительныеПоля.Добавить(фин_ОбщегоНазначенияСервер.ПолучитьИмяЭлементаПеречисленияПоЗначению(Группировка.Измерение));
			ГруппировочныеПоля.Добавить(фин_ОбщегоНазначенияСервер.ПолучитьИмяЭлементаПеречисленияПоЗначению(Группировка.Измерение));
		Иначе
			НомерСубконто = 0;
			Разрез = фин_РаботаСДополнительнымиРазрезамиБюджетирования.РазрезПоИзмерению(Группировка.Измерение);
			Если МассивСубконто.Найти(Разрез)=Неопределено Тогда
				МассивСубконто.Добавить(Разрез);
				НомерСубконто = МассивСубконто.Количество();
			Иначе
				НомерСубконто = МассивСубконто.Найти(Разрез)+1;
			КонецЕсли;
			ГруппировочныеПоля.Добавить("Субконто"+Строка(НомерСубконто));
			СоответствиеПолейИзмерениям.Вставить("Субконто"+Строка(НомерСубконто),Группировка.Измерение);
		КонецЕсли;
	КонецЦикла;
	
	Для Инд = 1 По МассивСубконто.Количество() Цикл
		ДополнительныеПоля.Добавить("Субконто"+Строка(Инд));
	КонецЦикла;
	

	// установка текста условия в текст запроса
	СхемаКомпоновкиДанных.НаборыДанных["Обороты"].Запрос = ТекстЗапросаОбороты(ТекстФильтрОстатки,МассивСубконто,ДополнительныеПоля);
	СхемаКомпоновкиДанных.НаборыДанных["Обороты"].Поля.Найти("Счет").Заголовок = фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке("Счет",ЯзыкОтчета);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	//СхемаКомпоновкиДанных.МакетыГруппировок.Очистить();
	НомерМакета = 1;
	Если ЗначениеЗаполнено(ПериодичностьОтчета) Тогда
		СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("Период").ВыражениеПредставления = "фин_УправлениеОтчетамиБюджетирование.ПредставлениеПериодаСтрокойНаЯзыке(Период,&Периодичность,&ЯзыкОтчета)";
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КонецЕсли;
	//установа параметров запроса
	Если МассивСубконто.Количество()>0 Тогда
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВидыСубконто",МассивСубконто);
	КонецЕсли;
	Для Каждого СтрокаОтбор Из Отбор Цикл
		Если СтрокаОтбор.ВидСравнения.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		ТекстУсловия = "ПараметрОтбора"+Строка(Отбор.Индекс(СтрокаОтбор));
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(ТекстУсловия,СтрокаОтбор.Значение);
	КонецЦикла;
	
		
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ТекстНачальноеСальдо",фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке("СальдоНаНачало",ЯзыкОтчета));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ТекстОбороты",фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке("Оборот",ЯзыкОтчета));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ТекстКонечноеСальдо",фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке("СальдоНаКонец",ЯзыкОтчета));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Периодичность",ПериодичностьОтчета);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Счет",Счет);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Сценарий",Сценарий);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПериода",НачалоПериода);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонецПериода",КонецДня(КонецПериода));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ЯзыкОтчета",ЯзыкОтчета);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПоСубсчетам",ПоСубсчетам);
	Если МассивСубконто.Количество()>0 Тогда
		СписокСубконто = Новый СписокЗначений;
		СписокСубконто.ЗагрузитьЗначения(МассивСубконто);
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВидыСубконто",СписокСубконто);
	КонецЕсли;
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Очистить();
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	Таблица.ПараметрыВывода.Элементы.Найти("ГоризонтальноеРасположениеОбщихИтогов").Использование = Истина;
	Таблица.ПараметрыВывода.Элементы.Найти("ГоризонтальноеРасположениеОбщихИтогов").Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	Таблица.ПараметрыВывода.Элементы.Найти("ВертикальноеРасположениеОбщихИтогов").Использование = Истина;
	Таблица.ПараметрыВывода.Элементы.Найти("ВертикальноеРасположениеОбщихИтогов").Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	
	ГруппаПолей = Таблица.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	//ГруппаПолей.Заголовок = фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке(Группа.Значение,ЯзыкОтчета);
	ГруппаПолей.Использование=Истина;
	ГруппаПолей.Расположение=РасположениеПоляКомпоновкиДанных.Вертикально;
		
	Для Каждого Показатель Из Показатели Цикл
		Имя =  фин_ОбщегоНазначенияСервер.ПолучитьИмяЭлементаПеречисленияПоЗначению(Показатель.Показатель);
		Дт = ГруппаПолей.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		Дт.Использование=Истина;
		Дт.Поле = Новый ПолеКомпоновкиДанных(Имя);
		Дт.Заголовок = фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке(Имя,ЯзыкОтчета);
	КонецЦикла;
		
	ПолеСчет = Таблица.Строки.Добавить();
	ПолеСчет.Использование = Истина;
	ПолеРазрезаАналитики=ПолеСчет.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеРазрезаАналитики.Использование	= Истина;
	ПолеРазрезаАналитики.Поле			= Новый ПолеКомпоновкиДанных("Счет");
	ПолеРазрезаАналитики.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	ВыбранныеПоляДляТекущей=ПолеСчет.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ВыбранныеПоляДляТекущей.Использование=Истина;
	
	Порядок = ПолеСчет.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Порядок.Использование = Истина;
	Порядок.Поле = Новый ПолеКомпоновкиДанных("Счет");
	Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	ПолеСчет.ПараметрыВывода.Элементы.Найти("РасположениеПолейГруппировки").Использование = Истина;
	ПолеСчет.ПараметрыВывода.Элементы.Найти("РасположениеПолейГруппировки").Значение = РасположениеПолейГруппировкиКомпоновкиДанных.Вместе;

	РодительскаяГруппировка = ПолеСчет;
	
	Для Каждого Поле Из ГруппировочныеПоля Цикл
		Если Поле<>"Счет" Тогда
			СхемаКомпоновкиДанных.НаборыДанных["Обороты"].Поля.Найти(Поле).ВыражениеПредставления = "фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке("+Поле+",&ЯзыкОтчета)";
		КонецЕсли;
		
		ПолеСубконто = РодительскаяГруппировка.Структура.Добавить();
		ПолеСубконто.Использование = Истина;
		ПолеРазрезаАналитики=ПолеСубконто.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеРазрезаАналитики.Использование	= Истина;
		ПолеРазрезаАналитики.Поле			= Новый ПолеКомпоновкиДанных(Поле);
		//ПолеСубконто.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		ВыбранныеПоляДляТекущей=ПолеСубконто.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ВыбранныеПоляДляТекущей.Использование=Истина;
		
		Порядок = ПолеСубконто.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		Порядок.Использование = Истина;
		Порядок.Поле = Новый ПолеКомпоновкиДанных(Поле);
		Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
		ПолеСубконто.ПараметрыВывода.Элементы.Найти("РасположениеПолейГруппировки").Использование = Истина;
		ПолеСубконто.ПараметрыВывода.Элементы.Найти("РасположениеПолейГруппировки").Значение = РасположениеПолейГруппировкиКомпоновкиДанных.Вместе;

		РодительскаяГруппировка = ПолеСубконто;
	КонецЦикла;
	
		
		ПолеКорсчет = Таблица.Колонки.Добавить();
		ПолеКорсчет.Использование = Истина;
		ПолеРазрезаАналитики=ПолеКорсчет.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеРазрезаАналитики.Использование	= Истина;
		ПолеРазрезаАналитики.Поле			= Новый ПолеКомпоновкиДанных("Колонка");
		
		ПолеРазрезаАналитики=ПолеКорсчет.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеРазрезаАналитики.Использование	= Истина;
		ПолеРазрезаАналитики.Поле			= Новый ПолеКомпоновкиДанных("Порядок");
		//ПолеРазрезаАналитики.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		ВыбранныеПоляДляТекущей=ПолеКорсчет.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ВыбранныеПоляДляТекущей.Использование=Истина;
	
	ПолеКорсчет.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор").Использование = Истина;
		
		Порядок = ПолеКорсчет.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		Порядок.Использование = Истина;
		Порядок.Поле = Новый ПолеКомпоновкиДанных("Колонка");
		Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
	
	Если ЗначениеЗаполнено(ПериодичностьОтчета) Тогда
		ПолеПериод = РодительскаяГруппировка.Структура.Добавить();
		ПолеПериод.Использование = Истина;
		ПолеРазрезаАналитики=ПолеПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеРазрезаАналитики.Использование	= Истина;
		ПолеРазрезаАналитики.Поле			= Новый ПолеКомпоновкиДанных("Период");
		ПолеРазрезаАналитики.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		ВыбранныеПоляДляТекущей=ПолеПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ВыбранныеПоляДляТекущей.Использование=Истина;
		
		Порядок = ПолеПериод.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		Порядок.Использование = Истина;
		Порядок.Поле = Новый ПолеКомпоновкиДанных("Период");
		Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
		ПолеПериод.ПараметрыВывода.Элементы.Найти("РасположениеПолейГруппировки").Использование = Истина;
		ПолеПериод.ПараметрыВывода.Элементы.Найти("РасположениеПолейГруппировки").Значение = РасположениеПолейГруппировкиКомпоновкиДанных.Вместе;

		РодительскаяГруппировка = ПолеПериод;
	КонецЕсли;
	
	
	
	//ПОДГОТОВКА К ВЫПОЛНЕНИЮ - ФОРМИРОВАНИЕ МАКЕТА КОМПОНОВКИ
	КомпоновщикМакета=Новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	Попытка
		МакетКомпоновки=КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,КомпоновщикНастроек.Настройки,ДанныеРасшифровки);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	//СхемаКомпоновкиДанных.НаборыДанных.Основной.Поля.Найти("Период").ВыражениеПредставления="фин_ПроцедурыМеханизмовБюджетированияКлиентСервер.ПолучитьПериодСтрокой(Период,"""+Периодичность+""")";
	
	//ВЫПОЛНЕНИЕ КОМПОНОВКИ ДАННЫХ
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,,ДанныеРасшифровки,Истина);
	
	//ВЫВОД РЕЗУЛЬТАТА В ТАБЛИЧНЫЙ ДОКУМЕНТ
	ДокументРезультат.Очистить();
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.ОтображатьПроцентВывода=Истина;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	//инициализация начала вывода
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки,Истина);

	Граница= ДокументРезультат.ФиксацияСверху;
	Для Инд = 1 по ДокументРезультат.ШиринаТаблицы Цикл
		ДокументРезультат.Область("R1C"+Строка(Инд)+":R"+Строка(Граница)+"C"+строка(Инд)).Объединить();
		ДокументРезультат.Область("R1C"+Строка(Инд)+":R"+Строка(Граница)+"C"+строка(Инд)).ВысотаСтроки=6;
	КонецЦикла;
	ОбластьВставляемая = ДокументРезультат.Область("C2");
	ДокументРезультат.ВставитьОбласть(ОбластьВставляемая,ДокументРезультат.Область("C2"),ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	ДокументРезультат.Область("C2").Очистить(Истина,Ложь,Ложь);
	ДокументРезультат.Область("C2").ГоризонтальноеПоложение =ГоризонтальноеПоложение.Лево;
	ДокументРезультат.Область("C2").РазмещениеТекста =ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	ДокументРезультат.ФиксацияСлева = 2;	
	МассивИменПоказателей = Новый Массив;
	Для Каждого Показатель Из Показатели Цикл
		МассивИменПоказателей.Добавить(фин_УправлениеОтчетамиБюджетирование.ПредставлениеПоляСтрокойНаЯзыке(фин_ОбщегоНазначенияСервер.ПолучитьИмяЭлементаПеречисленияПоЗначению(Показатель.Показатель),ЯзыкОтчета));
	КонецЦикла;
	НачальнаяЯчейка = Граница;
	Пока НачальнаяЯчейка < ДокументРезультат.ВысотаТаблицы Цикл
		Для Каждого Имя Из МассивИменПоказателей Цикл
			НачальнаяЯчейка = НачальнаяЯчейка + 1;
			ДокументРезультат.Область("R"+Строка(НачальнаяЯчейка)+"C2").Текст = Имя;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьСпискиПоказателейИГруппировок() Экспорт
	ДоступныеПоказатели = Новый СписокЗначений;
	Если Счет.Количественный Тогда
		ДоступныеПоказатели.Добавить(Перечисления.фин_РесурсыДанныхБюджетирования.Количество);
	КонецЕсли;
	Если Счет.Валютный Тогда
		ДоступныеПоказатели.Добавить(Перечисления.фин_РесурсыДанныхБюджетирования.ВалютнаяСумма);
	КонецЕсли;
	ДоступныеПоказатели.Добавить(Перечисления.фин_РесурсыДанныхБюджетирования.СуммаСценария);
	ДоступныеПоказатели.Добавить(Перечисления.фин_РесурсыДанныхБюджетирования.СуммаУпр);
	ДоступныеГруппировки = Новый СписокЗначений;
	Для Каждого СтрокаСубконто Из Счет.ВидыСубконто Цикл
		Измерение = фин_РаботаСДополнительнымиРазрезамиБюджетирования.ИзмерениеПоРазрезу(СтрокаСубконто.ВидСубконто);
		ДоступныеГруппировки.Добавить(Измерение,фин_РаботаСДополнительнымиРазрезамиБюджетирования.ПредставлениеРазреза(Измерение));
	КонецЦикла;
	ДоступныеГруппировки.Добавить(Перечисления.фин_ФактическиеПоказателиБюджетирования.Валюта,"Валюта операции");
	ДоступныеГруппировки.Добавить(Перечисления.фин_ФактическиеПоказателиБюджетирования.Организация,"Организация");
КонецПроцедуры

Функция ТекстЗапросаОбороты(ТекстФильтрОстатки,МассивВидовСубконто,ДополнительныеПоля)
	ТекстПоля = "";
	Для Каждого Поле Из ДополнительныеПоля Цикл
		Если Найти(Поле,"Субконто")=0 Тогда
			Продолжить;
		КонецЕсли;
		ТекстПоля = ТекстПоля+",
		|	Обороты."+Поле;
	КонецЦикла;
	Текст = "ВЫБРАТЬ
		|	Обороты.Счет,
		|	Обороты.Валюта,
		|	Обороты.Период КАК Период,
		|	Обороты.КоличествоНачальныйОстатокДт,
		|	Обороты.КоличествоНачальныйОстатокКт,
		|	Обороты.КоличествоКонечныйОстатокДт,
		|	Обороты.КоличествоКонечныйОстатокКт,
		|	Обороты.КоличествоОборотДт,
		|	Обороты.КоличествоОборотКт,
		|	Обороты.СуммаУпрНачальныйОстатокДт,
		|	Обороты.СуммаУпрНачальныйОстатокКт,
		|	Обороты.СуммаУпрКонечныйОстатокДт,
		|	Обороты.СуммаУпрКонечныйОстатокКт,
		|	Обороты.СуммаУпрОборотДт,
		|	Обороты.СуммаУпрОборотКт,
		|	Обороты.ВалютнаяСуммаНачальныйОстатокДт,
		|	Обороты.ВалютнаяСуммаНачальныйОстатокКт,
		|	Обороты.ВалютнаяСуммаКонечныйОстатокДт,
		|	Обороты.ВалютнаяСуммаКонечныйОстатокКт,
		|	Обороты.ВалютнаяСуммаОборотДт,
		|	Обороты.ВалютнаяСуммаОборотКт,
		|	Обороты.СуммаСценарияНачальныйОстатокДт,
		|	Обороты.СуммаСценарияНачальныйОстатокКт,
		|	Обороты.СуммаСценарияКонечныйОстатокДт,
		|	Обороты.СуммаСценарияКонечныйОстатокКт,
		|	Обороты.СуммаСценарияОборотДт,
		|	Обороты.СуммаСценарияОборотКт,
		|	Обороты.Организация"+ТекстПоля+"
		|ПОМЕСТИТЬ ВТ_Остатки
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВЫБОР
		|			КОГДА &ПоСубСчетам
		|				ТОГДА Обороты.Счет
		|			ИНАЧЕ &Счет
		|		КОНЕЦ КАК Счет,
		|		Обороты.Валюта КАК Валюта,
		|		"+?(ЗначениеЗаполнено(ПериодичностьОтчета),"Обороты.Период","ДАТАВРЕМЯ(1, 1, 1)")+" КАК Период,
		|		Обороты.КоличествоНачальныйОстатокДт КАК КоличествоНачальныйОстатокДт,
		|		Обороты.КоличествоНачальныйОстатокКт КАК КоличествоНачальныйОстатокКт,
		|		Обороты.КоличествоКонечныйОстатокДт КАК КоличествоКонечныйОстатокДт,
		|		Обороты.КоличествоКонечныйОстатокКт КАК КоличествоКонечныйОстатокКт,
		|		Обороты.КоличествоОборотДт КАК КоличествоОборотДт,
		|		Обороты.КоличествоОборотКт КАК КоличествоОборотКт,
		|		Обороты.СуммаУпрНачальныйОстатокДт КАК СуммаУпрНачальныйОстатокДт,
		|		Обороты.СуммаУпрНачальныйОстатокКт КАК СуммаУпрНачальныйОстатокКт,
		|		Обороты.СуммаУпрКонечныйОстатокДт КАК СуммаУпрКонечныйОстатокДт,
		|		Обороты.СуммаУпрКонечныйОстатокКт КАК СуммаУпрКонечныйОстатокКт,
		|		Обороты.СуммаУпрОборотДт КАК СуммаУпрОборотДт,
		|		Обороты.СуммаУпрОборотКт КАК СуммаУпрОборотКт,
		|		Обороты.ВалютнаяСуммаНачальныйОстатокДт КАК ВалютнаяСуммаНачальныйОстатокДт,
		|		Обороты.ВалютнаяСуммаНачальныйОстатокКт КАК ВалютнаяСуммаНачальныйОстатокКт,
		|		Обороты.ВалютнаяСуммаКонечныйОстатокДт КАК ВалютнаяСуммаКонечныйОстатокДт,
		|		Обороты.ВалютнаяСуммаКонечныйОстатокКт КАК ВалютнаяСуммаКонечныйОстатокКт,
		|		Обороты.ВалютнаяСуммаОборотДт КАК ВалютнаяСуммаОборотДт,
		|		Обороты.ВалютнаяСуммаОборотКт КАК ВалютнаяСуммаОборотКт,
		|		Обороты.СуммаСценарияНачальныйОстатокДт КАК СуммаСценарияНачальныйОстатокДт,
		|		Обороты.СуммаСценарияНачальныйОстатокКт КАК СуммаСценарияНачальныйОстатокКт,
		|		Обороты.СуммаСценарияКонечныйОстатокДт КАК СуммаСценарияКонечныйОстатокДт,
		|		Обороты.СуммаСценарияКонечныйОстатокКт КАК СуммаСценарияКонечныйОстатокКт,
		|		Обороты.СуммаСценарияОборотДт КАК СуммаСценарияОборотДт,
		|		Обороты.СуммаСценарияОборотКт КАК СуммаСценарияОборотКт,
		|		Обороты.Организация КАК Организация"+ТекстПоля+"
		|	ИЗ
		|		РегистрБухгалтерии.фин_Бюджетирование.ОстаткиИОбороты(&НачалоПериода, &КонецПериода,"+?(ЗначениеЗаполнено(ПериодичностьОтчета),Строка(ПериодичностьОтчета),"")+", , Счет В ИЕРАРХИИ (&Счет),"+?(МассивВидовСубконто.Количество()=0,"","&ВидыСубконто")+" , Сценарий = &Сценарий"+?(ТекстФильтрОстатки="",""," И "+ТекстФильтрОстатки)+") КАК Обороты) КАК Обороты
		|;

		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Обороты.Счет,
		|	Обороты.Валюта,
		|	Обороты.КоличествоДт,
		|	Обороты.КоличествоКт,
		|	Обороты.СуммаУпрДт,
		|	Обороты.СуммаУпрКт,
		|	Обороты.ВалютнаяСуммаДт,
		|	Обороты.ВалютнаяСуммаКт,
		|	Обороты.СуммаСценарияДт,
		|	Обороты.СуммаСценарияКт,
		|	Обороты.Организация,
		|	Обороты.Период"+ТекстПоля+"
		|ПОМЕСТИТЬ ВТ_Обороты
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВЫБОР
		|			КОГДА &ПоСубСчетам
		|				ТОГДА Обороты.Счет
		|			ИНАЧЕ &Счет
		|		КОНЕЦ КАК Счет,
		|		Обороты.Валюта КАК Валюта,
		|		Обороты.КоличествоОборотДт КАК КоличествоДт,
		|		Обороты.КоличествоОборотКт КАК КоличествоКт,
		|		Обороты.СуммаУпрОборотДт КАК СуммаУпрДт,
		|		Обороты.СуммаУпрОборотКт КАК СуммаУпрКт,
		|		Обороты.ВалютнаяСуммаОборотДт КАК ВалютнаяСуммаДт,
		|		Обороты.ВалютнаяСуммаОборотКт КАК ВалютнаяСуммаКт,
		|		Обороты.СуммаСценарияОборотДт КАК СуммаСценарияДт,
		|		Обороты.СуммаСценарияОборотКт КАК СуммаСценарияКт,
		|		Обороты.Организация КАК Организация,
		|		"+?(ЗначениеЗаполнено(ПериодичностьОтчета),"Обороты.Период","ДАТАВРЕМЯ(1, 1, 1)")+" КАК Период"+ТекстПоля+"
		|	ИЗ
		|		РегистрБухгалтерии.фин_Бюджетирование.Обороты(&НачалоПериода, &КонецПериода,"+?(ЗначениеЗаполнено(ПериодичностьОтчета),Строка(ПериодичностьОтчета),"")+" , Счет В ИЕРАРХИИ (&Счет),"+?(МассивВидовСубконто.Количество()=0,"","&ВидыСубконто")+", Сценарий = &Сценарий"+?(ТекстФильтрОстатки="",""," И "+ТекстФильтрОстатки)+", , ) КАК Обороты) КАК Обороты
		|;

		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Обороты.Счет,
		|	1 КАК Порядок,
		|	ЗНАЧЕНИЕ(Справочник.фин_СлужебныеТерминыБюджетирования.НачальноеСальдоДт) КАК Колонка,
		|	Обороты.КоличествоНачальныйОстатокДт КАК Количество,
		|	Обороты.СуммаУпрНачальныйОстатокДт КАК СуммаУпр,
		|	Обороты.ВалютнаяСуммаНачальныйОстатокДт КАК ВалютнаяСумма,
		|	Обороты.СуммаСценарияНачальныйОстатокДт КАК СуммаСценария,
		|	Обороты.Валюта,
		|	Обороты.Период,
		|	Обороты.Организация"+ТекстПоля+"
		|ИЗ
		|	ВТ_Остатки КАК Обороты

		|ОБЪЕДИНИТЬ ВСЕ

		|ВЫБРАТЬ
		|	Обороты.Счет,
		|	2,
		|	ЗНАЧЕНИЕ(Справочник.фин_СлужебныеТерминыБюджетирования.НачальноеСальдоКт),
		|	Обороты.КоличествоНачальныйОстатокКт,
		|	Обороты.СуммаУпрНачальныйОстатокКт,
		|	Обороты.ВалютнаяСуммаНачальныйОстатокКт,
		|	Обороты.СуммаСценарияНачальныйОстатокКт,
		|	Обороты.Валюта,
		|	Обороты.Период,
		|	Обороты.Организация"+ТекстПоля+"
		|ИЗ
		|	ВТ_Остатки КАК Обороты

		|ОБЪЕДИНИТЬ ВСЕ

		|ВЫБРАТЬ
		|	Обороты.Счет,
		|	3,
		|	ЗНАЧЕНИЕ(Справочник.фин_СлужебныеТерминыБюджетирования.ОборотДт),
		|	Обороты.КоличествоДт,
		|	Обороты.СуммаУпрДт,
		|	Обороты.ВалютнаяСуммаДт,
		|	Обороты.СуммаСценарияДт,
		|	Обороты.Валюта,
		|	Обороты.Период,
		|	Обороты.Организация"+ТекстПоля+"
		|ИЗ
		|	ВТ_Обороты КАК Обороты

		|ОБЪЕДИНИТЬ ВСЕ

		|ВЫБРАТЬ
		|	Обороты.Счет,
		|	5,
		|	ЗНАЧЕНИЕ(Справочник.фин_СлужебныеТерминыБюджетирования.ОборотКт),
		|	Обороты.КоличествоКт,
		|	Обороты.СуммаУпрКт,
		|	Обороты.ВалютнаяСуммаКт,
		|	Обороты.СуммаСценарияКт,
		|	Обороты.Валюта,
		|	Обороты.Период,
		|	Обороты.Организация"+ТекстПоля+"
		|ИЗ
		|	ВТ_Обороты КАК Обороты

		|ОБЪЕДИНИТЬ ВСЕ

		|ВЫБРАТЬ
		|	Обороты.Счет,
		|	7,
		|	ЗНАЧЕНИЕ(Справочник.фин_СлужебныеТерминыБюджетирования.КонечноеСальдоДт),
		|	Обороты.КоличествоКонечныйОстатокДт,
		|	Обороты.СуммаУпрКонечныйОстатокДт,
		|	Обороты.ВалютнаяСуммаКонечныйОстатокДт,
		|	Обороты.СуммаСценарияКонечныйОстатокДт,
		|	Обороты.Валюта,
		|	Обороты.Период,
		|	Обороты.Организация"+ТекстПоля+"
		|ИЗ
		|	ВТ_Остатки КАК Обороты

		|ОБЪЕДИНИТЬ ВСЕ

		|ВЫБРАТЬ
		|	Обороты.Счет,
		|	8,
		|	ЗНАЧЕНИЕ(Справочник.фин_СлужебныеТерминыБюджетирования.КонечноеСальдоКт),
		|	Обороты.КоличествоКонечныйОстатокКт,
		|	Обороты.СуммаУпрКонечныйОстатокКт,
		|	Обороты.ВалютнаяСуммаКонечныйОстатокКт,
		|	Обороты.СуммаСценарияКонечныйОстатокКт,
		|	Обороты.Валюта,
		|	Обороты.Период,
		|	Обороты.Организация"+ТекстПоля+"
		|ИЗ
		|	ВТ_Остатки КАК Обороты";
	Возврат Текст;
КонецФункции

ДоступныеПоказатели = Новый СписокЗначений;
ДоступныеГруппировки = Новый СписокЗначений;
ПереченьОсновныхРеквизитов = Новый Массив;
ПереченьОсновныхРеквизитов.Добавить("Счет");
//ПереченьОсновныхРеквизитов.Добавить("ПериодичностьОтчета");
ЗаполнениеПараметров = Новый Структура;
ЗаполнениеПараметров.Вставить("НачалоПериода",НачалоМесяца(ТекущаяДата()));
ЗаполнениеПараметров.Вставить("КонецПериода",КонецМесяца(ТекущаяДата()));
ЗаполнениеПараметров.Вставить("ЯзыкОтчета",фин_ОбщегоНазначенияСервер.ОсновнойЯзыкОтчетов());

ДополнительныеПараметры = Новый Массив;
ДополнительныеПараметры.Добавить("ЯзыкОтчета");

ПараметрыОформления = Новый Массив;

ДанныеРасшифровкиМакета = Новый Соответствие;

КЭШ = Новый Соответствие;

ДополнительныеПредставления = Новый СписокЗначений;
ДополнительныеПредставления.Добавить(Перечисления.фин_ФактическиеПоказателиБюджетирования.ФинансовыйПоказатель,"Счет");

ОтборыРасшифровки = Новый Массив;

ТаблицаОтбора = Новый ТаблицаЗначений;
ТаблицаОтбора.Колонки.Добавить("Поле");
ТаблицаОтбора.Колонки.Добавить("ВидСравнения");
ТаблицаОтбора.Колонки.Добавить("Значение");
