﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	фин_БюджетированиеОбщегоНазначения.НастроитьОформлениеТабличногоПоля(Элементы.Список);
	Если НЕ ПолучитьФункциональнуюОпцию("фин_УчетПоПлануСчетовБюджетирования") Тогда
		НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		НовыйОтбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Ссылка");
		НовыйОтбор.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеВИерархии;
		НовыйОтбор.ПравоеЗначение	= Справочники.фин_ВидыОтчетовПоБюджетам.УправленческийПланСчетов;
		НовыйОтбор.Использование	= Истина;
	КонецЕсли;
	Если Параметры.Свойство("ВыборДляНастроекОтчета") И Параметры.ВыборДляНастроекОтчета=Истина Тогда
		НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		НовыйОтбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Ссылка");
		НовыйОтбор.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеВСписке;
		НовыйОтбор.ПравоеЗначение	= Справочники.фин_ВидыОтчетовПоБюджетам.ОтчетыССобственнымиНастройками();
		НовыйОтбор.Использование	= Истина;
	КонецЕсли;
КонецПроцедуры
