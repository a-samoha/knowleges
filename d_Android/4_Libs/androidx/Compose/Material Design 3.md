
[официальный сайт](https://m3.material.io/)

[сгенерировать тему для арр](https://m3.material.io/theme-builder)


```kotlin
@Compose
fun KataScreen(){
	AppTheme(useDarkTheme = true){
		Surface(){  // Material3 либаб, применяет цвета из AppTheme
			Text(  
				text = "Hi world!",  
				style = MaterialTheme.typography.bodyLarge,  
				modifier = Modifier  
					.background(  
						color = MaterialTheme.colorScheme.error,  
						shape = MaterialTheme.shapes.large,  
					)
			)
		}
	}
}
```