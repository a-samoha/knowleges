### 🚀 **Переключает ли Retrofit `suspend fun` в IO-поток автоматически?**

Да, **Retrofit автоматически выполняет сетевые запросы в `IO`-потоке**. Если использовать
`suspend fun` в интерфейсе API, то **не нужно вручную переключаться на `Dispatchers.IO`**.
Это сделано внутри **OkHttp**, который использует **свой внутренний пул потоков** (`OkHttp Dispatcher`).

---



Get - "открытый" запрос 1024 символа ограничение. Ключи значения видны в адресной строке

Post не меняет урлу, все данные из формы передаются в виде потока

Тело от заголовка отделяется пустой строкой \n

Content-type text/html text/mime image/gif

Content length важно указывать иначе браузер крутит прогресбар

Сервер - это программа висит на каком-либо порту

Порт - программа биндится на порт объявляет ОС, что она заняла порт и никто другой его занять не может

Если номер порта в запросе не указан - значит используется 80 по умолчанию

## JSON parsing

```kotlin
val myJsonString = "{"errors":{"myList":["Some text."]},"errorCodes":{"myList":["PredicateValidator"]}}"

val extractedData = parseSocureExtractedData(myJsonString)

private fun parseSocureExtractedData(json: String?): SocureExtractedData? =  
    json?.let { raw ->  
        Gson().fromJson(  
            raw,  
            object : TypeToken<SocureExtractedData>() {}.type,  
        )  
    }
```

или то же самое, но другим кодом:

```kotlin
val extractedData = Gson().fromJson(myJsonString, SocureExtractedData::class.java)
```


### paintings-list.json
-  хостится по адресу https://github.com/SamoshkinR-Tem/mmdd.pictures/raw/master/paintings-list.json
-  content:
```json
{
  "paintings": [
    {
      "id": "af7c1fe6-d669-414e-b066-e9733f0de7a8",
      "createdAt": "2022-11-27T19:39:02.471Z",
      "surface": "Canvas",
      "paint": "Oil",
      "image": "https://github.com/SamoshkinR-Tem/mmdd.pictures/blob/master/4x4/Ghovardhan.jpg"
    },
    {
      "id": "08c71152-c552-42e7-b094-f510ff44e9cb",
      "createdAt": "2022-11-27T19:39:02.471Z",
      "surface": "WoodenBoard",
      "paint": "Acrylic",
      "image": "https://github.com/SamoshkinR-Tem/mmdd.pictures/blob/master/4x4/Red.jpg"
    }
  ]
}
```


## Android Studio implementation


```gradle
implementation 'com.squareup.retrofit2:retrofit:2.9.0' 
implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
```


### PaintingsResponse.kt
```kotlin
data class PaintingsResponse(  
    @SerializedName("paintings") val paintings: List<Painting>,  
)

data class Painting(  
    @SerializedName("id") val id: String,  
    @SerializedName("createdAt") val createdAt: String,  
    @SerializedName("surface") val surface: String,  
	@SerializedName("paint") val paint: String,  
	@SerializedName("image") val image: String, 
)
```


### koin module
```kotlin
import androidx.annotation.Keep  
import com.artsam.data.api.PaintingsApi  
import com.artsam.data.utils.DateUtils.STANDARD_SERVER_FORMAT  
import com.google.gson.GsonBuilder  
import org.koin.dsl.module  
import retrofit2.Retrofit  
import retrofit2.converter.gson.GsonConverterFactory

@Keep
internal val apis = module {  
    single<PaintingsApi> {  
        val retrofit = Retrofit.Builder()  
            .baseUrl("https://github.com/SamoshkinR-Tem/mmdd.pictures/")  
            .addConverterFactory(createGsonConverterFactory())  
            .build()  
        retrofit.create(PaintingsApi::class.java)  
    }  
}  
  
private fun createGsonConverterFactory(): GsonConverterFactory {  
    val gson = GsonBuilder()  
        .setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSS")  
        .setLenient()  // resolves the MalformedJsonException
        .create()  
    return GsonConverterFactory.create(gson)  
}
```


