﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ОбработкаЗаписиНовогоОбъекта формы.
//
&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	Элементы.Список.ТекущаяСтрока = НовыйОбъект.Ссылка;
КонецПроцедуры

// Обработчик события Действие элемента КоменднаяПанель.ДействиеПодбор.
//
&НаКлиенте
Процедура Подбор(Команда)
	ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.УправляемаяФормаПодбораИзКлассификатора",, ЭтаФорма,);
КонецПроцедуры

