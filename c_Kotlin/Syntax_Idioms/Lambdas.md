## Объявление:
```kotlin
// Unit у лямбды означает void (ничего не возвращает)
fun performWork(param1: String, myLambda: (result: String?) -> Unit) { // void
    // perform some work
    // on finished
    myLambda.invoke("result from network")
  }
```
## Использование: 
```kotlin
performWork("http://...", { result ->  print(result) })
// or
// лямбда вынесена за скобки, т.к. является последним аргументом функции
performWork("http://...") { result -> print(result) }

// скобки можно опустить, если лямбда - единственный аргумент функции
```

https://play.kotlinlang.org/
```korlin
// Lambda training:
fun main() {
   MyClass().log("TAG", "msg as attr")
   
   MyClass().log{ 
       val result = 4 + 5
       "msg $result"
   }
   
   MyClass().log("TAG", { i1, i2 ->
       val res = i1 * i2       // here I describe what to do with i1 and i2
       "mag as fun: res = $res"     // the last line is the "return" object
   })
}

class MyClass {
	
    fun log(tag: String, message: String) {
        println("$tag: $message")
    }
    
	fun log(lambda: () -> String){
        println(lambda.invoke()) // or println("${lambda()}")
    }
	
    fun log(tag: String, message: (i1: Int, i2: Int) -> String) {
        println("$tag: ${message(4,7)}")
    }
}

результаты:
// TAG: msg as attr
// msg 9
// TAG: mag as fun: res = 28
```

