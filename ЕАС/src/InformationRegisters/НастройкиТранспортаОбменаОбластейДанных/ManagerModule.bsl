///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обновляет запись в регистре по переданным значениям структуры
//
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаОбластейДанных");
	
КонецПроцедуры

Функция НастройкиТранспорта(Знач КонечнаяТочкаКорреспондента) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиТранспорта.FILEКаталогОбменаИнформацией КАК FILEКаталогОбменаИнформацией,
	|	НастройкиТранспорта.FILEСжиматьФайлИсходящегоСообщения КАК FILEСжиматьФайлИсходящегоСообщения,
	|	НастройкиТранспорта.FTPСжиматьФайлИсходящегоСообщения КАК FTPСжиматьФайлИсходящегоСообщения,
	|	НастройкиТранспорта.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения КАК FTPСоединениеМаксимальныйДопустимыйРазмерСообщения,
	|	НастройкиТранспорта.FTPСоединениеПассивноеСоединение КАК FTPСоединениеПассивноеСоединение,
	|	НастройкиТранспорта.FTPСоединениеПользователь КАК FTPСоединениеПользователь,
	|	НастройкиТранспорта.FTPСоединениеПорт КАК FTPСоединениеПорт,
	|	НастройкиТранспорта.FTPСоединениеПуть КАК FTPСоединениеПуть,
	|	НастройкиТранспорта.ВидТранспортаСообщенийОбменаПоУмолчанию КАК ВидТранспортаСообщенийОбменаПоУмолчанию
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластейДанных КАК НастройкиТранспорта
	|ГДЕ
	|	НастройкиТранспорта.КонечнаяТочкаКорреспондента = &КонечнаяТочкаКорреспондента";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не заданы настройки подключения для конечной точки %1.'"),
			Строка(КонечнаяТочкаКорреспондента));
	КонецЕсли;
	
	Результат = ОбменДаннымиСлужебный.РезультатЗапросаВСтруктуру(РезультатЗапроса);
	УстановитьПривилегированныйРежим(Истина);
	Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(КонечнаяТочкаКорреспондента, "FTPСоединениеПарольОбластейДанных,ПарольАрхиваСообщенияОбменаОбластейДанных");
	УстановитьПривилегированныйРежим(Ложь);
	Результат.Вставить("ПарольАрхиваСообщенияОбмена", Пароли.ПарольАрхиваСообщенияОбменаОбластейДанных);
	Результат.Вставить("FTPСоединениеПароль", Пароли.FTPСоединениеПарольОбластейДанных);
	
	Если Результат.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		ПараметрыFTP = ОбменДаннымиСервер.FTPИмяСервераИПуть(Результат.FTPСоединениеПуть);
		
		Результат.Вставить("FTPСервер", ПараметрыFTP.Сервер);
		Результат.Вставить("FTPПуть",   ПараметрыFTP.Путь);
	Иначе
		Результат.Вставить("FTPСервер", "");
		Результат.Вставить("FTPПуть",   "");
	КонецЕсли;
	
	ОбменДаннымиСервер.ДополнитьНастройкиТранспортаКоличествомЭлементовВТранзакции(Результат);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли