﻿
//Процедура ПриЗаписи(Отказ, Замещение)
//	Попытка
//		УстановитьПривилегированныйРежим(Истина);
//		Если фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("фин_ВестиКалендарноеПланированиеБюджетногоПроцесса") Тогда
//			Если ЭтотОбъект.Отбор.СтруктурнаяЕдиница.Использование Тогда
//				Если ТипЗнч(ЭтотОбъект.Отбор.СтруктурнаяЕдиница.Значение)=Тип("СправочникСсылка.Подразделения") Тогда
//		            НаборЗаписейИсполнителиЗадачБюджетирования = РегистрыСведений.фин_ИсполнителиЗадачБюджетногоПроцесса.СоздатьНаборЗаписей();
//					НаборЗаписейИсполнителиЗадачБюджетирования.Отбор.Исполнитель.Установить(ЭтотОбъект.Отбор.СтруктурнаяЕдиница.Значение);
//					НаборЗаписейИсполнителиЗадачБюджетирования.Прочитать();
//					Если НаборЗаписейИсполнителиЗадачБюджетирования.Количество()>0 Тогда
//						НаборЗаписейИсполнителиЗадачБюджетирования.Записать();
//					КонецЕсли;
//				КонецЕсли;
//			Иначе	
//				СтрокиФильтра = ЭтотОбъект.Выгрузить(,"СтруктурнаяЕдиница");
//				СтрокиФильтра.Свернуть("СтруктурнаяЕдиница");
//				МассивГрупп = СтрокиФильтра.ВыгрузитьКолонку("СтруктурнаяЕдиница");
//				Для Каждого СтруктурнаяЕдиница Из МассивГрупп Цикл
//					Если ТипЗнч(СтруктурнаяЕдиница)=Тип("СправочникСсылка.Подразделения") Тогда
//			            НаборЗаписейИсполнителиЗадачБюджетирования = РегистрыСведений.фин_ИсполнителиЗадачБюджетногоПроцесса.СоздатьНаборЗаписей();
//						НаборЗаписейИсполнителиЗадачБюджетирования.Отбор.Исполнитель.Установить(СтруктурнаяЕдиница);
//						НаборЗаписейИсполнителиЗадачБюджетирования.Прочитать();
//						Если НаборЗаписейИсполнителиЗадачБюджетирования.Количество()>0 Тогда
//							НаборЗаписейИсполнителиЗадачБюджетирования.Записать();
//						КонецЕсли;
//					КонецЕсли;
//				КонецЦикла;
//			КонецЕсли;
//		КонецЕсли;
//	Исключение
//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось обновить сведения об адресации задач бюджетирования!
//		|	"+ОписаниеОшибки());
//	КонецПопытки;
//КонецПроцедуры


