- Создаем переменную "MIGRATION_1_2" 
- Меняем версию "DB_VERSION"
###### Database.kt (commonMain)
```kotlin  
@Database(  
    version = DB_VERSION,  
    exportSchema = true,  
    entities = [  
        AccountEntity::class,  
        CategoryEntity::class,  
        TransactionEntity::class  
    ],
)  
abstract class ArthaDatabase : RoomDatabase() {  
    abstract fun accountDao(): AccountDao    
	...
	companion object {  
	    const val DB_NAME = "artha.db"  // or "artha_db"
	    const val DB_VERSION = 2 // changed from "1"
	}
}  

val MIGRATION_1_2 = object : Migration(1, 2) {  
    override fun migrate(connection: SQLiteConnection) {  
        connection.execSQL("ALTER TABLE accounts ADD COLUMN monthName TEXT NOT NULL DEFAULT ''")  
    }  
}
```

- Добавляем нужное поле "monthName"
###### AccountEntity.kt
```kotlin
@Entity(tableName = "accounts")  
data class AccountEntity(  
    @PrimaryKey(autoGenerate = true)   
	val id: Int = 0,  
	val title: String,
	val monthName: Long,
)
```

- Добавляем строку в билдер
```kotlin
fun buildDatabase(ctx: Context): ArthaDatabase {  
    val appContext = ctx.applicationContext  
    val dbFile = appContext.getDatabasePath(ArthaDatabase.DB_NAME)  
    return Room.databaseBuilder<ArthaDatabase>(  
        context = appContext,  
        name = dbFile.absolutePath  
    )  
	    .addMigrations(MIGRATION_1_2, MIGRATION_2_3, ...) // explicit migration
        .setDriver(AndroidSQLiteDriver())  
        .setQueryCoroutineContext(Dispatchers.IO)  
        .build()  
}
```