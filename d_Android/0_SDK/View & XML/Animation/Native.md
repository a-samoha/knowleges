#animation

#B3FFFFFF - B3 означает 30% цвета (70% прозрачности)

### Set **XY position** animation of top_left corner
```kotlin
view.apply{
	x = 10f
	y = 20f
	animate()  
		.x(0f)  
		.y(0f)  
		.setDuration(500)  
		.start()
}
```
### Set **onTouchListener** - will move the view with Your finger
```kotlin
...
var rightDX = 0f
var rightDY = 0f
view.setOnTouchListener(View.OnTouchListener { view, event ->  
    when (event?.action) {  
        MotionEvent.ACTION_DOWN -> {  
        
            rightDX = view!!.x - event.rawX  
            rightDY = view!!.getY() - event.rawY;  
            
        }  
        MotionEvent.ACTION_MOVE -> {  
        
            var displacement = event.rawX + rightDX 
            
			//if ((newX <= 0 || newX >= screenWidth - view.width) || (newY <= 0 || newY >= screenHeight - view.height)) {  
			//    return true  
			//}
			
            view!!.animate()  
                .x(displacement)  
                .y(event.getRawY() + rightDY)  
                .setDuration(0)  
                .start()  
        }  
        else -> { // Note the block  
            return@OnTouchListener false  
        }  
    }  
    true  
})
```
### Set view.alpha **VALUE animation** with ValueAnimator
```kotlin
... onViewCreated( ... ) {
	 val animator = ValueAnimator().apply {
		duration = 550L
		interpolator = AccelerateDecelerateInterpolator()
		setValues( PropertyValuesHolder.ofFloat("alpha_holder", 0f, 1f) )
		addUpdateListener {  binding.bottomNav.alpha = it.getAnimatedValue("alpha_holder") as Float    }
	 }
	
	 Handler(Looper.getMainLooper()).postDelayed({ animator.start() }, 200L)
 
... // or
	ValueAnimator().apply {  
	    duration = 1470L  
	    interpolator = AccelerateDecelerateInterpolator()  
	    setValues(PropertyValuesHolder.ofFloat("alpha_holder", 0f, 1f))  
	    addUpdateListener { binding.topAppBar.alpha = it.getAnimatedValue("alpha_holder") as Float }  
	    delay(280L) { start() }  
	}
}
```

### AppBar animation
```xml
<com.google.android.material.appbar.AppBarLayout  
    android:layout_width="match_parent"  
    android:layout_height="wrap_content"  
    android:animateLayoutChanges="true" // may become useful, but it also works without
    app:layout_constraintTop_toTopOf="parent">  
    
  
    <com.google.android.material.appbar.MaterialToolbar
        android:layout_width="match_parent"  
        android:layout_height="?actionBarSize" />  
  
</com.google.android.material.appbar.AppBarLayout>
```
### [Reveal or hide a view using animation](https://developer.android.com/training/animation/reveal-or-hide-view)