[источник](https://habr.com/ru/post/546298/)

#  suspend Лямбда
```kotlin
fun main() {
    lyambdaPrint{ text ->
    	println(text)
    }
}

fun lyambdaPrint(  myBlock: suspend (text:String) -> Unit){
    runBlocking{ myBlock("Any text") } 
}
```

# Лямбда  VS  Ссылка на функцию:
``` kotlin
// code for https://play.kotlinlang.org

								// КНОПКА
class Button(
    private val onClick: () -> Unit
) {
    fun performClick() = onClick()
}

							// Слушатель кнопки
class ButtonClickListenerVar1{
   	fun onClick() {
        println("button has been clicked")
    }
}

class ButtonClickListenerVar2{
    fun onClick(massage: String) {
        println(massage)
    }
}

								// UI фрагмент
class ScreenView{
    lateinit var listener: ButtonClickListenerVar1
// 	lateinit var listener: ButtonClickListenerVar2

    // Var1
//     val button = Button{ listener.onClick() } // передаем лямбда выражение (app works)
    val button = Button(listener::onClick) // передаем ссылку на функцию (listener NPE)
    
    // Var2
//     val button = Button{ listener.onClick("button has been clicked") } // app works
//     val button = Button{ "button has been clicked".let(listener::onClick) } // app works
   
}

fun main() {
    val screenView = ScreenView()
    screenView.listener = ButtonClickListenerVar1()
// 	screenView.listener = ButtonClickListenerVar2()
    screenView.button.performClick()
}
```

### Лямбда:
При использовании лямбды создается анонимный класс `Function0` и в методе `invoke` вызывается код, который мы передали в нашу лямбду. В нашем случае - `listener.onClick()`

``` java
private final Button button = new Button((Function0)(new Function0() {
    public final void invoke() {
       ScreenView.this.getListener().onClick();
    }
}));
```

То есть если мы передаем лямбду, наша переменная `listener` будет использована после имитации нажатия и она уже будет инициализирована.

### Ссылка на функцию (квадроточие):
При использовании ссылки на функцию. Тут также создается анонимный прокси-класс `Function0`, но если посмотреть на метод `invoke()`, то мы заметим, что метод `onClick` вызывается на переменной `this.receiver`. Поле `receiver` принадлежит классу `Function0` и должно проинициализироваться переменной `listener`, но так как переменная `listener` является `lateinit` переменной, то перед инициализацией `receiver`-а происходит проверка переменной `listener` на `null` и выброс ошибки, так как она пока не инициализирована. Поэтому наша программа завершается с ошибкой.

```java
Button var10001 = new Button;
Function0 var10003 = new Function0() {
   public final void invoke() {
      ((ButtonClickListener)this.receiver).onClick();
   }
};
ButtonClickListener var10005 = this.listener;
if (var10005 == null) {
   Intrinsics.throwUninitializedPropertyAccessException("listener");
}

var10003.<init>(var10005);
var10001.<init>((Function0)var10003);
this.button = var10001;
```

То есть разница между лямбдой и ссылкой на функцию заключается в том, что при передаче ссылки на функцию, переменная, на метод которой мы ссылаемся, фиксируется при создании, а не при выполнении, как это происходит при передаче лямбды.

Квадраточие_ - это оператор, а не функция. Никаких аргументов он не принимает. 
У него есть левая часть выражения и правая часть выражения, как у оператора точка, например. 
Оператор точка позволяет получить значение поля, указанного в правой части выражения, класса, указанного в левой - `SomeClass.someField` 
Так же и квадроточие позволяет получить ссылку на метод, указанный в правой части, класса, указанного в левой.  
Компилятор выводит тип ссылки из контекста и приводит её к соответствующему [функциональному интерфейсу](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html). 
В частности метод [forEach](https://docs.oracle.com/javase/8/docs/api/java/lang/Iterable.html#forEach-java.util.function.Consumer-) принимает [Consumer\<? super T\>](https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html), к нему и будет приведена ссылка на метод `println`, возвращаемая выражением `System.out::println`  
На уровне виртуальной машины, как ссылки на методы, так и лямбды - это создаваемые в рантайме прокси-классы. Пример их генерации и композиции вы можете увидеть [здесь](https://ru.stackoverflow.com/a/856524/204271).

[источник](https://bimlibik.github.io/posts/kotlin-lambdas-expressions-and-anonymous-functions/)
## Лямбда  VS  Aнонимные функции:

-   Изначально появилось понятие [**анонимной функции**](https://ru.wikipedia.org/wiki/%D0%90%D0%BD%D0%BE%D0%BD%D0%B8%D0%BC%D0%BD%D0%B0%D1%8F_%D1%84%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D1%8F "ru.wikipedia.org") как функции, у которой нет имени. Такие функции создаются в месте использования, либо присваиваются переменной и потом в нужном месте косвенно вызываются. Хотя в последнем случае функция всё таки получает имя за счет переменной и перестаёт быть анонимной, но тем не менее такой пример использования анонимной функции встречается повсеместно.
    
-   [**Лямбда-выражение**](https://ru.wikipedia.org/wiki/%D0%9B%D1%8F%D0%BC%D0%B1%D0%B4%D0%B0-%D0%B2%D1%8B%D1%80%D0%B0%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5 "ru.wikipedia.org") в общепринятом смысле - это синтаксическая конструкция для объявления анонимной функции. То есть по сути оно позволяет объявлять анонимную функцию в более коротком и читабельном виде.
    
-   В Kotlin же этим понятиям дали несколько иной смысл, по сути поменяли местами. Под **лямбда-выражением** понимается небольшой фрагмент кода, который можно передать другой функции. При этом лямбды чаще всего встречаются и применяются. Анонимная же функция - это другая синтаксическая форма лямбда-выражения, которую добавили для более удобной реализации следующих случаев (они же являются и различиями между лямбдой и анонимной функцией):
    
    -   Необходимость в определении возвращаемого типа. Лямбда-выражение выводит тип возвращаемого значения самостоятельно, а в анонимной функции его можно задать явно. Данный случай использования анонимной функции описан в [официальной документации](https://kotlinlang.org/docs/reference/lambdas.html#anonymous-functions "kotlinlang.org") языка.
        
    -   Второй случай связан с оператором `return`. В лямбда-выражении оператор `return` производит выход из функции, в которой вызывается это лямбда-выражение (т.е. полностью завершает работу этой функции и код, указанный после оператора `return` никогда не выполнится). Чтобы завершить работу только лямбда-выражения, к оператору `return` должна быть добавлена метка, но такой синтаксис считается неуклюжим, потому что может запутать при наличии нескольких выражений `return`.
        
        В анонимной же функции оператор `return` завершает работу самой анонимной функции. К тому же её намного удобнее использовать, когда требуется написать блок кода с несколькими точками выхода. Данное отличие описано в [официальной документации](https://kotlinlang.org/docs/reference/lambdas.html#anonymous-functions), но более понятно объяснено на [stackoverflow](https://stackoverflow.com/a/48112360/13626164 "stackoverflow.com").