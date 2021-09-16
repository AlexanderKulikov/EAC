///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму для отправки нового SMS.
//
// Параметры:
//   НомераПолучателей - Массив - номера получателей в формате +<КодСтраны><КодDEF><номер>(строкой);
//   Текст             - Строка - текст сообщения, длиной не более 1000 символов;
//   ДополнительныеПараметры - Структура - Дополнительные параметры отправки SMS.
//          * ИмяОтправителя     - Строка - Имя отправителя, которое будет отображаться вместо номера у получателей.
//          * ПеревестиВТранслит - Булево - Истина, если требуется переводить текст сообщения в транслит перед отправкой.
//   СтандартнаяОбработка - Булево -  Флаг необходимости выполнения стандартной обработки отправки SMS.
Процедура ПриОтправкеSMS(НомераПолучателей, Текст, ДополнительныеПараметры, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Определяет адрес страницы провайдера в сети Интернет.
//
// Параметры:
//  Провайдер - ПеречислениеСсылка.ПровайдерыSMS - поставщик услуги по отправке SMS.
//  АдресВИнтернете - Строка - адрес страницы провайдера в Интернете.
Процедура ПриПолученииАдресаПровайдераВИнтернете(Провайдер, АдресВИнтернете) Экспорт
	
	// _Демо начало примера
	Если Провайдер = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS._ДемоДругойПровайдер") Тогда
		АдресВИнтернете = "http://yandex.ru/search/?text=рассылка%20смс";
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
