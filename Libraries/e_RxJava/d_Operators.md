#rx_Java 
# Преобразование
[Документация javadoc](http://reactivex.io/RxJava/3.x/javadoc/index-all.html#I:O)
[Документация GitHub](https://github.com/ReactiveX/RxJava/wiki/Transforming-Observables)
### .map{} - applies the `fun` to each item and emits the results.
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.range(0, 10)
	.map{ it*it }
    .subscribe(){ println("$it") }
```
### .flatMap{} - требует создания новой цепочки
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
Принимает на вход эмит одного **Observable** , a возвращает эмит, излучаемый другим **Observable**, подменяя таким образом один **Observable** на другой. 
Порядок исходящих элементов НЕ поддерживается. Полезен если порядок выполнения не важен, но нужно единовременное выполнение.

Используем для создания новой цепочки которая будет использовать данные из первой цепочки. 
Напр.: "Первая цепочка Single - результат запроса который отправил токен, и получил userID, 
				Bторую цепочку создаем в flatMap и отправляем тяжелый запрос на все данные по юзеру
				если первый запрос упал или вернулась ошибка (юзер не найден) - второй запрос не запустится"

```kotlin
val userData(): DataClassUser = repository.getUserID("some-token")
	.flatMap{ userID -> 
		repository.getUserData("userID") // вернет Single.just(DataClassUser("Artem","Samoshkin"))
	}
    .subscribe(){ println("$it") }

// если нужно использовать данные из первого потока в третьем
val a = Observable.just("A", "B", "C")  
                .flatMap { a ->  
                    Observable.intervalRange(1, 3, 0, 1, TimeUnit.SECONDS)  
                        .map { b: Long -> "($a, $b)" }  
                        //.flatMap {  } // так можно только если третьему потоку нужно данные из первого потока (переменной "а")  
                        .map { Pair(a, it) }  // так нужно делать в промышленной разработке: 
                }                
                .flatMap { (a, b) ->  
                    a // данные из первого потока  
                    b // данные из второго потока  
                    Observable.just("$a")  
                }  
                .subscribe() { println(it) }
```
	.flatMapSingle - требует создания Single потока 
	.flatMapCompletable
	.flatMapObservable
	.flatMapIterable
	.flatMapMaybe
	.flatMapSingleElement - (только у Maybe)
	.flatMapPublisher - возвращает Flowable (только у Single и Maybe)
### .concatMap{} - как `flatMap` + поддерживает порядок эмиссии данных 
 Технически данный оператор выдает похожий с **FlatMap()** результат, но учитывается последовательность эмитов. 
 Поддерживает порядок эмиссии данных и ожидает исполнения текущего **Observable.** 
 Но!!! ВАЖНО выполнение **ConcatMap()** занимает больше времени чем **FlatMap().** (при больших объемах НЕ ПРОСТИТЕЛЬНО)
### .switchMap{} - кардинально отличается от `flatMap` и `concatMap`
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
Кардинально отличается от **FlatMap()** и **ConcatMap()**. Он подходит, если нужно проигнорировать промежуточные результаты и рассмотреть последний. 
Аналогичен flow{}.flatMapLatest{}
пример: Предположим, вы пишете приложение мгновенного поиска, которое отправляет поисковый запрос на сервер каждый раз, когда пользователь что-то вводит в поисковой строке. Пользователь быстро набирает несколько символов. При наборе каждого символа будет отправляться на сервер запрос с дополненной строкой на один символ. Благодаря **SwitchMap()** мы можем показать результат только последнего набранного запроса.
### .scan{}
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
 Observable.just(5, 3, 8, 1, 7)
    .scan(0) { partialSum: Int, x: Int -> partialSum + x }
    .subscribe(System.out::println)
    
// prints:
// 0
// 5
// 8
// 16
// 17
// 24
 ```
### .groupBy{} - сортирует элементы по заданному критерию и выдает группу
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
 ```kotlin
 val animals = Observable.just("Tiger", "Elephant", "Cat", "Chameleon", "Frog", "Fish", "Turtle", "Flamingo")  
  
 animals.groupBy({ animal -> animal[0] }) { obj ->  
    obj.uppercase(Locale.getDefault())  
 }  
    .concatMapSingle { obj: GroupedObservable<Char, String> ->  
        obj.toList()  
    }  
    .subscribe(System.out::println)

	// prints:
// [TIGER, TURTLE]
// [ELEPHANT]
// [CAT, CHAMELEON]
// [FROG, FISH, FLAMINGO]
 ```
### .buffer{}
### .cast{}
### .window{} - проигнорирует заданный элемент (напр.: "каждый третий")
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
 ```kotlin
 Observable.range(1, 10)  
    // Create windows containing at most 2 items, and skip 3 items before starting a new window.  
    .window(2, 3)  
    .flatMapSingle { window ->  
        window.map(java.lang.String::valueOf)  
            .reduce(StringJoiner(", ", "[", "]"), StringJoiner::add) }  
    .subscribe(System.out::println)

// prints:
// [1, 2]
// [4, 5]
// [7, 8]
// [10]
 ```


### .isEmpty - вернет `Single<Boolean>`
### .contains(Any) - проверит наличие объекта в цепочке и вернет `Single<Boolean>`
# Фильтрация 
[Документация](https://github.com/ReactiveX/RxJava/wiki/Filtering-Observables)
### .filter{} - filters items that satisfy a specified predicate
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.just(1, 2, 3, 4, 5, 6)
    .filter{ x -> x % 2 == 0 }
    .subscribe(System.out::print) // prints: 246
```
### .first() - returns first emitted element or ...
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.just("A", "B", "C")
    .first("D")        // Emits the first item, or default value (e.g.: "D")
    // .firstElement() // Emits the first item, or just completes if the source completes without emitting.
    // .firstOrError() // Emits the first item, or error if the source completes without emitting.
    .subscribe(System.out::print) // prints: A
```
![[Pasted image 20231011211339.png]]
### .last() - returns last emitted element or ...
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.just("A", "B", "C")
    .last("D")        // Emits the first item, or default value (e.g.: "D")
    // .lastElement() // Emits the first item, or just completes if the source completes without emitting.
    // .lastOrError() // Emits the first item, or error if the source completes without emitting.
    .subscribe(System.out::print) // prints: C
```
### .distinct() - emits items that are distinct from their immediate predecessors
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.just(2, 3, 4, 4, 2, 1)
    .distinct()
    .subscribe(System.out::print) // prints: 2341

Observable.just(1, 1, 2, 1, 2, 3, 3, 4)
    .distinctUntilChanged()
    .subscribe(System.out::println) // prints: 121234
```
### .skip() - throw out several items from the chain
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)  
    .skip(4)  // first 4 items will be skiped
	.subscribe(System.out::println) // print 5 6 7 8 9 10
  ```
 ### .skipLast()
   Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)  
    .skipLast(4)  // last 4 items will be skiped
	.subscribe(System.out::println) // print 1 2 3 4 5 6
  ```
 ### .skipUntil()
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)
	.doOnNext{ Thread.sleep(1000) }
    .skipUntil(Observable.timer(3, TimeUnit.SECONDS))
    .subscribe(System.out::println) // print 3 4 5 6 7 8 9 10
  ```
 ### .skipWhile()
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)  
    .skipWhile{ next -> next < 5 }  
	.subscribe(System.out::println) // print 5 6 7 8 9 10
  ```
### .take() - throw out several items from the chain
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)  
    .take(4)  // first 4 items will be taken
	.subscribe(System.out::println) // print 1 2 3 4
  ```
 ### .takeLast()
   Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)  
    .takeLast(4)  // last 4 items will be taken
	.subscribe(System.out::println) // print 7 8 9 10
  ```
   ### .takeUntil()
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)
	.doOnNext{ Thread.sleep(1000) }
    .takeUntil(Observable.timer(3, TimeUnit.SECONDS))
    .subscribe(System.out::print) // print 1 2
  ```
 ### .takeWhile()
  Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
  ```kotlin
  Observable.range(1, 10)  
    .takeWhile{ next -> next < 5 }  
	.subscribe(System.out::println) // print 1 2 3 4 
  ```
### .sample()
### .timeout()
# Объединение 
[Документация](https://github.com/ReactiveX/RxJava/wiki/Combining-Observables)
### .zip() - объединит 2 потока согласно указанному условию (после onComplete?)
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124320.png]] `Maybe`,  ![[Pasted image 20220704124320.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
val firstNames =  Observable.just("James", "Jean-Luc", "Benjamin")
val lastNames = Observable.just("Kirk", "Picard", "Sisko")
firstNames.zipWith(lastNames) { first, last -> first + " " + last }
	.subscribe(System.out::print) 
// emits "James Kirk" "Jean-Luc Picard" "Benjamin Sisko"
```
### .join() - `НЕ ПОНИМАЮ`
[Документация](https://reactivex.io/documentation/operators/join.html)

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
### .startWith() - добавит в начало потока указанный элемент
 Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
Observable.just("Spock ", "McCoy ")
    .startWith("Kirk ")
    .subscribe(System.out::print) // prints: Kirk Spock McCoy
```
### .switchOnNext()
Available in: ![[Pasted image 20220704124320.png]] `Flowable`, ![[Pasted image 20220704124320.png]] `Observable`,  ![[Pasted image 20220704124454.png]] `Maybe`,  ![[Pasted image 20220704124454.png]] `Single`, ![[Pasted image 20220704124454.png]] `Completable`
```kotlin
val timeIntervals = Observable.interval(1, TimeUnit.SECONDS)
	.map{ticks -> 
		Observable.interval(100, TimeUnit.MILLISECONDS)
			.map{innerInterval -> 
				"outer: " + ticks + " - inner: " + innerInterval}}

Observable.switchOnNext(timeIntervals)
	.subscribe(System.out::print) 
	
// outer: 0 - inner: 0
// outer: 0 - inner: 1
// outer: 0 - inner: 2
// outer: 0 - inner: 3
// outer: 0 - inner: 4
// outer: 0 - inner: 5
// outer: 0 - inner: 6
// outer: 0 - inner: 7
// outer: 0 - inner: 8
// outer: 1 - inner: 0
// outer: 1 - inner: 1
// outer: 1 - inner: 2
// outer: 1 - inner: 3
// ...
```
### .combineLatest() 
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
# Утилиты 
-   `observeOn`   — specify on which Scheduler a Subscriber should observe the Observable  
-   `subscribeOn` — specify which Scheduler an Observable should use when its subscription is invoked  

-   `onNext()`    —    генерируем новый эмит
-   `onErrorComplete()`   —    проглатываем ошибку и завершаем поток как будто закончились эмиты:
```kotlin
Observable<Integer> numbers = Observable.create(emitter -> {
    emitter.onNext(1);
    emitter.onNext(2);
    emitter.onError(new RuntimeException("Something went wrong"));
    emitter.onNext(3);
    emitter.onComplete();
});

numbers
    .onErrorComplete(throwable -> throwable instanceof RuntimeException)
    .subscribe(
        item -> System.out.println("Received: " + item),
        throwable -> System.out.println("Error: " + throwable),
        () -> System.out.println("Completed")
    );

// "Received: 1"
// "Received: 2"
// "Completed". Ошибка не будет передана в onError обработчик.
```

-   `doOnEach`    — register an action to take whenever an Observable emits an item  
-   `doOnNext`    — register an action to call just before the Observable passes an `onNext` event along to its downstream  
-   `doAfterNext` — register an action to call after the Observable has passed an `onNext` event along to its downstream  
-   `doOnCompleted`   — register an action to take when an Observable completes successfully  
-   `doOnError`   — register an action to take when an Observable completes with an error  
-   `doOnTerminate`   — register an action to call just before an Observable terminates, either successfully or with an error  
-   `doAfterTerminate`    — register an action to call just after an Observable terminated, either successfully or with an error  
-   `doOnSubscribe`   — register an action to take when an observer subscribes to an Observable  
-   `doOnUnsubscribe` — register an action to take when an observer unsubscribes from an Observable  
-   `finallyDo`   — register an action to take when an Observable completes  
-   `doFinally`   — register an action to call when an Observable terminates or it gets disposed  

-   `delay`   — shift the emissions from an Observable forward in time by a specified amount  
-   `delaySubscription`  — hold an Subscriber's subscription request for a specified amount of time before passing it on to the source Observable  

-   `single`  — if the Observable completes after emitting a single item, return that item, otherwise throw an exception  
	![[Pasted image 20231011211339.png]]
-   `singleOrDefault`  if the Observable completes after emitting a single item, return that item, otherwise return a default item  

-   `timestamp`   — attach a timestamp to every item emitted by an Observable  

-   `timeInterval`    — emit the time lapsed between consecutive emissions of a source Observable  
-   `using`   — create a disposable resource that has the same lifespan as an Observable  
-   `repeat`  — create an Observable that emits a particular item or sequence of items repeatedly  
-   `repeatWhen`  — create an Observable that emits a particular item or sequence of items repeatedly, depending on the emissions of a second Observable
-   `materialize( )` — convert an Observable into a list of Notifications
-   `dematerialize`   — convert a materialized Observable back into its non-materialized form  
-   `serialize`   — force an Observable to make serialized calls and to be well-behaved  
-   `cache`   — remember the sequence of items emitted by the Observable and emit the same sequence to future Subscribers 
