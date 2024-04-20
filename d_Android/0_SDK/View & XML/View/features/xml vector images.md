```xml
<?xml version="1.0" encoding="utf-8"?>  
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">  
    <item>        
	    <shape android:shape="rectangle">  
            <corners android:radius="@dimen/uikit_dimen_12" />  
            <solid android:color="@color/logoBrandColor" />  
            <size        
                android:width="200dp"  
	            android:height="200dp" />  
        </shape>    
    </item>
    <item
        android:width="112dp"  
        android:height="120dp"  
        android:drawable="@drawable/ui_kit_app_logo_white"  // здесь можно использовать другой xml с вектором
        android:gravity="center" />  
	<item
	    android:width="230dp"
	    android:height="70dp">
		<bitmap
	        android:gravity="fill_horizontal|fill_vertical"
	        android:src="@drawable/screen" />  // здесь можно использовать картинку (png, webp)
	</item>
</layer-list>
```

res/drawable/ui_kit_app_logo_white.xml
```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"  
    android:width="343dp"  
    android:height="362dp"  
    android:viewportWidth="343"  
    android:viewportHeight="362">  
	<path 
	    android:pathData="M178.67,12.5C178.39, ..."  
	    android:fillColor="#FFFFFF"/>  
	<path
		android:pathData="M171.58,0L164.21,10.97H178.25"  
        android:fillColor="#FFFFFF"/>  
</vector>
```



```xml
<!-- ic_launcher_foreground -->
<vector xmlns:android="http://schemas.android.com/apk/res/android"  
    android:width="108dp"  
    android:height="108dp"  
    android:viewportWidth="108"  
    android:viewportHeight="108">  
    <!-- масштабирование -->
    <!-- положение (в право/в лево) -->
	<group android:scaleX="2.0828571"  
		      android:scaleY="2.0828571"  
		      android:translateX="25.881428"  
		      android:translateY="24.84">  
	    <path  
	        android:pathData="M13.044,-0L0,8.4L13.044,16.8L26.088,8.4L13.044,-0Z"  
	        android:fillColor="#FF3761"/>  
	    <path  
	        android:pathData="M13.044,16.8L0,8.4V19.6L13.044,28L26.087,19.6L17.392,14L13.044,16.8Z"  
	        android:fillColor="#2F354A"/>  
	</group>  
</vector>
```

```xml
<?xml version="1.0" encoding="utf-8"?> 

<!-- ic_launcher -->
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">  
    <background android:drawable="@color/ic_launcher_background"/>  
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>  
</adaptive-icon>
```


[источник1:](https://blog.stylingandroid.com/vectordrawable-gradients-part1/)
[источник2:](https://blog.stylingandroid.com/vectordrawable-gradients-part1-2/)

```xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
  xmlns:aapt="http://schemas.android.com/aapt"
  android:width="96dp"
  android:height="96dp"
  android:viewportHeight="100"
  android:viewportWidth="100">

  <path
    android:pathData="M1,1 H99 V99 H1Z"
    android:strokeColor="?android:attr/colorAccent"
    android:strokeWidth="2">
    <aapt:attr name="android:fillColor">
      <gradient
        android:endX="50"
        android:endY="99"
        android:startX="50"
        android:startY="1"
        android:type="linear">
        <item
          android:color="?android:attr/colorAccent"
          android:offset="0.0" />
        <item
          android:color="?android:attr/colorPrimary"
          android:offset="0.8" />
        <item
          android:color="?android:attr/colorPrimaryDark"
          android:offset="1.0" />
      </gradient>
    </aapt:attr>
  </path>

  <path android:strokeWidth="0.1"
    android:strokeColor="@color/colorAccent"
    android:pathData="M0,80 H100" />
</vector>
```