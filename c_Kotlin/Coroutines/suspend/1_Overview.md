[oficial](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/)
[RxJava to Coroutines](https://medium.com/androiddevelopers/rxjava-to-kotlin-coroutines-1204c896a700)
[Developer Android guide](https://developer.android.com/kotlin/coroutines)
[Сallback API на корутины](https://www.fandroid.info/converting-existing-callback-apis-with-coroutines/)
[Cancellation](https://medium.com/androiddevelopers/cancellation-in-coroutines-aa6b90163629)

# Dependencies
```kotlin
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.1") // kotlin-coroutinesCore
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-rx3:1.7.1")  // kotlin-coroutinesRxAdapter
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:1.7.1") // kotlin-coroutinesTest
```


# Interface CoroutineScope
- задает время жизни корутины
- содержит ссылку на [CoroutineContext](3_CoroutineContext.md)
```kotlin
public interface CoroutineScope {  
     public val coroutineContext: CoroutineContext  
}
```
- определяет методы .launch{} .async{}

![[CoroutinesScope.png]]

- **lifecycleScope**
- **viewModelScope** 
	- По умолчанию стартует корутины в гланом потоке (SupervisorJob() + Dispatchers.Main.immediate)
	- Можно безопасно работать с LiveData
	- При уничтожении ViewModel все корутины, созданные в этом scope удаляются.
- можно создать **CustomScope**

# Cоздание корутины (Coroutine builders)
```kotlin
(Dispatchers.Default)
```
Используем extension методы интерфейса CoroutineScope:
## .launch(): Job {}  -  НЕ возвращает из корутины ничего ("void")
		- Используется внe корутины
		- в основном используется как отправная точка, чтобы стартовать корутину не из корутины 
			(потому, что сам метод не является suspend, но внутри содержит suspend лямбду)
		- создает новый контекст в котором будет, как минимум, новый Job
		- Можно запустить внутри существующей корутины, чтобы виполнить работу результат которой мы не ждем.
		- Можно подождать выполнение с помощью метода Job.join()
## .async(): Deferred {}  -  Возвращает в return
		- Используется внe корутины
		- НЕ ждет результат выполнения работы! (Сразу возвращает Deferred)
		- Чтобы получить результат нужно вызывать метод Deferred.await() (смотри пример)
		- Можно запустить как вне, так и внутри существующей корутины
		- Можно разбить какой-нить большой массив на 5 равних частей и обратотать их паралельно 
				запустив 5 раз .async{} и собрать результаты в одном месте с помощью метода Deferred.await()
		- создаcт новый контекст с новыми Job и указанным Dispatcher (с родительским, если не указан новый)

## runBlocking{ } 
		- Используется внe корутины
		- блокирует поток(Thread) в котором вызывается до завершения всех запущенных корутин внутри

## withContext(Dispatchers.IO){}  -  Ожидает результат!
		- Используется только внутри корутины (он suspend)
		- переключает контекст выполнения внутри корутины
		- ЖДЕТ результат выполнения работы (Блокирует остальной код описанный в корутине ниже себя)
		- НО НЕ Блокирует поток, в котором вызван
		- создаcт новый контекст с новыми Job & Dispatchers.Main


## e.g.:
```kotlin
// блокирует поток(Thread) в котором вызывается до завершения всех запущенных корутин внутри
val accessToken = runBlocking { tokenAuthenticatorService.refreshToken() }
```

```kotlin
CoroutineScope(Dispatchers.Default).launch {}
```

```kotlin
val deferredResult = CoroutineScope(Dispatchers.Default).async {}
```

```kotlin
// создания корутины, которая живет в течение всего жизненного цикла приложения
GlobalScope.launch {}
```

```kotlin
lifecycleScope.launch {}
```

```kotlin
viewModelScope.launch{
	delay(1000)
	
	// withContext вызывается в Main потоке
	// НО НЕ Блокирует его, а выполняет свою работу в потоке Default (в данном примере)
	val result = withContext(Dispatchers.Default){
		val part1 = async {
			delay(1000) // ставит корутину на паузу на 1с
			return@async "Part 1 done"
		}
		val part2 = async {
			delay(3000)
			return@async "Part 2 done"
		}
		val part3 = async {
			delay(2000)
			return@async "Part 3 done"
		}
		// общее время работы этого блока будет 3с
		// потому, что "части" будут выполнятся паралельно!!!
		val res1 = part1.await() // через 1с от .withContext() проинициализируется эта переменная
		val res2 = part2.await() // через 3с от .withContext() проинициализируется эта 
		val res3 = part3.await() // через 2с от .withContext() проинициализируется эта
		
		return@withContext "$res1 + $res2 + res3"
	}

	// withContext() ждет выполнения работы!
	Log.d("ANY_TAG", "Result: $result")
}
```

play.kotlinlang.org
```kotlin
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


/**
 * You can edit, run, and share this code.
 * play.kotlinlang.org
 */
fun main() {
    println("Hello, world!!!")
    
    CoroutineScope(Dispatchers.Default).launch {
	    // выполнится в любое время
		// абсолютно асинхронно
        println("Hello, from CoroutineScope 1!!!") 
    }
    
    runBlocking{
            println("Hello, from coroutine!!!")
            println(sf1())
            sf2()
	            .onSuccess{ println("onSuccess $it") }
            	.onFailure{ println("onFailure $it") }
                
            println(sf3())
            
            println(sf1())
    }
    
    CoroutineScope(Dispatchers.Default).launch {
	    // выполнится в любое время
		// абсолютно асинхронно
		// может даже перед кодом в runBlocking
        println("Hello, from CoroutineScope 2!!!")
    }
    
    println("Bye!!!")
}

suspend fun sf1(): Result<String>{
    return Result.success("Hi, sf1()")
}

suspend fun sf2(): Result<String>{
    return Result.failure(IllegalArgumentException("Hi, sf2"))
}

suspend fun sf3(): String{
	//throw IllegalArgumentException("IllegalArgumentException, sf3")
    return "Hi, sf3"
}
```


# Dispatchers

	.Default  -  используется для сложных мат. вычислений (оптемизирован для этого)
	.Main  -  главный поток (используется по умолчанию)
	.Unconfined
	.IO  -  используется для походов в сеть или БД


# Continuation

Roman Andrushchenko   e.g.:
```kotlin
interface Task<T>{

	fun cancel()
		
	suspend fun suspend(): T = suspendCancelableCoroutine{ continuation ->
		enque(){ // it: FinalResult<T>
			continuation.invokeOnCancelation { cancel()}
			when(it){
				is SuccessResult -> continuation.resume(it.data)
				is ErrorResult -> continuation.resumeWithException(it.exception)
			}
		}
	}
}
```

B9   e.g.:
```kotlin
class FirebaseTokenRepositoryImpl(  
    private val coroutineDispatchers: CoroutineDispatchers,  
) : FirebaseTokenRepository {  
  
    override fun read() = flow {  
        val token = suspendCoroutine { continuation ->  
            FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->  
                if (task.isSuccessful) {  
                    task.result?.let { continuation.resume(it) }  
                        ?: continuation.resumeWithException(  
                            task.exception ?: IllegalStateException("FirebaseMessaging getToken() Error")  
                        )  
                } else {  
                    continuation.resumeWithException(  
                        task.exception ?: IllegalStateException("FirebaseMessaging getToken() Error")  
                    )  
                }  
            }  
        }        emit(token)  
    }.flowOn(coroutineDispatchers.io)  
}
```













![[последовательность в корутинах.png]]

## Coroutines
[Introduction to Coroutines in Kotlin Playground](https://developer.android.com/codelabs/basic-android-kotlin-compose-coroutines-kotlin-playground)


```kotlin
class CanLoginWithBiometricUseCaseImpl(  
    private val userCredentialsRepository: UserCredentialsRepository,  
    private val bioManager: BioManager  
) : CanLoginWithBiometricUseCase {  
  
    override fun invoke() = flow {  
        // check if credentials are saved  
        userCredentialsRepository.getCredentials()  
            .collect { credentials ->  
                if (credentials != UserCredentials.EMPTY) {  
                    // credentials exist, check if device supports biometric feature  
                    emit(bioManager.isEnabled().firstOrNull() ?: false)  
                } else emit(false)// no saved credentials  
            }  
    }}
```

Single into a suspend function:
```kotlin
suspend fun waitForRxJavaResult(): String? = suspendCoroutine { cont ->
        try {
            val result = resultSingle.blockingGet()
            cont.resume(result)
        } catch (e: Exception){
            cont.resume(null)
        }
    }
```

# .onEach{} vs .collect{}
## Differences in methods of collecting Kotlin Flows
[источник](https://itnext.io/differences-in-methods-of-collecting-kotlin-flows-3d1d4efd1c2)
```kotlin
public suspend fun collect(collector: FlowCollector<T>)
vs
public fun <T> Flow<T>.launchIn(scope: CoroutineScope): Job
```

```kotlin
/**
 * you can call `collect()` method only from another suspending function or from a coroutine.
 */
coroutineScope.launch {  
	flowOf(1, 2, 3)  
	.collect { println(it) }  
}
```

```kotlin
/**
 * can be called in any regular function:
 */
flowOf(1, 2, 3)  
	.onEach { println(it) }  
	.launchIn(coroutineScope)
	
/**
* you also get a `Job` as return value, 
* so you could cancel the flow by cancelling the job:
*/
val job = flowOf(1, 2, 3)  
	.onEach { println(it) }  
	.launchIn(coroutineScope)  
job.cancel()
```

## A more subtle (тонкая) difference
```kotlin
runBlocking {  
    flowOf(1, 2, 3)  
        .onEach { delay(100) }  
        .collect { println(it) }    
    flowOf("a", "b", "c")  
        .collect { println(it) }  
}

// output:
// 1  
// 2  
// 3  
// a  
// b  
// c
```

The reason for this behaviour is, that `.collect()` is a suspending function. It suspends coroutine, until it is finished doing its own thing.
That means, that the second flow won’t be collected at all, until first flow is completed.

Let’s look into the implementation of `.launchIn()` method:

```kotlin
public fun <T> Flow<T>.launchIn(scope: CoroutineScope): Job =
scope.launch{ 
	collect() // tail-call  
}
```

```kotlin
runBlocking {  
    flowOf(1, 2, 3)  
        .onEach { delay(100) }  
        .onEach { println(it) }  
        .launchIn(this)    
    flowOf("a", "b", "c")  
        .onEach { println(it) }  
        .launchIn(this)  
}

// output:
// a  
// b  
// c  
// 1  
// 2  
// 3
```

when the first flow is collected, the coroutine launched by `runBlocking {}` is NOT suspended. 
Instead, a new child coroutine was launched in the scope of the blocking coroutine (launched via `runBlocking {}`) 
and this new child coroutine is the one, that will be suspended.

###### In conclusion I’d recommend preferring `.launchIn()` over `.collect()` for collecting your flows, to avoid unexpected bugs. 

Use `.collect()` only if you are absolutely sure, that you don’t mind and will not mind in the future it suspending your coroutine 
(for example because the coroutine was launched to collect this one specific flow and nothing else is ever going to be executed in it, 
not even in the future you’d want to add anything else into that coroutine).

## StateFlow, and LiveData

`StateFlow` and [`LiveData`](https://developer.android.com/topic/libraries/architecture/livedata) have similarities. Both are observable data holder classes, 
and both follow a similar pattern when used in your app architecture.

Note, however, that `StateFlow` and [`LiveData`](https://developer.android.com/topic/libraries/architecture/livedata) do behave differently:

-   `StateFlow` requires an initial state to be passed in to the constructor, while `LiveData` does not.
-   `LiveData.observe()` automatically unregisters the consumer when the view goes to the `STOPPED` state, 
	whereas collecting from a `StateFlow` or any other flow does not stop collecting automatically. 
	To achieve the same behavior,you need to collect the flow from a `Lifecycle.repeatOnLifecycle` block.

```kotlin
class LatestNewsActivity : AppCompatActivity() {  
    private val latestNewsViewModel = // getViewModel()  
		  
        override fun onCreate(savedInstanceState: Bundle?) {  
        ...  
        // Start a coroutine in the lifecycle scope  
        lifecycleScope.launch {  
            // repeatOnLifecycle launches the block in a new coroutine every time the  
            // lifecycle is in the STARTED state (or above) and cancels it when it's STOPPED.            
            repeatOnLifecycle(Lifecycle.State.STARTED) {  
                // Trigger the flow and start listening for values.  
                // Note that this happens when lifecycle is STARTED and stops                
                // collecting when the lifecycle is STOPPED                
                viewModel.uiState.collect { uiState ->  
                    // New value received  
                    when (uiState) {  
                        is LatestNewsUiState.Success -> showFavoriteNews(uiState.news)  
                        is LatestNewsUiState.Error -> showError(uiState.exception)  
                    }  
                }  
            }        
        }
    }  
}
```


## MutableSharedFlow
analog for `BehaviourSubject` - same as ReplaySubject with size "1"
```kotlin
val shared = MutableSharedFlow(
    replay = 1,
    onBufferOverflow = BufferOverflow.DROP_OLDEST,
)
shared.tryEmit(value)
```