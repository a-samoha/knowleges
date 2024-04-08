```kotlin
import java.util.regex.Pattern

class EmailValidatorImpl : EmailValidator {  
  
    override fun validate(email: String) = Pattern.compile(EMAIL_REGEX).matcher(email).matches() && isEmailValid(email)  
  
    companion object {  
		const val EMAIL_REGEX = "^(?!.*\\.{2})[a-zA-Z0-9_\\-]+(?:\\.[a-zA-Z0-9_\\-]+)*@[a-zA-Z0-9_\\-]+(?:\\.[a-zA-Z0-9_\\-]+)*\\.[a-zA-Z]{2,}$"
    }  
  
    private fun isEmailValid(email: String) =  
        email.isNotBlank() && domainsSet.contains(email.substringAfterLast("."))  
}
```