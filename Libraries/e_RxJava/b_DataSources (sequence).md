#rx_Java 

###### Важно
- The ***sequence*** (Stream) **sends items** to the _observer_ **one at a time**. 
- The  ***observer*  handles  each  one  before  processing the next one**. 
-  If many events come in asynchronously, they must be stored in a queue or dropped.

-   ***Non-Blocking*** – asynchronous execution is supported and is allowed to unsubscribe at any point in the event stream.
-   ***Blocking*** – all _onNext_ observer calls will be synchronous, and it is not possible to unsubscribe in the middle of an event stream. We can always convert an _Observable_ into a _Blocking Observable_, using the method _toBlocking:_   /   все вызовы наблюдателя onNext будут синхронными, и отписаться в середине потока событий невозможно.

**Холодная подписка** (телевизор)  - поток живет НО НЕ эмитит, пока на него не подпишутся.
**Горячая подписка**         (окно)       - поток живет и эмитит данные, и к нему можно подписаться в любой момент.

`onComplete() / onError()`  -  **терминальные события** (больше мы не получим никаких событий от источника.)
**Observable** vs **Flowable** 
 - Оба генерируют от нуля до n элементов. 
 - Оба могут завершаться успешно или с ошибкой. 
 - Так зачем нам два разных типа для представления одной и той же структуры данных?


## Observable
- **НЕ поддерживает BACKPRESSURE** 
	(желательно использовать для обработки кликов потому, что этот источник данных не возможно задержать).
- **Описывает будущий источник данных**
	пока на него не подпишутся, экземпляр даже не создается (ничего не эмитит).
- **Действия:**
	- [**создать**](c_Creation.md) (.just(), .fromArray(), .create(), .defer(), .range(), .timer(), .empty(), .error(), .never())
	- [**преобразовать**](d_Operators.md) (.map(), .flatmap(), .scan(), .filter(), .groupBy())
	- [**подписаться**](e_Subscription.md) (.subscribe(), .blockingSubscribe())

детали
 [Список операторов](https://reactivex.io/documentation/observable.html)
 ***Observer***    -  интерфейс для подписчиски на Observable
 ```kotlin
 interface Observer<T> { 
	fun onNext(T t)
	fun onComplete()
	fun onError(Throwable t)
	fun onSubscribe(Disposable d)
 }
 ```
 ***Disposable***     -  интерфейс. то что может быть уничтожено.
 ```kotlin
 interface Disposable { 
	fun dispose()   // «Я закончил работать с этим ресурсом, мне больше не нужны данные».
					// Если у вас есть сетевой запрос, то он может быть отменён. 
					// Если вы прослушивали бесконечный поток нажатий кнопок, то это будет означать, 
					// что вы больше не хотите получать эти события, 
					// в таком случае можно удалить `OnClickListener` у `View`.
 }
 ```

## Flowable        
- **С поддержкой [BACKPRESSURE](https://habr.com/ru/post/512724/)**
	(замедляет работу источника данных, например позволяет "притормозить" запрос в БД)
- **Описывает будущий источник данных**
	пока на него не подпишутся, экземпляр даже не создается (ничего не эмитит).
- **Действия:**
	- [**создать**](c_Creation.md) (.just(), .fromArray(), .create(), .defer(), .range(), .timer(), .empty(), .error(), .never())
	- [**преобразовать**](d_Operators.md) (.map(), .flatmap(), .scan(), .filter(), .groupBy())
	- [**подписаться**](e_Subscription.md) (.subscribe(), .blockingSubscribe())

детали
 ***Subscriber***    -  интерфейс для подписчиски на Flowable
 ```kotlin
 interface Subscriber<T> { 
	fun onNext(T t)
	fun onComplete()
	fun onError(Throwable t)
	fun onSubscribe(Subscription s)
 }
 ```
 **Subscription**
 ```kotlin
 interface Subscription { 
	fun cancel()         // работает аналогично методу dispose
	fun request(long r)  // посредством этого метода `backpressure` проявляется в API.
						 // c помощью этого метода мы говорим `Flowable`, что нам нужно больше элементов.
 }
 ```
 
 Почему типы `Disposable` и `Subscription` имеют разные названия, как и их методы — `dispose()` и `cancel()`. Почему нельзя было просто расширить один другим, добавив метод `request()`? Всё дело в спецификации реактивных потоков. Она является результатом инициативы ряда компаний, которые собрались вместе и решили выработать стандартный набор интерфейсов для реактивных библиотек Java. В спецификацию вошло четыре интерфейса
 ```kotlin
 interface Publisher<T> { 
	fun subscribe(Subscriber<? super T> s)
 }

 interface Subscriber<T> { 
	fun onNext(T t)
	fun onComplete()
	fun onError(Throwable t)
	fun onSubscribe(Subscription s)
 }

 interface Subscription { 
	fun request(long n) 
	fun cancel()
 }

 interface Processor<T, R>: Subscriber<T>, Publisher<R> { }
 ```

## Single, Completable, Maybe (три специализированных источника)
	НЕ поддерживают BACKPRESSURE 

###### *Single*
**Либо содержит один элемент, либо выдаёт ошибку**, так что это не столько последовательность элементов, сколько потенциально асинхронный источник одиночного элемента. *Можно представлять его как обычный метод.* Вы вызываете метод и получаете возвращаемое значение; либо метод бросает исключение. Именно эту схему реализует `Single`. Вы на него подписываетесь и получаете либо элемент, либо ошибку. Но при этом `Single` является реактивным.
 
###### *Completable*
Похож на void-метод. **Либо успешно завершает работу без каких-либо данных, либо бросает исключение.** То есть это некий кусок кода, который можно запустить, и он либо успешно выполнится, либо завершится co сбоем.

###### *Maybe*
**Либо содержит элемент, либо выдает ошибку, либо не содержит данных** — этакий реактивный Optional. 


[[c_Creation]]