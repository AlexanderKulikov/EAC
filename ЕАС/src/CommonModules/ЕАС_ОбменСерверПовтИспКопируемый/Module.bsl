// Модуль написан с учетом того, что он может исполняться как в конфигурации БСХП
//  так и в ЕАС
// Все изменения требуется синхронизировать в обоих конфигурациях
//
#Область ПрограммныйИнтерфейс

#Область ПроцедурыФункцииОбменаПоHTTP

// Возвращает текущую версию расширения ЕАС РасширениеЕАС
//
// Возвращаемое значение:
//   Строка - текущая версия расширения, либо Неопределено
//
Функция ВерсияРасширения() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	МассивРасширений = РасширенияКонфигурации.Получить(Новый Структура("Имя", "РасширениеЕАС"), ИсточникРасширенийКонфигурации.СеансАктивные);
	Если МассивРасширений.Количество() > 0 Тогда
		Возврат МассивРасширений[0].Версия;
	КонецЕсли;	
	
КонецФункции

#КонецОбласти

#Область ПроцедурыФункцииОбмена

// Возвращает признак необходимости регистрации справочника в текущей ИБ по плану обмена ЕАС
//
// Параметры:
// УзелОбмена - ПланОбменаСсылка.ОбменЕАСБухгалтерия - узел плана обмена для проверки.
//
// Возвращаемое значение:
//   Булево - Если Истина то регистрация производится.
//
Функция РегистрироватьИзменениеСправочников(УзелОбмена) Экспорт 
	
	Если ОбменЕАСИспользуется() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ОбменЕАСБухгалтерия.Ссылка КАК Ссылка
		               |ИЗ
		               |	ПланОбмена.ОбменЕАСБухгалтерия КАК ОбменЕАСБухгалтерия
		               |ГДЕ
		               |	ОбменЕАСБухгалтерия.Ссылка = &УзелОбмена
		               |	И НЕ ОбменЕАСБухгалтерия.ЭтотУзел
		               |	И (&ЭтоБазаЕАС
		               |				И НЕ ОбменЕАСБухгалтерия.ЭтоТестоваяИБ
		               |			ИЛИ НЕ &ЭтоБазаЕАС
		               |				И ОбменЕАСБухгалтерия.ЭтоТестоваяИБ)
		               |	И НЕ ОбменЕАСБухгалтерия.ПометкаУдаления";
		Запрос.УстановитьПараметр("ЭтоБазаЕАС", Метаданные.Имя = "ЕдинаяАвтоматизированнаяСистема");
		Запрос.УстановитьПараметр("УзелОбмена", УзелОбмена);
		
		УстановитьБезопасныйРежим(Истина);
		Возврат Не Запрос.Выполнить().Пустой();
		
	Иначе
		
		Возврат Ложь;
	КонецЕсли;	
КонецФункции	

// Возвращает признак необходимости регистрации справочника в текущей ИБ
//
// Возвращаемое значение:
//   Булево - Истина: регистрация производится
//
Функция РегистрироватьИзменениеДокументов() Экспорт
	Возврат Метаданные.Имя <> "ЕдинаяАвтоматизированнаяСистема"
КонецФункции

// Возвращает признак использования подсистемы ЕАС 
//
// Возвращаемое значение:
//   Булево - Истина: подсистема используется
//
Функция ОбменЕАСИспользуется() Экспорт 
	
	ВсеУзлы = УзлыПланаОбмена("ОбменЕАСБухгалтерия");
	Возврат ВсеУзлы.Количество() > 0;
	
КонецФункции	

