
## StateFlow (Hot) 
- Частный случай (наследник) SharedFlow:
- Появляется проперти value из которого можно достать текущее значение; 
- **Запрет на отсутствие значений** (обязует указать значение при инициализации)
- **НЕ эмитит** значение, если новое equals текущему.
- Живет, пока не помрет корутина, в которой запущен flow. 

```kotlin
class MainViewModel: ViewModel(){
	
	private val _message = MutableStateFlow("Hello Android")
	val message: StateFlow<String> = _message.asStateFlow
	
	fun setUserMessage(msg: String){
		_message.value = msg
		
		// или !!!
		_message.update{ oldValue -> oldValue + msg } // удобно если флоу возвращает List !!!
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
```
