
- `val fruits  =  setOf("apple", "banana", "cherry", "cherry")`  // размер будет "3"
- `val fruits  =  linkedSetOf("apple", "banana", "cherry", "cherry")`
- `val fruits  =  sortedSetOf("apple", "banana", "cherry", "cherry")`

- НЕ упорядоченный список (каждый хранит ссылку на соседа)
- Только уникальные елементы
- `fruits.count()`
- `fruits.elementAt(3)`  /  `fruits.elementAtOrNull(3)`  /  `fruits.elementAtOrElse(3){  }`
