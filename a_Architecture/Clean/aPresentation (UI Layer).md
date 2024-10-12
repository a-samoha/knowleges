#clean_architecture 

!!!   `Any changes to the UI state has to be immediately reflected in the UI.`
!!!   `You should never modify the UI state in the UI directly unless the UI itself is the sole source of its data.`

###### Diagram
![[Pasted image 20220630162310.png]]
###### The [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel)  (UI state holder )
The ViewModel type is the recommended implementation for the management of screen-level UI state with access to the data layer. Furthermore, it survives configuration changes automatically. `ViewModel` classes define the logic to be applied to events in the app and produce updated state as a result.

```kotlin
class NewsViewModel(
		private val repository: NewsRepository,
	) : ViewModel() {    
	
	// Use Kotlin Flows
	private val _uiState = MutableStateFlow(NewsUiState())
	private val _uiState = ObservableField(NewsUiState())
	private val _uiState = MutableLiveData(NewsUiState())
	
	val uiState: StateFlow<NewsUiState> = …
	
	private var fetchJob: Job? = null    
	
	fun fetchArticles(category: String) {        
		fetchJob?.cancel()        
		fetchJob = viewModelScope.launch {            
			try {                
				val newsItems = repository.newsItemsForCategory(category)                
				_uiState.update {                    
					it.copy(newsItems = newsItems)                
				}            
			} catch (ioe: IOException) {                
				// Handle the error and notify the UI when appropriate.                
				_uiState.update {                    
				val messages = getMessagesFromThrowable(ioe)                    
				it.copy(userMessages = messages)   
				}              
			}
		}
	}
}
```

```kotlin
class NewsActivity : AppCompatActivity() {  
	
	private val viewModel: NewsViewModel by viewModels()    
	override fun onCreate(savedInstanceState: Bundle?) {     
	...     
	  
	lifecycleScope.launch {            
		repeatOnLifecycle(Lifecycle.State.STARTED) {                
			// Bind the visibility of the progressBar to the state of isFetchingArticles.                
			viewModel.uiState                    
				.map { it.isFetchingArticles }                    
				.distinctUntilChanged()                    
				.collect { progressBar.isVisible = it }                    
		}
	}
}

```

###### The **UI state** 
is what the app gives to View to display for user.    e.g.: "**NewsUiState**", "**NewsItemUiState**"
```kotlin 
data class NewsUiState(    
	val isFetchingArticles: Boolean = false
	val isSignedIn: Boolean = false,    
	val isPremium: Boolean = false,    
	val newsItems: List<NewsItemUiState> = listOf(),   
	val userMessages: List<Message> = listOf(),
)

val NewsUiState.canBookmarkNews: Boolean get() = isSignedIn && isPremium

data class NewsItemUiState(    
	val title: String,    
	val body: String,    
	val bookmarked: Boolean = false,    
	...)
```

###### The **UI element**s (Views what the user sees)