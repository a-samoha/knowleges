
[MockK Guidebook](https://notwoods.github.io/mockk-guidebook/)
[MocKK official](https://mockk.io/)

MockK - это библиотека для создания макетов (mocks), стабов и заглушек в тестах на языке Kotlin.

**mockkObject()** : Создание Синглтона (object)
```kotlin
object MySingleton {
    fun doSomething(): String {
        return "Real implementation"
    }
}

// Создаем макет для объекта MySingleton
mockkObject(MySingleton)

// Теперь мы можем переопределить поведение вызовов методов объекта
every { MySingleton.doSomething() } returns "Mocked implementation"

// Тестируем код, который использует MySingleton
println(MySingleton.doSomething()) // Вывод: Mocked implementation

// Проверяем вызов метода
verify { MySingleton.doSomething() }
```

**mockkConstructor() и unmockkConstructor()**: 
		Создание макетов когда MockK встраивается в конструктор класса
		Когда где-то в коде создается новый объект `MyClass`, его конструктор будет заменен макетом
		Позволяет макетировать в одном месте все экземпляры (не писать по 100 раз every{})
`mockkConstructor(MyClass::class)`
`every { anyConstructed<MyClass>().myMethod() } returns "mocked"`
`unmockkConstructor(MyClass::class)`

**mockk()**: Создание макетов (mock) объектов.
	`val customMock = mockk<SomeClass> {
	    `every { someMethod() } returns "custom"`
	`}`
	`val mockedList = mockk<MutableList<String>>()` 
			Создаст список, но если вызывать методы этого списка - будут падать ошибки
	`val relaxedMock = mockk<SomeClass>(relaxed = true)` или
	`val relaxedMock = relaxedMockk<MyClass>()`
			Указывает, что создаваемый макет будет **расслабленным (relaxed)**, 
			Это означает, что он будет автоматически возвращать значения по умолчанию для всех вызовов методов (все методы будут успешно выполнятся), если для них не определены явные действия.
	`val mockWithAnswer = mockk<SomeClass>(answer = { "custom answer" })`
			Установливает функцию ответа для всех вызовов методов макета.
	`val mockWithAsyncAnswer = mockk<SomeClass>(coAnswers = { "async answer" })`
			Установливает асинхронную функцию ответа для всех вызовов методов макета в контексте корутин.
	`val mockWithInterface = mockk<SomeClass>(moreInterfaces = arrayOf(SomeInterface::class))`
			Указывает дополнительные интерфейсы, которые макет должен реализовывать.
	`val relaxedUnitMock = mockk<SomeClass>(relaxUnitFun = true)`
			Позволяет расслабить (relax) функции-члены, которые возвращают `Unit` без явного указания их поведения.
	`val mockWithPrivateCalls = mockk<SomeClass>(recordPrivateCalls = true)`
			Записывает вызовы закрытых (private) методов для последующей их проверки.
	`val mockWithHash = mockk<SomeClass>(hash = 123)`
			Устанавливает значение хеша для создаваемого макета. Это может быть полезно, если вам нужно предсказуемо управлять порядком вызовов методов.
	`val mockWithExceptionHandling = mockk<SomeClass>(catchExceptions = true)`
			Перехватывает исключения, выбрасываемые вызовами методов макета, и возвращать значения по умолчанию вместо выброса исключения.
	`val mockWithCustomMatcher = mockk<SomeClass>(matcher = { arg -> arg.startsWith("prefix") })`
			Позволяет использовать пользовательский матчер для аргументов вызываемых методов.

**every { ... } и coEvery { ... }**: Определение поведения макетов и Асинхронные варианты coEvery **для корутин**.
`every { mockedList.size } returns 42`
`coEvery { myRepository.getData() } returns mockData`
`every { mockedList.add(any()) } answers { println("Item added") }`
		`answer`: Позволяет установить функцию ответа для определенного вызова метода.
`every { spyList.add(any()) } just Runs` 
		`any()` Используется для указания, что для аргумента метода не имеет значения
		`capture(SomeArgument)` Позволяет захватить переданный аргумент и использовать его для дополнительных проверок

**verify { ... } и coVerify { ... }**: проверка того, что вызов состоялся. 
`verify { mockedList.size }`
`verify { spyList.add("item") }`
```kotlin
// Настраиваем проверку, сколько раз должен быть вызван метод.
verify(atLeast = 2) { mockedList.size }
verify(atMost = 3) { mockedList.isEmpty() }
verify(exactly = 1) { mockedList.add("item") }
verify(exactly = 0) { router.nextToHoursScreen() } // тест пройдет, если метод НЕ был вызван
```
`coVerify { myRepository.getData() }

**verifyOrder { ... }**: Проверка порядка вызовов.
`verifyOrder {`
		`mockedList.size`
		`mockedList.isEmpty()`
`}`

**`confirmVerified`**: Используется для проверки, что все ожидаемые вызовы были выполнены.
`confirmVerified(mockedList)`

**spyk()**: Cозданиe шпиона (spy) - объекта, который является **реальным экземпляром класса**, но при этом вы можете переопределять его поведение и следить за вызовами методов. В отличие от макетов, шпионы используют настоящие реализации объектов, что позволяет тестировать реальные взаимодействия. Атрибуты аналогичны методу mockk()
`val spyList = spyk(mutableListOf<String>())`

**slot()**: Захват аргументов вызываемых функций.
`every { mockedList.add(capture(slot)) } just Runs`
`val capturedArgument = slot<String>()`
`verify { mockedList.add(capturedArgument.captured) }`

**clearMocks()**: Очистка информации о вызовах.
`clearMocks(mockedList, spyList)`

# Частые ошибки (решение):

- `Error: Exception in thread "Test worker" java.lang.IllegalStateException: Module with the Main dispatcher had failed to initialize. For tests Dispatchers.setMain from kotlinx-coroutines-test module can be used`
		-  Для решения добавить:
		  `Dispatchers.setMain(StandardTestDispatcher())`
		  в метод (внутри тестового класса) 
		  `private fun getViewModel(): MyViewModel { 
			  `Dispatchers.setMain(StandardTestDispatcher())`
			  `return MyViewModel( ... )`
		  `}`

- `Error:  LoginFormValidator(#5).validate(eq(Input(phone=, password=)))) was not called`
		- Для решения добавить :
		  `advanceUntilIdle()`   или
		  `advanceTimeBy(1000)` 
		Дает тесту доп. время для выполнения асинхронных операций, прежде чем он перейдет к проверкам.
		`// Do`
		`viewVmodel.onViewCreated()`

		`// Wait for asynchronous operations to complete`
		`advanceUntilIdle()`

		`// Check`
		`coVerify { canLoginWithBiometricUseCase() }`

	- Второй вариант решения :
			- НЕ использовать @Before а создавать объект `MyViewModel` с помощью `getViewModel()` 