// Возвращает массив планов обмена подсистемы ЕАС (за исключением главного и помеченных на удаление) в текущей области данных)
//
// Возвращаемое значение:
//   - Массив - массив используемых планов обмена типа ПланОбменаСсылка.ОбменЕАСБухгалтерия 
//
Функция УзлыПланаОбмена(ИмяПланаОбмена) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПланОбмена.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	#ИмяТаблицыПланаОбмена КАК ПланОбмена
	                      |ГДЕ
	                      |	НЕ ПланОбмена.ЭтотУзел
	                      |	И НЕ ПланОбмена.ПометкаУдаления
						  | И ПланОбмена.ОбластьДанных = &ОбластьДанных");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ИмяТаблицыПланаОбмена", "ПланОбмена." + ИмяПланаОбмена);
	Запрос.УстановитьПараметр("ОбластьДанных", ЕАС_ОбластиДанныхКопируемый.ОбластьДанныхДляОбъектов());
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает код главного узла плана обмена по имени
//
// Параметры:
// ИмяПланаОбмена - Строка - Имя плана как задано в конфигураторе.
//
// Возвращаемое значение:
//   Строка - искомый код главного узла.
//
Функция КодЭтогоУзла(ИмяПланаОбмена) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Обмен.Код КАК Код
		|ИЗ
		|	ПланОбмена.ОбменЕАСБухгалтерия КАК Обмен
		|ГДЕ
		|	Обмен.ЭтотУзел";
	
	Если ИмяПланаОбмена <> "ОбменЕАСБухгалтерия" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ОбменЕАСБухгалтерия", ИмяПланаОбмена);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Следующий() Тогда
		Возврат РезультатЗапроса.Код;
	КонецЕсли;
	
КонецФункции

// Возвращает признак необходимости загрузки справочника при обмене по плану обмена ЕАС.
//
// Параметры:
// УзелОбмена - ПланОбменаСсылка.ОбменЕАСБухгалтерия - узел плана обмена.
//
// Возвращаемое значение:
//   Булево - Если Истина, то загрузка требуется.
//
Функция ТребуетсяЗагружатьСправочник(УзелОбмена = Неопределено) Экспорт 
	
	Если Не ОбменЕАСИспользуется() Тогда
		Возврат Ложь;
		
	ИначеЕсли Метаданные.Имя = "ЕдинаяАвтоматизированнаяСистема" Тогда
		// на тестовом узле не регистрируем справочники
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ОбменЕАСБухгалтерия.Ссылка КАК Ссылка
		               |ИЗ
		               |	ПланОбмена.ОбменЕАСБухгалтерия КАК ОбменЕАСБухгалтерия
		               |ГДЕ
		               |	ОбменЕАСБухгалтерия.Ссылка = &УзелОбмена
		               |	И НЕ ОбменЕАСБухгалтерия.ЭтотУзел
		               |	И ОбменЕАСБухгалтерия.ЭтоТестоваяИБ
		               |	И НЕ ОбменЕАСБухгалтерия.ПометкаУдаления";
		Запрос.УстановитьПараметр("УзелОбмена", УзелОбмена);
		
		УстановитьБезопасныйРежим(Истина);
		Возврат Не Запрос.Выполнить().Пустой();
		
	Иначе // БСХП
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ОбменЕАСБухгалтерия.Ссылка КАК Ссылка
		               |ИЗ
		               |	ПланОбмена.ОбменЕАСБухгалтерия КАК ОбменЕАСБухгалтерия
		               |ГДЕ
		               |	ОбменЕАСБухгалтерия.ЭтотУзел
		               |	И НЕ ОбменЕАСБухгалтерия.ЭтоТестоваяИБ";
		
		УстановитьБезопасныйРежим(Истина);
		Возврат Не Запрос.Выполнить().Пустой();
	КонецЕсли;	
КонецФункции	

// Возвращает признак необходимости загрузки документа при обмене по плану обмена ЕАС
//
// Возвращаемое значение:
//   Булево - Если Истина, то загрузка требуется.
//
Функция ТребуетсяЗагружатьДокумент() Экспорт
	Возврат Метаданные.Имя = "ЕдинаяАвтоматизированнаяСистема"
КонецФункции

#КонецОбласти

#КонецОбласти