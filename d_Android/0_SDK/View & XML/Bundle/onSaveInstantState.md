
B Bundle можно впихнуть лямбду, но этого НЕЛЬЗЯ делать!!!
   -  потому что если откроется звонилка - скрин пересоздастся, НО лямбда не сработает, 
   -  потому что ссылки в лямбде будут ссылаться на объекты из старого Activity - это утечка памяти.

Save/read List to Bundle
MainActivity.kt
```kotlin
class MainActivity : AppCompatActivity() {
	
	private val items = mutableListOf<ItemModel>()
	
	override fun onSaveInstanceState(outState: Bundle) {  
	    super.onSaveInstanceState(outState)
		val itemsArray = items.toTypedArray()
		outState.putParcelableArray(ITEMS, itemsArray)
		// or use BundleExt from [[Parcelize]]
		// outState.items = itemsArray
	}
	
	override fun onCreate(savedInstanceState: Bundle?) {
	    super.onCreate(savedInstanceState)
	    setContentView(R.layout.activity_main)
	
	    // Восстановление состояния, если Bundle не пуст
	    savedInstanceState?.let {
	        val itemsArray = 
		        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {  
				    it.getParcelableArray("items", ItemModel::class.java)  
				} else {  
				    @Suppress("DEPRECATION") it.getParcelableArray("items") as Array<ItemModel>  
				} ?: emptyArray<ItemModel>()
				
			// or use BundleExt from [[Parcelize]]
			// itemsArray = it.items
			
	        items.clear()
	        items.addAll(itemsArray as Array<ItemModel>)
	        renderContent(items)
	    }
	}
}
```
