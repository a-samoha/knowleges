
home/Android/sdk/platforms/android-34/android.jar/android/os/Bundle

1. B Bundle можно впихнуть лямбду, но этого НЕЛЬЗЯ делать!!!
   -  потому что если откроется звонилка - скрин пересоздастся, НО лямбда не сработает.
##### [getSerializableExtra and getParcelableExtra deprecated](https://stackoverflow.com/questions/72571804/getserializableextra-and-getparcelableextra-deprecated-what-is-the-alternative)

```kotlin
inline fun <reified T : Serializable> Bundle.serializable(key: String): T? = when {
  Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> getSerializable(key, T::class.java)
  else -> @Suppress("DEPRECATION") getSerializable(key) as? T
}

inline fun <reified T : Serializable> Intent.serializable(key: String): T? = when {
  Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> getSerializableExtra(key, T::class.java)
  else -> @Suppress("DEPRECATION") getSerializableExtra(key) as? T
}
```



## В  Kotlin  НЕТ Parcelable (это фишка Android)
### Serializable

String/Int/Boolean into Bundle
```kotlin
private const val ARG_REQUEST_ID = "ARG_REQUEST_ID"  
var Bundle.requestId: String  
    get() = getString(ARG_REQUEST_ID) ?: ""  
    set(value) = putString(ARG_REQUEST_ID, value)
```


BundleExt.kt
```kotlin
package com.b9.app.core.ui_kit.utils  
  
import android.os.Build  
import android.os.Bundle  
import android.os.Parcelable  
import java.io.Serializable  
  
/**  
 * Extensions for work with Bundle
 *
 * @author Yury Polshchikov on 18.04.2023 
 */
   
/**  
 * @return Serializable instance of object from [this] Bundle by [key], 
 * or [fallback] instance, or null 
 */
inline fun <reified T : Serializable> Bundle.deserialize(  
    key: String,  
    fallback: T? = null,  
): T? {  
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {  
        getSerializable(key, T::class.java) ?: fallback  
    } else {  
        @Suppress("DEPRECATION") getSerializable(key) as? T ?: fallback  
    }  
}  
```

Serialisable into Bundle
```kotlin
var Bundle.popup: Popup  // not-nullable object, so we HAVE TO throw exception
    get() = deserialize("walletPopup") ?: throw MissingPropertyException("You should provide walletPopup arg")  
    set(value) = putSerializable("walletPopup", value)
```


### Parcelable
[Parcelize. Или как одна аннотация упрощает работу](https://medium.com/@arzumanianartur0/parcelize-%D0%B8%D0%BB%D0%B8-%D0%BA%D0%B0%D0%BA-%D0%BE%D0%B4%D0%BD%D0%B0-%D0%B0%D0%BD%D0%BD%D0%BE%D1%82%D0%B0%D1%86%D0%B8%D1%8F-%D1%83%D0%BF%D1%80%D0%BE%D1%89%D0%B0%D0%B5%D1%82-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%83-%D1%81-parcelable-%D0%B2-kotlin-440b6fbe3a7e)

MyCLass.kt
```kotlin
import android.os.Parcelable  
import kotlinx.parcelize.Parcelize  
  
@Parcelize  
data class MyCLass(  
    val id: Int,  
    val isFree: Boolean,  
    val description: String,  
) : Parcelable
```

BundleExt.kt
```kotlin 
/**  
 * @return Parcelable instance of object from [this] Bundle by [key], 
 * or [fallback] instance, or null 
 */
inline fun <reified T : Parcelable> Bundle.deparcelize(  
    key: String,  
    fallback: T? = null,  
): T? {  
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {  
        getParcelable(key, T::class.java) ?: fallback  
    } else {  
        @Suppress("DEPRECATION") getParcelable(key) as? T ?: fallback  
    }  
}
```

Parcelable into Bundle
```kotlin
var Bundle.selectedCategoriesInfo: CategoriesInfo? // nullable object, so we DON'T have to throw exception
    get() = deparcelize("selectedCategoriesInfo")  
    set(value) = putParcelable("selectedCategoriesInfo", value)
```

