﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения)=Тип("Структура") И ДанныеЗаполнения.Свойство("Владелец") И (ТипЗнч(ДанныеЗаполнения.Владелец)=Тип("Массив") ИЛИ ТипЗнч(ДанныеЗаполнения.Владелец)=Тип("СписокЗначений")) Тогда
		Владельцы = ?(ТипЗнч(ДанныеЗаполнения.Владелец)=Тип("Массив"),ДанныеЗаполнения.Владелец,ДанныеЗаполнения.Владелец.ВыгрузитьЗначения());
		Если Владельцы.Количество()=1 Тогда
			Владелец = Владельцы[0];
		ИначеЕсли Владельцы.Количество()>1 Тогда
			Для Каждого ВладелецЗаполнение Из Владельцы Цикл
				Если ТипЗнч(ВладелецЗаполнение)=Тип("СправочникСсылка.фин_НастройкиОтчетовПоБюджетам") Тогда
					Владелец = ВладелецЗаполнение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
