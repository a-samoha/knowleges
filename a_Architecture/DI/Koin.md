[Quickstart](https://insert-koin.io/docs/quickstart/kotlin)
[Documentation](https://insert-koin.io/docs/reference/koin-android/get-instances)

##### build.gradle
```kotlin
api 'io.insert-koin:koin-core:3.4.3'
// или 
api 'io.insert-koin:koin-android:3.4.3'
// или 
api 'io.insert-koin:koin-androidx-compose:3.4.3'
```

#### AndroidManifest.xml
```kotlin
// ...
	<application  
	    android:name=".ObscuraApplication"
	    // ...
```

##### ObscuraApplication.kt
```kotlin
class ObscuraApplication : Application() {  
  
    override fun onCreate() {  
        super.onCreate()  
        initializeDi()  
    }    
    private fun initializeDi() {  
        startKoin {  
            androidContext(this@ObscuraApplication)  
            modules(  
                viewModelModule,
                workerModule,
            )  
        }  
    }  
}
```

##### di/ViewModelModule.kt   _var1
```kotlin 
@Keep  
val viewModelModule = module {  
    viewModelOf(::HomeViewModel)  
}
```

### di/ViewModelModule.kt   _var2
```kotlin
import androidx.annotation.Keep  
import org.koin.androidx.viewmodel.dsl.viewModel  
import org.koin.dsl.module  
  
@Keep  
internal val viewModelModule = module {  
    viewModel {  (arg: Bundle) ->
	    TooltipDialogViewModel(
		    tooltipDialog = requireNotNull(arg.tooltipDialog),  
			someRepo = get(),
	    ) 
	}  
}
```

##### di/WorkerModule.kt
```kotlin
@Keep  
val workerModule = module {  
    single { NotificationWorker(androidContext(), get()) }  
}
```

##### HomeFragment + Home[[Create]]
```kotlin
import org.koin.androidx.viewmodel.ext.android.sharedViewModel
import org.koin.androidx.viewmodel.ext.android.viewModel  
  
class HomeFragment : Fragment() {  
  
    private val viewModel: HomeViewModel by viewModel()
    private val sharedViewModel: HomeSharedViewModel by sharedViewModel()  
	private val filterViewModel: FilterSharedViewModel by sharedViewModel()
```



##### [источник](https://habr.com/ru/post/488072/)
##### **Зависмости** - классы нужные для работы текущего класса
(классы которые передаются в конструктор текущего)
1.  `class Car() { val engine = Engine() }` - Car использует один тип Engine, нулевая тестируемость
2.  `class Car(val engine: Engine) {}` - Это внедрение зависимости DI

##### **Проблемы ручного внедрения:**
1.  `Дуплицированные` _стандартного кода_
2.  `Строгий порядок создания` _классов-зависимостей_
3.  `Сложность повторного использования` _кода:_
   _- нужно создавать синглтоны, что осложняет тестируемость_
либо
   _- создавать огромный **класс** **AppContainer** который будет управлять:_
1.  созданием зависимостей (посредством фабрик)
2.  удалением зависимостей из памяти

##### **2 паттерна:**
1.  ***внедрение зависимостей***   - на кодогенерации.   `ошибки при компиляции`
2.  **_сервис локатор_** _(_Koin, Guice_)_ - на рефлексии. `ошибки в рантайме`

##### **2 типа внедрения:**
1.  [Constructor Injection](https://developer.android.com/training/dependency-injection#kotlin) - **в конструктор** (не возможно для _Activity or Fragments_)
2.  [Field Injection](https://developer.android.com/training/dependency-injection#automated-di) - **сетить lateinit поля**  `class Car { lateinit var engine: Engine ... }`
               `fun main(args: Array) { ... car.engine = Engine() ... }`

##### [источник](https://insert-koin.io/docs/quickstart/kotlin/)
##### Анотации (можно описать зависимости только ими)
-   `@Single` declare class as singleton instances
 ```kotlin
 @Single
 class AuthRepositoryImpl() : AuthRepository {}
 ```
-   `@Factory`  declare it as Koin factory instance (recreated each time you need)
 ```kotlin
 @Factory
 class MySimplePresenter(val repo: AuthRepository) {}
 ```
-   `@KoinViewModel` declare it as Koin ViewModel instance.
 ```kotlin
 @KoinViewModel
 class MyViewModel(val repo : HelloRepository) : ViewModel() {}
 ```
-   `@Module` annotation declare the module class
-   `@ComponentScan` annotation scan for components - scan given package for Koin definitions
 ```kotlin
 @Module
 @ComponentScan("org.koin.sample.coffee")
 class CoffeeAppModule
```

##### Модуль и методы (чтобы описать зависимости в отдельных файлах = в одном месте)
```kotlin
import androidx.annotation.Keep  
...
import org.koin.dsl.module 

@Keep  // зачем эта анотация???
val myModule = module {
	// declare a singleton (var1)
	single<AuthRepository> { AuthRepositoryImpl(get()) } 
	// declare a singleton (var2)
	single { AuthRepositoryImpl(get()) as AuthRepository }
	// Constructor DSL way: (var3)
	singleOf(::AuthRepositoryImpl){bind<AuthRepository()>}

	
	// Classical DSL way:
	factory<AuthStateUseCase> {        // some interface name
        AuthStateUseCaseImpl(get())    // class wich implements it
    } 
    // or
    factory{ AuthStateUseCaseImpl(get()) as AuthStateUseCase }
    // Constructor DSL way:
    factoryOf(::AuthStateUseCaseImpl){ bind<AuthStateUseCase()>}
	
	
	viewModel { MyViewModel(get()) } 
	
}

class MyViewModel(val repo : AuthRepository) : ViewModel() {
	fun auth() = repo.auth()
}

	// Если нельзя объявлять поле класса прямо в конструкторе
	// Можно использовать метод ленивой инициализации:
class MyActivity : AppCompatActivity(){
	
	val useCase: AuthStateUseCase by inject()
	
	// allows us to retrieve a ViewModel instance from Koin, 
	// linked to the Android ViewModelFactory.
	val viewModel: MyViewModel by viewModel 
	// or 
	// The `getViewModel()` function is here to retrieve directly an instance (non lazy)
}
```
<br/>
<br/>
#### Пример:
##### дерево проекта
![[Pasted image 20220804165105.png]]
##### Start Koin
```kotlin
class MyApplication : Application(){

	override fun onCreate() {
		super.onCreate()
		// Start Koin
		startKoin{
			androidLogger()
			androidContext(this@MyApplication)
			modules(appModule)
		}
	}
}
```
##### DomainModule.kt
```kotlin  
  
@Keep  
val domainModule = module {  
  
    factory<AuthStateUseCase> {  
        AuthStateUseCaseImpl(get())  
    }  

    factory<LogOutUseCase> {  
        LogOutUseCaseImpl(get(), get(), get())  
    }  
    
    factory<GetAllProjectsUseCase> {  
        GetAllProjectsUseCaseImpl(get())  
    }  
  
    factory<SelectProjectUseCase> {  
        SelectProjectUseCaseImpl(get())  
    }  
}
```
##### ViewModelModule.kt
```kotlin
@Keep  
val viewModelModule = module {  
    viewModel { MainViewModel(get(), get()) }  
    viewModel { HomeViewModel(get(), get()) }  
    viewModel { LogInViewModel(get(), get()) }  
    viewModel { ProjectsViewModel(get(), get(), get()) }  
    viewModel { parameters -> CreateNewPasswordViewModel(parameters.get(), get(), get()) }  
    viewModel { ResetPasswordViewModel(get(), get()) }  
}
```
##### ProvidersModule.kt
```kotlin
@Keep  
val providersModule = module {  
  
    single<SchedulerProvider> { ApplicationRxSchedulers() }  
  
    single<BuildInfo> {  
        object : BuildInfo {  
            override val buildNumber: Int = BuildConfig.VERSION_CODE  
            override val versionName: String = BuildConfig.VERSION_NAME  
            override val environmentName: String = BuildConfig.ENVIRONMENT  
            override fun toString(): String = "v$versionName-$buildNumber-$environmentName"  
        }  
    }  
}
```
##### RemoteModule.kt
```kotlin
// region OkHttpClient
single {  
    OkHttpClient.Builder()  
        .apply {  
            if (BuildConfig.DEBUG) addNetworkInterceptor(get<HttpLoggingInterceptor>())  
            addNetworkInterceptor(get<AuthenticationInterceptor>())  
        }  
        .followRedirects(false)  
        .connectTimeout(HTTP_TIMEOUT, TimeUnit.SECONDS)  
        .readTimeout(HTTP_TIMEOUT, TimeUnit.SECONDS)  
        .build()  
}  
  
factory {  
    AuthenticationInterceptor(get())  
}  
    
factory {  
    HttpLoggingInterceptor(get<PrettyHttpLogger>()).apply {  
        level = HttpLoggingInterceptor.Level.BODY  
    }  
}
// endregion

// region Gson
single<Gson> {  
    GsonBuilder()  
        .setPrettyPrinting()  
        .create()  
}  
// endregion

// region Retrofit
single<Retrofit> {  
    Retrofit.Builder()  
        .baseUrl(BuildConfig.API)  
        .client(get())  
        .addCallAdapterFactory(get())  
        .addConverterFactory(get())  
        .build()  
}

single<Converter.Factory> {  
    GsonConverterFactory.create(get())  
}


single<CallAdapter.Factory> {  
    RxJava2CallAdapterFactory.create()  
}  
// endregion
```

##### RepositoryModule.kt
```kotlin
@Keep  
val repositoryModule = module {  
  
    single<AuthenticationRepository> {  
        AuthenticationRepositoryImpl(get())  
    }  
  
    single<UserRepository> {  
        UserRepositoryImpl(get())  
    }  
  
    single<ProjectRepository> {  
        ProjectRepositoryImpl(get(), get(), get())  
    }  
  
    single<IssueRepository> {  
        IssueRepositoryImpl(get(), get(), get())  
    }  
}
```