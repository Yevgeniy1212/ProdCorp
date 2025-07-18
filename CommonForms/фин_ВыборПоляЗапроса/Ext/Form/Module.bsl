﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ТекстЗапроса") И НЕ Параметры.ТекстЗапроса="" Тогда
		Попытка
			ПостроительЗапроса = Новый ПостроительЗапроса(Параметры.ТекстЗапроса);
			ПостроительЗапроса.ЗаполнитьНастройки();
			мДерево = ДанныеФормыВЗначение(ДеревоПолей,Тип("ДеревоЗначений"));
			Для Каждого Измерение Из ПостроительЗапроса.ДоступныеПоля Цикл
				Если Параметры.ВидПоля<>"" Тогда
					Если Измерение[Параметры.ВидПоля]<>Истина Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				НС 					= мДерево.Строки.Добавить();
				НС.Поле 			= Измерение.ПутьКДанным;
				НС.Представление 	= Измерение.Представление;
				ДополнитьСписокПолямиРеквизита(НС,Измерение.ПутьКДанным,Измерение.Представление,Измерение.ТипЗначения,?(Найти(Измерение.ПутьКДанным,"Субконто")<>0,2,1));
			КонецЦикла;
			ЗначениеВДанныеФормы(мДерево,ДеревоПолей);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить список полей источника:
			|	"+ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПолейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(Элементы.ДеревоПолей.ТекущиеДанные.Поле);
КонецПроцедуры


//Процедура ДополнитьСписокПолямиРеквизита
//
Процедура ДополнитьСписокПолямиРеквизита(СтрокаДерева,ПутьКДанным,Представление,ТипЗначения,Знач Вложенность=1)
	Если Вложенность>2 Тогда
		Возврат;
	Иначе
		Для Каждого СправочникМетаданных Из Метаданные.Справочники Цикл
			Если ТипЗначения.СодержитТип(Тип("СправочникСсылка."+СправочникМетаданных.Имя)) Тогда
				Для Каждого РеквизитПодчиненный Из СправочникМетаданных.Реквизиты Цикл
					Если СтрокаДерева.Строки.НайтиСтроки(Новый Структура("Поле",ПутьКДанным+"."+РеквизитПодчиненный.Имя)).Количество()>0 Тогда
						Продолжить;
					КонецЕсли;
					СтрокаПоляРеквизитаТЧ 					= СтрокаДерева.Строки.Добавить();
					СтрокаПоляРеквизитаТЧ.Поле 				= ПутьКДанным+"."+РеквизитПодчиненный.Имя;
					СтрокаПоляРеквизитаТЧ.Представление 	= Представление+": "+РеквизитПодчиненный.Синоним;
					ДополнитьСписокПолямиРеквизита(СтрокаПоляРеквизитаТЧ,СтрокаПоляРеквизитаТЧ.Поле,СтрокаПоляРеквизитаТЧ.Представление,РеквизитПодчиненный.Тип,Вложенность+1);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		Для Каждого СправочникМетаданных Из Метаданные.Документы Цикл
			Если ТипЗначения.СодержитТип(Тип("ДокументСсылка."+СправочникМетаданных.Имя)) Тогда
				Для Каждого РеквизитПодчиненный Из СправочникМетаданных.Реквизиты Цикл
					Если СтрокаДерева.Строки.НайтиСтроки(Новый Структура("Поле",ПутьКДанным+"."+РеквизитПодчиненный.Имя)).Количество()>0 Тогда
						Продолжить;
					КонецЕсли;
					СтрокаПоляРеквизитаТЧ 					= СтрокаДерева.Строки.Добавить();
					СтрокаПоляРеквизитаТЧ.Поле 				= ПутьКДанным+"."+РеквизитПодчиненный.Имя;
					СтрокаПоляРеквизитаТЧ.Представление 	= Представление+": "+РеквизитПодчиненный.Синоним;
					ДополнитьСписокПолямиРеквизита(СтрокаПоляРеквизитаТЧ,СтрокаПоляРеквизитаТЧ.Поле,СтрокаПоляРеквизитаТЧ.Представление,РеквизитПодчиненный.Тип,Вложенность+1);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
