- Kонфигурирует корутину
- Елементы:
	- Job
	- CoroutineName
	- CoroutineDispatcher  
	- CoroutineExtensionHendler
- Доступ к текущему контексту можно получить:
```kotlin
viewModelScope.launch{
	delay(1000)
	Log.d("SomeTag", "Current context: $coroutineContext")
}
```

