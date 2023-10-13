﻿
&НаКлиенте
Функция ОтправитьСтатистикуВДатаЦентр(Данные, ВыводитьСообщение = Ложь)Экспорт
	
	ИмяПользователя = "service"; //TODO: переделать по стандартам
	Пароль = "hr65kl81";        //TODO: переделать по стандартам
	
	ssl = Новый ЗащищенноеСоединениеOpenSSL;	
	Сервер = "192.168.1.140";  //TODO: переделать по стандартам
	АдресСкрипта = "HomeBudget_backUp/hs/download_statistics/"; 
	
	ПараметрыПодключения = ИнициализироватьПараметрыПодключения("192.168.1.140"); //TODO: переделать по стандартам
	ПараметрыЗапроса = ИнициализироватьПараметрыЗапроса(АдресСкрипта);
	
	ПараметрыЗапроса.Метод = "POST";
	
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.Пароль = Пароль;
	
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Content-Type", "text/html");
	
	ОтветHTTP = ВыполнитьHTTTP_Запрос(ПараметрыПодключения, ПараметрыЗапроса, Истина, Истина, Данные, Истина);
	
	Текст = ОтветHTTP.ПолучитьТелоКакСтроку("utf-8");
	
	Если ОтветHTTP.КодСостояния = 200 Тогда			
		Если ВыводитьСообщение Тогда
			ДиалогиСПользователемКлиент.ПоказатьСообщениеПользователю(Текст);
		КонецЕсли;
	Иначе
		ЛогированиеОшибок.ЗаписатьОшибкуВЛоги(Текст);
	КонецЕсли;
	
	Возврат ОтветHTTP.КодСостояния;
КонецФункции

&НаКлиенте
Функция ИнициализироватьПараметрыПодключения(Сервер, ИспользоватьSSL = Ложь)
	Параметры = Новый Структура("Сервер, Порт, ИмяПользователя, Пароль, Прокси, Таймаут, ЗащищенноеСоединение");
	Параметры.Сервер = Сервер;
	Параметры.Порт = ?(ИспользоватьSSL, 443, 80);
	Параметры.ИмяПользователя = "";
	Параметры.Пароль = "";
	Параметры.Прокси = Новый ИнтернетПрокси;
	Параметры.Таймаут = 30;
	Параметры.ЗащищенноеСоединение = ?(ИспользоватьSSL, Новый ЗащищенноеСоединениеOpenSSL, Неопределено);
	
	Возврат Параметры;
КонецФункции

&НаКлиенте
Функция ИнициализироватьПараметрыЗапроса(АдресСкрипта)
	Параметры = Новый Структура("Метод, ЗапросHTTP, АдресСкрипта");
	Параметры.Метод = "";
	Параметры.ЗапросHTTP = Новый HTTPЗапрос(АдресСкрипта, Новый Соответствие);
	Параметры.АдресСкрипта = АдресСкрипта;
	
	Возврат Параметры;
КонецФункции

// Функция - Выполнить HTTTP запрос
//
// Параметры:
//  ПараметрыЗапроса	 - Структура	 -
//  	-Метод				 - 	 - 
//  	-ЗапросHTTP			 - 	 - 
//  	-АдресСкрипта		 - 	 - 
//	
//	ПараметрыПодключения - Структура
//		-Сервер				 - Строка	 -
//		-Порт				 - Число	 -
//		-ИмяПользователя	 - Строка	 -
//		-Пароль				 - Строка	 -
//
//  УстановитьТело		 - Булево	 - 
//  ПоказатьСообщение	 - Булево	 -  определяет, показывать сообщение пользователю при наличии ошибки исполнения функции
//  ТелоЗапроса			 - ДвоичныеДанные, XMLСтрока	 -
//  ТелоСтрока			 - Булево	 -
// 
// Возвращаемое значение:
//   - HTTPОтвет, Неопределено
//
&НаКлиенте
Функция ВыполнитьHTTTP_Запрос(ПараметрыПодключения, ПараметрыЗапроса, ПоказатьСообщение = Истина, УстановитьТело = Ложь, ТелоЗапроса = Неопределено, ТелоСтрока = Ложь) Экспорт
	
	ХТТП = Новый HTTPСоединение(ПараметрыПодключения.Сервер,, ПараметрыПодключения.ИмяПользователя, ПараметрыПодключения.Пароль);
	Попытка
		ЗапросHTTP = ПараметрыЗапроса.ЗапросHTTP;
		Если УстановитьТело И ТелоЗапроса <> Неопределено Тогда
			Если ТелоСтрока Тогда
				ЗапросHTTP.УстановитьТелоИзСтроки(ТелоЗапроса);
			Иначе
				ЗапросHTTP.УстановитьТелоИзДвоичныхДанных(ТелоЗапроса);
			КонецЕсли;
		КонецЕсли;
		
		Возврат ХТТП.ВызватьHTTPМетод(ПараметрыЗапроса.Метод, ЗапросHTTP);
		
	Исключение
		Текст = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЛогированиеОшибок.ЗаписатьОшибкуВЛоги(Текст);
		
		Если ПоказатьСообщение Тогда 
			ДиалогиСПользователемКлиент.ОбработатьИнформациюОбОшибкеДляПользователя(Текст);
		КонецЕсли;
		
		Возврат Неопределено;
		
	КонецПопытки;

КонецФункции


