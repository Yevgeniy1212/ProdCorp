﻿Перем ЗаполнениеПараметров Экспорт;
Перем СохраненнаяНастройка Экспорт;
Перем ДанныеРасшифровки Экспорт;

Процедура Скомпоновать(ДокументРезультат) Экспорт
	СкомпоноватьРезультат(ДокументРезультат,ДанныеРасшифровки);	
КонецПроцедуры

ЗаполнениеПараметров = Новый Структура;
ЗаполнениеПараметров.Вставить("НачалоПериода",НачалоМесяца(ТекущаяДата()));
ЗаполнениеПараметров.Вставить("КонецПериода",ТекущаяДата());
