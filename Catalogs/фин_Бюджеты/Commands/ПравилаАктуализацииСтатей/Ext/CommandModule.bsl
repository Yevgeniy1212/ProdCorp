﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Отбор",Новый Структура("Бюджет",ПараметрКоманды) );
	ОткрытьФорму("РегистрСведений.фин_ПорядокАктуализацииСтатейБюджетов.Форма.ФормаНастройки", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ?(фин_ОбщегоНазначенияКлиентПовтИсп.РежимОтдельногоОткрытияОкон(),ВариантОткрытияОкна.ОтдельноеОкно,ПараметрыВыполненияКоманды.Окно), ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
