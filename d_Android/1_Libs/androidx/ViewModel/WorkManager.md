[medium - WorkManager basics](https://medium.com/androiddevelopers/workmanager-basics-beba51e94048)

![[Pasted image 20230102144433.png]]

```kotlin
api "androidx.work:work-runtime-ktx:2.7.1"
```

## UploadWorker 
```kotlin
class UploadWorker(appContext: Context, workerParams: WorkerParameters)
		: Worker(appContext, workerParams) { // synchronous
		: CoroutineWorker(ctx, params) { // asynchronous (saving data in the database or doing network requests)
		
	override fun doWork(): Result {
		return try {
			// Get the input
			val imageUriInput = inputData.getString(Constants.KEY_IMAGE_URI)
			
			// Do the work
			val response = upload(imageUriInput) // synchronous
			
			// workDataOf (part of KTX) converts a list of pairs to a [Data] object.
			val outputData = workDataOf(Constants.KEY_IMAGE_URI to response.body().data.link)
			
			// asynchronous
			// save uri in the database 
			val imageDao = ImagesDatabase.getDatabase(applicationContext).blurredImageDao()
			imageDao.insert(BlurredImage(resourceUri))
			// By default `doWork()` uses `Dispatchers.Default`. 
			// You can override this with the Dispatcher that you need. 
			// In our case, we don’t need to do this because 
			// Room already moves the insert work on a different Dispatcher. 
			
			Result.success(outputData)
		catch (e: Exception) {
			return Result.failure()
		}
	}

	fun upload(imageUri: String): Response {
		TODO(“Webservice request code here”)
		// Webservice request code here; note this would need to be run
		// synchronously for reasons explained below.
	}
}
```

## ViewModel
```kotlin
class SomeViewModel(
	...
): BaseViewModel() {
...
	val constraints = Constraints.Builder()
		.setRequiresBatteryNotLow(true)
		.setRequiredNetworkType(NetworkType.CONNECTED)
		.setRequiresCharging(true)
		.setRequiresStorageNotLow(true)
		.setRequiresDeviceIdle(true)
		.build()
		
	val imageData = workDataOf(Constants.KEY_IMAGE_URI to imageUriString)
	val uploadWorkRequest = OneTimeWorkRequestBuilder<UploadWorker>()
		.setInputData(imageData)
		.setConstraints(constraints)
		.setBackoffCriteria(
			BackoffPolicy.LINEAR,
			OneTimeWorkRequest.MIN_BACKOFF_MILLIS,
			TimeUnit.MILLISECONDS)
		.build()

	WorkManager.getInstance().enqueue(uploadWorkRequest) // Actually start the work
		// or
	val workManager = WorkManager.getInstance(context)
	val continuation = workManager.beginUniqueWork(uploadWorkRequest)
	continuation.enqueue()
}
```

## Using Chains for dependent work
```kotlin
val compressWorkRequest = OneTimeWorkRequestBuilder<CompressWorker>()
	.setInputMerger(ArrayCreatingInputMerger::class.java)
	.setConstraints(constraints)
	.build()
	
WorkManager.getInstance()
	.beginWith(Arrays.asList(
		filterImageOneWorkRequest,
		filterImageTwoWorkRequest,
		filterImageThreeWorkRequest))
	.then(compressWorkRequest)
	.then(uploadWorkRequest)
	.enqueue()
```

## Observing your WorkRequest status
```kotlin
// In your UI (activity, fragment, etc)
WorkManager.getInstance()
	.getWorkInfoByIdLiveData(uploadWorkRequest.id)
	.observe(lifecycleOwner, Observer { workInfo ->
		// Check if the current work's state is "successfully finished"
		if (workInfo != null && workInfo.state == WorkInfo.State.SUCCEEDED) {
		displayImage(workInfo.outputData.getString(KEY_IMAGE_URI))
		}
	})
```

![[Pasted image 20230102142658.png]]

## Behind the Scenes — How work runs
By default, `WorkManager` will:
-   Run your work **off of the main thread** (this assumes you are extending the `Worker` class, as shown above in `UploadWorker`).
-   **Guarantee** your work will execute (it won’t forget to run your work, even if you restart the device or the app exits).
-   Run according to **best practices for the user’s API level** (as described in the [previous article](https://medium.com/androiddevelopers/introducing-workmanager-2083bcfc4712)).

Behind the scenes, WorkManager includes the following parts:
-   **Internal TaskExecutor**: A single threaded `[Executor](https://developer.android.com/reference/java/util/concurrent/Executor)` that handles all the requests to enqueue work. If you’re not familiar with `Executors` you can read more about them [here](https://developer.android.com/reference/java/util/concurrent/Executor).
-   **WorkManager database**: A local database that tracks all of the information and statuses of all of your work. This includes things like the current state of the work, the inputs and outputs to and from the work and any constraints on the work. This database is what enables WorkManager to guarantee your work will finish — if your user’s device restarts and work gets interrupted, all of the details of the work can be pulled from the database and the work can be restarted when the device boots up again.
-   **WorkerFactory****: A default factory that creates instances of your `Worker`s. We’ll cover why and how to configure this in a future blog post.
-   **Default Executor****: A default executor that runs your work unless you specify otherwise. This ensures that by default, your work runs synchronously and off of the main thread.

![[Pasted image 20230102142008.png]]

When you enqueue your `WorkRequest`:
1.  The Internal TaskExecutor immediately saves your `WorkRequest` info to the WorkManager database.
2.  Later, when the `Constraints` for the `WorkRequest` are met (which could be immediately), the Internal TaskExecutor tells the `WorkerFactory` to create a `Worker`.
3.  Then the default `Executor` calls your `Worker`’s `doWork()` method **off of the main thread.**
