
- предоставление данных в одной точке дерева композиции, делая их доступными для всех дочерних компонентов.
- изменения данных в одной ветви композиции не влияют на другие ветви.
- строго типизирован, что обеспечивает безопасность типов.

![[Pasted image 20231226143040.png]]


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
  
val LocalAppTHeme = compositionLocalOf { AppTheme.Light }

	...  
	setContent {                       // in MainActivity
		CompositionLocalProvider {     // явное изменение внутренностей Local
			LocalAppTHeme provides AppTheme.Dark  // присвоили значение
			KataScreen()                          // запустили @Composable
		}  
	}
	
	... 
	val theme = LocalAppTHeme.current  // используем значение Local внутри @Composable
	
	...
	CompositionLocalProvider {  
		// измененяем внутренности Local для нижних children
		LocalAppTHeme provides theme.copy(buttonColor = Color.Red)  
	}

```