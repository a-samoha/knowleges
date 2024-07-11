## Используем либу как файл .aar

- Скачиваем файл .aar (напр.: "fraudforce-lib-release-4.3.0.aar")

- Кладем этот файл в папку (напр.: "root/libs/fraudforce-lib-release-4.3.0")
	- создаем в этом модуле файл build.gradle:
	```kotlin
	configurations.maybeCreate("default")  
	artifacts.add("default", file("fraudforce-lib-release-4.3.0.aar"))
	```

- Добавляем в файл settings.gradle строку:
```kotlin
	include ":libs:fraudforce-lib-release-4.3.0" 
```

- Добавляем в build.gradle целевого модуля строку:
```kotlin
	implementation(project(":libs:fraudforce-lib-release-4.3.0"))
```

- Теперь в конечном целевом модуле можно использовать классы из либы:
```kotlin
	import com.iovation.mobile.android.FraudForceConfiguration
	
	...
	FraudForceConfiguration.Builder()  
		.subscriberKey(BuildConfig.IOVATION_API_KEY)  
	    .build() 
	...
```
  