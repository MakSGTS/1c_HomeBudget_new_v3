﻿
Процедура ПоказатьСообщениеПользователю(ТекстСообщения) Экспорт
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();
КонецПроцедуры 

Процедура ОбработатьИнформациюОбОшибкеДляПользователя(ТекстОшибки, ТекстДляПользователя = "") Экспорт //TODO: переделать на новый вариант АСИНХ
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТекстОшибки", ТекстОшибки);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОтветПользователя", ДиалогиСПользователемКлиент, Параметры);
	ВариантыОтветов = Новый СписокЗначений;
	ВариантыОтветов.Добавить("ОК", "ОК");
	ВариантыОтветов.Добавить("Отправить", "Отправить ошибку разработчику");
	
	Если Не ЗначениеЗаполнено(ТекстДляПользователя) Тогда
		Текст = "Произошла непредвиденная ошибка... Отправьте, пожалуйста, информацию об ошибке в техподдержку, чтобы разработчки как можно скорее исправил ошибку. Спасибо!"; 
	Иначе
		Текст = ТекстДляПользователя + " Отправьте, пожалуйста, информацию об ошибке в техподдержку, чтобы разработчки как можно скорее исправил ошибку. Спасибо!";
	КонецЕсли;
	
	Заголовок = "Что-то пошло не так...";
	
	ПоказатьВопрос(ОписаниеОповещения, Текст, ВариантыОтветов,,, Заголовок);
	
	
КонецПроцедуры

Процедура ОбработатьОтветПользователя(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = "Отправить" Тогда
		ДанныеОбОшибке = ЛогированиеОшибок.ПодготовитьИнформацибОбОшибке(ДопПараметры.ТекстОшибки, Истина);
		Ответ = ЗапросыHTTP.ОтправитьЛогиВДатаЦентр(ДанныеОбОшибке);
		ОбщиеПроцедурыИФункцииСервер.ЗаписатьЛоги(, ДанныеОбОшибке);
		
		Если Ответ.ОтправленоУдачно Тогда
			ПоказатьОповещениеПользователя("Логи отправлены успешно");
		Иначе
			ПоказатьОповещениеПользователя("Произошла ошибка при отправке логов");
		КонецЕсли;
	Иначе 
		ОбщиеПроцедурыИФункцииСервер.ЗаписатьЛоги(ДопПараметры.ТекстОшибки);
	КонецЕсли;
		
КонецПроцедуры