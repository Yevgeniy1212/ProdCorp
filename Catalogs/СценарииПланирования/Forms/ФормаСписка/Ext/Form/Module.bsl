﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	фин_БюджетированиеОбщегоНазначения.НастроитьОформлениеТабличногоПоля(Элементы.Список);
	Элементы.ДетализацияПланирования.Видимость = НЕ фин_ОбщегоНазначенияВызовСервераПовтИсп.РежимИнтеграции()=Перечисления.фин_РежимыИнтеграцииСУчетнойСистемой.УправлениеТорговлейДляКазахстана_3;
КонецПроцедуры
