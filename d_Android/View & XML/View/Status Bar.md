[Modifying System UI Visibility in Android 11](https://medium.com/swlh/modifying-system-ui-visibility-in-android-11-e66a4128898b)
[Android 11: WindowInsets](https://blog.stylingandroid.com/android11-windowinsets-part1/)
[WindowInsetsControllerCompat.java](https://androidx.tech/artifacts/core/core/1.7.0-source/androidx/core/view/WindowInsetsControllerCompat.java.html)


[Готовим Window Inset под соусом Jetpack Compose и щепоткой View](https://habr.com/ru/companies/kts/articles/687310/)
[Reverting Window Insets on fragment change](https://stackoverflow.com/questions/69923207/reverting-window-insets-on-fragment-change)

# Android 11 

[Programmatically Change StatusBar](https://www.appsloveworld.com/kotlin/100/12/programmatically-change-status-bar-text-color-in-android-11-api-30)

```kotlin
fun setStatusBarLightText(window: Window, isLight: Boolean) {
    setStatusBarLightTextOldApi(window, isLight)
    setStatusBarLightTextNewApi(window, isLight)
}

// Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
private fun setStatusBarTextColorNewApi(window: Window, isDarkBar: Boolean) {  
    WindowCompat.getInsetsController(window, window.decorView).apply {  
        // dark status bar -> light text  
        isAppearanceLightStatusBars = !isDarkBar  
    }  
}

// Build.VERSION.SDK_INT <= Build.VERSION_CODES.R
private fun setStatusBarTextColorOldApi(window: Window, isDarkBar: Boolean) {  
    val decorView = window.decorView  
    @Suppress("DEPRECATION")  
    decorView.systemUiVisibility =  
        if (isDarkBar) decorView.systemUiVisibility and View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR.inv()  
        else decorView.systemUiVisibility or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR  
}
```


```kotlin
override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
    super.onViewCreated(view, savedInstanceState)  
    if (flavorsTypeProvider() == FlavorType.USA_NATIONAL) renderStatusBar(true)  
}  
  
private fun renderStatusBar(isDark: Boolean) {  
    val window: Window = requireActivity().window  
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {  // >=30 "Android 11"
		
		// получить высоту системного NavigationBar
        val insets = requireActivity().windowManager.currentWindowMetrics.windowInsets  
		val navigationBarHeight = insets.getInsets(WindowInsetsCompat.Type.navigationBars()).bottom;  
		binding.haveAccount.margin(bottom = navigationBarHeight)
        
        //  это системный метод и принимает Boolean
        //  true  - контент приложения отдельно от StatusBar (под нижним краем)
        //  false - контент под StatusBar (FullScreen)
        window.setDecorFitsSystemWindows(!isDark)  
		
		// окрасит текст в белый цвет
        if (isDark) window.insetsController?.setSystemBarsAppearance(0, APPEARANCE_LIGHT_STATUS_BARS)
        // окрасит текст в черный цвет
        else window.insetsController?.setSystemBarsAppearance(APPEARANCE_LIGHT_STATUS_BARS, APPEARANCE_LIGHT_STATUS_BARS)  
    } else {  
	    // этот раздел для устроуйств Build.VERSION.SDK_INT <= 29
	    // эти методы деприкейтнуты 
        @Suppress("DEPRECATION")  
		// растянет rootView на FULLSCREEN и сам опредилит цвет текста StatusBar
        if (isDark) window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN  
		// окрасит текст в черный цвет
        else window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR  
    }  
}  
  
override fun onDestroyView() {  
    if (flavorsTypeProvider() == FlavorType.USA_NATIONAL) renderStatusBar(false)  
    super.onDestroyView()  
}
```


## Method 1: Using .xml Theme

##### values/styles
```xml
<resources>
    <style name="Theme.OverlapSystemBar" parent="Theme.AppCompat.Light.NoActionBar">  <!-- = statusBar bg is gray with black text-->
			      <!-- parent="android:Theme.AppCompat.NoActionBar"                      = statusBar bg is black with white text -->
		          <!-- parent="android:Theme.AppCompat.Light.NoActionBar.Fullscreen"     = statusBar disapear in 2 sec -->
        <item name="colorPrimary">@color/purple_200</item>
        <item name="colorPrimaryDark">@color/teal_200</item> <!-- change statusBarColor -->
        <item name="colorAccent">@color/black</item>
        <!-- change statusBarColor but MORE powerful then "colorPrimaryDark" -->
		<item name="android:windowLightStatusBar">true</item> <!-- change statusBar text color (black/withe) -->
		<item name="android:statusBarColor">@android:color/transparent</item>
		<item name="android:navigationBarColor">@android:color/transparent</item>
		<item name="android:windowBackground">?attr/colorSurface</item>
    </style>
</resources>
```

##### AndroidManifest.xml
```xml
<activity  
    android:name="com.artsam.presentation.main.MainActivity"
    android:theme="@style/AppTheme.OverlapSystemBar">
```

## Method 2: Using setStatusBarColor Method (window.statusBarColor)

add this `kotlin` code in `OnCreate()` of `Activity` or `Fragment` :
```kotlin
if (Build.VERSION.SDK_INT >= 21) {
            val window = requireActivity().window
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            window.statusBarColor = this.resources.getColor(R.color.colorPrimaryDark)
		}
```

## or Activity extension fun

```kotlin
fun Activity.coloredStatusBarMode(
	@ColorInt color: Int = Color.WHITE, 
	lightSystemUI: Boolean? = null
) { 
		var flags: Int = window.decorView.systemUiVisibility // get current flags 
		var systemLightUIFlag = View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR 
		var setSystemUILight = lightSystemUI 
		
		if (setSystemUILight == null) { 
			// Automatically check if the desired status bar is dark or light 
			setSystemUILight = ColorUtils.calculateLuminance(color) < 0.5 
		} 
		
		flags = if (setSystemUILight) { 
			// Set System UI Light (Battery Status Icon, Clock, etc) 
			removeFlag(flags, systemLightUIFlag) 
		} else { 
			// Set System UI Dark (Battery Status Icon, Clock, etc) 
			addFlag(flags, systemLightUIFlag) 
		} 
			
		window.decorView.systemUiVisibility = flags 
		window.statusBarColor = color 
} 

private fun containsFlag(flags: Int, flagToCheck: Int) = (
flags and flagToCheck) != 0 

private fun addFlag(flags: Int, flagToAdd: Int): Int { 
	return if (!containsFlag(flags, flagToAdd)) { flags or flagToAdd } else { flags } 
} 
	
private fun removeFlag(flags: Int, flagToRemove: Int): Int { 
	return if (containsFlag(flags, flagToRemove)) { flags and flagToRemove.inv() } else { flags } 
}
```

# in COMPOSE

## Method 1: Using .xml Theme

Отключить ActionBar можно только c помощью манифеста
```xml
<application android:theme="@style/Theme.FinanceNavigator">
<!--  <activity android:theme="@style/Theme.FinanceNavigator">  -->
```
Поэтому создаем рутову тему приложения в themes.xml
```xml
<style name="Theme.SomeApp" parent="android:Theme.Material.Light.NoActionBar">   <!-- = statusBar bg is gray with black text-->
			      <!-- parent="android:Theme.Material.NoActionBar" = splash screen and statusBar bg is black with white text -->
		          <!-- parent="android:Theme.Material.NoActionBar.Fullscreen" 
											          = statusBar не прозрачный и занимает место но текст исчезает через 2 сек -->
		          <!-- parent="android:Theme.Material.NoActionBar.TranslucentDecor" = контент подъезжает под полу прозрачный statusBar -->
    <item name="android:statusBarColor">@android:color/transparent</item>  
</style>
```
Просто убрать StatusBar можно добавив строку (при теме описанной выше)
```kotlin
class MainActivity : ComponentActivity() {  
    override fun onCreate(savedInstanceState: Bundle?) {  
        super.onCreate(savedInstanceState)  
        WindowCompat.setDecorFitsSystemWindows(window, false)  // вот эта строка делает магию
        setContent {}
```

## Method 2: Programaticaly in Composable SomeAppTheme

```kotlin
@Composable  
fun SomeAppTheme(  
    darkTheme: Boolean = isSystemInDarkTheme(),  
    content: @Composable () -> Unit  
) {  
    val colors = if (darkTheme) DarkColorPalette  
    else LightColorPalette  
  
    val view = LocalView.current  
    if (!view.isInEditMode) {  
        SideEffect {  
            val window = (view.context as Activity).window  
            window.statusBarColor = colors.background.toArgb()  // цвет статус бара
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = true  // черный/белый
            //window.navigationBarColor = colors.primary.copy(alpha = 0.08f).compositeOver(colorScheme.surface.copy()).toArgb()  
            //WindowCompat.getInsetsController(window, view).isAppearanceLightNavigationBars = !darkTheme        }  
    }  
  
    MaterialTheme(  
        colors = colors,  
        typography = Typography,  
        shapes = Shapes,  
        content = content  
    )  
}
```
window.statusBarColor = colors.background.toArgb()    **- позволяет указать цвет статус бара**
WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = true    **- цвет текста статус бара:   true(черный)/false(белый)** 