
[Roman - (State) в Jetpack Compose, частина 1](https://www.youtube.com/watch?v=nLXjIZs3G9I&list=PLRmiL0mct8WkFdcvOCi06_64_ec3B2jvx&index=7&pp=iAQB)
выучить наизусть (ката)

**Stateful** - функция, у которой State создается, меняется и хранится внутри (снаружи его НЕ видно)
**Stateless** - НЕТ внутреннего State, он передается в параметры

**val** myState = **remember { ... }**  // внутри Composable функции
	- Эта функция выполнится при первой композиции 
	- Запомнает возвращаемое значение (объект описанный в последней строке)
	- И больше не будет менять это значение (объект) во время рекомпозиции
	- НАПР.:
		`val myState = remember { mutableStateOf(false) }`
		объект стейт сохранится и будет меняться только его внутреннее значение
		а здесь:
		`val myState = mutableStateOf(false)`
		переменная myState будет заново создаваться при каждой рекомпозиции со значением false
### Вариант со Stateful функцией

```kotlin
// импорты для вар3 с Kotlin delegation
// import androidx.compose.runtime.getValue
// import androidx.compose.runtime.setValue

data class TmpState(  // UiStateModel (domain)
	val number: Short = 0  
)  

/**
* Stateful - функция, у которой State создается, меняется и хранится внутри (снаружи его НЕ видно)
* Stateless - НЕТ внутреннего State, он передается в параметры
*  
* Flutter: StatefulWidget, StatelessWidget 
* 
* State Hoisting - поднимаем State на более высокий уровень
*/
@Preview(showSystemUi = true)  
@Composable  
fun TmpScreen() {  

	// remember{}  -  кеширует объект из лямбды при первой композиции и больше НЕ пересоздает его (при рекомпозиции)
	// rememberSaveable - сохраняет данные в Bundle (сериализация) при повороте экрана
	// rememberSaveable может принимать реализацию интерфейса Saver в которой мы должны настроить логику сериализации

	// вар1 с обычным StateFlow
	// val uiState = remember {  
	// 	  mutableStateOf(TmpState(Random.nextInt(1000).toShort()))  
	// }
	
	// вар2 "Kotlin Destruction" - це механізм мови Kotlin (синтаквичний сахар)
	// val (value, setValue) = remember {  
	//    mutableStateOf(TmpState(Random.nextInt(1000).toShort()))  
	// } 
	
	// вар3 с "Kotlin Delegation" - це механізм мови Kotlin (синтаквичний сахар)
	// ВЫУЧИ Kotlin delegation & destruction
	// var uiState by remember {  
	//    mutableStateOf(TmpState(Random.nextInt(1000).toShort()))  
	// }
	  
	Column(
		verticalArrangement = Arrangement.Center,  
		horizontalAlignment = BiasAlignment.Horizontal(0.5f),  
		modifier = Modifier.fillMaxSize(),
	) {  
		Text(
			// вар1  
			// text = uiState.value.number.toString(),  
			
			// вар2  
			// text = value.number.toString(),
			
			// вар3
			// text = uiState.number.toString(),
			fontSize = 60.sp,  
			fontWeight = FontWeight.Bold,  
			fontFamily = FontFamily.Monospace,
		)  
		Spacer(modifier = Modifier.height(12.dp))  
		Button(onClick = {  
			// вар1
			// val newVal = (uiState.value.number + 1).toShort()  
			// uiState.value = uiState.value.copy(number = newVal)
			
			// вар2
			// val newVal = (value.number + 1).toShort()  
			// setValue(value.copy(number = newVal))
			
			// вар3
			// val newVal = (uiState.number + 1).toShort()
			// uiState = uiState.copy(number = newVal)
		}) {  
			Text(text = "Increment", fontSize = 18.sp)  
		}  
	}  
}
```

### derivedStateOf{} 
**ВАЖНО!**	 - используем когда нужно реагировать **НЕ** на все обновления State
	- НАПР.: "**Активировать кнопку LOG IN только при вводе валидного логина и пароля**" (проверяя при этом каждый ввод)
	- это посредник между родительским стейтом и одной из фаз рендеринга

**БЕЗ** derivedStateOf:
```kotlin
// в данном кейсе 
// originState меняется при каждом клике
// Layout Phase выполняется (1 раз в 3 смены originState)
// HO Recomposition Phase ТАКЖЕ выполняется
//       при каждом изменении "transformedValue" (1 раз в 3 смены originState)
val transformedValue = counterValue/3

Text(
	text = "test",
	modifier = Modifier
		// .offset{} выполняется на LayoutPhase фазе
		//  поэтому Composition Phase и Drawing Phase пропускаются
		.offset{ IntOffset(x=0, y = 20 * transformedValue) }
)```

**используем** derivedStateOf:
```kotlin
// в данном кейсе 
// Layout Phase выполняется (1 раз в 3 смены originState)
// а Recomposition Phase НЕ выполняется (только 1 раз при первой композиции)
val transformedValue by remember{
	derivedStateOf{ originState/3 }
}

Text(
	text = "test",
	modifier = Modifier
		// .offset{} выполняется на LayoutPhase фазе
		//  поэтому Composition Phase и Drawing Phase пропускаются
		.offset{ IntOffset(x=0, y = 20 * transformedValue) }
)
```

### Вариант со Stateless функцией
```kotlin
@Composable
fun HomeScreen(userService: UserService = UserService.get()){ // .get() это функция синглтона object
	val userListState by userService.getUsers()
		.collectAsStateWithLifecycle()
}
```

## rememberSaveable 
- сохраняет данные в Bundle (сериализация) и переживает поворот екрана

### Класс TmpState  делаем Serializable 
```kotlin
data class TmpState(  
	var number: Short = 0  
) : Serializable
```

### Поскольку Bundle НЕ резиновый делаем Parcelable
```kotlin
plugins{
	...
	id("kotlin-parcelize")
}

... 

@Parcelize
data class TmpState(  
	var number: Short = 0  
) : Parcelable
```

### Используем Saver 
**(когда в Bundle прячем только идентификаторы картинок или имена файлов, а НЕ сами файлы)**

```kotlin
data class CheckableItem(
	val title: String,
	val isChecked: MutableState<Boolean>,
)

data class CheckBoxesState(
	val checkableItems: List<CheckableItem>,
){
	
	companion object {
		val Saver: Saver<CheckBoxesState, *> = Saver(
			save = { state: CheckBoxesState -> 
				ParcelableCheckboxesState(
					checkedItems = state.checkableItems.map{
						ParcelableCheckableItem(
							it.title,
							it.isChecked.value,
						)
					}
				)
			},
			restore = { state: ParcelableCheckboxesState -> 
				CheckBoxesState(
					checkableItems = state.checkedItems.map{
						CheckableItem(
							it.title,
							mutableStateOf(it.isChecked)
						)
					}
				)
			}
		)
	}
}

@Parcelize
data class ParcelableCheckableItem(
	val title: String,
	val isChecked: Boolean,
) : Parcelable

@Parcelize
data class ParcelableCheckboxesState(  
	val checkedItems: List<ParcelableCheckableItem>
) : Parcelable

@Composable  
fun TmpScreen() {  
	val uiState = rememberSaveable(
		saver = CheckBoxesState.Saver
	){
		CheckBoxesState( ... )
	}
}

```


## [NECO - Compose | States | #5 |](https://www.youtube.com/watch?v=ztJvKbD3vQY&list=PLmjT2NFTgg1cyNFqS2ST6nTDxZH_bYjba&index=6)
```kotlin
@Composable
fun CustomScreen(initialState: Int = 0){
	
	val textState = remember{
		mutableStateOf(initialState)
	}
	
	val colorState = remember{ 
		mutableStateOf(Color.Red)
	}
	
	var isExpanded by remember{
		mutableStateOf(false)
	}
	
	Card(modifier = Modifier
		.clicable {
			// variant1
			when(textState.value++){ // сначала проверит textState => выполнит условие => увеличит значение textState
				9 -> colorState.value = Color.Blue // поэтому нужно ставить на 1 значение меньше.
			}
			// variant2
			when(++textState.value){ // сначала увеличит textState => выполнит условие
				10 -> colorState.value = Color.Blue
			}
	}
	) {
		Text(
			modifier = Modifier
				.background(colorState.value)
				.cilckable{ isExpanded = !isExpanded },
			maxLines = if(isExpanded) 10 else 1,
			text = textState.value.toString,
		)
	}
}
```
