﻿
Процедура ВыгрузитьДанные(ВыгрузкаНаСервер, Пользователь = Неопределено, Пароль = Неопределено, ТолькоСправочники = Ложь) Экспорт
	Если ВыгрузкаНаСервер Тогда
		ПеречислениеОблачныйBackUp = ПредопределенноеЗначение("Перечисление.ВидыСтатистики.ОблачныйBackUp");
		СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПеречислениеОблачныйBackUp, Ложь);
		
		Ответ = ВыгрузкаДанныхСервер.ВыгрузитьДанные(КаталогВременныхФайлов(), ТолькоСправочники);
		
		Если Ответ.ВыгрузкаУспешно Тогда
			Путь = КаталогВременныхФайлов() + "backUp_1CDB.txt";
			ТелоСтрокиСтатистика = СборСтатистикиСервер.ПолучитьТелоСтрокиСтатистики(ПеречислениеОблачныйBackUp);
			Если ЗапросыHTTP.ОтпарвитьДанныеНаСервер(Путь, Пользователь, Пароль,,, ТелоСтрокиСтатистика)Тогда
				ДиалогиСПользователямиКлиент.ПоказатьСообщениеПользователю("Выгрузка завершена успешно!");
			КонецЕсли;
			КопироватьФайл(КаталогВременныхФайлов() + "backUp_1CDB.txt", КаталогДокументов() + "backUp_1CDB.txt");
		Иначе			
			ДиалогиСПользователямиКлиент.ОбработатьИнформациюОбОшибкеДляПользователя(Ответ.Ошибка);	
		КонецЕсли;
	Иначе
		СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПредопределенноеЗначение("Перечисление.ВидыСтатистики.ЛокальныйBackUp"), Ложь);
		
		Ответ = ВыгрузкаДанныхСервер.ВыгрузитьДанные(КаталогДокументов(), ТолькоСправочники);
		
		Если Ответ.ВыгрузкаУспешно Тогда
			ДиалогиСПользователямиКлиент.ПоказатьСообщениеПользователю("Выгрузка завершена успешно!");
		Иначе
			ДиалогиСПользователямиКлиент.ОбработатьИнформациюОбОшибкеДляПользователя(Ответ.Ошибка);
		КонецЕсли;		
	КонецЕсли;
	ОбщиеПроцедурыИФункцииКлиент.ОбновиьГлавныйЭкран();
КонецПроцедуры

Процедура Автобэкап(ВыгрузкаНаСервер, Логин = Неопределено, Пароль = Неопределено) Экспорт
	ПеречислениеАвтобэкап = ПредопределенноеЗначение("Перечисление.ВидыСтатистики.Автобэкап");
	ТелоСтрокиСтатистика = СборСтатистикиСервер.ПолучитьТелоСтрокиСтатистики(ПеречислениеАвтобэкап);
	СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПеречислениеАвтобэкап, Ложь);
	
	Ответ = ВыгрузкаДанныхСервер.ВыгрузитьДанные(КаталогВременныхФайлов(), Ложь);
	Если Ответ.ВыгрузкаУспешно Тогда
		УчетныеЗаписи = ОбщиеПроцедурыИФункцииСервер.ПолучитьУчетнуюЗапись();
		Если ЗначениеЗаполнено(УчетныеЗаписи)И ВыгрузкаНаСервер Тогда
			Путь = КаталогВременныхФайлов() + "\backUp_1CDB.txt";
			Если ЗапросыHTTP.ОтпарвитьДанныеНаСервер(Путь, УчетныеЗаписи.Логин, УчетныеЗаписи.Пароль,,, ТелоСтрокиСтатистика) Тогда
				ПоказатьОповещениеПользователя("АВТОБЭКАП",, "Выполнен успешно");
			Иначе
				//ПоказатьОповещениеПользователя("
			КонецЕсли;
		Иначе
			//ПоказатьОповещениеПользователя("
		КонецЕсли;
		КопироватьФайл(КаталогВременныхФайлов() + "backUp_1CDB.txt", КаталогДокументов() + "backUp_1CDB.txt");
	Иначе
		ДиалогиСПользователямиКлиент.ОбработатьИнформациюОбОшибкеДляПользователя(Ответ.Ошибка, "Не удалось выполнить автоматический бэкап.");
	КонецЕсли;
	

	
КонецПроцедуры

Процедура АвтобэкапФон(ВыгрузкаНаСервер) Экспорт
	УчетныеЗаписи = ОбщиеПроцедурыИФункцииСервер.ПолучитьУчетнуюЗапись();
	ВыгрузкаДанныхСервер.АвтобэкапФонСервер(КаталогДокументов(), УчетныеЗаписи, ВыгрузкаНаСервер);
КонецПроцедуры
