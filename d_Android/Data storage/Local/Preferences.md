#data_storage
###### Device file explorer / data / data /
![[Pasted image 20220629161840.png]]

###### ----------------------------------------------------------------------------------------------------------
- [`SharedPreferences`](https://developer.android.com/training/data-storage/shared-preferences) : Store private, primitive data in ***key-value pairs***.

###### To get sharedPreferences entity:
```kotlin
class SettingsActivity: AppCompatActivity(){

	private lateinit var sharedPref: SharedPreferences

	override fun onCreate(savedInstanceState: Bundle?) { 
	/*
	* Use this if you need multiple shared preference files identified by name, 
	* which you specify with the first parameter. 
	* You can call this from any Context in your app.
	*/
    sharedPref = getSharedPreferences(getString(R.string.preference_file_key), Context.MODE_PRIVATE)

	/*
	* Use this from an Activity.
	* returns sharedPref FILE linked exactly for current activity
	*/
    sharedPref = getPreferences(Context.MODE_PRIVATE)
    
    /*
	* If you're using the SharedPreferences to save app settings, 
	* you should instead use getDefaultSharedPreferences() 
	* to get the default shared preference file for your entire app. 
	* For more information, see the [Settings developer guide](https://developer.android.com/guide/topics/ui/settings).
	*/
    sharedPref = PreferenceManager.getDefaultSharedPreferences(this)
	}
}
```

###### Read from sharedPreferences:
```kotlin
val someValueFromSp: Int = sharedPref.getInt(getString(R.string.some_value_key), defaultValue)
```

###### Write to sharedPreferences:
```kotlin
with (sharedPref.edit()) { // this is SharedPreferences.Editor!
	putInt(getString(R.string.some_value_key), newSomeValue)    
	apply()  
}
```

###### ----------------------------------------------------------------------------------------------------------
-  [`Preference`](https://developer.android.com/guide/topics/ui/settings)  help you build a user interface for your app settings (although they also use `SharedPreferences` to save the user's settings). Only your application can access it.
  
###### Create a hierarchy (XML file path:  xml/root_preferences.xml)
```xml
<PreferenceScreen xmlns:android="http://schemas.android.com/apk/res/android"  
    xmlns:app="http://schemas.android.com/apk/res-auto">  
  
    <PreferenceCategory app:title="@string/messages_header">  
    
        <EditTextPreference            
	        app:key="text_preference"  
            app:title="@string/text_preference"  
            app:useSimpleSummaryProvider="true" />  
  
        <EditTextPreference            
	        app:key="custom_summary"  
            app:title="@string/custom_summary_title" />  
        
        <Preference           
	        app:key="start_web_page"  
            app:title="@string/start_web_page">  
            <intent                
	            android:action="android.intent.action.VIEW"  
                android:data="http://www.google.com" />  
        </Preference>  
        
        <ListPreference            
	        app:defaultValue="reply"  
            app:entries="@array/reply_entries"  
            app:entryValues="@array/reply_values"  
            app:key="reply"  
            app:title="@string/reply_title"  
            app:useSimpleSummaryProvider="true" />  
    </PreferenceCategory>  
    
    <PreferenceCategory app:title="@string/sync_header"> 
	     
        <Preference            
	        app:fragment="com.artsam.presentation.ui.fragment.settings.NotificationsSettingsFragment"  
            app:key="start_fragment"  
            app:title="Start NOTIFICATIONS settings fragment" />  
            
        <SwitchPreferenceCompat            
	        app:dependency="sync"  
            app:key="attachment"  
            app:summaryOff="@string/attachment_summary_off"  
            app:summaryOn="@string/attachment_summary_on"  
            app:title="@string/attachment_title" />  
    </PreferenceCategory> 
    
</PreferenceScreen>
```


###### Create Fragment class
```kotlin
class MySettingsFragment : PreferenceFragmentCompat() {

	override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {    
	
	    setPreferencesFromResource(R.xml.preferences, rootKey)    
	    
		// Finding Preferences  
		// To access an individual Preference use PreferenceFragmentCompat.findPreference()  
		// This method searches the entire hierarchy for a Preference with the given key.  
		val customSummaryPreference: EditTextPreference? = findPreference("custom_summary")  
		
		// Customize an EditTextPreference dialog  
		customSummaryPreference?.setOnBindEditTextListener {  
		    it.inputType = InputType.TYPE_CLASS_NUMBER  
		    }  
		      
		// Use a custom SummaryProvider  
		customSummaryPreference?.summaryProvider = Preference.SummaryProvider<EditTextPreference> { preference ->  
			val text = preference.text  
		    if (TextUtils.isEmpty(text)) {  "Not set"  }
		    else {  "Length of saved value: " + text?.length  }  
		}  
  
		/*  
		 * Implementing an OnPreferenceChangeListener allows you to listen for 
		 * the value of a Preference is about to change. 
		 * From there, you can validate if this change should occur. 
		 */
		 customSummaryPreference?.setOnPreferenceChangeListener { preference, newValue ->  
		    println("preference: $preference is about to change to \"$newValue\"")  
		    return@setOnPreferenceChangeListener true  
		}
		
		// Control Preference visibility  
		if(/*some feature*/) {  
	        customSummaryPreference?.isVisible = true  
		}
	}  
}
```

###### DataStore
```kotlin

/*
* Only override methods that are used by your `Preference` objects. 
* Attempting to call a method that you haven’t implemented results in an `UnsupportedOperationException`.
*/
class DataStore : PreferenceDataStore() {
	
	override fun putString(key: String, value: String?) {
		// Save the value somewhere    
	}    
	
	override fun getString(key: String, defValue: String?): String? {
		// Retrieve the value    
	}  
}
```

```kotlin

// To enable a custom data store for a specific Preference
val preference: Preference? = findPreference("key")  
preference?.preferenceDataStore = dataStore

// To enable a custom data store for an entire hierarchy, 
// call `setPreferenceDataStore()` on the `PreferenceManager`:
val preferenceManager = preferenceManager  
preferenceManager.preferenceDataStore = dataStore
```

###### Build a hierarchy in code 
```kotlin
override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
	val context = preferenceManager.context
	val screen = preferenceManager.createPreferenceScreen(context)   
	 
	val notificationPreference = SwitchPreferenceCompat(context)    
	notificationPreference.key = "notifications"    
	notificationPreference.title = "Enable message notifications"    
	
	val notificationCategory = PreferenceCategory(context)    
	notificationCategory.key = "notifications_category"    
	notificationCategory.title = "Notifications"    
	screen.addPreference(notificationCategory)    
	notificationCategory.addPreference(notificationPreference)    
	
	val feedbackPreference = Preference(context)    
	feedbackPreference.key = "feedback"    
	feedbackPreference.title = "Send feedback"    
	feedbackPreference.summary = "Report technical issues or suggest new features"  
	  
	val helpCategory = PreferenceCategory(context)    
	helpCategory.key = "help"    
	helpCategory.title = "Help"    
	screen.addPreference(helpCategory)    
	helpCategory.addPreference(feedbackPreference)    
	preferenceScreen = screen}
```

