#rx_Java 
## **Подписка**
```kotlin
class someViewModel(observeDataUseCase: ObserveDataUseCase){
	init{
		observeDataUseCase  
		    .observeData()  
		    .map(::mapFetchResultToListNotifications)  
		    .subscribeOn(Schedulers.io())  
		    .observeOn(AndroidSchedulers.mainThread())  
		    .subscribeBy(Throwable::printStackTrace) {  
		        notifications.value = it  
		    }    
		    .addToDisposable()
	}	
}
```
- Цепочка (Observable и т.д.) не существует, пока на нее не сделали подписку. (Существовать будет только Subject)
	- Холодная подписка (Observable и т.д.)
	- Горячая подписка (Subject)

 ```java
 public static void hello(String... args) {
  Flowable.fromArray(args).subscribe(s -> System.out.println("Hello " + s + "!"));
 }

 // If your platform doesn't support Java 8 lambdas (yet), 
 // you have to create an inner class of `Consumer` manually:
 public static void hello(String... args) {
  Flowable.fromArray(args).subscribe(new Consumer<String>() {
      @Override
      public void accept(String s) {
          System.out.println("Hello " + s + "!");
      }
  });
 }
 ```
## **Schedulers**
**`AndroidSchedulers.mainThread()`** - 
Schedulers **`.io( )`** -  by default is a `CachedThreadScheduler`, which is something like a new thread scheduler with thread caching
Schedulers **`.computation( )`** - for ordinary computational work,  such as event-loops and callback processing; do not use this scheduler for I/O.
	 The number of threads, by default, is equal to the number of processors.
Schedulers **`.newThread( )`** -  creates a new thread for each unit of work
Schedulers **`.immediate( )`** - begin immediately in the current thread
Schedulers **`.from(executor)`** - 
Schedulers **`.trampoline( )`** - begin on the current thread after any already-queued (стоит в очереди) work удоно использовать в юнит тестах 
## **Операторы**
**`.subscribeOn()`** - указывает в каком потоке **начнет** работать Observable, **независимо** от того, в какой точке цепочки он вызывается .
**`.observeOn()`** - указывает планировщик, который Observable будет использовать для отправки уведомлений своим наблюдателям.
 Можно вызывать несколько раз в разных точках, чтобы изменить потоки, в которых будут работать "нижние" операторы цепочки.
 ![[Pasted image 20220716123634.png]]
**`.subscribe()`** - **5 вариантов перегрузок:** **()** / (**onNext**) / (onNext, onError) / (onNext, onError, onComplete) / (**observer**)
**`.subscribeBy()`** - **Перевернутый набор параметров.** `Внутри вызывает .subscribe()`

### .blockingSubscribe()
### .blockingAwait()
### .blockingFirst()

### .delay()
### .deleySubscription()

## **Disposable**
```kotlin
open class BaseViewModel : ViewModel() {  
  
    private val disposables: CompositeDisposable = CompositeDisposable()  
  
    protected infix operator fun CompositeDisposable.plus(d: Disposable) = this.add(d)  //???
  
    fun Disposable.addToDisposable() {  
        disposables.add(this)  
    }  
  
    operator fun Disposable.not() {  
        disposables.add(this)  
    }  
  
    override fun onCleared() {  // ViewModel method 
        disposables.clear()  
    }  
}
```