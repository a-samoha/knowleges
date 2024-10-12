
[AndroidDevelopers](https://www.youtube.com/watch?v=fSB6_KE95bU)
[FLOWMARBLES.COM](https://flowmarbles.com/#conflate)
[STACK_OVERFLOW](https://stackoverflow.com/a/63943728/16640319)
[Kotlin Coroutine Flows: Deep Dive (Part 1 Cold Flows)](https://proandroiddev.com/kotlin-coroutine-flows-deep-dive-part-1-cold-flows-e030405d1664)
[Kotlin Coroutine Flows: Deep Dive (Part 2: Hot Flows🔥)](https://proandroiddev.com/kotlin-coroutine-flows-deep-dive-part-2-hot-flows-9571b7620f66)
[State Flow and Shared Flow in Kotlin](https://levelup.gitconnected.com/state-flow-and-shared-flow-in-kotlin-f603c7aa7299)
[Developer Android guide](https://developer.android.com/kotlin/coroutines)
[Rx to Flow](https://habr.com/ru/companies/simbirsoft/articles/534706/)

Buffer  -  Хранит эмит отправленный подписчику, пока он не будет доставлен [(03:00)](https://youtu.be/njchj9d_Lf8?t=173)  [(06:30)](https://youtu.be/njchj9d_Lf8?t=392)

Cache   -  Хранит эмиты для следующих подписчиков (задается в replay = 3)	

###### Иерархия:
`Flow`
`SharedFlow<out T> : Flow<T>`
`StateFlow<out T> : SharedFlow<T>`

## Flow (Cold) 
Flow — это, реактивный поток данных. 
- в него отправляет `emit()` эмиттер и 
- из него собирает `collect()` подписчик.
- **Холодный** поток: "Один объект потока может иметь только одного подписчика. 
  При каждой подписке - создается новый объект потока"
  Превратить в горячий:  `.stateIn(CoroutineScope)` / `.shareIn()` / `.produceIn(CoroutineScope)`
- Похоже на Single/Completable (но c одним или несколькими эмитами)
- **Помрет** как только выплюнет последнее значение
- желательно подчищать корутинские Job.   Напр.: `job.cancel()`

# Важно:  

1)  .first() **НЕЛЬЗЯ** использовать!!!
	- этот метод бросает NPE точнее "kotlin.UninitializedPropertyAccessException: lateinit property implementation has not been initialized"
	- это происходит, если в .catch{} прилетает ошибка 
	- **всегда используй .firstOrNull()**

1) .emit(myValue)  -  требует suspend
2) .tryEmit(myValue)  -  **НE требует suspend**!!!

3) .observeOn() у RX переключает поток, в котором будут выполняться последующие операторы, 
   [.flowOn()](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/flow-on.html) у Flow определяет диспетчер выполнения для предыдущих операторов.  
  ```kotlin
withContext(Dispatchers.Main) {
    val singleValue = intFlow // will be executed on IO if context wasn't specified before
        .map { ... }          // Will be executed in IO
        .flowOn(Dispatchers.IO)
        .filter { ... }       // Will be executed in Default
        .flowOn(Dispatchers.Default)
        .single()             // Will be executed in the Main
}
```
	Метод collect() будет выполняться в том же диспетчере, что и launch, 
	а emit данных будет происходить в Dispatchers.IO, 
	в то время как метод subscribe() будет выполняться в Schedulers.single(), 
	потому что идет после него.  
  
4) Flow, как и RxJava, представляет собой cold stream данных: до вызова методов collect() и subscribe() никакой обработки происходить не будет.  

5) В RxJava нужно явно вызывать emitter.onComplete(). 
	У Flow метод onCompletion() будет автоматически вызываться после окончания блока flow { }.  
	 (когда все эмиты закончились)
	
6) Попытка сделать эмит из другого диспетчера (напр.: с помощью withContext) приведет к ошибке.
7) Важно помнить, что нижестоящий подписчик также может быть самим потоком `Flow`,  создавая цепочку этапов обработки данных, где каждый этап собирает данные с предыдущего.
# Создаем:
	- flowOf(1, 2, 3) - поток с ограниченным кол. знач. (rx: Observable.fromArray(1, 2, 3))
	- .asFlow()       - превращает Iterable, Sequence, массивы во flow
	- flow { emit("value") }  -  внутри последовательные вызовы emit()
	- channelFlow{ send("value") }  -  внутри асинхронные вызовы send() если сбор и отправку потока необходимо разделить на несколько сопрограмм
# Настраиваем
	- Промежуточные операторы: 
	- .map{ it.toDomain() }, 
	- .filter{ it.property == true }, 
	- .take(), 
	- .zip(), etc. 
	- .stateIn(CoroutineScope)  -  превращаем в горячий StateFlow
	- .shareIn(...)             -  превращаем в горячий SharedFlow
	- .produceIn(CoroutineScope)
	- указывают некие действия, которые потом будут вполнятся при эмитах
# Подписываемся:
	- Терминальные операторы:
	- .collect{}
	- .lounchIn(CoroutineScope)
	- .firstOrNull()  // Всегда используй этот метод вместо .first() 
	- .single()
	- .reduce()
	- .toList(), etc.
	- .first() // НЕЛЬЗЯ использовать!!! ЕСЛИ прилетает ошибка в .catch{} приложение крашнется
	напр: 
```kotlin
		lifecycleScope.LaunchWhenStarted{
			viewModel.message // если это обычный Flow
				.onEach{ textView.text = it}
				.collect()
			printLn("Hello World") // то эта строка ВЫПОЛНИТСЯ после получения последнего значения из flow
		}
		
		// OR
		
		viewModel.message
			.onEach{ textView.text = it}
			.lounchIn(lifecycleScope)
		printLn("Hello World") // эта строка ВЫПОЛНИТСЯ сразу "рядом" с подпиской на flow
```

[Вот так реализован Flow](https://play.kotlinlang.org) 
```kotlin
import kotlinx.coroutines.*

fun main() {
    runBlocking{
	    
		val flow1 = object : Flow<String> {
			override suspend fun collect(emitter: FlowEmitter<String>) {
				emitter.emit("Hello") // Take the value "Hello" and bring to the subscriber
				emitter.emit("World1")
    		}
		}
         
		val flow2 = Flow<String> { emitter ->
    		emitter.emit("Hello")
			delay(1000)
			emitter.emit("World2")
		}
	    
        flow1.collect(object : FlowEmitter<String> {
    		override suspend fun emit(value: String) {
				println(value) // action that we will do with the value
    		}
		})
	    
        flow2.collect { value ->
    		println(value)
		}
    }
}

fun interface Flow<T> {
    suspend fun collect(emitter: FlowEmitter<T>) // lambda function
}

fun interface FlowEmitter<T> {  // In original Kotlin it names FlowCollector BUT,
    suspend fun emit(value: T)  // "emit" means: "Hey, FlowCollector, here is the value, take it and bring to the subscriber"
}
```


Разбери все эти топики:
![[1 1.png]]
![[2 1.png]]