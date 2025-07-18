﻿&НаКлиенте
Перем СоответствиеКолонок;

&НаКлиенте
Перем СоответствиеКолонокОбратно;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СформироватьДерево();
	УстановитьШиринуКолонок();

КонецПроцедуры

&НаКлиенте
Процедура СформироватьДерево()
	//соответствие колонок списку перечислений
	СоответствиеКолонок = Новый Соответствие;
	СоответствиеКолонокОбратно = Новый Соответствие;
	СформироватьДеревоНаСервере(СоответствиеКолонок,СоответствиеКолонокОбратно);
	//УстановитьЗначенияВДереве(СоответствиеКолонокОбратно);
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоНаСервере(СоответствиеКолонок,СоответствиеКолонокОбратно)
	мДерево = Неопределено;
	ИсходныеДанные = ПолучитьИсходныеДанные();
	//получение таблицы разделов рабочего стола
	ТаблицаПрав = ИсходныеДанные[0].Выгрузить();
	//получение таблицы прав пользователей
	ТаблицаРазделов = ИсходныеДанные[1].Выгрузить();
	//загрузка прав доступа пользователей
	ТаблицаПравДоступа = ИсходныеДанные[2].Выгрузить();
	//сортировка по алфавиту колонок
	ТаблицаПравДоступа.Сортировать("Ссылка");
	//создание реквизитов колонок ТЧ
	ИзменитьРеквизитыФормы(ТаблицаПравДоступа,СоответствиеКолонок,СоответствиеКолонокОбратно,мДерево,ТаблицаРазделов); 
	//заполнение ТЧ формы
	ЗаполнениеПрав(ТаблицаПрав,СоответствиеКолонок);
КонецПроцедуры

&НаСервере
Функция ПолучитьИсходныеДанные()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	общ_НастройкиДоступаКРабочемуСтолу.Раздел,
	               |	общ_НастройкиДоступаКРабочемуСтолу.ПраваДоступа
	               |ИЗ
	               |	РегистрСведений.общ_НастройкиДоступаКРабочемуСтолу КАК общ_НастройкиДоступаКРабочемуСтолу
				   |ГДЕ НЕ общ_НастройкиДоступаКРабочемуСтолу.ПраваДоступа = ЗНАЧЕНИЕ(Перечисление.НаборПравПользователей.ПустаяСсылка)
				   |//////////////////////////////////////////////////////////////////////////
				   |;
				   |ВЫБРАТЬ
	               |	общ_РазделыРабочегоСтола.Ссылка,
	               |	общ_РазделыРабочегоСтола.Наименование КАК Наименование,
	               |	общ_РазделыРабочегоСтола.Родитель КАК Родитель
	               |ИЗ
	               |	Справочник.общ_РазделыРабочегоСтола КАК общ_РазделыРабочегоСтола
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Родитель,
	               |	Наименование
				   |//////////////////////////////////////////////////////////////////////////
				   |;
				   |ВЫБРАТЬ
	               |	НаборПравПользователей.Ссылка КАК Ссылка
	               |ИЗ
	               |	Перечисление.НаборПравПользователей КАК НаборПравПользователей
	               |ГДЕ
	               |	НаборПравПользователей.Ссылка <> ЗНАЧЕНИЕ(Перечисление.НаборПравПользователей.ПолныеПрава)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка";
	Результат = Запрос.ВыполнитьПакет();
	Возврат Результат;	
КонецФункции

