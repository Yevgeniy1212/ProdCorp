﻿Перем ЗаполнениеПараметров Экспорт;
Перем СохраненнаяНастройка Экспорт;
Перем ДанныеРасшифровки Экспорт;

Процедура Скомпоновать(ДокументРезультат) Экспорт
	СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных[0].Запрос,"Справочник.общ_СценарииПланирования","Справочник."+фин_ОбщегоНазначенияВызовСервераПовтИсп.ПрефиксОбщихОбъектов()+"СценарииПланирования");
	СкомпоноватьРезультат(ДокументРезультат,ДанныеРасшифровки);	
КонецПроцедуры

ЗаполнениеПараметров = Новый Структура;
ЗаполнениеПараметров.Вставить("ДатаАктуальности",ТекущаяДата());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	фин_СформированныеБюджеты.Сценарий
		|ИЗ
		|	РегистрСведений.фин_СформированныеБюджеты КАК фин_СформированныеБюджеты";
	
	РезультатЗапроса = Запрос.Выполнить();
	Сценарии = Новый СписокЗначений;
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Сценарии.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Сценарий"));
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СценарииПланирования.Ссылка КАК Сценарий
			|ИЗ
			|	Справочник."+фин_ОбщегоНазначенияВызовСервераПовтИсп.ПрефиксОбщихОбъектов()+"СценарииПланирования КАК СценарииПланирования";
		
		РезультатЗапроса = Запрос.Выполнить();
		Сценарии.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Сценарий"));
	КонецЕсли;

ЗаполнениеПараметров.Вставить("Сценарии",Сценарии);
СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных[0].Запрос,"Справочник.общ_СценарииПланирования","Справочник."+фин_ОбщегоНазначенияВызовСервераПовтИсп.ПрефиксОбщихОбъектов()+"СценарииПланирования");

