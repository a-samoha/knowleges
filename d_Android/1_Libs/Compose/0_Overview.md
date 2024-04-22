
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