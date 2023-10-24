﻿&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если Объект.Предопределенный Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Объект.Наименование = СокрЛП(Объект.Наименование);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Наименование = Объект.Наименование;
	ПроверитьДубльНаименованияНаСервере(Отказ, Объект.Ссылка, Наименование);
	Если Отказ Тогда
		ДиалогиСПользователемКлиент.ПоказатьСообщениеПользователю("Валюта с таким наименованием уже есть!");
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьДубльНаименованияНаСервере(Отказ, Ссылка, Наименование)
	Отказ = ОбщиеПроцедурыИФункцииСервер.ПроверитьНаличиеДубляНаименования(Наименование, "Валюты", Ссылка); 
КонецПроцедуры

