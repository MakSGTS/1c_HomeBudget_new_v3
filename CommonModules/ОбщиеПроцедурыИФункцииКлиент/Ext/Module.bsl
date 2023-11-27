﻿ 
Функция ПроверитьКорректностьСимволовЛогина(СтрокаЛогина) Экспорт
	ЛогинКорректен = Истина;
	
	СтрокаПоиска = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя=+/*,!""№;:%()\|`~'?&";         
	КоличествоСимволов = СтрДлина(СтрокаЛогина);
	НайденныеСовпадения = 0;
	
	Для рр = 1 По КоличествоСимволов Цикл		
		НайденныеСовпадения = НайденныеСовпадения + СтрНайти(СтрокаПоиска, Сред(СтрокаЛогина, рр, 1));
	КонецЦикла;
	Возврат НЕ НайденныеСовпадения > 0;
	
	ПозицияСобаки = СтрНайти(СтрокаЛогина, "@");
	Если ПозицияСобаки = 0 Тогда
		ЛогинКорректен = Ложь;
	Иначе
		ПраваяЧастьЛогина = Прав(СтрокаЛогина, СтрДлина(СтрокаЛогина) - ПозицияСобаки);
		ПозицияТочки = СтрНайти(ПраваяЧастьЛогина, ".");
		Если ПозицияТочки = 1 ИЛИ СтрНайти(ПраваяЧастьЛогина, "@") > 0 Тогда
			ЛогинКорректен = Ложь;
		КонецЕсли;
		ИмяДоменаСТочкой = Прав(ПраваяЧастьЛогина, СтрДлина(ПраваяЧастьЛогина - ПозицияТочки));
		Если СтрДлина(ИмяДоменаСТочкой) = 1 ИЛИ СтрНайти(ПраваяЧастьЛогина, "@") > 0 Тогда
			ЛогинКорректен = Ложь;	
		КонецЕсли;		
	КонецЕсли;
	
	Если НЕ ЛогинКорректен Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "e-mail введён не корректно";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Возврат ЛогинКорректен;
	
КонецФункции

Функция ПроверитьКорректностьСимволовПароля(СтрокаПароля) Экспорт
	СтрокаПоиска = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";         
	КоличествоСимволов = СтрДлина(СтрокаПароля);
	НайденныеСовпадения = 0;
	
	Для рр = 1 По КоличествоСимволов Цикл		
		НайденныеСовпадения = НайденныеСовпадения + СтрНайти(СтрокаПоиска, Сред(СтрокаПароля, рр, 1));
	КонецЦикла;
	Возврат НЕ НайденныеСовпадения > 0;	
КонецФункции

Функция ПолучитьФормуГлавногоЭкрана() Экспорт
	Возврат ПолучитьФорму("ОбщаяФорма.ГлавныйЭкран");
КонецФункции

Процедура ОбновиьГлавныйЭкран() Экспорт
	Окна = ПолучитьОкна();
	Для Каждого мОкно Из Окна Цикл
		//@skip-check unknown-method-property
		Если мОкно.Заголовок = "Домашний бюджет" И мОкно.НачальнаяСтраница Тогда
			//@skip-check unknown-method-property
			Форма = мОкно.Содержимое[0].ЭтаФорма;
			Форма.ОбновитьЭкран();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция имяФункции() Экспорт
	Возврат ОбщиеПроцедурыИФункцииСервер.ПолучитьУчетнуюЗапись();
КонецФункции
