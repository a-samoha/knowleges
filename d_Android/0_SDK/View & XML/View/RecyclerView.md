
Варианты списков:
- RecyclerView
- ListView
- Spinner

## RecyclerView
### SingleItemTypeListAdapter

Это древний вариант
- Он работает, НО перерисовывает все елементы при каждом изменении списка данных ("values")
```kotlin
import android.view.LayoutInflater  
import android.view.View  
import android.view.ViewGroup  
import android.widget.TextView  
import androidx.recyclerview.widget.RecyclerView  
import com.b9.app.core.ui_kit.utils.gone  
import com.b9.app.feature.loan.impl.presentation.adapter.DetailsValuesAdapter.DetailsValuesViewHolder  
import com.b9.app.features.loan.impl.R  
  
class DetailsValuesAdapter(  
    private val values: List<Pair<String, String>>,  
) : RecyclerView.Adapter<DetailsValuesViewHolder>() {  
  
    class DetailsValuesViewHolder(view: View) : RecyclerView.ViewHolder(view) {  
        val title: TextView = view.findViewById(R.id.title)  
        val value: TextView = view.findViewById(R.id.value)  
        val divider: View = view.findViewById(R.id.divider)  
    }  
  
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = DetailsValuesViewHolder(  
        LayoutInflater.from(parent.context).inflate(  
            R.layout.loan_details_values_item, parent, false  
        )  
    )  
  
    override fun onBindViewHolder(holder: DetailsValuesViewHolder, position: Int) {  
        println("test onBindViewHolder $holder")  
        holder.title.text = values[position].first  
        holder.value.text = values[position].second  
        if (position == itemCount - 1) holder.divider.gone()  
    }  
  
    override fun getItemCount() = values.size  
}
```

Это более современный вариант с DiffUtil
- Не перерисовывает елементы которые при обновлении даных НЕ изменились.
```kotlin

class DetailsValuesAdapter :  
    ListAdapter<Pair<String, String>, DetailsValuesViewHolder>(DetailsValuesDiffCallback()) {  
  
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DetailsValuesViewHolder {  
        val binding =  
            LoanDetailsValuesItemBinding.inflate(LayoutInflater.from(parent.context), parent, false)  
        return DetailsValuesViewHolder(binding = binding)  
    }  
  
    override fun onBindViewHolder(holder: DetailsValuesViewHolder, position: Int) {  
        holder.bind(getItem(position), position == itemCount - 1)  
    }  
  
    class DetailsValuesViewHolder(  
        private val binding: LoanDetailsValuesItemBinding,  
    ) : RecyclerView.ViewHolder(binding.root) {  
  
        fun bind(item: Pair<String, String>, hideDivider: Boolean) = with(binding) {  
            val context = itemView.context // тут можно легко получить контекст
		    
			title.text = item.first  
            value.text = item.second  
            if (hideDivider) divider.gone()  
        }  
    }  
  
    class DetailsValuesDiffCallback : DiffUtil.ItemCallback<Pair<String, String>>() {  
  
        override fun areItemsTheSame(  
            oldItem: Pair<String, String>,  
            newItem: Pair<String, String>  
        ): Boolean {  
            return oldItem.first == newItem.first  
        }  
  
        override fun areContentsTheSame(  
            oldItem: Pair<String, String>,  
            newItem: Pair<String, String>  
        ): Boolean {  
            return oldItem == newItem  
        }  
    }  
}
```

##### LoanDetailsScreen.kt
```kotlin
class LoanDetailsScreen : BaseFragment<LoanDetailsFragmentBinding>() {  
  
    private val viewModel by viewModel<LoanDetailsViewModel> { parametersOf(arguments) }  
  
    private val valuesAdapter = DetailsValuesAdapter()
	
	override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
	    super.onViewCreated(view, savedInstanceState)
	    
	    val layoutManagerDetails = object : LinearLayoutManager(requireContext()) {
	        override fun canScrollVertically() = false  
		}  
		
		binding.rvDetailsValues.layoutManager = layoutManagerDetails    
		binding.rvDetailsValues.adapter = valuesAdapter
		
		viewModel.state  
		    .onEach{ state -> valuesAdapter.submitList(state.values) }  
		    .launchIn(lifecycleScope)
	}
```

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

