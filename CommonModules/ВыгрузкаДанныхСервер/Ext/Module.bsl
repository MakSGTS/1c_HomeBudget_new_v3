﻿
Функция ВыгрузитьДанныеНоваяСхема(Путь, ТолькоСправочники) Экспорт
	
	СтруктураВозврата = Новый Структура("ВыгрузкаУспешно, Ошибка", Ложь, "");
	ПутьXML = ПолучитьИмяВременногоФайла("xml");
	Попытка
		хml = Новый ЗаписьXML;
		хml.ОткрытьФайл(ПутьXML, "UTF-8");
		хml.ЗаписатьОбъявлениеXML();
		
		хml.ЗаписатьНачалоЭлемента("dataBase");
		
		хml.ЗаписатьНачалоЭлемента("dateFirstUpLoad");
		хml.ЗаписатьТекст(Строка(ТекущаяДата()));
		хml.ЗаписатьКонецЭлемента(); //</dateFirstUpLoad>
		
		хml.ЗаписатьНачалоЭлемента("dateUpdate");
		хml.ЗаписатьТекст(Строка(ТекущаяДата()));
		хml.ЗаписатьКонецЭлемента(); //</dateUpdate>
		
		хml.ЗаписатьНачалоЭлемента("version");
		хml.ЗаписатьТекст(Метаданные.Версия);
		хml.ЗаписатьКонецЭлемента(); //</version>
		
		хml.ЗаписатьНачалоЭлемента("user_id");
		хml.ЗаписатьТекст(ОбщиеПроцедурыИФункцииСервер.ПолучитьЗначениеКонстанты("user_id"));
		хml.ЗаписатьКонецЭлемента(); //</user_id>
		
		хml.ЗаписатьНачалоЭлемента("onlyHandbooks");
		хml.ЗаписатьТекст(XMLСтрока(ТолькоСправочники));
		хml.ЗаписатьКонецЭлемента(); //</onlyHandbooks>

		ВыгрузкаПоСхемеЦепочка_XML(хml, ТолькоСправочники);
		
		хml.ЗаписатьКонецЭлемента(); //</dataBase>
		хml.Закрыть();
		
		Файл = Новый ДвоичныеДанные(ПутьXML);
		
		ХЗ = Новый ХранилищеЗначения(Файл, Новый СжатиеДанных(9));
		ДанныеСтрока = XMLСтрока(ХЗ);
		ФайлТекст = Новый ЗаписьТекста;
		ФайлТекст.Открыть(Путь + "backUp_1CDB.txt");
		ФайлТекст.Записать(ДанныеСтрока);
		ФайлТекст.Закрыть();
				
		СтруктураВозврата.ВыгрузкаУспешно = Истина;
		
		Возврат СтруктураВозврата;
		
	Исключение
		Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Ошибка);
		
		СтруктураВозврата.ВыгрузкаУспешно = Ложь;
		СтруктураВозврата.Ошибка = Ошибка;
		
		Возврат СтруктураВозврата;
	КонецПопытки;
	
КонецФункции

