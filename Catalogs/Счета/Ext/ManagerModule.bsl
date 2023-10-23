﻿
Функция  ПолучитьСчетДляИсточникаПоступления() Экспорт
	СписокСчетов = ПолучитьВсеСчета();
	Если СписокСчетов.Количество() = 1 Тогда
		Возврат СписокСчетов[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ПолучитьВсеСчета()
	МассивСчетов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Счета.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Счета КАК Счета
	               |ГДЕ
	               |	НЕ Счета.ПометкаУдаления
	               |	И НЕ Счета.Закрыт";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции