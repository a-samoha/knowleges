#rx_Java 

``` kotlin
data class AppRxSchedulers(  
    val database: Scheduler,  
    val disk: Scheduler,  
    val network: Scheduler,  
    val main: Scheduler  
)

@Singleton  
@Provides  
fun provideRxSchedulers() = AppRxSchedulers(  
        _database_ = Schedulers.single(),  
        _disk_ = Schedulers.io(),  
        _network_ = Schedulers.io(),  
        _main_ = AndroidSchedulers.mainThread()  
)
```