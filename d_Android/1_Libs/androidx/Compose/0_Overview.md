
[YouTube курс по Compose](https://youtu.be/z24DOCcqzaU?si=83M4xkSnDKO73rOy)

- Jetpack Compose, 
- Flatter, 
- React Native, React Redax
- MVI, 
- RecyclerView + ListAdapter + DiffUtil

Oснованы на одних и тех же принципах:
- Reactive Programming
- UI depends on State (розделение ui (логики отображения) от state (логики хранения данных))
- immutability (ТОЛЬКО val и .copy(). Для var можно сделать делегат, гетеры&сеттеры, или реактивно, НО работать не будет.)
- Pure Functions (для ui рекомпозиции)
	- Stable and predictable results
	- Easy to optimize
	- Eazy to cover with tests

## Композиция (Composition)
	- Композиция ОТЛИЧАЕТСЯ от композабл функций
	- Композиция это объект который создается и обслуживается композабл функциями
	- Композиция это рекурсивное дерево, каждый елемент которого есть таким же деревом:

![[composition.png]]

Lifecycle - Жизненный цикл объекта композиции:
	- Вход (Создание)
	- Рекомпозиция (посредством композабл функции)
	- Удаление

Логирование Lifecycle
```kotlin
private const val TAG = "CompositionLifecycle"  
  
@Composable  
fun logCompositionLifecycle(name: String): Any = remember {  
    LifecycleRememberObserver(name)  
}  
  
private class LifecycleRememberObserver(  
    private val name: String  
): RememberObserver {  
      
    override fun onAbandoned() {  
        Log.d(TAG, "$name.onEnter")  
    }  
  
    override fun onForgotten() {  
        Log.d(TAG, "$name.onLeave")  
    }  
  
    override fun onRemembered() = Unit  
}
```