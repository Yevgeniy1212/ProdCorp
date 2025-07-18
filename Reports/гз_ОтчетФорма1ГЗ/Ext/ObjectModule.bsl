﻿#Если Клиент Тогда
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт; // (переменная отчета)

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;  // (переменная отчета)

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт; // (переменная отчета)

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт; // (переменная отчета)

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;  // (переменная отчета)

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт; // (переменная отчета)
// хранит дату конца периода
Перем мДатаКонцаПериодаОтчета  Экспорт; // (переменная отчета)

//хранит версию формы
Перем мВерсияФормы Экспорт; // (переменная отчета)

//хранит полное имя файла внешней обработки
Перем мПолноеИмяФайлаВнешнейОбработки Экспорт; // (переменная отчета)

// хранит флаг запрета записи
Перем мЗаписьЗапрещена Экспорт; // (переменная отчета)

//хранит интервал автосохранения
Перем мИнтервалАвтосохранения Экспорт; // (переменная отчета)

//хранит таблицу страниц на печать
Перем мТаблицаСтраницНаПечать Экспорт; // (переменная отчета)

//хранит общее количество страниц
Перем ВсегоСтраниц Экспорт; // (переменная отчета)

// Хранит ФИО исполнителя 
Перем мИсполнитель Экспорт; // (переменная отчета)

// Хранит список структурных единиц, по которым строится отчет
Перем мСписокСтруктурныхЕдиниц Экспорт; // (переменная отчета)

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция получает основные сведения о выбранной организации
// 
Функция ЗаполнитьСведенияОбОрганизации()Экспорт
	
	Если (Организация  = Неопределено) ИЛИ (Организация = гз_ОбщегоНазначения.мПустоеЗначениеТипа("СправочникСсылка.Организации")) Тогда
		Возврат 0;
	КонецЕсли;
	
	// Составляем список данных, необходимых для вывода в отчетную форму
	Сведения = Новый СписокЗначений;
			
	Сведения.Добавить("", "НаимЮЛПол"); // Полное название организации
			
	Сведения.Добавить("", "КодПоОКПО"); // ОКПО
			
	Сведения.Добавить("", "АдрЮР"); // Юридический адрес
	
	Сведения.Добавить("", "ТелОрганизации"); // Телефон организации
	
	Сведения.Добавить("", "ФИОБухКраткое"); // ФИО гл. бухгалтера
	
	Сведения.Добавить("", "ФИОРукКраткое"); // ФИО руководителя
	
	// Теперь получаем данные из глобальной общей функции
	ОргСведения = гз_ОбщегоНазначения.мПолучитьСведенияОбОрганизации(Организация, ТекущаяДата(), Сведения);
	
	Возврат ОргСведения;
	
КонецФункции // ЗаполнитьСведенияОбОрганизации

