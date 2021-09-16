///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ИтерацияПроверки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		ТекстЗаголовкаФормы = НСтр("ru = 'Выгрузить данные в локальную версию'");
		ТекстСообщения      = НСтр("ru = 'Данные из сервиса будут выгружены в файл для последующей их загрузки
			|и использования в локальной версии.'");
	Иначе
		ТекстЗаголовкаФормы = НСтр("ru = 'Выгрузить данные для перехода в сервис'");
		ТекстСообщения      = НСтр("ru = 'Данные из локальной версии будут выгружены в файл для последующей их загрузки
			|и использования в режиме сервиса.'");
	КонецЕсли;
	Элементы.ДекорацияПредупреждение.Заголовок = ТекстСообщения;
	Заголовок = ТекстЗаголовкаФормы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Команда)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.АктивныеПользователи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	Если РежимВыгрузкиДляТехническойПоддержки Тогда 		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузкаДанныхДляТехническойПоддержкиПроверкаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'В режиме выгрузки для технической поддержки не будут выгружаться присоединенные файлы (картинки, документы), версии объектов и другие данные. 
			|Полученную выгрузку необходимо использовать только в целях тестирования и разбора проблем. Продолжить?'"),
			РежимДиалогаВопрос.ОКОтмена,,
			КодВозвратаДиалога.Отмена);		
	Иначе
		ЗапуститьВыгрузкуДанных();	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте 
Процедура СохранитьФайлВыгрузки()
	
	ЧастиФайла = ПолучитьИзВременногоХранилища(АдресХранилища);
	ОбъединитьФайлИзЧастей(ЧастиФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьФайлИзЧастей(ЧастиФайла)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЧастиФайла", ЧастиФайла);
	ДополнительныеПараметры.Вставить("ВсегоЧастейФайла", 0);
	ДополнительныеПараметры.Вставить("ПолученоЧастейФайла", 0);
	
	ПослеУстановкиРасширенияРаботыСФайлами = Новый ОписаниеОповещения("ПослеУстановкиРасширенияРаботыСФайлами", ЭтотОбъект, ДополнительныеПараметры);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ПослеУстановкиРасширенияРаботыСФайлами);
	
КонецПроцедуры

&НаКлиенте 
Процедура ПослеУстановкиРасширенияРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если РежимВыгрузкиДляТехническойПоддержки Тогда
		ПолноеИмяФайла = "data_dump_technical_support.zip";
	Иначе
		ПолноеИмяФайла = "data_dump.zip";
	КонецЕсли;

	Если Подключено Тогда
		
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		ДиалогВыбораФайла.МножественныйВыбор = Ложь;
		ДиалогВыбораФайла.ПолноеИмяФайла = ПолноеИмяФайла;
		ДиалогВыбораФайла.Расширение = "zip";
		ДиалогВыбораФайла.Фильтр = "ZIP архив(*.zip)|*.zip";
		
		Если ЭтоАдресВременногоХранилища(ДополнительныеПараметры.ЧастиФайла) Тогда
			
			// Данные файла уже помещены во временное хранилище, так как разделение не выполнялось.
			ПолучаемыеФайлы = Новый Массив;
			ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайла, ДополнительныеПараметры.ЧастиФайла));
			НачатьПолучениеФайлов(Новый ОписаниеОповещения("ПослеПолученияФайла", ЭтотОбъект, ДополнительныеПараметры), ПолучаемыеФайлы, ДиалогВыбораФайла);
			
		Иначе
		
			// Разделение выполнялось, необходимо получить части файла и объединить под указанным именем.
			ДополнительныеПараметры.ВсегоЧастейФайла = ДополнительныеПараметры.ЧастиФайла.Количество();
			ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбораФайла", ЭтотОбъект, ДополнительныеПараметры));
			
		КонецЕсли;
		
	Иначе
		
		// Данные файла уже помещены во временное хранилище, так как разделение не выполнялось.
		ПолучитьФайл(ДополнительныеПараметры.ЧастиФайла, ПолноеИмяФайла);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияФайла(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияДиалогаВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		
		ЗавершитьПолучениеЧастейФайла(ДополнительныеПараметры.ЧастиФайла);
		Закрыть();
		Возврат;
		
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ИмяФайла", ВыбранныеФайлы[0]);
	ДополнительныеПараметры.Вставить("ИменаЧастей", Новый Массив);
	
	#Если НЕ ВебКлиент Тогда
		
	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ВременныйКаталог);
	ДополнительныеПараметры.Вставить("ВременныйКаталог", ВременныйКаталог);
	
	#КонецЕсли
	
	ПолучитьЧастьФайла(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЧастьФайла(ДополнительныеПараметры)
	
	Состояние(НСтр("ru = 'Получение файла...'"), ДополнительныеПараметры.ПолученоЧастейФайла * 100 / ДополнительныеПараметры.ВсегоЧастейФайла);
	
	ПолучаемыеФайлы = Новый Массив;
	ИмяЧасти = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ДополнительныеПараметры.ЧастиФайла[ДополнительныеПараметры.ПолученоЧастейФайла].Хранение).Имя;
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяЧасти, АдресХранилища));
	
	ПоместитьВоВременноеХранилищеЧастьФайла(ДополнительныеПараметры.ЧастиФайла[ДополнительныеПараметры.ПолученоЧастейФайла], АдресХранилища);
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияЧастиФайла", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПолучениеФайлов(Оповещение, ПолучаемыеФайлы, ДополнительныеПараметры.ВременныйКаталог, Ложь);
		
