
Варианты списков:
- RecyclerView
- ListView
- Spinner

## RecyclerView
### SingleItemTypeListAdapter
### MultipleItemTypesListAdapter [(with Title Separator)](https://stackoverflow.com/a/65593579)

##### fragment_settings.xml
```xml
	...
	<androidx.recyclerview.widget.RecyclerView  
	    android:id="@+id/rv_settings_content"  .
	    ...
	    android:overScrollMode="never"        --  optional
	    android:clipToPadding="false"         --  optional
	    ...
	    app:layoutManager="androidx.recyclerview.widget.LinearLayoutManager"   
	    tools:itemCount="4"  
	    tools:listitem="@layout/item_some" />
```

##### item_title_separator.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<TextView xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/titleSeparator"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"/>
```

#####  item_type.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android"  
    xmlns:app="http://schemas.android.com/apk/res-auto"  
    xmlns:tools="http://schemas.android.com/tools"  
    tools:ignore="ContentDescription">
	
	<data>
		<variable 
			name="item"
			type="com.my.app.ui.f.some.SomeItemUiModel"/>
			
		<import type="com.my.app.ui.f.some.SomeItemUiModel.Selection" />
	</data>
	
	<androidx.constraintlayout.widget.ConstraintLayout  
	    android:layout_width="match_parent"  
	    android:layout_height="wrap_content">
	
    </androidx.constraintlayout.widget.ConstraintLayout>
</layout>
```

##### TwoItemTypesUiModel
```kotlin
data class SomeItemUiModel(
	private val id: Int,
	private val text: String,
)

sealed class TwoItemTypesUiModel(val id: String) {  
    data class TypeOne(val text: String) : TwoItemTypesUiModel("${text.hashCode()}")  
    data class TypeTwo(val some: SomeItemUiModel) : TwoItemTypesUiModel(some.id)  
}
```

##### TwoItemTypesListAdapter
```kotlin
class TwoItemTypesListAdapter(  
    private val onViewCLick: (SomeItemUiModel) -> Unit,  
) : ListAdapter<TwoItemTypesUiModel, TwoItemTypesListAdapter.ViewHolder>(DIFF) {
	
	// описывает тип елемента списка, на который кликнули
	override fun getItemViewType(position: Int): Int =
		return when(getItem(position)){
			is TwoItemTypesUiModel.TypeOne -> VIEW_TYPE_ONE
			is TwoItemTypesUiModel.TypeTwo -> VIEW_TYPE_TWO
		}
	
	// Выдаем холдер согласно типу елемента. 
	// (если cписок из 2/3 типов Item, напр: "Дата" и "Звонки")
	// Если тип один - убираем проверку.
	override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
		val inflater = LayoutInflater.from(parent.context)
			return when (viewType){
				VIEW_TYPE_ONE -> TypeOneViewHolder(ItemTypeOneBinding.inflate(inflater, parent, false))
				else -> TypeTwoViewHolder(ItemTypeTwoBinding.inflate(inflater, parent, false))
			}
		}
	}
	
	override fun onBindViewHolder(holder: ViewHolder, position: Int) {  
		when (holder) {  
		    is TypeOneViewHolder -> holder.bind(getItem(position) as TwoItemTypesUiModel.TypeOne)  
		    is TypeTwoViewHolder -> holder.bind(getItem(position) as TwoItemTypesUiModel.TypeTwo)  
		}

	}
	
	abstract class ViewHolder(view: View): RecyclerView.ViewHolder(view)
	
	inner class TypeOneViewHolder(
		private val binding: ItemTypeOneBinding
	) : ViewHolder(binding.root){
	
		fun bind(item: SomeItemUiModel) { 
			binding.item = item
			binding.tvSome.setOnClickListener{ 
			    onViewCLick.invoke(item)
		    }
		}
	}
	
	inner class TypeTwoViewHolder(
		private val binding: ItemTypeTwoBinding
	) : ViewHolder(binding.root){
	
		TODO("Not yet implemented")
	}
	
	companion object {    
	    const val VIEW_TYPE_ONE  = 0  
	    const val VIEW_TYPE_TWO = 1
	    
	    private val DIFF = object : DiffUtil.ItemCallback<SomeItemUiModel>() {  
	        override fun areItemsTheSame(  
	            oldItem: SomeItemUiModel,  
	            newItem: SomeItemUiModel,  
	        ): Boolean = oldItem == newItem  // Проверяем уникальность объектов
			  
	        override fun areContentsTheSame(  
	            oldItem: SomeItemUiModel,  
	            newItem: SomeItemUiModel,  
	        ): Boolean = oldItem.text == newItem.text  // Проверяем изменения в полях объектов
	    }  
	}
}
```

### Payload
Payload в контексте Kotlin для разработки Android упоминается в связи с  RecyclerView. 
Payload используется для описания изменений, которые должны быть применены к элементу списка.

Когда данные, отображаемые в RecyclerView, изменяются, адаптер может уведомить об этих изменениях с использованием методов `.notifyItemChanged(position)`, `.notifyDataSetChanged()` и других. В этих методах можно передать payload - объект, который содержит информацию о том, что именно изменилось в элементе данных. Это может быть полезно для оптимизации производительности, поскольку позволяет обновлять только те части представления элемента списка, которые действительно изменились, а не перерисовывать весь элемент целиком.

Например, если у вас есть список, в котором отображается имя и фотография пользователя, и изменяется только имя, то с помощью payload можно обновить только текстовое представление с именем, не затрагивая изображение.

В методе адаптера `onBindViewHolder`, который отвечает за связывание данных с представлениями элементов списка, можно проверить, передан ли payload. Если payload передан, можно выполнить только те обновления, которые он описывает. 