// Функция формирует запрос
// 
Функция СформироватьЗапрос(мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,СписокСостояний,ТаблицаСпособов)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Внешняя",	ТаблицаСпособов);
	Запрос.УстановитьПараметр("Заключенные",Заключенные);
	Запрос.УстановитьПараметр("ПоКонтрагентам",ПоКонтрагентам);
	Запрос.Текст ="ВЫБРАТЬ
	              |	Внешняя.СпособЗакупки,
	              |	Внешняя.СоставляющийСпособ
	              |ПОМЕСТИТЬ ВТ_Способы
	              |ИЗ
	              |	&Внешняя КАК Внешняя
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ РАЗЛИЧНЫЕ
	              |	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор
	              |ПОМЕСТИТЬ ВТ_Регистрации
	              |ИЗ
	              |	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
	              |ГДЕ
	              |	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Состояние В(&Состояние)
	              |	И гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Год = &Год
	              |	И гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Организация В (&Организация)
	              |	И ВЫБОР
	              |			КОГДА ВЫБОР
	              |					КОГДА &Заключенные
	              |						ТОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата
	              |					ИНАЧЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.ДатаИсполнения
	              |				КОНЕЦ < &Год
	              |				ТОГДА ВЫБОР
	              |						КОГДА &ВключаяДоГода
	              |							ТОГДА ИСТИНА
	              |						ИНАЧЕ ЛОЖЬ
	              |					КОНЕЦ
	              |			КОГДА ВЫБОР
	              |					КОГДА &Заключенные
	              |						ТОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата
	              |					ИНАЧЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.ДатаИсполнения
	              |				КОНЕЦ > &КонецГода
	              |				ТОГДА ВЫБОР
	              |						КОГДА &ВключаяПослеГода
	              |							ТОГДА ИСТИНА
	              |						ИНАЧЕ ЛОЖЬ
	              |					КОНЕЦ
	              |			ИНАЧЕ ВЫБОР
	              |						КОГДА &Заключенные
	              |							ТОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата
	              |						ИНАЧЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.ДатаИсполнения
	              |					КОНЕЦ >= &ДатаНачала
	              |					И ВЫБОР
	              |						КОГДА &Заключенные
	              |							ТОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата
	              |						ИНАЧЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.ДатаИсполнения
	              |					КОНЕЦ <= &ДатаОкончания
	              |		КОНЕЦ
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ РАЗЛИЧНЫЕ
	              |	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки КАК СпособЗакупки,
	              |	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Закупка КАК Закупка
	              |ПОМЕСТИТЬ ВТ_Закупки
	              |ИЗ
	              |	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
	              |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
	              |		ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ВложенныйЗапрос.ПоставщиковПобедителей,
	              |	ВложенныйЗапрос.СпособЗакупки КАК ГруппаСпособаЗакупки,
	              |	ВложенныйЗапрос.ПроведенныхЗакупок,
	              |	ВложенныйЗапрос.ОбъемЗакупок,
	              |	ВложенныйЗапрос.ОбъемЗакупокЗарубежных,
	              |	ВложенныйЗапрос.ЗарубежныхЗакупок,
	              |	ВложенныйЗапрос.ВыделеннаяСумма,
	              |	ВложенныйЗапрос.УсловнаяЭкономия
	              |ИЗ
	              |	(ВЫБРАТЬ
	              |		ЗапросПоЗакупкам.ПоставщиковПобедителей КАК ПоставщиковПобедителей,
	              |		ЗапросПоЗакупкам.СпособЗакупки КАК СпособЗакупки,
	              |		ЗапросПоЗакупкам.ПроведенныхЗакупок КАК ПроведенныхЗакупок,
	              |		ЗапросПоЗакупкам.ОбъемЗакупок КАК ОбъемЗакупок,
	              |		ЗапросПоЗакупкам.ОбъемЗакупокЗарубежных КАК ОбъемЗакупокЗарубежных,
	              |		ЕСТЬNULL(ЗарубежныеЗакупки.ЗарубежныхЗакупок, 0) КАК ЗарубежныхЗакупок,
	              |		ЕСТЬNULL(ЗапросВыделеннаяСумма.ВыделеннаяСумма, 0) КАК ВыделеннаяСумма,
	              |		ЕСТЬNULL(ЗапросВыделеннаяСумма.ВыделеннаяСумма, 0) - ЗапросПоЗакупкам.ОбъемЗакупок КАК УсловнаяЭкономия
	              |	ИЗ
	              |		(ВЫБРАТЬ
	              |			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	              |					КОГДА &ПоКонтрагентам
	              |						ТОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Контрагент
	              |					ИНАЧЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор
	              |				КОНЕЦ) КАК ПоставщиковПобедителей,
	              |			ВТ_Способы.СпособЗакупки КАК СпособЗакупки,
	              |			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	              |					КОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Закупка.Ссылка ЕСТЬ NULL 
	              |						ТОГДА NULL
	              |					ИНАЧЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Закупка
	              |				КОНЕЦ) КАК ПроведенныхЗакупок,
	              |			СУММА(ЕСТЬNULL(гз_КорректировкиДоговоровГосударственныхЗакупокСрезПоследних.Сумма, гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Сумма)) КАК ОбъемЗакупок,
	              |			СУММА(ВЫБОР
	              |					КОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.ЗарубежныйПоставщик
	              |						ТОГДА ЕСТЬNULL(гз_КорректировкиДоговоровГосударственныхЗакупокСрезПоследних.Сумма, гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Сумма)
	              |					ИНАЧЕ 0
	              |				КОНЕЦ) КАК ОбъемЗакупокЗарубежных
	              |		ИЗ
	              |			РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
	              |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
	              |				ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
	              |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Способы КАК ВТ_Способы
	              |				ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки = ВТ_Способы.СоставляющийСпособ
	              |				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.гз_КорректировкиДоговоровГосударственныхЗакупок.СрезПоследних КАК гз_КорректировкиДоговоровГосударственныхЗакупокСрезПоследних
	              |				ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.ДоговорКонтрагента = гз_КорректировкиДоговоровГосударственныхЗакупокСрезПоследних.ДоговорКонтрагента
	              |					И гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Год = гз_КорректировкиДоговоровГосударственныхЗакупокСрезПоследних.Год
	              |		
	              |		СГРУППИРОВАТЬ ПО
	              |			ВТ_Способы.СпособЗакупки) КАК ЗапросПоЗакупкам
	              |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	              |				ВложенныйЗапрос.СпособЗакупки КАК СпособЗакупки,
	              |				СУММА(ВЫБОР
	              |						КОГДА ВложенныйЗапрос.ЗарубежныйПоставщик
	              |							ТОГДА 1
	              |						ИНАЧЕ 0
	              |					КОНЕЦ) КАК ЗарубежныхЗакупок
	              |			ИЗ
	              |				(ВЫБРАТЬ
	              |					ВТ_Способы.СпособЗакупки КАК СпособЗакупки,
	              |					гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Контрагент КАК Контрагент,
	              |					МАКСИМУМ(гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.ЗарубежныйПоставщик) КАК ЗарубежныйПоставщик
	              |				ИЗ
	              |					РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
	              |						ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
	              |						ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
	              |						ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Способы КАК ВТ_Способы
	              |						ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки = ВТ_Способы.СоставляющийСпособ
	              |				
	              |				СГРУППИРОВАТЬ ПО
	              |					ВТ_Способы.СпособЗакупки,
	              |					гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Контрагент) КАК ВложенныйЗапрос
	              |			
	              |			СГРУППИРОВАТЬ ПО
	              |				ВложенныйЗапрос.СпособЗакупки) КАК ЗарубежныеЗакупки
	              |			ПО ЗапросПоЗакупкам.СпособЗакупки = ЗарубежныеЗакупки.СпособЗакупки
	              |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	              |				ВТ_Способы.СпособЗакупки КАК СпособЗакупки,
	              |				СУММА(ЕСТЬNULL(КонкурсныеЗакупки.Сумма, 0) + ЕСТЬNULL(РучныеЗакупки.Сумма, 0)) КАК ВыделеннаяСумма
	              |			ИЗ
	              |				ВТ_Закупки КАК ВТ_Закупки
	              |					ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Способы КАК ВТ_Способы
	              |					ПО ВТ_Закупки.СпособЗакупки = ВТ_Способы.СоставляющийСпособ
	              |					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.гз_ПроведенныеЗакупки.СуммаПоСпособамЗакупки КАК РучныеЗакупки
	              |					ПО ВТ_Закупки.СпособЗакупки = РучныеЗакупки.СпособЗакупки
	              |						И ВТ_Закупки.Закупка = РучныеЗакупки.Ссылка
	              |					ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	              |						гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка.СпособЗакупки КАК СпособЗакупки,
	              |						СУММА(гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Сумма) КАК Сумма,
	              |						ВТ_Закупки.Закупка КАК Закупка
	              |					ИЗ
	              |						Документ.гз_ОбъявлениеОПроведенииГосударственныхЗакупок.Товары КАК гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары
	              |							ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Закупки КАК ВТ_Закупки
	              |							ПО гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка.СпособЗакупки = ВТ_Закупки.СпособЗакупки
	              |								И гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка = ВТ_Закупки.Закупка
	              |					
	              |					СГРУППИРОВАТЬ ПО
	              |						гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка.СпособЗакупки,
	              |						ВТ_Закупки.Закупка) КАК КонкурсныеЗакупки
	              |					ПО ВТ_Закупки.СпособЗакупки = КонкурсныеЗакупки.СпособЗакупки
	              |						И ВТ_Закупки.Закупка = КонкурсныеЗакупки.Закупка
	              |			
	              |			СГРУППИРОВАТЬ ПО
	              |				ВТ_Способы.СпособЗакупки) КАК ЗапросВыделеннаяСумма
	              |			ПО ЗапросПоЗакупкам.СпособЗакупки = ЗапросВыделеннаяСумма.СпособЗакупки) КАК ВложенныйЗапрос";
		
	Запрос.УстановитьПараметр("НачалоГода", НачалоГода(мДатаНачалаПериодаОтчета));
	Запрос.УстановитьПараметр("Год", НачалоГода(мДатаНачалаПериодаОтчета));
	Запрос.УстановитьПараметр("КонецГода", КонецГода(мДатаКонцаПериодаОтчета));
	Запрос.УстановитьПараметр("Организация", мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ВидДвиженияПриход", ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ДатаНачала", ?(СНарастающимИтогом,НачалоГода(мДатаНачалаПериодаОтчета),НачалоКвартала(мДатаНачалаПериодаОтчета)));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецКвартала(мДатаКонцаПериодаОтчета));
	Запрос.УстановитьПараметр("ВключаяДоГода",СНарастающимИтогом ИЛИ (НачалоГода(мДатаНачалаПериодаОтчета)=НачалоКвартала(мДатаНачалаПериодаОтчета)));
 	Запрос.УстановитьПараметр("ВключаяПослеГода", (КонецГода(мДатаКонцаПериодаОтчета)=КонецКвартала(мДатаКонцаПериодаОтчета)));
	Запрос.УстановитьПараметр("Состояние", СписокСостояний);

	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции // СформироватьЗапрос

