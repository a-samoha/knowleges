
### Без либы NavHostFragment
activity_main.xml
```xml
<androidx.fragment.app.FragmentContainerView  
	android:id="@+id/fragmentContainer"  
	android:layout_width="match_parent"  
	android:layout_height="match_parent" />
```

MainActivity.kt
```kotlin
	override fun onCreate(savedInstanceState: Bundle?) {  
		super.onCreate(savedInstanceState)  
		setContentView(R.layout.activity_main)  
		
		showExampleFragment()
	}
	
	private fun showExampleFragment() {  
		supportFragmentManager.commit {  
			val arguments = Bundle()  
			arguments.putString("key", "From Activity")  
			
			add<ExampleFragment>(R.id.fragmentContainer, args = arguments) // показывает фр. поверх (НЕ скрывая предыдущий)
																		   // пред. ничего не делает (остается "onResumed()")
			// replace(R.id.fragmentContainer, ExampleFragment()) // показывает фр. вместо предыдущего
																  // у пред. вызывается "onDestroyView()",
																  // БЕЗ "onDestroy()" (висит в памяти)
			// remove(this@ExampleFragment)  // удаляет фр. ("onDestroy()") НЕ очищая backStack!!!
			
			setCustomAnimations(  
				R.anim.enter_animation,  
				R.anim.exit_animation,  
				R.anim.pop_enter_animation,  
				R.anim.pop_exit_animation  
			)
			
			setReorderingAllowed(true)  // must be set to true in the same transaction as addToBackStack() 
										// to allow the pop of that transaction to be reordered.
			addToBackStack("ExampleFragment")  // обеспечивает удаление ("onDestroy()") фр. по системной кнопке "Back"
		}  
	}
```

```kotlin
val fragmentById = supportFragmentManager.findFragmentById(R.id.fragment_container_view)
val fragmentByTag = supportFragmentManager.findFragmentByTag("exampleTag")

// начинает новую транзакцию для изменения фрагментов.
val transaction = supportFragmentManager.beginTransaction()  
transaction.replace(R.id.fragmentContainerView1, ExampleFragment())  
transaction.setCustomAnimations(  
				R.anim.enter_animation,  
				R.anim.exit_animation,  
				R.anim.pop_enter_animation,  
				R.anim.pop_exit_animation  
			)
transaction.setReorderingAllowed(true)  
transaction.addToBackStack(ExampleFragment::class.java.name)  
transaction.commit() // применяет изменения.

// немедленно выполнит все ожидающие транзакции.
supportFragmentManager.executePendingTransactions()

// откат последней транзакции в стеке возврата.
supportFragmentManager.popBackStack()
supportFragmentManager.popBackStackImmediate()

// количество транзакций в стеке возврата.
val count = supportFragmentManager.backStackEntryCount

// список фр. отображаемых единовременно (add)
val fragmentList = supportFragmentManager.fragments
```



### C либой NavHostFragment
activity_main.xml
```xml
<androidx.fragment.app.FragmentContainerView  
	android:id="@+id/nav_host_fragment_activity_main"  
	android:name="androidx.navigation.fragment.NavHostFragment"  // подключает библиотеку навигации в Android
	android:layout_width="match_parent"  
	android:layout_height="match_parent"  
	app:defaultNavHost="true"  // указывает, что "NavHostFragment" основной (обрабатывает системные нав. события, напр. "назад")
	app:navGraph="@navigation/mobile_navigation" />  // ресурс нав. графа, отображает структуру навигации в приложении
```
