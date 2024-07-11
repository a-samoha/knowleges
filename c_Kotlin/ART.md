Android runtime ([ART](https://source.android.com/docs/core/runtime)) is a virtual machine used instead of JVM.
[Dalvik и ART](https://habr.com/ru/articles/513928/)

Heap и Stack

Когда приложение на Kotlin работает на мобильном устройстве, объекты, с которыми оно работает, хранятся в оперативной памяти (ОЗУ). Давайте рассмотрим процесс хранения объектов и управление памятью в таком приложении:

### Управление памятью в JVM

Приложения на Kotlin обычно выполняются на Java Virtual Machine (JVM) или ART в случае Android. 
Они используют механизм автоматического управления памятью - Garbage Collector (GC).

### Создание объектов

- **Heap**: Куча — область памяти, управляемая JVM или ART, используемая для хранения ОБЪЕКТОВ, созданных приложением.
- **Stack**: Стековая память используется для временного хранения **локальных переменных** и **параметров метода** (исчезают после завершения выполнения метода).

### Жизненный цикл объектов

1. **Создание**: При создании объекта оператором `new` или через конструктор, память для него выделяется в куче.
2. **Использование**: Объекты могут ссылаться друг на друга и быть частью более сложных структур данных, таких как списки, массивы или карты (maps).
3. **Удаление**: Сборщик мусора отслеживает ссылки на объекты и удаляет те О, которые больше не достижимы (напр. нет ссылок).
	- **Mark-and-Sweep**: Сборщик мусора помечает все доступные объекты и затем удаляет все немеченные.
	- **Generational Garbage Collection**: Объекты разделяются на поколения (молодые, старые), и сборка мусора проводится чаще для молодых объектов, 
	  так как они имеют более короткий жизненный цикл.

### Примеры хранения объектов в Kotlin

```kotlin
class Person(val name: String, val age: Int)

fun main(args: Array<String>) { // Параметры метода хранятся в стеке.

	val number: Int = 42 // Примитивы, являющиеся локальными переменными в методах, хранятся в стеке.
	
	val person = // Локальная переменная `person` хранится в стеке и содержит ссылку на объект в куче.
				// Объект `person` создается в куче.
				// Поля `name` и `age` также хранятся в куче в составе объекта `Person`.
				Person("John", 30)
} 
```