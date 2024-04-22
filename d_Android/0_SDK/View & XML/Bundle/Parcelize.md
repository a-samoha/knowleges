
## В  Kotlin  НЕТ Parcelable (это фишка Android)
### Parcelable

БЕЗ аннотации @Parcelize (нативно, не подключая плагин)

MyCLass.kt
```kotlin
data class MyClass(
    val id: Int,
    val isFree: Boolean,
    val description: String
) : Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.readInt(),
        parcel.readByte() != 0.toByte(),
        parcel.readString() ?: ""
    )

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeInt(id)
        parcel.writeByte(if (isFree) 1 else 0)
        parcel.writeString(description)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<MyClass> {
        override fun createFromParcel(parcel: Parcel): MyClass {
            return MyClass(parcel)
        }

        override fun newArray(size: Int): Array<MyClass?> {
            return arrayOfNulls(size)
        }
    }
}
```

ИСПОЛЬЗУЯ аннотацию
[Parcelize. Или как одна аннотация упрощает работу](https://medium.com/@arzumanianartur0/parcelize-%D0%B8%D0%BB%D0%B8-%D0%BA%D0%B0%D0%BA-%D0%BE%D0%B4%D0%BD%D0%B0-%D0%B0%D0%BD%D0%BD%D0%BE%D1%82%D0%B0%D1%86%D0%B8%D1%8F-%D1%83%D0%BF%D1%80%D0%BE%D1%89%D0%B0%D0%B5%D1%82-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%83-%D1%81-parcelable-%D0%B2-kotlin-440b6fbe3a7e)

```kotlin
plagin{
	id("kotlin-android")
	id("kotlin-parcelize") // Добавьте эту строку
}
```

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

private const val MY_CLASS = "MY_CLASS"
var Bundle.myClass: MyCLass? // nullable object, so we DON'T have to throw exception
    get() = deparcelize(MY_CLASS)  
    set(value) = putParcelable(MY_CLASS, value)

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
