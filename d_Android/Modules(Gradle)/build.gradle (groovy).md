#gradle

[api vs implimentation](https://docs.gradle.org/current/userguide/java_library_plugin.html#:~:text=The%20api%20configuration%20should%20be,are%20internal%20to%20the%20component)

## build.gradle
```groovy
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {  
    id 'com.android.application' version '7.3.1' apply false  
    id 'com.android.library' version '7.3.1' apply false  
    id 'org.jetbrains.kotlin.android' version '1.7.20' apply false  
}

apply from: 'gradle/dependencies.gradle'
```
<br />

## gradle/dependencies.gradle
```kotlin
// Create this file in the default gradle directory
// and use it once in the build.gradle (Top-level) file
// apply from: 'gradle/dependencies.gradle' (build.gradle)
ext.coroutines_version = '1.7.0'
// OR
ext{
    room_version = '1.6.2'
    androidx_viewmodel_version = '1.4.5'
    ...
}
// also
ext {
	// "coroutines_version" val can be declared anywhere in .gradle files
    kotlin = [
            coroutines: "org.jetbrains.kotlinx:kotlinx-coroutines-android:$coroutines_version",
    ]
    androidx = [
            core: "androidx.core:core-ktx:$androidx_core_version",
            appcompat: "androidx.appcompat:appcompat:$androidx_appcompat_version",
            constraintlayout: "androidx.constraintlayout:constraintlayout:$androidx_constraint_version",
            recyclerview: "androidx.recyclerview:recyclerview:$androidx_recyclerview_version",
            lifecycle: "androidx.lifecycle:lifecycle-viewmodel-ktx:$androidx_viewmodel_version",
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
<br />

## settings.gradle
```groovy
pluginManagement {  
    repositories {  
        gradlePluginPortal()  
        google()  
        mavenCentral()  
        maven { url = 'https://jitpack.io' }
    }  
}  
dependencyResolutionManagement {  
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)  
    repositories {  
        google()  
        mavenCentral()
        maven { url = 'https://jitpack.io' }  
    }  
}

rootProject.name = "DataStorage"  

// Groovy definition of libs array 
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
<br />

## gradle/android-common.gradle
```groovy
// Create this file in the default gradle directory
android {  
    compileSdk 32  
	
    defaultConfig {  
        minSdk 23  
        targetSdk 32  
		  
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"  
		consumerProguardFiles "consumer-rules.pro"
	}  
	  
    buildTypes {  
        release {  
            minifyEnabled false  
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'  
        }  
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
<br />

## presentation.gradle ()
```groovy
plugins {  
    id 'com.android.application'  
    id 'org.jetbrains.kotlin.android'  
}  
  
//apply from: '../gradle/android-common.gradle'  
apply from: "$rootDir/gradle/android-common.gradle"

// This is just an example. 
// We can add "buildFeatures" into "android-common.gradle".
android {  
    buildFeatures {  
	    // compose true
	    dataBinding true  
	    viewBinding true  
	}  
}

dependencies {  
    // module  
    api project(":domain")  
	
	// androidx
    api androidx.core
	api androidx.appcompat
	api androidx.constraintlayout
	api androidx.recyclerview
	api androidx.lifecycle
	
	// coroutines
	api kotlin.coroutines
	
	// room
	api room.runtime
	kapt room.compiler
}
```
<br/>

## app.gradle ()
```groovy
plugins {  
    id 'com.android.application'  
    id 'org.jetbrains.kotlin.android'  
}  
  
apply from: "$project.rootDir/gradle/android-common.gradle"  
  
android {  
    namespace 'com.artsam.mmdd'  
    defaultConfig {  
        applicationId "com.artsam.mmdd"  
        versionName "1.0.0"  
        versionCode 1  
    }  
}  
  
dependencies {  
    api project(':presentation')  
}
```