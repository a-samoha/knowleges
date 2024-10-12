**assert**: проверяем условия внутри тестового кода.
`assert(mockedList.size == 42)`

Cтандартная библиотека в Kotlin предоставляет функцию `assert`, которая используется для проверки условий в тестах. Однако, когда речь идет о вариациях `assert`, стоит уточнить, что у нее нет прямых вариаций в стандартной библиотеке.

Однако, существует сторонняя библиотека `kotlin.test`, предназначенная для написания тестов в Kotlin, и она предоставляет различные функции для проверки условий. Вот некоторые из них:

- **`assertTrue` / `assertFalse`**:
`assertTrue("Message", condition)`
`assertFalse("Message", condition)`
    
- **`assertEquals` / `assertNotEquals`**:
`assertEquals("Message", expected, actual)`
`assertNotEquals("Message", expected, actual)`
    
- **`assertNull` / `assertNotNull`**:
`assertNull("Message", nullableReference)`
`assertNotNull("Message", nonNullableReference)`
    
- **`assertSame` / `assertNotSame`**:
`assertSame("Message", expected, actual)`
`assertNotSame("Message", expected, actual)`
    
- **`assertFails`**:
`assertFails("Message") {     // код, ожидающий исключение }`

