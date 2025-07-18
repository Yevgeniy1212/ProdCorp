﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НадписьСоответствиеПлановойНоменклатуре = "Соответствие плановой номенклатуре";
КонецПроцедуры

&НаКлиенте
Процедура ПлановаяНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрыВыбора = Элементы.ПлановаяНоменклатура.ПараметрыВыбора;
	НовыйМассив = Новый Массив();
	НоваяСвязь = Новый ПараметрВыбора("Отбор.ТипПозицииВПланеЗакупок", ПолучитьТипПозиции());
	НовыйМассив.Добавить(НоваяСвязь);
	Элементы.ПлановаяНоменклатура.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
КонецПроцедуры

&НаСервере
Функция ПолучитьТипПозиции()
	Возврат ?(ТипЗнч(Запись.ВнеоборотныйАктив)=Тип("СправочникСсылка.ОсновныеСредства"),Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.ОсновноеСредство,Перечисления.узп_ТипыПозицийПлановойНоменклатурыВПланеЗакупок.НематериальныйАктив);
КонецФункции

