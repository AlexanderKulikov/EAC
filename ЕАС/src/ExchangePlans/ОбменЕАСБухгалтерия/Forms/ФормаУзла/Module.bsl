#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.ЭтотУзел Тогда
		Элементы.Организации.Видимость 						= Ложь;
		Элементы.ИспользоватьОтборПоОрганизациям.Видимость 	= Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	Перем ТекстСообщения, ВерсияРасширения;     
	
	ПроверитьПодключениеНаСервере(ТекстСообщения, ВерсияРасширения);
	
	Если ТекстСообщения <> Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли ВерсияРасширения = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Версия расширения клиента не определена. Обратитесь к администратору.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе	
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Успешно. Версия расширения %1'"), ВерсияРасширения);
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;	         
	
КонецПроцедуры    

&НаСервере
Процедура ПроверитьПодключениеНаСервере(ТекстСообщения, ВерсияРасширения)
	
	СтруктураЗапроса = Новый Структура;
	СтруктураЗапроса.Вставить("ВебАдрес",    Объект.ВебАдрес);
	СтруктураЗапроса.Вставить("Запрос",      "version");
	СтруктураЗапроса.Вставить("ContentType", "text");
	СтруктураЗапроса.Вставить("Логин",       Объект.Логин);
	СтруктураЗапроса.Вставить("Пароль",      Объект.Пароль);
	СтруктураЗапроса.Вставить("Метод",       "get");
	
	ВерсияРасширения = ЕАС_ОбработкаfHTTPСервиса.HTTPЗапросВыполнить(СтруктураЗапроса, ТекстСообщения);
	
КонецПроцедуры    

&НаКлиенте
Процедура СинхронизацияДанных(Команда)
	Перем ТекстСообщения;
	ОтправитьПолучитьДанныеНаСервере(ТекстСообщения);          
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;	
	Прочитать();
КонецПроцедуры

&НаСервере
Процедура ОтправитьПолучитьДанныеНаСервере(ТекстОшибки)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Протокол = Новый ТекстовыйДокумент;
	СтруктураПротокол = ЕАС_ПротоколированиеКопируемый.НачатьФормированиеПротокола(Перечисления.ЕАС_ВидыПротоколовОбмена.Вручную, Протокол);
	
	Попытка
		Тело = ЕАС_ОбменВызовСервераКопируемый.СформироватьXMLСообщениеЕАС(Объект, ТекстОшибки, СтруктураПротокол);
		Если ТекстОшибки <> Неопределено Тогда
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;	                               
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("Тело",     	 Тело);     
		
		СтруктураЗапроса = Новый Структура;
		СтруктураЗапроса.Вставить("ВебАдрес",    Объект.ВебАдрес);
		СтруктураЗапроса.Вставить("Запрос",      "changes");
		СтруктураЗапроса.Вставить("ContentType", "xml");
		СтруктураЗапроса.Вставить("Логин",       Объект.Логин);
		СтруктураЗапроса.Вставить("Пароль",      Объект.Пароль);
		СтруктураЗапроса.Вставить("Метод",       "post");
		СтруктураЗапроса.Вставить("Параметры",   ПараметрыЗапроса);
		
		ТекстПротокол = НСтр("ru = 'Формирование и отправка HTTP запроса.'");
		ЕАС_ПротоколированиеКопируемый.СообщениеВПротокол(СтруктураПротокол, ТекстПротокол, 1);  								
		
		ДанныеXML = ЕАС_ОбработкаfHTTPСервиса.HTTPЗапросВыполнить(СтруктураЗапроса, ТекстОшибки);
		Если ТекстОшибки <> Неопределено Тогда
			ВызватьИсключение ТекстОшибки;
		ИначеЕсли ДанныеXML = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Версия расширения клиента не определена. Обратитесь к администратору.'");
			ВызватьИсключение ТекстОшибки;
		Иначе	
			ТекстПротокол = НСтр("ru = 'Отправка и получение данных по HTTP завершена.'");
			ЕАС_ПротоколированиеКопируемый.СообщениеВПротокол(СтруктураПротокол, ТекстПротокол, 1);  								
		КонецЕсли;	         
		
		ЕАС_ОбменВызовСервераКопируемый.ПрочитатьXMLСообщениеЕАС(ДанныеXML, ТекстОшибки, СтруктураПротокол);
		Если ТекстОшибки <> Неопределено Тогда
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;	
		
		ТекстПротокол = НСтр("ru = 'Процедура обмена по команде вручную успешно завершена.'");
		ЕАС_ПротоколированиеКопируемый.СообщениеВПротокол(СтруктураПротокол, ТекстПротокол, 1);
		ЕАС_ПротоколированиеКопируемый.ЗакончитьФормированиеПротокола(СтруктураПротокол);
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка процедуры обмена %1. Смотрите протокол обмена.'"), ОписаниеОшибки());
		ЕАС_ПротоколированиеКопируемый.СообщениеВПротокол(СтруктураПротокол, ТекстОшибки, 1, Истина);
		ЕАС_ПротоколированиеКопируемый.ЗакончитьФормированиеПротокола(СтруктураПротокол);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимость()      
	Элементы.Организации.Видимость = Не Объект.ЭтотУзел И Объект.ИспользоватьОтборПоОрганизациям;
	Элементы.ГруппаКорреспондент.Видимость 		  = Не Объект.ЭтотУзел;
	Элементы.ОбластьДанных.Видимость       		  = Не Объект.ЭтотУзел;
	Элементы.ГруппаПараметрыСоединения.Видимость  = Не Объект.ЭтотУзел;
КонецПроцедуры	

&НаСервере
Процедура НачальнаяРегистрацияНаСервере()
	НачатьТранзакцию();
	Попытка
		ПланыОбмена.ЗарегистрироватьИзменения(Объект.Ссылка, Неопределено);
		УзелОбъект = Объект.Ссылка.ПолучитьОбъект();
		УзелОбъект.НомерОтправленного = 0;
		УзелОбъект.НомерПринятого = 0;
		УзелОбъект.Записать();
		ЗафиксироватьТранзакцию();
	Исключение	
		ОтменитьТранзакцию();
		ТекстОшибки = ОписаниеОшибки();
		ВызватьИсключение(ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура НачальнаяРегистрация(Команда)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru='Начальная регистрация производится ТОЛЬКО при первом запуске узла корреспондента. Продолжать?'");
		ДопПараметры = Новый Структура;
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеВопросаНачальнойРегистрации", ЭтаФорма, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, 10, КодВозвратаДиалога.Нет);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='Требуется записать данный узел обмена'"));    
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВопросаНачальнойРегистрации(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачальнаяРегистрацияНаСервере();
		Прочитать();
		ПоказатьПредупреждение(, НСтр("ru='Готоао'"));    
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти
