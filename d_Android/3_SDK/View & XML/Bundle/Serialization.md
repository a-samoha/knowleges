
home/Android/sdk/platforms/android-34/android.jar/android/os/Bundle

1. B Bundle можно впихнуть лямбду, но этого НЕЛЬЗЯ делать!!!
   -  потому что если откроется звонилка - скрин пересоздастся, НО лямбда не сработает.

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

inline fun <reified T : Serializable> Intent.deserialize(  
    key: String,  
    fallback: T? = null,  
): T? {  
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {  
        getSerializableExtra(key, T::class.java) ?: fallback  
    } else {  
        @Suppress("DEPRECATION") getSerializableExtra(key) as? T ?: fallback  
    }  
}  
```

Serialisable into Bundle
```kotlin
... // anywhere in code
private const val WALLET_POPUP = "walletPopup"
var Bundle.popup: Popup  // not-nullable object, so we HAVE TO throw exception
    get() = deserialize(WALLET_POPUP) ?: throw MissingPropertyException("You should provide walletPopup arg")  
    set(value) = putSerializable(WALLET_POPUP, value)
```
