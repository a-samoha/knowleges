#android 
[Documentation](https://developer.android.com/topic/libraries/data-binding/expressions#java)
-   [Android Data Binding codelab](https://codelabs.developers.google.com/codelabs/android-databinding)

## build.gradle
```kotlin
android {
	...    
	dataBinding {
		enabled true    
	}
}
```

## Activity Binding
```kotlin
private lateinit var binding: ActivityMainBinding

// Obtain ViewModel from ViewModelProviders
private val viewModel by lazy { ViewModelProviders.of(this).get(SimpleViewModel::class.java) }

override fun onCreate(savedInstanceState: Bundle?) {
	super.onCreate(savedInstanceState)
	binding = DataBindingUtil.setContentView(this, R.layout.activity_main)

	binding.viewModel = viewModel
}
```

## Fragment Binding
```kotlin
import org.koin.androidx.viewmodel.ext.android.sharedViewModel
import org.koin.androidx.viewmodel.ext.android.viewModel  
  
class HomeFragment : Fragment() {  
	  
	private val viewModel: HomeViewModel by viewModel()
	private val sharedViewModel: HomeSharedViewModel by sharedViewModel()  
	private val filterViewModel: FilterSharedViewModel by sharedViewModel()
	
	private lateinit var binding: FragmentHomeBinding
	
	override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {  
	    binding = DataBindingUtil.inflate(inflater, R.layout.fragment_mdpage, container, false)  
	    return binding.root  
	}
	
	override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
	    super.onViewCreated(view, savedInstanceState)
	    binding.name = "Artem"
	    binding.viewModel = viewModel  
	    binding.sharedViewModel = sharedViewModel  
	    binding.filterSharedViewModel = filterViewModel
	}
}
```

## R.layout.fragment_home.xml
```xml
<?xml version="1.0" encoding="utf-8"?>  
<layout xmlns:android="http://schemas.android.com/apk/res/android"  
    xmlns:app="http://schemas.android.com/apk/res-auto">  
    
    <data>  
	    <variable name="name" type="String"/>
        <variable  
			name="viewModel"  
			type="constru.quality.presentation.ui.fragment.home.HomeViewModel" />  
		<variable  
		    name="sharedViewModel"  
		    type="constru.quality.presentation.ui.fragment.home.HomeSharedViewModel" />  
		<variable  
		    name="filterSharedViewModel"  
		    type="constru.quality.presentation.ui.fragment.discrepancies.filter.FilterSharedViewModel" />
    </data>
    
    <androidx.constraintlayout.widget.ConstraintLayout  
        android:layout_width="match_parent"  
        android:layout_height="match_parent">
        
        <TextView
			android:id="@+id/user_name"
			android:text="@{name}"/>
                
        <TextView
			android:id="@+id/project_name"
			android:text="@{viewModel.projectName}"/>
			
        <ImageView  
			android:id="@+id/ivNetworkStatus"
			android:src="@{viewModel.networkState ? @drawable/ic_network_online : @drawable/ic_network_offline}"
			android:onClick="@{() -> viewmodel.onNetworkStatus()}"
		    app:viewVisibility="@{sharedViewModel.iconNetworkStatusVisible}" />
        
    </androidx.constraintlayout.widget.ConstraintLayout>  
</layout>
```

![[Pasted image 20230102111104.png]]