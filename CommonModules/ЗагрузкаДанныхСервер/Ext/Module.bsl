﻿
Процедура ЗагрузитьДанные(Путь, ТолькоСправочники = Ложь) Экспорт 
	
	Попытка
		
		ПутьXML = ПолучитьИмяВременногоФайла("xml");
		
		ФайлТХТ = Новый ЧтениеТекста;
		ФайлТХТ.Открыть(Путь);
		
		ДанныеСтрока = ФайлТХТ.Прочитать();
		Если НЕ ЗначениеЗаполнено(ДанныеСтрока) Тогда
			Ошибка = "Не удалось восстановить данные!";
			ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Ошибка + " Модуль ЗагрузкаДанныхСервер, Процедура ЗагрузитьДанные(), Причина: ФайлТХТ.Прочитать() = Неопределено.");
			ДиалогиСПользователямиСервер.ПоказатьСообщениеПользователю(Ошибка);
			Возврат;
		КонецЕсли;
		
		ДанныеСтрока = СокрЛП(ДанныеСтрока);
		ДанныеСтрока = СтрЗаменить(ДанныеСтрока, " ", "");
		ДанныеСтрока = СтрЗаменить(ДанныеСтрока, Символы.НПП, "");
		
		ХЗ = XMLЗначение(Тип("ХранилищеЗначения"), ДанныеСтрока);
		ДвоичныеДанные = ХЗ.Получить();
		ДвоичныеДанные.Записать(ПутьXML);
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ПутьXML);
		
		ДатаБазы = "";
		ВерсияБазы = "";
		user_id = "";
		ПараметрыСчитаны = Ложь;
		
		Пока ЧтениеXML.Прочитать() Цикл
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Имя = "dateUpLoad" Тогда
				ЧтениеXML.Прочитать();
				ДатаБазы = ЧтениеXML.Значение;
			ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Имя = "version" Тогда
				ЧтениеXML.Прочитать();
				ВерсияБазы = ЧтениеXML.Значение;
			ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Имя = "user_id" Тогда
				ЧтениеXML.Прочитать();
				user_id = ЧтениеXML.Значение;
			ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Имя = "onlyHandbooks" Тогда
				ЧтениеXML.Прочитать();
				ТолькоСправочники = XMLЗначение(Тип("Булево"), ЧтениеXML.Значение);
				ПараметрыСчитаны = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(ДатаБазы) И ЗначениеЗаполнено(ВерсияБазы) И ЗначениеЗаполнено(user_id) И ПараметрыСчитаны Тогда
				ЧтениеXML.Закрыть();
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если user_id <> Константы.user_id.Получить() Тогда
			Константы.user_id.Установить(user_id);
		КонецЕсли;
		
		ЧтениеXML.ОткрытьФайл(ПутьXML);
		НоваяЗагрузка_XML(ЧтениеXML, ПутьXML, ТолькоСправочники);

		Текст = СтрШаблон("База данных успешно згружена! Данные восстановлены по сотоянию на %1", ДатаБазы);
		ДиалогиСПользователямиСервер.ПоказатьСообщениеПользователю(Текст);
		
	Исключение
		Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщиеПроцедурыИФункцииСервер.ЗаписатьЛоги(Ошибка);
		ДиалогиСПользователямиСервер.ПоказатьСообщениеПользователю(Ошибка);
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(ПутьXML);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Текст = "Не удалост удалить файл." + Символы.ПС + ТекстОшибки;
		ЛогированиеОшибокСервер.ЗаписатьОшибкуВЛоги(Текст);
	КонецПопытки;

КонецПроцедуры

