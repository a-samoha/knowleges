## Interface Callback

Java
```java
public interface Callback<R> {  
    void onResult(R result);  
    void onError(Exception e);  
}
```

Kotlin
```kotlin
interface Callback<R> {  
    fun onResult(result: R)  
    fun onError(e: Exception?)  
}
```

## USE (var1)
```kotlin
class SignInCallback(
	private val emitter: SingleEmitter<SignInResult>
) : Callback<SignInResult> {  
	  
    override fun onResult(result: SignInResult) {  
        if (emitter.isDisposed.not()) emitter.onSuccess(result)  
    }  
	  
    override fun onError(error: Exception) {  
        if (emitter.isDisposed.not()) emitter.onError(error)  
    }  
}
```

## USE (var2)
```kotlin
fun initialize(): Completable = 
	Completable.create { emitter ->  
	    someClient.initialize( // this fun requires CallbackImpl object
	        object : Callback<UserStateDetails?> {  
	            override fun onResult(result: UserStateDetails?) {  
	                // TODO something onResult 
	            }  
				  
	            override fun onError(error: Exception?) {  
	                // TODO something onResult 
	            }  
	    })  
}
```