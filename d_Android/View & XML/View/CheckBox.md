
### 2 спаренных Chb (как RadioButton):
ui_kit_choice_indicator.xml
```kotlin
<?xml version="1.0" encoding="utf-8"?>  
<selector xmlns:android="http://schemas.android.com/apk/res/android">  
	<item android:drawable="@drawable/ic_checked_24dp" android:state_checked="true" />  
	<item android:drawable="@drawable/ui_kit_ic_choice_indicator_unchecked" />  
</selector>
```

my_layout.xml
```kotlin
	...
	<CheckBox  
	android:id="@+id/checkboxChecking"  
	android:layout_width="wrap_content"  
	android:layout_height="24dp"   
	android:button="@drawable/ui_kit_choice_indicator"  // xml с селектором
	android:checked="true"  
	android:focusable="false"  
	android:fontFamily="@font/sf_pro_regular"  
	android:paddingLeft="8dp"  // двигает текст правее от иконки
	android:text="Сhecking"  
	android:textIsSelectable="true"   />  
	  
	<CheckBox  
	android:id="@+id/checkboxSavings"  
	android:layout_width="wrap_content"  
	android:layout_height="24dp"   
	android:button="@drawable/ui_kit_choice_indicator"  
	android:checked="false"  
	android:focusable="false"  
	android:fontFamily="@font/sf_pro_regular"  
	android:paddingLeft="8dp"  
	android:text="Saving"  
	android:textIsSelectable="true"  />
	...
```

MyClass.kt
```kotlin
	...
	private fun setListeners() = with(binding) {  
		checkboxChecking.setOnClickListener {  
			if (checkboxChecking.isChecked) checkboxSavings.isChecked = false  
			else checkboxChecking.isChecked = !checkboxChecking.isChecked  
		}  
		checkboxSavings.setOnClickListener {  
			if (checkboxSavings.isChecked) checkboxChecking.isChecked = false  
			else checkboxSavings.isChecked = !checkboxSavings.isChecked  
		}  
	}
	...
```

