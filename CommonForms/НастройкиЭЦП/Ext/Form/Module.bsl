﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПоказыватьНастройкиШифрования") Тогда
		Элементы.АлгоритмШифрования.Видимость = Ложь;
	КонецЕсли;	
	
	ГлавныйУзел = (ПланыОбмена.ГлавныйУзел() <> Неопределено);
	
	Если ГлавныйУзел Тогда // мы в не главном узле
		Элементы.АлгоритмПодписи.ТолькоПросмотр = Истина;
		Элементы.АлгоритмХеширования.ТолькоПросмотр = Истина;
		Элементы.АлгоритмШифрования.ТолькоПросмотр = Истина;
		Элементы.ПровайдерЭЦП.ТолькоПросмотр = Истина;
		Элементы.ТипПровайдераЭЦП.ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПутиМодулейКриптографииСерверовLinux.ИмяКомпьютера,
	               |	ПутиМодулейКриптографииСерверовLinux.ПутьМодуляКриптографии,
	               |	ПутиМодулейКриптографииСерверовLinux.Комментарий
	               |ИЗ
	               |	РегистрСведений.ПутиМодулейКриптографииСерверовLinux КАК ПутиМодулейКриптографииСерверовLinux";

	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Строка = ПутиМодулейКриптографииСерверовLinux.Добавить();
		
		Строка.ИмяКомпьютера = Выборка.ИмяКомпьютера;
		Строка.ПутьМодуляКриптографии = Выборка.ПутьМодуляКриптографии;
		Строка.Комментарий = Выборка.Комментарий;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасширениеПодключеноКрипто = ПодключитьРасширениеРаботыСКриптографией();
	
	ПерсональныеНастройкиРаботыСЭЦП = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП();
	ПровайдерЭЦП = ПерсональныеНастройкиРаботыСЭЦП.ПровайдерЭЦП;
	ПутьМодуляКриптографии = ПерсональныеНастройкиРаботыСЭЦП.ПутьМодуляКриптографии;
	ТипПровайдераЭЦП = ПерсональныеНастройкиРаботыСЭЦП.ТипПровайдераЭЦП;
	
	АлгоритмПодписи = ПерсональныеНастройкиРаботыСЭЦП.АлгоритмПодписи;
	АлгоритмХеширования = ПерсональныеНастройкиРаботыСЭЦП.АлгоритмХеширования;
	АлгоритмШифрования = ПерсональныеНастройкиРаботыСЭЦП.АлгоритмШифрования;
	
	ВыполнятьПроверкуЭЦПНаСервере = ПерсональныеНастройкиРаботыСЭЦП.ВыполнятьПроверкуЭЦПНаСервере;
	
	Элементы.ПутиМодулейКриптографииСерверовLinux.Доступность = ВыполнятьПроверкуЭЦПНаСервере;
	Элементы.ПутиМодулейКриптографииСерверовLinuxКоманднаяПанель.Доступность = ВыполнятьПроверкуЭЦПНаСервере;
	
	Если ТипПровайдераЭЦП = 0 Тогда
		ТипПровайдераЭЦП = 75; // Крипто Про
	КонецЕсли;	
	
	Если ПустаяСтрока(ПровайдерЭЦП) Тогда
		
		Попытка
			МенеджерКриптографии = Новый МенеджерКриптографии("", "", ТипПровайдераЭЦП);
			ИнформацияМенеджера = МенеджерКриптографии.ПолучитьИнформациюМодуляКриптографии();
			ПровайдерЭЦП = ИнформацияМенеджера.Имя;
		Исключение 
			// не обрабатываем исключение - вполне допустимо исключение, если нет ни одного криптопровайдера
		КонецПопытки;	
		
	КонецЕсли;	
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаСервере
Функция СохранитьПараметры()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Константы.ПровайдерЭЦП.Установить(ПровайдерЭЦП);
	Константы.ТипПровайдераЭЦП.Установить(ТипПровайдераЭЦП);
	Константы.АлгоритмХеширования.Установить(АлгоритмХеширования);
	Константы.АлгоритмПодписи.Установить(АлгоритмПодписи);
	Константы.АлгоритмШифрования.Установить(АлгоритмШифрования);
	Константы.ВыполнятьПроверкуЭЦПНаСервере.Установить(ВыполнятьПроверкуЭЦПНаСервере);
	
	Для Каждого Строка Из ПутиМодулейКриптографииСерверовLinux Цикл
		НаборЗаписей = РегистрыСведений.ПутиМодулейКриптографииСерверовLinux.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ИмяКомпьютера.Установить(Строка.ИмяКомпьютера);

		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ИмяКомпьютера = Строка.ИмяКомпьютера;
		НоваяЗапись.ПутьМодуляКриптографии = Строка.ПутьМодуляКриптографии;
		НоваяЗапись.Комментарий = Строка.Комментарий;

		НаборЗаписей.Записать();
	КонецЦикла;	
	
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Если НЕ СохранитьПараметры() Тогда
		Возврат;
	КонецЕсли;	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНаКлиенте()
	
	Элементы.АлгоритмПодписи.СписокВыбора.Очистить();
	Элементы.АлгоритмХеширования.СписокВыбора.Очистить();
	Элементы.АлгоритмШифрования.СписокВыбора.Очистить();
	
	Если ПустаяСтрока(ПровайдерЭЦП) Тогда
		Возврат;
	КонецЕсли;
		
	Попытка
		ПутьМодуляКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП().ПутьМодуляКриптографии;
		
		МенеджерКриптографии = Новый МенеджерКриптографии(ПровайдерЭЦП, ПутьМодуляКриптографии, ТипПровайдераЭЦП);
		ИнформацияМенеджера = МенеджерКриптографии.ПолучитьИнформациюМодуляКриптографии();
		
		// заполняем списки выбора
		Для Индекс = 0 По ИнформацияМенеджера.АлгоритмыПодписи.Количество() - 1 Цикл
			Строка = ИнформацияМенеджера.АлгоритмыПодписи.Получить(Индекс);
			Элементы.АлгоритмПодписи.СписокВыбора.Добавить(Строка);
		КонецЦикла;	
		
		Для Индекс = 0 По ИнформацияМенеджера.АлгоритмыХеширования.Количество() - 1 Цикл
			Строка = ИнформацияМенеджера.АлгоритмыХеширования.Получить(Индекс);
			Элементы.АлгоритмХеширования.СписокВыбора.Добавить(Строка);
		КонецЦикла;	
		
		Для Индекс = 0 По ИнформацияМенеджера.АлгоритмыШифрования.Количество() - 1 Цикл
			Строка = ИнформацияМенеджера.АлгоритмыШифрования.Получить(Индекс);
			Элементы.АлгоритмШифрования.СписокВыбора.Добавить(Строка);
		КонецЦикла;	
		
	Исключение
		
		Предупреждение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭЦППриИзменении(Элемент)
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьПроверкуЭЦПНаСервереПриИзменении(Элемент)
	
	Элементы.ПутиМодулейКриптографииСерверовLinux.Доступность = ВыполнятьПроверкуЭЦПНаСервере;
	Элементы.ПутиМодулейКриптографииСерверовLinuxКоманднаяПанель.Доступность = ВыполнятьПроверкуЭЦПНаСервере;
	
КонецПроцедуры


&НаКлиенте
Процедура ТипПровайдераЭЦППриИзменении(Элемент)
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

