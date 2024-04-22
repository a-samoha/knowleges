
```kotlin
	someLiveData.value
	someLiveData.setValue = ...  // обязует обновляться только на UI потоке (явно объявляем, что обновление UI потоке)
	someLiveData.postValue(...)  // можно использовать на любом потоке.
```

##### Transforming LivaData
**map()**
var userNameLiveData = Transformations.map(
	userLiveData,
	{ user -> "${user.name} ${user.lastname}" })

**switchMap()**

**MediatorLivaData**


[ХОРОШЕЕ ВИДЕО ПОСМОТРИ!](https://www.youtube.com/watch?v=i4vfklDGn_o)


|            | LiveData                                                                                                                                                  | StateFlow | SHaredFlow | Flow   |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|:---------:|------------|--------|
| Доступно   | Java/Kotlin                                                                                                                                               | Kotlin    | Kotlin     | Kotlin |
|            | Clod                                                                                                                                                      |           | Hot        |        |
| Lifecycle  | - Можно использовать в OnCreate() - автоматически учитывает жизненный цикл - вернет значение только когда это безопасно (Started/Resumed - Paused/Stoped) |           |            |        |
| Поточность | - требует обновление только в Main потоке  @MainThread fun setUserUnswer(msg: String) { _message.value = msg }                                            |           |            |        |


LiveData
```kotlin
class MainViewModel: ViewModel(){
	
	private val _message = MutableLiveData<String>()
		.apply{ value = "Hello Android"}
	val message: LiveData<String> get() = _message
	
	@MainThread
	fun setUserMessage(msg: String){
		_message.value = msg
	}
}

class MainActivity{
	
	private val viewModel by viewModel<MainViewModel> { parametersOf(arguments) }
	
	override fun onCreate(sacedInstanceState: Bundle?){
		super.onCreate(sacedInstanceState)
		
		val textView: TextView = findViewById(R.id.message)
		
		// для Fragment вместо this используем lifeCycleOwner
		viewModel.message.observe(this){ msg ->
			textView.text = msg
		}
	}
}
```

StateFlow
```kotlin
class MainViewModel: ViewModel(){
	
	private val _message = MutableStateFlow("Hello Android")
	val message: StateFlow<String> = _message.asStateFlow
	
	fun setUserMessage(msg: String){
		_message.value = msg
	}
}

class MainActivity{
	
	private val viewModel by viewModel<MainViewModel> { parametersOf(arguments) }
	
	override fun onCreate(sacedInstanceState: Bundle?){
		super.onCreate(sacedInstanceState)
		
		val textView: TextView = findViewById(R.id.message)
		
		lifecycleScope.LaunchWhenStarted{
			viewModel.message
				.onEach{ msg ->
					textView.text = msg
				}
				.collect()
		}
		// or
		viewModel.message
			.onEach{ msg ->
				textView.text = msg
			}
			.launchIn(lifecycleScope)
	}
	
	//или в onViewCreated
		
	override fun onViewCreated(view: View, savedInstanceState: Bundle?){
		super.onViewCreated(view, savedInstanceState)
		
		val textView: TextView = findViewById(R.id.message)
		
		viewModel.message
			.onEach{ msg ->
				textView.text = msg
			}
			.launchIn(lifecycleScope)
	}
}

fun Flow<T>
```



https://www.youtube.com/watch?v=6Jc6-INantQ


B9:
```kotlin
import org.koin.androidx.viewmodel.ext.android.viewModel

class CashbackOnboarding1Screen : BaseFragment<CashbackOnboardingScreenBinding>() {

    private val viewModel by viewModel<CashbackOnboarding1ViewModel>()
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        viewModel.screenData.observe(viewLifecycleOwner) {
            updateUi(it)
        }
    }
	
    private fun updateUi(data: CashbackOnboarding) = with(binding) {
        icCashbackOnboarding.loadFitCenter(data.imageUrl, onResourceReady = {
            mainLayout.visible()
            btnNext.visible()
            shimmer.gone()
        })
        tvTitle.text = data.header
        tvDescription.text = data.text
        tvTerms.run {
            visibleOrGone(data.linkText.isNotEmpty())
            tvTerms.text = data.linkText
        }
        btnNext.text = data.buttonText
    }
}
```

```kotlin
private const val FIRST = 0

class CashbackOnboarding1ViewModel(
    private val router: CashbackOnboardingRouter,
    private val cashbackRepository: CashbackRepository
) : ViewModel() {

	// LiveData
    private val _screenData: MutableLiveData<CashbackOnboarding> = MutableLiveData()
    val screenData: LiveData<CashbackOnboarding> = _screenData
	
    init {
        viewModelScope.launch {
            cashbackRepository.getCashbackOnboardingScreens(FIRST)
                .onSuccess { _screenData.value = it }
        }
    }
}
```