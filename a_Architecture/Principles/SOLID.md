[источник1](https://javarush.ru/groups/posts/osnovnye-principy-dizajna-klassov-solid-v-java)
[источник2](https://javarush.ru/groups/posts/3650-principih-solid-kotorihe-sdelajut-kod-chijshe)

## Eдинственная ответственность (SRP) - Single-responsiblity Principle.
`Никогда не должно быть больше одной причины изменить класс.`

## Принцип открытости/закрытости (OCP) - Open-closed Principle.
`Программные сущности (классы, модули, функции и т.п.) должны быть открыты для расширения, но закрыты для изменения.` ПО изменяется не через изменение существующего кода, а через добавление нового. То есть созданный изначально код остаётся «нетронутым» и стабильным, а новая функциональность внедряется либо через наследование реализации, либо через использование интерфейсов и полиморфизм.
 ```kotlin
 // было
 class FileLogger{ 
	fun logError(error: String) { 
		val file = File("errors2.txt") 
		file.appendText(text = error) 
	}
 }
 
 // используем слово "open"
 // стало 
 open class FileLogger{  
 	open fun logError(error: String) { 
 		val file = File("error.txt") 
 		file.appendText(text = error) 
 	} 
 } 
 
 class CustomErrorFileLogger : FileLogger() { 
 	override fun logError(error: String) { 
 		val file = File("my_custom_error_file.txt") 
 		file.appendText(text = error) 
 	}
 }
 ```

##  Подстановка Барбары Лисков (LSP) - Liskov Substitution Principle.
 `Классы-наследники должны использоваться вместо родительских классов (напр. в конструкторе класса), не нарушая работу программы (обращения к полям класса или вызовы методов ВООБЩЕ не должны меняться. Только подменили класс и все).`

## Разделения интерфейса (ISP) - Interface Segregation Principle.
`Клиенты не должны быть вынуждены реализовывать методы, которые они не будут использовать.`
 ```kotlin
 interface FileLogger{ 
	fun printLogs() { 
		 //какая-то дефолтная реализация 
	} 
	
	fun logError(error: String) {
		val file = File("errors.txt") 
		file.appendText(text = error) 
	}
 }
 ```

## Инверсии зависимостей (DIP) - Dependency Inversion Principle.
`Объектом зависимости (напр. в конструкторе) должна быть абстракция, а не что-то конкретное.` Зависимости внутри системы строятся на основе абстракций.  Модули верхнего уровня не зависят от модулей нижнего уровня. Абстракции не должны зависеть от деталей а, детали должны зависеть от абстракций.