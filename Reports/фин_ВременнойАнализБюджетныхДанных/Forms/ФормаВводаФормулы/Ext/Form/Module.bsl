﻿&НаКлиенте
Перем СоответствиеКоманд;

&НаКлиенте
Процедура ВыборФункции(Команда)
	Если Найти(Команда.Имя,"Цифра")=0 Тогда
		Элементы.Формула.ВыделенныйТекст = СоответствиеКоманд.Получить(Команда.Имя);
	Иначе
		Элементы.Формула.ВыделенныйТекст = Сред(Команда.Имя,СтрДлина("Цифра")+1);
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НадписьПоказателиФормулы = "Показатели формулы";
	НадписьФормула = "Формула";
	Если Параметры.Свойство("Формула") Тогда
		Формула = Параметры.Формула;
	КонецЕсли;
	Если Параметры.Свойство("ВходящиеПоказатели") Тогда
		ВходящиеПоказателиПолученные = ПолучитьИзВременногоХранилища(Параметры.ВходящиеПоказатели);
		Для Каждого СтрокаПараметр Из ВходящиеПоказателиПолученные Цикл
			НС = ВходящиеПоказатели.Добавить();
			ЗаполнитьЗначенияСвойств(НС,СтрокаПараметр);
		КонецЦикла;
	КонецЕсли;
	ТекстФормулы = Формула;
	ПредставлениеФормулы.УстановитьТекст(ТекстФормулы);
	НастроитьДоступность();
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступность()
    Элементы.ВходящиеПоказателиЗначение.Видимость=УказыватьТестовыеЗначения;
КонецПроцедуры

&НаКлиенте
Процедура ВходящиеПоказателиНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	Если Элементы.ВходящиеПоказатели.ТекущиеДанные.Поле="" Тогда
		Выполнение = Ложь;
	Иначе
		ПараметрыПеретаскивания.Значение = Элементы.ВходящиеПоказатели.ТекущиеДанные.Поле;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВФормулу(Команда)
	Если Элементы.ВходящиеПоказатели.ТекущиеДанные<>Неопределено И Элементы.ВходящиеПоказатели.ТекущиеДанные.Поле<>"" Тогда
		Элементы.Формула.ВыделенныйТекст = Элементы.ВходящиеПоказатели.ТекущиеДанные.Поле;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаФормулы(Команда)
	Если ПроверитьЗаполнение() Тогда
		ВыполнитьПроверку();
	Иначе
		ПоказатьПредупреждение(,"Перед продолжением заполните все необходимые поля!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверку()
	ТекстФормулы = ПредставлениеФормулы.ПолучитьТекст();
	ТекстФормулы = СтрЗаменить(ТекстФормулы,"КореньКв(",	"Sqrt(");
	ТекстФормулы = СтрЗаменить(ТекстФормулы,"Степень(",		"Pow(");
	ТаблицаЗначенийПоказателей = ВходящиеПоказатели.Выгрузить();
	ТаблицаЗначенийПоказателей.Колонки.Добавить("КодПоказателя");
	Для Каждого СтрокаТЗ Из ТаблицаЗначенийПоказателей Цикл
		СтрокаТЗ.КодПоказателя = СтрокаТЗ.Поле;
		Если НЕ УказыватьТестовыеЗначения Тогда
			СтрокаТЗ.Значение = 0;
		КонецЕсли;
	КонецЦикла;
	РезультатРасчета =  фин_ПроцедурыМеханизмовБюджетирования.РассчитатьОтрезокФормулы(ТекстФормулы,ТаблицаЗначенийПоказателей,"Проверка формулы: ",ТекущаяДата());
	Если УказыватьТестовыеЗначения Тогда
		Сообщить("Результат: "+Строка(РезультатРасчета));
	КонецЕсли;
	Сообщить("Готово.");
КонецПроцедуры

&НаКлиенте
Процедура УказыватьТестовыеЗначенияПриИзменении(Элемент)
	НастроитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(СтрЗаменить(ПредставлениеФормулы.ПолучитьТекст(),Символы.ПС," "));
КонецПроцедуры


СоответствиеКоманд = Новый Соответствие;
СоответствиеКоманд.Вставить("Выбор",	"ВЫБОР КОГДА  ТОГДА  ИНАЧЕ  КОНЕЦ");
СоответствиеКоманд.Вставить("Минус",	"-");
СоответствиеКоманд.Вставить("Плюс",		"+");
СоответствиеКоманд.Вставить("СкобкаЗакрывающая",	")");
СоответствиеКоманд.Вставить("СкобкаОткрывающая",	"(");
СоответствиеКоманд.Вставить("Умножить",	"*");
СоответствиеКоманд.Вставить("Делить",	"/");
СоответствиеКоманд.Вставить("Больше",		">");
СоответствиеКоманд.Вставить("Меньше",		"<");
СоответствиеКоманд.Вставить("Равно",		"=");
СоответствиеКоманд.Вставить("БольшеИлиРавно",		"=>");
СоответствиеКоманд.Вставить("МеньшеИлиРавно",		"<=");
СоответствиеКоманд.Вставить("НеРавно",		"<>");
СоответствиеКоманд.Вставить("Точка",		".");
СоответствиеКоманд.Вставить("НЕ",		" НЕ ");
СоответствиеКоманд.Вставить("И",		" И ");
СоответствиеКоманд.Вставить("ИЛИ",		" ИЛИ ");
