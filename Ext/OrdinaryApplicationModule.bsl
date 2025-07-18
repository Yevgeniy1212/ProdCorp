﻿
// СтандартныеПодсистемы.ФайловыеФункции
// Признак того, что в данном сеансе не нужно повторно делать проверку доступа к каталогу на диске
Перем ПроверкаДоступаКРабочемуКаталогуВыполнена Экспорт;
// Конец СтандартныеПодсистемы.ФайловыеФункции


Перем глЗапрашиватьПодтверждениеПриЗакрытии; // запрашивать
Перем глТекущийПользователь Экспорт;   //текущий пользователь
Перем АдресРесурсовОбозревателя Экспорт;  // адрес
Перем глОбщиеЗначения Экспорт;  // хранилище общих значений
Перем ФормаОповещенияЗадачОткрыта Экспорт;
// Быстрый доступ к бухгалтерским итогам 
Перем БИ Экспорт; // итоги

// Учет ведется по одной организации - или по нескольким.
Перем УчетПоВсемОрганизациям Экспорт; // признак учета по всем организациям
Перем ОсновнаяОрганизация Экспорт;    // основная организация

// Переменная для использования в отраслевых решениях, в типовой конфигурации не используется
Перем глХранилищеЗначений Экспорт; // Переменная для использования в отраслевых решениях, в типовой конфигурации не используется
// список префиксов узлов
Перем глСписокПрефиксовУзлов Экспорт;  // список префиксов узлов

// обработка обмена данными
Перем глОбработкаАвтоОбменДанными Экспорт; // обработка обмена данными

// переменная для проверки на создание нового пользователя
Перем СтарыйПользователь;         // признак
Перем ИмяНовогоПользователя;      // имя

Перем СеансовыеДанныеЭСФ Экспорт;

///////////////////////////////////////////////////////////////////////////////
// -гз- начало

// Переменные предназначены для совместимости с БК и БГУ
//Перем Пользователи Экспорт; 			// для совместимости с "Бухгалтерией для Казахстана" 

// Переменная предназначена для хранения переменных работы с защитой конфигурации
Перем глСтруктураМенеджерЛицензий Экспорт; // для восместимости с "Бухгалтерией для Казахстана" 
										   // и "Бухгалтерией для государственных учреждений Казахстана"
										   
// -гз- конец
///////////////////////////////////////////////////////////////////////////////


// Обработать параметр запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры
//  ПараметрЗапуска  – Строка – параметр запуска, переданный в конфигурацию 
//								с помощью ключа командной строки /C.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска(Знач ПараметрЗапуска)

	// есть ли параметры запуска
	Если ПустаяСтрока(ПараметрЗапуска) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Параметр может состоять из частей, разделенных символом ";".
	// Первая часть - главное значение параметра запуска. 
	// Наличие дополнительных частей определяется логикой обработки главного параметра.
	ПараметрыЗапуска = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска,";");
	ЗначениеПараметраЗапуска = Врег(ПараметрыЗапуска[0]);
	
	Результат = УправлениеСоединениямиИБ.ОбработатьПараметрыЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска);
	Возврат Результат;

КонецФункции 

