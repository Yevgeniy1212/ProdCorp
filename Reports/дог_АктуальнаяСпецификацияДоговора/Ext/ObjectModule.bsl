﻿Перем ДанныеРасшифровки Экспорт;
Перем СохраненнаяНастройка Экспорт;

Процедура Скомпоновать(ДокументРезультат) Экспорт
	СкомпоноватьРезультат(ДокументРезультат,ДанныеРасшифровки);	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Для Каждого Реквизит Из Метаданные().Реквизиты Цикл
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(Реквизит.Имя,?(Реквизит.Имя="Дата",КонецДня(Дата),ЭтотОбъект[Реквизит.Имя]));
	КонецЦикла;
	Отчеты.дог_АктуальнаяСпецификацияДоговора.ДоработатьКомпоновщикПередВыводом(КомпоновщикНастроек,ОтображатьДанныеПоПодчиненнымДоговорамКонтрагента,ДоговорКонтрагента);
КонецПроцедуры
