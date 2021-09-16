#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс
	
Функция ЗарегистрироватьЗапрос(Запрос, ТипЗапроса, ДополнительныеПараметры = Неопределено) Экспорт
	
	ИмяВременногоФайла = ПередачаДанныхСлужебный.ИмяВременногоФайла(, ДополнительныеПараметры);
	
	Если ТипЗнч(ИмяВременногоФайла) = Тип("Структура") Тогда
		Возврат ИмяВременногоФайла;
	КонецЕсли;
	
	СтруктураЗапроса = Новый Структура;
	
	СтруктураЗапроса.Вставить("HTTPМетод", Запрос.HTTPМетод);
	СтруктураЗапроса.Вставить("БазовыйURL", Запрос.БазовыйURL);
	СтруктураЗапроса.Вставить("Заголовки", ЗаголовкиБезАвторизации(Запрос.Заголовки));
	СтруктураЗапроса.Вставить("ОтносительныйURL", Запрос.ОтносительныйURL);
	СтруктураЗапроса.Вставить("ПараметрыURL", Запрос.ПараметрыURL);
	СтруктураЗапроса.Вставить("ПараметрыЗапроса", Запрос.ПараметрыЗапроса);
	СтруктураЗапроса.Вставить("ИдентификаторЗапроса", Строка(Новый УникальныйИдентификатор));
	СтруктураЗапроса.Вставить("ТипЗапроса", ТипЗапроса);
	СтруктураЗапроса.Вставить("ИмяВременногоФайла", ИмяВременногоФайла);
	СтруктураЗапроса.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СтруктураЗапроса);
	
	ЗапросJSON = ЗаписьJSON.Закрыть();
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХешированиеДанных.Добавить(ЗапросJSON);
	Идентификатор = НРег(СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", ""));
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Идентификатор = Идентификатор;
	МенеджерЗаписи.Дата = ТекущаяУниверсальнаяДата();
	МенеджерЗаписи.Запрос = Новый ХранилищеЗначения(ЗапросJSON);
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Записать(Ложь);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Идентификатор;
	
КонецФункции

Функция ЗапросПоИдентификатору(Идентификатор) Экспорт
	
	Запрос = Неопределено;
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Идентификатор = НРег(Идентификатор);
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Прочитать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если МенеджерЗаписи.Выбран() Тогда
		
		Если ТекущаяУниверсальнаяДата() - МенеджерЗаписи.Дата < ПередачаДанныхСлужебный.ПериодДействияВременногоИдентификатора() Тогда
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(МенеджерЗаписи.Запрос.Получить());
			Запрос = ПрочитатьJSON(ЧтениеJSON, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Запрос;
		
КонецФункции

Процедура ПродлитьДействиеВременногоИдентификатора(Идентификатор) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Идентификатор = НРег(Идентификатор);
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Прочитать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если МенеджерЗаписи.Выбран() Тогда
		
		МенеджерЗаписи.Дата = ТекущаяУниверсальнаяДата();
		
		ПередачаДанныхСлужебный.ПриПродленииДействияВременногоИдентификатора(Идентификатор, МенеджерЗаписи);
		
		УстановитьПривилегированныйРежим(Истина);
		МенеджерЗаписи.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаголовкиБезАвторизации(Заголовки)

	Если ТипЗнч(Заголовки) <> Тип("ФиксированноеСоответствие") ИЛИ ТипЗнч(Заголовки) <> Тип("Соответствие") Тогда
		Возврат Заголовки;
	КонецЕсли;
	
	Результат = Новый Соответствие();
	
	Для Каждого ЭлементКоллекции Из Заголовки Цикл
		
		ИмяЗаголовка = ЭлементКоллекции.Ключ;
		ЗначениеЗаголовка = ЭлементКоллекции.Значение;
		
		Если НРег(ИмяЗаголовка) = "authorization" Тогда
			ЭлементыАвторизации = СтрРазделить(ЗначениеЗаголовка, " ", Ложь);
			Если ЭлементыАвторизации.Количество() > 1 Тогда
				ЗначениеЗаголовка = ЭлементыАвторизации[0] + " ***";
			Иначе
				ЗначениеЗаголовка = "***";
			КонецЕсли;	
		КонецЕсли;
		
		Результат.Вставить(ИмяЗаголовка, ЗначениеЗаголовка);
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);

КонецФункции

#КонецОбласти

#КонецЕсли