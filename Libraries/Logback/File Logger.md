
pom.xml
```xml
<!-- Зависимость Logback -->
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.2.3</version> <!-- Используйте актуальную версию -->
    </dependency>
```

src/main/resources/logback.xml
```kotlin
<configuration>
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/myapp.log</file>
        <encoder>
            <pattern>%date %level [%thread] %logger{10} [%file:%line] %msg%n</pattern>
        </encoder>

        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/myapp.%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>10MB</maxFileSize>  // задаем максимальный размера файла логов в 10 Мб
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
    </appender>

    <root level="debug">
        <appender-ref ref="FILE" />
    </root>
</configuration>
```

В следующей конфигурации:
- `FixedWindowRollingPolicy` настроен так, чтобы использовать только один резервный файл (`logFile.1.log`).
- Когда `logFile.log` достигает размера в 10 МБ, он переименовывается в `logFile.1.log`, и логирование продолжается в новый файл `logFile.log`.
- Это приведет к тому, что старые данные в `logFile.1.log` будут перезаписаны каждый раз, когда основной лог-файл достигнет 10 МБ.

Обратите внимание, что такая конфигурация может не быть оптимальной для важных систем логирования, так как вы рискуете потерять старые данные логов.

```kotlin
<configuration>
    <appender name="ROLLING" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logFile.log</file>
        <encoder>
            <pattern>%date %level [%thread] %logger{10} [%file:%line] %msg%n</pattern>
        </encoder>

        <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
            <fileNamePattern>logFile.%i.log</fileNamePattern>
            <minIndex>1</minIndex>
            <maxIndex>1</maxIndex>
        </rollingPolicy>

        <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
            <maxFileSize>10MB</maxFileSize>
        </triggeringPolicy>
    </appender>

    <root level="debug">
        <appender-ref ref="ROLLING" />
    </root>
</configuration>
```

Main.kt
```kotlin
import org.slf4j.LoggerFactory

fun main() {
    val logger = LoggerFactory.getLogger("MainLogger")
    logger.info("Это сообщение информационного уровня логирования.")
    logger.error("Это сообщение уровня ошибки.")
}
```

