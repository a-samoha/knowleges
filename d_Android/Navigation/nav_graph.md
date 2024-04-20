### build.gradle
```kotlin  
api ("androidx.navigation:navigation-fragment-ktx:$nav_version")  
api ("androidx.navigation:navigation-ui-ktx:$nav_version")
```
### res/layout/activity_main
```xml
...
<androidx.fragment.app.FragmentContainerView  
    android:id="@+id/fcv_nav_host"  
    android:name="androidx.navigation.fragment.NavHostFragment"  
    android:layout_width="match_parent"  
    android:layout_height="match_parent"  
    app:defaultNavHost="true"  
    app:layout_constraintTop_toTopOf="parent"  
    app:navGraph="@navigation/main" />
```
### res/navigation/nav_graph
1. In the 
window, right-click on the `res` directory and select **New > Android Resource File**.
2. Type a name in the **File name** field, such as "nav_graph".
3. Select **Navigation** from the **Resource type**
```xml
<?xml version="1.0" encoding="utf-8"?>  
<navigation 
	xmlns:android="http://schemas.android.com/apk/res/android"  
    xmlns:app="http://schemas.android.com/apk/res-auto"  
    android:id="@+id/nav_graph"  
    app:startDestination="@id/mdPageFragment">  
    
    <fragment        
	    android:id="@+id/mdPageFragment"  
        android:name="com.artsam.presentation.mdviewer.ui.fragment.mdpage.MdPageFragment"  
        android:label="MdPageFragment">
        <action 
	        android:id="@+id/toResetPassword"  <!-- local -->
			app:destination="@id/resetPasswordFragment" />
    </fragment>
     
	<fragment  
	    android:id="@+id/resetPasswordFragment"  
	    android:name="constru.quality.presentation.ui.fragment.auth.ResetPasswordFragment"  
	    android:label="ResetPasswordFragment"  
	    tools:layout="@layout/fragment_reset_password">  
	    <argument  
	        android:name="username"  
	        app:argType="string" />  
	</fragment>
	
    <dialog
	    android:id="@+id/someDialog" />
	    
	<action  
	    android:id="@+id/globalLogout"  
	    app:destination="@+id/logInFragment"  
	    app:popUpTo="@id/main"  
	    app:popUpToInclusive="true" />
	    
</navigation>
```