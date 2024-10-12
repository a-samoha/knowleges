# Идиомы

Набор различных часто используемых идиом в языке Kotlin. 
Если у вас есть любимая идиома, вы можете поделиться ею здесь. 
Для этого нужно создать pull request.

## Создание DTO (он же POJO или POCO)

```kotlin
data class Customer(val name: String, val email: String)
```

создаёт класс `Customer`, обладающий следующими возможностями:

- геттеры (и сеттеры в случае `var`) для всех свойств,
- метод `equals()`,
- метод `hashCode()`,
- метод `toString()`,
- метод `copy()`,
- методы `component1()`, `component2()`, и т.д. для всех свойств (см. [Классы данных](https://kotlinlang.ru/docs/data-classes.html))

## Значения по умолчанию для параметров функций

```kotlin
fun foo(a: Int = 0, b: String = "") { ... }
```

## Фильтрация списка

```kotlin
val positives = list.filter { x -> x > 0 }
```

Или короче:

```kotlin
val positives = list.filter { it > 0 }
```

Узнайте разницу между [фильтрацией в Java и Kotlin](https://kotlinlang.ru/docs/java-to-kotlin-idioms-strings.html#create-a-string-from-collection-items).

## Проверка наличия элемента в коллекции

```kotlin
if ("john@example.com" in emailsList) { ... }

if ("jane@example.com" !in emailsList) { ... }
```

## Форматирование строк

```kotlin
println("Name $name")
```

Узнайте разницу между [конкатенация строк в Java и Kotlin](https://kotlinlang.ru/docs/java-to-kotlin-idioms-strings.html#concatenate-strings).

## Проверка объекта на принадлежность к определённому классу

```kotlin
when (x) {
    is Foo -> ...
    is Bar -> ...
    else   -> ...
}
```

## Read-only список

```kotlin
val list = listOf("a", "b", "c")
```

## Read-only ассоциативный список (map)

```kotlin
val map = mapOf("a" to 1, "b" to 2, "c" to 3)
```

## Обращение к ассоциативному списку

```kotlin
println(map["key"])
map["key"] = value
```

# Итерация по ассоциативному списку или списку пар

```kotlin
for ((k, v) in map) {
    println("$k -> $v")
}
```

`k` и `v` могут быть любыми удобными именами, такими как `name` и `age`.

## Итерация по диапазону

```kotlin
for (i in 1..100) { ... }  // закрытый диапазон: включает 100
for (i in 1 until 100) { ... } // полуоткрытый диапазон: не включает 100
for (x in 2..10 step 2) { ... }
for (x in 10 downTo 1) { ... }
(1..10).forEach { ... }
```

## Ленивые свойства

```kotlin
val p: String by lazy {
    // compute the string
}
```

## Функции-расширения

```kotlin
fun String.spaceToCamelCase() { ... }

"Convert this to camelcase".spaceToCamelCase()
```

## Создание синглтона

```kotlin
object Resource {
    val name = "Name"
}
```

## Создание экземпляра абстрактного класса

```kotlin
abstract class MyAbstractClass {
    abstract fun doSomething()
    abstract fun sleep()
}

fun main() {
    val myObject = object : MyAbstractClass() {
        override fun doSomething() {
            // ...
        }

        override fun sleep() { // ...
        }
    }
    myObject.doSomething()
}
```

## Сокращение для "Если не null"

```kotlin
val files = File("Test").listFiles()

println(files?.size) // размер выводится, если размер файлов не равен null
```

## Сокращение для "Если не null, иначе"

```kotlin
val files = File("Test").listFiles()

println(files?.size ?: "empty") // если файл равен null, выводится "empty"

// Чтобы вычислить резервное значение в блоке кода, используйте команду `run`
val filesSize = files?.size ?: run { 
    return someSize 
}
println(filesSize)
```

## Выброс исключения при равенстве null

```kotlin
val values = ...
val email = values["email"] ?: throw IllegalStateException("Email is missing!")
```

## Получение первого элемента, возможно, пустой коллекции

```kotlin
val emails = ... // может быть пустой
val mainEmail = emails.firstOrNull() ?: ""
```

Узнайте разницу между [получения первого элемента в Java и Kotlin](https://kotlinlang.ru/docs/java-to-kotlin-collections-guide.html#get-the-first-and-the-last-items-of-a-possibly-empty-collection).

## Выполнение при неравенстве null

```kotlin
val value = ...

value?.let {
    ... // этот блок выполняется, если value не равен null
}
```

## Маппинг nullable значение при неравенстве null

```kotlin
val value = ...

val mapped = value?.let { transformValue(it) } ?: defaultValue 
// возвращается defaultValue, если значение или результат преобразования равны null
```

## Return с оператором when

```kotlin
fun transform(color: String): Int {
    return when (color) {
        "Red" -> 0
        "Green" -> 1
        "Blue" -> 2
        else -> throw IllegalArgumentException("Invalid color param value")
    }
}
```

## Выражение try-catch

```kotlin
fun test() {
    val result = try {
        count()
    } catch (e: ArithmeticException) {
        throw IllegalStateException(e)
    }

    // Working with result
}
```

## Выражение if

```kotlin
val y = if (x == 1) {
    "one"
} else if (x == 2) {
    "two"
} else {
    "other"
}
```

## Builder-style использование методов, возвращающих Unit

```kotlin
fun arrayOfMinusOnes(size: Int): IntArray {
    return IntArray(size).apply { fill(-1) }
}
```

## Функции, состоящие из одного выражения

```kotlin
fun theAnswer() = 42
```

Что равносильно этому:

```kotlin
fun theAnswer(): Int {
    return 42
}
```

Для сокращения кода их можно эффективно совмещать с другими идиомами. Например, с `when`:

```kotlin
fun transform(color: String): Int = when (color) {
    "Red" -> 0
    "Green" -> 1
    "Blue" -> 2
    else -> throw IllegalArgumentException("Invalid color param value")
}
```

## Вызов нескольких методов объекта (with)

```kotlin
class Turtle {
    fun penDown()
    fun penUp()
    fun turn(degrees: Double)
    fun forward(pixels: Double)
}

val myTurtle = Turtle()
with(myTurtle) { // нарисует квадрат размером 100 pix
    penDown()
    for (i in 1..4) {
        forward(100.0)
        turn(90.0)
    }
    penUp()
}
```

## Конфигурация свойств объекта (apply)

```kotlin
val myRectangle = Rectangle().apply {
    length = 4
    breadth = 5
    color = 0xFAFAFA
}
```

Это полезно для конфигурации свойств, которых нет в конструкторе объектов.

## try-with-resources из Java 7

```kotlin
val stream = Files.newInputStream(Paths.get("/some/file.txt"))
stream.buffered().reader().use { reader ->
    println(reader.readText())
}
```

# Обобщённая функция, требующая информацию об обобщённом типе

```kotlin
//  public final class Gson {
//     ...
//     public <T> T fromJson(JsonElement json, Class<T> classOfT) throws JsonSyntaxException {
//     ...

inline fun <reified T: Any> Gson.fromJson(json: JsonElement): T = this.fromJson(json, T::class.java)
```

## Nullable Boolean

```kotlin
val b: Boolean? = ...
if (b == true) {
    ...
} else {
    // `b` is false or null
}
```

# Обмен значений переменных

```kotlin
var a = 1
var b = 2
a = b.also { b = a }
```

## Обозначение кода как незаконченного (TODO)

В стандартной библиотеке Kotlin есть функция `TODO()`, которая всегда выдает ошибку `NotImplementedError`. Её возвращаемый тип - `Nothing`, поэтому её можно использовать независимо от ожидаемого типа. Существует также перегрузка этой функции, которая принимает параметр причины.

```kotlin
fun calcTaxes(): BigDecimal = TODO("Waiting for feedback from accounting")
```

Плагин от IntelliJ IDEA понимает семантику `TODO()` и автоматически добавляет указатель кода в окно инструмента TODO.

## Что дальше?

- Решайте [Advent of Code puzzles](https://kotlinlang.ru/docs/advent-of-code.html), используя идиоматический стиль;
- Узнайте, как решать [типичные задачи со строками в Java и Kotlin](https://kotlinlang.ru/docs/java-to-kotlin-idioms-strings.html).