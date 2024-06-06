
### derivedStateOf{} 
	- используется когда нужно реагировать НЕ на все обновления originState
	- это посредник между родительским стейтом и одной из фаз рендеринга

```kotlin
// в данном кейсе 
// Layout Phase выполняется (1 раз в 3 смены originState)
// HO Recomposition Phase ТАКЖЕ 
// выполняется при каждом изменении "transformedValue" (1 раз в 3 смены originState)
val transformedValue = counterValue/3

Text(
	text = "test",
	modifier = Modifier
		// .offset{} выполняется на LayoutPhase фазе
		//  поэтому Composition Phase и Drawing Phase пропускаются
		.offset{ IntOffset(x=0, y = 20 * transformedValue) }
)

// в данном кейсе 
// Layout Phase выполняется (1 раз в 3 смены originState)
// а Recomposition Phase НЕ выполняется (только 1 раз композиция)
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