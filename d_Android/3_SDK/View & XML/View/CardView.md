##### instead of CardView:

card_bg_white_rounded_12dp
```xml
<?xml version="1.0" encoding="utf-8"?>  
<shape xmlns:android="http://schemas.android.com/apk/res/android">  
    <solid android:color="@android:color/white" />  
    <corners android:radius="12dp" />  
</shape>
```

card_bg_white_ripple_effect
```xml
<?xml version="1.0" encoding="utf-8"?>  
<ripple xmlns:android="http://schemas.android.com/apk/res/android"  
    android:color="@color/gray_600">  
    <item>        
	    <shape android:shape="rectangle">  
            <corners android:radius="12dp" />  
            <solid android:color="@color/white" />  
        </shape>    
    </item>
</ripple>
```

if You nee to turn the grey onClick animation - set:
```xml
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"  
    xmlns:app="http://schemas.android.com/apk/res-auto"  
    android:layout_width="match_parent"  
    android:layout_height="wrap_content"  
    android:background="@drawable/bg_white_rounded_12dp"  
    android:elevation="2dp"  
    app:itemBackground="@null"
    app:itemRippleColor="@null">
```

