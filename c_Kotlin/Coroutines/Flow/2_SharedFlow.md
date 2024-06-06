
## SharedFlow (Hot) 
- Частный случай (наследник) Flow:
- **Создается один раз**
- Может иметь много подписчиков, 
	которые при появлении получают все или заданное количество емитов (Буффер значений)
- Чтобы как PublishSubject, такая настройка:  
	`private val _error = MutableSharedFlow<Error>(replay = 0, extraBufferCapacity = 1, BufferOverflow.DROP_OLDEST)`
- Чтобы как BehaviorSubject, такая настройка:  
	`private val _error = MutableSharedFlow<Error>(replay = 1, extraBufferCapacity = 1, BufferOverflow.DROP_OLDEST)`
- Поток живет, пока не помрет корутина, в которой он запущен. 
	При этом, поток БЛОКИРУЕТ код написанный внутри корутины после `.collect()` 
	напр: 
```kotlin
		lifecycleScope.LaunchWhenStarted{
			viewModel.message // это SharedFlow
				.onEach{ textView.text = it}
				.collect()
			printLn("Hello World") // НЕ ВЫПОЛНИТСЯ никогда
		}
```

```kotlin
class SupportSaleViewModel() : ViewModel() {

	// аналог PublishSubject
	private val errorFlow = MutableSharedFlow<Throwable>(replay = 0, extraBufferCapacity = 1, BufferOverflow.DROP_OLDEST)  

	// аналог BehaviourSubject
	private val errorFlow = MutableSharedFlow<Throwable>(replay = 1, extraBufferCapacity = 1, BufferOverflow.DROP_OLDEST)  
	
	val error: SharedFlow<Throwable> = errorFlow.asSharedFlow()
}

class SupportSaleScreen : BaseFragment<SupportSaleScreenBinding>() {   
    private val viewModel by viewModel<SupportSaleViewModel> { parametersOf(arguments) }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
    super.onViewCreated(view, savedInstanceState)
		viewModel.error  
			.onEach {  
				Timber.tag(TAG).e(it)  
				showToast(R.string.error_unknown)  
			}  
			.launchIn(lifecycleScope)
	}
	companion object {  
	    private const val TAG = "RateAppInternalScreen"  
	}
}
```
