Store structured data in a private database.
Room is **androidx** library.
### Android project
### KMP project
###### libs.versions.toml
```kotlin
[versions]
room = "2.7.0-beta01"  
devtoolsksp = "2.1.0-1.0.29"

[plugins]
devtools-ksp = { id = "com.google.devtools.ksp", version.ref = "devtoolsksp" } # (KSP) Kotlin Symbol Processing
// with `ksp { arg("room.schemaLocation", "${projectDir}/schemas") }` in build.gradle.kts (Module level)

// room plugin can be used instead of devtools-ksp
androidx-room = { id = "androidx.room", version = "2.7.0-beta01" }
// with  `room { schemaDirectory.set(file("$projectDir/schemas")) }`  in build.gradle.kts (Module level)

[libraries]
androidx-room-runtime = { module = "androidx.room:room-runtime", version.ref = "room" } # runtime part of the library  
androidx-room-compiler = { module = "androidx.room:room-compiler", version.ref = "room" } # (KSP) processor that generates code
```

###### build.gradle.kts (Project level)
```kotlin
plugins {  
    ...
    alias(libs.plugins.devtools.ksp) apply false  
}
```

###### build.gradle.kts (Module level)
```kotlin
plugins {  
    ...
    alias(libs.plugins.devtools.ksp)  
}

kotlin{ 
	...
	listOf(  
	    iosX64(),  
	    iosArm64(),  
	    iosSimulatorArm64()  
	).forEach { iosTarget ->  
	    iosTarget.binaries.framework {  
	        baseName = "ComposeApp"  
	        isStatic = true  
	        linkerOpts.add("-lsqlite3") // Required for NativeSQLiteDriver  
	    }  
	}
}

sourceSets {
	androidMain.dependencies { .. }
	
	commonMain.dependencies {
		...
		implementation(libs.androidx.room.runtime)
	}
	
	nativeMain.dependencies { .. }
}

// for (KSP) Kotlin Symbol Processing  
// следующие строки нужны, чтобы создавать БД при первом запуске арр.
// если их удалить, уже установленная арр с существующей БД работать будет,
// но заново установленная арр на новом телефоне НЕ запустится.

ksp { arg("room.schemaLocation", "${projectDir}/schemas") } 
  
dependencies {  
    listOf(  
        "kspAndroid",  
        // "kspJvm",  
        "kspIosSimulatorArm64",  
        "kspIosX64",  
        "kspIosArm64"  
    ).forEach {  
        add(it, libs.androidx.room.compiler) // for (KSP)
    }
}
```

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
  
@Database(entities = [AccountEntity::class], version = 1)  
abstract class ArthaDatabase : RoomDatabase() {  
    abstract fun accountDao(): AccountDao  
}  
  
@Dao  
interface AccountDao {  
    @Insert  
    suspend fun insert(account: AccountEntity)  
	  
    @Update  
    suspend fun update(account: AccountEntity)  
	  
    @Insert(onConflict = OnConflictStrategy.REPLACE)  
    suspend fun upsert(account: AccountEntity)  
	  
    @Query("SELECT * FROM accounts WHERE id = :id")  
    suspend fun getAccountById(id: Int): AccountEntity?  
	  
    @Query("SELECT * FROM accounts")  
    fun observeAllAccounts(): Flow<List<AccountEntity>>  
	  
    @Delete  
    suspend fun delete(account: AccountEntity)  
	  
    @Query("DELETE FROM accounts WHERE id = :accountId")  
    suspend fun deleteById(accountId: Int)  
}  
  
@Entity(tableName = "accounts")  
data class AccountEntity(  
    @PrimaryKey(autoGenerate = true) val id: Int = 0,  
    val title: String,  
    val balance: Double  
)
```

###### DatabaseAndroid.kt (androidMain)
```kotlin
import android.content.Context  
import androidx.room.Room  
import androidx.sqlite.driver.AndroidSQLiteDriver  
import kotlinx.coroutines.Dispatchers  
  
fun getDatabase(ctx: Context): ArthaDatabase {  
    val appContext = ctx.applicationContext  
    val dbFile = appContext.getDatabasePath(DATABASE_NAME)  
    return Room.databaseBuilder<ArthaDatabase>(  
        context = appContext,  
        name = dbFile.absolutePath  
    )  
        .setDriver(AndroidSQLiteDriver())  
        .setQueryCoroutineContext(Dispatchers.IO)  
        .build()  
}
```

###### DatabaseIos.kt (nativeMain)
```kotlin
import androidx.room.Room  
import androidx.sqlite.driver.NativeSQLiteDriver  
import kotlinx.cinterop.ExperimentalForeignApi  
import kotlinx.coroutines.Dispatchers  
import kotlinx.coroutines.IO  
import platform.Foundation.NSDocumentDirectory  
import platform.Foundation.NSFileManager  
import platform.Foundation.NSUserDomainMask  
  
fun getDatabase(): ArthaDatabase {  
    val dbFilePath = documentDirectory() + "/$DATABASE_NAME"  
    return Room.databaseBuilder<ArthaDatabase>(name = dbFilePath)  
        .setDriver(NativeSQLiteDriver())  
        .setQueryCoroutineContext(Dispatchers.IO)  
        .build()  
}  
  
@OptIn(ExperimentalForeignApi::class)  
private fun documentDirectory(): String {  
    val documentDirectory = NSFileManager.defaultManager.URLForDirectory(  
        directory = NSDocumentDirectory,  
        inDomain = NSUserDomainMask,  
        appropriateForURL = null,  
        create = false,  
        error = null,  
    )  
    return requireNotNull(documentDirectory?.path)  
}
```
###### modules.android.kt (androidMain)
```kptlin
actual val platformModule = module {  
    single<ArthaDatabase> { getDatabase(androidContext()) }
}
```
###### modules.native.kt
```kptlin
actual val platformModule = module {  
    single<ArthaDatabase> { getDatabase() }
}
```
###### AccountsRepositoryImpl.kt (commonMain)
```
class AccountsRepositoryImpl(  
    private val db: ArthaDatabase,  
) : AccountsRepository { 

	override fun observe(): Flow<List<AccountModel>> = 
		db.accountDao().observeAllAccounts()  
		    .map { it.map { entity -> AccountModel( ... ) } }
}
```

