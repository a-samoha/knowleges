#animation

#B3FFFFFF - B3 означает 30% цвета (70% прозрачности)

[Compose animation](https://developer.android.com/develop/ui/views/animations)

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

... 

fun showBottomNavBar(isVisible: Boolean) {  
    val screenHeight = context.resources.displayMetrics.heightPixels.toFloat()
    val bottomNavBarY = (screenHeight - binding.bottomNavigationHolder.height)  // положение верхнего левого угла по оси У (вертикально)
    binding.bottomNavBar.apply {  
        animate()  
            .y(if (isVisible) bottomNavBarY else screenHeight)  // положение в которое придет левый верхний угол в конце линейной анимации
            .setDuration(500)  // продолжительность анимации
            .start()  
    }  
}
```

### Set **alphaAnimation**
```kotlin
	val alphaAnimation = AlphaAnimation(0f, 1f).apply { duration = 500 }  
	binding.textView.startAnimation(alphaAnimation)
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

### [Анимация фрагмента ВАР 1 (папка res/anim)](https://developer.android.com/guide/fragments/animate) 
res/anim/fade_out.xml
```kotlin
<?xml version="1.0" encoding="utf-8"?>
<alpha xmlns:android="http://schemas.android.com/apk/res/android"    
	   android:duration="@android:integer/config_shortAnimTime"    
	   android:interpolator="@android:anim/decelerate_interpolator"    
	   android:fromAlpha="1"    
	   android:toAlpha="0" />
```
res/anim/slide_in.xml
```kotlin

<?xml version="1.0" encoding="utf-8"?>
<translate xmlns:android="http://schemas.android.com/apk/res/android"
	android:duration="@android:integer/config_shortAnimTime"
	android:interpolator="@android:anim/decelerate_interpolator"
	android:fromXDelta="100%"
	android:toXDelta="0%" />
```
res/anim/slide_out.xml
```kotlin
<?xml version="1.0" encoding="utf-8"?>
<translate xmlns:android="http://schemas.android.com/apk/res/android"
	android:duration="@android:integer/config_shortAnimTime"
	android:interpolator="@android:anim/decelerate_interpolator"
	android:fromXDelta="0%"
	android:toXDelta="100%" />
```
res/anim/fade_in.xml
```kotlin
<alpha xmlns:android="http://schemas.android.com/apk/res/android"
android:duration="@android:integer/config_shortAnimTime" 
android:interpolator="@android:anim/decelerate_interpolator" 
android:fromAlpha="0"  
android:toAlpha="1" />
```
MainActivity.kt
```kotlin
supportFragmentManager.commit {    
	setCustomAnimations(       
		R.anim.slide_in, // enter  
		R.anim.fade_out, // exit     
		R.anim.fade_in, // popEnter    
		R.anim.slide_out // popExit    )  
	replace(R.id.fragment_container, fragment)  
	addToBackStack(null)  
}
```

### Анимация фрагмента ВАР 2 (папка res/transition)
res/transition/fade.xml
```
<fade xmlns:android="http://schemas.android.com/apk/res/android"  
	android:duration="@android:integer/config_shortAnimTime"/>
```
res/transition/slide_right.xml
```kotlin
<slide xmlns:android="http://schemas.android.com/apk/res/android"  
	android:duration="@android:integer/config_shortAnimTime"  
	android:slideEdge="right" />
```

```kotlin
class FragmentA : Fragment() { 
	override fun onCreate(savedInstanceState: Bundle?) {     
		super.onCreate(savedInstanceState)        
		val inflater = TransitionInflater.from(requireContext())     
		exitTransition = inflater.inflateTransition(R.transition.fade) 
	}  
}  
  
class FragmentB : Fragment() { 
	override fun onCreate(savedInstanceState: Bundle?) {  
		super.onCreate(savedInstanceState)      
		val inflater = TransitionInflater.from(requireContext())        
		enterTransition = inflater.inflateTransition(R.transition.slide_right)
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


