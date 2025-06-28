
[Roman Andrushchenko](https://www.youtube.com/watch?v=lfKNyC_3Bjc&list=PLRmiL0mct8WkFdcvOCi06_64_ec3B2jvx&index=9&pp=iAQB)
### Композиция (Composition) - как объект
	- Композиция ОТЛИЧАЕТСЯ от композабл функций -> `Composition != @Composable fun`
	- это рекурсивное дерево, каждый елемент которого есть таким же деревом
	- У каждого Composition свой Lifecycle (вложенные могут умирать раньше)
	- создается и обслуживается композабл функциями. *Сами функции выполняются при каждой рекомпозиции, НО*
	- под капотом проверяется кеш  uiState и перерис. только те, в которых произошли изменения uiState.
	- remember{} кеширует данные ровно пока, живет Композиция в которой он вызвается
	

![[composition.png]]

### Lifecycle - Жизненный цикл объекта композиции:
	- Инициализация (Создание)
	- Рекомпозиция (посредством композабл функции)
	- Удаление

напр.:  
		для btn "Increment" **композиция** выполнится 1 раз:
			- Создание объекта композиции + @Composable function
		а для текста "кол. кликов" сначала 1 раз тоже  выполнится **композиция**: 
			- Создание объекта композиции + @Composable function
	а потом (при каждой смене стейта хранящего инфу про кол. кликов) будет выполняться только **РЕКОМПОЗИЦИЯ**: 
			- @Composable function
	
(типа: onCreate, onUpdate, onDestroy)

![[Pasted image 20231220190406.png]]
#### Логирование Lifecycle
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

#### 1. Инициализация 
- **Инициализация (Создание состояний и подписок)**: 
	- `Превращает @Composables в дерево Композиций (набор UI элементов).`
	- `Cтроит родительские отношения между Композициями`
	- `Устанавливаются состояния, объекты и подписки.`
	- Инициализируются паттерны, `remember` или `LaunchedEffect`

#### 2. Recomposition (Рекомпозиция)
- **Реакция на изменения**: 
	Когда state, от которого зависит `@Composable`, изменяется - функция повторно вызывается с новыми данными.
- **Минимальные изменения**: 
	Compose оптимизирует этот процесс, перекомпонуя только те части интерфейса, которые зависят от изменившегося state.
	
#### 3. Disposal (Уничтожение)
- **Очистка**: Когда `@Composable` функция удаляется из композиции, например, при переходе на другой экран, Compose выполняет очистку. Это включает отмену всех подписок и корутин, запущенных внутри функции.
- **Эффекты уничтожения**: Использование `DisposableEffect` позволяет определить код, который должен быть выполнен при удалении компонента из композиции, что аналогично методу `onDestroy` в жизненном цикле Activity или Fragment.
----------------------------------------------------------------------------
**Интеграция с Lifecycle**: Хотя сами `@Composable` функции не имеют жизненного цикла, они могут быть осведомлены о жизненном цикле внешних контейнеров (например, активити или фрагментов) через специальные API, такие как `LifecycleOwnerAmbient`.

### Rander Phases
**ВАЖНО!**   Можно настроить, что любая из фаз будут пропущены.
 ![[Compose Phases.png]]

#### 1. Composition/Recomposition Phase - (ЧТО отрисовать?)
  - **Создание Композиции** (древовидной структуры данных) посредством композабл функций
	  -`Выполняется при каждом изменении любого входящего параметра, напр.:` 
		Text(text = uistate.title, fontSize = 60.sp)  -  при смене text или fontSize -> рекомпозиция.
  
#### 2. Layout Phase (Расположение элементов.. ГДЕ отрисовыват?)
	`.offset{}  // выполняется на LayoutPhase фазе `
	
- **Измерение (Расчет размеров)**: 
	`- после композиции или рекомпозиции, рассчитываем размеры и расположение` 
	`- старается все делать за 1 проход`
	`- Компоновщики спрашивают у вложеных компонентов их размеры`
	`- Компоненты напр. Text, Spaser измеряют себя сами`
- **Размещение (Определение позиции)**: 
	`- Каждый компонент в дереве UI получает конкретную позицию на экране.`
	
**ВАЖНО!**   ЕСЛИ  Layout Phase  НЕ  зависит от State  ->  эта фаза будет ПРОПУЩЕНА

#### 3. Drawing Phase - (КАК отрисовать?)
	`.drawBehind{}  // выполняется на DrawingPhase фазе `
	
- **Рендеринг**: 
	Когда все размеры и позиции определены, 
	Compose отрисовывает компоненты на экране.
	Используется графический движок устройства.
	
**ВАЖНО!** (из GPT4)
**Макетирование и отрисовка следуют за рекомпозицией и связаны с ней (как ее последствия), 
но являются отдельными этапами в процессе рендеринга.
Каждая фаза может быть пропущена, напр.: (код ниже)**
- `дерево композиций не изменилось,`
- `и внешний вид для Text(...) не изменился,` 
- `нужно поменять только местоположение елемента Text ->` 
- `выполнится только Layout Phase (Composition Phase и Drawing Phase НЕ выполнятся)`

```kotlin
// в данном кейсе 
// Recomposition Phase НЕ выполняется (только 1 раз композиция)
// НО Layout Phase выполняется на каждое изменение "counterValue"

// счетчик кликов на кнопку
val originState by remember{ mutableStateOf(0) } 

// перемещается на каждый третий клик по кнопке.
Text(
	text = "test",
	modifier = Modifier
		
		// отвечает за позицию вьюхи
		// .offset() будет инициировать все 3 фазы
		.offset(y = 20 * (originState/3))
		
		// отвечает за позицию вьюхи
		// .offset{} выполняется на LayoutPhase фазе
		//  поэтому Composition Phase и Drawing Phase пропускаются
!!! ->	.offset{ IntOffset(x=0, y = 20 * (originState/3)) }

		// отвечает за отрисовку вьюхи
		// .drawBehind{} выполняется на DrawingPhase фазе
!!!	->	.drawBehind{ ... }  
)
```

### derivedStateOf{} 
**ВАЖНО!**	 - используем когда нужно реагировать **НЕ** на все обновления State
	- НАПР.: "**Активировать кнопку LOG IN только при вводе валидного логина и пароля**" (проверяя при этом каждый ввод)
	- это посредник между родительским стейтом и одной из фаз рендеринга

**БЕЗ** derivedStateOf:
```kotlin
// в данном кейсе 
// originState меняется при каждом клике
// Layout Phase выполняется (1 раз в 3 смены originState)
// HO Recomposition Phase ТАКЖЕ выполняется
//       при каждом изменении "transformedValue" (1 раз в 3 смены originState)
val transformedValue = counterValue/3

Text(
	text = "test",
	modifier = Modifier
		// .offset{} выполняется на LayoutPhase фазе
		//  поэтому Composition Phase и Drawing Phase пропускаются
		.offset{ IntOffset(x=0, y = 20 * transformedValue) }
)```

**используем** derivedStateOf:
```kotlin
// в данном кейсе 
// Layout Phase выполняется (1 раз в 3 смены originState)
// а Recomposition Phase НЕ выполняется (только 1 раз композиция)
val transformedValue by remember{
	derivedStateOf{ originState/3 }
}

Text(
	text = "test",
	modifier = Modifier
		// .offset{} выполняется на LayoutPhase фазе
		//  поэтому Composition Phase и Drawing Phase пропускаются
		.offset{ IntOffset(x=0, y = 20 * transformedValue) }
)
```

![[Pasted image 20231221180044.png]]
