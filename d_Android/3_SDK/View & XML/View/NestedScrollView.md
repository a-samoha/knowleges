```xml
<androidx.core.widget.NestedScrollView  
    android:layout_width="0dp"  
    android:layout_height="0dp"  
    android:fillViewport="true"  // РАСТЯГИВАЕТ по всей площади
    app:layout_constraintBottom_toBottomOf="parent"  
    app:layout_constraintEnd_toEndOf="parent"  
    app:layout_constraintStart_toStartOf="parent"  
    app:layout_constraintTop_toBottomOf="@id/toolbarDivider">
```

Атрибут **`android:fillViewport="true"`** внутри тега `ScrollView` указывает, 
что внутреннее содержимое (например, LinearLayout или RelativeLayout) 
должно быть увеличено до размеров прокручиваемой области внутри `ScrollView`.

Если этот атрибут не указан, то содержимое может оставаться меньше по высоте, 
чем `ScrollView`, и это может привести к неправильной работе прокрутки.
