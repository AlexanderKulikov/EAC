
#Область ПрограммныйИнтерфейс

// Запланировать загрузку данных, соответствующих дескриптору.
//
// Параметры:
//  Дескриптор - ОбъектXDTO, Структура - Описание поставляемых данных. Соответствует типу Descriptor пакета XDTO SuppliedData
//     или Структура со свойствами:
//     * DataType - Строка - код вида поставляемых данных
//     * FileGUID - УникальныйИдентификатор - идентификатор файла поставляемых данных
//     * RecommendedUpdateDate - Дата - рекомендуемая дата обработки
//     * Properties - Массив - характеристики поставляемых данных. Каждый элемент является значением типа Структура со свойствами
//          * Code - Строка - код характеристики
//          * Value - Строка - значение характеристики
//          * IsKey - Булево - признак того, что характеристика является ключевой
//     * CreationDate - Дата - момент создания элемента поставляемых данных
//  ДескрипторJSON - Булево - если указать Истина, значит типом параметра Дескриптор функции является Структура (см. выше),
//     значение по умолчанию - Ложь
//
Процедура ЗапланироватьЗагрузкуДанных(Знач Дескриптор, Знач ДескрипторJSON = Ложь) Экспорт
	Перем ДескрипторСтрока, ПараметрыМетода;
	
	Если Дескриптор.RecommendedUpdateDate = Неопределено Тогда
		Дескриптор.RecommendedUpdateDate = ТекущаяУниверсальнаяДата();
	КонецЕсли;
	
	Если ДескрипторJSON Тогда
		ДескрипторСтрока = СериализоватьJSON(Дескриптор);
	Иначе
		ДескрипторСтрока = СериализоватьXDTO(Дескриптор);
	КонецЕсли;
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ДескрипторСтрока);
	ПараметрыМетода.Добавить(ДескрипторJSON);

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода", "СообщенияПоставляемыхДанныхОбработчикСообщения.ЗагрузитьДанные");
	ПараметрыЗадания.Вставить("Ключ", ХешДескриптора(Дескриптор));
	ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
	ПараметрыЗадания.Вставить("ОбластьДанных", -1);
	ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", Дескриптор.RecommendedUpdateDate);
	Если Дескриптор.DataType = "Расширения" Тогда
		ПараметрыЗадания.Вставить("ЭксклюзивноеВыполнение", Истина);	
	КонецЕсли;
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
	
	УстановитьПривилегированныйРежим(Истина);
	ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДесериализоватьJSON(Знач СтрокаJSON, Знач СвойстваСоЗначениемДата = "") Экспорт 
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(СтрокаJSON);
	
	ИменаСвойствВостановления = Новый Массив;
	ИменаСвойствВостановления.Добавить("FileGUID");
	
	Данные = ПрочитатьJSON(Чтение, Ложь, СвойстваСоЗначениемДата,, "ВосстановитьЗначениеJSON", СообщенияПоставляемыхДанныхОбработчикСообщения,, ИменаСвойствВостановления);
	Чтение.Закрыть();
	
	Возврат Данные;
	
КонецФункции

Функция СериализоватьJSON(Знач Дескриптор) Экспорт 
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку();
	
	Если Дескриптор.Свойство("FileGUID") Тогда
		Дескриптор.FileGUID = Строка(Дескриптор.FileGUID);	
	КонецЕсли;
	
	ЗаписатьJSON(Запись, Дескриптор);
	
	Возврат Запись.Закрыть();
	
КонецФункции

// Получает список обработчиков сообщений, которые обрабатывает данная подсистема.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений.
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Знач Обработчики) Экспорт
	
	ДобавитьОбработчикКаналаСообщений("ПоставляемыеДанные\Обновление", СообщенияПоставляемыхДанныхОбработчикСообщения, Обработчики);
	ДобавитьОбработчикКаналаСообщений("ПоставляемыеДанныеJSON\Обновление", СообщенияПоставляемыхДанныхОбработчикСообщения, Обработчики);
	
