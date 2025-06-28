
![[Pasted image 20241002124719.png]]

PUSH a new screen  -  операція відкриття нового скріна та додавання його в СТЕК (скрінів)
POP the last screen  -  операція закриття поточного скріна та видалення його зі СТЕКу

![[Pasted image 20241004153407.png]]

![[Pasted image 20241006181155.png]]

## onBackPresed()
### За замовчуванням
	- до Android 11 (включно) арр полностью убивается (удаляется из оперативки)
	- с Android 12 арр сворачивается и живет некоторое время в фоновом режиме

### Custom
```kotlin
@Composable
fun HomeScreen(){

	BackHandler(enabled = counter > 0) { // блок буде працювати лише якщо виконується умова 
											// інакше дефолтна поведінка (згортання у фон)
	
		// призначуємо кастомну дію, напр.:
		counter-- // зменшуємо значення лічильника кліків замість згортання всього додатку.
	}
}
```

**ВАЖНО!!!** 
	- Если написать в коде несколько BackHandler
		  выполняться будет тот, который композиция создала ПОСЛЕДНИМ!
		  напр.: 
```kotlin
@Composable
fun HomeScreen(){

	BackHandler { println("test 222") } // этот обработчик будет проигнорирован

	BackHandler { println("test 111") } // выполнится этот блок
}
```
		
		  ИЛИ: 
		
```kotlin
@Composable
fun HomeScreen(){

	if(counter % 2 == 1){ 
							// данная композиция будет появляться ТОЛЬКО при выполнении условия
							// таким образом BackHandler будет создаваться в дереве композиции 
							// ПОСЛЕ BackHandler { println("test 111") }
							// а значит и выполняться будет 222 (а 111 будет проигнорирован)
							
							// 222 будет выполняться пока будет жива данная композиция !!!
							
		BackHandler { println("test 222") } // этот обработчик будет проигнорирован
		
	}
	
	... 
	
	BackHandler { println("test 111") } // выполнится этот блок
}
```
# NAVIGATION в проекте:

## MainActivity
```kotlin
override fun onCreate(savedInstanceState: Bundle?) {  
    super.onCreate(savedInstanceState)  
    setContent {  // рисует все в левом верхнем углу
        AppCompatTheme {  
            MukundaNavGraph()  
        }  
    }
}
```

## MukundaNavGraph.kt
```kotlin
@Composable
fun MukundaNavGraph(
    modifier: Modifier = Modifier,
    navController: NavHostController = rememberNavController(),
    coroutineScope: CoroutineScope = rememberCoroutineScope(),
    drawerState: DrawerState = rememberDrawerState(initialValue = DrawerValue.Closed),
    startDestination: String = MukundaDestinations.HOME_ROUTE,
    navActions: MukundaNavigationActions = remember(navController) {
        MukundaNavigationActions(navController)
    }
) {
    val currentNavBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = currentNavBackStackEntry?.destination?.route ?: startDestination

    NavHost(
        navController = navController,
        startDestination = startDestination,
        modifier = modifier
    ) {
        composable(
            MukundaDestinations.HOME_ROUTE,
        ) { entry ->
            AppModalDrawer(drawerState, currentRoute, navActions) {
                PicturesScreen() //custom Composable function
            }
        }
        composable(MukundaDestinations.STATISTICS_ROUTE) {
            AppModalDrawer(drawerState, currentRoute, navActions) {
                StatisticsScreen(openDrawer = { coroutineScope.launch { drawerState.open() } })
            }
        }
    }
}
```

#### PicturesScreen.kt
```kotlin 
@Composable  
fun PicturesScreen() {  
	
	val myState = remember{ //теперь, если значение изменится - textView перересуется.
		mutableStateOf(value = "ArtSam World")
	}
	 
	val otherState by remember{ 
		mutableStateOf(false)
	}
	
    Row(modifier = Modifier.fillMaxSize()) {  
        PictureGridItem("\"Ghovardhan\"", "$100.00")  //custom Composable function same as PicturesScreen()
        PictureGridItem("\"Ghovardhan\"", "$100.00")  
        Text(maxLines = 10, text = myState.value)
    }   
}
```
//used in MukundaNavGraph.kt

## MukundaNavigation.kt
```kotlin
/**  
 * Screens used in [MukundaDestinations]  
 */  
private object MukundaScreens {  
    const val PICTURES_SCREEN = "pictures"  
    const val STATISTICS_SCREEN = "statistics"  
    const val PICTURE_DETAIL_SCREEN = "picture"  
}  
  
/**  
 * Arguments used in [MukundaDestinations] routes */object MukundaDestinationsArgs {  
    const val PICTURE_ID_ARG = "taskId"  
    const val TITLE_ARG = "title"  
}  
  
/**  
 * Destinations used in the [MainActivity]  
 */  
object MukundaDestinations {  
    const val HOME_ROUTE = "$PICTURES_SCREEN?"  
    const val STATISTICS_ROUTE = STATISTICS_SCREEN  
    const val PICTURE_DETAILS_ROUTE = "$PICTURE_DETAIL_SCREEN/{$PICTURE_ID_ARG}"  
}  
  
/**  
 * Models the navigation actions in the app. 
 */
class MukundaNavigationActions(private val navController: NavHostController) {  
  
    fun navigateToTasks(userMessage: Int = 0) {  
        val navigatesFromDrawer = userMessage == 0  
        navController.navigate(PICTURES_SCREEN) {  
            popUpTo(navController.graph.findStartDestination().id) {  
                inclusive = !navigatesFromDrawer  
                saveState = navigatesFromDrawer  
            }  
            launchSingleTop = true  
            restoreState = navigatesFromDrawer  
        }  
    }  
  
    fun navigateToStatistics() {  
        navController.navigate(MukundaDestinations.STATISTICS_ROUTE) {  
            // Pop up to the start destination of the graph to  
            // avoid building up a large stack of destinations            // on the back stack as users select items            popUpTo(navController.graph.findStartDestination().id) {  
                saveState = true  
            }  
            // Avoid multiple copies of the same destination when  
            // reselecting the same item            launchSingleTop = true  
            // Restore state when reselecting a previously selected item  
            restoreState = true  
        }  
    }  
  
    fun navigateToPictureDetails(taskId: String) {  
        navController.navigate("$PICTURE_DETAIL_SCREEN/$taskId")  
    }  
}
```

