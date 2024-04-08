- НЕ обязательный елемент объекта CoroutineContext
- Определяет то где (в каком потоке) и как будет работать корутина 

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