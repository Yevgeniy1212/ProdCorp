﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("ФинансовыйПоказатель",ПараметрКоманды);
	ОткрытьФорму("Справочник.фин_ПравилаОтраженияФактическихДанных.Форма.ФормаПравилПоФинансовомуПоказателю", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,?(фин_ОбщегоНазначенияКлиентПовтИсп.РежимОтдельногоОткрытияОкон(),ВариантОткрытияОкна.ОтдельноеОкно,ПараметрыВыполненияКоманды.Окно), ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
