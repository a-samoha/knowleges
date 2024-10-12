#architecture 

## Builder [link](https://asvid.github.io/kotlin-builder-pattern)
- Builder pattern is used to simplify creating complex objects with non-trivial building logic, or with many constructor parameters. 
- It allows making immutable objects because all properties can be set by the Builder with no need to use object setters.
- Builder solves problem of telescopic constructors, when many variants of constructor are created with increasing number of arguments.
 ```kotlin
 constructor(firstName: String): this(firstName, "", 0)
 constructor(firstName: String, lastName: String): this(firstName, lastName, 0)
 constructor(firstName: String, lastName: String, age: Int): this(firstName, lastName, age)
 ```
##### Examples
```kotlin
/*
* In this example Builder methods are connected in a chain. 
* It’s possible because each one of them returns Builder instance, so `this`. 
* With proper method naming you can almost read it like a sentence.
*/
SomePermissionsListener.Builder
        .withContext(context)
        .withTitle("Camera permission")
        .withMessage("Camera permission is needed to take pictures of your cat")
        .withButtonText(android.R.string.ok)
        .withIcon(R.mipmap.my_icon)
        .build()
```

```kotlin
/*
* Interestingly enough there is no `build()` method 
* but `show()` that is NOT only returning dialog object but also displays it. 
* Sounds like a bad idea for a method to do more than one thing, 
* but in this case I believe it was done on purpose to avoid a common mistake 
* of creating a dialog but forgetting to display it with a separate method.
*/
val dialog = AlertDialog.Builder(this)
        .apply {
            setTitle("Title")
            setIcon(R.mipmap.ic_launcher)
        }.show()
```
##### Implementation
```kotlin
// Java style
class Product private constructor(
        val property: Any,
        val optionalProperty: Any?
) {

    class Builder(private val requiredProperty: Any) {
        private var optionalProperty: Any? = null

        fun optionalProperty(value: Any?): Builder {
            this.optionalProperty = value
            return this
        }

        fun build(): Product {
            return Product(requiredProperty, optionalProperty)
        }
    }
}

// ...

val product = Product.Builder("required")
        .optionalProperty("optional")
        .build()
```

```kotlin
/*
* Kotlin style
* 
* Such Builder can be used in few ways:
* -   identical as in Java or Kotlin example above
* -   providing both arguments (required and optional) at once in Builder constructor
* -   providing both arguments but in random order using named arguments ```kotlin 
*/
class FancyProduct private constructor(
        val property: Any,
        val optionalProperty1: Any?
        val optionalProperty2: Any?
        val optionalProperty3: Any?
) {

    class Builder(
            private var requiredProperty: String,
            private var optionalProperty1: Any? = null,
            private var optionalProperty2: Any? = null,
            private var optionalProperty3: Any? = null,
    ) {

        fun optionalProperty1(value: Any) = apply { this.optionalProperty1 = value }
        fun optionalProperty2(value: Any) = apply { this.optionalProperty2 = value }
        fun optionalProperty3(value: Any) = apply { this.optionalProperty3 = value }

        fun build(): FancyProduct {
            return FancyProduct(requiredProperty, optionalProperty1, optionalProperty2, optionalProperty3)
        }
    }
}

// ...

val fancyProduct1 = FancyProduct.Builder("required").optionalProperty("optional").build()
val fancyProduct2 = FancyProduct.Builder("required", "optional").build()
val fancyProduct3 = FancyProduct.Builder(optionalProperty = "optional", requiredProperty = "required").build()
```

```kotlin
/*
* DSL (Domain Specific Language) is a domain-dedicated quasi language.
* 
* For such a simple object using DSL doesn’t look very tempting, 
* but if object is a composition of other complex objects - each with its own builder 
* than it start to look interesting.
*/

class DslProduct private constructor(
        val requiredProperty: Any,
        val optionalProperty: Any?
) {
    companion object {
        inline fun dslProduct(requiredProperty: Any, block: Builder.() -> Unit) =
                Builder(requiredProperty)
                        .apply(block)
                        .build()
    }

    class Builder(
            private val requiredProperty: Any,
            private var optionalProperty: Any? = null
    ) {
       fun optionalProperty(value: Any?) = apply { this.optionalProperty = value }
       fun build() = DslProduct(requiredProperty, optionalProperty)
    }
}
```
 


## Factory
*Подбирает возвращаемый имплементатор для заданного интерфейса в зависимости от обстоятельств (сборка/Енвайронмент).*

Just like Builder, the Factory is a creational pattern. It describes an interface used to deliver instances.
What makes it **different from Builder** is that usually none or very few arguments need to be passed. It’s Factory’s job to fulfill all required by the object dependencies.

There are few variants of this pattern:
-   [“typical” Factory Method](https://asvid.github.io/kotlin-factory-method)
-   [Static Factory Method](https://asvid.github.io/kotlin-static-factory-methods)
-   [Abstract Factory](https://asvid.github.io/kotlin-abstract-factory)


## Prototype 
### *Позволяет копировать объекты, не вдаваясь в подробности их реализации.*

## Singltone
### *Блокирует создание нескольких экземпляров класса проверяя существование одного созданного (экземпляра) и отдавая ссылку на него.*


кастомные ViewGroup отвечают за со
Биндинг адаптер
фрагмент должен раздавать область екрана

корутины, 
стейтфлоу.