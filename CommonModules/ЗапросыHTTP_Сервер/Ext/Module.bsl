﻿
Функция ОтпарвитьДанныеНаСервер(АдресВХ, УчетнаяЗапись, Данные = Неопределено, ПоказатьСообщение = Истина, ТелоСтрокиСтатистика = "") Экспорт
	//ВОПРОС проверить ssl на реальном сервере с ssl
		
	СодержимоеФайла = ПолучитьИзВременногоХранилища(АдресВХ); 
	РазмерФайлаОтправки = XMLСтрока(СодержимоеФайла.Размер());
	
	АдресСкрипта = ПараметрыСерверов.ПолуитьАдресСкрипта("ВыгрузкаБэкапа");
	АдресСкрипта = АдресСкрипта + ПараметрыСерверов.ПолучитьЛогинДляБэкапа();
	АдресСервера = ПараметрыСерверов.ПолучитьАдресСервера();
	
	ПараметрыПодключения = ИнициализироватьПараметрыПодключения(АдресСервера);
	ПараметрыПодключения.ИмяПользователя = ПараметрыСерверов.ПолучитьЛогинДляБэкапа();
	ПараметрыПодключения.Пароль = "";;
	
	ПараметрыЗапроса = ИнициализироватьПараметрыЗапроса(АдресСкрипта);
	ПараметрыЗапроса.Метод = "POST";
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Content-Type", "multipart/form-data");	                 
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Content-Length", РазмерФайлаОтправки);
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Accept-Charset", КодировкаТекста.UTF8);
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Accept-Language", "ru");
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("user_id", УчетнаяЗапись.id_user);
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("password", УчетнаяЗапись.Пароль);
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("login", УчетнаяЗапись.Логин);
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("statistic", ТелоСтрокиСтатистика);
	
	//TODO: ssl = Новый ЗащищенноеСоединениеOpenSSL;	
	
	Если ЗначениеЗаполнено(ТелоСтрокиСтатистика) Тогда
		//ТелоСтрокиСтатистика = XMLСтрока(ОбщиеПроцедурыИФункцииСервер.ПоместитьДанныеВХранилищеЗначения(ТелоСтрокиСтатистика));
	КонецЕсли;	
	
	ОтветHTTP = ВыполнитьHTTTP_Запрос(ПараметрыПодключения, ПараметрыЗапроса, ПоказатьСообщение, Истина, СодержимоеФайла);
	
	Если ОтветHTTP = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Текст = ОтветHTTP.ПолучитьТелоКакСтроку("utf-8");
	Если НЕ ЗначениеЗаполнено(Текст) Тогда
		Текст = "Отправка данных на сервер. Код ответа = " + ОтветHTTP.КодСостояния;
	КонецЕсли;
	
	Если ОтветHTTP.КодСостояния <> 200 Тогда
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Текст);
		//Если ПоказатьСообщение Тогда 
			//TODO: ДиалогиСПользователямиКлиент.ОбработатьИнформациюОбОшибкеДляПользователя(Текст);
		//КонецЕсли;
	КонецЕсли;
	Возврат ОтветHTTP.КодСостояния = 200; //TODO: Сделать возврать структурой
	
КонецФункции

