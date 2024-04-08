
- задает время жизни корутины
- содержит ссылку на [CoroutineContext](3_CoroutineContext.md)
- определяет методы .launch{} .async{}

![[CoroutinesScope.png]]


```kotlin
public interface CoroutineScope {  
      
     public val coroutineContext: CoroutineContext  
}
```

## Отличия Coroutine builders

	- .launch(): Job {...} 
			- в основном используется как отправная точка, чтобы стартовать корутину не из корутины 
				(потому, что сам метод не является suspend, но внутри содержит suspend лямбду)
			- создает новый контекст в котором будет, как минимум, новый Job
			- Можно запустить внутри существующей корутины, чтобы виполнить работу результат которой мы не ждем.
			- Можно подождать выполнение с помощью метода Job.join()

	- .async(): Deferred<T> {...} 
			- Можно запустить как вне, так и внутри существующей корутины
			- Можно разбить какой-нить большой массив на 5 равних частей и обратотать их паралельно 
					запустив 5 раз .async{} и собрать результаты в одном месте с помощью метода Deferred.await()
			- создаcт новый контекст с новыми Job & Dispatchers.IO
			  
	- .withContext{...} 
			- Используется только внутри корутины (он suspend)
			- создаcт новый контекст с новыми Job & Dispatchers.Main

```kotlin
class MyViewModel : ViewModel() {
    private val repository = MyRepository()

    fun fetchData() {
        viewModelScope.launch {
            // Код, выполняющийся в контексте основного потока

            // Здесь нет необходимости явного переключения на контекст главного потока,
            // так как viewModelScope уже настроен для работы с главным потоком.

            // Вызываем функцию, которая может выполнять блокирующие операции
            val result = withContext(Dispatchers.IO) {
                // Код, выполняющийся в контексте ввода-вывода (IO)
                repository.fetchDataFromNetwork()
            }

            // Обновляем UI с использованием полученных данных
            updateUI(result)

            // Код после withContext вновь выполняется в контексте основного потока
        }
    }

    private fun updateUI(result: Result) {
        // Обновление UI
    }
}
```

