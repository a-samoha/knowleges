
```kotlin
enum class LinkFollowMode : Serializable {  
    BrowserPreview,  
    WebView,  
    WebViewWithDefaultClient,  
    Default;  
  
    companion object {  
        fun fromString(rawLinkFollowMode: String?): LinkFollowMode =  
            entries.find { it.name.equals(rawLinkFollowMode, ignoreCase = true) } ?: Default  
    }  
}

data class EmbeddedUrlModel(  
    val placeholder: String,  
    val text: String,  
    val url: String,  
    val type: LinkFollowMode,  
) : Serializable

data class LinkedTextModel(  
    val text: String = "",  
    val urls: List<EmbeddedUrlModel> = emptyList(),  
    val urlsColor: String = PRIMARY_COLOR,  
    val isUnderlined: Boolean = false,  
) : Serializable {  
    companion object{  
        const val PRIMARY_COLOR = "#009C3D"  
    }  
}

fun LinkedTextModel.toAnnotatedString(): AnnotatedString {  
    return buildAnnotatedString {  
        var currentIndex = 0  
  
        urls.forEachIndexed { index, urlModel ->  
            val regex = Regex.escape(urlModel.placeholder).toRegex()  
            val matchResult = regex.find(text)  
  
            matchResult?.let {  
                val start = matchResult.range.first  
                val end = matchResult.range.last + 1  
  
                // Add text instead of placeholder  
                if (currentIndex < start) {  
                    append(text.substring(currentIndex, start))  
                }  
  
                withStyle(  
                    style = SpanStyle(  
                        color = Color(B9ColorParser.parseColor(this@toAnnotatedString.urlsColor)),  
                        textDecoration = if (isUnderlined) TextDecoration.Underline else TextDecoration.None  
                    )  
                ) {  
                    append(urlModel.text)  
                }  
                addStringAnnotation(  
                    tag = "URL",  
                    annotation = urlModel.url,  
                    start = length - urlModel.text.length,  
                    end = length  
                )  
  
                currentIndex = end  
            }  
        }  
        // Add text after last placeholder  
        if (currentIndex < text.length) {  
            append(text.substring(currentIndex))  
        }  
    }  
}
```