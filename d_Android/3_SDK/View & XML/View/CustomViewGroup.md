###### XML
```xml
<TextView  
    android:id="@+id/tvSomeInfo"  
    android:layout_width="0dp"  
    android:layout_height="wrap_content"  
    ...
    app:someProfileValue="@{viewModel.someInfo}"  
    ... />
```

###### SomeValueUiModel
```kotlin  
data class SomeValueUiModel(  
    val value: String = "",  
    val placeholder: Int = R.string.placeholder_info_add  
)
```

###### SomeBindingAdapter
```kotlin
import androidx.databinding.BindingAdapter

@BindingAdapter("someProfileValue")  
fun TextView.bindSomeProfileValue(model: SomeValueUiModel) {  
    text = when {
        model.value.isNotEmpty() -> {  
            setTextColor(ContextCompat.getColor(context, R.color.colorDeepBlue))  
            model.value  
        }
        model.value.isEmpty() -> {  
            setTextColor(ContextCompat.getColor(context, R.color.colorDeepBlue20))  
            context.getString(model.placeholder)  
        }  
        else -> ""
    }  
}
```

###### Fragment
```kotlin  
import org.koin.androidx.viewmodel.ext.android.viewModel  
import org.koin.core.parameter.parametersOf

class SomeProfileInfoFragment : BaseFragment<FragmentSomeProfileInfoBinding>() {

	override val viewModel: SomeProfileInfoViewModel by viewModel {  
	    parametersOf(requireArguments().getString(SOME_ID, "0"))  
	}

...

	override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
	    super.onViewCreated(view, savedInstanceState)  
	    binding.viewModel = viewModel  
	}
}
```

###### ViewModel
```kotlin
class ChildProfileInfoViewModel(  
    private val childProfileUseCase: GetChildProfileUseCase,
    private val schedulerProvider: SchedulerProvider  
) : BaseViewModel() {
	
	val childDeviceName = ObservableField(  
	    ChildValueUiModel(placeholder = R.string.fragment_child_profile_info_unlinked)  
	)
	
	childDeviceName.getAndSet {  
	    if(child.deviceId == 0L) it.copy(value = "")  
	    else it.copy(value = "${child.firstName}’s Littlebird Band")  
	}
}
```

###### DataBindingExtentions.kt
```kotlin
import androidx.databinding.ObservableField  
  
fun <T> ObservableField<T>.getNotNull(): T =  
    this.get() ?: error("Cannot can not null value of null")  
  
fun <T> ObservableField<T>.getAndSet(fn: (T) -> T) {  
    set(fn(this.getNotNull()))  
}
```


```kotlin
// GET All CHILDREN for layout
for (index in 0 until (viewGroup as ViewGroup).childCount) {  
    val nextChild: View = (viewGroup as ViewGroup).getChildAt(index)  
}
```