﻿// Данная функция возвращает строку с версией платформы, которая требуется для работы конфигурации. 
// Версия возвращается в формате <основная версия>.<младшая версия>.<релиз>.<дополнительный номер релиза>
// или более коротком, например, "8.1.10.5", "8.1.13"
// Если требований к версии платформы нет, функция может возвращать пустую строку
Функция РекомендуемаяВерсияПлатформы(НомерВерсии = "8.2")
	
	Если НомерВерсии = "8.2" Тогда //8.2
		Возврат "8.2.19";
	ИначеЕсли НомерВерсии = "8.3" Тогда //8.3
		Возврат "8.3.11";
	КонецЕсли;
		
КонецФункции

// Проверка версии платформы.
// Если версия платформы боле поздняя, чем требуется, работа программы будет прекращена.
Процедура ПроверитьВерсиюПлатформы() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ТекущаяВерсия = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СистемнаяИнформация.ВерсияПриложения, ".");
	//смотрим, какая ситема используется 8.3 или 8.2
	Если Число(ТекущаяВерсия[0]) >= 8 И Число(ТекущаяВерсия[1]) = 3 Тогда //8.3
		ТекВерсия = РекомендуемаяВерсияПлатформы("8.3");
		РекомендуемаяВерсия = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ТекВерсия, ".");
	ИначеЕсли Число(ТекущаяВерсия[0]) >= 8 И Число(ТекущаяВерсия[1]) = 2 Тогда //8.2
		ТекВерсия = РекомендуемаяВерсияПлатформы("8.2");
		РекомендуемаяВерсия = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ТекВерсия, ".");
	КонецЕсли;  		
	
	Для Счетчик = РекомендуемаяВерсия.Количество() + 1 По ТекущаяВерсия.Количество() Цикл
		РекомендуемаяВерсия.Добавить("0");
	КонецЦикла;
	
	ВерсияПодходит = Истина;
	Для Счетчик = 0 По ТекущаяВерсия.ВГраница() Цикл
		Если Число(ТекущаяВерсия[Счетчик]) < ?(ПустаяСтрока(РекомендуемаяВерсия[Счетчик]), 0, Число(РекомендуемаяВерсия[Счетчик])) Тогда
			ВерсияПодходит = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ВерсияПодходит Тогда
		Возврат;
	КонецЕсли;
	
	Предупреждение("Для работы с данной конфигурацией требуется версия платформы 1С:Предприятие " + 
		ТекВерсия + " или более поздняя." + 
		Символы.ПС + "Используемая сейчас версия - " + СистемнаяИнформация.ВерсияПриложения + "." + 
		Символы.ПС + 
		Символы.ПС + "Для получения новой версии платформы 1С:Предприятие воспользуйтесь диском Информационно-технологического сопровождения (ИТС) " + 
		"или разделом сайта фирмы ""1С"" для пользователей: http://users.v8.1c.ru" + 
		Символы.ПС + 
		Символы.ПС + "Если Вы не являетесь подписчиком диска ИТС, Вам необходимо оформить подписку.",60);
		
				
КонецПроцедуры
