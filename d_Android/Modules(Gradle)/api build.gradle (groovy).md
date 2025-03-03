
```groovy
plugins {  
    id("org.jetbrains.kotlin.jvm")  
}  
  
apply from: "$rootDir/build_jvm.gradle"  
  
dependencies {  
    implementation(project(":core:validation:api"))  
    implementation(project(":core:models"))  
  
    implementation(project(":features:profile:api"))  
  
    implementation(libs.kotlin.coroutinesCore)  
    implementation(libs.gson)  
}
```

