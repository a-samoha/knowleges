
**!ВАЖЛИВО** відслідковувати сумісність версій наступних ліб:

- Gradle Plugin (agp="8.3.2")
- Kotlin (kotlin="1.9.22")
- ComposeBom (composeBom="2024.05.00")
- KSP (ksp="1.9.22-1.0.17")
- NavCompose (nav="2.7.7")
- Hilt (hilt="2.51.1")
- HiltNavCompose (hiltNavCompose="1.2.0")

## БЕЗ .toml  та БЕЗ navCompose
### build.gradle (TOP LEVEL)
```kotlin
// Top-level build file ...
plugins{
	...
	id("com.google.devtools.ksp") version "1.9.22-1.0.17" apply false // ksp - Kotlin Symbol Processing - потрібен щоб hilt міг генерувати додатковий код
	id("com.google.dagger.hilt.android") version "2.51.1" apply false
}
```

### build.gradle  (MODULE)
```kotlin
plugins{
	...
	id("com.google.devtools.ksp")
	id("com.google.dagger.hilt.android")
}

dependencies {
// ЗАКОМЕНТОВАНІ рядки використовуємо з лібою nav-compose
//api(com.google.dagger:hilt-android:2.51.1
//api(com.google.dagger:hilt-android-compiler:2.51.1)
//api(com.google.dagger:hilt-android-gradle-plugin:2.51.1)
//api(com.google.dagger:hilt-android-testing:2.51.1)
//api(androidx.hilt:hilt-navigation-compose:1.2.0)

implementation("com.google.dagger:hilt-android:2.51.1")
ksp("com.google.dagger:hilt-android-compiler:2.51.1")
...
}
```

## .toml  + NavCompose
### gradle/libs.versions.toml
```kotlin
[versions]    
agp = "8.6.1"
kotlin = "2.0.20"
ksp="2.0.20-1.0.25"
hilt = "2.51.1"
hiltNavCompose = "1.2.0"
composeBom = "2024.09.03"
navigationCompose = "2.8.2"

[plugins]  
ksp = { id = "com.google.devtools.ksp", version.ref = "ksp" }
hilt = { id = "com.google.dagger.hilt.android", version.ref = "hilt" }

[libraries]
androidx-navigation-compose = { group = "androidx.navigation", name = "navigation-compose", version.ref = "navigationCompose" }

hilt-android = { module = "com.google.dagger:hilt-android", version.ref = "hilt" }  
hilt-android-compiler = { module = "com.google.dagger:hilt-android-compiler", version.ref = "hilt" }  
hilt-navigation-compose = { module = "com.google.dagger:hilt-navigation-compose", version.ref = "hiltNavCompose" }
```
### build.gradle (TOP LEVEL)
```kotlin
// Top-level build file ...
plugins{
	...
	id("com.google.devtools.ksp") version "1.9.22-1.0.17" apply false // ksp - Kotlin Symbol Processing - потрібен щоб hilt міг генерувати додатковий код
	id("com.google.dagger.hilt.android") version "2.51.1" apply false
}
```

### build.gradle  (MODULE)
```kotlin
plugins{
	...
	id("com.google.devtools.ksp")
	id("com.google.dagger.hilt.android")
}

dependencies {
// ЗАКОМЕНТОВАНІ рядки використовуємо з лібою nav-compose
//api(com.google.dagger:hilt-android:2.51.1
//api(com.google.dagger:hilt-android-compiler:2.51.1)
//api(com.google.dagger:hilt-android-gradle-plugin:2.51.1)
//api(com.google.dagger:hilt-android-testing:2.51.1)
//api(androidx.hilt:hilt-navigation-compose:1.2.0)

implementation("com.google.dagger:hilt-android:2.51.1")
ksp("com.google.dagger:hilt-android-compiler:2.51.1")
...
}
```
## Реалізація
### AndroidManifest.xml
```kotlin
// ...
	<application  
	    android:name=".App" // реєструємо свій клас Application
	    // ...
```

### App.kt (Application)
```kotlin
import dagger.hilt.android.HiltAndroidApp  
  
@HiltAndroidApp  // This annotation will initialize the Hilt
class App : Application(), Configuration.Provider {  
    override fun getWorkManagerConfiguration(): Configuration =  
                Configuration.Builder()  
                        .setMinimumLoggingLevel(if (BuildConfig.DEBUG) android.util.Log.DEBUG else android.util.Log.ERROR)  
                        .build()  
}
```

### MainActivity.kt
```kotlin
@AndroidEntryPoint
class MainActivity : ComponentActivity(){
	...
}
```

### CusomViewModel
```kotlin
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

 @HiltViewModel  // This annotation will initialize the viewModel
class CusomViewModel @Inject internal constructor(  
    plantRepository: MyRepository,  
    private val savedStateHandle: SavedStateHandle  
) : ViewModel() {
	// ...
}
```

### DatabaseModule
```kotlin
import dagger.Module  
import dagger.Provides  
import dagger.hilt.InstallIn  
import dagger.hilt.android.qualifiers.ApplicationContext  
import dagger.hilt.components.SingletonComponent  
import javax.inject.Singleton  
  
@InstallIn(SingletonComponent::class)  
@Module  
class DatabaseModule {  
  
    @Singleton  
    @Provides   
    fun provideAppDatabase(@ApplicationContext context: Context): AppDatabase {  
        return AppDatabase.getInstance(context)  
    }  
  
    @Provides  
    fun providePlantDao(appDatabase: AppDatabase): PlantDao {  
        return appDatabase.plantDao()  
    }  
  
    @Provides  
    fun provideGardenPlantingDao(appDatabase: AppDatabase): GardenPlantingDao {  
        return appDatabase.gardenPlantingDao()  
    }  
}
```

### NetworkModule
```kotlin
import dagger.Module  
import dagger.Provides  
import dagger.hilt.InstallIn  
import dagger.hilt.components.SingletonComponent  
import javax.inject.Singleton  
  
@InstallIn(SingletonComponent::class)  
@Module  
class NetworkModule {  
  
    @Singleton  
    @Provides    
    fun provideUnsplashService(): UnsplashService {  
        return UnsplashService.create()  
    }  
}
```

[источник](https://habr.com/ru/post/488072/)
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

