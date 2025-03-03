
```kotlin
plugins {  
    id("org.jetbrains.kotlin.jvm")  
}  
  
apply("$rootDir/build_jvm.gradle")  
  
dependencies {  
    implementation(project(":core:models"))  
    implementation(project(":core:network"))  
  
    implementation(project(":features:profile:api"))  
  
    implementation(libs.kotlin.coroutinesCore)  
}
```