Процедура ВыгрузкаПоСхемеЦепочка_XML(ЗаписьXML, ТолькоСправочники) Экспорт
	
	Узел = ПланыОбмена.Бэкап.НайтиПоКоду("DataCentre");
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	
	Попытка
		ЗаписьСообщения.НачатьЗапись(Запись, Узел);
	Исключение
		Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Ошибка);
	КонецПопытки;
	
	Выборка = ПланыОбмена.ВыбратьИзменения(ЗаписьСообщения.Получатель, ЗаписьСообщения.НомерСообщения);
	
	СоставОбмена = Метаданные.ПланыОбмена.Бэкап.Состав;
	
	//МассивТипов = Новый Массив;
	//Для Каждого ЭлементСостава Из СоставОбмена Цикл
	//	Если СтрНайти(ЭлементСостава.Метаданные.ПолноеИмя(), "Справочник") ИЛИ СтрНайти(ЭлементСостава.Метаданные.ПолноеИмя(), "Документ") Тогда
	//		ТипДанных = Тип(СтрЗаменить(ЭлементСостава.Метаданные.ПолноеИмя(), ".", "Ссылка."));
	//		МассивТипов.Добавить(ТипДанных);
	//	ИначеЕсли СтрНайти(ЭлементСостава.Метаданные.ПолноеИмя(), "РегистрСведений") Тогда     
	//		ТипДанных = Тип(СтрЗаменить(ЭлементСостава.Метаданные.ПолноеИмя(), ".", "НаборЗаписей.")); //TODO: выяснить про тип *Запись
	//		МассивТипов.Добавить(ТипДанных);
	//	КонецЕсли;
	//КонецЦикла;
	
	
	//ТЗ_Данные = Новый ТаблицаЗначений;
	//ТЗ_Данные.Колонки.Добавить("ОбъектСсылка", Новый ОписаниеТипов(МассивТипов));
	//ТЗ_Данные.Колонки.Добавить("ТипДанных", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(50)));
	//ТЗ_Данные.Колонки.Добавить("ТипДанныхОбъекта", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	
	МассивНаборовЗаписей = Новый Массив;
	МассивДокументов = Новый Массив;
	МассивСправочников = Новый Массив;
	МассивКонстант = Новый Массив;
	//добавить выгрузку Параметров
	
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Получить();
		
		Попытка
			ИмяОбъектаМетаданные = Объект.Метаданные().ПолноеИмя();
			
			Если СтрНайти(ИмяОбъектаМетаданные, "Документ") Тогда
				
				МассивДокументов.Добавить(Объект);
			ИначеЕсли СтрНайти(ИмяОбъектаМетаданные, "Справочник") Тогда
				
				МассивСправочников.Добавить(Объект);
				
			ИначеЕсли СтрНайти(ИмяОбъектаМетаданные, "РегистрСведений") Тогда
				
				МассивНаборовЗаписей.Добавить(Объект);
				
			ИначеЕсли СтрНайти(ИмяОбъектаМетаданные, "Констант") Тогда
				
				//МассивКонстант.Добавить(Объект);
				
			КонецЕсли;
			
		Исключение
			Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Ошибка + " Ошибка получения данных по объекту по плану обмена для выгрузки бэкапа. Объект: " + ИмяОбъектаМетаданные);
			Продолжить;
		КонецПопытки;
		
	КонецЦикла;
	
	//Справочники
	Если МассивСправочников.Количество() > 0 Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("handbooks");
		Для Каждого Объект Из МассивСправочников Цикл
			ЗаписатьXML(ЗаписьXML, Объект, НазначениеТипаXML.Явное);
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента(); //handbooks
	КонецЕсли;
	
	//Документы
	Если МассивДокументов.Количество() > 0 Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("documents");
		Для Каждого Объект Из МассивДокументов Цикл
			ЗаписатьXML(ЗаписьXML, Объект, НазначениеТипаXML.Явное);
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента(); //documents
	КонецЕсли;
	
	//РегистрСведений
	Если МассивНаборовЗаписей.Количество() > 0 Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("infoReg");
		Для Каждого Объект Из МассивНаборовЗаписей Цикл
			ЗаписатьXML(ЗаписьXML, Объект, НазначениеТипаXML.Явное);
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента(); //infoReg
	КонецЕсли;
	
	//Константы
	Если МассивКонстант.Количество() > 0 Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("constants");
		Для Каждого Объект Из МассивКонстант Цикл
			ЗаписатьXML(ЗаписьXML, Объект, НазначениеТипаXML.Явное);
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента(); //constants
	КонецЕсли;

	а  = 1;
	Попытка
		ЗаписьСообщения.ЗакончитьЗапись();
		Запись.Закрыть();
	Исключение
		Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Ошибка);
	КонецПопытки;
	
	
	
	//TODO: если отправка Успешно - очистить изменения
	
	////Константы
	//ЗаписьXML.ЗаписатьНачалоЭлемента("constants");
	//Для Каждого Объект Из ОбъектыКонстанты Цикл
	//	ЗаписьXML.ЗаписатьНачалоЭлемента(Объект.Имя);
	//	ЗаписатьОбъектыВФайл(ЗаписьXML, Объект.Имя, Истина);
	//	ЗаписьXML.ЗаписатьКонецЭлемента();
	//КонецЦикла;
	//ЗаписьXML.ЗаписатьКонецЭлемента(); //constants
				
КонецПроцедуры

Процедура АвтобэкапФонСервер(Каталог, УчетныеЗаписи, Облако) Экспорт
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Облако);
	МассивПараметров.Добавить(Каталог);
	МассивПараметров.Добавить(УчетныеЗаписи.Логин);     
	МассивПараметров.Добавить(УчетныеЗаписи.Пароль); 
	
	//Автобэкап(Истина, Каталог, УчетныеЗаписи.Логин, УчетныеЗаписи.Пароль);//Времянка для тестов
	
	/////////////////////
	//Определяем, если ли изменения по плану обмена
	Узел = ПланыОбмена.Бэкап.НайтиПоКоду("DataCentre");
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	Попытка
		ЗаписьСообщения.НачатьЗапись(Запись, Узел);
	Исключение
		Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Ошибка);
		Возврат;
	КонецПопытки;
	Выборка = ПланыОбмена.ВыбратьИзменения(ЗаписьСообщения.Получатель, ЗаписьСообщения.НомерСообщения);
	
	Если Выборка.Следующий() Тогда
		Константы.АдресХЗ_Ответа.Установить(ПоместитьВоВременноеХранилище(Неопределено));
		ФонЗадание = ФоновыеЗадания.Выполнить("ВыгрузкаДанныхСервер.Автобэкап", МассивПараметров,, "Создаю резервную копию...");
		Константы.ФонУИД_Автобэкап.Установить(ФонЗадание.УникальныйИдентификатор);
	КонецЕсли;
	//
	/////////////////////////////////////

