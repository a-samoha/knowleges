```kotlin
fun main() {
	println(CustomEnam.CUSTOM1.name) // CUSTOM1
    println(StringEnam.CUSTOM2.someValue) // World!
}
```

```kotlin
enum class CustomEnam{
	CUSTOM1, CUSTOM2
}
```

```kotlin
enum class StringEnam(val someValue: String){
	CUSTOM1("Hi"), CUSTOM2("World!")
}

... 

val stringEnam = StringEnam.values().find { it.value == "Hi" }
```

```kotlin
enum class AccountType : Serializable {  
	Unknown,  
	Main,  
	Reward;  
	  
	companion object {  
		fun fromString(rawType: String?): AccountType {  
			for (type in AccountType.values()) {  
				if (rawType.equals(type.name, ignoreCase = true)) {  
					return type  
				}  
			}  
			return Unknown  
		}  
	}  
}
```