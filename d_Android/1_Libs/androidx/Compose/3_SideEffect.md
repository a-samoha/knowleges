
Pure function  -  при одних и тех же входных данных, получаем один и тот же результат.

- [[#Side Effect]]
- [[#LaunchedEffect - для suspend]]
- [[#DisposableEffect - аналог LaunchedEffect для callback]]
- [[1_Lifecycle#derivedStateOf{}|derivedStateOf]]
- snapshotFlow
- rememberUpdateState
- rememberCoroutineScope

### @Composable 
	-  цель такой функции преобразовать данные в UI
	- Compose следит за подписантами на State
	- если естьподписавшиеся - будет рекомпозиция.
	- напр.:
```kotlin
@Composable
fun KataScreen(){
	var state by rememberSaveable { mutableIntStateOf(1) }
	
	// подписка здесь будет провоцировать рекомпозицию!!!
	printLn("AAA - counter $state")
	
	Text(
		text = "$state" // даже если закоментировать эту строку - 
						// все равно будет происходить рекомпозиция!!!
						// потому что мы подписались в printLn
	)
}
```

### Side Effect  
	- позволяет внутри @Composable выполнять обычные функции:
	- НЕ влияющие на UI но 
	- подписавшиеся (зависящие от) на State 
	- напр.:
```kotlin
@Composable
fun KataScreen(){
	var state by rememberSaveable { mutableIntStateOf(1) }
	
	// теперь код будет выполняться только если Text будет зависить от state!!!
	SideEffect {  // код выполняется ПОСЛЕ рекомпозиции!!!
		printLn("AAA - counter $state")
	}
	
	Text(
		text = "$state" // если закоментировать эту строку - 
						// рекомпозиция происходить НЕ будет!!!
						// потому что никто НЕ зависит от state
	)
}
```

### LaunchedEffect  -   для suspend
	- МОЖНО запускать SUSPEND ()
	- Использует КЛЮЧ! 
	- При изменении значения ключа (напр. если ключ это state) - перезапуск (как SideEffect)
	- Если в ключ передать константу - suspend живет до уничтожения компонента, БЕЗ перезапуска
	- напр.:
```kotlin
@Composable
fun KataScreen(){
	var state by rememberSaveable { mutableIntStateOf(1) }
	
	if(state )
	// передаем в ключ константу
	LaunchedEffect(0) {  // выполнится 1 раз!!!
		printLn("AAA - counter $state)
	}
---------------------------------------------------------------------------------
	// передаем в ключ изменяемое знач.
	LaunchedEffect(state) {  // выполнится при каждой смене ключа!!!
		printLn("AAA launched")
		try {
			while (true) {
				delay(1000)  // SUSPEND
				println("AAA Hello - ${Random.nextInt(100)}")
			}
		} catch(e: CancellationException) {
			println("AAA cancelled")
			throw e
		}
	}
}
```

### DisposableEffect  -  аналог LaunchedEffect для callback
	- КЛЮЧ работает аналогично LaunchedEffect
	- НЕЛЬЗЯ запускать suspend()
	- есть функция onDispose()
```kotlin
@Composable
fun KataScreen(){
	var state by rememberSaveable { mutableIntStateOf(1) }
	
	// передаем в ключ изменяемое знач.
	DisposableEffect(state) {  // выполнится при каждой смене ключа!!!
		printLn("AAA launched")
		kotlin.concurrent.timer(period = 1000L){
			println("AAA Hello - ${Random.nextInt(100)}")
		}
		onDispose {
			println("AAA cancelled")
			timer.cancel()
		}
	}
}
```