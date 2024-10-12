
![[Pasted image 20241002153555.png]]

### Анотація **@Stable**
```kotlin
import androidx.compose.runtime.Stable
import androidx.compose.runtime.Immutable

@Stable  // Анотація оголошує що всі екземпляри данoго типу відповідають умовам стабільності (фото вище)
interface MutableState<T> : State<T> {}

@Stable // всі екземпляри стабільні тому що MutableState також стабільний
data class Label(
    val text: MutableState<String> = mutableStateOf("123")
)

@Immutable  // Анотація оголошує що всі екземпляри не просто стабільні, а ще й немютабельні !!!
data class Label(  
    val text: String
)
```

### Стабільний клас:
```kotlin
/**  
 * Даний клас є стабільним, тому що: 
 * - УСІ аргументи є 'val' 
 * - УСІ аргументи є стабільні (примітиви або String) 
 */
data class Label(  
    val text: String  
)
```

### НЕ Стабільний клас:
```kotlin
/**  
 * Даний клас є НЕ стабільним, тому що: 
 * - аргумент є 'var' 
 */
data class Label(
	var text: String  // тому що var !!!
)
```

### skippable функція
```kotlin
/**  
 * Якщо Composable функція приймає в аргументи 
 * примітивні типи або String 
 * така функція вважається `skippable` !!! 
 */
@Composable  
fun CounterText(counter: Int) {  
    Text(  
        text = "$counter",  
        fontSize = 32.sp,  
        fontWeight = FontWeight.Bold,  
        fontFamily = FontFamily.Monospace,  
    )  
}
```

### NOT skippable функція
```kotlin
/**  
 * Тут Composable функція приймає 
 * Стабільний клас [Label]  
 * така функція вважається skippable !!!  
 */
@Composable  
fun LabelText(label: Label) {  
    Text(  
        text = label.text,  
        fontSize = 32.sp,  
        fontWeight = FontWeight.Bold,  
        fontFamily = FontFamily.Monospace,  
    )  
}
```

### Звіти з Compose метриками:
build.gradle.kts
```kotlin
kotlinOptions{  
    freeCompilerArgs += listOf(  
        "-P",  
        "plugin:androidx.compose.compiler.plugins.kotlin:metricsDestination=${rootProject.buildDir.absolutePath}/reports",  
        "-P",  
        "plugin:androidx.compose.compiler.plugins.kotlin:reportsDestination=${rootProject.buildDir.absolutePath}/reports",  
        "-P",  
        "plugin:androidx.compose.compiler.plugins.kotlin:reportsDestination=${rootProject.buildDir.absolutePath}/reports",  
    )  
}
```

у результаті після кожного білда отримуємо файли:

build/reports/app_skippableDebug-classes.txt
```
stable class Label {  
  stable val text: String  
  <runtime stability> = Stable  
}  
unstable class UnstLabel {  
  stable var text: String  
  <runtime stability> = Unstable  
}  
stable class MainActivity {  
  <runtime stability> = Stable  
}
```

build/reports/app_skippableDebug-composables.txt
```kotlin
restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun AppScreen()  
restartable fun CounterText(  
  unstable counter: Any  
)  
restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun LabelText(  
  stable label: Label  
)  
restartable scheme("[androidx.compose.ui.UiComposable]") fun UnstLabelText(  
  unstable label: UnstLabel  
)  
restartable scheme("[androidx.compose.ui.UiComposable]") fun LabelFromAnotherModuleText(  
  unstable label: LabelFromAnotherModule  
)
```

```kotlin
```