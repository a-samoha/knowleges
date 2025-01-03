## Принципы ООП:

1. **_Инкапсуляция_** - запрет на изменение состояния объекта извне 
	(можно только попросить объект изменить свое состояние. 
	Setеры должны проверять валидность)
2. **_Наследование_** - один код используется множество раз. Дочерний класс получает все состояние (методы, поля) родителя.
3. **_Полиморфизм_** - наследника можно использовать как родителя: Object o = new ChildClass()   
- расширяет или переопределяет состояние родителя.
4. **Абстракция** - выносим на более высокий уровень 

## Термины:
1. **Сигнатура** (метода/класса) - все описанное в строке объявления класса: - возвращаемое значение, модификаторы доступа, принимаемые параметры, бросаемые ошибки;
2. **Абстрактный метод** - ЕСТЬ СИГНАТУРА но НЕТ тела
3. **Абстрактный класс** - НЕ МОЖЕТ иметь объектов (его нельзя "материализовать"/создать).  
	- Описывает и поведение и состояние.
	- Обединяет между собой классы, имеющие очень близкую связь, а интерфейс может быть реализован классами, у которых вообще нет ничего общего.
	- Наследоваться можно только от одного класса.
4. **Интерфейс** - описывает только поведение. (Нет "состояния"). 
	- МОЖНО описать поле будущего класса, НЕЛЬЗЯ его тут же инициализировать. МОЖНО использовать гетеры, сеттеры.
	- Классы могут реализовывать сколько угодно интерфейсов, но наследоваться можно только от одного класса.
	- Можно описывать дефолтную реализацию методов.
5. **Переопределение** - изменить тело метода оставив сигнатуру как у родителя.
6. **Перегрузка** - 2 и более методов в одном классе, С РАЗНЫМИ ПАРАМЕТРАМИ (измененные возвращаемый тип, модификаторы доступа и бр. ош. не перегружают)
7. **Инстанциация -** создание объекта(экземпляра) класса: Class a = new Class()

