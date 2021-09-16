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
	
	МетаданныеУзла = Параметры.Узел.Метаданные(); // ОбъектМетаданныхПланОбмена
	Менеджер = ПланыОбмена[МетаданныеУзла.Имя];
	
	Если Параметры.Узел = Менеджер.ЭтотУзел() Тогда
		ВызватьИсключение
			НСтр("ru = 'Создание начального образа для данного узла невозможно.'");
	Иначе
		ВидБазы = 0; // файловая база
		ТипСУБД = "";
		Узел = Параметры.Узел;
		МожноСоздатьФайловуюБазу = Истина;
		Если ОбщегоНазначения.ЭтоLinuxСервер() Тогда
			МожноСоздатьФайловуюБазу = Ложь;
		КонецЕсли;
		
		КодыЛокализации = ПолучитьДопустимыеКодыЛокализации();
		ЯзыкФайловойБазы = Элементы.Найти("ЯзыкФайловойБазы");
		ЯзыкБазыСервера = Элементы.Найти("ЯзыкБазыСервера");
		
		ЯзыкиФайловойБазы = ЯзыкФайловойБазы.СписокВыбора; // СписокЗначений
		ЯзыкиБазыСервера = ЯзыкБазыСервера.СписокВыбора; // СписокЗначений
		Для Каждого Код Из КодыЛокализации Цикл
			Представление = ПредставлениеКодаЛокализации(Код);
			ЯзыкиФайловойБазы.Добавить(Код, Представление);
			ЯзыкиБазыСервера.Добавить(Код, Представление);
		КонецЦикла;
		
		Язык = КодЛокализацииИнформационнойБазы();
		
	КонецЕсли;
	
	ЕстьФайлыВТомах = Ложь;
	
	Если РаботаСФайлами.ЕстьТомаХраненияФайлов() Тогда
		ЕстьФайлыВТомах = РаботаСФайламиСлужебный.ЕстьФайлыВТомах();
	КонецЕсли;
	
	ОССервераWindows = ОбщегоНазначения.ЭтоWindowsСервер();
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Элементы.ПолноеИмяФайловойБазыLinux.Видимость = НЕ ОССервераWindows;
		Элементы.ПолноеИмяФайловойБазы.Видимость = ОССервераWindows;
	КонецЕсли;
	
	Если ЕстьФайлыВТомах Тогда
		Если ОССервераWindows Тогда
			Элементы.ПолноеИмяФайловойБазы.АвтоОтметкаНезаполненного = Истина;
			Элементы.ПутьКАрхивуСФайламиТомов.АвтоОтметкаНезаполненного = Истина;
		Иначе
			Элементы.ПолноеИмяФайловойБазыLinux.АвтоОтметкаНезаполненного = Истина;
			Элементы.ПутьКАрхивуСФайламиТомовLinux.АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	Иначе
		Элементы.ГруппаПутьКАрхивуСФайламиТомов.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Элементы.ПутьКАрхивуСФайламиТомов.ПодсказкаВвода = НСтр("ru = '\\имя сервера\resource\files.zip'");
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ИсходныеДанные;
	Элементы.СоздатьНачальныйОбраз.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидБазыПриИзменении(Элемент)
	
	// Переключить страницу параметров.
	Страницы = Элементы.Найти("Страницы");
	Страницы.ТекущаяСтраница = Страницы.ПодчиненныеЭлементы[ВидБазы];
	
	Если ЭтотОбъект.ВидБазы = 0 Тогда
		Элементы.ПутьКАрхивуСФайламиТомов.ПодсказкаВвода = "";
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Истина;
	Иначе
		Элементы.ПутьКАрхивуСФайламиТомов.ПодсказкаВвода = НСтр("ru = '\\имя сервера\resource\files.zip'");
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКАрхивуСФайламиТомовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработчикСохраненияФайла(
		Элемент,
		"ПутьКАрхивуСФайламиТомовWindows",
		СтандартнаяОбработка,
		"files.zip",
		"Архивы zip(*.zip)|*.zip");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяФайловойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработчикСохраненияФайла(
		Элемент,
		"ПолноеИмяФайловойБазыWindows",
		СтандартнаяОбработка,
		"1Cv8.1CD",
		"Любой файл(*.*)|*.*");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяФайловойБазыПриИзменении(Элемент)
	
	ПолноеИмяФайловойБазыWindows = СокрЛП(ПолноеИмяФайловойБазыWindows);
	СтруктураПути = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолноеИмяФайловойБазыWindows);
	Если НЕ ПустаяСтрока(СтруктураПути.Путь) Тогда
		ПутьКФайлу = СтруктураПути.Путь;
		Если ПустаяСтрока(СтруктураПути.Расширение) Тогда
			ПутьКФайлу = СтруктураПути.ПолноеИмя;
			ПолноеИмяФайловойБазыWindows = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтруктураПути.ПолноеИмя);
			ПолноеИмяФайловойБазыWindows = ПолноеИмяФайловойБазыWindows + "1Cv8.1CD";
		КонецЕсли;
		
		МассивКаталогов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьКФайлу, "\", Истина);
		
		Если МассивКаталогов.Количество() > 0 Тогда
			Файл = Новый Файл(МассивКаталогов[0]);
			
			ТекущийМассив = Новый Массив;
			ТекущийМассив.Добавить(МассивКаталогов[0]);
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ПолныйПуть", Файл.ПолноеИмя);
			ДополнительныеПараметры.Вставить("МассивКаталогов",
				ОбщегоНазначенияКлиентСервер.РазностьМассивов(МассивКаталогов, ТекущийМассив));
			
			Оповещение = Новый ОписаниеОповещения("ПроверкаСуществованияПолноеИмяФайловойБазыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			Файл.НачатьПроверкуСуществования(Оповещение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНачальныйОбраз(Команда)
	
	ОчиститьСообщения();
	Если ВидБазы = 0 И НЕ МожноСоздатьФайловуюБазу Тогда
		
		ВызватьИсключение
			НСтр("ru = 'Создание начального образа файловой информационной базы
			           |на данной платформе не поддерживается.'");
	Иначе
		ПроцентВыполнения = 0;
		ДопИнформацияВыполнение = "";
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Узел", Узел);
		ПараметрыЗадания.Вставить("ПутьКАрхивуСФайламиТомовWindows", ПутьКАрхивуСФайламиТомовWindows);
		ПараметрыЗадания.Вставить("ПутьКАрхивуСФайламиТомовLinux", ПутьКАрхивуСФайламиТомовLinux);
		
		Если ВидБазы = 0 Тогда
			// Файловый начальный образ.
			ПараметрыЗадания.Вставить("УникальныйИдентификаторФормы", УникальныйИдентификатор);
			ПараметрыЗадания.Вставить("Язык", Язык);
			ПараметрыЗадания.Вставить("ПолноеИмяФайловойБазыWindows", ПолноеИмяФайловойБазыWindows);
			ПараметрыЗадания.Вставить("ПолноеИмяФайловойБазыLinux", ПолноеИмяФайловойБазыLinux);
			ПараметрыЗадания.Вставить("НаименованиеЗадания", НСтр("ru = 'Создание файлового начального образа'"));
			ПараметрыЗадания.Вставить("НаименованиеПроцедуры", "РаботаСФайламиСлужебный.СоздатьФайловыйНачальныйОбразНаСервере");
		Иначе
			// Серверный начальный образ.
			СтрокаСоединения =
				"Srvr="""       + Сервер + """;"
				+ "Ref="""      + ИмяБазы + """;"
				+ "DBMS="""     + ТипСУБД + """;"
				+ "DBSrvr="""   + СерверБазыДанных + """;"
				+ "DB="""       + ИмяБазыДанных + """;"
				+ "DBUID="""    + ПользовательБазыДанных + """;"
				+ "DBPwd="""    + ПарольПользователя + """;"
				+ "SQLYOffs=""" + Формат(СмещениеДат, "ЧГ=") + """;"
				+ "Locale="""   + Язык + """;"
				+ "SchJobDn=""" + ?(УстановитьБлокировкуРегламентныхЗаданий, "Y", "N") + """;";
			
			ПараметрыЗадания.Вставить("СтрокаСоединения", СтрокаСоединения);
			ПараметрыЗадания.Вставить("НаименованиеЗадания", НСтр("ru = 'Создание серверного начального образа'"));
			ПараметрыЗадания.Вставить("НаименованиеПроцедуры", "РаботаСФайламиСлужебный.СоздатьСерверныйНачальныйОбразНаСервере");
		КонецЕсли;
		Результат = ПодготовитьДанныеДляСозданияНачальногоОбраза(ПараметрыЗадания, ВидБазы);
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Если Результат.ДанныеПодготовлены Тогда
				АдресПараметровЗадания = ПоместитьВоВременноеХранилище(ПараметрыЗадания, УникальныйИдентификатор);
				ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьСозданиеНачальногоОбраза", ЭтотОбъект);
				Если Результат.ТребуетсяПодтверждение Тогда
					ПоказатьВопрос(ОписаниеОповещения, Результат.ТекстВопроса, РежимДиалогаВопрос.ДаНет);
				Иначе
					ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверкаСуществованияПолноеИмяФайловойБазыЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	Если Не Существует Тогда
		Оповещение = Новый ОписаниеОповещения("СозданиеКаталогаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьСозданиеКаталога(Оповещение, ДополнительныеПараметры.ПолныйПуть);
		Возврат;
	КонецЕсли;
	
	ПродолжитьПроверкуСуществованияПолноеИмяФайловойБазы(ДополнительныеПараметры.ПолныйПуть,
		ДополнительныеПараметры.МассивКаталогов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьПроверкуСуществованияПолноеИмяФайловойБазы(ПолныйПуть, МассивКаталогов)
	Если МассивКаталогов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Новый Файл(ПолныйПуть + ПолучитьРазделительПути() + МассивКаталогов[0]);
			
	ТекущийМассив = Новый Массив;
	ТекущийМассив.Добавить(МассивКаталогов[0]);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ПолныйПуть", Файл.ПолноеИмя);
	ПараметрыОповещения.Вставить("МассивКаталогов",
		ОбщегоНазначенияКлиентСервер.РазностьМассивов(МассивКаталогов, ТекущийМассив));
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаСуществованияПолноеИмяФайловойБазыЗавершение", ЭтотОбъект, ПараметрыОповещения);
	Файл.НачатьПроверкуСуществования(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура СозданиеКаталогаЗавершение(ИмяКаталога, ДополнительныеПараметры) Экспорт
	
	ПродолжитьПроверкуСуществованияПолноеИмяФайловойБазы(ИмяКаталога, ДополнительныеПараметры.МассивКаталогов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСохраненияФайла(
		Элемент,
		ИмяСвойства,
		СтандартнаяОбработка,
		ИмяФайла,
		Фильтр = "")
	
	СтандартнаяОбработка = Ложь;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Элемент",     Элемент);
	Контекст.Вставить("ИмяСвойства", ИмяСвойства);
	Контекст.Вставить("ИмяФайла",    ИмяФайла);
	Контекст.Вставить("Фильтр",      Фильтр);
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения'");
	Диалог.МножественныйВыбор = Ложь;
	Диалог.ПредварительныйПросмотр = Ложь;
	Диалог.Фильтр = Контекст.Фильтр;
	Диалог.ПолноеИмяФайла =
		?(ЭтотОбъект[Контекст.ИмяСвойства] = "",
			Контекст.ИмяФайла,
			ЭтотОбъект[Контекст.ИмяСвойства]);
	
	ОписаниеОповещенияДиалогаВыбора = Новый ОписаниеОповещения(
		"ОбработчикСохраненияФайлаПослеВыбораВДиалоге", ЭтотОбъект, Контекст);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещенияДиалогаВыбора, Диалог);
	
КонецПроцедуры

// Параметры:
//   ВыбранныеФайлы - Массив, Неопределено -.
//   Контекст - Структура - .
//
&НаКлиенте
Процедура ОбработчикСохраненияФайлаПослеВыбораВДиалоге(ВыбранныеФайлы, Контекст) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() = 1 Тогда
		
		ЭтотОбъект[Контекст.ИмяСвойства] = ВыбранныеФайлы[0];
		Если Контекст.Элемент = Элементы.ПолноеИмяФайловойБазы Тогда
			ПолноеИмяФайловойБазыПриИзменении(Контекст.Элемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьДанныеДляСозданияНачальногоОбраза(ПараметрыЗадания, ВидБазы)
	
	// Запись параметров подключения узла в константу.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		
		Отказ = Ложь;
		
		ПомощникСозданияОбменаДанными = Обработки["ПомощникСозданияОбменаДанными"].Создать();
		ПомощникСозданияОбменаДанными.Инициализация(ПараметрыЗадания.Узел);
		
		Попытка
			Обработки["ПомощникСозданияОбменаДанными"].ВыгрузитьНастройкиПодключенияДляПодчиненногоУзлаРИБ(
				ПомощникСозданияОбменаДанными);
		Исключение
			Отказ = Истина;
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если Отказ Тогда
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидБазы = 0 Тогда
		// Файловый начальный образ.
		// Функция обработки, проверки и подготовки параметров.
		Результат = РаботаСФайламиСлужебный.ПодготовитьДанныеДляСозданияФайловогоНачальногоОбраза(ПараметрыЗадания);
	Иначе
		// Серверный начальный образ.
		// Функция обработки, проверки и подготовки параметров.
		Результат = РаботаСФайламиСлужебный.ПодготовитьДанныеДляСозданияСерверногоНачальногоОбраза(ПараметрыЗадания);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьСозданиеНачальногоОбраза(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПроцентВыполнения = 0;
		ДопИнформацияВыполнение = "";
		ПерейтиКСтраницеОжидания();
		ПодключитьОбработчикОжидания("ЗапуститьСозданиеНачальногоОбраза", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьСозданиеНачальногоОбраза()
	
	Результат = СоздатьНачальныйОбразНаСервере(ВидБазы);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполняется" Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("СоздатьНачальныйОбразНаСервереЗавершение", ЭтотОбъект);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("СоздатьНачальныйОбразНаСервереПрогресс", ЭтотОбъект);;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ПерейтиКСтраницеОжидания();
		ПроцентВыполнения = 100;
		ДопИнформацияВыполнение = "";
		// Переход к странице с результатом с задержкой в 1 сек.
		ПодключитьОбработчикОжидания("ЗапуститьПереходРезультат", 1, Истина);
	Иначе
		ВызватьИсключение НСтр("ru = 'Не удалось создать начальный образ по причине:'") + " " + Результат.КраткоеПредставлениеОшибки; 
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтраницеОжидания()
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ОжиданиеСозданияНачальногоОбраза;
	Элементы.СоздатьНачальныйОбраз.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Функция СоздатьНачальныйОбразНаСервере(Знач Действие)
	
	Если ЭтоАдресВременногоХранилища(АдресПараметровЗадания) Тогда
		ПараметрыЗадания = ПолучитьИзВременногоХранилища(АдресПараметровЗадания);
		Если ТипЗнч(ПараметрыЗадания) = Тип("Структура") Тогда
			// Запуск фонового задания.
			ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
			ПараметрыВыполнения.НаименованиеФоновогоЗадания = ПараметрыЗадания.НаименованиеЗадания;
			
			Возврат ДлительныеОперации.ВыполнитьВФоне(ПараметрыЗадания.НаименованиеПроцедуры, ПараметрыЗадания, ПараметрыВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНачальныйОбразНаСервереЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ПроцентВыполнения = 0;
		ДопИнформацияВыполнение = НСтр("ru = 'Действие отменено администратором.'");
		ЗапуститьПереходРезультат();
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ПроцентВыполнения = 0;
		Элементы.СтатусГотово.Заголовок = НСтр("ru = 'Не удалось создать начальный образ по причине:'") + " " + Результат.КраткоеПредставлениеОшибки;
		ЗапуститьПереходРезультат();
		Возврат;
	КонецЕсли;
	
	ПроцентВыполнения = 100;
	ДопИнформацияВыполнение = "";
	ЗапуститьПереходРезультат();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачальныйОбразНаСервереПрогресс(Прогресс, ДополнительныеПараметры) Экспорт
	
	Если Прогресс = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Прогресс.Прогресс <> Неопределено Тогда
		СтруктураПрогресса = Прогресс.Прогресс;
		ПроцентВыполнения = СтруктураПрогресса.Процент;
		ДопИнформацияВыполнение = СтруктураПрогресса.Текст;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьПереходРезультат()
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.Результат;
	Элементы.СоздатьНачальныйОбраз.Видимость = Ложь;
	
	Если ПроцентВыполнения = 100 Тогда
		ЗавершитьСозданиеНачальногоОбраза(Узел);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗавершитьСозданиеНачальногоОбраза(УзелОбмена)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		МодульОбменДаннымиСервер.ЗавершитьСозданиеНачальногоОбраза(УзелОбмена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
