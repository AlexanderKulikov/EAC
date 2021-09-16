///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция Подключены() Экспорт
	
	Возврат ОбсужденияСлужебныйВызовСервера.Подключены();
	
КонецФункции

Процедура ПоказатьПодключение(ОписаниеЗавершения = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.ПодключениеОбсуждений.Форма",,,,,, ОписаниеЗавершения);
	
КонецПроцедуры

Процедура ПоказатьОтключение() Экспорт
	
	Если Не ОбсужденияСлужебныйВызовСервера.Подключены() Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Подключение обсуждений не выполнено.'"));
		Возврат;
	КонецЕсли;
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Отключить", НСтр("ru = 'Отключить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Нет);
	
	Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбОтключении", ЭтотОбъект);
	
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Отключить обсуждения?'"),
		Кнопки,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

Процедура ПослеЗаписиПользователя(Форма, ОписаниеЗавершения) Экспорт
	
	Если Не Форма.ПредлагатьОбсуждения Тогда
		ВыполнитьОбработкуОповещения(ОписаниеЗавершения);
		Возврат;
	КонецЕсли;
	
	Форма.ПредлагатьОбсуждения = Ложь;
		
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПредлагатьОбсужденияЗавершение", ЭтотОбъект, ОписаниеЗавершения);
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Истина;
	ПараметрыВопроса.Заголовок = НСтр("ru = 'Обсуждения (система взаимодействий)'");
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОповещениеОЗавершении, Форма.ПредлагатьОбсужденияТекст,
		РежимДиалогаВопрос.ДаНет, ПараметрыВопроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеОтветаНаВопросОбОтключении(КодВозврата, Контекст) Экспорт
	
	Если КодВозврата = "Отключить" Тогда 
		ПриОтключении();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОтключении()
	
	Оповещение = Новый ОписаниеОповещения("ПослеУспешногоОтключения", ЭтотОбъект,,
		"ПриОбработкеОшибкиОтключения", ЭтотОбъект);
	СистемаВзаимодействия.НачатьОтменуРегистрацииИнформационнойБазы(Оповещение);
	
КонецПроцедуры

Процедура ПослеУспешногоОтключения(Контекст) Экспорт
	
	Оповестить("ОбсужденияПодключены", Ложь);
	
КонецПроцедуры

Процедура ПриОбработкеОшибкиОтключения(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	
КонецПроцедуры

Процедура ПредлагатьОбсужденияЗавершение(Результат, ОписаниеЗавершения) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеЗавершения);
		Возврат;
	КонецЕсли;
	
	Если Результат.БольшеНеЗадаватьЭтотВопрос Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("НастройкиПрограммы", "ПредлагатьОбсуждения", Ложь);
	КонецЕсли;
	
	Если Результат.Значение = КодВозвратаДиалога.Да Тогда
		ПоказатьПодключение();
		Возврат;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(ОписаниеЗавершения);
	
КонецПроцедуры

#КонецОбласти