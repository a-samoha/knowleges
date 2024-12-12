

Переводится как "Залп"

```kotlin

api 'com.android.volley:volley:1.2.1'

...

import com.android.volley.Request  
import com.android.volley.toolbox.StringRequest  
import com.android.volley.toolbox.Volley

const val API_KEY = "Ваш API ключь"

fun getData(name: String, context: Context, mState: MutableState<String>){  
    val url = "https://api.weatherapi.com/v1/forecast.json?key=$API_KEY" +  
             "&q=$city" +  
             "&days=" +  
             "3" +  
             "&aqi=no&alerts=no"
    val queue = Volley.newRequestQueue(context)  
    val stringRequest = StringRequest(  
        Request.Method.GET,  
        url,  
        {  
                response->  
            val obj = JSONObject(response)  
            val temp = obj.getJSONObject("current")  
            mState.value = temp.getString("temp_c")  
            Log.d("MyLog","Response: ${temp.getString("temp_c")}")  
        },  
        {  
            Log.d("MyLog","Volley error: $it")  
        }  
    )  
    queue.add(stringRequest)  
}
```