[zendesk.github](https://zendesk.github.io/mobile_sdk_javadocs/supportv2/v211/zendesk/support/RequestProvider.html#getUpdatesForDevice--)

```kotlin
override suspend fun fetchZdUnreadMessagesCount(): Result<Unit> = runCatching {  
    withContext(Dispatchers.IO) {  
        Support.INSTANCE.provider()?.requestProvider()?.let { provider ->  
            val isUpdated = suspendCoroutine { continuation ->  
                provider.getAllRequests(object : ZendeskCallback<List<Request>>() {  
                    override fun onSuccess(result: List<Request>?) {  
                        continuation.resume(true)  
                    }  
					
                    override fun onError(error: ErrorResponse?) {  
                        continuation.resume(true)  
                    }  
                })  
            }  
			
            if (isUpdated) {  
                val unreadMassages = suspendCoroutine { continuation ->  
                    provider.getUpdatesForDevice(object : ZendeskCallback<RequestUpdates>() {  
                        override fun onSuccess(result: RequestUpdates?) {  
                            continuation.resume(result?.totalUpdates())  
                        }  
						
                        override fun onError(error: ErrorResponse?) {  
                            continuation.resumeWithException(IllegalAccessException(""))  
                        }  
                    })  
                }  
                unreadMassagesState.value = unreadMassages  
            }  
        }  
    }
}
```

```kotlin
override fun registerPushProvider(id: String): Completable = Completable.create { emitter ->  
    Zendesk.INSTANCE.provider()?.pushRegistrationProvider()  
        ?.registerWithDeviceIdentifier(id, object : ZendeskCallback<String>() {  
            override fun onSuccess(result: String) {  
                emitter.onComplete()  
            }  
			
            override fun onError(error: ErrorResponse?) {   
                emitter.tryOnError(IllegalStateException(error?.reason))  
            }  
        })  
}  

override fun unregisterPushProvider(): Completable = Completable.fromCallable {  
    Zendesk.INSTANCE.provider()?.pushRegistrationProvider()?.unregisterDevice(null)  
}
```