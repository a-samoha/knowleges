
## Simple Kotlin class

```kotlin
import android.graphics.Color
/**  
 * Parser for color strings from BE
 * 
 * @author Denys Kalashnyk on 30.03.2023  
 */
class B9ColorParser {  
    companion object {  
        fun parseColor(colorString: String?, defaultColor: String = DEFAULT_TV_TEXT_COLOR): Int =  
            runCatching {  
                colorString?.let { Color.parseColor(if (it.contains("#")) it else "#$it") }  
                    ?: Color.parseColor(defaultColor)  
            }.getOrElse { Color.parseColor(defaultColor) }  
		
        private const val DEFAULT_TV_TEXT_COLOR = "#14273A"  
    }  
}
```

## Test class

```kotlin
import android.graphics.Color  
import org.hamcrest.CoreMatchers.equalTo  
import org.hamcrest.MatcherAssert.assertThat  
import org.junit.Test  
import org.junit.runner.RunWith  
import org.robolectric.RobolectricTestRunner  
  
/**  
 * Tests for [B9ColorParser]  
 *  
 * @author Denys Kalashnyk on 30.03.2023  
 */
@RunWith(RobolectricTestRunner::class)  
class B9ColorParserTest {  
    private val expectedDefTvTextColor = Color.parseColor("#14273A")  
    private val expectedRed = Color.parseColor("#FF0000")  
    private val expectedBlue = Color.parseColor("#430000ff")  
  
    @Test  
    fun parsingValidValue() {  
        val actual = B9ColorParser.parseColor("14273A")  
        assertThat(actual, equalTo(expectedDefTvTextColor))  
    }  
  
    @Test  
    fun parsingBlackWithSharp() {  
        val actual = B9ColorParser.parseColor("#14273A")  
        assertThat(actual, equalTo(expectedDefTvTextColor))  
    }  
  
    @Test  
    fun parsingRedWithoutSharp() {  
        val actual = B9ColorParser.parseColor("FF0000")  
        assertThat(actual, equalTo(expectedRed))  
    }  
  
    @Test  
    fun parsingWithTransparency() {  
        val actual = B9ColorParser.parseColor("430000ff")  
        assertThat(actual, equalTo(expectedBlue))  
    }  
  
    @Test  
    fun parsingUnValidValue() {  
        val actual = B9ColorParser.parseColor("some_bug")  
        assertThat(actual, equalTo(expectedDefTvTextColor))  
    }  
  
    @Test  
    fun parsingUnValidValueWithSharp() {  
        val actual = B9ColorParser.parseColor("#some_bug")  
        assertThat(actual, equalTo(expectedDefTvTextColor))  
    }  
}
```

https://stackoverflow.com/questions/31177363/testing-color-class-in-android-not-working-as-expected
https://developer.android.com/training/testing/local-tests
https://developer.android.com/jetpack/androidx/releases/test
https://robolectric.org/getting-started/