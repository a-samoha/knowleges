[documentation](https://developer.android.com/develop/ui/views/layout/webapps/webview)
[bridge betwen JS and Java](http://rapidprogrammer.com/android-how-to-call-native-java-methods-from-webview-javascript)

## fragment_web_view_popup.xml

```xml
<?xml version="1.0" encoding="utf-8"?>  
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"  
    android:layout_width="match_parent"  
    android:layout_height="match_parent">  
  
    <WebView        
	    android:id="@+id/webView"  
        android:layout_width="match_parent"  
        android:layout_height="match_parent" />  
  
    <ProgressBar        
	    android:id="@+id/progressBar"  
        android:layout_width="@dimen/uikit_dimen_60"  
        android:layout_height="@dimen/uikit_dimen_60"  
        android:layout_gravity="center"  
        android:visibility="invisible" />  
  
</FrameLayout>/>
```


## PopupWebViewScreen

```kotlin
class PopupWebViewScreen : Fragment() {  
	  
    private lateinit var binding: FragmentWebViewPopupBinding  
	  
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {  
        binding = FragmentWebViewPopupBinding.inflate(inflater, container, false)  
        return binding.root  
    }  
	  
    @SuppressLint("SetJavaScriptEnabled")  
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
        super.onViewCreated(view, savedInstanceState)  
		  
        with(binding.webView) {  
            settings.apply {  
                javaScriptEnabled = true  
                addJavascriptInterface(PopupWebInterface(requireContext()), "B9PopupWebInterface")  
                setSupportZoom(true)  
                builtInZoomControls = true  
                displayZoomControls = false  
            }  
			  
            // todo change when back will be done  
            // loadUrl(requireNotNull(arguments).argUrl)  
            loadUrl("file:///android_asset/asset_popup_web.html")  
        }  
    }  
	
}
```


## PopupWebInterface.kt

```kotlin
class PopupWebInterface(private val context: Context) {  
  
    /** Show a toast from the web page  */  
    @JavascriptInterface  
    fun showToast(toast: String?) {  
        Toast.makeText(context, toast, Toast.LENGTH_SHORT).show()  
    }  
}
```


## asset_popup_web.html

```html
<link type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet"/>  
<style>  
   body{overflow: hidden;}  
   .container{padding: 0 16px;}  
   .col-12{padding: 8px 16px;}  
   div {font-size: 16px;}  
   .row{margin: 0 -16px;}  
   h1 {font-size: 28px; margin: 0;}  
   img{width: 240px;  }  
   .fixed-bottom a{border: 0; background: #009C3D;    color: #FFF; text-transform: uppercase;   
      font-weight:500; font-size: 18px; border-radius: 12.5px;   text-align: center;  
      text-decoration: none;}  
</style>  
<div class="container">  
    <div class="row">  
  
        <h1 onClick="showAndroidToast('Click on title')" class="col-12" >This is testing title</h1>  
  
        <div class="col-12" onClick="showAndroidToast('Click on subtitle')">This is testing text and desciprion 
	        and desciprion and desciprion and desciprion and desciprion  
            and desciprion and desciprion and desciprion and desciprion 
        </div>  
  
        <div class="col-12 text-right">  
            <img src="https://img1.picmix.com/output/stamp/normal/0/6/8/5/565860_01494.gif"/>  
        </div>  
        <div class="col-12 fixed-bottom">  
            <a onClick="showAndroidToast('Hello From B9!')" href="#" class="col-12 d-block">NEXT</a>  
        </div>  
        <input type="button" value="Say hello" onClick="showAndroidToast('Hello Android!')"/>  
  
        <!-- Such kind of a js code should be used to handle the WebView clicks -->  
        <script type="text/javascript">  
            function showAndroidToast(toast) {  
                if(typeof B9PopupWebInterface !== "undefined" && B9PopupWebInterface !== null) {  
                    B9PopupWebInterface.showToast(toast);  
                } else {  
                    alert("Not viewing in webview");  
                }  
            }  
        </script>  
    </div></div>
```