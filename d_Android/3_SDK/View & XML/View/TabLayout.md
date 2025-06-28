
- `app:tabInlineLabel="true"`    располагает иконку и текст гризонтально (последовательно)

- `android:textColor=""`   задает цвет НЕ активных заголовков

- `app:tabIconTint="@color/tab_icon"`    задает цвет ИКОНОК.  Нужно СОЗДАТЬ файл:
```xml
<?xml version="1.0" encoding="utf-8"?>  
<selector xmlns:android="http://schemas.android.com/apk/res/android">  
    <item android:color="@color/color_text_regular" android:state_selected="true" />  
    <item android:color="@color/color_text_not_active_tab_item" />  
</selector>
```

- `app:tabIndicatorColor=""`    задает цвет линии-индикатора активного таба  [custom indicator](https://medium.com/android-news/custom-tablayout-indicator-in-android-8f3735e70dc)

- `app:tabSelectedTextColor=""`     задает цвет активного заголовка

- `app:tabTextAppearance="@style/Theme.App.TabLayout"`    задает стиль шрифта
```xml
<style name="Theme.App.TabLayout" parent="">  
    <item name="fontFamily">@font/rubik_regular</item>  
    <item name="android:textSize">@dimen/size_text_tab</item>  
    <item name="android:textStyle">bold</item>  
</style>
```

