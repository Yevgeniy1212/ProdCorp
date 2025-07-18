﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// См. эту процедуру в модуле ФайловыеФункцииСлужебный.
Процедура ЗаписатьРезультатИзвлеченияТекста(ФайлИлиВерсияСсылка,
                                            РезультатИзвлечения,
                                            АдресВременногоХранилищаТекста) Экспорт
	
	ФайловыеФункцииСлужебный.ЗаписатьРезультатИзвлеченияТекста(
		ФайлИлиВерсияСсылка,
		РезультатИзвлечения,
		АдресВременногоХранилищаТекста);
	
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ДобавитьПараметрыРаботыКлиента(Параметры) Экспорт
	
	НастройкиРаботыСФайлами = ФайловыеФункцииСлужебныйПовтИсп.НастройкиРаботыСФайлами();
	
	Параметры.Вставить("ПерсональныеНастройкиРаботыСФайлами", Новый ФиксированнаяСтруктура(
		НастройкиРаботыСФайлами.ПерсональныеНастройки));
	
	Параметры.Вставить("ОбщиеНастройкиРаботыСФайлами", Новый ФиксированнаяСтруктура(
		НастройкиРаботыСФайлами.ОбщиеНастройки));
		
КонецПроцедуры