КонецПроцедуры

// Параметры:
// 	ПолученныеФайлы - Массив Из ОписаниеПереданногоФайла - полученные файлы.
// 	ДополнительныеПараметры - Структура - дополнительные параметры:
//	 * ИменаЧастей - Массив Из Строка - имена частей файла.
//	 * ИмяФайла - Строка - имя полученного файла.
&НаКлиенте
Процедура ПослеПолученияЧастиФайла(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	ОписаниеФайла = ПолученныеФайлы[0]; // ОписаниеПереданногоФайла
	ДополнительныеПараметры.ИменаЧастей.Добавить(ОписаниеФайла.Имя);
	
	ДополнительныеПараметры.ПолученоЧастейФайла = ДополнительныеПараметры.ПолученоЧастейФайла + 1;
	Состояние(НСтр("ru = 'Получение файла...'"), ДополнительныеПараметры.ПолученоЧастейФайла * 100 / ДополнительныеПараметры.ВсегоЧастейФайла);
	
	Если ДополнительныеПараметры.ПолученоЧастейФайла < ДополнительныеПараметры.ВсегоЧастейФайла Тогда
	
		ПолучитьЧастьФайла(ДополнительныеПараметры);
		
	Иначе
		
		#Если НЕ ВебКлиент Тогда
			
		ОбъединитьФайлы(ДополнительныеПараметры.ИменаЧастей, ДополнительныеПараметры.ИмяФайла);
		ЗавершитьПолучениеЧастейФайла(ДополнительныеПараметры.ЧастиФайла);
		УдалитьФайлы(ДополнительныеПараметры.ВременныйКаталог);
		
		#КонецЕсли
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоместитьВоВременноеХранилищеЧастьФайла(Знач ОписаниеЧастиФайла, АдресХранилища)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.CRC32);
	ХешированиеДанных.ДобавитьФайл(ОписаниеЧастиФайла.Хранение);
	
	Если ХешированиеДанных.ХешСумма <> ОписаниеЧастиФайла.ХешСумма Тогда
		
		ВызватьИсключение НСтр("ru = 'Ошибка при получении части файла.'");
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ОписаниеЧастиФайла.Хранение), АдресХранилища);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗавершитьПолучениеЧастейФайла(ЧастиФайла)
	
	Для каждого ОписаниеЧастиФайла Из ЧастиФайла Цикл
		
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.CRC32);
		ХешированиеДанных.ДобавитьФайл(ОписаниеЧастиФайла.Хранение);
		
		Если ХешированиеДанных.ХешСумма = ОписаниеЧастиФайла.ХешСумма Тогда
			
			ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ОписаниеЧастиФайла.Хранение).Путь);
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СнятьМонопольныйРежимПослеВыгрузки()
	
	УстановитьМонопольныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьГотовностьВыгрузки()
	
	Попытка
		ГотовностьВыгрузки = ВыгрузкаГотова();
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
		СнятьМонопольныйРежимПослеВыгрузки();
		
		ОбработатьОшибку(
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
	Если ГотовностьВыгрузки Тогда
		СнятьМонопольныйРежимПослеВыгрузки();
		ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
		СохранитьФайлВыгрузки();
	Иначе
		
		ИтерацияПроверки = ИтерацияПроверки + 1;
		
		Если ИтерацияПроверки = 3 Тогда
			ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
			ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 30);
		ИначеЕсли ИтерацияПроверки = 4 Тогда
			ОтключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки");
			ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 60);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиЗаданиеПоИдентификатору(Идентификатор)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	
	Возврат Задание;
	
