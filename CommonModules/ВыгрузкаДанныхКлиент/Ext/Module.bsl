﻿
Процедура ВыгрузитьДанные(ВыгрузкаНаСервер, ВидВыгрузки = "Бэкап")
			
	Если ВидВыгрузки = "Бэкап" Тогда
		ВыгрузитьБэкап(ВыгрузкаНаСервер);
	ИначеЕсли ВидВыгрузки = "Логи" Тогда 
		
	ИначеЕсли ВидВыгрузки = "Обмен" Тогда
		 		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыгрузитьБэкап(ВыгрузкаНаСервер) Экспорт
	Если ВыгрузкаНаСервер Тогда
		ПеречислениеОблачныйBackUp = ПредопределенноеЗначение("Перечисление.ВидыСтатистики.ОблачныйBackUp");
		СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПеречислениеОблачныйBackUp, Ложь);
		
		Ответ = ВыгрузкаДанныхСервер.ПодготовитьФайлБэкапа(КаталогВременныхФайлов(), Истина);
		
		Если Ответ.ФайлСоздан Тогда
			ТелоСтрокиСтатистика = СборСтатистикиСервер.ПолучитьТелоСтрокиСтатистики(ПеречислениеОблачныйBackUp);
			Если ЗапросыHTTP_Сервер.ОтпарвитьДанныеНаСервер(Ответ.АдресВХ,,, ТелоСтрокиСтатистика)Тогда
				ДиалогиСПользователемКлиент.ПоказатьСообщениеПользователю("Выгрузка завершена успешно!");
			КонецЕсли;
		Иначе			
			ДиалогиСПользователемКлиент.ОбработатьИнформациюОбОшибкеДляПользователя("Не удалось выгрузить бэкап на сервер. Попробуйте позже.");	
		КонецЕсли;
	Иначе
		СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПредопределенноеЗначение("Перечисление.ВидыСтатистики.ЛокальныйBackUp"), Ложь);
		
		Ответ = ВыгрузкаДанныхСервер.ПодготовитьФайлБэкапа(КаталогДокументов(), Истина);
		
		Если Ответ.ФайлСоздан Тогда
			ДиалогиСПользователемКлиент.ПоказатьСообщениеПользователю("Выгрузка завершена успешно!");
		Иначе
			ДиалогиСПользователемКлиент.ОбработатьИнформациюОбОшибкеДляПользователя("Не удалось записать бэкап. Попробуйте позже");
		КонецЕсли;		
	КонецЕсли;
	ОбщиеПроцедурыИФункцииКлиент.ОбновиьГлавныйЭкран();
КонецПроцедуры

Процедура Автобэкап(ВыгрузкаНаСервер, Логин = Неопределено, Пароль = Неопределено) Экспорт
	ПеречислениеАвтобэкап = ПредопределенноеЗначение("Перечисление.ВидыСтатистики.Автобэкап");
	ТелоСтрокиСтатистика = СборСтатистикиСервер.ПолучитьТелоСтрокиСтатистики(ПеречислениеАвтобэкап);
	СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПеречислениеАвтобэкап, Ложь);
	
	Ответ = ВыгрузкаДанныхСервер.ПодготовитьФайлБэкапа(КаталогВременныхФайлов(), Ложь);
	Если Ответ.ФайлСоздан Тогда
		УчетныеЗаписи = ОбщиеПроцедурыИФункцииСервер.ПолучитьУчетнуюЗапись();
		Если ЗначениеЗаполнено(УчетныеЗаписи)И ВыгрузкаНаСервер Тогда
			Путь = КаталогВременныхФайлов() + "\backUp_1CDB.txt";
			Если ЗапросыHTTP_Сервер.ОтпарвитьДанныеНаСервер(Путь, УчетныеЗаписи.Логин, УчетныеЗаписи.Пароль,,, ТелоСтрокиСтатистика) Тогда
				ПоказатьОповещениеПользователя("АВТОБЭКАП",, "Выполнен успешно");
			Иначе
				//ПоказатьОповещениеПользователя("//TODO:?)
			КонецЕсли;
		Иначе
			//ПоказатьОповещениеПользователя("//TODO:?)
		КонецЕсли;
		КопироватьФайл(КаталогВременныхФайлов() + "backUp_1CDB.txt", КаталогДокументов() + "backUp_1CDB.txt");
	Иначе
		//TODO: ДиалогиСПользователемКлиент.ОбработатьИнформациюОбОшибкеДляПользователя(Ответ.Ошибка, "Не удалось выполнить автоматический бэкап.");
	КонецЕсли;
КонецПроцедуры

Процедура АвтобэкапФон(ВыгрузкаНаСервер) Экспорт
	УчетныеЗаписи = ОбщиеПроцедурыИФункцииСервер.ПолучитьУчетнуюЗапись();
	ВыгрузкаДанныхСервер.АвтобэкапФонСервер(КаталогДокументов(), УчетныеЗаписи, ВыгрузкаНаСервер);
КонецПроцедуры
