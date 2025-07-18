﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


//Процедура ОбработкаПроведения
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	фин_ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	ПараметрыПроведения = Документы.фин_КалендарныйПланБюджетнойКампании.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
	фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаГрафикПроцесса, Движения, Отказ,"ГрафикПроцесса",,,"фин_КалендарныеПланыБюджетныхКампаний");	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	БюджетированиеПоОрганизациям 	= фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("БюджетированиеПоОрганизациям");
	Если НЕ БюджетированиеПоОрганизациям Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
		
	фин_ЗаполнениеДокументов.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	фин_ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект,фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаРегламентированногоУчета"));
КонецПроцедуры

#КонецЕсли

