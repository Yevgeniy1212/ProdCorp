﻿Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Количество()>0 Тогда
		Возврат;
	КонецЕсли; 
   	
	Для Каждого СтрокаНабораЗаписей Из ЭтотОбъект Цикл
		
		ТекКодСтроки = СтрокаНабораЗаписей.КодСтроки;
		Пока Найти(Прав(ТекКодСтроки,1)," ") Цикл 
			ТекКодСтроки = СокрЛП(ТекКодСтроки);
			Если Прав(ТекКодСтроки,1) ="." Тогда 
				КоличествоСимволовВСтроке = СтрДлина(ТекКодСтроки);
				ТекКодСтроки = Лев(ТекКодСтроки,КоличествоСимволовВСтроке-1);
			КонецЕсли;
		КонецЦикла;
		
		СтрокаНабораЗаписей.КодСтроки = ТекКодСтроки;
	
 	КонецЦикла;
	
КонецПроцедуры