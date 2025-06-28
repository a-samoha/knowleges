
### ViewExt

```kotlin
fun ViewGroup.inflate(@LayoutRes layoutRes: Int, attachToRoot: Boolean = false): View {  
    return LayoutInflater.from(context).inflate(layoutRes, this, attachToRoot)  
}  
  
fun <T : View> T.gone() = apply {  
	this.visibility = View.GONE  
}  
  
fun <T : View> T.invisible() = apply {  
	this.visibility = View.INVISIBLE  
}  
  
fun <T : View> T.visible() = apply {  
	this.visibility = View.VISIBLE  
}  
  
fun View.visibleOrGone(isVisible: Boolean) {  
	visibility = if (isVisible) View.VISIBLE else View.GONE  
}  
  
fun View.visibleOrInvisible(isVisible: Boolean) {  
	visibility = if (isVisible) View.VISIBLE else View.INVISIBLE  
}  
  
fun View.setOnDebouncedClickListener(delayTime: Long = 500, action: (view: View?) -> Unit) {  
	setOnClickListener(  
		object : View.OnClickListener {  
  
			private var isClickEnabled: Boolean = true  
  
			override fun onClick(view: View?) {  
				if (isClickEnabled) {  
					isClickEnabled = false  
					view?.postDelayed({ isClickEnabled = true }, delayTime)  
					action.invoke(view)  
				}  
			}  
		}  
	)  
}  
  
fun NavigationBarView.setDebouncedOnItemSelectedListener(  
	delayTime: Long = 500,  
	action: (MenuItem) -> Boolean  
) {  
	setOnItemSelectedListener(  
	object : NavigationBarView.OnItemSelectedListener {  
	  
		private var isClickEnabled: Boolean = true  
		private var lastActionResult: Boolean = true  
		  
		override fun onNavigationItemSelected(item: MenuItem): Boolean {  
			if (isClickEnabled) {  
				isClickEnabled = false  
				postDelayed({ isClickEnabled = true }, delayTime)  
				lastActionResult = action.invoke(item)  
			}  
			return lastActionResult  
			}  
		}  
	)  
}  
  
/* Keyboard */  
fun View?.hideKeyboard(removeFocusable: Boolean = false) {  
	this?.context?.let {  
		if (removeFocusable) this.isFocusable = false  
		val imm = it.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager  
		imm?.hideSoftInputFromWindow(windowToken, 0)  
	}  
}  
  
fun View.showKeyboard() {  
	requestFocus()  
	if (hasWindowFocus()) {  
		showKeyboardNow()  
	} else {  
		viewTreeObserver.addOnWindowFocusChangeListener(  
		object : ViewTreeObserver.OnWindowFocusChangeListener {  
			override fun onWindowFocusChanged(hasFocus: Boolean) {  
				if (hasFocus) {  
					this@showKeyboard.showKeyboardNow()  
					viewTreeObserver.removeOnWindowFocusChangeListener(this)  
				}  
			}  
		})  
	}  
}  
  
private fun View.showKeyboardNow() {  
	if (isFocused) {  
		post {  
			val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager  
			imm?.showSoftInput(this, InputMethodManager.SHOW_IMPLICIT)  
		}  
	}  
}

fun View.setLoadingState(isLoading: Boolean, vararg ignoredViews: View) {  
	if (!ignoredViews.contains(this)) {  
		isEnabled = !isLoading  
	}  
	when (this) {  
		is ViewGroup -> for (i in 0 until childCount) {  
			getChildAt(i).setLoadingState(isLoading, *ignoredViews)  
		}  
		!is ProgressBar -> alpha = if (isLoading && !ignoredViews.contains(this)) 0.6F else 1F  
	}  
}  
  
@SuppressLint("ClickableViewAccessibility")  
fun View.disableTouch() {  
	setOnTouchListener { _, _ -> true }  
	if (this is ViewGroup) {  
		for (i in 0 until childCount) {  
			getChildAt(i).disableTouch()  
		}  
	}  
}  
  
fun View.setChildEnabled(isEnabled: Boolean) {  
	this.isEnabled = isEnabled  
	if (this is ViewGroup) {  
		for (i in 0 until childCount) {  
			getChildAt(i).setChildEnabled(isEnabled)  
		}  
	}  
}  
  
fun View.toBitmap(): Bitmap {  
	val unspecifiedSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)  
	measure(unspecifiedSpec, unspecifiedSpec)  
	layout(0, 0, measuredWidth, measuredHeight)  
	return Bitmap.createBitmap(measuredWidth, measuredHeight, Bitmap.Config.ARGB_8888).apply {  
		eraseColor(Color.TRANSPARENT)  
		draw(Canvas(this))  
	}  
}  
  
fun View.setTopMargin(valuePx: Int) {  
	(layoutParams as? ViewGroup.MarginLayoutParams)?.topMargin = valuePx  
}  
  
fun View.setBottomMargin(valuePx: Int) {  
	(layoutParams as? ViewGroup.MarginLayoutParams)?.bottomMargin = valuePx  
}  
  
fun View.setStartMargin(valuePx: Int) {  
	(layoutParams as? ViewGroup.MarginLayoutParams)?.marginStart = valuePx  
}  
  
fun View.setEndMargin(valuePx: Int) {  
	(layoutParams as? ViewGroup.MarginLayoutParams)?.marginEnd = valuePx  
}  
  
fun View.bottomMargin(@DimenRes dimensionResId: Int) {  
    (layoutParams as ViewGroup.MarginLayoutParams).bottomMargin = resources.getDimension(dimensionResId).toInt()  
}
	
fun View.margin(  
    @DimenRes left: Int? = null,  
    @DimenRes top: Int? = null,  
    @DimenRes right: Int? = null,  
    @DimenRes bottom: Int? = null,  
) {  
    (layoutParams as? ViewGroup.MarginLayoutParams)?.setMargins(left ?: 0, top ?: 0, right ?: 0, bottom ?: 0)  
}

fun View.showToast(@StringRes messageResId: Int) {  
    Toast.makeText(context, resources.getString(messageResId), Toast.LENGTH_LONG).show()  
}
```

### MetricsExt

```kotlin
/**  
* This method converts dp unit to equivalent pixels, depending on device density.  
*  
* @param dp A value in dp (density independent pixels) unit. Which we need to convert into pixels  
* @param context Context to get resources and device specific display metrics  
* @return A float value to represent px equivalent to dp depending on device density  
*/  
fun dpToPx(context: Context, dp: Float): Float {  
	return dp * context.resources.displayMetrics.density  
}  
  
/**  
* This method converts device specific pixels to density independent pixels.  
*  
* @param px A value in px (pixels) unit. Which we need to convert into db  
* @param context Context to get resources and device specific display metrics  
* @return A float value to represent dp equivalent to px value  
*/  
fun pxToDp(context: Context, px: Float): Float {  
	return px / context.resources.displayMetrics.density  
}

@Deprecated(  
	message = "this method can give wrong result on different screens",  
	replaceWith = ReplaceWith("fun dpToPx(context: Context, dp: Float): Float")  
)  
fun dpToPx(dp: Int, context: Context): Int {  
	val displayMetrics: DisplayMetrics = context.resources.displayMetrics  
	return (dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT)).roundToInt()  
}  
```