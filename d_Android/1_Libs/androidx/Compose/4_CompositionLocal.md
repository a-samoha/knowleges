
- предоставление данных в одной точке дерева композиции, делая их доступными для всех дочерних компонентов.
- изменения данных в одной ветви композиции не влияют на другие ветви.
- строго типизирован, что обеспечивает безопасность типов.

![[Pasted image 20231226143040.png]]

Объявляем  CompositionLocal:
```kotlin
data class AppTheme(  
	val buttonColor: Color,  
	val bgColor: Color,  
) {  
	companion object {  
		val Light = AppTheme(  
			buttonColor = Color.Blue,  
			bgColor = Color.White,  
		)  
		val Dark = AppTheme(  
			buttonColor = Color.Gray,  
			bgColor = Color.Black,  
		)  
	}  
}  
```

```kotlin
val LocalAppTHeme = compositionLocalOf { AppTheme.Light }
```

Используем  "В лоб"
```kotlin
	...  
	setContent {                       // in MainActivity
		CompositionLocalProvider(      // явное изменение внутренностей Local
			LocalAppTHeme provides AppTheme.Dark  // присвоили значение
		) {    
			KataScreen()                          // запустили @Composable
		}  
	}
	
	... 
	@Composable
	fun KataScreen(){
	
		val theme = LocalAppTHeme.current  // используем значение Local внутри @Composable
		Box(modifier = Modifier.background(theme.bgColor)) {
		
			CompositionLocalProvider( // явно измененяем внутренности Local для нижних children
				LocalAppTHeme provides theme.copy(buttonColor = Color.Red)  
			) {  
				Column(){
					val theme = LocalAppTHeme.current // в это месте buttonColor будет уже Red
				}
			}
		}
	}
```

### НАПР.:  ДИНАМИЧЕСКАЯ смена глобальной темы арр:

#### Объявляем и реализуем DataSource хранящий AppTheme в SharedPreferences
```kotlin
interface ThemeDataSource{
	
	val themeStateFlow: StateFlow<AppTheme>
	
	fun setTheme(theme: AppTheme)
}
```

```kotlin
class SharedPrefsThemeDataSource(
	context: Context
) : ThemeDataSource {
	private val prefs = context.getSharedPreferences(
		THEME_PREFS_NAME, Context.MODE_PRIVATE
	)
	
	override var themeStateFlow: MutableStateFlow<AppTheme> = MutableStateFlow(readTheme())
	
	override fun setTheme(theme: AppTheme){
		prefs.edit()
			.putInt(KEY_BUTTON_COLOR, theme.buttonColor.toArgb())
			.putInt(KEY_BG_COLOR, theme.bgColor.toArgb())
			.apply()
			themeStateFlow.value = theme
	}
	
	private fun readTheme(): AppTheme{
		return if(!hasSavedTheme()) AppTheme.Light 
			else AppTheme(
				buttonColor = Color(prefs.getInt(KEY_BUTTON_COLOR, 0)),
				bgColor = Color(prefs.getInt(KEY_BG_COLOR, 0)),
			)
	}	
	
	private fun hasSavedTheme(): Boolean = prefs.contains(KEY_BG_COLOR)
	
	companionObject{
		const val THEME_PREFS_NAME = "themes"
		const val KEY_BUTTON_COLOR = "BUTTON_COLOR"
		const val KEY_BG_COLOR = "BG_COLOR"
	}
}
```

#### Объявляем и реализуем AppThemeController 

```kotlin
interface AppThemeController {

	/**
	* Toggle between Light/Dark app theme,
	* @see AppTheme
	*/
	fun toggle()
}

// This impl will be used as the default for staticCompositionLocalOf<AppThemeController>
class EmptyThemeController() : AppThemeController { 
	override fun toggle(){} 
}
```

```kotlin
class RealThemeController(
	private val themeDataSource: ThemeDataSource,
) : AppThemeController {
	
	override fun toggle(){
		val currentTheme = themeDataSource.themeStateFlow.value
		if(currrentTheme == AppTheme.Dark){
			themeDataSource.setTheme(AppTheme.Light)
		} else {
			themeDataSource.setTheme(AppTheme.Dark)
		}
	}
}
```

#### Объвляем CompositionLocal
AppThemeContainer.kt
```kotlin

// compositionLocalOf  -  Composе определяет какие композиции зависят от этого параметра
						// и при смене параметра рекомпозироваться будет НЕ все, 
						// а только те композиции, которые от него зависят
val LocalAppTheme = compositionLocalOf<AppTheme>{
	AppTheme.Light
}

// staticCompositionLocalOf  -  потребляет МЕНЬШЕ ресурсов
								// используем если параметр будет меняться ОЧЕНЬ редко
								// потому, что при каждой смене параметра рекомпозироваться будет ВСЕ что в нем лежит!!!
val LocalAppThemeController = staticCompositionLocalOf<AppThemeController>{
	EmptyThemeController
}

@Composable
fun AppThemeContainer(content: @Composable() -> Unit){
	val context = LocalContext.current
	val themeDataSource = remember {
		SharedPrefsThemeDataSource(context)
	}
	val controller = remember{
		RealThemeController(themeDataSource)
	}
	val theme by themeDataSource.themeStateFlow.collectAsStateWithLifecycle()
	CompositionLocalProvider(
		LocalAppTheme provides theme,
		LocalAppThemeController provides controller,
	){
		content()
	}
}
```

#### Используем тему
```kotlin
	...  
	setContent {                       // in MainActivity
		AppThemeContainer {    
			KataScreen() 
		}  
	}
	
	... 
	@Composable
	fun KataScreen(){
	
		val theme = LocalAppTHeme.current  // используем значение Local внутри @Composable
		val themeController = LocalAppTHemeController.current  // используем значение Local внутри @Composable
		
		Box(modifier = Modifier.background(theme.bgColor)) {
			
			SettingsButton( onClick = { themeController.toggle() } )  // МЕНЯЕМ ТЕМУ ВСЕГО ПРИЛОЖЕНИЯ!!!
			
			CompositionLocalProvider( // явно измененяем внутренности Local для нижних children
				LocalAppTHeme provides theme.copy(buttonColor = Color.Red)  
			) {  
				Column(){
					val theme = LocalAppTHeme.current // в это месте buttonColor будет уже Red
				}
			}
		}
	}
```