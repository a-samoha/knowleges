
```kotlin
private fun exportDbToJson() {  
    val database = DatabaseAndroid.getInstance(this)  
    val accountDao = database.accountDao()  
    val categoryDao = database.categoryDao()  
    val transactionDao = database.transactionDao()  
  
    // Получаем данные из базы данных  
    lifecycleScope.launch {  
        withContext(Dispatchers.IO) {  
            val accounts = accountDao.observeAllAccounts().firstOrNull()  
            val categories = categoryDao.observeAllCategories().firstOrNull()  
            val transactions = transactionDao.observeAllTransactions().firstOrNull()  
  
            // Создаем объект для хранения всех данных  
            val exportData = mapOf(  
                "accounts" to accounts,  
                "categories" to categories,  
                "transactions" to transactions  
            )  
  
            // Инициализируем Gson с pretty printing для удобочитаемости  
            val gson: Gson = GsonBuilder().setPrettyPrinting().create()  
            val jsonString = gson.toJson(exportData)  
  
            // Определяем путь к директории "Загрузки"  
            val downloadsDir =  
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)  
            val dbName = ArthaDatabase.DB_NAME.split(".")[0]  
            val outputFileName = "$dbName-${today()}.json"  
            val file = File(downloadsDir, outputFileName)  
  
            var fileWriter: FileWriter? = null  
            try {  
                fileWriter = FileWriter(file)  
                fileWriter.write(jsonString)  
                fileWriter.flush()  
                withContext(Dispatchers.Main.immediate) {  
                    showToast("Данные успешно экспортированы в файл: ${file.absolutePath}")  
                }  
            } catch (e: IOException) {  
                e.printStackTrace()  
                withContext(Dispatchers.Main.immediate) {  
                    showToast("Ошибка при записи файла: ${e.localizedMessage}")  
                }  
            } finally {  
                try {  
                    fileWriter?.close()  
                } catch (e: IOException) {  
                    e.printStackTrace()  
                }  
            }  
        }  
    }}
```