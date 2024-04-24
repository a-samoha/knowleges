#gradle

[api vs implimentation](https://docs.gradle.org/current/userguide/java_library_plugin.html#:~:text=The%20api%20configuration%20should%20be,are%20internal%20to%20the%20component)

# Var1  -  AS default

## settings.gradle.kts
```kotlin
pluginManagement {  
    repositories {  
        google {  
            content {  
                includeGroupByRegex("com\\.android.*")  
                includeGroupByRegex("com\\.google.*")  
                includeGroupByRegex("androidx.*")  
            }  
        }        
        mavenCentral()  
        gradlePluginPortal()  
    }  
}  
dependencyResolutionManagement {  
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)  
    repositories {  
        google()  
        mavenCentral()  
    }  
}  
  
rootProject.name = "rv"  
include(":app")
```

## build.gradle.kts (Top-level)
```kotlin
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {  
    alias(libs.plugins.androidApplication) apply false  
    alias(libs.plugins.jetbrainsKotlinAndroid) apply false  
}
```

## build.gradle.kts (app) (with flavors)
```kotlin
plugins {  
    alias(libs.plugins.androidApplication)  
    alias(libs.plugins.jetbrainsKotlinAndroid)  
}  
  
android {  
    compileSdk = 34  
	  
    defaultConfig {  
        minSdk = 24  
        targetSdk = 34  
    }  
	  
    compileOptions {  
        sourceCompatibility = JavaVersion.VERSION_1_8  
        targetCompatibility = JavaVersion.VERSION_1_8  
    }  
	  
    namespace = "com.app.rv"  
	  
    // Groovy syntax  
    // flavorDimensions = ["version"]    
    // Kotlin DSL syntax    
    flavorDimensions.add("version")  
    // "version" - указывает название "измерения"  
    // можно сделать несколько измерений    
    // и в каждом по несколько флейворов    
    // Если измерение одно - можно опустить строку    
    // dimension = "version"  
    productFlavors {  
        // Вкус "artsam"  
        create("artsam") {  
            dimension = "version"  
            applicationId = "com.artsam.rv"  
            versionCode = 1  
            versionName = "1.0"  
        }  
		  
        // Вкус "roman"  
        create("roman") {  
            dimension = "version"  
            applicationId = "com.roman.rv"  
            versionCode = 1  
            versionName = "1.0"  
        }  
    }  
    
    buildTypes {  
        release {  
            isMinifyEnabled = false  
            proguardFiles(  
                getDefaultProguardFile("proguard-android-optimize.txt"),  
                "proguard-rules.pro"  
            )  
        }  
    }  
    kotlinOptions {  
        jvmTarget = "1.8"  
    }  
}  
  
dependencies {  
    implementation(libs.material)  
    implementation(libs.androidx.core.ktx)  
    implementation(libs.androidx.viewmodel.ktx)  
    implementation(libs.androidx.activity.ktx)  
    implementation(libs.androidx.appcompat)  
    implementation(libs.androidx.constraintlayout)  
    testImplementation(libs.junit)  
    androidTestImplementation(libs.androidx.junit)  
}
```

## libs.versions.toml
```kotlin
[versions]  
agp = "8.3.2"  
kotlin = "1.9.0"  
coreKtx = "1.12.0"  
viewmodelKtx = "2.7.0"  
fragmentKtx = "1.7.0"  
junit = "4.13.2"  
junitVersion = "1.1.5"  
espressoCore = "3.5.1"  
appcompat = "1.6.1"  
material = "1.11.0"  
activity = "1.8.2"  
constraintlayout = "2.1.4"  
  
[libraries]  
material = { group = "com.google.android.material", name = "material", version.ref = "material" }  
androidx-activity-ktx = { group = "androidx.activity", name = "activity-ktx", version.ref = "activity" }  
androidx-constraintlayout = { group = "androidx.constraintlayout", name = "constraintlayout", version.ref = "constraintlayout" }  
androidx-appcompat = { group = "androidx.appcompat", name = "appcompat", version.ref = "appcompat" }  
androidx-core-ktx = { group = "androidx.core", name = "core-ktx", version.ref = "coreKtx" }  
androidx-viewmodel-ktx = { group = "androidx.lifecycle", name = "lifecycle-viewmodel-ktx", version.ref = "viewmodelKtx" }  
androidx-fragment-ktx = { group = "androidx.fragment", name = "fragment-ktx", version.ref = "fragmentKtx" }  
  
junit = { group = "junit", name = "junit", version.ref = "junit" }  
androidx-junit = { group = "androidx.test.ext", name = "junit", version.ref = "junitVersion" }  
androidx-espresso-core = { group = "androidx.test.espresso", name = "espresso-core", version.ref = "espressoCore" }  
  
[plugins]  
androidApplication = { id = "com.android.application", version.ref = "agp" }  
jetbrainsKotlinAndroid = { id = "org.jetbrains.kotlin.android", version.ref = "kotlin" }
```

# Var2  -  DSL
![[Pasted image 20220708210302.png]]
## build.gradle.kts (Top-level)
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
    // implementation("com.badoo.reaktive.dependencies:dependencies:SNAPSHOT")
}  
  
// Почти то же самое, что и implementation("com.badoo.reaktive.dependencies:dependencies:SNAPSHOT"), 
// но с работающим автодополнением  
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