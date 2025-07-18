﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
   		Если Объект.Предопределенный Тогда
			Элементы.ТипЗначения.Доступность=Ложь;
			Возврат;
		КонецЕсли;

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	НастройкаДополнительныхРазрезовБюджетирования.Измерение
			|ИЗ
			|	РегистрСведений.фин_НастройкаДополнительныхРазрезовБюджетирования КАК НастройкаДополнительныхРазрезовБюджетирования
			|ГДЕ
			|	НастройкаДополнительныхРазрезовБюджетирования.Разрез = &Разрез";

		Запрос.УстановитьПараметр("Разрез", Объект.Ссылка);

		Результат = Запрос.Выполнить();

		Выборка = Результат.Выбрать();

		Если Выборка.Следующий() Тогда
			
			ИмяРазреза = фин_РаботаСДополнительнымиРазрезамиБюджетирования.ИмяРазреза(Выборка.Измерение);
			Поле = ?(Найти(ИмяРазреза,"Разрез")=0,ИмяРазреза,"ДополнительныеРазрезы."+ИмяРазреза);
	
			Если фин_ПривилегированныеПроцедуры.ИмеютсяДанныеПоРазрезу(Выборка.Измерение,ИмяРазреза,Поле,Объект.ТипЗначения) Тогда
				//Элементы.ТипЗначения.Доступность=Ложь;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Тип субконто недоступен для изменения, т.к. заполнены данные по дополнительному разрезу!");
				Возврат;
			КонецЕсли;

			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ФинансовыеПоказателиРазрезыУчета.Ссылка
				|ИЗ
				|	Справочник.фин_ФинансовыеПоказатели.РазрезыУчета КАК ФинансовыеПоказателиРазрезыУчета
				|ГДЕ
				|	ФинансовыеПоказателиРазрезыУчета.Разрез = &Разрез
				|	И (НЕ ФинансовыеПоказателиРазрезыУчета.ОсновноеЗначение.Ссылка.Ссылка ЕСТЬ NULL )";

			Запрос.УстановитьПараметр("Разрез", Объект.Ссылка);

			Результат = Запрос.Выполнить();
  			Если НЕ Результат.Пустой() Тогда
				//Элементы.ТипЗначения.Доступность=Ложь;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Тип субконто недоступен для изменения, т.к. заполнены данные по дополнительному разрезу!");
				Возврат;
			КонецЕсли;

		КонецЕсли;
	Иначе
		
		Объект.ТипЗначения = фин_ОбщегоНазначенияВызовСервераПовтИсп.ОписаниеТиповУправленческоеПодразделение();
		
	КонецЕсли;
КонецПроцедуры
