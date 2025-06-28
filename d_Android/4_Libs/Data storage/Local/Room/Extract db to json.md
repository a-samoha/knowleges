###### Extract Database to Json in Downloads
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

###### Import Database from Json
```kotlin
private suspend fun importDataFromJson(jsonString: String) {  
    val gson = GsonBuilder()  
        .registerTypeAdapter(AccountEntity::class.java, object :  
            JsonDeserializer<AccountEntity> {  
            override fun deserialize(  
                json: JsonElement,  
                typeOfT: Type,  
                context: JsonDeserializationContext  
            ): AccountEntity {  
                val jsonObject = json.asJsonObject  
  
                return AccountEntity(  
                    id = jsonObject["id"]?.asInt ?: 0,  
                    title = jsonObject["title"]?.asString ?: "",  
                    month = jsonObject["month"]?.asLong ?: 0L,  
                    monthName = jsonObject["monthName"]?.asString  
                        ?: (jsonObject["month"]?.asLong ?: 0L)  
                            .toLocalDate()  
                            .toCategoryMonthString(),  
                    monthStartBalance = jsonObject["monthStartBalance"]?.asDouble ?: 0.0  
                )  
            }  
        })  
        .create()  
    val exportData = gson.fromJson(jsonString, ExportData::class.java)  
  
    val database = DatabaseAndroid.getInstance(this)  
    val accountDao = database.accountDao()  
    val categoryDao = database.categoryDao()  
    val transactionDao = database.transactionDao()  
  
    withContext(Dispatchers.IO) {  
        accountDao.insertAllStrategyReplace(exportData.accounts)  
        categoryDao.insertAllStrategyReplace(exportData.categories)  
        transactionDao.insertAllStrategyReplace(exportData.transactions)  
    }  
}
```