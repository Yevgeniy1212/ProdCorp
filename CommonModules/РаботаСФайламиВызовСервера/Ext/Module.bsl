﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
// Устаревший модуль. Будет удален в следующей редакции БСП.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
// Устаревший программный интерфейс. Будет удален в следующей редакции БСП.

// Устарела. Следует использовать вызываемую процедуру. Будет удалена в следующей редакции БСП.
Функция СоздатьФайлНаОсновеФайлаНаДиске(Владелец, ПутьКФайлуНаДиске) Экспорт
	
	Возврат куфиб_РаботаСФайлами.СоздатьФайлНаОсновеФайлаНаДиске(Владелец, ПутьКФайлуНаДиске);
	
КонецФункции

// Сохраняет настройку в хранилище общих настроек.
// 
// Параметры:
//   Соответствуют методу ХранилищеОбщихНастроекСохранить.Сохранить, 
//   подробнее - см. параметры процедуры ХранилищеСохранить()
// 
Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек = "", Значение, ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено, НужноОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	фин_ОбщегоНазначенияСервер.ХранилищеОбщихНастроекСохранить(
		КлючОбъекта,
		КлючНастроек,
		Значение,
		ОписаниеНастроек,
		ИмяПользователя,
		НужноОбновитьПовторноИспользуемыеЗначения);
		
КонецПроцедуры
