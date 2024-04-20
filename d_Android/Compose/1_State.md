
[Roman - (State) в Jetpack Compose, частина 2](https://www.youtube.com/watch?v=C_h2RVPUxSw&list=PLRmiL0mct8WkFdcvOCi06_64_ec3B2jvx&index=8)
### выучить наизусть (ката)
```kotlin

// вар2
// import androidx.compose.runtime.getValue
// import androidx.compose.runtime.setValue

data class TmpState(  
	var number: Short = 0  
)  

/**
* Stateful - функция, у которой State хранится внутри и снаружи его НЕ видно
* Stateless- НЕТ внутреннего State, он передается в параметры
*  
* Flutter: StatefulWidget, StatelessWidget 
* 
* State Hoisting - поднимаем State на более высокий уровень
*/
@Preview(showSystemUi = true)  
@Composable  
fun TmpScreen() {  
	// если удалить remember, то mutableStateOf будет пересоздаваться при рекомпозиции
	// rememberSaveable - сохраняет данные в Bundle (сериализация) при повороте экрана
	// вар1 с обычным stateFlow
	val uiState = remember {  
		mutableStateOf(TmpState(Random.nextInt(1000).toShort()))  
	}
	
	// вар2 Kotlin Destruction
	// val (value, setValue) = remember {  
	//    mutableStateOf(TmpState(Random.nextInt(1000).toShort()))  
	// } 
	
	// вар3 с Delegation
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
			text = uiState.value.number.toString(),  
			
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
			val newVal = (uiState.value.number + 1).toShort()  
			uiState.value = uiState.value.copy(number = newVal)
			
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

**rememberSaveable** - сохраняет данные в Bundle (сериализация) и переживает поворот екрана

- Класс TmpState  делаем Serializable
```kotlin
data class TmpState(  
	var number: Short = 0  
) : Serializable
```

- Класс TmpState  делаем Parcelable
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

-  Используем Saver
```kotlin
companion object {
	val Saver: Saver<CustomState, *> = Saver(
		save = { state: CustomState -> 
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
			CustomState(
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
```




[NECO - Compose | States | #5 |](https://www.youtube.com/watch?v=ztJvKbD3vQY&list=PLmjT2NFTgg1cyNFqS2ST6nTDxZH_bYjba&index=6)
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
