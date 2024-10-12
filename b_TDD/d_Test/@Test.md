# `@Test (org.junit.Test)`aтрибуты в аннотации :

1. **`expected`**: Указывает, что тест должен выбросить указанное исключение. 
	Пример: `@Test(expected = SomeException::class)`.
    
2. **`timeout`**: Определяет максимальное время выполнения теста в миллисекундах. Если тест не завершится в течение указанного времени, он будет считаться неудачным. 
	Пример: `@Test(timeout = 1000)`.
    
3. **`timeoutMethod`**: Позволяет указать метод, который будет использоваться для определения времени выполнения теста. Метод должен возвращать значение в миллисекундах. 
	Пример: `@Test(timeoutMethod = "calculateTimeout")`.
    
4. **`displayName`**: Позволяет установить пользовательское имя теста, которое будет отображаться при выполнении. 
	Пример: `@Test(displayName = "Custom Test Name")`.
    
5. **`disabled`**: Позволяет отключить выполнение теста. 
	Пример: `@Test(disabled = true)`.
    
6. **`repeatedTest`**: Позволяет указать, что тест должен быть выполнен несколько раз. 
	Пример: `@RepeatedTest(value = 5)`.
    
7. **`repetitionName`**: Позволяет задать пользовательское имя для повторяемого теста. 
	Пример: `@RepeatedTest(value = 5, name = "Test {currentRepetition}")`.
    
8. **`repetitionInfo`**: Позволяет получить информацию о текущем повторении теста. 
	Пример: `@RepeatedTest(value = 5) fun testMethod(repetitionInfo: RepetitionInfo)`.


# @Before (org.junit.Before)

`import org.junit.Before`
Аннотация `@Before` в JUnit 5 указывает на метод, который будет выполнен перед каждым тестовым методом.
или `import org.junit.jupiter.api.BeforeEach;`
##### [Multiple @Before vs. one @Before split up into methods](https://stackoverflow.com/questions/9131071/junit-multiple-before-vs-one-before-split-up-into-methods)
- Методы с анотацией @Before [выполняются в алфавитном порядке](https://stackoverflow.com/a/53582236) 
- Можно разместить несколько методов в один @Before:
```kotlin
private fun setUpClientStub() {
     //whatever you want to do
}

private fun setUpObjectUnderTest() {
    //whatever you want to do
}

@Before
fun setUp() {
    setUpClientStub()
    setUpObjectUnderTest()
}

@Test
fun test() {
   //your test logic
}
```

# Тестируем Корутины

```kotlin
import kotlinx.coroutines.test.TestCoroutineDispatcher
import kotlinx.coroutines.test.runBlockingTest
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals

class MyCoroutineTest {

    private val testDispatcher = TestCoroutineDispatcher()

    @Test
    fun `myCoroutineFunction should return expected result`() = testDispatcher.runBlockingTest {
        val result = myCoroutineFunction()

        assertEquals("Expected Result", result)
    }

    // Ваша функция, использующая корутины
    private suspend fun myCoroutineFunction(): String {
        // Пример асинхронной работы в корутинах
        return "Expected Result"
    }
}
```

Чтобы использовать `runTest`, вам нужно находиться в контексте `TestCoroutineScope` (как правило, это предоставляется с использованием `runBlockingTest` или других тестовых средств из `kotlinx-coroutines-test`). Вот пример использования:

```kotlin
import kotlinx.coroutines.test.TestCoroutineScope
import kotlinx.coroutines.test.runBlockingTest
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals

class MyCoroutineTest {

    @Test
    fun `myCoroutineFunction should return expected result`() = runBlockingTest {
        val result = runTest {
            // Ваша тестовая логика с корутинами
            myCoroutineFunction()
        }

        assertEquals("Expected Result", result)
    }

    // Ваша функция, использующая корутины
    private suspend fun myCoroutineFunction(): String {
        // Пример асинхронной работы в корутинах
        return "Expected Result"
    }
}
```

Здесь `runTest` принимает блок кода, который содержит вашу тестовую логику с использованием корутин, и запускает его в контексте `TestCoroutineScope`, обеспечивая возможность управлять выполнением корутин в тестовом окружении.