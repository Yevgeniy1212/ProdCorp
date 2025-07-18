﻿
Функция АктуализироватьКодыТНВЭД(Знач ПараметрыВызова, Знач АдресХранилища) Экспорт

	НеобработанныеСтроки = ПараметрыВызова.ТаблицаАктуализации.СкопироватьКолонки();
	
	Для Каждого ТекСтрока Из ПараметрыВызова.ТаблицаАктуализации Цикл
		Если ТекСтрока.Пометка И Не ТекСтрока.Номенклатура.Пустая() И Не ПустаяСтрока(ТекСтрока.НовыйКодТНВЭД) Тогда
				
			НачатьТранзакцию();
			
			Попытка
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить(ТекСтрока.Номенклатура.Метаданные().ПолноеИмя());
				ЭлементБлокировки.УстановитьЗначение("Ссылка", ТекСтрока.Номенклатура);
				Блокировка.Заблокировать();
				
				НоменклатураОбъект = ТекСтрока.Номенклатура.ПолучитьОбъект();
				Если НоменклатураОбъект = Неопределено Тогда
					ОтменитьТранзакцию();
					Продолжить;
				КонецЕсли;
				
				НоменклатураОбъект.КодТНВЭД = ТекСтрока.НовыйКодТНВЭД;
				//БК2
				//ОбновлениеИнформационнойБазы.ЗаписатьДанные(НоменклатураОбъект);
				НоменклатураОбъект.Записать();
				//БК2
      				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				ТекстСообщения = НСтр("ru = 'Не удалось обработать %Ссылка% по причине: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ТекСтрока.Номенклатура);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				//БК 2
				//ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Актуализация кодов ТН ВЭД по ГСВС'"),, УровеньЖурналаРегистрации.Предупреждение,
					ТекСтрока.Номенклатура.Метаданные(), ТекСтрока.Номенклатура, ТекстСообщения);
			    //БК 2
				ЗаполнитьЗначенияСвойств(НеобработанныеСтроки.Добавить(), ТекСтрока);
			КонецПопытки;
			
		Иначе
			ЗаполнитьЗначенияСвойств(НеобработанныеСтроки.Добавить(), ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	АдресХранилища = ПоместитьВоВременноеХранилище(НеобработанныеСтроки, АдресХранилища);
	
	Возврат АдресХранилища;

КонецФункции
