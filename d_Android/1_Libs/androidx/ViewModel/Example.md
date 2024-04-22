
Buffer  -  Хранит эмит отправленный подписчику, пока он не будет доставлен [(03:00)](https://youtu.be/njchj9d_Lf8?t=173)  [(06:30)](https://youtu.be/njchj9d_Lf8?t=392)
	
Cache   -  Хранит эмиты для следующих подписчиков (задается в replay = 3)
	
### HomeViewModel.kt

```kotlin
import ...

class HomeViewModel(  
    private val someUseCase: SomeUseCase,
) : ViewModel() {  
	
	// Screen UI STATE
    var state by mutableStateOf(HomeState())
	    private set
	
	// Screen UI ONE-TIME EVENT
	
	// Variant 1 (Best)
	// - ЕСТЬ Buffer
	// - НЕT Cache

	// - ВАЖНО подписаться до эмита (иначе он пропадет)
	// 1) Если подписался и тебе отправили эмит - ты его получиш даже при повороте скрина
	// 2) Если тебе отправили эмит, а потом ты подписался - ты его НЕ получиш (пролетит мимо).
	
	// - На Main потоке могут пропадать эмиты
	// - для лечения при подписке нужно использовать Main.immediate
	private val eventsChannel = Channel<HomeUiEvent>()
	val eventsChannelFlow = eventsChannel.receiveAsFlow()
	
	// Variant 2 
	// - ЕСТЬ Cache (по-умолчанию = 0)
	// - нужно использовать replay = 3
	private var _events = MutableSharedFlow<HomeUiEvent>()
	val events = _events.asSharedFlow()
	
	// Variant 3 
	// - ЕСТЬ Cache (по-умолчанию = 1)
	// - больше не учтанаыливается.
	
	// - нужно помнить какой стейт последний,
	// - и получив на фрагменте данные нужно сетить дефолтный.
	// - напр.: Если я запхну в HomeState поле с ошибкой error = true
	// - после отображения ошибки нужно будет исправить стейт на error = false
	// - иначе при пересоздании фрагмента СНОВА отобразится ошибка.
	var events by mutableStateOf(HomeUiEvent())
		private set 
	
	// INIT
    init  {  
	    viewModelScope.launch{
		    state = state.copy(isLoading = true)
			delay(3000L)
			
			eventsChannel.send(Error)
			
			state = state.copy(isLoading = false)
		}
    }  
	
	fun onShowed() { ... }
	fun onButtonClick() { ... }
	
    data class HomeState(
	    val isLoading: Boolean = false,
	    val homeData: HomeModel = HomeModel.EMPTY,
	)
	
	sealed interface HomeUiEvent {
		data object Error: HomeUiEvent
		data object NavigateProfile: HomeUiEvent
	}
}
```


### Compose screen

```kotlin
...
	NavHost(
		navController = navController,
		startDestination = "home"
	){
		composable("home"){
			val viewModel = viewModel<HomeViewModel>()
			val state = viewModel.state
			
			ObserveAsEvents(viewModel.eventsChannelFlow){ event ->
				when(event){
					Error -> Toast.makeText(requireContext(), "Smth went wrong", Toast.LENGTH_LONG).show()
					NavigateProfile -> navController.navigate("profile")
				}
			}
			
			HomeScreen(
				state = state,
				onProfileClick = viewModel::onProfile
			)
		}
		composable("profile"){
			ProfileScreen()
		}
	}
...
	@Composeable
	private fun <T> ObserveAsEvents(flow:Flow<T>, onEvent: (T) -> Unit){
			val lifecycleOwner = LocalLifecycleOwner.current
			LaunchedEffect(flow, lifecycleOwner.lifecycle){
				lifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED){
					flow.collect(onEvent)
					
				}
			}
	}

```

