
```kotlin
var amount = 0

val timer = kotlin.concurrent.timer(period = 1000L){
	// do some periodical code
	amount++
}

if(amount >= 5){
	timer.cancel() // останавливаем таймер, если досчитали до "5"
}
```


