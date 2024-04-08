
[kotlinlang.ru](https://kotlinlang.ru/)
[Основы Kotlin](https://hyperskill.org/tracks/18) от JetBrains Academy.

## Определение имени пакета и импорт

Имя пакета указывается в начале исходного файла, так же как и в Java.
Но в отличие от Java, *структура пакетов может не совпадать со структурой папок*.
(исходные файлы могут располагаться в произвольном месте на диске)
```kotlin
package my.demo

import java.util.*
// ...
```
См. [Пакеты](https://kotlinlang.ru/docs/packages.html).

## Точка входа в программу
```kotlin
fun main() {
    println("Hello world!")
}

fun main(args: Array<String>) {
    println(args.contentToString())
}
```

## Функции
```kotlin
fun sum(a: Int, b: Int): Int {   // принимает два аргумента `Int` и возвращает `Int`.
    return a + b
}
fun sum(a: Int, b: Int) = a + b

fun printSum(a: Int, b: Int): Unit {   // не возвращает никакого значения (`void` в Java).
    println("сумма $a и $b равна ${a + b}")
}
fun printSum(a: Int, b: Int) {
    println("сумма $a и $b равна ${a + b}")
}
```
См. [Функции](https://kotlinlang.ru/docs/functions.html).

## Переменные

Неизменяемые (только для чтения) локальные переменные определяются с помощью ключевого слова `val`. Присвоить им значение можно только один раз.

```kotlin
val a: Int = 1   // Инициализация при объявлении
val b = 1        // Тип `Int` определен автоматически
val c: Int       // Указывать тип обязательно, если переменная не инициализирована сразу
c = 1            // Последующее присвоение
```

Изменяемые переменные объявляются с помощью ключевого слова `var`.

```kotlin
var x = 5 // Тип `Int` определен автоматически
x += 1
```

Вы можете объявлять глобальные переменные.

```kotlin
val PI = 3.14
var x = 0

fun incrementX() { 
    x += 1 
}
```

См. [Свойства и поля](https://kotlinlang.ru/docs/properties.html).

## Создание классов и экземпляров

Для создания класса используйте ключевое слово `class`.

```kotlin
class Shape
```

Свойства класса могут быть перечислены при его объявлении или в его теле.

```kotlin
class Rectangle(var height: Double, var length: Double) {
    var perimeter = (height + length) * 2 
}
```

Конструктор по умолчанию с параметрами, перечисленными при объявлении класса, доступен автоматически.

```kotlin
val rectangle = Rectangle(5.0, 2.0)
println("Периметр равен ${rectangle.perimeter}")
```

Чтобы объявить наследование между классами используйте двоеточие (`:`). По умолчанию классы являются финальными, поэтому, чтобы сделать класс наследуемым, используйте `open`.

```kotlin
open class Shape

class Rectangle(var height: Double, var length: Double): Shape() {
    var perimeter = (height + length) * 2 
}
```

См. [Классы и наследование](https://kotlinlang.ru/docs/classes.html) и [Объекты и экземпляры](https://kotlinlang.ru/docs/object-declarations.html).

## Комментарии

Также, как любой другой популярный современный язык, Kotlin поддерживает однострочные и многострочные (блочные) комментарии.

```kotlin
// Это однострочный комментарий

/* Это блочный комментарий
   из нескольких строк. */
```

Блочные комментарии в Kotlin могут быть вложенными.

```kotlin
/* Этот комментарий начинается здесь
/* содержит вложенный комментарий */
и заканчивается здесь. */
```

См. [Документация Kotlin кода](https://kotlinlang.ru/docs/kotlin-doc.html) для информации о документации в комментариях.

## Строковые шаблоны

Допустимо использование переменных внутри строк в формате `$name` или `${name}`:

```kotlin
fun main(args: Array<String>) {
  if (args.size == 0) return

  print("Первый аргумент: ${args[0]}")
}
```

```kotlin
var a = 1
// просто имя переменной в шаблоне:
val s1 = "a равно $a" 

a = 2
// произвольное выражение в шаблоне:
val s2 = "${s1.replace("равно", "было равно")}, но теперь равно $a"

/*
  Результат работы программы:
  a было равно 1, но теперь равно 2
*/
```

См. [Строковые шаблоны](https://kotlinlang.ru/docs/basic-types.html#string-templates).

## Условные выражения

```kotlin
fun maxOf(a: Int, b: Int): Int {
    if (a > b) {
        return a
    } else {
        return b
    }
}
```

В Kotlin `if` может быть использован как выражение (т. е. `if` ... `else` возвращает значение):

```kotlin
fun maxOf(a: Int, b: Int) = if (a > b) a else b
```

См. [Выражение `if`](https://kotlinlang.ru/docs/control-flow.html#if-expression).

## Цикл for

```kotlin
val items = listOf("яблоко", "банан", "киви")
for (item in items) {
    println(item)
}
```

или

```kotlin
val items = listOf("яблоко", "банан", "киви")
for (index in items.indices) {
    println("${index} фрукт - это ${items[index]}")
}
```

См. [Цикл for](https://kotlinlang.ru/docs/control-flow.html#for-loops).

## Цикл while

```kotlin
val items = listOf("яблоко", "банан", "киви")
var index = 0
while (index < items.size) {
    println("${index} фрукт - это ${items[index]}")
    index++
}
```

См. [Цикл while](https://kotlinlang.ru/docs/control-flow.html#while-loops).

## Выражение when

```kotlin
fun describe(obj: Any): String =
    when (obj) {
        1          -> "Один"
        "Hello"    -> "Приветствие"
        is Long    -> "Long"
        !is String -> "Не строка"
        else       -> "Unknown"
    }
```

См. [Выражение when](https://kotlinlang.ru/docs/control-flow.html#when-expression).

## Интервалы

Проверка на вхождение числа в интервал с помощью оператора `in`.

```kotlin
val x = 10
val y = 9
if (x in 1..y+1) {
    println("принадлежит диапазону")
}
```

Проверка значения на выход за пределы интервала.

```kotlin
val list = listOf("a", "b", "c")

if (-1 !in 0..list.lastIndex) {
    println("-1 не принадлежит диапазону")
}
if (list.size !in list.indices) {
    println("размер списка также выходит за допустимый диапазон индексов списка")
}
```

Перебор значений в заданном интервале.

```kotlin
for (x in 1..5) {
    print(x)
}
```

Или по арифметической прогрессии.

```kotlin
for (x in 1..10 step 2) {
    print(x)
}
println()
for (x in 9 downTo 0 step 3) {
    print(x)
}
```

См. [Интервалы](https://kotlinlang.ru/docs/ranges.html).

## Коллекции

Итерация по коллекции.

```kotlin
for (item in items) {
    println(item)
}
```

Проверка, содержит ли коллекция данный объект, с помощью оператора `in`.

```kotlin
val items = setOf("яблоко", "банан", "киви")
when {
    "апельсин" in items -> println("сочно")
    "apple" in items -> println("яблоко тоже подойдет")
}
```

Использование лямбда-выражения для фильтрации и модификации коллекции.

```kotlin
val fruits = listOf("банан", "авокадо", "яблоко", "киви")
fruits
    .filter { it.startsWith("а") }
    .sortedBy { it }
    .map { it.uppercase() }
    .forEach { println(it) }
```

См. [Коллекции](https://kotlinlang.ru/docs/collections-overview.html).

## Nullable-значения и проверка на null

Ссылка должна быть явно объявлена как nullable (символ `?` в конце имени), когда она может принимать значение `null`.

Возвращает `null`, если `str` не содержит числа.

```kotlin
fun parseInt(str: String): Int? {
  // ...
}
```

Использование функции, возвращающей `null`.

```kotlin
fun printProduct(arg1: String, arg2: String) {
    val x = parseInt(arg1)
    val y = parseInt(arg2)
    
    // Использование `x * y` приведет к ошибке, потому что они могут содержать null
    if (x != null && y != null) {
        // x и y автоматически приведены к не-nullable после проверки на null
    print(x * y)
    }
    else {
        println("'$arg1' или '$arg2' не число")
    }
}
```

или

```kotlin
// ...
if (x == null) {
    print("Неверный формат числа arg1: '$arg1'")
    return
}
if (y == null) {
    print("Неверный формат числа arg2: '$arg2'")
    return
}

// x и y автоматически приведены к не-nullable после проверки на null
  print(x * y)
```

См. [Null-безопасность](https://kotlinlang.ru/docs/null-safety.html).

## Проверка типа и автоматическое приведение типов

Оператор `is` проверяет, является ли выражение экземпляром заданного типа. Если неизменяемая локальная переменная или свойство уже проверены на определенный тип, то в дальнейшем нет необходимости явно приводить к этому типу:

```kotlin
fun getStringLength(obj: Any): Int? {
    if (obj is String) {
        // в этом блоке `obj` автоматически преобразован в `String`
        return obj.length
    }

    // `obj` имеет тип `Any` вне блока проверки типа
    return null
}
```

или

```kotlin
fun getStringLength(obj: Any): Int? {
    if (obj !is String) return null

    // в этом блоке `obj` автоматически преобразован в `String`
    return obj.length
}
```

или даже

```kotlin
fun getStringLength(obj: Any): Int? {
    // `obj` автоматически преобразован в `String` справа от оператора `&&`
    if (obj is String && obj.length > 0) {
        return obj.length
    }

    return null
}
```

См. [Классы](https://kotlinlang.ru/docs/classes.html) и [Приведение типов](https://kotlinlang.ru/docs/typecasts.html).