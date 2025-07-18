﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДействияПриСохраненииСЭЦП = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "ДействияПриСохраненииСЭЦП");
	Если ДействияПриСохраненииСЭЦП.Пустая() Тогда
		ДействияПриСохраненииСЭЦП = Перечисления.ДействияПриСохраненииСЭЦП.Спрашивать;
	КонецЕсли;
	
	РасширениеДляЗашифрованныхФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "РасширениеДляЗашифрованныхФайлов");
	Если ПустаяСтрока(РасширениеДляЗашифрованныхФайлов) Тогда
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
	РасширениеДляФайловПодписи = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "РасширениеДляФайловПодписи");
	Если ПустаяСтрока(РасширениеДляФайловПодписи) Тогда
		РасширениеДляФайловПодписи = "p7s";
	КонецЕсли;
	
	ПутьМодуляКриптографии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "ПутьМодуляКриптографии");
	
	Если НЕ Параметры.ВебКлиентВLinux Тогда
		Элементы.ПутьМодуляКриптографии.Видимость = Ложь;
	КонецЕсли;	
	
	ОтпечатокЛичногоСертификатаДляШифрования = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "ОтпечатокЛичногоСертификатаДляШифрования");
	
	Если НЕ Параметры.Свойство("ПоказыватьНастройкиШифрования") Тогда
		Элементы.ЛичныйСертификатДляШифрования.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЭЦП");
	Элемент.Вставить("Настройка", "ДействияПриСохраненииСЭЦП");
	Элемент.Вставить("Значение", ДействияПриСохраненииСЭЦП);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЭЦП");
	Элемент.Вставить("Настройка", "ПутьМодуляКриптографии");
	Элемент.Вставить("Значение", ПутьМодуляКриптографии);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЭЦП");
	Элемент.Вставить("Настройка", "РасширениеДляЗашифрованныхФайлов");
	Элемент.Вставить("Значение", РасширениеДляЗашифрованныхФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЭЦП");
	Элемент.Вставить("Настройка", "ОтпечатокЛичногоСертификатаДляШифрования");
	Элемент.Вставить("Значение", ОтпечатокЛичногоСертификатаДляШифрования);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЭЦП");
	Элемент.Вставить("Настройка", "РасширениеДляФайловПодписи");
	Элемент.Вставить("Значение", РасширениеДляФайловПодписи);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЛичныйСертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		Предупреждение(НСтр("ru='Для выбора сертификата вам нужно установить расширение работы с криптографией.'"));
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	МассивСтруктурЛичныхСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина); // ТолькоЛичные
	
	ПараметрыФормы = Новый Структура("МассивСтруктурСертификатов", МассивСтруктурЛичныхСертификатов);		
	СтруктураВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВыборСертификата", ПараметрыФормы);
	
	Если ТипЗнч(СтруктураВозврата) = Тип("Структура") Тогда
		
		ОтпечатокЛичногоСертификатаДляШифрования = СтруктураВозврата.Отпечаток;
		
		СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиент.ЗаполнитьСтруктуруСертификатаПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования);
		ЛичныйСертификатДляШифрования = СтруктураСертификата.КомуВыдан;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОтпечатокЛичногоСертификатаДляШифрования <> Неопределено И НЕ ПустаяСтрока(ОтпечатокЛичногоСертификатаДляШифрования) Тогда
		Сертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования, Истина); // ТолькоЛичные
		Если Сертификат = Неопределено Тогда		
			ОтпечатокЛичногоСертификатаДляШифрования = "";
		Иначе
			СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиент.ЗаполнитьСтруктуруСертификатаПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования);
			ЛичныйСертификатДляШифрования = СтруктураСертификата.КомуВыдан;
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЛичныйСертификатОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОтпечатокЛичногоСертификатаДляШифрования <> Неопределено И НЕ ПустаяСтрока(ОтпечатокЛичногоСертификатаДляШифрования) Тогда
		ЭлектроннаяЦифроваяПодписьКлиент.ОткрытьСертификат(ОтпечатокЛичногоСертификатаДляШифрования);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЛичныйСертификатОчистка(Элемент, СтандартнаяОбработка)
	ОтпечатокЛичногоСертификатаДляШифрования = "";
КонецПроцедуры
