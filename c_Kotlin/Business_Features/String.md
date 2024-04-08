
[interesting extension fun for ignorCase](https://stackoverflow.com/a/76630172)

### Удалить пробелы 
```kotlin
val originalString = "Это пример строки с пробелами"
val stringWithoutSpaces = originalString.replace(" ", "")
println(stringWithoutSpaces) // Выведет: "Этопримерстрокиспробелами"

// `\\s+` - это регулярное выражение, которое соответствует одному или нескольким пробельным символам.
val stringWithoutWhitespaces = originalString.replace("\\s+".toRegex(), "")
```



