
# Spannable
```kotlin
/**  
 * TextView extension function 
 * which converts a part of the text into 
 * underlined clickable link 
 * 
 * @param text the text of the TextView to be set  
 * @param start number of the first char of the link text  
 * @param end number of the last char of the link text  
 * @param colorRes res id of the color to be applied to the link text  
 * @param onClicked action to be invoked on the link click  
 * 
 * @author Denys Kalashnyk on 06.04.2023  
 */
 fun TextView.setUnderlineClickableSpannable(  
    text: String,  
    start: Int,  
    end: Int,  
    colorRes: Int,  
    onClicked: () -> Unit  
) {  
    val ss = SpannableString(text)  
    val clickableSpan: ClickableSpan = object : ClickableSpan() {  
        override fun onClick(textView: View) {  
            onClicked.invoke()  
        }  
		  
        override fun updateDrawState(ds: TextPaint) {  
            super.updateDrawState(ds)  
            ds.isUnderlineText = true  
            ds.color = ContextCompat.getColor(context, colorRes)  
        }  
    }  
    ss.setSpan(clickableSpan, start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)  
    this.text = ss  
    this.movementMethod = LinkMovementMethod.getInstance()  
    this.highlightColor = ContextCompat.getColor(context, colorRes)  
}
```
<br/>

```kotlin

/**  
 * Domain model for FormattedText * * @author Yury Polshchikov on 03.05.2023  
 */data class FormattedTextModel(  
    val text: String,  
    val formats: List<Format>,  
) : Serializable {  
	  
    /**  
     * Domain model for FormattedTextFragmentViewModel     */    data class Format(  
        val placeholder: String,  
        val text: String,  
        val emphasis: Emphasis,  
        val color: Color,  
        val fontSizeMultiplier: Double,  
    ) : Serializable {  
	  
        enum class Emphasis : Serializable {  
            Default,  
            SemiBold,  
            Bold,  
            Black,  
            Italic,  
            BoldItalic,  
            Underlined,  
            StrikeThrough;  
			  
            companion object {  
                fun fromString(rawEmphasis: String?): Emphasis {  
                    for (emphasis in values()) {  
                        if (rawEmphasis.equals(emphasis.name, ignoreCase = true)) {  
                            return emphasis  
                        }  
                    }  
                    return Default  
                }  
            }  
        }  
		  
        enum class Color : Serializable {  
            Default,  
            BrandPrimary,  
            BrandAlternative;  
			  
            companion object {  
                fun fromString(rawColor: String?): Color {  
                    for (color in Color.values()) {  
                        if (rawColor.equals(color.name, ignoreCase = true)) {  
                            return color  
                        }  
                    }  
                    return Default  
                }  
            }  
        }  
		  
        companion object {  
            const val DEFAULT_FONT_SIZE_MULTIPLIER = 1.0  
        }  
    }  
}

/**  
 * Prepare SpannableString by [FormattedTextModel] and set it to [this] TextView 
 * 
 * @param textModel model with text for formatting and formatting settings  
 */
 fun TextView.setFormattedSpannableString(textModel: FormattedTextModel) {  
    try {  
        var spannableText = SpannableString(textModel.text)  
        val textSpanActions = mutableListOf<(() -> Unit)>()  
        textModel.formats.forEach { format ->  
            if (spannableText.contains(format.placeholder)) {  
                val regex = Regex.escape(format.placeholder).toRegex()  
                val text = Regex.escapeReplacement(format.text)  
                spannableText = SpannableString(  
                    spannableText.replaceFirst(  
                        regex = regex,  
                        replacement = text  
                    )  
                )  
				  
                // emphasis  
                when (format.emphasis) {  
                    Format.Emphasis.SemiBold -> {  
                        textSpanActions.add {  
                            spannableText.setTypeface(context, R.font.sf_pro_semibold, format.text)  
                        }  
                    }  
                    Format.Emphasis.Bold -> {  
                        textSpanActions.add {  
                            spannableText.setTypeface(context, R.font.sf_pro_bold, format.text)  
                        }  
                    }  
                    Format.Emphasis.Black -> {  
                        textSpanActions.add {  
                            spannableText.setTypeface(context, R.font.sf_pro_black, format.text)  
                        }  
                    }  
                    Format.Emphasis.Italic -> textSpanActions.add {  
                        spannableText.setStyle(  
                            Typeface.ITALIC,  
                            format.text  
                        )  
                    }  
                    Format.Emphasis.BoldItalic -> {  
                        textSpanActions.add {  
                            spannableText.setTypeface(context, R.font.sf_pro_bold, format.text, Typeface.ITALIC)  
                        }  
                    }  
                    Format.Emphasis.Underlined -> textSpanActions.add { spannableText.setUnderline(format.text) }  
                    Format.Emphasis.StrikeThrough -> textSpanActions.add {  
                        spannableText.setStrikethrough(  
                            format.text  
                        )  
                    }  
                    Format.Emphasis.Default -> Unit  
                }  
				  
                // color  
                val color = when (format.color) {  
                    Format.Color.BrandPrimary -> R.color.primaryColor  
                    Format.Color.BrandAlternative -> R.color.textColorSplash  
                    Format.Color.Default -> null  
                }  
                color?.let {  
                    textSpanActions.add { spannableText.setColor(context, color, format.text) }  
                }  
                // size  
                if (format.fontSizeMultiplier != Format.DEFAULT_FONT_SIZE_MULTIPLIER) {  
                    textSpanActions.add { spannableText.setSize(textSize, format.fontSizeMultiplier, format.text) }  
                }  
            }  
        }  
        textSpanActions.forEach { it.invoke() }  
		  
        text = spannableText  
    } catch (e: Exception) {  
        Timber.e(e)  
        FirebaseCrashlytics.getInstance().recordException(e)  
        text = textModel.text  
    }  
}
```
<br/>

```kotlin
...
val htmlText = tooltipDialog.subtitle.text // we use it below

val spannableSubtitle = SpannableString(  
    Html.fromHtml(htmlText.replace("\n", "<br>"), Html.FROM_HTML_MODE_COMPACT)  
).apply {  
    try {  
        setClickable(  // see the fun below
            context = requireContext(),  
            action = {  
                viewModel.onUrl1Click()  
                dismiss()  
            },  
            clickableString = tooltipDialog.subtitle.urls[0].text,  
            isUnderlineSpan = true  
        )  
    } catch (_: Exception) {  
    }  
}  
  
tooltipSubtitle.text = spannableSubtitle  
tooltipSubtitle.movementMethod = LinkMovementMethod.getInstance() 
...
```
<br/>

# SpannableStringExt.kt
```kotlin
fun SpannableString.setTextColor(  
    context: Context,  
    @ColorRes colorRes: Int,  
    start: Int,  
    end: Int  
) = apply {  
    setSpan(  
        ForegroundColorSpan(ContextCompat.getColor(context, colorRes)),  
        start,  
        end,  
        Spanned.SPAN_EXCLUSIVE_EXCLUSIVE  
    )  
}  
  
fun SpannableString.setTextAppearance(  
    context: Context,  
    @StyleRes textAppearanceId: Int,  
    colorString: String = this.toString()  
) {  
    val firstIndex = this.indexOf(colorString)  
    this.setSpan(  
        TextAppearanceSpan(context, textAppearanceId),  
        firstIndex,  
        firstIndex + colorString.length,  
        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE  
    )  
}  
  
fun SpannableString.drawableEnd(  
    context: Context,  
    @DrawableRes drawableRes: Int,  
) {  
    val d = AppCompatResources.getDrawable(context, drawableRes)!!  
    d.setBounds(0, 0, d.intrinsicWidth, d.intrinsicHeight)  
    val imgSpan = ImageSpan(d, ImageSpan.ALIGN_BASELINE)  
    setSpan(  
        imgSpan,  
        this.length - 1,  
        this.length,  
        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE,  
    )  
}  
  
/**  
 * This method returns the spannable string 
 * To make it work You should set 
 * the textView.movementMethod = LinkMovementMethod.getInstance() 
 */
 fun SpannableString.setClickable(  
    context: Context,  
    action: () -> Unit,  
    clickableString: String = this.toString(),  
    isUnderlineSpan: Boolean = false,  
) {  
    val firstIndex = this.lastIndexOf(clickableString)  
    setSpan(  
        spanClicked(context, isUnderlineSpan) { action() },  // see the fun below
        firstIndex,  
        firstIndex + clickableString.length,  
        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE  
    )  
}
e.g.:
binding.textTermsOfService.apply {  
    movementMethod = LinkMovementMethod.getInstance()  
    text = SpannableString(getString(R.string.auth_password_terms_of_service)).apply {  
        setClickable(  
            context = requireContext(),  
            action = { viewModel.navigateToTermsOfService() },  
            clickableString = getString(R.string.auth_password_terms_of_service_clickable_part)  
        )  
    }  
}
 
private fun spanClicked(
	 context: Context,
	 isUnderlineSpan: Boolean = false, 
	 action: () -> Unit
): ClickableSpan {  
    return object : ClickableSpan() {  
		  
        override fun onClick(p0: View) {  
            action()  
        }  
		
        override fun updateDrawState(ds: TextPaint) {  
            super.updateDrawState(ds)  
            ds.color = ContextCompat.getColor(context, R.color.primaryColor)  
            ds.isUnderlineText = isUnderlineSpan  
        }  
    }  
}
 
val String.bitmap: Bitmap  
    get() = run {  
        val imageBytes = Base64.decode(this, 0)  
        BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)  
    }
```
<br/>

# Drawable on Start/End of TextView
```kotlin
itemSimulateMonthlySpends.tvTitle.text = "some text"  
itemSimulateMonthlySpends.tvTitle.setCompoundDrawablesWithIntrinsicBounds(  
    0, 0, R.drawable.ui_kit_ic_question_mark_gray, 0  
)  
itemSimulateMonthlySpends.tvTitle.compoundDrawablePadding = 10
```

### [From StackOverFlow](https://stackoverflow.com/questions/6931900/programmatically-set-left-drawable-in-a-textview)
You can create an extension function or just use `setCompoundDrawablesWithIntrinsicBounds` directly.
```less
fun TextView.leftDrawable(@DrawableRes id: Int = 0) {
   this.setCompoundDrawablesWithIntrinsicBounds(id, 0, 0, 0)
}
```
If you need to resize the drawable, you can use this extension function.
```kotlin
textView.leftDrawable(R.drawable.my_icon, R.dimen.icon_size)

fun TextView.leftDrawable(@DrawableRes id: Int = 0, @DimenRes sizeRes: Int) {
    val drawable = ContextCompat.getDrawable(context, id)
    val size = resources.getDimensionPixelSize(sizeRes)
    drawable?.setBounds(0, 0, size, size)
    this.setCompoundDrawables(drawable, null, null, null)
}
```
To get really fancy, create a wrapper that allows size and/or color modification.
```kotlin
textView.leftDrawable(R.drawable.my_icon, colorRes = R.color.white)

fun TextView.leftDrawable(@DrawableRes id: Int = 0, @DimenRes sizeRes: Int = 0, @ColorInt color: Int = 0, @ColorRes colorRes: Int = 0) {
    val drawable = drawable(id)
    if (sizeRes != 0) {
        val size = resources.getDimensionPixelSize(sizeRes)
        drawable?.setBounds(0, 0, size, size)
    }
    if (color != 0) {
        drawable?.setColorFilter(color, PorterDuff.Mode.SRC_ATOP)
    } else if (colorRes != 0) {
        val colorInt = ContextCompat.getColor(context, colorRes)
        drawable?.setColorFilter(colorInt, PorterDuff.Mode.SRC_ATOP)
    }
    this.setCompoundDrawables(drawable, null, null, null)
}
```

