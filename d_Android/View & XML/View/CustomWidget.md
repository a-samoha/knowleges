#### abstract class Widget
```kotlin
package com.b9.app.core.ui_kit.widget  
  
import android.os.Bundle  
import android.view.View  
import android.view.ViewGroup  
import androidx.lifecycle.LifecycleOwner  
  
  
abstract class Widget {  
	  
    var arguments: Bundle? = null  
    
    abstract fun build(parent: ViewGroup, lifecycleOwner: LifecycleOwner): View  
}
```

#### class MyCustomWidget
```kotlin
// just 1dp line 
class Separator : Widget() {  
	
    override fun build(parent: ViewGroup, lifecycleOwner: LifecycleOwner): View {  
        return LayoutInflater.from(parent.context)  
            .inflate(R.layout.wallet_separator_widget, parent, false)  
    }  
}
```

#### SomeFragment
```kotlin
	...
	bindWidgets(depositWidgetContainer, *getWidgets(state.loan).toTypedArray())
	// or
	bindWidget(advanceWidgetContainer, AdvanceWidget(nextAdvanceInfo))
```

#### LifecycleOwnerEx.kt extention (some file)
```kotlin
package com.b9.app.core.ui_kit.widget  
  
import android.view.View  
import android.view.ViewGroup  
import androidx.lifecycle.LifecycleOwner  
  
fun <T : Widget> LifecycleOwner.bindWidget(  
    container: ViewGroup,  
    widget: T,  
    configure: View.() -> Unit = {}  
) {  
    container.removeAllViews()  
    val view = widget.build(container, this)  
    view.configure()  
    container.addView(view)  
}  
  
fun <T : Widget> LifecycleOwner.bindWidgets(  
    container: ViewGroup,  
    vararg widgets: T,  
    callback: (() -> Unit)? = null  
) {  
    container.removeAllViews()  
    widgets.forEach { widget ->  
        val view = widget.build(container, this)  
        container.addView(view)  
    }  
    callback?.invoke()  
}
```