КонецФункции

&НаСервере
Функция ВыгрузкаГотова()
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Предупреждение;
	
	Если Задание = Неопределено Тогда
		ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - не найдено задание подготавливающее выгрузку.'"));
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		ОшибкаЗадания = Задание.ИнформацияОбОшибке;
		Если ОшибкаЗадания <> Неопределено Тогда
			ВызватьИсключение(ПодробноеПредставлениеОшибки(ОшибкаЗадания));
		Иначе
			ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - задание подготавливающее выгрузку завершилось с неизвестной ошибкой.'"));
		КонецЕсли;
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		ВызватьИсключение(НСтр("ru = 'При подготовке выгрузки произошла ошибка - задание подготавливающее выгрузку было отменено администратором.'"));
	Иначе
		ИдентификаторЗадания = Неопределено;
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗапуститьВыгрузкуДанныхНаСервере()
	
	УстановитьМонопольныйРежим(Истина);
	
	Попытка
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		АдресХранилищаФайла = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(АдресХранилища);
		ПараметрыЗадания.Добавить(АдресХранилищаФайла);
		ПараметрыЗадания.Добавить(ОбщегоНазначения.ЭтоВебКлиент());
		ПараметрыЗадания.Добавить(0);
		ПараметрыЗадания.Добавить(РежимВыгрузкиДляТехническойПоддержки);

		Задание = ФоновыеЗадания.Выполнить("ВыгрузкаЗагрузкаОбластейДанных.ВыгрузитьТекущуюОбластьДанныхВФайлИРазделитьНаЧасти", 
			ПараметрыЗадания,
			,
			НСтр("ru = 'Подготовка выгрузки области данных'"));
			
		ИдентификаторЗадания = Задание.УникальныйИдентификатор;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		УстановитьМонопольныйРежим(Ложь);
		ОбработатьОшибку(
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		ОтменитьЗаданиеПодготовки(ИдентификаторЗадания);
		СнятьМонопольныйРежимПослеВыгрузки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьЗаданиеПодготовки(Знач ИдентификаторЗадания)
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено
		ИЛИ Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат;
	КонецЕсли;
	
	Попытка
		Задание.Отменить();
	Исключение
		// Возможно задание как раз в этот момент закончилось и ошибки нет
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отмена выполнения задания подготовки выгрузки области данных'", 
			ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьОшибку(Знач КраткоеПредставление, Знач ПодробноеПредставление)
	
	ШаблонЗаписиЖР = НСтр("ru = 'При выгрузке данных произошла ошибка:
                           |
                           |-----------------------------------------
                           |%1
                           |-----------------------------------------'");
	ТекстЗаписиЖР = СтрШаблон(ШаблонЗаписиЖР, ПодробноеПредставление);
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Выгрузка данных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		ТекстЗаписиЖР);
	
	ШаблонИсключения = НСтр("ru = 'При выгрузке данных произошла ошибка: %1.
                             |
                             |Расширенная информация для службы поддержки записана в журнал регистрации. Если причина ошибки неизвестна - рекомендуется обратиться в службу технической поддержки, предоставив для расследования информационную базу и выгрузку журнала регистрации.'");
	
	ВызватьИсключение СтрШаблон(ШаблонИсключения, КраткоеПредставление);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаДанныхДляТехническойПоддержкиПроверкаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ЗапуститьВыгрузкуДанных();	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗапуститьВыгрузкуДанных()
	
	ЗапуститьВыгрузкуДанныхНаСервере();
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Выгрузка;
	
	ИтерацияПроверки = 1;
	
	ПодключитьОбработчикОжидания("ПроверитьГотовностьВыгрузки", 15);
	
КонецПроцедуры

#КонецОбласти
