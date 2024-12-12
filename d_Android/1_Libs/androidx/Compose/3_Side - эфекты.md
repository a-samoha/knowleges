
Pure function  -  при одних и тех же входных данных, получаем один и тот же результат.

**ВАЖНО!!!**
	- ВСЕ, что НЕ связано с преобразованием данных в UI - это side - эфекты
	- напр. лямбда Button ( onClick = {} ) это LaunchedEffect {} (side-эфект)
	
- [[#Side Effect]]
- [[#LaunchedEffect - для suspend]]
- [[#DisposableEffect - аналог LaunchedEffect для callback]]
- [[1_Lifecycle#derivedStateOf{}|derivedStateOf]]
- snapshotFlow
- rememberUpdateState
- rememberCoroutineScope

### @Composable 
	- цель такой функции преобразовать данные в UI 
	- ВСЕ, что НЕ связано с переделкой данных в UI - это side - эфекты
	- Compose следит за подписантами на State
	- если есть подписавшиеся - будет рекомпозиция.
	 напр.:
```kotlin
@Composable
fun KataScreen(){
	var state by rememberSaveable { mutableIntStateOf(1) } // state будет менять клик по кнопке
	
	// подписка на State здесь будет провоцировать рекомпозицию!!!
	printLn("AAA - counter $state")
	
	Text(
		text = "123"    // хотя Text НЕ зависит от state (знач. всегда одно и то же) и рекомпозиция НЕ нужна   
						// все равно будет происходить рекомпозиция!!!
						// потому что мы подписались в printLn
	)
}
```

### Side Effect  
	- ВСЕ, что НЕ связано с преобразованием данных в UI - это side - эфекты
	- напр.:
		- передавать данные во ViewModel нужно в side-эфект;
		- выводить State в логи нужно в SideEffect:
```kotlin
/**
* лямбда SideEffect говорит фреймворку Composе
* что этот код хотя и зависит от State,
* но НЕ должен тригерить рекомпозицию !!!
* и сам код SideEffect выполняться НЕ будет пока не произойдет рекомпозиция !!!
* 
* таким образом:
* SideEffect позволяет внутри @Composable выполнять обычные функции:
* подписавшиеся (зависящие от) на State НО НЕ влияющие на UI !!!
* 
* код SideEffect выполняется ПОСЛЕ рекомпозиции!!!
*/
@Composable
fun KataScreen(){
	var state by rememberSaveable { mutableIntStateOf(1) }
	
	// подписка на State здесь напр. printLn("AAA - counter $state")
	// будет провоцировать рекомпозицию
	// НО нам этого НЕ нужно
	// поэтому используем SideEffect:	
	SideEffect {  
		// теперь printLn будет выполняться только если Text будет зависить от state!!!
		printLn("AAA - counter $state")
		// выполняется ПОСЛЕ рекомпозиции!!!
	}
	
	Text(
		text = "$state" // если закоментировать эту строку - 
						// рекомпозиция происходить НЕ будет!!!
						// потому, что SideEffect скрывает зависимость printLn от State 
						// и Composе думает, что никто НЕ зависит от State
	)
}
```

### LaunchedEffect  -   для suspend
	- Принимает КЛЮЧ как параметр !!! 
	- Если в ключ передать константу 
			- LaunchedEffect запустится 1 раз и
			- будет жить до уничтожения композиции, БЕЗ перезапуска
	- При каждом изменении ключа (напр. если ключ это state)
			- LaunchedEffect перезапустится (будет похоже на SideEffect)
	напр.:
```kotlin
@Composable
fun KataScreen(){
	var state by rememberSaveable { mutableIntStateOf(1) }
	
	// передаем в ключ константу "0"
	LaunchedEffect(0) {  // выполнится 1 раз при первой композиции!!!
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
		// ловим ошибку CancellationException, 
		// которая выбрасывается при завершении LaunchedEffect
		// т.е. логируем завершение side-эфект
		} catch(e: CancellationException) { 
			println("AAA cancelled")
			throw e
		}
	}
}
```

 **ВАЖНО!!!**
 если LaunchedEffect описать внутри блока зависящего от State 
 он будет перезапускаться при каждом изменении выполнении условия:
 ```kotlin
 @Composable
fun KataScreen(state: KataState){

	// передаем в ключ константу "0"
	LaunchedEffect(0) {  // выполнится 1 раз!!!
		printLn("AAA - counter $state)
	}
	
	if(state % 4 < 2){
		LaunchedEffect(0) {  // выполнится МНОГО раз!!!
			// при каждом выполнении условия
			printLn("AAA - counter $state)
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

### derivedStateOf{}  - генерация промежуточного стейт на основе originState
	- выполняется при КАЖДОМ изменении originState
	- выполняется ПЕРЕД рекомпозицией
```kotlin
@Composable
fun KataScreen(){
	
	val transformedValue by remember{
		derivedStateOf{ 
			// этот блок будет выполняться при КАЖДОМ изменении originState
			// этот блок выполняется ПЕРЕД рекомпозицией 
			// потому, что здесь мы сами тригерим рекомпозицию
			// посредством возврата нужного нам значения. напр.: 
			originState / 3 
			// этот код возвращает 
				// при 0/3 -> 0
				// при 1/3 -> 0 как мы помним 
				// при 2/3 -> 0 StateFlow НЕ эмитит (игнорирует) одинаковыйе значения
				// при 3/3 -> 1 Здесь произойдет новый эмит который стригерит рекомпозицию
				// при 4/3 -> 1 StateFlow снова проигнорирует знаечение и рекомпозиции НЕ будет
		}
	}
}
```

### snapshotFlow {} - мапит стейт в новый Flow
	- функция обратная к 
		"collectAsState()" которая преобразовывает Flow в State
		а "snapshotFlow { state }" - слушает State и ємитит во Flow (который вернула)

Если обернуть snapshotFlow в LaunchedEffect
можно слушать изменения State без произошедшей рекомпозиции:
 ```kotlin
 @Composable
fun KataScreen(state: KataState){
	
	if(state % 4 < 2){
		LaunchedEffect(0) {  // выполнится МНОГО раз!!!
			// при каждом выполнении условия
			printLn("AAA launched")
			
			try {
				snapshotFlow{state}
				.collect{
					// пока будет выполняться условие
					// корутина LaunchedEffect будет жить
					// и мы сможем слушать изменения State
					// даже если рекомпозиция не происходила
					printLn("AAA - counter $state)
				}
				
			// ловим ошибку CancellationException, 
			// которая выбрасывается при завершении LaunchedEffect
			// т.е. логируем завершение side-эфект
			} catch(e: CancellationException) { 
				println("AAA cancelled")
				throw e
			}
		}
	}
}
```