Функция ОтправитьЛогиВДатаЦентр(Знач Данные = Неопределено, ОбработатьЛогиПослеВыгрузки = Ложь) Экспорт
	//СборСтатистикиСервер.ЗаписатьФактИспользованияСервиса(ПредопределенноеЗначение("Перечисление.ВидыСтатистики.ОтправкаЛогов"));   //TODO - включить после внедрения СбораСтатистики
	СтруктураВозврата = Новый Структура("ОтправленоУдачно, Ошибка", Ложь, "");
	
	Если Не ЗначениеЗаполнено(Данные) Тогда
		ДанныеДляОтправки = ВыгрузкаДанныхСервер.ПолучитьДанныеЛоговДляВыгрузки();
		ОбработатьЛогиПослеВыгрузки = Истина;
	ИначеЕсли ТипЗнч(Данные) = Тип("Структура") Тогда
		ДанныеДляОтправки = XMLСтрока(ВыгрузкаДанныхСервер.ПреобразоватьДанныеСтрокаВХранилище(Данные));
		ОбработатьЛогиПослеВыгрузки = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеДляОтправки) Тогда
		ДиалогиСПользователямиСервер.ПоказатьСообщениеПользователю("Нет данных для выгрузки");
		СтруктураВозврата.Ошибка = "Нет данных для выгрузки";
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	РазмерФайлаОтправки = XMLСтрока(СтрДлина(ДанныеДляОтправки));
	
	АдресСкрипта = ПараметрыСерверов.ПолуитьАдресСкрипта("ВыгрузкаЛогов");
	АдресСервера = ПараметрыСерверов.ПолучитьАдресСервера();
	
	ПараметрыПодключения = ИнициализироватьПараметрыПодключения(АдресСервера);
	ПараметрыПодключения.ИмяПользователя = "service";  //TODO: Сделать получение служебных учётных данных
	ПараметрыПодключения.Пароль = "hr65kl81";
	ПараметрыЗапроса = ИнициализироватьПараметрыЗапроса(АдресСкрипта);
	ПараметрыЗапроса.Метод = "POST";
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Content-Type", "multipart/form-data");
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Content-Length", РазмерФайлаОтправки);
	
	//TODO: ssl = Новый ЗащищенноеСоединениеOpenSSL;	
	
	ОтветHTTP = ВыполнитьHTTTP_Запрос(ПараметрыПодключения, ПараметрыЗапроса, Истина, Истина, ДанныеДляОтправки, Истина);
	
	Если ОтветHTTP = Неопределено Тогда
		СтруктураВозврата.ОтправленоУдачно = Ложь;
		СтруктураВозврата.Ошибка = "Не удалось отправить логи.";
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Текст = ОтветHTTP.ПолучитьТелоКакСтроку("utf-8");
	
	Если ОтветHTTP.КодСостояния = 200 Тогда			
		
		СтруктураВозврата.ОтправленоУдачно = Истина;
		
	Иначе
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Текст);
		
		СтруктураВозврата.ОтправленоУдачно = Ложь;
		СтруктураВозврата.Ошибка = Текст;
	КонецЕсли;
	
	Если ОтветHTTP.КодСостояния = 200 И ОбработатьЛогиПослеВыгрузки Тогда
		РегистрыСведений.ЛогиОшибок.ОбработатьЛогиПослеВыгрузки(ДанныеДляОтправки);		
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция СоздатьНовогоПользователя(СтруктураУчетки) Экспорт
	Результат = Новый Структура("РегистрацияУспешно, id_user");
	
	ИмяПользователя = "Service";
	Пароль = "hr65kl81";
	
	АдресСкрипта = ПараметрыСерверов.ПолуитьАдресСкрипта("РегистрацияПользователя");
	АдресСкрипта = АдресСкрипта + СтруктураУчетки.Логин + "/" + СтруктураУчетки.Пароль;
	АдресСервера = ПараметрыСерверов.ПолучитьАдресСервера();
	
	ПараметрыПодключения = ИнициализироватьПараметрыПодключения(АдресСервера);
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.Пароль = Пароль;
	ПараметрыЗапроса = ИнициализироватьПараметрыЗапроса(АдресСкрипта);
	ПараметрыЗапроса.Метод = "GET";
	
	ОтветHTTP = ВыполнитьHTTTP_Запрос(ПараметрыПодключения, ПараметрыЗапроса);
	
	//ОтветТекст - либо текст ошибки, либо id в случае удачной регистрации
	ОтветТекст = ОтветHTTP.ПолучитьТелоКакСтроку("utf-8");
	Если ОтветHTTP.КодСостояния <> 200 Тогда
		Если ОтветHTTP.КодСостояния = 404 Тогда
			ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги("Регистрация пользователя. Не удалось подключиться к серверу (404).");
		Иначе
			ОтветТекст = ОтветТекст + ?(ЗначениеЗаполнено(ОтветТекст), Символы.ПС, "") + "Код состояния ответа: " + Строка(ОтветHTTP.КодСостояния) + Символы.ПС + "Действие: Регистрация пользователя.";
			ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(ОтветТекст);
		КонецЕсли;
	Иначе
		Результат.id_user = ОтветТекст;
	КонецЕсли;
	
	Результат.РегистрацияУспешно = ОтветHTTP.КодСостояния = 200;
	
	Возврат Результат;
КонецФункции

Функция ОтправитьСтатистикуВДатаЦентр()Экспорт
	
	МассивСтруктурСтатистики = РаботаСоСтатистикой_Сервер.ПолучитьСтатистику(Истина);
		
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, МассивСтруктурСтатистики);
	СтрокаJson = ЗаписьJSON.Закрыть();
	
	Путь = ПолучитьИмяВременногоФайла("txt");
	ЗаписьТекста = Новый ЗаписьТекста();
	ЗаписьТекста.Открыть(Путь);
	ЗаписьТекста.Записать(СтрокаJson);
	ЗаписьТекста.Закрыть();
	
	АдресВХ = РаботаСФайлами_Сервер.УпаковатьФайлВАрхив(Путь,, Истина);
	СодержимоеФайла = ПолучитьИзВременногоХранилища(АдресВХ); 
	РазмерФайлаОтправки = XMLСтрока(СодержимоеФайла.Размер());
	
	
	ИмяПользователя = "service";
	Пароль = "hr65kl81";
	
	//TODO: ssl = Новый ЗащищенноеСоединениеOpenSSL;	
	АдресСервер = ПараметрыСерверов.ПолучитьАдресСервера();
	АдресСкрипта = ПараметрыСерверов.ПолуитьАдресСкрипта("ВыгрузкаСтатистики"); 
	
	ПараметрыПодключения = ИнициализироватьПараметрыПодключения(АдресСервер);
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.Пароль = Пароль;
	ПараметрыЗапроса = ИнициализироватьПараметрыЗапроса(АдресСкрипта);
	ПараметрыЗапроса.Метод = "POST";	
	ПараметрыЗапроса.ЗапросHTTP.Заголовки.Вставить("Content-Type", "text/html");
	
