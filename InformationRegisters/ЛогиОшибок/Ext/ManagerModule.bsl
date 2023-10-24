﻿
Процедура ЗаписатьОшибкуВЛоги(ТекстОшибки, СтруктураДанных = Неопределено, ОтправитьНаСервер = Истина, Важность = Неопределено) Экспорт
	Попытка
		Если НЕ ЗначениеЗаполнено(СтруктураДанных) Тогда
			СтруктураДанных = ПодготовитьИнформацибОбОшибке(ТекстОшибки,, Важность); 
		КонецЕсли;
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураДанных);
		
		МенеджерЗаписи.Записать(Ложь);
		
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		Если ОтправитьНаСервер Тогда
			МассивПараметров = Новый Массив;
			МассивПараметров.Добавить(СтруктураДанных);
			МассивПараметров.Добавить(Истина);
			
			ФонЗадание = ФоновыеЗадания.Выполнить("ЗапросыHTTP_Сервер.ОтправитьЛогиВДатаЦентр", МассивПараметров);
		КонецЕсли;
		
	Исключение
		Возврат;
	КонецПопытки;
КонецПроцедуры

Функция ПодготовитьИнформацибОбОшибке(ТекстОшибки, Отправлено = Ложь, Важность = Неопределено) Экспорт
	
	СтруктураИнформации = Новый Структура;
	
	ВажностьОшибки = ?(ЗначениеЗаполнено(Важность), Важность, ПредопределенноеЗначение("Перечисление.КритерииОшибок.НеКритичная")); 
	СисИнфо = Новый СистемнаяИнформация;        
	
	СтруктураИнформации.Вставить("Период",ТекущаяДата());
	СтруктураИнформации.Вставить("Дата",ТекущаяДата());
	СтруктураИнформации.Вставить("УниверсальнаяДата", ТекущаяУниверсальнаяДата());
	СтруктураИнформации.Вставить("ЧасовойПояс", ЧасовойПояс());
	СтруктураИнформации.Вставить("user_id", ОбщиеПроцедурыИФункцииСервер.ПолучитьЗначениеКонстанты("user_id"));
	СтруктураИнформации.Вставить("ВерсияОС" ,СисИнфо.ВерсияОС);
	СтруктураИнформации.Вставить("ВерсияКофигурации", СисИнфо.ВерсияПриложения);
	СтруктураИнформации.Вставить("ВерсияПрограммы", Метаданные.Версия);
	СтруктураИнформации.Вставить("ОперативнаяПамять", СисИнфо.ОперативнаяПамять);
	СтруктураИнформации.Вставить("Процессор", СисИнфо.Процессор);
	СтруктураИнформации.Вставить("ТипПлатформы", Строка(СисИнфо.ТипПлатформы));
	СтруктураИнформации.Вставить("Отправлено", Отправлено);
	СтруктураИнформации.Вставить("ТекстОшибки", ТекстОшибки);
	СтруктураИнформации.Вставить("Важность", ВажностьОшибки);
	
	Возврат СтруктураИнформации;
КонецФункции

Функция ОбработатьЛогиПослеВыгрузки(Данные) Экспорт
	ХЗ = XMLЗначение(Тип("ХранилищеЗначения"), Данные);
	ТабДанных = ХЗ.Получить();
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	
	Для Каждого Запись Из ТабДанных Цикл
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Отправлено = Истина;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЦикла;
КонецФункции