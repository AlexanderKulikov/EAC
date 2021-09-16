
#Область СлужебныйПрограммныйИнтерфейс

Функция КорневоеСобытие() Экспорт
    
    КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Универсальная интеграция'", КодЯзыка);
	
КонецФункции

Функция НеЗаполненИдентификаторПравила() Экспорт
	
	Возврат НСтр("ru = 'Не заполнен идентификатор правила.'") 
	
КонецФункции

Функция НеЗаполненКлючОбъекта() Экспорт
	
	Возврат НСтр("ru = 'Не заполнен ключ объекта.'") 
	
КонецФункции

Функция ОперацияНеМожетБытьВыполненаВРазделенномСеансе() Экспорт
	
	Возврат НСтр("ru = 'Операция не может быть вызвана в сеансе, который запущен с указанием разделителей.'");
	
КонецФункции

Функция ОперацияНеМожетБытьВыполненаВБазеСОтключеннымРазделением() Экспорт
	
	Возврат НСтр("ru = 'Операция не может быть выполнена для информационной базы с отключенным разделением по областям данных.'");
	
КонецФункции

Функция НомерОбластиДолженСодержатьТолькоЦифры() Экспорт
	
	Возврат НСтр("ru = 'Номер области должен содержать только цифры.'") 
	
КонецФункции

Функция ОшибкаПриОтправкеПодпискиНаОповещениеОбИзменении() Экспорт
	
    Возврат НСтр("ru = 'Ошибка ''%1'' при отправке подписки на оповещение об изменении объекта по правилу ''%2'' с идентификатором ''%3'':
                      |%4'");
	
КонецФункции
 
#КонецОбласти 