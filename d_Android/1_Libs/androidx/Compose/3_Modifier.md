
### Modifier  -  декорирование, клики, прокрутка...
- Декорирует компоненты
- Отвечает за "ОБЩИЕ" параметры (напр.: .background(color= Color.Green))
	- тогда как у компонентов идут специализированные параметры (напр.: TEXT(text = "")) 
- Это интрфейс, на который навешивают extension функции.
- Можно создавать свои extension для модификатора
- Oн обрабатывается:
	- Компоновщиком (как :layout_ атрибуты в xml, напр.: layout_width)         или
	- ComposeView
		  - наследуется от ViewGroup
		  - внутри метода setContent {}  создается ComposeView и 
		  - сетится в старый setContentView (this, DefaultActivityContentLayoutParams)
- **ВАЖНО** соблюдать правильную очередность вызовов функций
	 ![[Pasted image 20231219174853.png]]
  
```kotlin
modifier = Modifier                  // ВАЖНО соблюдать очередность
			.align(BiasAlignment.Horizontal(0.2f))  // смещение как в ConstraintLayout
			.background(
				color= Color.Green,  // цвет фона
				shape=CircleShape, // форма фона
			)
			.clip(CircleShape)       // обрезка типа crop 
			.clickable(              // обработка кликов
				onClick = {},
				interactionSource = MutableInteractionSource(),
				indication = rememberRipple(),
			)            
			.fillMaxSize()           // занять все место в родителе
			.fillMaxWidth(0.5f)      // займет половину родителя
			.offset(40.dp, 40.dp)    // как бывший padding но территоря та же
			.offset{                 // выполняется на LayoutPhase фазе (cм. Lifecycle)
				IntOffset(x=0, y = 20 * (counterValue/3))
			}
			.drawBehind{}            // выполняется на DrawingPhase фазе 
			.padding(16.dp)          // как бывший marging
			.pinterInput(Unit){      // обработка любых событий: перетягивания, кликов
				detectDrag...{}
			}
			.size(64.dp)
			.verticalScroll(rememberScrollState()) // прокрутка
			.weight(2f)              // ТОЛЬКО для Row/Column - аналог weight у LinearLayout
			.fillMaxWidth()          // если соблюсти такую последовательность ->  
			.wrapContentWidth(),     // -> текст выровняется по центру скрина и займет минимум места.
			
			// прокидываем modifier в свой кастомный компонент
@Composable
fun MyComponent(
	modifier: Modifier = Modifier,
	width: Dp = 100.dp,
	height: Dp = 100.dp,
){
	Box(modifier.then(
		Modifier
			.size(width, height)
		))
}
```
