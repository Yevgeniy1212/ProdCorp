﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АвтоЗаголовок = Ложь;
	Параметры.Свойство("Заголовок",Заголовок);
	Параметры.Свойство("ВидОтсчета",ВидОтсчета);
	Параметры.Свойство("ДатаОтсчета",ДатаОтсчета);
	Параметры.Свойство("ДнейОтсчета",ДнейОтсчета);
	Параметры.Свойство("ЕдиницаИзмеренияВремениИсполнения",ЕдиницаИзмеренияВремениИсполнения);
	Параметры.Свойство("ЕдиницаИзмеренияВремениОтсчета",ЕдиницаИзмеренияВремениОтсчета);
	Параметры.Свойство("СрокИсполнения",СрокИсполнения);
	Если Параметры.Свойство("Исполнители") Тогда
		Исполнители.ЗагрузитьЗначения(Параметры.Исполнители);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ВидОтсчета) Тогда
		ВидОтсчета = Перечисления.фин_ВидыОтсчетовСроковИсполнения.До;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ДатаОтсчета) Тогда
		ДатаОтсчета = Перечисления.фин_ГраницыБюджетногоПериода.НачалоБюджетногоПериода;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ЕдиницаИзмеренияВремениИсполнения) Тогда
		ЕдиницаИзмеренияВремениИсполнения = Перечисления.усд_ЕдиницыИзмеренияВремениИсполненияЗадачСогласования.Дней;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ЕдиницаИзмеренияВремениОтсчета) Тогда
		ЕдиницаИзмеренияВремениОтсчета = Перечисления.усд_ЕдиницыИзмеренияВремениИсполненияЗадачСогласования.Дней;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Если ПроверитьЗаполнение() Тогда
		Закрыть(Новый Структура("ВидОтсчета,ДатаОтсчета,ДнейОтсчета,ЕдиницаИзмеренияВремениИсполнения,ЕдиницаИзмеренияВремениОтсчета,СрокИсполнения,Исполнители,Удалить",ВидОтсчета,ДатаОтсчета,ДнейОтсчета,ЕдиницаИзмеренияВремениИсполнения,ЕдиницаИзмеренияВремениОтсчета,СрокИсполнения,Исполнители.ВыгрузитьЗначения(),Удалить));	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПриИзменении(Элемент)
	Элементы.ГруппаСрокИсполнения.Доступность = НЕ Удалить;
	Элементы.ГруппаОкончаниеСрокаИсполнения.Доступность = НЕ Удалить;
	Элементы.ГруппаИсполнители.Доступность = НЕ Удалить;
КонецПроцедуры