КонецПроцедуры

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений.
//
// Параметры:
//  КаналСообщений - Строка - идентификатор канала сообщений, из которого получено сообщение.
//  ТелоСообщения - Произвольный - тело сообщения, полученное из канала, которое подлежит обработке.
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(Знач КаналСообщений, Знач ТелоСообщения, Знач Отправитель) Экспорт
	
	Если ОбрабатываемыеКаналы().Найти(КаналСообщений) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		
		Если КаналСообщений = "ПоставляемыеДанные\Обновление" Тогда
			Дескриптор = ДесериализоватьXDTO(ТелоСообщения);
			ДескрипторJSON = Ложь;
		ИначеЕсли КаналСообщений = "ПоставляемыеДанныеJSON\Обновление" Тогда
			Дескриптор = ДесериализоватьJSON(ТелоСообщения, "CreationDate");
			ДескрипторJSON = Истина;
		КонецЕсли;
		
		ОбработатьНовыйДескриптор(Дескриптор, ДескрипторJSON);
		
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки сообщения'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,
			, ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбработатьНовыйДескриптор(Знач Дескриптор, Знач ДескрипторJSON = Ложь) Экспорт
	
	Загружать = Ложь;
	НаборЗаписей = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	
	Для Каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		
		ОбработчикЗагружать = Ложь;
		
		Если ДескрипторJSON Тогда
			Обработчик.Обработчик.ДоступныНовыеДанныеJSON(Дескриптор, ОбработчикЗагружать);
		Иначе
			Обработчик.Обработчик.ДоступныНовыеДанные(Дескриптор, ОбработчикЗагружать);
		КонецЕсли;
		
		Если ОбработчикЗагружать Тогда
			НеобработанныеДанные = НаборЗаписей.Добавить();
			НеобработанныеДанные.ИдентификаторФайла = Дескриптор.FileGUID;
			НеобработанныеДанные.КодОбработчика = Обработчик.КодОбработчика;
			Загружать = Истина;
		КонецЕсли;
		
	КонецЦикла; 
	
	Если Загружать Тогда
		УстановитьПривилегированныйРежим(Истина);
		НаборЗаписей.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗапланироватьЗагрузкуДанных(Дескриптор, ДескрипторJSON);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Доступны новые данные'", 
		ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, ,
		, ?(Загружать, НСтр("ru = 'В очередь добавлено задание на загрузку.'"), НСтр("ru = 'Загрузка данных не требуется.'"))
		+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));

КонецПроцедуры

