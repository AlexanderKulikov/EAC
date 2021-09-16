///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик активизации строки пользовательской настройки СКД отчета.
//
// Параметры:
//   Отчет - ДанныеФормыЭлементКоллекции - строка табличной части, описывающая отчет.
//       Свойства для чтения:
//         * ПолноеИмя - Строка - полное имя отчета. Например: "Отчет.ИмяОтчета".
//         * КлючВарианта - Строка - ключ варианта отчета.
//         * Отчет - СправочникСсылка.ВариантыОтчетов - ссылка варианта отчета.
//         * Представление - Строка - наименование варианта отчета.
//       Свойства для изменения:
//         * ВнесеныИзменения - Булево - следует установить Истина когда меняются пользовательские настройки отчета.
//   КомпоновщикНастроекКД - КомпоновщикНастроекКомпоновкиДанных - все настройки отчета.
//       Свойства для изменения:
//       * ПользовательскиеНастройки - ПользовательскиеНастройкиКомпоновкиДанных - все пользовательские настройки отчета.
//       Все прочие свойства - только для чтения.
//   ИдентификаторКД - ИдентификаторКомпоновкиДанных - идентификатор пользовательской настройки отчета.
//       Может использоваться для получения данных пользовательской настройки. Например:
//       	ПользовательскаяНастройкаКД = КомпоновщикНастроекКД.НайтиПоИдентификатору(ИдентификаторКД);
//   ТолькоПросмотрЗначения - Булево - флажок возможности непосредственного редактирования колонки "Значение".
//       Если установить в Истина, то следует определить обработчик выбора значения в событии "ПриНачалеВыбораНастройки".
//
Процедура ПриАктивизацииСтрокиНастройки(Отчет, КомпоновщикНастроекКД, ИдентификаторКД, ТолькоПросмотрЗначения) Экспорт
	
КонецПроцедуры

// Обработчик начала выбора значения для строки пользовательской настройки СКД отчета.
//
// Параметры:
//   Отчет - ДанныеФормыЭлементКоллекции - строка табличной части, описывающая отчет.
//       Свойства для чтения:
//         * ПолноеИмя - Строка - полное имя отчета. Например: "Отчет.ИмяОтчета".
//         * КлючВарианта - Строка - ключ варианта отчета.
//         * Отчет - СправочникСсылка.ВариантыОтчетов - ссылка варианта отчета.
//         * Представление - Строка - наименование варианта отчета.
//       Свойства для изменения:
//         * ВнесеныИзменения - Булево - следует установить Истина когда меняются пользовательские настройки отчета.
//   КомпоновщикНастроекКД - КомпоновщикНастроекКомпоновкиДанных - все настройки отчета.
//       Свойства для изменения:
//       * ПользовательскиеНастройки - ПользовательскиеНастройкиКомпоновкиДанных - все пользовательские настройки отчета.
//       Все прочие свойства - только для чтения.
//   ИдентификаторКД - ИдентификаторКомпоновкиДанных - идентификатор пользовательской настройки отчета.
//       Может использоваться для получения данных пользовательской настройки. Например:
//       	ПользовательскаяНастройкаКД = КомпоновщикНастроекКД.НайтиПоИдентификатору(ИдентификаторКД);
//   СтандартнаяОбработка - Булево - если Истина, то будет использован стандартный диалог выбора.
//       Если используется собственная обработка события, то следует установить в Ложь.
//   Обработчик - ОписаниеОповещения - обработчик результата выбора прикладной формы.
//       В качестве 1-го параметра (Результат) в процедуру-обработчик могут быть переданы значения типов:
//       Неопределено - пользователь отказался от выбора.
//       ПользовательскиеНастройкиКомпоновкиДанных - новые настройки отчета.
//
Процедура ПриНачалеВыбораНастройки(Отчет, КомпоновщикНастроекКД, ИдентификаторКД, СтандартнаяОбработка, Обработчик) Экспорт
	
КонецПроцедуры

// Обработчик очистки значения для строки пользовательской настройки СКД отчета.
//
// Параметры:
//   Отчет - ДанныеФормыЭлементКоллекции - строка табличной части, описывающая отчет.
//       Свойства для чтения:
//         * ПолноеИмя - Строка - полное имя отчета. Например: "Отчет.ИмяОтчета".
//         * КлючВарианта - Строка - ключ варианта отчета.
//         * Отчет - СправочникСсылка.ВариантыОтчетов - ссылка варианта отчета.
//         * Представление - Строка - наименование варианта отчета.
//       Свойства для изменения:
//         * ВнесеныИзменения - Булево - следует установить Истина когда меняются пользовательские настройки отчета.
//   КомпоновщикНастроекКД - КомпоновщикНастроекКомпоновкиДанных - все настройки отчета.
//       Свойства для изменения:
//       * ПользовательскиеНастройки - ПользовательскиеНастройкиКомпоновкиДанных - все пользовательские настройки отчета.
//       Все прочие свойства - только для чтения.
//   ИдентификаторКД - ИдентификаторКомпоновкиДанных - идентификатор пользовательской настройки отчета.
//       Может использоваться для получения данных пользовательской настройки. Например:
//       	ПользовательскаяНастройкаКД = КомпоновщикНастроекКД.НайтиПоИдентификатору(ИдентификаторКД);
//   СтандартнаяОбработка - Булево - если Истина, то значение настройки будет очищено.
//       Если значение настройки не должно быть очищено, то следует установить в Ложь.
//
Процедура ПриОчисткеНастройки(Отчет, КомпоновщикНастроекКД, ИдентификаторКД, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти
