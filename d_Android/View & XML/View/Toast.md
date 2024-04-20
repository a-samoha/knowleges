
FragmentExt.kt
```kotlin

fun Fragment.showToast(message: CharSequence) {  
    Toast.makeText(requireContext(), message, Toast.LENGTH_LONG).show()  
}  
  
fun Fragment.showCenteredToast(rawMessage: CharSequence) {  
    val message = SpannableString(rawMessage).apply {  
        setSpan(  
            AlignmentSpan.Standard(Layout.Alignment.ALIGN_CENTER), 0, rawMessage.length - 1,  
            Spannable.SPAN_INCLUSIVE_INCLUSIVE  
        )  
    }  
    showToast(message)  
}  
  
fun Fragment.showToast(@StringRes messageResId: Int) {  
    showToast(resources.getString(messageResId))  
}

```