Процедура ЗагрузитьДанные(Знач ДескрипторСтрока, Знач ДескрипторJSON = Ложь) Экспорт
	Перем Дескриптор, ИмяФайлаВыгрузки;
	
	Попытка
		
		Если ДескрипторJSON Тогда
			Дескриптор = ДесериализоватьJSON(ДескрипторСтрока, "CreationDate,RecommendedUpdateDate");
		Иначе
			Дескриптор = ДесериализоватьXDTO(ДескрипторСтрока);
		КонецЕсли;
		
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка работы с XML'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ ДескрипторСтрока);
		Возврат;
	КонецПопытки;

	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
		ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, ,
		, НСтр("ru = 'Загрузка начата'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));

	Если ЗначениеЗаполнено(Дескриптор.FileGUID) Тогда
		ИмяФайлаВыгрузки = ПолучитьФайлИзХранилища(Дескриптор, ДескрипторJSON);
	
		Если ИмяФайлаВыгрузки = Неопределено Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
				ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Информация, ,
				, НСтр("ru = 'Файл не может быть загружен'") + Символы.ПС 
				+ ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
		ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Примечание, ,
		, НСтр("ru = 'Загрузка успешно выполнена'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));

	// РегистрСведений.ПоставляемыеДанныеТребующиеОбработки используется на тот случай, если выполнение
	// цикла было прервано перезагрузкой сервера.
	// В этой ситуации единственный способ сохранить информацию о отработавших обработчиках (если их более 1) - 
	// оперативно записывать их в указанный регистр.
	НаборНеобработанныхДанных = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборНеобработанныхДанных.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	НаборНеобработанныхДанных.Прочитать();
	БылиОшибки = Ложь;
	
	Для Каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		ЗаписьНайдена = Ложь;
		Для Каждого ЗаписьНеобработанныхДанных Из НаборНеобработанныхДанных Цикл
			Если ЗаписьНеобработанныхДанных.КодОбработчика = Обработчик.КодОбработчика Тогда
				ЗаписьНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		
		Если Не ЗаписьНайдена Тогда 
			Продолжить;
		КонецЕсли;
			
		Попытка
			
			Если ДескрипторJSON Тогда
				Обработчик.Обработчик.ОбработатьНовыеДанныеJSON(Дескриптор, ИмяФайлаВыгрузки);
			Иначе 
				Обработчик.Обработчик.ОбработатьНовыеДанные(Дескриптор, ИмяФайлаВыгрузки);
			КонецЕсли;
			
			НаборНеобработанныхДанных.Удалить(ЗаписьНеобработанныхДанных);
			НаборНеобработанныхДанных.Записать();			
			
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки'", 
				ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, ,
				, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
				+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON)
				+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
				
			ЗаписьНеобработанныхДанных.КоличествоПопыток = ЗаписьНеобработанныхДанных.КоличествоПопыток + 1;
			Если ЗаписьНеобработанныхДанных.КоличествоПопыток > 3 Тогда
				УведомитьОбОтменеОбработки(Обработчик, Дескриптор, ДескрипторJSON);
				НаборНеобработанныхДанных.Удалить(ЗаписьНеобработанныхДанных);
			Иначе
				БылиОшибки = Истина;
			КонецЕсли;
			НаборНеобработанныхДанных.Записать();			
			
		КонецПопытки;
	КонецЦикла; 
	
	Если ИмяФайлаВыгрузки <> Неопределено Тогда
		
		ФайлВременный = Новый Файл(ИмяФайлаВыгрузки);
		
		Если ФайлВременный.Существует() Тогда
			
			Попытка
				
				ФайлВременный.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ИмяФайлаВыгрузки);
				
			Исключение
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", ОбщегоНазначения.КодОсновногоЯзыка()), 
					УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТранзакцияАктивна() Тогда
			
		Пока ТранзакцияАктивна() Цикл
				
			ОтменитьТранзакцию();
				
		КонецЦикла;
			
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки'", 
			ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, 
			,
			, 
			НСтр("ru = 'По завершении выполнения обработчика не была закрыта транзакция'")
				 + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));
			
	КонецЕсли;
	
	Если БылиОшибки Тогда
		// Откладываем загрузку на 5 минут.
		Дескриптор.RecommendedUpdateDate = ТекущаяУниверсальнаяДата() + 5 * 60;
		ЗапланироватьЗагрузкуДанных(Дескриптор, ДескрипторJSON);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Обработка данных будет запущена повторно из-за ошибки обработчика.'")
			 + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));
	Иначе
		НаборНеобработанныхДанных.Очистить();
		НаборНеобработанныхДанных.Записать();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Информация, ,
			, НСтр("ru = 'Новые данные обработаны'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));

	КонецЕсли;
	
КонецПроцедуры

Функция ВосстановитьЗначениеJSON(Знач Свойство, Знач Значение, Знач ДопПараметры) Экспорт 
	
	Если Свойство = "FileGUID" Тогда
		Возврат Новый УникальныйИдентификатор(Значение);
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьСведенияОНеобработанныхДанных(Знач Дескриптор, Знач ДескрипторJSON = Ложь)
	
	НаборНеобработанныхДанных = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборНеобработанныхДанных.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	НаборНеобработанныхДанных.Прочитать();
	
	Для каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		ЗаписьНайдена = Ложь;
		
		Для каждого ЗаписьНеобработанныхДанных Из НаборНеобработанныхДанных Цикл
			Если ЗаписьНеобработанныхДанных.КодОбработчика = Обработчик.КодОбработчика Тогда
				ЗаписьНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		
		Если Не ЗаписьНайдена Тогда 
			Продолжить;
		КонецЕсли;
			
		УведомитьОбОтменеОбработки(Обработчик, Дескриптор, ДескрипторJSON);
		
	КонецЦикла; 
	НаборНеобработанныхДанных.Очистить();
	НаборНеобработанныхДанных.Записать();
	
КонецПроцедуры

Процедура УведомитьОбОтменеОбработки(Знач Обработчик, Знач Дескриптор, Знач ДескрипторJSON = Ложь)
	
	Попытка
		Обработчик.Обработчик.ОбработкаДанныхОтменена(Дескриптор);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Отмена обработки'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Информация,,
			, ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON)
			+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
	
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Отмена обработки'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,
			, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON)
			+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
	КонецПопытки;

