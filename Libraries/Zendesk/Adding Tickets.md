[Support SDK - Adding Tickets](https://developer.zendesk.com/documentation/classic-web-widget-sdks/support-sdk/android/requests/)

```kotlin
fun sendZendeskReport(  
    context: Context,  
    fileLogger: FileLogger,  
    isPremiumSupport: Boolean,  
    sectionTagName: String? = null,  
    requestId: String? = null,  
) {  
    val tags = arrayListOf("android", "mobile")  
    if (isPremiumSupport) tags.add("premium_cs")  
  
    when {  
        requestId != null -> {  
            val b9ActivityIntent = Intent(context, context::class.java)  
            val deepLinkIntent = Builder()  
                .setupCommonConfig(tags, fileLogger)  
                .withRequestId(requestId)  
                .deepLinkIntent(context, b9ActivityIntent)  
            context.sendBroadcast(deepLinkIntent)  
        }  
        sectionTagName != null -> {  
            tags.add(sectionTagName)  
            RequestActivity.builder()  
                .setupCommonConfig(tags, fileLogger)  
                .withCustomFields(listOf(CustomField(
	                SupportCategoriesViewModel.ID_FOR_ZENDESK_CATEGORIES, sectionTagName
	            )))  
                .show(context)  
        }  
        else ->  
            RequestListActivity.builder()  
                .show(context, getConfig(tags, fileLogger))  
    }  
}  
  
private fun Builder.setupCommonConfig(tags: List<String>, fileLogger: FileLogger): Builder {  
    withRequestSubject("Android Ticket")  
    withTags(tags)  
    try {  
        val logFile = fileLogger.getLogFile()  
        if (logFile.length() < 20 * 1024 * 1024) {  
            withFiles(logFile)  
        }  
    } catch (e: Exception) {  
        Timber.e(e)  
    }  
    return this  
}  
  
private fun getConfig(tags: ArrayList<String>, fileLogger: FileLogger) =  
    RequestActivity.builder()  
        .setupCommonConfig(tags, fileLogger)  
        .config()
```