// Функция формирует запрос по расшифровке
// 
Функция СформироватьЗапросПоРасшифровке(мДатаНачалаПериодаОтчета,мДатаКонцаПериодаОтчета,Показатель,СписокСпособов)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СпособЗакупки",СписокСпособов);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор
	|ПОМЕСТИТЬ ВТ_Регистрации
	|ИЗ
	|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
	|ГДЕ
	|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Состояние = &Состояние
	|	И гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Год = &Год
	|	И ВЫБОР
	|			КОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата"+?(Заключенные,"","Исполнения")+" < &Год
	|				ТОГДА ВЫБОР
	|						КОГДА &ВключаяДоГода
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			КОГДА гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата"+?(Заключенные,"","Исполнения")+" > &КонецГода
	|				ТОГДА ВЫБОР
	|						КОГДА &ВключаяПослеГода
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			ИНАЧЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата"+?(Заключенные,"","Исполнения")+" >= &ДатаНачала
	|					И гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор.Дата"+?(Заключенные,"","Исполнения")+" <= &ДатаОкончания
	|		КОНЕЦ
	|;";
	Запрос.УстановитьПараметр("НачалоГода", 	НачалоГода(мДатаНачалаПериодаОтчета));
	Запрос.УстановитьПараметр("Год", 			НачалоГода(мДатаНачалаПериодаОтчета));
	Запрос.УстановитьПараметр("КонецГода", 		КонецГода(мДатаКонцаПериодаОтчета));
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("ВидДвиженияПриход", ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ДатаНачала", 	?(СНарастающимИтогом,НачалоГода(мДатаНачалаПериодаОтчета),НачалоКвартала(мДатаНачалаПериодаОтчета)));
	Запрос.УстановитьПараметр("ДатаОкончания", 	КонецКвартала(мДатаКонцаПериодаОтчета));
	Запрос.УстановитьПараметр("ВключаяДоГода",	СНарастающимИтогом ИЛИ (НачалоГода(мДатаНачалаПериодаОтчета)=НачалоКвартала(мДатаНачалаПериодаОтчета)));
 	Запрос.УстановитьПараметр("ВключаяПослеГода", (КонецГода(мДатаКонцаПериодаОтчета)=КонецКвартала(мДатаКонцаПериодаОтчета)));
  	Запрос.УстановитьПараметр("Состояние", 		Перечисления.гз_СостоянияДоговоровПоГосударственнымЗакупкам.Исполнен);
	Если Показатель = "ПоставщиковПобедителей" Тогда
		 Запрос.Текст=Запрос.Текст+"ВЫБРАТЬ РАЗЛИЧНЫЕ"+?(ПоКонтрагентам,"
		                           |	ВТ_Регистрации.Регистратор.Контрагент КАК Контрагент,","")+"
		                           |	ВТ_Регистрации.Регистратор КАК Регистратор
		                           |ИЗ
		                           |	ВТ_Регистрации КАК ВТ_Регистрации
		                           |ГДЕ
		                           |	ВТ_Регистрации.Регистратор.СпособЗакупки В(&СпособЗакупки)"+?(ПоКонтрагентам,"
		                           |ИТОГИ
		                           |	КОЛИЧЕСТВО(Регистратор)
		                           |ПО
		                           |	Контрагент","");
	ИначеЕсли Показатель = "ПроведенныхЗакупок" Тогда 
		 Запрос.Текст=Запрос.Текст+"
		 	|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Закупка КАК Регистратор
			|ИЗ
			|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
			|		ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
			|ГДЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки В (&СпособЗакупки)";
	ИначеЕсли Показатель = "ЗарубежныхЗакупок" Тогда 
		 Запрос.Текст=Запрос.Текст+"
		 	|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Закупка КАК Регистратор
			|ИЗ
			|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
			|		ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
			|ГДЕ гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки В (&СпособЗакупки) И гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.ЗарубежныйПоставщик";
	ИначеЕсли Показатель = "ОбъемЗакупок" Тогда 
		 Запрос.Текст=Запрос.Текст+"ВЫБРАТЬ
			|	СУММА(гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Сумма) КАК Сумма,
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор
			|ИЗ
			|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
			|		ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
			|ГДЕ
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки В (&СпособЗакупки)
			|
			|СГРУППИРОВАТЬ ПО
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор";
	ИначеЕсли Показатель = "ОбъемЗакупокЗарубежных" Тогда 
		 Запрос.Текст=Запрос.Текст+"ВЫБРАТЬ
			|	СУММА(гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Сумма) КАК Сумма,
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор
			|ИЗ
			|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
			|		ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
			|ГДЕ
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки В (&СпособЗакупки)
			|	И гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.ЗарубежныйПоставщик
			|
			|СГРУППИРОВАТЬ ПО
			|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор";
	ИначеЕсли Показатель = "ВыделеннаяСумма" Тогда 
		Запрос.Текст=Запрос.Текст+"
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.СпособЗакупки КАК СпособЗакупки,
				|	гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Закупка КАК Закупка
				|ПОМЕСТИТЬ ВТ_Закупки
				|ИЗ
				|	РегистрСведений.гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам КАК гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрации КАК ВТ_Регистрации
				|		ПО гз_ДоговорыКонтрагентовПоГосударственнымЗакупкам.Регистратор = ВТ_Регистрации.Регистратор
				|;
				|ВЫБРАТЬ
				  |	ВТ_Закупки.Закупка КАК Регистратор,
				  |	СУММА(ЕСТЬNULL(КонкурсныеЗакупки.Сумма, 0) + ЕСТЬNULL(РучныеЗакупки.Сумма, 0)) КАК Сумма
				  |ИЗ
				  |	ВТ_Закупки КАК ВТ_Закупки
				  |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.гз_ПроведенныеЗакупки.СуммаПоСпособамЗакупки КАК РучныеЗакупки
				  |		ПО ВТ_Закупки.СпособЗакупки = РучныеЗакупки.СпособЗакупки
				  |			И ВТ_Закупки.Закупка = РучныеЗакупки.Ссылка
				  |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
				  |			гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка.СпособЗакупки КАК СпособЗакупки,
				  |			СУММА(гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Сумма) КАК Сумма,
				  |			ВТ_Закупки.Закупка КАК Закупка
				  |		ИЗ
				  |			Документ.гз_ОбъявлениеОПроведенииГосударственныхЗакупок.Товары КАК гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары
				  |				ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Закупки КАК ВТ_Закупки
				  |				ПО гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка.СпособЗакупки = ВТ_Закупки.СпособЗакупки
				  |					И гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка = ВТ_Закупки.Закупка
				  |		
				  |		СГРУППИРОВАТЬ ПО
				  |			гз_ОбъявлениеОПроведенииГосударственныхЗакупокТовары.Ссылка.СпособЗакупки,
				  |			ВТ_Закупки.Закупка) КАК КонкурсныеЗакупки
				  |		ПО ВТ_Закупки.СпособЗакупки = КонкурсныеЗакупки.СпособЗакупки
				  |			И ВТ_Закупки.Закупка = КонкурсныеЗакупки.Закупка
				  |ГДЕ
				  |	ВТ_Закупки.СпособЗакупки В (&СпособЗакупки)
				  |
				  |СГРУППИРОВАТЬ ПО
				  |	ВТ_Закупки.Закупка";
	КонецЕсли;
	Если Показатель = "ПоставщиковПобедителей" И ПоКонтрагентам Тогда
		Возврат Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Иначе
		Возврат Запрос.Выполнить().Выбрать();
	КонецЕсли;

КонецФункции // СформироватьЗапросПоРасшифровке

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

мСписокСтруктурныхЕдиниц = Новый СписокЗначений;

ОписаниеТиповСтрока15  = гз_ОбщегоНазначения.мПолучитьОписаниеТиповСтроки(15);
ОписаниеТиповСтрока50  = гз_ОбщегоНазначения.мПолучитьОписаниеТиповСтроки(50);

// Таблица значений хранит состав показателей отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя поля табличного документа;
//    - код показатели по составу показателей;
//    - код показателя по форме (имя области табличного документа);
//    - признак многострочности;
//    - тип данных показателя.
//
мТаблицаСоставПоказателей    = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнакМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСтруктуре",ОписаниеТиповСтрока50);

мСтруктураВариантыЗаполнения = Новый Структура;

мТаблицаСтраницНаПечать = Новый ТаблицаЗначений;
мТаблицаСтраницНаПечать.Колонки.Добавить("ПолеТабличногоДокумента");
мТаблицаСтраницНаПечать.Колонки.Добавить("ИмяЛиста");
мТаблицаСтраницНаПечать.Колонки.Добавить("ИмяЛистаДляЗаписи");

// определим ФИО исполнителя
Если Не гз_ОбщегоНазначения.АвтономныйРежимРаботы() Тогда 
	Запрос =  Новый Запрос;
	Запрос.УстановитьПараметр("Исполнитель", глТекущийПользователь.ФизЛицо);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ФИОФИзЛиц.Фамилия,
	|	ФИОФИзЛиц.Имя,
	|	ФИОФИзЛиц.Отчество
	|Из
	|	РегистрСведений.ФИОФизЛиц.СрезПоследних(, ФизЛицо = &Исполнитель) КАК ФИОФизЛиц
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		мИсполнитель = Выборка.Фамилия + ?(Выборка.Имя <> "", " " + Лев(Выборка.Имя, 1) + ".", "") + ?(Выборка.Отчество <> "", " " + Лев(Выборка.Отчество, 1) + ".", "");
	Иначе
		Если глТекущийПользователь.ФизЛицо.Пустая() Тогда
			мИсполнитель = глТекущийПользователь.Наименование;
		Иначе
			мИсполнитель = глТекущийПользователь.ФизЛицо.Наименование;
		КонецЕсли;
	КонецЕсли;
КонецЕсли;

#КонецЕсли
