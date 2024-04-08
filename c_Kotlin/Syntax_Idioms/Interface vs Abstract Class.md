
https://play.kotlinlang.org/
```korlin
fun main() {
    println("Hello, world!!!")
    
    val dog = Dog(17)
    dog.voice()
    dog.move()
    dog.eat()
}

interface LivingBeing{
    val mouth: String
    private fun breath(){ println("test I'm breathing") }
    fun move()
}

abstract class Animal(customAge: Int? = null){
    val age: Int = customAge ?: 13
    fun eat() = println("test I eat meat")
    abstract fun voice()
}

class Dog(customAge: Int? = null): Animal(customAge), LivingBeing{    
    override fun voice() = println("test I'm $age")
    
    override val mouth = "default"
    override fun move() = println("run")
}
```
