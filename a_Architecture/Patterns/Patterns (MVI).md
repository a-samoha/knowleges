#architecture 
[источник](https://staltz.com/unidirectional-user-interface-architectures.html)

от  Lackner:  
- в MVI все данные для скрина лежат в ОДНОМ data class, напр.:
	```kotlin
	data class HomeState(
		val isLoading: Boolean = false,
		val userName: Strin = "",
		val date: Date? = null,
	)
	```
	- в той час як у MVVM усі поля передаються в срін окремими flow

# UDF - Unidirectional data flow 
	(принцип управления пользовательским интерфейсом.)

## **MVI** view( model( intent())) == **mvu** (Model View UseCase) 
				render( state( actions()))
**Водопад экшенов и стейтов**

	Когда испльзовали EventBus - сталкивались с проблемами: 
	- не понятно откуда прилетает Event и кто его инициирует.

![[mvi.jpg]]
![[Pasted image 20220803165945.png]]
## **Задача:** "Отправить запрос на поиск по клику"
![[Pasted image 20220803165131.png]]
## Как **НЕ нужно** делать:
```kotlin
btnSubmit.clicks()                                      // Здесь ЧИТАЕМ Ui - текущий стейт
	.doOnNext {
		btnSubmit.isEnabled = false
		progressView.visibility = VISIBLE               // Здесь меняем Ui 
	}
	.flatMap { api.serch( searchView.text.toString()) } // Здесь ЧИТАЕМ Ui 
	.observeOn(uiScheduller)
	.doOnNext { progressView.visibility = GONE }        // Здесь меняем Ui 
	.subscribe(
		{ data -> showData(data) },
		{
			btnSubmit.isEnabled = true                  // Здесь меняем Ui 
			toast("Search failed")
		}
	)
```
## Как **нужно** делать:
### **Простой** вариант с одним действием
```kotlin
// Простой вариант с одним действием
sealed class UiAction {
	class SearchAction(val query: String) : UiAction()
}

sealed class UiState {
	object Loading : UiState()
	class Success(val data: Data) : UiState()
	class Failure(val error: Thowable) : UiState()
}

val actions = submitBtn.clicks()
	.map { SearchAction(searchView.text.toString()) }   // Вся информация из UI получена в одном месте

val states = actions.flatMap { action ->                // Логические операции:
	api.search(action.query)                            // - запрос в api 
		.map<UiState> { result -> Success(result) }     // - действие при удачном завершении запроса
		.onErrorReturn { e-> Failure(e) }               // - действие при ошибке
		.observeOn(uiScheduler)
		.startWith(Loading)                             // - перед запросом возвращается Loading состояние
}

states.subscribe(::render)

privet fun render(state: UiState) {                      // Oбработка и отображение стейтов
	btnSubmit.isEnabled = state !is Loading              // - блокируем кнопку
	progressView.visibility = if (state is Loading) VISIBLE else GONE // - показываем загрузку
	when (state {
		is Success -> finish()                           // - регируем на результат
		is Failure -> toast("Search failed")             // - реагируем на ошибку
	})
}
```
```kotlin
// Можно вынести логику в отдельный компонент:
class SearchComponent(privet val api: Api, val uiScheduller: Scheduller){
	
	fun bind (actions: Observable<SearchAction>): Observable<UiState> {
		return actions.flatMap { action ->                      // Логические операции:
			api.search(action.query)                            // - запрос в api 
				.map<UiState> { result -> Success(result) }     // - действие при удачном завершении запроса
				.onErrorReturn { e-> Failure(e) }               // - действие при ошибке
				.observeOn(uiScheduler)
				.startWith(Loading)                             // - перед запросом возвращается Loading состояние
	}
}
```
```kotlin
// используем на View part
searchComponent.bind(actions).subscribe(::render)
```
### Варинт **с автокомплитом** (предлагать слова по введнным буквам)
```kotlin
// Варинт с автокомплитом (предлагать слова по введнным буквам)
sealed class UiAction : Action {
	class SearchAction(val query: String) : UiAction()
	class LoadSuggestionsAction(val query: String) : UiAction()
}

class UiState(
	val loading: Bolean = false,
	val data: String? = null,
	val error: Throwable? = null,
	val suggection: List<String>? = null
)

seald class InternalAction : Action {
	object SearchLoadingAction : InternalAction()
	class  SearchSuccessAction(val data: String) : InternalAction()
	object SearchFailureAction(val error: Throwable) : InternalAction()
	object SuggestionsLoadedAction(val suggestions: List<String>) : InternalAction()
}

// Можно вынести логику в отдельный компонент:
class SearchComponent(privet val api: Api, val uiScheduller: Scheduller){

	fun bind(actions: Observable<Action>): Observable<UiState>{
		return actions.publish { shared ->
			Observable.merge<Action>(
				bind(shared.ofType<SearchAction>())
				bind(shared.ofType<LoadSuggestionsAction>()))
		}
		// .scan() позволяет кешировать текущее значение стейта и 
		// проводить изменения на основе последнего запомненного значения
		// это Reducer
		.scan(UiState()){ state, action ->    
			when (action) {
				SearchLoadingAction -> state.copy(
					loading = true,
					error = null,
					suggestions = null)
				is SearchSuccessAction -> state.copy(
					loading = false,
					data = newData,
					error = null,
					suggestions = null)
				is SearchFailureAction -> state.copy(
					loading = false,
					error = action.error)
				is SuggestionsLoadedAction -> state.copy(
					suggestions = action.suggestions)
				is SearchAction, is LoadSuggestionsAction -> state // обрабатываем все нужные акшоны
			}
		}
	}
}

// Middleware
fun bind(actions: Observable<SearchAction>): Observable<InternalAction>{
	return actions.flatMap { action ->                // Логические операции:
		api.search(action.query)                            // - запрос в api 
			.map<UiState> { result -> SearchSuccessAction(result) }     // - действие при удачном завершении запроса
			.onErrorReturn { e-> SearchFailureAction(e) }               // - действие при ошибке
			.observeOn(uiScheduler)
			.startWith(SearchLoadingAction)                             // - перед запросом возвращается Loading состояние
}

// Middleware
fun bind(actions: Observable<LoadSuggestionsAction>): Observable<InternalAction>{
	return actions.flatMap { action ->                     // Логические операции:
		api.sugestions(action.query)                       // - запрос в api 
			.onErrorReturnItem (emptyLIst())               // - действие при ошибке
			.map { result -> SuggestionsLoadedAction(result) }     // - действие при удачном завершении запроса
			.observeOn(uiScheduler)
}
```
## Архитектура
![[Pasted image 20220803215011.png]]
![[Pasted image 20220803215131.png]]
![[Pasted image 20220803215641.png]]
Store описанный выше описывает одну фичу
## MVI Core:
```kotlin
// Store
class Store <A, S> (
	private val reducer: Reducer<S, A>,
	private val middlewares: List<Middleware<S, A>>,
	private val initialState: S,
) {
	fun wire(): Disposable {}
	fun bind(view: MviView<Action, UiState>): Disposable {}
}

// Middleware - занимается внешним взаимодействием с ОС или сетью
interface Middleware<A, S> {
	fun bind(actions: Observable<A>, state: Observable<S>): Observable<A>
}

// Reducer - меняем состояние на основе каких-то входящих данных
interface Reducer<S, A> { 
	fun reduce(state: S, action :A): S
}

// Для любого фрагмента или Активити
interface MviView<A, S> {
	val actions: Observable<A>
	fun render(state: S)
}
```

## Bind it All:
```kotlin

// В конструкторе приходит правильно настроенный Store
class SearchViewModel<A, S>
@Inject constructor (private val store: Store<A, S>) : ViewModel(){

	// цепляемся к нашему PipeLine (цепочке)
	private val wiring = store.wire()
	private var viewBinding: Disposable? = null

	override fun onCleared(){
		// гасим наш PipeLine (цепочку)
		wiring.dispose()
	}

	// используем эти 2 метода при повороте екрана
	fun bind(view: MviView<A, S>){
		viewBinding = store.bind(view)
	}
	fun unbind(){
		viewBinding?.dispose()
	}
}
```

## Listener - многоразовый
## CallBack - одноразовый инстанс