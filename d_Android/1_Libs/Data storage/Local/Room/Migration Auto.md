- Добавляем поле "autoMigrations" 
- Меняем версию "DB_VERSION"
###### Database.kt (commonMain)
```kotlin
import androidx.room.Dao  
import androidx.room.Database  
import androidx.room.Delete  
import androidx.room.Entity  
import androidx.room.Insert  
import androidx.room.OnConflictStrategy  
import androidx.room.PrimaryKey  
import androidx.room.Query  
import androidx.room.RoomDatabase  
import androidx.room.Update  
import kotlinx.coroutines.flow.Flow  
  
const val DATABASE_NAME = "artha.db"  
  
@Database(  
    version = DB_VERSION,  
    exportSchema = true,  
    entities = [  
        AccountEntity::class,  
        CategoryEntity::class,  
        TransactionEntity::class  
    ],
    autoMigrations = [  
	    AutoMigration(from = 1, to = 2),  
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
```

- ОБЯЗАТЕЛЬНО указываем "defaultValue"
###### AccountEntity.kt
```kotlin
@Entity(tableName = "accounts")  
data class AccountEntity(  
    @PrimaryKey(autoGenerate = true)   
	val id: Int = 0,  
	val title: String,
	@ColumnInfo(name = "month_name", defaultValue = "no_val")
	val monthName: Long,
)
```
