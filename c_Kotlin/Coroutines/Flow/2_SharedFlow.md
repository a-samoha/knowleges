
## SharedFlow (Hot) 
- Частный случай (наследник) Flow:
- Используется для **широковещательной передачи событий** (broadcast communication).
- **Создается один раз**
- Может иметь **много подписчиков**, 
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

Предположим, у вас есть `MutableSharedFlow` с `replay = 1` и `extraBufferCapacity = 1`. Это означает, что общий размер буфера составляет 2 значения: одно для повторной отправки новым подписчикам и одно дополнительное.
1. **Эмиттер отправляет значение `A`**:
    - Значение `A` сохраняется в буфере для повторной отправки.
2. **Эмиттер отправляет значение `B`**:
    - Значение `B` сохраняется в дополнительном буфере (`extraBufferCapacity`).
3. **Эмиттер отправляет значение `C`**:
    - Буфер заполнен. В зависимости от стратегии переполнения буфера (`BufferOverflow`), одно из значений будет удалено, чтобы освободить место для `C`. В вашем случае используется `BufferOverflow.DROP_OLDEST`, поэтому самое старое значение (`A`) будет удалено, и буфер теперь содержит `B` и `C`.

**Стратегии переполнения буфера (`BufferOverflow`):**
- **`SUSPEND`**: Эмиттер приостанавливается до тех пор, пока в буфере не освободится место.
- **`DROP_OLDEST`**: Удаляется самое старое значение в буфере, чтобы освободить место для нового.
- **`DROP_LATEST`**: Новое значение отбрасывается, если буфер заполнен.