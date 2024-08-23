### Dependencies
#### official JetBrains (no Multiplatform usage)
build.gradle
```kotlin
implementation("androidx.constraintlayout:constraintlayout-compose:1.0.1") // official JetBrains
```

#### [custom Github (For Multiplatform)](https://github.com/Lavmee/constraintlayout-compose-multiplatform)
build.gradle
```kotlin
val commonMain by getting {
    dependencies {
        implementation("tech.annexflow.compose:constraintlayout-compose-multiplatform:0.4.0")
        /// Compose 1.7.0-alpha01
        implementation("tech.annexflow.compose:constraintlayout-compose-multiplatform:0.5.0-alpha01")
    }
}
```


### Variant_1  -  constraints в текущем методе (в лоб)
KataScreen.kt
```kotlin
@Composable  
fun KataScreen() {  
	ConstraintLayout(  
		modifier = Modifier.fillMaxSize()  
	) {  
	// объявляем ссылки на компоненты  
	val title = createRef()  
	val (rect1, rect2, rect3) = createRefs()  
	  
	// title  
	Text(  
		text = "Hi world!",  
		modifier = Modifier.constrainAs(title) {  
			centerTo(parent)  
			centerVerticallyTo(parent)  
			centerHorizontallyTo(parent)  
			start.linkTo(parent.start)  
			end.linkTo(parent.end, margin = 20.dp) // с отступом 20  
			top.linkTo(parent.top)  
			bottom.linkTo(parent.top) // реагирует на локаль  
			absoluteLeft.linkTo(parent.absoluteLeft) // игнорит локаль  
			absoluteRight.linkTo(parent.absoluteRight)  
		})  
	  
	// rect1  
	Box(modifier = Modifier  
		.background(Color.Green)  
		.constrainAs(rect1) {  
			visibility = Visibility.Gone  
			top.linkTo(title.bottom) // здесь привязка к title  
			width = Dimension.fillToConstraints // заполнит до указанных linkTo  
			width = Dimension.matchParent  
			width = Dimension.percent(0.7f)  
			width = Dimension.wrapContent // игнорирует linkTo  
			width = Dimension.preferredWrapContent // соблюдает linkTo  
			width = Dimension.preferredValue(500.dp) // соблюдает linkTo  
			width = Dimension.value(150.dp) // игнорирует linkTo  
			height = Dimension.ratio("3:3") // намалює квадрат  
		}  
		.width(24.dp) // не работает, constrainAs сильнее  
		.height(24.dp)  
		.background(Color.Blue)  // сработает
	  
	)  
	  
	// rect2  
	Box(modifier = Modifier  
		.constrainAs(rect2) {  
			width = Dimension.value(150.dp)  
			height = Dimension.value(100.dp)  
			linkTo(  
				start = parent.start,  
				end = parent.end,  
				bias = 0.25f,  
			)  
			linkTo(  
				top = rect1.bottom,  
				bottom = parent.bottom,  
				topMargin = 16.dp,  
				topGoneMargin = 156.dp, // если rect1.visibility = Visibility.GONE  
				bias = 0f  
			)  
			verticalChainWeight = 1f // влияет на chain  
		}  
	)  
	  
	// chain (сильнее чем все остальные)  
	val chain = createVerticalChain(  // другие компоненты могут привязываться к этой ссылке 
		rect1, rect2, rect3,  
		chainStyle = ChainStyle.Packed(0.7f)  
	)  
	constrain(chain) {  // описываем привязку chain к parent
		top.linkTo(parent.top)  
		bottom.linkTo(parent.bottom)  
	}  
	  
	// barrier  
	val barrier = createEndBarrier( // другие компоненты могут привязываться к этой ссылке  
		rect1, rect2 // barrier будет плавать завися от ширины указанных компонентов  
	)  
	  
	// guideline  
	// другие компоненты могут привязываться к этой ссылке
	val startGuideline = createGuidelineFromStart(16.dp)  
	}  
}

@Composable
fun ConstraintLayoutScope.Hint(id: ConstraintLayoutReference, text: String) {
	Text(
		text = text,
		fontSize = 14.sp,
		modifier = Modifier.constrainAs(createRef()) {
			centerHorizontallyTo(id)
			bottom.linkTo(id.top, margin = 2.dp)
		}
	)
}

```

### Veriant_2  -  constraints в отдельном методе
KataScreen.kt
```kotlin
@Composable  
fun KataScreen() {  
	ConstraintLayout(  
		modifier = Modifier.fillMaxSize(),
		constraints = constraints(), // метод описан ниже
	) { 
	
// title  
	Text(  
		text = "Hi world!",
		modifier = Modifier
			.layoutId("text1)  
	)
// subtitle  
	Text(  
		text = "Hare Krsna!",
		modifier = Modifier
			.layoutId("text2)  
	)
}

private fun constraints() = ConstraintSet{
	val text1 = createRefFor("text1")
	val text1 = createRefFor("text2")
	
	constrain(text1){
		centerHorizontallyTo(parent)
	}
	
	constrain(text2){
		centerHorizontallyTo(parent)
	}

	createVerticalChain(
		text1, text2,
		chainStyle = ChainStyle.Packed,
	)
}
```