КонецПроцедуры

Функция Автобэкап(ВыгрузкаНаСервер, Каталог, Логин = Неопределено, Пароль = Неопределено) Экспорт
	ПеречислениеАвтобэкап = ПредопределенноеЗначение("Перечисление.ВидыСтатистики.Автобэкап");
	ТелоСтрокиСтатистика = СборСтатистикиСервер.ПолучитьТелоСтрокиСтатистики(ПеречислениеАвтобэкап);
	СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПеречислениеАвтобэкап, Ложь);
	
	Результат = Новый Структура("Успешно, ТекстОшибки, СообщениюПользователю", Ложь, "", "");
	
	Ответ = Ложь;
	
	Ответ = ВыгрузкаДанныхСервер.ВыгрузитьДанныеНоваяСхема(КаталогВременныхФайлов(), Ложь);
	
	Если Ответ.ВыгрузкаУспешно Тогда
		УчетныеЗаписи = ОбщиеПроцедурыИФункцииСервер.ПолучитьУчетнуюЗапись();
		Если ЗначениеЗаполнено(УчетныеЗаписи) И ВыгрузкаНаСервер Тогда
			Путь = КаталогВременныхФайлов() + "\backUp_1CDB.txt";
			Если ЗапросыHTTP_Сервер.ОтпарвитьДанныеНаСервер(Путь, УчетныеЗаписи.Логин, УчетныеЗаписи.Пароль,,, ТелоСтрокиСтатистика) Тогда
				Результат.Успешно = Истина;
				Результат.СообщениюПользователю = "Выполнен успешно";
			Иначе
				Результат.Успешно = Ложь;
				Результат.СообщениюПользователю = "Не удалось отправить данные на сервер";
			КонецЕсли;
		Иначе
			Результат.Успешно = Истина;
		КонецЕсли;
		КопироватьФайл(КаталогВременныхФайлов() + "backUp_1CDB.txt", Каталог + "backUp_1CDB.txt");
	Иначе
		Результат.СообщениюПользователю = "Не удалось отправить данные на сервер";
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, Константы.АдресХЗ_Ответа.Получить()); 
	
	Возврат Результат;
КонецФункции

//Отправка логов в фоне
Процедура ОтправитьЛогиФонСервер() Экспорт
	
	Константы.АдресХЗ_ОтветаЛоги.Установить(ПоместитьВоВременноеХранилище(Неопределено));
	ФонЗадание = ФоновыеЗадания.Выполнить("ВыгрузкаДанныхСервер.ВыгрузкаЛогов",,, "Отправляю логи на сервер...");
	Константы.ФонУИД_ОтправкаЛогов.Установить(ФонЗадание.УникальныйИдентификатор);

КонецПроцедуры

#Область ВыгрзукаЛогов
Функция ПолучитьДанныеЛоговДляВыгрузки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ *
	               |ИЗ
	               |	РегистрСведений.ЛогиОшибок КАК ЛогиОшибок
	               |ГДЕ
	               |	НЕ ЛогиОшибок.Отправлено";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ХЗ = Новый ХранилищеЗначения(РезультатЗапроса.Выгрузить(), Новый СжатиеДанных(9));
		Данные = XMLСтрока(ХЗ);
		Возврат Данные;
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции      

Функция ВыгрузкаЛогов() Экспорт
	
	ПеречислениеЛоги = ПредопределенноеЗначение("Перечисление.ВидыСтатистики.ОтправкаЛогов");
	ТелоСтрокиСтатистика = СборСтатистикиСервер.ПолучитьТелоСтрокиСтатистики(ПеречислениеЛоги);
	СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПеречислениеЛоги, Ложь);
	
	Результат = Новый Структура("Успешно, ТекстОшибки, СообщениюПользователю", Ложь, "", "");
	
	Ответ = ЗапросыHTTP_Сервер.ОтправитьЛогиВДатаЦентр();
	
	ОтветЛоги = ЗапросыHTTP_Сервер.ОтправитьСтатистикуВДатаЦентр();
	
	Если Ответ.ОтправленоУдачно Тогда
		Результат.Успешно = Истина;
		Результат.СообщениюПользователю = "Выполнен успешно";
	Иначе
		Результат.Успешно = Ложь;
		Результат.СообщениюПользователю = "Не удалось отправить данные на сервер";
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, Константы.АдресХЗ_ОтветаЛоги.Получить());
КонецФункции
#КонецОбласти

Функция ПреобразоватьДанныеСтрокаВХранилище(Знач ДанныеСтрока) Экспорт
	Возврат Новый ХранилищеЗначения(ДанныеСтрока, Новый СжатиеДанных(9));
КонецФункции