// Процедура - обработчик события "ПередНачаломРаботыСистемы"
// 
Процедура ПередНачаломРаботыСистемы(Отказ)
	
	//Если РольДоступна("СкрытыеПапкиСогласованиеПлатежей") ИЛИ РольДоступна("СкрытыеПапкиСогласованиеРеестров") Тогда 
	//ГлавныйСтиль = БиблиотекаСтилей.Получить(4);
	//КонецЕсли;

	СтарыйПользователь = ПолныеПрава.ПроверитьПользователей(ИмяНовогоПользователя);
	
	ЗапускПользователяВозможен = Истина;
	
	Если НЕ СтарыйПользователь Тогда 
		Предупреждение("В программе не обнаружено ни одного пользователя!" +Символы.ПС+"Был создан пользователь """+ИмяНовогоПользователя+""".");
	КонецЕсли;
	
	Если СтарыйПользователь Тогда 
		
		ДоступенТолькоПросмотр = Ложь;
		РолиТолькоПросмотр = Новый Массив;
		Для Каждого Роль Из Метаданные.Роли Цикл
			Если Найти(Роль.Имя,"ТолькоПросмотр")<>0 Тогда
				Если РольДоступна(Роль.Имя) Тогда
					ДоступенТолькоПросмотр = Истина;
					Для Каждого РольМетаданных из Метаданные.Роли Цикл
						ИмяРоли = РольМетаданных.Имя;
						Если РольДоступна(ИмяРоли) И Найти(ИмяРоли,"ТолькоПросмотр")=0 И ИмяРоли<>"общ_НастройкаСЛК" Тогда 
							ЗапускПользователяВозможен = Ложь;
						КонецЕсли;
					КонецЦикла;
					Если НЕ ЗапускПользователяВозможен Тогда
						Предупреждение("Роль ""Только просмотр"" не может быть назначена совместно с другими ролями. 
										|Запуск конфигурации невозможен!");
						Отказ = Истина;
						Возврат;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если (НЕ РольДоступна("ТолькоПросмотрБазовыеФункции")) И ДоступенТолькоПросмотр Тогда
			Предупреждение("Вам не назначена роль ""Только просмотр (базовые функции)"". Запуск конфигурации невозможен!");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если (НЕ РольДоступна("Пользователь")) И (НЕ РольДоступна("ПолныеПрава")) И НЕ ДоступенТолькоПросмотр Тогда
			Предупреждение("Вам не назначена роль ""Пользователь"". Запуск конфигурации невозможен!");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если РольДоступна("ГлавныйБухгалтер") И НЕ РольДоступна("Бухгалтер") Тогда
			Предупреждение("Роль ""Главный бухгалтер"" может быть назначена только совместно с ролью ""Бухгалтер"". Запуск конфигурации невозможен!");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		// проверка назначенности еще каких-либо смысловых ролей, кроме дополнительных.
		Если РольДоступна("Пользователь") И НЕ РольДоступна("ПолныеПрава") Тогда		
			
			ЗапускПользователяВозможен = Ложь;
			// список дополнительных ролей, которые не учитываем при проверке
			СтруктураДополнительныхРолей = Новый Структура("фин_БюджетированиеИспользованиеНСИБезОграничений,фин_РасчетМоделейБюджетированияПоРегламентированнымДаннымБезЗарплатныхДанных,фин_РасчетМоделейБюджетированияПоРегламентированнымДанным,фин_ФормированиеОтчетаПоИсполнениюБюджета,фин_ФормированиеОтчетаПоБюджету,фин_ОбновлениеРегламентныхСоответствийФактическихДанныхБюджетирования,фин_КорректировкаДвиженийБухгалтерскихДокументовПоБюджетам,ДобавлениеИзменениеОбменовДанными,ПравоАдминистрирования, ПравоАдминистрированияДополнительныхФормИОбработок, ПравоВнешнегоПодключения, ПравоЗавершенияРаботыПользователей, ПравоЗапускаВнешнихОбработок, РедактированиеДвиженийДокумента, ПравоИнтерактивногоУдаленияПомеченныхОбъектов, Пользователь,ВыполнениеОбменовДанными");
			Для Каждого РольМетаданных Из Метаданные.Роли Цикл
				ИмяРоли = РольМетаданных.Имя;
				Если СтруктураДополнительныхРолей.Свойство(ИмяРоли) = Ложь Тогда
					// Это не дополнительная роль. Проверяем ее доступность
					Если РольДоступна(ИмяРоли) Тогда
						ЗапускПользователяВозможен = Истина;
					КонецЕсли;
				КонецЕсли;	
			КонецЦикла;
			// Если кроме роли Пользователь не назначено ни одной смысловой роли - не запускаем конфигурацию
			//- так как некоторые алгоритмы  не ориентированы на работу в таком режиме
			Если НЕ ЗапускПользователяВозможен Тогда
				Предупреждение("Роль ""Пользователь"" не является самостоятельной и должна назначаться совместно с ролями ""Бухгалтер"" или ""Главный бухгалтер"". 
								|Запуск конфигурации невозможен!");
				Отказ = Истина;
				
				Возврат;
			КонецЕсли;	
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры // ПередНачаломРаботыСистемы()

// Процедура - обработчик события "ПриНачалеРаботыСистемы"
//
Процедура ПриНачалеРаботыСистемы()
	
	Если СтарыйПользователь Тогда 
		ФормаОповещенияЗадачОткрыта = Ложь;
		КонтрольВерсииПлатформы.ПроверитьВерсиюПлатформы(); 
		
		//Если НЕ ПравоДоступа("Использование",    Метаданные.Обработки.БухгалтерскиеИтоги) Тогда
		//	Предупреждение("Недостаточно прав для работы с бухгалтерскими итогами. Работа системы будет завершена.");
		//	ЗавершитьРаботуСистемы();
		//	Возврат;
		//КонецЕсли;
		
		// есть ли права администратора
		ПравоАдминистратора = ПравоДоступа("Администрирование", Метаданные);
		Если ПравоАдминистратора Тогда
			МетаданныеПользователей = Метаданные.Справочники.Пользователи;
			ПараметрыЧтениеПользователи = ПараметрыДоступа("Чтение", МетаданныеПользователей, "ФизЛицо");
			ПараметрыДобавлениеПользователи = ПараметрыДоступа("Добавление", МетаданныеПользователей, "ФизЛицо");
			
			ПравоАдминистратора = ПараметрыЧтениеПользователи.Доступность И НЕ ПараметрыЧтениеПользователи.ОграничениеУсловием 
			И ПараметрыДобавлениеПользователи.Доступность И НЕ ПараметрыДобавлениеПользователи.ОграничениеУсловием 	
		КонецЕсли;
		
		// инициализация глобальной переменной
		// глТекущийПользователь
		
		Если ПараметрыСеанса.ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка() Тогда 
			ПараметрыСеанса.ТекущийПользователь = ПолныеПрава.ОпределитьТекущегоПользователя();
		КонецЕсли;
		
		глТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
		
		Если ПравоДоступа("Использование", Метаданные.Обработки.БухгалтерскиеИтоги) Тогда
			БИ = Обработки.БухгалтерскиеИтоги.Создать();
		КонецЕсли;
		
		ЭтоФайловаяИБ = ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая();
		
		Если ЭтоФайловаяИБ Тогда
			
			ПользовательДляВыполненияРеглЗаданий = Константы.ПользовательДляВыполненияРегламентныхЗаданийВФайловомВарианте.Получить();
			
			Если глТекущийПользователь = ПользовательДляВыполненияРеглЗаданий Тогда
				
				// с интервалом секунд вызываем процедуру работы с регламентными заданиями
				ПоддержкаРегламентныхЗаданиеДляФайловойВерсии();
				
				
				ИнтервалДляОпроса = Константы.ИнтервалДляОпросаРегламентныхЗаданийВФайловомВарианте.Получить();
				
				Если ИнтервалДляОпроса = Неопределено
					ИЛИ ИнтервалДляОпроса = 0 Тогда
					
					ИнтервалДляОпроса = 60;	
					
				КонецЕсли;
				
				ПодключитьОбработчикОжидания("ПоддержкаРегламентныхЗаданиеДляФайловойВерсии", ИнтервалДляОпроса);
				
			КонецЕсли;
			
		КонецЕсли;
		
		// автообмен данными
		Если глЗначениеПеременной("глОбработкаАвтоОбменДанными") <> Неопределено Тогда
			
			// подключим обработчик обменов данными
			ПодключитьОбработчикОжидания("ПроверкаОбменаДанными", глЗначениеПеременной("глКоличествоСекундОпросаОбмена"));
			
		КонецЕсли;
		
		
		ОбщегоНазначения.ЗначениеСпискаПрефиксовУзлов(глСписокПрефиксовУзлов, Истина); 
		ПервыйЗапуск = (Константы.НомерВерсииКонфигурации.Получить()="");
		
		ОсновнаяОрганизация    = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		
		УчетПоВсемОрганизациям = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "УчетПоВсемОрганизациям");
		//ПроверитьНаличиеОбновлений();   
		
		ЗаголовокСистемы = Константы.ЗаголовокСистемы.Получить();
		Если Пустаястрока(ЗаголовокСистемы) Тогда
			ТекстЗаголовкаСистемы = ПолучитьЗаголовокСистемы();
			ЗаголовокСистемы  = ТекстЗаголовкаСистемы;
		КонецЕсли;
		Если Не ОсновнаяОрганизация.Пустая() Тогда
			Попытка
				ЗаголовокСистемы = ЗаголовокСистемы + " / " + СокрЛП(ОсновнаяОрганизация.Наименование);
			Исключение
			КонецПопытки;
		КонецЕсли;
		Если ПараметрыСеанса.ИспользованиеРИБ Тогда
			Если Не ПустаяСтрока(ПланыОбмена.Полный.ЭтотУзел().Наименование) Тогда
				ЗаголовокСистемы = ЗаголовокСистемы + " / " + СокрЛП(ПланыОбмена.Полный.ЭтотУзел());
			Иначе
				ЗаголовокСистемы = ЗаголовокСистемы + " / " + СокрЛП(ПланыОбмена.ПоОрганизации.ЭтотУзел());
			КонецЕсли;
		КонецЕсли;
		ЗаголовокСистемы = ЗаголовокСистемы + " / "+ СокрЛП(глТекущийПользователь);
		УстановитьЗаголовокСистемы(ЗаголовокСистемы);
		
			
		ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы();
		// - БП - начало
		общ_ЗапускИОбновлениеИнформационнойБазы.ИнициализироватьПодсистемуБюджетированиеПредприятия();
		// - БП – конец		
		// отработка параметров запуска системы
		Если ОбработатьПараметрыЗапуска(ПараметрЗапуска) Тогда
			Возврат;
		КонецЕсли;
		
		УправлениеСоединениямиИБ.УстановитьКонтрольРежимаЗавершенияРаботыПользователей();

		// Начнем проверку динамического обновления конфигурации
		НачатьПроверкуДинамическогоОбновленияИБ();
		
		// Подключение обработчик напоминания о событиях
		куфиб_ПроверитьПодключениеОбработчикаОжидания();
		
		Если УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "АвтооткрытиеЭлектроннойПочтыПриЗапускеПрограммы") = Истина
			И Константы.ИспользованиеВстроенногоПочтовогоКлиента.Получить() Тогда
			Обработки.Почта.ПолучитьФорму().Открыть();
		КонецЕсли;
		
		// открытие обработки "Текущие задачи"
		ОткрытьТекущиеЗадачиПользователя = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОткрыватьПриЗапускеСписокТекущихЗадачПользователя")
		И ПравоДоступа("Использование", Метаданные.Задачи.ЗадачаИсполнителя);
		
		Если ОткрытьТекущиеЗадачиПользователя Тогда
			Задачи.ЗадачаИсполнителя.ПолучитьФормуСписка().Открыть();
		КонецЕсли;
		
		// Открытие Стартового помощника и Панели функций
		Если (НЕ ПервыйЗапуск) Тогда
			// запустим стартовый помощник, если это первый запуск предзаполненной базы 
			ПроверитьЗапускСтартовогоПомощникаИПанелиФункций();
		КонецЕсли;
		
		// Открытие Быстрого освоения
		ПоказыватьБыстроеОсвоение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ПоказыватьБыстроеОсвоениеПриНачалеРаботыСистемы");
		Если ПоказыватьБыстроеОсвоение  И (НЕ ПервыйЗапуск) Тогда
			Обработки.БыстроеОсвоение.ПолучитьФорму().Открыть();
		КонецЕсли;
		
		//БИТ
		Задачи.ЗадачаИсполнителяПоСогласованиюПлатежей.ПолучитьФормуСписка().Открыть();
		//БИТ 
		
		// Автоматическая загрузка курсов валют
		Если ПравоДоступа("Изменение",Метаданные.РегистрыСведений.КурсыВалют) Тогда
			ЗагружатьАвтоматически = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"АвтоматическиЗагружатьКурсыВалютПриНачалеРаботыСистемы"); 
			Если ЗагружатьАвтоматически Тогда 
				ФормаЗагрузкиКурсов = РегистрыСведений.КурсыВалют.ПолучитьФорму("ФормаЗагрузкиВалют");
				ФормаЗагрузкиКурсов.Открыть();
				ФормаЗагрузкиКурсов.ЗагрузкаКурсовВалютАвтоматическая(Истина);
			КонецЕсли;
		КонецЕсли;
		
		// Календарь бухгалтера. Регламентированная отчетность.
		Если РольДоступна("Бухгалтер") ИЛИ РольДоступна("ГлавныйБухгалтер") ИЛИ РольДоступна("ПолныеПрава") Тогда
			ПроверитьНапоминанияКалендарьБухгалтераСобытия();
		КонецЕсли;
		
		// Открытие дополнительной информации
		//Форма = Обработки.ДополнительнаяИнформация.ПолучитьФорму("ФормаРабочийСтол");
		//Форма.Открыть();
		
		
			// Форма помощника обновления конфигурации выводится поверх остальных окон.
		Если РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
			ЗначениеПроверятьПриЗапуске = ВосстановитьЗначение("ПроверкаНаличияОбновленияПроверятьПриЗапуске");
			ПроверятьНаличиеОбновленияПриЗапуске = ? (ЗначениеПроверятьПриЗапуске = Неопределено, Ложь, ЗначениеПроверятьПриЗапуске);
			Если ПроверятьНаличиеОбновленияПриЗапуске Тогда
				ОбработкаОбновлениеКонфигурации = Обработки.ОбновлениеКонфигурации.Создать();
				ОбработкаОбновлениеКонфигурации.ПроверитьНаличиеОбновлений();
			КонецЕсли;
		КонецЕсли;

		Если ЭтоФайловаяИБ И ПравоДоступа("Чтение",Метаданные.РегистрыБухгалтерии.Типовой) Тогда
			
			ПроверятьРасчетИтоговРБ = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ПроверкаРассчитанныхИтоговРегистраБухгалтерии");
			
			Если ПроверятьРасчетИтоговРБ Тогда 
				ПроверитьИзменитьПериодРассчитаныхИтогов(ПервыйЗапуск);
			КонецЕсли;
			
		КонецЕсли;
		Если ПравоДоступа("Использование",Метаданные.Обработки.ОбменЭСФ) Тогда
			ЭСФКлиент.ПриНачалеРаботыСистемыЭСФ();
		КонецЕсли;
		
	Иначе 
		ЗавершитьРаботуСистемы(Ложь,Истина,);
	КонецЕсли;
	
КонецПроцедуры // ПриНачалеРаботыСистемы()

// Процедура - обработчик события "ПриЗавершенииРаботыСистемы"
// 
Процедура ПриЗавершенииРаботыСистемы()
	
	// Показ финальной дополнительной информации
	Форма = Обработки.ДополнительнаяИнформация.Создать();
	Форма.ВыполнитьДействие();

КонецПроцедуры // ПриЗавершенииРаботыСистемы()

///////////////////////////////////////////////////////////////////////////////
// СЕРВИСНЫЕ ПРОЦЕДУРЫ

Процедура ИзменитьПериодРассчитанныхИтогов(ИзменитьГраницу, ДатаИтогов)
	
	//Регистр бухгалтерии
	Если ИзменитьГраницу Тогда
		РегистрыБухгалтерии.Типовой.УстановитьПериодРассчитанныхИтогов(ДатаИтогов);
		РегистрыБухгалтерии.Налоговый.УстановитьПериодРассчитанныхИтогов(ДатаИтогов);
	Иначе
		РегистрыБухгалтерии.Типовой.ПересчитатьИтоги();
		РегистрыБухгалтерии.Налоговый.ПересчитатьИтоги();
	КонецЕсли;
	
	//Регистры накопления
	ОграничениеПоВидуРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки;
	Для Каждого МенеджерРегистра ИЗ РегистрыНакопления Цикл
		МетаданныеРегистра = Метаданные.НайтиПоТипу(ТипЗнч(МенеджерРегистра));
		
		Если  МетаданныеРегистра.ВидРегистра <> ОграничениеПоВидуРегистра Тогда
			Продолжить;
		КонецЕсли;
		
		Если ИзменитьГраницу Тогда
			МенеджерРегистра.УстановитьПериодРассчитанныхИтогов(ДатаИтогов);
		Иначе
			МенеджерРегистра.ПересчитатьИтоги();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Проверка границы рассчитанных итогов

Процедура ПроверитьИзменитьПериодРассчитаныхИтогов(ПервыйЗапуск)
	
	ТекущаяДата = ТекущаяДата();
	КонтрольнаяДата = ДобавитьМесяц(НачалоМесяца(ТекущаяДата)-1,-1);
	ДатаИтогов = НачалоМесяца(ТекущаяДата)-1;
	БазоваяПоставка = (Найти(ВРег(Метаданные.Имя), "БАЗОВАЯ") > 0);
	ПериодРассчитанныхИтогов = РегистрыБухгалтерии.Типовой.ПолучитьПериодРассчитанныхИтогов();
	
	Если ПервыйЗапуск Тогда
		
		ИзменитьПериодРассчитанныхИтогов(Истина, ДатаИтогов);
		
	ИначеЕсли БазоваяПоставка Тогда
		
		Если ПериодРассчитанныхИтогов < КонтрольнаяДата Тогда
			ИзменитьПериодРассчитанныхИтогов(Истина, ДатаИтогов);
		ИначеЕсли ПериодРассчитанныхИтогов > ТекущаяДата Тогда
			ИзменитьПериодРассчитанныхИтогов(Ложь, ДатаИтогов);
		КонецЕсли;
		
	Иначе
		
		#Если Клиент Тогда
			
			Если ПериодРассчитанныхИтогов = '00010101' Тогда 
				ТекстСообщения = "Итоги в информационной базе не рассчитаны."
			Иначе				
				ТекстСообщения = "Итоги в информационной базе рассчитаны по " + Формат(ПериодРассчитанныхИтогов, "ДЛФ=DD"); 
			КонецЕсли;
			
			ТекстСообщения = ТекстСообщения  + "
			|Дата рассчитанных итогов влияет на скорость проведения документов и формирования отчетов.
			|Рекомендуется поддерживать границу рассчитанных итогов на конец предыдущего месяца.
			|Для отключения проверки расчета итогов при запуске системы необходимо нажать на кнопку «Отключить проверку». 
			|Включить проверку итогов можно в настройках пользователя.";
			
			Если РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ПравоАдминистрирования") Тогда
				
				ТекстВопроса = ТекстСообщения  + "
								|Установка новой границы рассчитанных итогов может занять некоторое время.
								|
								|Установить границу рассчитанных итогов на " + Формат(ДатаИтогов, "ДЛФ=DD") + "?";

				СписокКнопок = Новый СписокЗначений;
				СписокКнопок.Добавить(КодВозвратаДиалога.Да	 , "Да");
				СписокКнопок.Добавить(КодВозвратаДиалога.Нет , "Нет");
				СписокКнопок.Добавить("ОтключитьПроверку"	 , "Отключить проверку");
				
				Если ПериодРассчитанныхИтогов < ДобавитьМесяц(КонтрольнаяДата,1) Тогда
					
				
					Ответ = Вопрос(ТекстВопроса, СписокКнопок,60,,,КодВозвратаДиалога.Нет);
					Если Ответ = КодВозвратаДиалога.Да Тогда
						ИзменитьПериодРассчитанныхИтогов(Истина, ДатаИтогов);
					ИначеЕсли Ответ = "ОтключитьПроверку" Тогда 
						УправлениеПользователями.УстановитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ПроверкаРассчитанныхИтоговРегистраБухгалтерии", Ложь); 
					КонецЕсли;
				ИначеЕсли ПериодРассчитанныхИтогов > ТекущаяДата Тогда
					
					Ответ = Вопрос(ТекстВопроса, СписокКнопок,60,,,КодВозвратаДиалога.Нет);
					Если Ответ = КодВозвратаДиалога.Да Тогда
						ИзменитьПериодРассчитанныхИтогов(Истина, ДатаИтогов);
					ИначеЕсли Ответ = "ОтключитьПроверку" Тогда 
						УправлениеПользователями.УстановитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ПроверкаРассчитанныхИтоговРегистраБухгалтерии", Ложь); 
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				Если ПериодРассчитанныхИтогов < ДобавитьМесяц(КонтрольнаяДата,1) Тогда
					
					СписокКнопок = Новый СписокЗначений;
					СписокКнопок.Добавить(КодВозвратаДиалога.ОК	 , "Ok");
					СписокКнопок.Добавить("ОтключитьПроверку"	 , "Отключить проверку");

					ТекстВопроса = ТекстСообщения + "
					|
					|Для выполнения этой процедуры необходимо обратиться к пользователю, обладающему полными правами.";
					Ответ = Вопрос(ТекстВопроса, СписокКнопок,60,,,КодВозвратаДиалога.ОК); 
					
					Если Ответ = "ОтключитьПроверку" Тогда 
						УправлениеПользователями.УстановитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ПроверкаРассчитанныхИтоговРегистраБухгалтерии", Ложь); 
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура осуществляет проверку на необходимость обмена данными с заданным интервалом
//
Процедура ПроверкаОбменаДанными() Экспорт

	Если глЗначениеПеременной("глОбработкаАвтоОбменДанными") = Неопределено Тогда
		Возврат;
	КонецЕсли;		
	
	ОтключитьОбработчикОжидания("ПроверкаОбменаДанными");
	
	// проводим обмен данными
	глЗначениеПеременной("глОбработкаАвтоОбменДанными").ПровестиОбменДанными(); 
		
	ПодключитьОбработчикОжидания("ПроверкаОбменаДанными", глЗначениеПеременной("глКоличествоСекундОпросаОбмена"));

КонецПроцедуры

//Процедура ОткрытьФормуРедактированияНастройкиФайлаОбновления
//
Процедура ОткрытьФормуРедактированияНастройкиФайлаОбновления() Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Константы.НастройкаФайлаОбновленияКонфигурации) Тогда
		
		Предупреждение("Нет прав на чтение данных константы ""Настройка файла обновления конфигурации""", 30, "Настройка файла обновления конфигурации");		
		Возврат;
		
	КонецЕсли;

	ФормаРедактирования = ПолучитьОбщуюФорму("НастройкаФайлаОбновленияКонфигурации");
	ФормаРедактирования.СтруктураПараметров = ПроцедурыОбменаДанными.ПолучитьНастройкиДляФайлаОбновленияКонфигурации(); 
	ФормаРедактирования.Открыть();
	
