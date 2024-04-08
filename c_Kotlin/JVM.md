
- [компиляция и выполнение](https://javarush.com/groups/posts/2256-kompiljacija-i-ispolnenie-java-prilozheniy-pod-kapotom)

**Компиляция** — трансляция программы, составленной на исходном языке высокого уровня, в эквивалентную программу на низкоуровневом языке, близком машинному коду.

**Интерпретация** — пооператорный (покомандный, построчный) анализ, обработка и тут же выполнение исходной программы или запроса (в отличие от компиляции, при которой программа транслируется без её выполнения).

```java
package ru.javarush;

class Calculator {
    public static void main(String[] args){
        int a = Integer.valueOf(args[0]);
        int b = Integer.valueOf(args[1]);
		
        System.out.println(a + b);
    }
}
```

- $ `javac Calculator.java`
- $ `java Calculator 1 2`

- $ `javac -d bin src/ru/javarush/Calculator.java`
- $ `java -classpath ./bin ru.javarush.Calculator 1 2`
