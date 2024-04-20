#gradle

# Var1
![[Pasted image 20220708210302.png]]
## build.gradle.kts
```kotlin
// Top-level build file where you can add configuration options common to all sub-projects/modules.
...
includeBuild("includedBuild/dependencies")  
  
include(":app")  
include(":data")  
include(":domain")  
include(":presentation")  
```

## includeBuild/build.gradle.kts
```kotlin
plugins {  
    `kotlin-dsl`  
    `java-gradle-plugin`  
    id("dependencies")  
}  
  
dependencies {  
    // Теперь в другой включённой сборке можно использовать Deps  
    implementation(Deps.kotlin.plugin)  
    // implementation(implementation("com.badoo.reaktive.dependencies:dependencies:SNAPSHOT"))  
}  
  
// Почти то же самое, что и implementation("com.badoo.reaktive.dependencies:dependencies:SNAPSHOT"), но с работающим автодополнением  
kotlin.sourceSets.getByName("main").kotlin.srcDir("../dependencies/src/main/kotlin")
```

## includeBuild/dependencies/build.gradle.kts
```kotlin
plugins {  
    `kotlin-dsl`  
    `java-gradle-plugin`}  
  
// To make it available as direct dependency  
group = "com.rosberry.dependencies"  
version = "SNAPSHOT"  
  
repositories {  
    jcenter()  
}  
  
gradlePlugin {  
    plugins.register("dependencies") {  
        id = "dependencies"  
        implementationClass = "com.rosberry.dependencies.DependenciesPlugin"  
    }  
}
```

## Deps
```kotlin

package com.rosberry.dependencies  
  
object Deps {  
    val android = Android  
    
    object Android {  
        val androidx = Androidx
        
		object Androidx {  
		    const val appcompat = "androidx.appcompat:appcompat:1.2.0"
		}
    }
}
```

## DependenciesPlugin.kt
```kotlin
package com.rosberry.dependencies  
  
import org.gradle.api.Plugin  
import org.gradle.api.Project  
  
class DependenciesPlugin : Plugin<Project> {  
  
    override fun apply(target: Project) {  
        // no-op  
    }  
}
```
## module/build.gradle
```kotlin
/*  
 * Copyright (c) 2019 Rosberry. All rights reserved. 
 */
import com.rosberry.dependencies.Deps  
...
apply(from = "$rootDir/tools/android-common.gradle")  
  
dependencies {  
    implementation(Deps.android.dagger.core)  
    kapt(Deps.android.dagger.compiler)  
    implementation(Deps.android.rx.rxjava)  
    implementation(Deps.android.retrofit.core)  
    implementation(Deps.android.retrofit.gsonConverter)  
    implementation(Deps.android.retrofit.rxAdapter)  
    implementation(Deps.android.okhttp.loggingInterceptor)  
    implementation(Deps.android.okhttp.digest)  
}
```