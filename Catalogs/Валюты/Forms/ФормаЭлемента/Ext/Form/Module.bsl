﻿
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если Объект.Предопределенный Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Объект.Наименование = СокрЛП(Объект.Наименование);
КонецПроцедуры
