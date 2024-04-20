
### ConstraintLayout
```kotlin
  
<androidx.constraintlayout.widget.ConstraintLayout  
	android:layout_width="match_parent"  
	android:layout_height="match_parent"> 

	<androidx.fragment.app.FragmentContainerView  
		android:layout_width="0dp"  
		android:layout_height="0dp"  
		
		android:layout_marginTop="16dp"  
		app:layout_goneMarginTop="0dp"  // отменит marginTop указанный выше, если "опора" пропадет
		
		app:layout_constraintStart_toStartOf="parent"  
		app:layout_constraintTop_toTopOf="parent"
		
		app:layout_constraintHorizontal_chainStyle="packed" // spread, spread_inside
		
		app:layout_constraintHeight_percent="0.45"  // задать Height как 0.45 * высоту дисплея телефона
		
		app:layout_constraintVertical_bias="0.8"  // смещение по вертикали
		
		app:layout_constraintDimensionRatio="H, 0.9" // расчитать Height как 0,9*Width компонента
		/>
		  
		  
	<androidx.constraintlayout.widget.Guideline  
		android:layout_width="wrap_content"  
		android:layout_height="wrap_content"  
		android:orientation="vertical"  
		app:layout_constraintGuide_end="16dp"  
		app:layout_constraintGuide_percent="0.1" />
	
	<androidx.constraintlayout.helper.widget.Flow  // цепочка объектов указанных в "ids"
		android:layout_width="0dp"  
		android:layout_height="wrap_content"  
		app:flow_wrapMode="chain"  
		app:flow_horizontalBias="0.1"  
		app:flow_horizontalStyle="spread"  
		app:flow_verticalGap="6dp"  
		app:flow_horizontalGap="6dp"  
		app:constraint_referenced_ids="tv1, tv2, tv3" />	
	
	<androidx.constraintlayout.widget.Barrier  // НЕВИДИМЫЙ компонент к которому можно привязаться
		android:layout_width="0dp"  
		android:layout_height="0dp"  
		app:barrierDirection="end"  // прилипнет к "end" самого широкого из указанных ниже "ids"
		app:constraint_referenced_ids="tv1, tv2, tv3" />
	
	<Space  // "пустой" прозрачный компонент, полезно для привязки к нему как к точке на макете
		android:layout_width="wrap_content"  
		android:layout_height="wrap_content"/>

</androidx.constraintlayout.widget.ConstraintLayout>
```

### MotionLayout
### FrameLayout 
### LinearLayout
### RelativeLayout
### CoordinatorLayout
