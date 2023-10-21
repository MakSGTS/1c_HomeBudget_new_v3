﻿

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	Отказ = Истина;
	ТекстПредупреждения = "Закрыть приложение?";

КонецПроцедуры

Процедура НачатьОбработчикОжидания(ПроверяемоеСобытие) Экспорт
	
	Если ПроверяемоеСобытие = ПредопределенноеЗначение("Перечисление.ПроверяемыеСобытияОбработчикаОжидания.Автобэкап") Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗаданияАвтоБэкап", 1);
	ИначеЕсли ПроверяемоеСобытие = ПредопределенноеЗначение("Перечисление.ПроверяемыеСобытияОбработчикаОжидания.ОтправкаЛогов") Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗаданияОтправкаЛогов", 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьВыполнениеФоновогоЗаданияАвтоБэкап() Экспорт
	
	Результат = ОбщиеПроцедурыИФункцииСервер.ЗаданиеВыполнено(ПредопределенноеЗначение("Перечисление.ПроверяемыеСобытияОбработчикаОжидания.Автобэкап"));
	Если Результат.Выполнено Тогда
		//и отключаем обработчик ожидания
		
		АдресХЗ = ОбщиеПроцедурыИФункцииСервер.ПолучитьЗначениеКонстанты("АдресХЗ_Ответа");
		Если ЗначениеЗаполнено(АдресХЗ) Тогда
			Ответ = ПолучитьИзВременногоХранилища(АдресХЗ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ответ) Тогда
			Если Ответ.Успешно Тогда
				ПоказатьОповещениеПользователя("Бэкап",, Ответ.СообщениюПользователю);
				ВыгрузкаДанныхСервер.ОчиститьРегисрациюПО();
			Иначе
				ПоказатьОповещениеПользователя("Бэкап",, Ответ.СообщениюПользователю);
			КонецЕсли;
			ОбщиеПроцедурыИФункцииСервер.ЗадатьЗначениеКонстанты("АдресХЗ_Ответа", "");
		Иначе
			ПоказатьОповещениеПользователя("Бэкап",, Результат.ТекстСообщения);
		КонецЕсли;
		
		ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗаданияАвтоБэкап");
		
	ИначеЕсли Результат.НетДанных Тогда
		ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗаданияАвтоБэкап");
	КонецЕсли;
	
КонецПроцедуры	

Процедура ПроверитьВыполнениеФоновогоЗаданияОтправкаЛогов() Экспорт
	
	Результат = ОбщиеПроцедурыИФункцииСервер.ЗаданиеВыполнено(ПредопределенноеЗначение("Перечисление.ПроверяемыеСобытияОбработчикаОжидания.ОтправкаЛогов"));
	Если Результат.Выполнено Тогда
		//и отключаем обработчик ожидания
		
		АдресХЗ = ОбщиеПроцедурыИФункцииСервер.ПолучитьЗначениеКонстанты("АдресХЗ_ОтветаЛоги");
		Если ЗначениеЗаполнено(АдресХЗ) Тогда
			Ответ = ПолучитьИзВременногоХранилища(АдресХЗ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ответ) Тогда
			Если Ответ.Успешно Тогда
				ПоказатьОповещениеПользователя("Отправка логов",, Ответ.СообщениюПользователю);
				ВыгрузкаДанныхСервер.ОчиститьРегисрациюПО();
			Иначе
				ПоказатьОповещениеПользователя("Отправка логов",, Ответ.СообщениюПользователю);
			КонецЕсли;
			ОбщиеПроцедурыИФункцииСервер.ЗадатьЗначениеКонстанты("АдресХЗ_ОтветаЛоги", "");
		Иначе
			ПоказатьОповещениеПользователя("Отправка логов",, Результат.ТекстСообщения);
		КонецЕсли;
		
		ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗаданияОтправкаЛогов");
	ИначеЕсли Результат.НетДанных Тогда
		ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗаданияОтправкаЛогов");
	КонецЕсли;
	
КонецПроцедуры