КонецПроцедуры

Функция ПолучитьФайлИзХранилища(Знач Дескриптор, Знач ДескрипторJSON = Ложь)
	
	Попытка
		ИмяФайлаВыгрузки = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Дескриптор.FileGUID);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка хранилища'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор, ДескрипторJSON));
				
		// Откладываем загрузку на час.
		Дескриптор.RecommendedUpdateDate = Дескриптор.RecommendedUpdateDate + 60 * 60;
		ЗапланироватьЗагрузкуДанных(Дескриптор, ДескрипторJSON);
		Возврат Неопределено;
	КонецПопытки;
	
	// Если файл был заменен или удален между перезапусками функции - 
	// удалим старый план обновления.
	Если ИмяФайлаВыгрузки = Неопределено Тогда
		УдалитьСведенияОНеобработанныхДанных(Дескриптор, ДескрипторJSON);
	КонецЕсли;
	
	Возврат ИмяФайлаВыгрузки;

КонецФункции

Функция ПолучитьОбработчики(Знач ВидДанных)
	
	Обработчики = Новый ТаблицаЗначений;
	Обработчики.Колонки.Добавить("ВидДанных");
	Обработчики.Колонки.Добавить("Обработчик");
	Обработчики.Колонки.Добавить("КодОбработчика");
	
	ИнтеграцияПодсистемБТС.ПриОпределенииОбработчиковПоставляемыхДанных(Обработчики);
	ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных(Обработчики);
	
	Возврат Обработчики.Скопировать(Новый Структура("ВидДанных", ВидДанных), "Обработчик, КодОбработчика");
	
КонецФункции	

Функция СериализоватьXDTO(Знач XDTOОбъект)
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, XDTOОбъект, , , , НазначениеТипаXML.Явное);
	Возврат Запись.Закрыть();
КонецФункции

Функция ДесериализоватьXDTO(Знач СтрокаXML) 
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(СтрокаXML);
	XDTOОбъект = ФабрикаXDTO.ПрочитатьXML(Чтение);
	Чтение.Закрыть();
	Возврат XDTOОбъект;
КонецФункции

Процедура ДобавитьОбработчикКаналаСообщений(Знач Канал, Знач ОбработчикКанала, Знач Обработчики)
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Канал = Канал;
	Обработчик.Обработчик = ОбработчикКанала;
	
КонецПроцедуры

Функция ОбрабатываемыеКаналы()
	
	Массив = Новый Массив;
	Массив.Добавить("ПоставляемыеДанные\Обновление");
	Массив.Добавить("ПоставляемыеДанныеJSON\Обновление");
	
	Возврат Массив;
	
КонецФункции

Функция ХешДескриптора(Дескриптор)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.CRC32);
	
	ХешированиеДанных.Добавить(Строка(Дескриптор.DataType));
	ХешированиеДанных.Добавить(Строка(Дескриптор.FileGUID));
	
	Если ТипЗнч(Дескриптор.Properties) = Тип("Массив") Тогда
		Характеристики = Дескриптор.Properties;
	Иначе
		Характеристики = Дескриптор.Properties.Property;
	КонецЕсли;
	Для Каждого Характеристика Из Характеристики Цикл
		ХешированиеДанных.Добавить(СтрШаблон("%1:%2", Характеристика.Code, Характеристика.Value));
	КонецЦикла;
	
	Возврат Формат(ХешированиеДанных.ХешСумма, "ЧГ=0");
	
КонецФункции

#КонецОбласти