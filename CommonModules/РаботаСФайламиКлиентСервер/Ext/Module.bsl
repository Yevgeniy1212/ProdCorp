﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Определяет, можно ли занять файл и, если нет, то формирует строку ошибки
//
Функция МожноЛиЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт
	
	Если ДанныеФайла.ПометкаУдаления = Истина Тогда
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя занять файл ""%1"",
			           |т.к. он помечен на удаление.'"),
			Строка(ДанныеФайла.Ссылка));
		Возврат Ложь;
	КонецЕсли;
	
	
	Если ДанныеФайла.Редактирует.Пустая()
		Или ДанныеФайла.РедактируетТекущийПользователь Тогда 
		
		Возврат Истина;
		
	Иначе
		
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файл ""%1""
			           |уже занят для редактирования пользователем
			           |""%2"" с %3.'"),
			Строка(ДанныеФайла.Ссылка),
			Строка(ДанныеФайла.Редактирует),
			Формат(ДанныеФайла.ДатаЗаема, "ДФ='dd.MM.yyyy hh:mm'"));
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Создает элемент справочника Файлы
Функция СоздатьЭлементСправочникаФайлы(
	ВыбранныйФайл,
	МассивСтруктурВсехФайлов,
	Владелец,
	ИдентификаторФормы,
	Комментарий,
	ХранитьВерсии,
	ДобавленныеФайлы,
	АдресВременногоХранилищаФайла,
	АдресВременногоХранилищаТекста,
	Пользователь = Неопределено,
	Кодировка = Неопределено) Экспорт
	
	ИмяБезРасширения = ВыбранныйФайл.ИмяБезРасширения;
	Расширение = ВыбранныйФайл.Расширение;
	
	Расширение = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ВыбранныйФайл.Расширение);
	ВремяИзменения = ВыбранныйФайл.ПолучитьВремяИзменения();
	ВремяИзмененияУниверсальное = ВыбранныйФайл.ПолучитьУниверсальноеВремяИзменения();
	Размер = ВыбранныйФайл.Размер();
	
	// Создадим карточку Файла в БД
	ДокСсылка = РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(
		Владелец,
		ИмяБезРасширения,
		Расширение,
		ВремяИзменения,
		ВремяИзмененияУниверсальное,
		Размер,
		АдресВременногоХранилищаФайла,
		АдресВременногоХранилищаТекста,
		Ложь,  // это не веб клиент
		Пользователь,
		Комментарий,
		Ложь,
		Кодировка);
	
	УдалитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
	Если Не ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаТекста);
	КонецЕсли;
	
	ДобавленныйФайлИПуть = Новый Структура("ФайлСсылка, Путь", ДокСсылка, ВыбранныйФайл.Путь);	
	ДобавленныеФайлы.Добавить(ДобавленныйФайлИПуть);
	
	Запись = Новый Структура;
	Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
	Запись.Вставить("Файл", ДокСсылка);
	МассивСтруктурВсехФайлов.Добавить(Запись);

КонецФункции

// Получает имя сканированного файла, вида ДМ-00000012, где ДМ - префикс базы
Функция ПолучитьИмяСканированногоФайла(НомерФайла, ПрефиксБазы) Экспорт
	
	ИмяФайла = "";
	Если НЕ ПустаяСтрока(ПрефиксБазы) Тогда
		ИмяФайла = ПрефиксБазы + "-";
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + Формат(НомерФайла, "ЧЦ=9; ЧВН=; ЧГ=0");
	
	Возврат ИмяФайла;
	
КонецФункции	

