

fragment.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout ...>
  
	<com.google.android.material.textfield.TextInputLayout  
	    style="@style/BNine.InputLayout"  
	    ...
		app:errorTextAppearance="@android:color/holo_red_light"  
		app:hintTextAppearance="@android:color/darker_gray"  
		app:boxStrokeColor="@android:color/holo_green_dark"
		app:startIconDrawable="@drawable/my_icon.webp"
		app:startIconTint="@null" // отменяет автопокрас иконки в цвет текста
		app:endIconMode="password_toggle"  
	    ... >  
	  
	    <com.google.android.material.textfield.TextInputEditText        
		    android:id="@+id/identity_input_text"  
	        ...  
	        android:digits="abcdefg 0123456789-"  // ограничивает разрешенные символы указанными в строке
	        android:singleLine="true"
	        // android:inputType="number" -  откроет клавиатуру с кнопками
	        android:inputType="text"
	        android:imeOptions="actionDone" // нажатие на кнопку "enter" - сворачивает клаву (вместо новой строки)
			/>  
	</com.google.android.material.textfield.TextInputLayout>

</androidx.constraintlayout.widget.ConstraintLayout>
```

style.xml
```xml
<!-- TextInputLayout Theme -->  
<style name="BNine.InputLayout" parent="Widget.Design.TextInputLayout">  
    <item name="errorTextAppearance">@style/ErrorTextAppearance</item>  
    <item name="hintTextAppearance">@style/HintTextAppearance</item>  
    <item name="android:lineSpacingExtra">8dp</item>  
    <item name="android:textColorHint">@color/secondaryTextColor</item>  
    <item name="android:textSize">16sp</item>  
    <item name="strokeColor">@color/primaryColor</item>  
</style>
```

Screen.kt
```kotlin
	...
	// ПРОГрАМНО сетим иконку в конце поля для ввода
	identityInputLayout.endIconMode = TextInputLayout.END_ICON_PASSWORD_TOGGLE  
	identityInputLayout.hint = getString(R.string.some_hint_text)
	
	identityInputLayout.bindErrorText(
		this@InputIdentityScreen,  
	    error.filter { it.identityError != null }.map { it.identityError!! }
	)  
	
	identityInputLayout.setEndIconOnClickListener {  
	    val isPasswordHidden = identityInputText.transformationMethod is PasswordTransformationLastVisible  
	    if (isPasswordHidden) identityInputText.transformationMethod = null  
	    else identityInputText.transformationMethod = PasswordTransformationLastVisible()  
	}  
	  
	identityInputText.transformationMethod = PasswordTransformationLastVisible() // text will be transformed into asterisks  
	identityInputText.textChangesWithMask(IDENTITY_MASK) {}
	
	companion object {  
	    const val IDENTITY_MASK = "[000]-[00]-[0000]"  
	}
	
	// TextInputEditText умеет выдавать Observable
	// и емитить в него каждое изменение введенного текста
	val onIdentityUpdated: Observable<String> = identityInputText.textChanges().map { it.toString() }
```

### Обучаем эмитить во flow
```kotlin
/**  
* TextView changes Coroutines Flow binding  
*  
* @author Yury Polshchikov on 24.11.2023  
*/  
fun Flow<CharSequence>.trimText(): Flow<String> = map { it.toString().trim() }  

fun TextView.textChanges(isSkipFirst: Boolean = false): Flow<String> = textChangesFlow()  
	.apply {  
		return if (isSkipFirst) {  
			drop(1)  
		} else {  
			this  
		}  
	}  
  
private fun TextView.textChangesFlow(): Flow<String> = callbackFlow {  
	val listener = object : TextWatcher {  
		override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) = Unit  
		  
		override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {  
		trySend(s.toString())  
		}  
		  
		override fun afterTextChanged(s: Editable) = Unit  
	}  
	  
	addTextChangedListener(listener)  
	text = text  
	awaitClose { removeTextChangedListener(listener) }  
}.conflate()
```

### Класс описывает сокрытие введенных символов звездочками:
```kotlin
public class PasswordTransformationLastVisible extends PasswordTransformationMethod {  
    boolean lastActionWasDelete = false;  
	  
