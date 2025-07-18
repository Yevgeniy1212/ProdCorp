﻿// Процедура проверяет Напоминания из регистра.
// 
//  Параметры
//   ТаблицаНапоминаний - ТаблицаЗначений, с Напоминаниями
//
Процедура ПроверитьНапоминанияПользователя() Экспорт
	
	ВыбПользователь = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ТекущийПользователь");
	
	КоличествоЗадач = 0;
	Если НЕ фин_ОбщегоНазначенияСервер.ПроверитьДоступКЗадачамИНапоминанияПользователяБюджетирование("фин_ЗадачиБюджетногоПроцесса", ВыбПользователь, КоличествоЗадач) Тогда
		Возврат;
	КонецЕсли;
	
	ФормаОповещения = ПолучитьФорму("Задача.фин_ЗадачиБюджетногоПроцесса.Форма.ФормаОповещенияОЗадачах");
		
	Если КоличествоЗадач > 0 Тогда
		Если НЕ ФормаОповещения.Открыта() Тогда			
			ФормаОповещения.Открыть();			
		КонецЕсли;		
		ФормаОповещения.АктивизироватьФорму(КоличествоЗадач);		
	Иначе		
		Если ФормаОповещения.Открыта() Тогда
			ФормаОповещения.Закрыть();
		КонецЕсли;		
	КонецЕсли;

КонецПроцедуры // ПроверитьНапоминанияПользователя()