&НаСервере
Процедура ИзменитьРеквизитыФормы(ТаблицаПравДоступа,СоответствиеКолонок,СоответствиеКолонокОбратно, мДерево,ТаблицаРазделов)
	//загрузка в дерево значений разделов
	мДерево = РеквизитФормыВЗначение("Дерево");	
	Для каждого СтрокаТЧ из ТаблицаРазделов Цикл
		ДобавитьЭлементДереваВрекурсии(СтрокаТЧ, мДерево);
	КонецЦикла;
	МассивКолонокФормы = Новый Массив;
	к=0;
	Для каждого СтрокаТЧ из ТаблицаПравДоступа Цикл
		//СоответствиеКолонок.Вставить("КолонкаДоступа"+Строка(к),СтрокаТЧ.Ссылка);
		СоответствиеКолонок.Вставить(СтрокаТЧ.Ссылка,"КолонкаДоступа"+Строка(к));
		СоответствиеКолонокОбратно.Вставить("КолонкаДоступа"+Строка(к),СтрокаТЧ.Ссылка);
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("Булево"));
		ОписаниеБулево = Новый ОписаниеТипов(МассивТипов);
		//НоваяКолонка = мДерево.Колонки.Добавить("КолонкаДоступа"+Строка(к), ОписаниеБулево, СтрокаТЧ.Ссылка);
		НоваяКолонка = мДерево.Колонки.Добавить("КолонкаДоступа"+Строка(к), ОписаниеБулево, СтрокаТЧ.Ссылка);
		НоваяКолонкаФормы = Новый РеквизитФормы("КолонкаДоступа"+Строка(к), ОписаниеБулево,"Дерево",ПеревестиСтрокиПоПробелам(Строка(СтрокаТЧ.Ссылка)));
		МассивКолонокФормы.Добавить(НоваяКолонкаФормы);
		
		к=к+1;
	КонецЦикла;
	ИзменитьРеквизиты(МассивКолонокФормы);
	ЗначениеВРеквизитФормы(мДерево,"Дерево");
	к=0;
	Для Каждого СтрокаТЧ из мДерево.Колонки Цикл
		Если Не Найти(ВРег(СтрокаТЧ.Имя), Врег("КолонкаДоступа")) = 0 Тогда
			Элемент = Элементы.Добавить("КолонкаДоступа"+Строка(к),Тип("ПолеФормы"),Элементы.Дерево);
			Элемент.Вид = ВидПоляФормы.ПолеФлажка;
			Элемент.ПутьКДанным = "Дерево.КолонкаДоступа"+Строка(к);
			Элемент.ЦветФонаЗаголовка = Новый Цвет(176,196,222);
			Элемент.ЦветТекстаЗаголовка = Новый Цвет(0,66,66);
			Элемент.ЦветРамки = Новый Цвет(176,196,222);
			Элемент.ОтображатьВШапке = Истина;
			Элемент.Заголовок = ПеревестиСтрокиПоПробелам(СтрокаТЧ.Заголовок);
			Элемент.ВысотаЗаголовка = 7;
			Элемент.ГоризонтальноеПоложениеВШапке=ГоризонтальноеПоложениеЭлемента.Центр;
			//Элемент.АвтоВысотаЯчейки = Истина;
			Элемент.УстановитьДействие("ПриИзменении","ВыборПраваПриИзменении");
			к=к+1;
		КонецЕсли;
	КонецЦикла;	
	КоличествоКолонокДоступа = к;
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеПрав(ТаблицаПрав,СоответствиеКолонок)
	мДерево = РеквизитФормыВЗначение("Дерево");
	Для Каждого СтрокаТЧ из мДерево.Строки Цикл
		Для к=0 По КоличествоКолонокДоступа-1 Цикл
			СтрокаТЧ["КолонкаДоступа"+Строка(к)] = Ложь;
			Для Каждого ПодСтрокаТЧ Из СтрокаТЧ.Строки Цикл
				ПодСтрокаТЧ["КолонкаДоступа"+Строка(к)] = Ложь;
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого СтрокаТЧ из ТаблицаПрав Цикл
		НайденныеСтроки = мДерево.Строки.Найти(СтрокаТЧ.Раздел,"Раздел",истина);
		Если не НайденныеСтроки = Неопределено Тогда
			НайденныеСтроки[СоответствиеКолонок.Получить(СтрокаТЧ.ПраваДоступа)]=Истина;
		КонецЕсли;
	КонецЦикла;
	ЗначениеВРеквизитФормы(мДерево,"Дерево");	
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЭлементДереваВрекурсии(Строка, ДеревоСтрок)
	НайденнаяСтрока = ДеревоСтрок.Строки.Найти(Строка,"Раздел",Истина);
	НоваяСтрока = НайденнаяСтрока;
	Если НайденнаяСтрока = Неопределено Тогда
		Если ЗначениеЗаполнено(Строка.Родитель) Тогда
			СтрокаРодителя = ДобавитьЭлементДереваВрекурсии(Строка.Родитель, ДеревоСтрок);
			Если Не СтрокаРодителя = Неопределено Тогда
				НоваяСтрока = СтрокаРодителя.Строки.Добавить();
				НоваяСтрока.Раздел = Строка.Ссылка;
			КонецЕсли;
		Иначе
			НоваяСтрока = ДеревоСтрок.Строки.Добавить();
			НоваяСтрока.Раздел = Строка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	Возврат НоваяСтрока;
КонецФункции

&НаКлиенте
Процедура ВыборПраваПриИзменении(Элемент)
	ПроверкаУстановкиФлагаРодителя(Элементы.Дерево.ТекущиеДанные,Элементы.Дерево.ТекущийЭлемент);
КонецПроцедуры

