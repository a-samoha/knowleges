
#### VIEW_MODEL
```kotlin  
import androidx.lifecycle.ViewModel
class UserViewModel(private val repository: UserRepository) : ViewModel() {  
	  
    fun sayHello(name : String) : String{  
        val foundUser = repository.findUser(name)  
        return foundUser?.let { "Hello '$it' from $this" } ?: "User '$name' not found!"  
    }  
}

import org.koin.androidx.compose.koinViewModel
fun CustomScreen(userName: String, viewModel: CustomViewModel = koinViewModel()){
	Text(text = viewModel.sayHello(userName))
}
```

