#architecture 

### **Зачем:**
- обеспечивают инкапсуляцию кода в границах модуля. 
	- Никто из участников проекта не сможет "гавнокодить" создавая лишние ссылки на объекты.
![[Pasted image 20220804133531.png]]

# **Реализация обычная:**
##### settings.gradle
```kotlin
...
def libraries = [  
        ':app',  
        ':data',  
        ':domain',  
        ':presentation'  
] as String[]  
  
include libraries  
  
// Change each module's gradle filename - https://stackoverflow.com/a/30878796  
rootProject.children.each{  
    it.buildFileName = it.name + '.gradle'  
}
```

##### build.gradle `(Top-level)`
```kotlin
buildscript {  
    ext {  
		rx_java_version = '2.2.21'
        ...
    }
}
...
```

##### tools/android-common.gradle
```kotlin
android {  
    compileSdk 32  
  
    defaultConfig {  
        minSdk 23  
        targetSdk 32  
          
		testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }  
  
    buildTypes {  
        release {  
            minifyEnabled false  
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'  
        }  
    }    
    buildFeatures {  
        dataBinding true  
        viewBinding true  
    }
    compileOptions {  
        sourceCompatibility JavaVersion.VERSION_1_8  
        targetCompatibility JavaVersion.VERSION_1_8  
    }  
    kotlinOptions {  
        jvmTarget = '1.8'  
    }  
}
```
##### tools/dependencies.gradle
```kotlin
ext {
	// "room_version" val leaves in build.gradle (Top level)
    kotlin = [
            coroutines: "org.jetbrains.kotlinx:kotlinx-coroutines-android:$coroutines_version",
    ]
    androidx = [
            core: "androidx.core:core-ktx:$androidx_core_version",
            appcompat: "androidx.appcompat:appcompat:$androidx_appcompat_version",
            constraintlayout: "androidx.constraintlayout:constraintlayout:$androidx_constraint_version",
            recyclerview: "androidx.recyclerview:recyclerview:$androidx_recyclerview_version",
            lifecycle: "androidx.lifecycle:lifecycle-viewmodel-ktx:$androidx_viewmodel_version"
    ]
    google = [
            material: "com.google.android.material:material:$google_material_version",
    ]
    room = [
            runtime: "androidx.room:room-runtime:$room_version",
            rxjava2: "androidx.room:room-rxjava2:$room_version",
            compiler: "androidx.room:room-compiler:$room_version",
    ]
    shifthackz = [
            logger: "com.github.ShiftHackZ.AndroidLogger:logger:1.0",
            logger_kit: "com.github.ShiftHackZ.AndroidLogger:logger-kit:1.0",
    ]
}
```
##### использование этих двух файлов в my.gradle
```kotlin
...
apply from: "$project.rootDir/tools/android-common.gradle"  // важно двойные кавычки
apply from: '../tools/dependencies.gradle' // тоже работает, но с одинарными кавычками

dependencies {
    api project(':logger')
    api kotlin.coroutines
    api androidx.appcompat
    api androidx.constraintlayout
    api androidx.recyclerview
    api androidx.lifecycle
    api room.runtime
    kapt room.compiler
}
```
<br />
<br />

