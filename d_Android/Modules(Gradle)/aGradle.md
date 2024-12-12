#Gradle

[[build.gradle (groovy)]]
[[build.gradle.kts (kotlin)]]


* ERROR:
Failed to calculate the value of task ':compileJava' property 'javaCompiler'.
No matching toolchains found for requested specification: {languageVersion=11, vendor=any, implementation=vendor-specific}.
No locally installed toolchains match (see https://docs.gradle.org/8.0.2/userguide/toolchains.html#sec:auto_detection) 
and toolchain download repositories have not been configured (see https://docs.gradle.org/8.0.2/userguide/toolchains.html#sub:download_repositories).
- Handling:   
	add to `settings.gradle.kts`
```kotlin
plugins {
    id("org.gradle.toolchains.foojay-resolver-convention") version("0.4.0")
}
```