### PaintingsApi.kt
```kotlin
import com.artsam.data.model.PaintingsResponse  
import retrofit2.http.GET  
import retrofit2.http.Header
import retrofit2.http.Path  
  
interface PaintingsApi {  
	  
    @GET("raw/{branch}/{path}")  
    suspend fun fetch(  
        @Path("branch") branch: String,  
        @Path("path") path: String,  
        @Header("Authorization") token: String,  
        @Header("Content-Type") contentType: String,    
    ): PaintingsResponse  
}
```


### PaintingsRepository.kt
```kotlin
import com.artsam.data.api.PaintingsApi  
import com.artsam.data.entity.Painting  
import kotlinx.coroutines.flow.Flow  
import kotlinx.coroutines.flow.flow  
  
class PaintingsRepository(  
    private val api: Lazy<PaintingsApi>  
) {  
	  
    fun fetch(  
        branch: String = "master",  
        path: String = "paintings-list.json",  
    ): Flow<List<Painting>> = flow {  
        emit(  
            api.value.fetch(branch, path).paintings  
        )  
    }  
}
```


##### PaintingsRepositoryTest.kt
```kotlin
@OptIn(ExperimentalCoroutinesApi::class) // required for 'runTest' method  
class PaintingsRepositoryTest {
	@Test  
	fun `fetching data with real PaintingRepo`() = runTest {  
	    val retrofit = Retrofit.Builder()  
	        .baseUrl("https://github.com/SamoshkinR-Tem/mmdd.pictures/")  
	        .addConverterFactory(GsonConverterFactory.create())  
	        .build()  
	    val api = retrofit.create(PaintingsApi::class.java)  
	    val repo = PaintingsRepository(api = lazy { api })  
		  
	    val expectedData = listOf(  
	        Painting(  
	            "af7c1fe6-d669-414e-b066-e9733f0de7a8",  
	            "2022-11-27T19:39:02.471Z",  
	            "Canvas",  
	            "Oil",  
	            "https://github.com/SamoshkinR-Tem/mmdd.pictures/blob/master/4x4/Ghovardhan.jpg",  
	        ),  
	        Painting(  
	            "08c71152-c552-42e7-b094-f510ff44e9cb",  
	            "2022-11-27T19:39:02.471Z",  
	            "WoodenBoard",  
	            "Acrylic",  
	            "https://github.com/SamoshkinR-Tem/mmdd.pictures/blob/master/4x4/Red.jpg",  
	        )  
	    )  
		  
	    // act  
	    val flow = repo.fetch()  
		  
	    // assert  
	    flow.collect { data ->  
	        assertEquals(expectedData, data)  
	    }  
	}
}
```


# variant from ChatGPT4

```java
public class MyData { 
	private String name; 
	private int age; 
	
	public String getName() { return name; } 
	public int getAge() { return age; } 
}
```

##### GithubApi
```java
public interface GitHubApi { 
	@GET("raw/{branch}/{path}") 
	Call<MyData> getData( 
		@Path("branch") String branch, 
		@Path("path") String path, 
		@Header("Authorization") String token ); 
}
```

##### MainActivity
```java
...
private void parseJsonFile() { 
	String token = "Bearer <your access token>"; 
	
	Retrofit retrofit = new Retrofit.Builder() 
		.baseUrl("https://raw.githubusercontent.com/<user>/<repo>/") 
		.addConverterFactory(GsonConverterFactory.create()) 
		.build();
	GitHubApi api = retrofit.create(GitHubApi.class); 
	
	Call<MyData> call = api.getData("<branch>", "paintings-list.json", token); 
	call.enqueue(new Callback<MyData>() { 
		@Override 
		public void onResponse(
			Call<MyData> call, 
			Response<MyData> response
		) { 
			MyData data = response.body(); 
			Log.d("MyApp", "Name: " + data.getName() + ", Age: " + data.getAge()); } 
		
		@Override 
		public void onFailure(Call<MyData> call, Throwable t) { t.printStackTrace(); 
	} }); 
}
```