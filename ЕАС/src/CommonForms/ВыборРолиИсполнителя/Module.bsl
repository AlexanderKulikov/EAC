///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Роль = Параметры.РольИсполнителя;
	ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
	ДополнительныйОбъектАдресации = Параметры.ДополнительныйОбъектАдресации;
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
	Если Параметры.ВыборОбъектаАдресации Тогда
		ТекущийЭлемент = Элементы.ОсновнойОбъектАдресации;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользуетсяБезОбъектовАдресации Тогда
		Возврат;
	КонецЕсли;
		
	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
	
	Если ЗаданыТипыОсновногоОбъектаАдресации И ОсновнойОбъектАдресации = Неопределено Тогда
		
		ОбщегоНазначения.СообщитьПользователю( 
		    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"), Роль.ТипыОсновногоОбъектаАдресации.Наименование ),,,
				"ОсновнойОбъектАдресации", Отказ);
				
	ИначеЕсли ЗаданыТипыДополнительногоОбъектаАдресации И ДополнительныйОбъектАдресации = Неопределено Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"), Роль.ТипыДополнительногоОбъектаАдресации.Наименование ),,, 
			"ДополнительныйОбъектАдресации", Отказ);
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OKВыполнить()
	
	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = ПараметрыЗакрытия();
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТипыОбъектовАдресации()
	
	ТипыОсновногоОбъектаАдресации = Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения;
	ТипыДополнительногоОбъектаАдресации = Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения;
	ИспользуетсяСОбъектамиАдресации = Роль.ИспользуетсяСОбъектамиАдресации;
	ИспользуетсяБезОбъектовАдресации = Роль.ИспользуетсяБезОбъектовАдресации;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()

	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации
		И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации 
		И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
		
	Элементы.ОсновнойОбъектАдресации.Заголовок = Роль.ТипыОсновногоОбъектаАдресации.Наименование;
	Элементы.ОсновнойОбъектАдресации.Доступность = ЗаданыТипыОсновногоОбъектаАдресации; 
	Элементы.ОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыОсновногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ОсновнойОбъектАдресации.ОграничениеТипа = ТипыОсновногоОбъектаАдресации;
		
	Элементы.ДополнительныйОбъектАдресации.Заголовок = Роль.ТипыДополнительногоОбъектаАдресации.Наименование;
	Элементы.ДополнительныйОбъектАдресации.Доступность = ЗаданыТипыДополнительногоОбъектаАдресации; 
	Элементы.ДополнительныйОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыДополнительногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	                        
КонецПроцедуры

&НаСервере
Функция ПараметрыЗакрытия()
	
	Результат = Новый Структура;
	Результат.Вставить("РольИсполнителя", Роль);
	Результат.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Результат.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	
	Если Результат.ОсновнойОбъектАдресации <> Неопределено И Результат.ОсновнойОбъектАдресации.Пустая() Тогда
		Результат.ОсновнойОбъектАдресации = Неопределено;
	КонецЕсли;
	
	Если Результат.ДополнительныйОбъектАдресации <> Неопределено И Результат.ДополнительныйОбъектАдресации.Пустая() Тогда
		Результат.ДополнительныйОбъектАдресации = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