КонецПроцедуры


// Процедура запускает стартовый помощник и панель функций при необходимости
//
Процедура ПроверитьЗапускСтартовогоПомощникаИПанелиФункций()
	СПОткрыт = Ложь;
	Если РольДоступна("ПолныеПрава") Тогда
		//ОрганизацияСсылка = Справочники.Организации.НайтиПоНаименованию("Укажите наименование Вашей организации", Истина);
		//Если НЕ ОрганизацияСсылка = Справочники.Организации.ПустаяСсылка() Тогда
		//	ПолнНаименование = СокрЛП(ОрганизацияСсылка.НаименованиеПолное);
		//	Если ПолнНаименование = "Укажите наименование Вашей организации" ИЛИ ПолнНаименование = "" Тогда
		//		
		//		КоличествоОрганизаций = 1;
		//		Запрос = Новый Запрос();
		//		Запрос.Текст = 
		//		"ВЫБРАТЬ 
		//		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Организации.Ссылка) КАК КоличествоОрганизаций
		//		|ИЗ
		//		|	Справочник.Организации КАК Организации";
		//		Выборка = Запрос.Выполнить().Выбрать();
		//		Если Выборка.Следующий() Тогда
		//			КоличествоОрганизаций = Выборка.КоличествоОрганизаций;
		//		КонецЕсли;
		//		
		//		Если (КоличествоОрганизаций = 1) Тогда
		//			ФормаСтартовогоПомощника = Обработки.СтартовыйПомощник.ПолучитьФорму("Форма");
		//			ФормаСтартовогоПомощника.ПервыйЗапуск = Истина;
		//			ФормаСтартовогоПомощника.СпособОтображенияОкна = ВариантСпособаОтображенияОкна.Максимизированное;
		//			ФормаСтартовогоПомощника.Открыть();
		//			Если ФормаСтартовогоПомощника.Открыта() Тогда
		//				ФормаСтартовогоПомощника.ЭлементыФормы.НадписьПервыйЗапуск.Видимость = Истина;
		//				ФормаСтартовогоПомощника.ЭлементыФормы.НадписьПервыйЗапуск.Значение = 
		//				"Для продолжения работы нажмите кнопку ""Далее"".";
		//			КонецЕсли;
		//			СПОткрыт = Истина;
		//		КонецЕсли;
		//		
		//	КонецЕсли;
		//КонецЕсли;
	КонецЕсли;
	
	//ЦС
	ОткрытьПанельФункций = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОткрыватьПриЗапускеПанельФункций");
	//ЦС
	Если (НЕ СПОткрыт) и ОткрытьПанельФункций Тогда
		 //Открытие дополнительной информации
		Если РольДоступна("УтверждениеПланаЗакупокТРУ") И 
			НЕ глТекущийПользователь = Справочники.Пользователи.НайтиПоНаименованию("Администратор") Тогда
			Обработки.гз_ПанельФункций.ПолучитьФорму().Открыть();			
		//ИначеЕсли глТекущийПользователь = Справочники.Пользователи.НайтиПоНаименованию("Администратор") Тогда
		//	Обработки.ПанельФункцийАдминистратора.ПолучитьФорму().Открыть();
		Иначе
			Обработки.ПанельФункций.ПолучитьФорму().Открыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗапускСтартовогоПомощникаИПанелиФункций()

// Открывает форму текущего пользователя для изменения его настроек.
//
// Параметры:
//  Нет.
//
Процедура ОткрытьФормуТекущегоПользователя() Экспорт

	Если НЕ ЗначениеЗаполнено(глТекущийПользователь) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не задан текущий пользователь.");

	Иначе
		глТекущийПользователь.ПолучитьФорму().Открыть();

	КонецЕсли;

КонецПроцедуры // ОткрытьФормуТекущегоПользователя()

// ПроверитьНапоминанияПользователяКалендарьБухгалтераСобытия
//
Процедура ПроверитьНапоминанияКалендарьБухгалтераСобытия() Экспорт
	
	РегламентированнаяОтчетность.ПроверитьНапоминанияПользователяКалендарьБухгалтераСобытия(глЗначениеПеременной("глТекущийПользователь"));
	
КонецПроцедуры // ПроверитьНапоминанияПользователяКалендарьБухгалтераСобытия

//
//
Функция глЗначениеПеременной(Имя) Экспорт
	
	Возврат ОбщегоНазначения.ПолучитьЗначениеПеременной(Имя, глОбщиеЗначения);

КонецФункции

// Процедура установки значения экспортных переменных модуля приложения
//
// Параметры
//  Имя - строка, содержит имя переменной целиком
// 	Значение - значение переменной
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	ОбщегоНазначения.УстановитьЗначениеПеременной(Имя, глОбщиеЗначения, Значение, ОбновлятьВоВсехКэшах);
	
КонецПроцедуры

//Процедура ПередЗавершениемРаботыСистемы
//
Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	ЗапрашиватьПодтверждение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ЗапрашиватьПодтверждениеПриЗакрытии");
		
	Если глЗапрашиватьПодтверждениеПриЗакрытии <> Ложь Тогда
		Если ЗапрашиватьПодтверждение Тогда
			Ответ = Вопрос("Завершить работу с программой?", РежимДиалогаВопрос.ДаНет);
			Отказ = (Ответ = КодВозвратаДиалога.Нет);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		// отдельно получаем настройки для которых нужно выполнить обмен при выходе из программы
		ПроцедурыОбменаДанными.ВыполнитьОбменПриЗавершенииРаботыПрограммы(глЗначениеПеременной("глОбработкаАвтоОбменДанными"));
			
	КонецЕсли;

КонецПроцедуры


// Процедура проверяет необходимость проверки наличия комплекта обновления конфигурации
//
Процедура ПроверитьНаличиеОбновлений()

	ПроверятьПриЗапуске = ВосстановитьЗначение("ПроверкаНаличияОбновленияПроверятьПриЗапуске");
	ПроверятьПриЗапуске = ?(ТипЗнч(ПроверятьПриЗапуске) = Тип("Неопределено"), Ложь, ПроверятьПриЗапуске);

	Если НЕ ПроверятьПриЗапуске Тогда
		Возврат;
	КонецЕсли;
	
	//ОбновлениеКонфигурации = Обработки.ОбновлениеКонфигурации.Создать();
	//Форма = ОбновлениеКонфигурации.ПолучитьФорму("ОбновлениеКонфигурации");
	//Форма.ПроверкаНаличияОбновленияПриЗапуске = ПроверятьПриЗапуске;
	//Форма.Открыть();

КонецПроцедуры //ПроверитьНаличиеОбновлений()

// Процедура проверяет и при необходимости подключает обработчик ожидания
// на запуск процедуры ПроверитьНапоминания()
//
// Параметры:
//  Нет.
//
Процедура куфиб_ПроверитьПодключениеОбработчикаОжидания() Экспорт
	
	ИнтервалПроверкиНапоминанийВСекундах = Константы.ИнтервалПроверкиНапоминанийВСекундах.Получить();
	
	Если глЗначениеПеременной("глТекущийПользователь") <> Неопределено
		И ТипЗнч(глЗначениеПеременной("глТекущийПользователь")) = Тип("СправочникСсылка.Пользователи")
		И НЕ глЗначениеПеременной("глТекущийПользователь").Пустая()
		И УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ИспользоватьНапоминания")
		И ИнтервалПроверкиНапоминанийВСекундах > 0 Тогда
		
		ПодключитьОбработчикОжидания("ПроверитьНапоминания", ИнтервалПроверкиНапоминанийВСекундах);
		
		УправлениеКонтактами.ПроверитьНапоминанияПользователя(глЗначениеПеременной("глТекущийПользователь"));
		усд_ПроцедурыСогласованияКлиент.ПроверитьНапоминанияПользователя();
		фин_ПроцедурыМеханизмовБюджетированияТонкийКлиент.ПроверитьНапоминанияПользователя();
		
	Иначе
		
		ОтключитьОбработчикОжидания("ПроверитьНапоминания");
		
	КонецЕсли; 
	
КонецПроцедуры

АдресРесурсовОбозревателя = "AccountingHRMKz";

глОбработкаАвтоОбменДанными = Неопределено;

СтарыйПользователь = Истина;
ИмяНовогоПользователя = "Администратор";
