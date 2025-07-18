﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит список структурных единиц, по которым строится отчет
Перем мСписокСтруктурныхЕдиниц Экспорт; // (отчет)

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

Процедура СформироватьОтчет(РезультатОтчета) Экспорт
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Год").Значение 				= Год;
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Организация").Значение 		= мСписокСтруктурныхЕдиниц.ВыгрузитьЗначения();
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВидПланаЗакупок").Значение	= ВидПланаЗакупок;
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Ссылка").Значение 			= Ссылка;
	РезультатОтчета.Очистить();
	СкомпоноватьРезультат(РезультатОтчета);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

мСписокСтруктурныхЕдиниц = Новый СписокЗначений;
