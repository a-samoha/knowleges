[Retrofit.error()](https://www.tabnine.com/code/java/methods/retrofit2.Response/error)
["error_text".toResponseBody()](https://stackoverflow.com/a/66864825)

```kotlin
import io.mockk.coEvery  
import io.mockk.mockk  
import kotlinx.coroutines.test.runTest  
import org.hamcrest.CoreMatchers.equalTo  
import org.hamcrest.MatcherAssert.assertThat  
import org.junit.Test  
import retrofit2.Response

class ZendeskSupportRepositoryTest {  
  
    private val supportApi = mockk<SupportApi>()  
    private val repository = ZendeskSupportRepository(api = supportApi)  
	  
    @Test  
    fun getSupportCategoriesSuccess() = runTest {  
        // Set  
        val expectedModel = listOf(  
            SupportCategory("value0", "tag0", "default0"),  
            SupportCategory("value1", "tag1", "default1"),  
        )  
		  
        // Mock Api  
        coEvery { supportApi.getCategories() } returns Response.success(  
            listOf(  
                CategoryResponse("value0", "tag0", "default0"),  
                CategoryResponse("value1", "tag1", "default1"),  
            )  
        )  
		  
        // Get  
        var actualModel: List<SupportCategory>? = null  
        repository.getSupportCategories().onSuccess { actualModel = it }  
		  
        // Check  
        assertThat(actualModel, equalTo(expectedModel))  
    }  
		  
    @Test(expected = IllegalArgumentException::class)  
    fun getSupportCategoriesError() = runTest {  
        // Set  
        val expectedModel = IllegalArgumentException()  
		  
        // Mock Api  
        coEvery { supportApi.getCategories() } returns Response.error(IllegalArgumentException())  
    }  
}
```