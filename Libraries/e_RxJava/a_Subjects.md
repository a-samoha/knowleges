#rx_Java 

###### `PublishSubject` - returns every emits AFTER the subscription
```kotlin
val result = "RESULT"
```

```kotlin
fun main(String[] args) { 
	val publishSubject = PublishSubject.create<Int>()  
	publishSubject.onNext(0)  
	publishSubject.onNext(1)  
	publishSubject.onNext(2)  
	publishSubject.subscribe { println(result + "$it, ") }  
	publishSubject.onNext(3)  
	publishSubject.onNext(4)  
	publishSubject.onNext(5) // RESULT:  3, 4, 5,
}
```
###### `ReplaySubject` - returns every emits before & after the subscription
```kotlin
fun main(String[] args) { 
	val replaySubject = ReplaySubject.create<Int>()  
	replaySubject.onNext(0)  
	replaySubject.onNext(1)  
	replaySubject.onNext(2)  
	replaySubject.onNext(3)  
	replaySubject.subscribe { println(result + "$it, ") }  
	replaySubject.onNext(4)  
	replaySubject.onNext(5) // RESULT:  0, 1, 2, 3, 4, 5,
}
```
**We can  setup the cache volume** e.g. "remember 2 last values"
```kotlin
fun main(String[] args) { 
	val replaySubject2 = ReplaySubject.createWithSize<Int>(2)
	replaySubject2.onNext(0)  
	replaySubject2.onNext(1)  
	replaySubject2.onNext(2)  
	replaySubject2.onNext(3)  
	replaySubject2.subscribe { println(result + "$it, ") }  
	replaySubject2.onNext(4)  
	replaySubject2.onNext(5) // RESULT: 2, 3, 4, 5, 
}
```
###### `BehaviourSubject` - same as ReplaySubject with size "1"
```kotlin
fun main(String[] args) { 
	// this sbjct should be created with some default value:
	val behaviourSubject = BehaviorSubject.createDefault(-1)  
	behaviourSubject.onNext(0)  
	behaviourSubject.onNext(1)  
	behaviourSubject.onNext(2)  
	behaviourSubject.onNext(3)
	behaviourSubject.subscribe { println(result + "$it, ") }   
	behaviourSubject.onNext(4)  
	behaviourSubject.onNext(5) // RESULT: 3, 4, 5,
}
```
###### `AsyncSubject` - returns only the last value exactly before onComplete
```kotlin
fun main(String[] args) { 
	val asyncSubject = AsyncSubject.create<Int>()  
	asyncSubject.onNext(0)  
	asyncSubject.onNext(1)  
	asyncSubject.onNext(2)  
	asyncSubject.subscribe { println(result + "$it, ") }  
	asyncSubject.onNext(3)  
	asyncSubject.onNext(4)  
	asyncSubject.onNext(5)  
	asyncSubject.onComplete() // RESULT:  5,
}
```
