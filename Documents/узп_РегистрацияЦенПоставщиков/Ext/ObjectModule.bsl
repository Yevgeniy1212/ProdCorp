﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	фин_ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.узп_РегистрацияЦенПоставщиков.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
		фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаТовары, Движения, Отказ,"Товары","узп_УправлениеЗакупками","ЗарегистрироватьДвиженияРегистрацияЦенПоставщиков",,);
		//фин_УправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаТовары, Движения, Отказ,"Товары",,,"узп_ПереченьЦенПоставщиков",);
	КонецЕсли;	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИспользоватьХарактеристики = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("узп_ИспользоватьХарактеристикиНоменклатурыПриПланированииЗакупок");
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УстановкаЦенНоменклатуры") Тогда
		// Заполнение шапки
		Информация = ДанныеЗаполнения.Информация;
		Комментарий = ДанныеЗаполнения.Комментарий;
		НеПроводитьНулевыеЗначения = ДанныеЗаполнения.НеПроводитьНулевыеЗначения;
		ТипЦен = ДанныеЗаполнения.ТипЦен;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Валюта = ТекСтрокаТовары.Валюта;
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.дог_РегистрацияДоговоров") Тогда
		// Заполнение шапки
		Комментарий = ДанныеЗаполнения.Комментарий;
		Контрагент = ДанныеЗаполнения.Контрагент;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		ТипЦен = ДанныеЗаполнения.ТипЦен;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
			НоваяСтрока.Валюта = ДанныеЗаполнения.ВалютаДокумента;
		КонецЦикла;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Услуги Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
			НоваяСтрока.Валюта = ДанныеЗаполнения.ВалютаДокумента;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.узп_ЗаказПоставщику") Тогда
		// Заполнение шапки
		Комментарий = ДанныеЗаполнения.Комментарий;
		Контрагент = ДанныеЗаполнения.Контрагент;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		ТипЦен = ДанныеЗаполнения.ТипЦен;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
			НоваяСтрока.Валюта = ДанныеЗаполнения.ВалютаДокумента;
			Если ИспользоватьХарактеристики Тогда 
				НоваяСтрока.Характеристика = ТекСтрокаТовары.Характеристика;
			КонецЕсли;
			
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеНМА")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеИзПереработки") Тогда
		// Заполнение шапки
		Комментарий = ДанныеЗаполнения.Комментарий;
		Контрагент = ДанныеЗаполнения.Контрагент;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Если НЕ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеНМА") Тогда
			ТипЦен = ДанныеЗаполнения.ТипЦен;
		КонецЕсли;
		ЦеныПоставщика = узп_УправлениеЗакупками.ПолучитьСписокЦенПоставщика(ДанныеЗаполнения.Ссылка);
		Для Каждого ТекСтрокаТовары Из ЦеныПоставщика Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекСтрокаТовары);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.узп_Лот") Тогда
		// Заполнение шапки
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		ТипЦен = ДанныеЗаполнения.ТипЦен;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.Валюта = ТипЦен.ВалютаЦены;
			Если ИспользоватьХарактеристики Тогда 
				НоваяСтрока.Характеристика = ТекСтрокаТовары.Характеристика;
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	
	фин_ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("ВалютаРегламентированногоУчета"));
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ИспользоватьХарактеристики = фин_ОбщегоНазначенияВызовСервераПовтИсп.ЗначениеПеременной("узп_ИспользоватьХарактеристикиНоменклатурыПриПланированииЗакупок");
	
	//Проверка заполнения товаров
	Для Каждого СтрокаТовары Из Товары Цикл
		Если ИспользоватьХарактеристики Тогда 
			ПараметрыПоиска = Новый Структура("Номенклатура,Характеристика, Валюта",СтрокаТовары.Номенклатура,СтрокаТовары.Характеристика,СтрокаТовары.Валюта)
		Иначе
			ПараметрыПоиска = Новый Структура("Номенклатура,Валюта",СтрокаТовары.Номенклатура,СтрокаТовары.Валюта)
		КонецЕсли;
		
		Строки = Товары.НайтиСтроки(ПараметрыПоиска);
		Если Строки.Количество()>1 Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("
			|	- более одного раза задана цена для товара "+СтрокаТовары.Номенклатура+" в валюте "+СтрокаТовары.Валюта);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
	
#КонецЕсли