# **Реализация с помощью DslPlugin**
![[Pasted image 20220804161601.png]]
###### MyDslPlugin.kt
```kotlin
package constru.quality.dependencies  
  
import org.gradle.api.Plugin  
import org.gradle.api.Project  
  
class ConstruDslPlugin : Plugin<Project> {  
  
    override fun apply(target: Project) = Unit  
}
```
##### Dependencies.kt
```kotlin
package constru.quality.dependencies  
  
// region AndroidX Versions  
private const val CORE_KTX_VERSION = "1.8.0"  
private const val APP_COMPAT_VERSION = "1.4.2"  
private const val FRAGMENT_VERSION = "1.4.1"  
private const val SPLASH_VERSION = "1.0.0"  
private const val LIFECYCLE_VERSION = "2.4.1"  
private const val NAVIGATION_VERSION = "2.4.2"  
// endregion  
  
// region ReactiveX Versions  
private const val RX_JAVA_VERSION = "2.2.21"  
private const val RX_ANDROID_VERSION = "2.1.1"  
private const val RX_KOTLIN_VERSION = "2.4.0"  
private const val RX_NETWORK_VERSION = "3.0.8"  
private const val RX_BINDING_VERSION = "2.2.0"  
// endregion
...
object Dependencies {  
    object Module {  
        const val Aws = ":aws"  
        const val Data = ":data"  
        const val Domain = ":domain"  
        const val Mvu = ":mvu"  
        const val Presentation = ":presentation"  
        const val Common = ":common"  
    }  
  
    object AndroidX {  
        const val CoreKtx = "androidx.core:core-ktx:$CORE_KTX_VERSION"  
        const val AppCompat = "androidx.appcompat:appcompat:$APP_COMPAT_VERSION"  
        const val Fragment = "androidx.fragment:fragment-ktx:$FRAGMENT_VERSION"  
        const val Splash = "androidx.core:core-splashscreen:$SPLASH_VERSION"  
        const val Lifecycle = "androidx.lifecycle:lifecycle-livedata-ktx:$LIFECYCLE_VERSION"  
        const val ViewModel = "androidx.lifecycle:lifecycle-viewmodel-ktx:$LIFECYCLE_VERSION"  
        const val NavigationUi = "androidx.navigation:navigation-ui-ktx:$NAVIGATION_VERSION"  
        const val NavigationFragment = "androidx.navigation:navigation-fragment-ktx:$NAVIGATION_VERSION"  
    }  
  
    object ReactiveX {  
        const val RxJava = "io.reactivex.rxjava2:rxjava:$RX_JAVA_VERSION"  
        const val RxAndroid = "io.reactivex.rxjava2:rxandroid:$RX_ANDROID_VERSION"  
        const val RxKotlin = "io.reactivex.rxjava2:rxkotlin:$RX_KOTLIN_VERSION"  
        const val RxNetwork = "com.github.pwittchen:reactivenetwork-rx2:$RX_NETWORK_VERSION"  
        const val RxBinding = "com.jakewharton.rxbinding2:rxbinding:$RX_BINDING_VERSION"  
    }  
  
    object DI {  
        const val Koin = "io.insert-koin:koin-android:$KOIN_VERSION"  
        const val KoinWorkManager = "io.insert-koin:koin-androidx-workmanager:$KOIN_VERSION"  
    }
	      
	object Rules {  
	    val excludeOkHttp = ExcludeRule(  
	        group = "com.squareup.okhttp3",  
	        module = "okhttp",  
	    )  
	}
}
```
##### ExcludeRule.kt
```kotlin
package constru.quality.dependencies  
  
data class ExcludeRule(  
    val group: String,  
    val module: String,  
)
```
##### app.gradle `(Знает про всех)`
```kotlin
import constru.quality.dependencies.Dependencies  
import groovy.lang.Closure

val getApplicationVersionCode: Closure<Int> by ext
  
plugins {  
    id("com.android.application")  
    id("org.jetbrains.kotlin.android")  
}  
  
apply(from = "$rootDir/tools/android-common.gradle")  
apply(from = "$rootDir/ci.gradle")  
  
android {  
    defaultConfig {  
        applicationId = "constru.quality.android"  
        versionCode = getApplicationVersionCode()  
        versionName = "1.0"  
    }  
    flavorDimensions.add("server")  
    productFlavors {  
        create("production") {  
            dimension = "server"  
            buildConfigField ("String", "ENVIRONMENT", "\"production\"")  
            buildConfigField ("String", "API", "\"https://api.constru.me\"")  
        }  
        create("staging") {  
            dimension = "server"  
            buildConfigField("String", "ENVIRONMENT", "\"staging\"")  
            buildConfigField("String", "API", "\"https://dev-api.constru.cc\"")  
        }  
        create("dev") {  
            dimension = "server"  
            buildConfigField("String", "ENVIRONMENT", "\"dev\"")  
            buildConfigField("String", "API", "\"https://dev.constru.ai\"")  
        }  
        create("dev2") {  
            dimension = "server"  
            buildConfigField("String", "ENVIRONMENT", "\"dev2\"")  
            buildConfigField("String", "API", "\"https://dev2.constru.ai\"")  
        }  
        create("dev5") {  
            dimension = "server"  
            buildConfigField("String", "ENVIRONMENT", "\"dev5\"")  
            buildConfigField("String", "API", "\"https://dev5.constru.ai\"")  
        }  
    }}  
  
dependencies {  
    // region <modules>  
    api(project(Dependencies.Module.Data))  
    api(project(Dependencies.Module.Domain))  
    api(project(Dependencies.Module.Presentation))  
    api(project(Dependencies.Module.Aws))  
    // endregion  
  
    // region <di>    
    api(Dependencies.DI.Koin)  
    api(Dependencies.DI.KoinWorkManager)  
    // endregion  
  
    // region <rx>    
    api(Dependencies.ReactiveX.RxJava)  
    api(Dependencies.ReactiveX.RxAndroid)  
    api(Dependencies.ReactiveX.RxKotlin)  
    // endregion  
}

```
##### data.gradle `(Знает про domain. Реализует интерфейсы)`
```kotlin
import constru.quality.dependencies.Dependencies  
  
plugins {  
    id("com.android.library")  
    id("org.jetbrains.kotlin.android")  
    id("kotlin-kapt")  
    id("dependencies")  
}  
  
apply(from = "$rootDir/tools/android-common.gradle")  
  
android {  
    defaultConfig.javaCompileOptions.annotationProcessorOptions.arguments.apply {  
        put("room.schemaLocation", "$projectDir/schemas")  
        put("room.incremental", "true")  
    }  
}  
  
dependencies {  
    // region <modules>  
    api(project(Dependencies.Module.Domain))  
    // endregion  
  
    // region <rx>    
    api(Dependencies.ReactiveX.RxJava)  
    api(Dependencies.ReactiveX.RxAndroid)  
    api(Dependencies.ReactiveX.RxKotlin)  
    // endregion  
  
    // region <network>    
    api(Dependencies.Networking.Retrofit) {  
        exclude(  
            Dependencies.Rules.excludeOkHttp.group,  
            Dependencies.Rules.excludeOkHttp.module,  
        )  
    }  
    api(Dependencies.Networking.RetrofitGson)  
    api(Dependencies.Networking.RetrofitRxJava2)  
    api(Dependencies.Networking.OkHttp)  
    api(Dependencies.Networking.OkHttpInterceptor)  
    api(Dependencies.Utils.Gson)  
    // endregion  
  
    // region <db>    
    api(Dependencies.Database.Room)  
    api(Dependencies.Database.RoomKtx)  
    api(Dependencies.Database.RoomRxJava2)  
    kapt(Dependencies.Database.RoomCompiler)  
    // endregion  
}
```
##### domain.gradle `(Интерфейсы описывающие бизнесс логику, Сущности и UseCases)`
```kotlin
import constru.quality.dependencies.Dependencies  
  
plugins {  
    id("com.android.library")  
    id("org.jetbrains.kotlin.android")  
    id("dependencies")  
}  
  
apply(from = "$rootDir/tools/android-common.gradle")  
  
dependencies {  
    // region <modules>  
    api(project(Dependencies.Module.Common))  
    api(project(Dependencies.Module.Mvu))  
    // endregion  
  
    // region <rx>    api(Dependencies.ReactiveX.RxJava)  
    api(Dependencies.ReactiveX.RxAndroid)  
    api(Dependencies.ReactiveX.RxKotlin)  
    // endregion  
}
```
##### presentation.gradle `(Знает про domain. Пользуется методами из интерфейсов)`