//	ОтветHTTP = ВыполнитьHTTTP_Запрос(ПараметрыПодключения, ПараметрыЗапроса, Истина, Истина, СодержимоеФайла, Истина);
	
//	Текст = ОтветHTTP.ПолучитьТелоКакСтроку("utf-8");
//	
//	Если ОтветHTTP.КодСостояния = 200 Тогда			
//		Если ВыводитьСообщение Тогда
//			//ДиалогиСПользователямиКлиент.ПоказатьСообщениеПользователю(Текст);
//		КонецЕсли;
//	Иначе
//		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Текст);
//	КонецЕсли;
	УдалитьФайлы(Путь);
//	Возврат ОтветHTTP.КодСостояния;
КонецФункции

Процедура ПолучитьДанныеССервера(ПутьКаталогВрем) Экспорт
	//TODO: ssl = Новый ЗащищенноеСоединениеOpenSSL;
	
	УчетнаяЗапись = ОбщиеПроцедурыИФункцииСервер.ПолучитьУчетнуюЗапись();
	
	АдресСкрипта = ПараметрыСерверов.ПолуитьАдресСкрипта("ЗагрузкаБэкапа");	
	АдресСкрипта = АдресСкрипта + ПараметрыСерверов.ПолучитьЛогинДляБэкапа();
	АдресСервера = ПараметрыСерверов.ПолучитьАдресСервера();
	
	ПараметрыПодключения = ИнициализироватьПараметрыПодключения(АдресСервера);
	ПараметрыПодключения.ИмяПользователя = ПараметрыСерверов.ПолучитьЛогинДляБэкапа();
	ПараметрыПодключения.Пароль = "";
	
	ПараметрыЗапроса = ИнициализироватьПараметрыЗапроса(АдресСкрипта);
	ПараметрыЗапроса.Метод = "GET";
	
	ОтветHTTP = ВыполнитьHTTTP_Запрос(ПараметрыПодключения, ПараметрыЗапроса); 	
	Если ОтветHTTP.КодСостояния = 200 Тогда
		Данные = ОтветHTTP.ПолучитьТелоКакДвоичныеДанные();
		АдресВХАрхива = ПоместитьВоВременноеХранилище(Данные);
		АдресВХ = РаботаСФайлами_Сервер.РаспаковатьДанныеИзАрхива(Истина, Истина, Истина, АдресВХАрхива, ПутьКаталогВрем, УчетнаяЗапись.Пароль);
			
//		Путь = ?(ЗначениеЗаполнено(Путь), Путь, КаталогВременныхФайлов() + "tmpXML.txt");
//		Данные.Записать(Путь);
		
		ЗагрузкаДанныхСервер.ЗагрузитьДанные(АдресВХ);
	Иначе
		//TODO Обработать ОтветHTTP = Неопределено, <> 200
	КонецЕсли;
КонецПроцедуры

Функция ИнициализироватьПараметрыПодключения(лСервер, ИспользоватьSSL = Ложь)
	Параметры = Новый Структура;
	Параметры.Вставить("Сервер");
	Параметры.Вставить("Порт");
	Параметры.Вставить("ИмяПользователя");
	Параметры.Вставить("Пароль");
	Параметры.Вставить("Прокси");
	Параметры.Вставить("Таймаут");
	Параметры.Вставить("ЗащищенноеСоединение");
	
	Параметры.Сервер = лСервер;
	Параметры.Порт = ?(ИспользоватьSSL, 443, 80);
	Параметры.ИмяПользователя = "";
	Параметры.Пароль = "";
	Параметры.Прокси = Новый ИнтернетПрокси;
	Параметры.Таймаут = 30;
	Параметры.ЗащищенноеСоединение = ?(ИспользоватьSSL, Новый ЗащищенноеСоединениеOpenSSL, Неопределено);
	
	Возврат Параметры;
КонецФункции

Функция ИнициализироватьПараметрыЗапроса(АдресСкрипта)
	Параметры = Новый Структура("Метод, ЗапросHTTP, АдресСкрипта");
	Параметры.Метод = "";
	Параметры.ЗапросHTTP = Новый HTTPЗапрос(АдресСкрипта, Новый Соответствие);
	Параметры.АдресСкрипта = АдресСкрипта;
	
	Возврат Параметры;
КонецФункции

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
		
		Ответ = ХТТП.ВызватьHTTPМетод(ПараметрыЗапроса.Метод, ЗапросHTTP);
		Возврат Ответ;
		
	Исключение
		Текст = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = "Ошибка выполнения http-запроса." + Символы.ПС + Текст;
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(ТекстОшибки);
		
		Возврат Неопределено;
		
	КонецПопытки;

КонецФункции
