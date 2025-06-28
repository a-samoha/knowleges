# Compose

### CustomScreen.kt
## Koin
```kotlin
//implimentation 'io.insert-koin:koin-androidx-compose:3.4.3'
import org.koin.androidx.compose.koinViewModel

@Composable  
fun CustomScreen(  
    viewModel: PaintingsViewModel = koinViewModel()  // Koin
) {  
    Column() {  
        PaintingsGrid()  
    }  
}
```

## Hilt
```kotlin
//implimentation 'androidx.hilt:hilt-navigation-compose:2.44.2'
import androidx.hilt.navigation.compose.hiltViewModel

@Composable  
fun CustomScreen(  
    viewModel: PicturesViewModel = hiltViewModel()  // Hilt
) {  
    Column() {  
        PicturesGrid()  
    }  
}
```

## Lifecycle
```kotlin
//implimentation 'androidx.lifecycle:lifecycle-viewmodel-compose:2.5.1'  
import androidx.lifecycle.viewmodel.compose.viewModel

@Composable  
fun CustomScreen(  
    viewModel: PicturesViewModel = viewModel()  // Hilt
) {  
    Column() {  
        PicturesGrid()  
    }  
}
```


# XML

### TooltipDialogScreen (Fragment) 
### Для Activity все то же самое
## Koin

```kotlin  
//api 'io.insert-koin:koin-android:3.4.3'
import org.koin.androidx.viewmodel.ext.android.viewModel

class TooltipDialogScreen : BottomSheetDialogFragment() {
	// viewModel это extention fun для Fragment
    private val viewModel by viewModel<TooltipDialogViewModel> { parametersOf(arguments) } 
}
```

## Hilt
```kotlin  
//api 'io.insert-koin:koin-android:3.4.3'  ?????
import org.koin.androidx.viewmodel.ext.android.viewModel  ????

class TooltipDialogScreen : BottomSheetDialogFragment() {
    private val viewModel by viewModel<TooltipDialogViewModel> { parametersOf(arguments) }  // Hilt
}
```

## Lifecycle
```kotlin  
//implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:$2.7.0"
import androidx.lifecycle.ViewModel  
import androidx.lifecycle.viewModelScope

class TooltipDialogViewModel: ViewModel(){}
...

// implementation("androidx.activity:activity-ktx:1.8.2")
import androidx.activity.viewModels

class MainActivity: AppCompatActivity() {  
    private val viewModel by viewModels<MainViewModel>() 
}

// implementation("androidx.fragment:fragment-ktx:1.7.0")
import androidx.fragment.viewModels

class TooltipDialogScreen : BottomSheetDialogFragment() {
    private val viewModel by viewModel<TooltipDialogViewModel> { parametersOf(arguments) } 
}
```

## [[Fragment]]
```kotlin  
import androidx.fragment.app.FragmentActivity  
import androidx.fragment.app.activityViewModels

class HomeFragment : Fragment() {
    private val viewModel : HomeViewModel by activityViewModels()
}
```