    @Override  
    public CharSequence getTransformation(CharSequence source, View view) {  
        return new PasswordCharSequence(source);  
    }  
	  
    @Override  
    public void onTextChanged(CharSequence s, int start, int before, int count) {  
        super.onTextChanged(s, start, before, count);  
        this.lastActionWasDelete = before > count;  
    }  
	
    private class PasswordCharSequence implements CharSequence {  
        private final CharSequence source;  
		  
        PasswordCharSequence(CharSequence source) {  
            this.source = source;  
        }  
		  
        public char charAt(int index) {  
            //This is the check which makes sure the last character is shown  
            if (!lastActionWasDelete && index == source.length() - 1) return source.charAt(index);  
            if (source.charAt(index) == '-') return source.charAt(index);  
            if (index > 6) return source.charAt(index);  
            return '•';  
        }  
		  
        public int length() {  
            return source.length(); // Return default  
        }  
		  
        @NonNull  
        public CharSequence subSequence(int start, int end) {  
            return source.subSequence(start, end); // Return default  
        }  
    }  
}
```

### Extention функции для EditText
```kotlin
package com.b9.app.core.ui_kit.ext  

  ...
import com.b9.app.core.ui_kit.binding.textChanges  
import com.redmadrobot.inputmask.MaskedTextChangedListener  
import io.reactivex.rxjava3.core.Observable  
  
fun EditText.textChangesWithMask(mask: String, initText: String = ""): Observable<String> {  
    val maskedListener = MaskedTextChangedListener(mask, this)  
        .also {  
            addTextChangedListener(it)  
            onFocusChangeListener = it  
        }    return maskedListener.textChanges(initText)  
}  
  
fun EditText.configurePhoneInput(phoneMask: String): MaskedTextChangedListener {  
    return with(MaskedTextChangedListener(phoneMask, this)) {  
        this@configurePhoneInput.addTextChangedListener(this)  
        this@configurePhoneInput.onFocusChangeListener = this  
        this    }  
}  
  
fun EditText.setColor(@ColorRes resColor: Int) {  
    this.setTextColor(ContextCompat.getColor(context, resColor))  
}  
  
fun EditText.textChangesWithMask(mask: String, textCallback: (String) -> Unit) {  
    val maskedListener = MaskedTextChangedListener(  
        format = mask,  
        field = this,  
        valueListener = object : MaskedTextChangedListener.ValueListener {  
            override fun onTextChanged(  
                maskFilled: Boolean,  
                extractedValue: String,  
                formattedValue: String  
            ) {  
                textCallback(extractedValue)  
            }  
        })  
  
    addTextChangedListener(maskedListener)  
    onFocusChangeListener = maskedListener  
}  
  
fun EditText.setWatcher(action: (text: String) -> Unit) {  
	  
    this.addTextChangedListener(object : TextWatcher {  
        override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) { action(p0.toString()) }  
        override fun afterTextChanged(p0: Editable?) = Unit  
        override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) = Unit  
    })  
}
```


### Extention функции для TextInputLayout 
```kotlin
package com.b9.app.core.mvvm.rx.binding  

fun TextInputLayout.bindError(  
    msg: String,  
    hideOnChange: Boolean = true,  
) {  
    this.error = msg  
    if (hideOnChange) hideErrorOnTextChanged()  
}
  
fun TextInputLayout.hideErrorOnTextChanged(disableError: Boolean = false) {  
    editText?.addTextChangedListener(object : TextWatcher {  
		  
        override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) = Unit  
		  
		override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {  
            error = null  
            if (disableError) isErrorEnabled = false  
        }  
		  
        override fun afterTextChanged(p0: Editable?) = Unit  
    })  
}
```