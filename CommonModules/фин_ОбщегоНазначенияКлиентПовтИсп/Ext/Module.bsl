﻿Функция ПустоеЗначениеПроект() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ПустоеЗначениеРазреза("Проект");	
КонецФункции

Функция ПустоеЗначениеУправленческоеПодразделение() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ПустоеЗначениеРазреза("УправленческоеПодразделение");	
КонецФункции

Функция ДетализацияПланированияНоменклатурныеГруппы() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ДетализацияПланированияНоменклатурныеГруппы();	
КонецФункции

Функция СостояниеОбъектаУтвержден() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.СостояниеОбъектаУтвержден();	
КонецФункции

Функция ПустаяСсылкаСценарий() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ПустаяСсылкаСценарий();	
КонецФункции

Функция ТипСправочникСценариевПланирования() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ТипСправочникСценариевПланирования();	
КонецФункции

Функция РежимОтдельногоОткрытияОкон() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию("ОткрыватьПодчиненныеОкнаВОтдельномОкне")=Истина;
КонецФункции

Функция ТипНоменклатурныеГруппыСсылка() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ТипНоменклатурныеГруппыСсылка();	
КонецФункции

Функция ПустойТипПлановыхЦен() Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.ПустойТипПлановыхЦен();	
КонецФункции


#Область РаботаСДаннымиСтатей

Функция ИтоговаяФункцияСтроки(Статья,Бюджет) Экспорт
	КЭШ_ДанныеСтатей = фин_ОбщегоНазначенияКлиентПовтИсп.КЭШ_ДанныеСтатейБюджетаЧерезСоответствия(Бюджет);
	Результат = КЭШ_ДанныеСтатей.Получить(Статья);
	Если Результат<>Неопределено Тогда
		Возврат Результат.ИтоговаяФункция;
	КонецЕсли;
    Возврат ПредопределенноеЗначение("Перечисление.фин_ИтоговыеФункции.Сумма");
КонецФункции

Функция ИсключитьИзИтогов(Статья,Бюджет) Экспорт
	КЭШ_ДанныеСтатей = фин_ОбщегоНазначенияКлиентПовтИсп.КЭШ_ДанныеСтатейБюджетаЧерезСоответствия(Бюджет);
	Результат = КЭШ_ДанныеСтатей.Получить(Статья);
	Если Результат<>Неопределено Тогда
		Возврат Результат.ИсключитьИзИтогов;
	КонецЕсли;
    Возврат Ложь;
КонецФункции

Функция ЭтоГруппа(Статья,Бюджет) Экспорт
	КЭШ_ДанныеСтатей = фин_ОбщегоНазначенияКлиентПовтИсп.КЭШ_ДанныеСтатейБюджетаЧерезСоответствия(Бюджет);
	Результат = КЭШ_ДанныеСтатей.Получить(Статья);
	Если Результат<>Неопределено Тогда
		Возврат Результат.ЭтоГруппа;
	КонецЕсли;
    Возврат Ложь;
КонецФункции

Функция КЭШ_ДанныеСтатейБюджетаЧерезСоответствия(Бюджет) Экспорт
	Возврат фин_ОбщегоНазначенияВызовСервераПовтИсп.КЭШ_ДанныеСтатейБюджетаЧерезСоответствия(Бюджет);	
КонецФункции

#КонецОбласти
