
[STACK_OVERFLOW](https://stackoverflow.com/a/63943728/16640319)

	- myMutableStateFlow.asStateFlow()  // чтобы точно убедиться, что объект "read-only"
	- myMutableSharedFlow.asSHaredFlow()  // аналогично

# Создать
	- runBlocking{ (1..3).asFlow() }  // выплюнет три эмита подряд
	- runBlocking{ flowOf(1, 2, 3) }  // аналогично
	- fun oserveSmth(): Flow<String> = flow{ emit(Unit) }
	- fun <T> contextualFlow(): Flow<T> = channelFlow { }
				позволяет внутри запускать новые корутины(и Flow) которые будут выполняться одновременно. 
				смотри описание в документации.
	- fun flowFrom(api: CallbackBasedApi): Flow<T> = callbackFlow {}  // пока не понял
	- .consumeAsFlow  // преврацает Сoroutine ReceiveChannel в Flow

# Подписаться (Терминальные операторы)
###### - Вне корутины
	- myFlow.lounchIn(Dispatchers.IO)
					возвращает Job
###### - Из корутины
	- myFlow.collect{}
					код в этой лямбде будет выполняться при каждом эмите (а, НЕ один раз по завершению)
					возвращает Unit
	- myFlow.collectIndexed{ index, value -> print("$index, $value") }  // позволяет пронумировать получаємые эмиты
	- myFlow.collectLatest{  
					если обработка первого эмита продлится дольше, чем прилетит следующий эмит, то код прервется НЕ обработав первый эмит 
					это значит - НЕ прокинет первый эмит дальше, а, займется следующим эмитом
					println("Collecting $value") 
					delay(200) // Emulate work (обработка первого эмита продолжается)
				    println("$value collected")  // этот код может не выполниться, если следующий эмит прилетит раньше
	}

	- myFlow.single() // Throws [NoSuchElementException] for empty flow and [IllegalArgumentException] for flow that contains more than one element.

	- myFlow.first()  // возвращает первый эмит и завершает flow (Throws NoSuchElementException if the flow was empty)
	- myFlow.firstOrNull()  // возвращает первый эмит и завершает flow (Returns null if the flow was empty)

	- myFlow.last()
	- myFlow.lastOrNull()

# Преобразовать
	- .map{ it.toString() }  // преобразовывает эмит из одного объекта в другой, причем можно даже во флоу (получим flowOfFlows)
	- .mapLatest{ it.toString() }  // если преобразовывание эмита продлится дольше, чем прилетит следующий эмит, то код прервется НЕ обработав текущий эмит
	- .mapNotNull{ it.toString() }  преобразовывает эмит и если получился null - вернет it (не переделанный)
	- .shareIn(scope, SharingStarted.Eagerly)

# Объединить
[Хорошая статья](https://kt.academy/article/cc-flow-combine)
###### - БЕЗ преобразования  (НЕ меняется тип возвращаемого объекта)
	- listOf(flow1, flow2).merge().collect{}
				Ретранслирует эмиты из каждого потока в один общий
				НЕ соблюдает порядок эмитов
				Нельзя объеденять потоки с разными дженериками
	- merge(flow1, flow2, flow4).collect{}   // аналогично
	
	- flowOfFlows.flattenConcat()
				СОХРАНЯЕТ порядок элементов
	
	- flowOfFlows.flattenMerge(2)
				если указать `concurrency == 1` этот метод аналогичен flattenConcat()

###### - C преобразованием (меняется тип возвращаемого объекта)
	- flow1.combine(flow2){ emitFrom1, emitFrom2 -> "$emitFrom1, $emitFrom2" }.collect{}
					порядок на каком flow (flow1 или flow2) вызывать НЕ !ВАЖЕН
					так можно объединить только 2 flow, для большего количества - смотри ниже
	- combine(flow1, flow2, flow4){ emitFrom1, emitFrom2, emitFrom4 -> "$emitFrom1, $emitFrom2" }.collect{}  
					тот же оператор
					ждет эмита от каждого потока 
					свой первый эмит выдает только, когда получит по эмиту от всех потоков (НЕ обязательно по первому)
					напр.: flow1 уже сделал 4 эмита, а flow2 только свой первый combine обработает flow1(4) с flow2(1)
					а, следующие свои эмиты делает на каждый эмит из любого потока (помнит значения последних эмитов и работает с ними)
					!НЕ НУЖНО явно указывать emit()
	flow1.combineTransform(flow2){ emitFrom1, emitFrom2 -> emit("$emitFrom1, $emitFrom2") }.collect{}
					НУЖНО явно указывать emit()
					МОЖНО сделать более одного эмита
					в остальном аналогичен combine (я разницы не увидел)

	- flow1.flatMapConcat { flow2(it) }
					это объединение (аналог) `.map(transform).flattenConcat()`
					каждый эмит из flow1 передается во flow2
					flow2 БЛОКИРУЕТ следующий эмит из flow1 пока не выполнит свой код
					на каджий эмит из flow1 второй поток может делать много своих эмитов
					второй поток может преобразовывать тип объекта (получить Int а вернуть String)
					по-сути, возвращает эмиты второго потока
	- flow1.flatMapLatest{ flow2(it) } 
					идея та же, что у flatMapConcat
					но, !НЕ БЛОКИРУЕТ следующий ємит из flow1 
					напр.: если преобразовывание flow2 продлится дольше, чем прилетит следующий эмит из flow1, 
									то код flow2 прервется НЕ дообработав текущий эмит
	- flow1.flatMapMerge{ flow2(it) } 
					это объединение (аналог) `.map(transform).flattenMerge(concurrency)`
					flow2 !НЕ БЛОКИРУЕТ следующий эмит из flow1
					если интервал между эмитами во flow1 больше чем преобразовывание flow2 -- работает аналогично flatMapConcat
					но, если преобразовывание flow2 продлится дольше, чем прилетит следующий эмит из flow1, эмиты перемешиваются
					получается, НЕ соблюдает порядок эмитов

	- flow1.zip(flow2) { fl1, fl2 -> "$fl1 $fl2" }.collect{}
					работает ТОЛЬКО с 2-я потоками
					жестко связывает пары эмитов (flow1(1) с flow2(1), flow1(2) с flow2(2) и т.д.)
					БЛОКИРУЕТ flow2, пока не получит эмит от flow1.
					ЗАВЕРШАЕТ оба потока, как только завершится хотябы один из них 
					ЕСЛИ, flow2 будет пустым - flow1 выполнит свой первый эмит
					ЕСЛИ, запустить на пустом flow1 - flow2 вообще не выполнится.

# Фильтровать

- [.debounce(1000) ](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/debounce.html) -  фильтрует эмиты ПОСЛЕ которых была задержка больше указанной
								-  всегда возвращает последний эмит
- [.drop(5)](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/drop.html)  - проигнорирует указанное количество эмитов и вернет все остальное
- [.dropWhile{ it == 2 } ](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/drop-while.html) - проигнорирует количество эмитов удовлетворяющих условию и вернет все остальное
- [.filter{ it == 2 }](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/filter.html)  - вернет все, что удовлетворяет условию
- [.filterNot{ it == 2 }](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/filter-not.html)  - вернет все, что НЕ удовлетворяет условию
- [.filterNotNull()](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/first-or-null.html)  - вернет все, что НЕ null
- .[take(1)](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/take.html)  -  
- .[sample()](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/sample.html)  - 

# Обработка ошибок

- [.catch{ e -> emit(ErrorWrapperValue(e)) }](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/catch.html)  -  обрабатывает ошибки в предыдущих операторах и не видит, что после него.  
																			-  does not catch exceptions that are thrown to cancel the flow.
- .catch{ e -> emitAll(config.asSharedFlow()) }

# Операторы

- [.flowOn(Dispatchers.IO)](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/flow-on.html)  -  обрабатывает в предыдущих операторах и не видит, что после него.  
- .onEach{}
- .onEmpty{}
- .onSubscription{}
- .onStart{}
- .onCompletion{}
- .[retry(3){ e ->(e is IOException).also { if (it) delay(1000) }](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/retry.html)  - 
- [.count()](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/count.html)  или  .count{ it == 1}  - возвращает количество эмитов (общее или удовлетворяющее условию)
- [.buffer()](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/buffer.html)  -  создаст еще одну паралельную корутину которая заберет на себя код описанный перед этим оператором.
```kotlin
flowOf("A", "B", "C")
    .onEach  { println("1$it") }
    .buffer()  // .onEach{} будет выполняться одновременно с .collect{} (а, если без .buffer() - то последовательно)
    .collect { println("2$it") }
```
- [.cancellable()](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/cancellable.html)  -  все SharedFlow являются cancellable по-умолчанию. А что оно дает обычному Flow пока не понял
- [.conflate()](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/conflate.html)  -   если обработка первого эмита продлится дольше, чем прилетит следующий эмит, то код прервется НЕ обработав первый эмит.
						-  Что-то похожее на collectLatest, но точно пока не понял.




```kotlin
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

/**
 * You can edit, run, and share this code.
 * play.kotlinlang.org
 */
fun main() {
    println("Hello, world!!!")
    
    CoroutineScope(Dispatchers.IO).launch{
        fl1().onEach{ println("fl1") }.collect()
    }
    
    CoroutineScope(Dispatchers.IO).launch{
        fl2().collect{ println("fl2") }
    }
    
    println("Bye!!!")

//     runBlocking{ delay(1200) }
//     runBlocking{
//         fl1()
//             .onEach{
//                 println("fl1!!!")
//             }
//             .onCompletion(){
//                 println("fl1 completed!!!")
//             }
//             .first()
//             //.launchIn(CoroutineScope(Dispatchers.IO))
//     }
	println("Definitely!")
}

fun fl1(): Flow<Unit> = flow{
    println("Hello, fl1()")
 	emit(Unit)
    delay(1000)
    emit(Unit)
}

fun fl2(): Flow<Unit> = flow{
    println("Hello, fl2()")
    emit(Unit)
    delay(1000)
    emit(Unit)
}.onCompletion{
    println("fl2 completed")
}
```
