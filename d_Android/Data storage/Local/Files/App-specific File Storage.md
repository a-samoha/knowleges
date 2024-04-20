#data_storage
###### Device file explorer / data / data /
![[Pasted image 20220629200017.png]]

###### Important
- Directories are File class instances
- Files are removed with uninstalling.
- *To further protect app-specific files, use the [Security library](https://developer.android.com/topic/security/data) that's part of [Android Jetpack](https://developer.android.com/jetpack) to encrypt these files at rest.*

```kotlin
var files: Array<String> = context.fileList()
var files: Array<String> = File("some_path").fileList()
```

### Internal storage directories:
###### Description
 The system prevents other apps from accessing these locations, and on Android 10 (API level 29) and higher, these locations are encrypted. These characteristics make these locations a good place to store sensitive data that only your app itself can access.

###### Create dir
```kotlin
/*
* context.getDir() - метод возвращающий File 
* Вернет папку уровня приложения (на ровне с files и database)
* к имени автоматически будет добавлено "app_" 
* напр.: "app_flutter"
*/
context.getDir("myfolder", Context.MODE_PRIVATE).run { if (!exists()) mkdir() }

/*
* context.filesDir это системная переменная у которой можно взять путь
* добавить к нему имя файла/папки и проверить существование. 
* Если не существует - создаем.
*/
File(context.filesDir.path + File.separator + "myfolder").run { if (!exists()) mkdir() }

// mkdir()  -
// mkdirs() - 
```

###### Create file
```kotlin

// Store a file to Internal storage using File API
File(context.filesDir.path + File.separator + "myfolder", "file_in_folder").run {  
    if (!exists()) createNewFile()  
    if (exists()) {  
        val fos = FileOutputStream(this, true)  
        fos.write("Hello world!\n".toByteArray())  
        fos.close()  
    }  
}

// Store a file to Internal storage using a stream
context.openFileOutput("myfile", Context.MODE_PRIVATE).use {
	it.write("Hello world!".toByteArray())  
}
```

###### Read file
```kotlin
// get file from Internal storage using a File API
val file = File(context.filesDir, filename)

// Read a file from Internal storage using a stream
context.openFileInput(filename).bufferedReader().useLines { lines ->    
	lines.fold("") { some, text ->        
		"$some\n$text"    
	}  
}
```

###### Delete file
```kotlin
File("some_path").delete()  // or
context.deleteFile(fileName)
```
###### Cache file
```kotlin 
// create
File.createTempFile(filename, null, context.cacheDir)

// read 
val cacheFile = File(context.cacheDir, filename)

// delete
cacheFile.delete()    // clean all cache
context.deleteFile(cacheFileName) // delete one specific file
```

### External storage directories (SD card):
###### Description
Although it's possible for another app to access these directories if that app has the proper permissions, the ***files stored in these directories are meant for use only by your app*** . If you specifically intend to create files that other apps should be able to access, your app should store these files in the [shared storage](https://developer.android.com/training/data-storage/shared) part of external storage instead.

The files in these directories aren't guaranteed to be accessible, such as when a removable SD card is taken out of the device.

###### Common
```kotlin
// Checks if a volume containing external storage is available for read and write.  
fun isExternalStorageWritable(): Boolean {    
	return Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED  
}  
  
// Checks if a volume containing external storage is available to at least read.  
fun isExternalStorageReadable(): Boolean {     
	return Environment.getExternalStorageState() in        
		setOf(Environment.MEDIA_MOUNTED, Environment.MEDIA_MOUNTED_READ_ONLY)  
}

// On devices without removable external storage, use the following command to enable 
// a virtual volume for testing your external storage availability logic:
adb shell sm set-virtual-disk true

// To access the different locations, call ContextCompat.getExternalFilesDirs().
// As shown in the code snippet, the first element in the returned array is 
// the primary external storage volume. Use this volume unless it's full or unavailable.
val externalStorageVolumes: Array<out File> =
	ContextCompat.getExternalFilesDirs(applicationContext, null)  
val primaryExternalStorage = externalStorageVolumes[0]

// To access app-specific files from external storage, call
val appSpecificExternalDir = File(context.getExternalFilesDir(null), filename)
val externalCacheFile = File(context.externalCacheDir, filename)

// To remove a file from the external cache directory
context.externalCacheFile.delete()
```

###### Media content
If your app works with media files that provide value to the user only within your app, it's best to store them in app-specific directories within external storage, as demonstrated in the following code snippet:
```kotlin
fun getAppSpecificAlbumStorageDir(context: Context, albumName: String): File? {
	// Get the pictures directory that's inside the app-specific directory on external storage.    
	val file = File(context.getExternalFilesDir(
		Environment.DIRECTORY_PICTURES), albumName)   
		if (!file?.mkdirs()) {        
			Log.e(LOG_TAG, "Directory not created")    
		}
	return file
	}
```