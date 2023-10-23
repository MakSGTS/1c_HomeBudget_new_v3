﻿
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Объект.Наименование = СокрЛП(Объект.Наименование);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Наименование = Объект.Наименование;
	ПроверитьДубльНаименованияНаСервере(Отказ, Объект.Ссылка, Наименование);
	Если Отказ Тогда
		ДиалогиСПользователемКлиент.ПоказатьСообщениеПользователю("Источник с таким наименованием уже есть!");
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьДубльНаименованияНаСервере(Отказ, Ссылка, Наименование);
	Отказ = ОбщиеПроцедурыИФункцииСервер.ПроверитьНаличиеДубляНаименования(Наименование, "ИсточникПоступлений", Ссылка); 
КонецПроцедуры
