﻿
Процедура УстановитьНастройкиПоУмолчанию() Экспорт
	
	
	НаборЗаписей = РегистрыСведений.НастройкиСистемы.СоздатьНаборЗаписей();
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Параметр = Справочники.ПараметрыСистемы.Автобэкап;
	НоваяЗапись.Значение = Истина;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Параметр = Справочники.ПараметрыСистемы.ОблачныйБэкап;
	НоваяЗапись.Значение = Ложь;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Параметр = Справочники.ПараметрыСистемы.АвтоматическиОтправлятьОшибки;
	НоваяЗапись.Значение = Истина;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Параметр = Справочники.ПараметрыСистемы.ВариантРасчетаБюджета;
	НоваяЗапись.Значение = Перечисления.ВариантАлгоритмаБюджета.Вариант2;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Параметр = Справочники.ПараметрыСистемы.ОтправлятьЛоги;
	НоваяЗапись.Значение = Истина;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Параметр = Справочники.ПараметрыСистемы.ОтправлятьСтатистику;
	НоваяЗапись.Значение = Ложь;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Параметр = Справочники.ПараметрыСистемы.УведомлятьОПревышенииБюджета;
	НоваяЗапись.Значение = Истина;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура УстановитьНовоеЗначениеПараметраСистемы(Параметр, Значение) Экспорт
	
	Попытка
		
		спрПараметр = Справочники.ПараметрыСистемы.НайтиПоНаименованию(Параметр);
		
		МенеджерЗаписи = РегистрыСведений.НастройкиСистемы.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Параметр = спрПараметр;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			
			Если МенеджерЗаписи.Значение = Значение Тогда
				Возврат;
			Иначе
				МенеджерЗаписи.Значение = Значение;
			КонецЕсли;
			
		Иначе
			МенеджерЗаписи.Параметр = спрПараметр;
			МенеджерЗаписи.Значение = Значение;
		КонецЕсли;
		МенеджерЗаписи.Записать();
	Исключение
		Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщиеПроцедурыИФункцииСервер.ЗаписатьЛоги(Ошибка);
	КонецПопытки;
	
КонецПроцедуры

// Функция - Получить значения параметров
//
// Параметры:
//  МассивПараметров - Массив со списком запрашиваемых параметров. Тип элемента массива - Строка - Тип("Массив")
// 
// Возвращаемое значение:
//   - Массив структур по запрашиваемым параметрам, либо Неопределено, если переданный массив в функцию был пустым
//
Функция ПолучитьЗначенияПараметров(МассивПараметров) Экспорт
		
	Если Не ЗначениеЗаполнено(МассивПараметров) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	массивСтруктурПараметров = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НастройкиСистемы.Параметр КАК Параметр,
	               |	НастройкиСистемы.Значение КАК Значение
	               |ИЗ
	               |	РегистрСведений.НастройкиСистемы КАК НастройкиСистемы
	               |ГДЕ
	               |	НастройкиСистемы.Параметр В(&Параметр)";
	
	Запрос.УстановитьПараметр("Параметр", МассивПараметров);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Структурапараметров = Новый Структура("Параметр, Значение");
		ЗаполнитьЗначенияСвойств(Структурапараметров, ВыборкаДетальныеЗаписи);
		массивСтруктурПараметров.Добавить(Структурапараметров);
	КонецЦикла;
	
	Возврат массивСтруктурПараметров;
	
КонецФункции


