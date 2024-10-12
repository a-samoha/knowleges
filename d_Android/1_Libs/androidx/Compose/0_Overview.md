
[YouTube курс по Compose](https://youtu.be/z24DOCcqzaU?si=83M4xkSnDKO73rOy)

[Dependencies](https://developer.android.com/jetpack/androidx/releases/compose-ui#declaring_dependencies)

Пришел на смену для "солянки":

| component | lifecycle          | work with        |
| --------- | ------------------ | ---------------- |
| Fragment  | fragment lifecycle | fragment manager |
| Activity  | actyvity lifecycle | intent           |
| views     | view lifecycle     | View & ViewGroup |

## Принципы Compose
- Jetpack Compose, 
- Flatter, 
- React Native, React Redax
- MVI, 
- RecyclerView + ListAdapter + DiffUtil

**Oснованы на одних и тех же принципах:**
1) Reactive Programming
2) UI depends on State (розделение ui (логики отображения) от state (логики хранения данных))
3) immutability (ТОЛЬКО val и .copy(). Для var можно сделать делегат, гетеры&сеттеры, или реактивно, НО работать не будет.)
4) Pure Functions (для ui рекомпозиции)
	- Stable and predictable results
	- Easy to optimize
	- Eazy to cover with tests

### ComposeView  :  AbstractComposeView   :  ViewGroup(context, attrs, defStyleAttr)
```kotlin
import androidx.activity.compose.setContent

class MainActivity : ComponentActivity() {  
	override fun onCreate(savedInstanceState: Bundle?) {  
		super.onCreate(savedInstanceState)  
		setContent {}  // запускает отрисовку ComposeView 
	}
}
```

### Preview
```kotlin
@Composable  
@Preview(
	showSystemUi = true,   
	widthDp = 100,                    // можно указывать вместе с showSystemUi
	heightDp = 600          
	showBackground = true,
	)
private fun PreviewScreenContent() {  // any fun name
	ScreenContent(                    // name of real compose fun
		uiState = MyState(),               
	)  
}
```

### Get Context
```kotlin
@Composable
fun showToast(){
	val context: Context = LocalContext.current
	Toast.makeText(
		context,
		"Hello world",
		Toast.LENGTH_SHORT
	).show()
}
```
