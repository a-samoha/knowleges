Из  javadoc:

- **Концепция** как Java's BlockingQueue с суспензированием вместо блокирования

- **Варианты создания:**
	  - `Channel<String>()`  это  Channel(RENDEZVOUS)
	  - Custom:   `Channel(3,  DROP_OLDEST)`   *ArrayList buffer
	  -` Channel(CONFLATED)`  это  Channel(1,  DROP_OLDEST)
	  - `Channel(BUFFERED)`  это  Channel(64,  SUSPEND)
	  - `Channel(BUFFERED, DROP_OLDEST)`  это  Channel(1,  DROP_OLDEST)
	  - `Channel(UNLIMITED)`  это  Channel(Int.MAX,  SUSPEND)   *LinkedList buffer

- **onUndeliveredElement** вызывается (synchronously) в 3 случаях:
	  - .send() выбрасывает ошибку
	  - .receive()/.receiveOrNull()/.hasNext() выбрасывает ошибку
	  - Сhannel was cancelled, а в буфере были елементы
	  - Должна быть быстрой и НЕ бросать ошибок

- НЕ дефолтный onBufferOverflow=DROP_OLDEST задает минимальное capacity = 1
- Channel(UNLIMITED) игнорирует указанный DROP_OLDEST

## Важно
	.send(event)     - требует suspend
					  - используем при любом capacity
					  
	.trySend(evemt)  - НЕ требует suspend (вызывается из текущего потока)
					- использолвать желательно только при capacity=1
					- при capacity=0 ВАЖНО подписаться ДО .trySend(evemt)

![[Pasted image 20240409223600.png]]

## Использование
```kotlin
private val _errors = Channel<MyExeption>()
val errors = _errors.receiveAsFlow()
...
suspend fun doSmth(){
	_error.send(MyExeption)
}

fun notSuspendDoSmth(){
	_error.trySend(MyExeption)
}
```

## Создание 
 ```kotlin
val channel = Channel<String>(
    // дефолтное значение capacity=0. Буфера нет, 
    // НО метод send() суспензирует отправленный объект
    // и он ждет пока кто-то подпишется (вызовет метод receive())
    // при этом НЕ важно была подписка до send() или после
	
	// если capacity=0 вызвать метод trySend() 
	// - при подписке ДО send/trySend() доставка успешна
	// - при подписке ПОСЛЕ - объект пролетит в небытие
	
	// если capacity=0 вызвать метод tryReceive() 
	// - при подписке ДО send/trySend() доставка Failed
	// - при подписке ПОСЛЕ - все ок
	
	capacity: Int = RENDEZVOUS,  
	onBufferOverflow: BufferOverflow = BufferOverflow.SUSPEND,  
	onUndeliveredElement: ((E) -> Unit)? = null
 )``` 
 


https://play.kotlinlang.org/
```kotlin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.launchIn

/**
 * You can edit, run, and share this code.
 * play.kotlinlang.org
 */
fun main() {

    val channel = Channel<String>()
    val flow = channel.receiveAsFlow()
    println("\nchannel $channel")
    println("flow $flow")
    
    CoroutineScope(Dispatchers.IO).launch{
    	println("\ncoroutineIO")
        
        delay(100)
        channel.send("STATE")
    }
    
    flow
	    .onEach{ println("onEach $it") }
        .launchIn(CoroutineScope(Dispatchers.Default))
    
    CoroutineScope(Dispatchers.Default).launch{
        println("\ncoroutinMain")
        
        val tmp = channel.receive()
        println("\n receive $tmp")
        delay(1000) 
    }
}

```