//Новый вариант
Процедура НоваяЗагрузка_XML(ЧтениеXML, Путь, ТолькоСправочники) Экспорт
	
	Пока ЧтениеXML.Прочитать() Цикл
		Пока ВозможностьЧтенияXML(ЧтениеXML) Цикл
			Объект = ПрочитатьXML(ЧтениеXML);
			//Объект.ОбменДанными.Загрузка = Истина;
			Объект.ДополнительныеСвойства.Вставить("ЗагрузкаДанных", Истина);
			Если СтрНайти(Объект.Метаданные().ПолноеИмя(), "Справочник") > 0 Тогда
				Если Объект.Предопределенный Тогда
					ОбъектКопия = Объект;
					СпрСс = Справочники[Объект.Метаданные().Имя].НайтиПоКоду(ОбъектКопия.Код);
					Если ЗначениеЗаполнено(СпрСс) Тогда 
						ОбъектСт = СпрСс.ПолучитьОбъект();
												
						Если Объект.Метаданные().ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Число Тогда
							ТипПриведения = Тип("Число");
						Иначе
							ТипПриведения = Тип("Строка");
						КонецЕсли;
						guid = ПолучитьGUID(Путь, ЧтениеXML.Имя, Объект.Код, ТипПриведения);
						
						Объект = Справочники[Объект.Метаданные().Имя].СоздатьЭлемент();
						ЗаполнитьЗначенияСвойств(Объект, ОбъектСт,, ПолучитьПропускаемыРеквизиты(СпрСс));
						Объект.ИмяПредопределенныхДанных = ОбъектКопия.ИмяПредопределенныхДанных;
						Объект.УстановитьСсылкуНового(ПолучитьСсылкуСпр(Объект, Новый УникальныйИдентификатор(guid)));
						
						ОбъектСт.Удалить();
						
						Объект.Записать();
					КонецЕсли;
				Иначе
					Объект.Записать();
				КонецЕсли;
			ИначеЕсли СтрНайти(Объект.Метаданные().ПолноеИмя(), "Документ") > 0 И НЕ ТолькоСправочники Тогда
				Если Объект.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
					Объект.Записать(РежимЗаписиДокумента.Проведение);
				Иначе					
					Объект.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
			ИначеЕсли СтрНайти(Объект.Метаданные().ПолноеИмя(), "Регистр") > 0 И НЕ ТолькоСправочники Тогда
				Объект.Записать();
			ИначеЕсли СтрНайти(Объект.Метаданные().ПолноеИмя(), "Константа") > 0 И НЕ ТолькоСправочники Тогда
				Объект.Записать();
			КонецЕсли;			
		КонецЦикла;
	КонецЦикла;
	
	//ПровестиДокументыНепроведенные
	
КонецПроцедуры

Функция ПолучитьПропускаемыРеквизиты(СпрСсылка)
	
	ПропускаемыеРеквизиты = "";
	
	Если НЕ СпрСсылка.Метаданные().Иерархический Тогда
		ПропускаемыеРеквизиты = ПропускаемыеРеквизиты + ?(ЗначениеЗаполнено(ПропускаемыеРеквизиты), ", ", "") + "Родитель";
	КонецЕсли;
	
	Если СпрСсылка.Метаданные().Владельцы.Количество() = 0 Тогда
		ПропускаемыеРеквизиты = ПропускаемыеРеквизиты + ?(ЗначениеЗаполнено(ПропускаемыеРеквизиты), ", ", "") + "Владелец";
	КонецЕсли;
	
	Если СпрСсылка.Метаданные().ПолучитьИменаПредопределенных().Количество() = 0 Тогда
		ПропускаемыеРеквизиты = ПропускаемыеРеквизиты + ?(ЗначениеЗаполнено(ПропускаемыеРеквизиты), ", ", "") + "ИмяПредопределенныхДанных";
	КонецЕсли;
	
	Возврат ПропускаемыеРеквизиты;
	
КонецФункции

Функция ПолучитьСсылкуСпр(ОбъектСпр, guid)
	Возврат Справочники[ОбъектСпр.Метаданные().Имя].ПолучитьСсылку(guid);
КонецФункции

Функция ПолучитьGUID(Путь, ИмяСправочника, КодЭлемента, ТипПриведения)
	ЧтХ = Новый ЧтениеXML;
	ЧтХ.ОткрытьФайл(Путь);// + "1cDB_new.xml");
	Пока ЧтХ.Прочитать() Цикл
		Если ЧтХ.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтХ.Имя = ИмяСправочника Тогда
			Пока ЧтХ.Прочитать() Цикл 
				Если ЧтХ.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтХ.Имя = "Ref" Тогда
					ЧтХ.Прочитать();
					guid = ЧтХ.Значение;                           
					Продолжить;
				ИначеЕсли ЧтХ.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтХ.Имя = "Code" Тогда
					ЧтХ.Прочитать();
					Код = XMLЗначение(ТипПриведения, ЧтХ.Значение);
					Если Код = КодЭлемента Тогда
						Возврат guid;
						ЧтХ.Закрыть();
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	ЧтХ.Закрыть();
КонецФункции
