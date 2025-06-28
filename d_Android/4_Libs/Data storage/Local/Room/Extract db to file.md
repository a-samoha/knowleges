
###### Extract Database to File !до Android 10 (API 29)
```kotlin
import android.content.Context
import android.os.Environment
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException

fun exportDatabase(context: Context) {
    val dbName = "имя_базы_данных"
    val dbPath = context.getDatabasePath(dbName).absolutePath
    val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
    val backupFile = File(downloadsDir, "$dbName.db")

    try {
        FileInputStream(dbPath).use { input ->
            FileOutputStream(backupFile).use { output ->
                input.copyTo(output)
            }
        }
        // Экспорт успешен
    } catch (e: IOException) {
        e.printStackTrace()
        // Обработка ошибки
    }
}
```

###### Extract Database to File in Downloads ( с Android 10 (API 29) и выше)
```kotlin
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import java.io.FileInputStream
import java.io.OutputStream

fun exportDatabaseToDownloads(context: Context) {
    val dbName = "your_database_name" // Замените на имя вашей базы данных
    val dbPath = context.getDatabasePath(dbName).absolutePath
    val contentResolver = context.contentResolver

    val contentValues = ContentValues().apply {
        put(MediaStore.MediaColumns.DISPLAY_NAME, "$dbName.db")
        put(MediaStore.MediaColumns.MIME_TYPE, "application/octet-stream")
        put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
    }

    val uri: Uri? = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
    uri?.let {
        try {
            val inputStream = FileInputStream(dbPath)
            val outputStream: OutputStream? = contentResolver.openOutputStream(it)

            outputStream?.use { output ->
                inputStream.copyTo(output)
            }

            inputStream.close()
            // Экспорт успешен
        } catch (e: Exception) {
            e.printStackTrace()
            // Обработка ошибки
        }
    } ?: run {
        // Обработка ошибки при создании URI
    }
}
```

###### Import Database from File ( с Android 11 (API 30) и выше)
```kotlin
import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class MainActivity : AppCompatActivity() {

	/**  
	 * Required to declare registerForActivityResult before Lifecycle.State.STARTED 
	 * LifecycleOwners must call register before they are STARTED. 
	 */
    private val pickFileLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val uri: Uri? = result.data?.data
                uri?.let {
                    handleSelectedFile(it) // Обрабатываем файл
                }
            }
        }
	
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        selectFile() // Запуск выбора файла при старте
    }
	
    private fun selectFile() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
        }
        pickFileLauncher.launch(intent) // Запускаем диалог выбора файла
    }
    
    private fun handleSelectedDbFile(uri: Uri) {  
	    val dbName = "your_database_name"  
	    val dbPath = this.getDatabasePath(dbName).absolutePath  
		  
	    try {  
	        val inputStream: InputStream? = this.contentResolver.openInputStream(uri)  
	        val outputStream = FileOutputStream(dbPath)  
		  
	        inputStream?.use { input ->  
	            outputStream.use { output ->  
	                input.copyTo(output)  
	            }  
	        }        
	        showToast("Database imported successfully")  
	    } catch (e: Exception) {  
	        e.printStackTrace()  
	        showToast("Something went wrong")  
	    }  
    }
}

```

