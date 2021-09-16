///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция СправочникиФайловИОбъектыХранения() Экспорт
	
	СправочникиФайлов = Новый Соответствие();
	ОбъектыХраненияВИнформационнойБазе = Новый Соответствие();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		
		Обработчик = "РаботаСФайламиСлужебный";
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль(Обработчик);
		Если ОбщийМодуль <> Неопределено Тогда
			
			СправочникиФайловОбработчика = ОбщийМодуль.СправочникиФайлов();
			Для Каждого СправочникФайловОбработчика Из СправочникиФайловОбработчика Цикл
				СправочникиФайлов.Вставить(СправочникФайловОбработчика.ПолноеИмя(), Обработчик);
			КонецЦикла;
			
			ОбъектыХраненияОбработчика = ОбщийМодуль.ОбъектыХраненияФайловИнформационнойБазе();
			Для Каждого ОбъектХраненияОбработчика Из ОбъектыХраненияОбработчика Цикл
				ОбъектыХраненияВИнформационнойБазе.Вставить(ОбъектХраненияОбработчика.ПолноеИмя(), Обработчик);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Кэш = Новый Структура("СправочникиФайлов, ОбъектыХранения", СправочникиФайлов, ОбъектыХраненияВИнформационнойБазе);
	
	Возврат Кэш;
	
КонецФункции

#КонецОбласти