&НаКлиенте
Функция ПроверкаУстановкиФлагаРодителя(ТекущиеДанные,ТекущийЭлемент)
	Для к=0 По КоличествоКолонокДоступа-1 Цикл
		Для каждого СтрокаПервогоУровня из Дерево.ПолучитьЭлементы() Цикл
			Если СтрокаПервогоУровня.Раздел = ТекущиеДанные.Раздел Тогда
				Для каждого СтрокаВторогоУровня из СтрокаПервогоУровня.ПолучитьЭлементы() Цикл
					СтрокаВторогоУровня[ТекущийЭлемент.Имя] = СтрокаПервогоУровня[ТекущийЭлемент.Имя];
				КонецЦикла;
			Иначе
				ВсеНеОтмеченныеПодчиненные = Истина;
				СтрокаПервогоУровняНайдена = Ложь;
				ЕстьОтмеченныеПодчиненные = Ложь;
				Для каждого СтрокаВторогоУровня из СтрокаПервогоУровня.ПолучитьЭлементы() Цикл
					Если СтрокаВторогоУровня.Раздел = ТекущиеДанные.Раздел Тогда
						СтрокаПервогоУровняНайдена = Истина;
						ЕстьОтмеченныеПодчиненные = ?(СтрокаВторогоУровня[текущийЭлемент.Имя],СтрокаВторогоУровня[текущийЭлемент.Имя],ЕстьОтмеченныеПодчиненные);
						Если ЕстьОтмеченныеПодчиненные Тогда
							СтрокаПервогоУровня[ТекущийЭлемент.Имя] = ЕстьОтмеченныеПодчиненные;
							//Прервать;
						КонецЕсли;
					КонецЕсли;
					ВсеНеОтмеченныеПодчиненные = ?(ВсеНеОтмеченныеПодчиненные, Не СтрокаВторогоУровня[ТекущийЭлемент.Имя],ВсеНеОтмеченныеПодчиненные);
				КонецЦикла;
				Если ВсеНеОтмеченныеПодчиненные и СтрокаПервогоУровняНайдена тогда
					СтрокаПервогоУровня[ТекущийЭлемент.Имя] = не ВсеНеОтмеченныеПодчиненные;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецФункции

&НаКлиенте
Процедура Записать(Команда)
	Ответ = Вопрос("Записать права доступа?",РежимДиалогаВопрос.ДаНет,0);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаСервере(СоответствиеКолонокОбратно);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(СоответствиеКолонокОбратно)
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.общ_РазделыРабочегоСтола"));
	ОписаниеТипаРаздела = Новый ОписаниеТипов(МассивТипов);	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ПеречислениеСсылка.НаборПравПользователей"));
	ОписаниеТипаПраваДоступа = Новый ОписаниеТипов(МассивТипов);	
	
	ТаблицаЗаписей = Новый ТаблицаЗначений;
	ТаблицаЗаписей.Колонки.Добавить("Раздел",ОписаниеТипаРаздела);
	ТаблицаЗаписей.Колонки.Добавить("ПраваДоступа",ОписаниеТипаПраваДоступа);
	мДерево = РеквизитФормыВЗначение("Дерево");
	ЗаписатьВРекурсии(мДерево.Строки, ТаблицаЗаписей,СоответствиеКолонокОбратно);
	НаборЗаписей = РегистрыСведений.общ_НастройкиДоступаКРабочемуСтолу.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	НаборЗаписей.Записывать=Истина;
	НаборЗаписей.Загрузить(ТаблицаЗаписей);
	НаборЗаписей.Записать(Истина);
КонецПроцедуры

&НаСервере
Функция ЗаписатьВРекурсии(Строки, ТаблицаЗаписей,СоответствиеКолонокОбратно)
	Для каждого СтрокаТЧ из Строки Цикл
		Если СтрокаТЧ.Строки.Количество()>0 Тогда
			ЗаписатьВРекурсии(СтрокаТЧ.Строки,ТаблицаЗаписей,СоответствиеКолонокОбратно);
		КонецЕсли;
		Для к=0 по КоличествоКолонокДоступа-1 Цикл
			Если СтрокаТЧ["КолонкаДоступа"+Строка(к)] = Истина тогда
				НоваяСтрока = ТаблицаЗаписей.Добавить();
				НоваяСтрока.Раздел = СтрокаТЧ.Раздел;
				НоваяСтрока.ПраваДоступа = СоответствиеКолонокОбратно.Получить("КолонкаДоступа"+Строка(к));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецФункции

&НаКлиенте
Процедура Восстановить(Команда)
	Ответ = Вопрос("Текущие изменения будут утеряны. Продолжить?",РежимДиалогаВопрос.ДаНет,0);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		НомерСтроки = Элементы.Дерево.ТекущаяСтрока;
		НомерСтроки = Дерево.НайтиПоИдентификатору(НомерСтроки);
		ВосстановитьНаСервере(СоответствиеКолонок);
		Для Каждого СтрокаТЧ Из Дерево.ПолучитьЭлементы() Цикл
			Элементы.Дерево.Развернуть(СтрокаТЧ.ПолучитьИдентификатор());
		КонецЦикла;
		Элементы.Дерево.ТекущаяСтрока = НомерСтроки;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНаСервере(СоответствиеКолонок)
	ИсходныеДанные = ПолучитьИсходныеДанные();
	ТаблицаПрав = ИсходныеДанные[0].Выгрузить();
	
	ЗаполнениеПрав(ТаблицаПрав,СоответствиеКолонок);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьШиринуКолонок()
	//Для к= 0 По КоличествоКолонокДоступа-1 Цикл
	//	Элементы.Дерево.ПодчиненныеЭлементы["КолонкаДоступа"+Строка(к)].ФиксацияВТаблице = Лево;
	//КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПеревестиСтрокиПоПробелам(Строка)
//Символы.ПС	
	ИзмененнаяСтрока = СтрЗаменить(Строка," ",Символы.ПС);
	Возврат ИзмененнаяСтрока;
КонецФункции

&НаСервере
Процедура УстановитьСтандартныеНастройкиНаСервере()
	//Обработка = Обработки.ОбновлениеИнформационнойБазы.Создать();
	//Обработка.ЗаполнитьПраваДоступаКРабочемуСтолу();
	
	 ЗаполнитьПраваДоступаКРабочемуСтолу(); 
	 
КонецПроцедуры

Процедура ЗаполнитьПраваДоступаКРабочемуСтолу(РольДляОбработки = Неопределено)  Экспорт
		НаборЗаписей = РегистрыСведений.общ_НастройкиДоступаКРабочемуСтолу.СоздатьНаборЗаписей();
		Если РольДляОбработки<>Неопределено Тогда
			РольПользователя = Перечисления.НаборПравПользователей[РольДляОбработки];
			НаборЗаписей.Отбор.ПраваДоступа.Установить(РольПользователя);
		КонецЕсли;
		МакетПрава = Обработки.ПанельФункций.ПолучитьМакет("ДоступностьСтраницПоРолям");
		СоответствиеРазделовИСтрокМакета = Новый Соответствие;
		Для Инд = 2 По МакетПрава.ВысотаТаблицы Цикл
			ОбластьМакета = МакетПрава.Область("R"+Строка(Инд)+"C1").Текст;
			Если ОбластьМакета<>"" И ЗначениеЗаполнено(ОбластьМакета) Тогда
				Попытка
					Раздел = Справочники.общ_РазделыРабочегоСтола[ОбластьМакета];
					СоответствиеРазделовИСтрокМакета.Вставить(Инд,Раздел);
				Исключение
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
		Для Инд = 2 По МакетПрава.ШиринаТаблицы Цикл
			ОбластьРоль = МакетПрава.Область("R1C"+Строка(Инд)).Текст;
			Если РольДляОбработки<>Неопределено И РольДляОбработки <> ОбластьРоль Тогда
				Продолжить;
			КонецЕсли;
			Если ОбластьРоль<>"" И ЗначениеЗаполнено(ОбластьРоль) Тогда
				Если Метаданные.Перечисления.НаборПравПользователей.ЗначенияПеречисления.Найти(ОбластьРоль)=Неопределено Тогда
					Продолжить;
				КонецЕсли;
				РольПользователя = Перечисления.НаборПравПользователей[ОбластьРоль];
			Иначе
				Продолжить;
			КонецЕсли;
			Для ИндексРаздел = 2 По МакетПрава.ВысотаТаблицы Цикл
				ОбластьПраво = МакетПрава.Область("R"+Строка(ИндексРаздел)+"C"+Строка(Инд)).Текст;
				Если ОбластьПраво="+" Тогда
					НЗ = НаборЗаписей.Добавить();
					НЗ.Раздел = СоответствиеРазделовИСтрокМакета.Получить(ИндексРаздел);
					НЗ.ПраваДоступа = РольПользователя;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		НаборЗаписей.Записать();
	КонецПроцедуры
	

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	УстановитьСтандартныеНастройкиНаСервере();
	СформироватьДерево();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ФормаУстановитьСтандартныеНастройки.Видимость = РольДоступна("ПолныеПрава");
КонецПроцедуры
