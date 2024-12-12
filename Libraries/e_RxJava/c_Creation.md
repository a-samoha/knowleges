#rx_Java 

#### Diagram
[Хабр статья](https://habr.com/ru/post/560162/)
```kotlin
Observable.just("Hello", "world")
	.map{ }
	.filter{ true }
	.subscribe()
```
 ![[Pasted image 20220704123550.png]]
###### Вывод
- `Observable`_’ы_ **вкладываются друг в друга** и вызывают _callback’и_ для создания `Observer`_’ов_, которые и будут обрабатывать получаемые данные и передавать их дальше по цепочки.
- Метод `onSubscribe()` **вызывается до начала отправки данных** и это надо иметь ввиду если вы пользуетесь такими операторами, как `doOnSubscribe()`.
- На каждый оператор создается как минимум 3 объекта:
 - Анонимный класс передаваемый в оператор
 - `Observable` создаваемый внутри оператора
 - `Observer` обрабатывающий получаемые данные
 Поэтому при использовании операторов стоит иметь ввиду, что каждый оператор аллоцирует память для несколько объектов и не стоит добавлять операторы в цепочку, только потому что “можно”.

RxJava мощный инструмент, но нужно понимать, как он работает и для каких задач его использовать. Если вам нужно просто выполнение сетевого запроса в фоновом потоке и последующее выполнение результата на главном потоке, то это как “стрелять из пушки по воробьям”, попасть можно, а вот последствия могут быть серьезными.

# Создание источников
[Документация](https://github.com/ReactiveX/RxJava/wiki/Creating-Observables)
### .just ( "Hi" ) - 
**Available in:** ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`

```kotlin
// вернет Observable который заупстит "onNext" (после подписки) 4 раза
val observable = Observable.just("Hello", "World", "from", "observable")
observable.subscribe()
```

### .from...( ... )
.**fromIterable**( listOf("a", "b", "c", )
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
 ```kotlin
 // вернет Observable который заупстит "onNext" 4 раза отдавая отдельный елемент списка
 Observable.fromIterable(listOf("\"Hello\", \"World\", \"from\", \"iterable\""))  
 	.subscribe(System.out::println)
 ```
.**fromArray**( arrayof("a", "b", "c",) )
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
 ```kotlin
 // вернет Observable который заупстит "onNext" 1 раз отдав  целый список
 Observable.fromArray(arrayOf("Hello", "World", "from", "array"))  
    .subscribe(System.out::println)
 ```
  ```kotlin
 // ОЧЕНЬ ВАЖНА ЗВЕЗДОЧКА "`*`"
 // вернет Observable который заупстит "onNext" 3 раза отдав  каждый отдельный елемент
 Observable.fromArray(*arrayOf("Hello", "World", "from", "array"))  
    .subscribe(System.out::println)
 ```
.**fromCallable**(callable)
   Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
  ```kotlin
  class MyJob : Callable<Int> {  
	    override fun call() = 42
    }
    
  Observable.fromCallable(MyJob())  
    .subscribe(System.out::println)
  ```
.**fromAction**(action)
 Available in: ![[Pasted image 20220704124454.png]] `Flowable`, ![[Pasted image 20220704124454.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
 ```kotlin
 val action = Action { println("Hello from action!") }  
 Completable.fromAction(action)  
    .subscribe()
 ```
.**fromRunable**(runnable)
 Available in: ![[Pasted image 20220704124454.png]] `Flowable`, ![[Pasted image 20220704124454.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
 ```kotlin
 val runnable = Runnable { println("Hello from runnable!") }  
 Completable.fromRunnable(runnable)  
    .subscribe()
 ```
 _Note: the difference between `fromAction` and `fromRunnable` is that the `Action` interface allows throwing a checked exception while the `java.lang.Runnable` does not._
.**fromFuture**()
   Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
  ```kotlin
 val executor: ScheduledExecutorService = Executors.newSingleThreadScheduledExecutor()  
 val future = executor.schedule({ "Hello from future!" }, 10, TimeUnit.SECONDS)  
 Single.fromFuture(future)
	 .subscribe()
  ```

### .generate() - сreates a cold, synchronous and stateful generator of values.
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
 ```kotlin
 val startValue = 1  
 val incrementValue = 1  
 val flowable = Flowable.generate(Callable { startValue }, BiFunction { s: Int, emitter: Emitter<Int?> ->  
    val nextValue = s + incrementValue  
    emitter.onNext(nextValue)  
    nextValue  
 })  
 flowable.subscribe { value: Int? -> println(value) }
 ```
 
### .create() -  (should NOT use in RX_Java1 )
   Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
  When subscribed to by a consumer, runs an user-provided function and provides a type-specific `Emitter` for this function to generate the signal(s) the designated business logic requires. This method allows bridging the non-reactive, usually listener/callback-style world, with the reactive world.
  ```kotlin
 val executor: ScheduledExecutorService = Executors.newSingleThreadScheduledExecutor()  
 val handler = ObservableOnSubscribe { emitter: ObservableEmitter<String?> ->  
 val future: Future<Any?> = executor.schedule<Any?>({  
        emitter.onNext("Hello")  
        emitter.onNext("World")  
        emitter.onNext("from")  
        emitter.onNext(".create()")  
        emitter.onComplete()  
        null  
    }, 1, TimeUnit.SECONDS)  
    emitter.setCancellable { future.cancel(false) }  
 }  
  
 Observable.create(handler)  
	  .subscribe({ item -> System.out.println(item) },  
	    { error -> error.printStackTrace() }) { println("Done") }  
  
 Thread.sleep(2000)  
 executor.shutdown()
  ```
### .defer()
### .range() - emits only `Integer`
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.range(0, "greeting".length)  
    .map { index -> "greeting".toCharArray()[index] }  
    .subscribe({ println(it) })
 ```
 
### .interval() - periodically emits an infinite, ever increasing numbers (of type `Long`)
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.interval(1, TimeUnit.SECONDS)  
    .subscribe { time ->  
    if (time % 2 == 0L) {  
        println("Tick")  
    } else {  
        println("Tock")  
    }  
}
```
### .timer() -
### .empty() - signals completion immediately upon subscription.
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
```kotlin
Observable.empty<Int>()  
    .subscribe(  
        { println("This should NEVER be printed") },  
        { println("Or this") },  
        { println("Done will be printed") })
```
### .never() - nothing will happen
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
  ```kotlin
 Observable.never<Int>()  
    .subscribe(  
        { println("This should NEVER be printed") },  
        { println("Or this") },  
        { println("This neither!") })
  ```
### .error() - 
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
  ```kotlin
 Observable.error<Int>()  
    .subscribe(  
        { println("This should NEVER be printed") },  
        { e -> e.printStackTrace() },  
        { println("This neither!") })
  ```

# Создание путем объединения
[Документация](https://github.com/ReactiveX/RxJava/wiki/Combining-Observables)
### .merge() - добавит второй поток в конец (после onComplete?) первого
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124320.png]] `Completable`
```kotlin
Observable.just(1, 2, 3)
    .mergeWith(Observable.just(4, 5, 6))
    .subscribe(System.out::print) 
// prints: 123456

val observable1 = Observable.error(new IllegalArgumentException(""))
val observable2 = Observable.just("Four", "Five", "Six")
Observable.mergeDelayError(observable1, observable2)
	.subscribe(System.out::print) 
// emits 4, 5, 6 and then the IllegalArgumentException	
```
### .combineLatest() - 
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
val newsRefreshes = Observable.interval(100, TimeUnit.MILLISECONDS)
val weatherRefreshes = Observable.interval(50, TimeUnit.MILLISECONDS)
Observable.combineLatest(newsRefreshes, weatherRefreshes) { newsRefreshes, weatherRefreshes -> 
		"Refreshed news " + newsRefreshTimes + " times and weather " + weatherRefreshTimes }
	.subscribe(System.out::print) 
// prints:
// Refreshed news 0 times and weather 0
// Refreshed news 0 times and weather 1
// Refreshed news 0 times and weather 2
// Refreshed news 1 times and weather 2
// Refreshed news 1 times and weather 3
// Refreshed news 1 times and weather 4
// Refreshed news 2 times and weather 4
// Refreshed news 2 times and weather 5
// ...
```
