﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Отбор",Новый Структура("РасчетныйПоказатель",ПараметрКоманды));
	ОткрытьФорму(ИмяРегистра(ПараметрКоманды)+".ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,?(фин_ОбщегоНазначенияКлиентПовтИсп.РежимОтдельногоОткрытияОкон(),ВариантОткрытияОкна.ОтдельноеОкно,ПараметрыВыполненияКоманды.Окно));
КонецПроцедуры

&НаСервере
Функция ИмяРегистра(Показатель)
	Возврат ?(Показатель.СпособВвода=Перечисления.фин_СпособыВводаЗначенийРасчетныхПоказателей.ВКаждомПериоде,"РегистрНакопления.фин_ЗначенияРасчетныхПоказателейЗаПериод","РегистрСведений.фин_ПериодическиеЗначенияРасчетныхПоказателей");	
КонецФункции
