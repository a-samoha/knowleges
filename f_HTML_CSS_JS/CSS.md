
# CSS (Cascading Style Sheets, каскадні таблиці стилів)

![[Pasted image 20241014101418.png]]

**Селектор** — вказує, до яких елементів розмітки застосувати стилі
**Оголошень** може бути безліч 
	- розділяються ";"
	- порядок НЕ важливий

[набір зарезервованих імен](https://htmlcolorcodes.com/color-names/) для атребуту color

[margin](https://developer.mozilla.org/en-US/docs/Web/CSS/margin)

### Селектор за типом елемента (X)
```css
a { color: rgb(255, 0, 0); } /* можна використовувати значення від 0 до 255 АБО відсотки 45% */
h1 { color: rgb(255, 0, 0, 0.3); } /* 0.3 вказує прозорість */
p { color: #ff0000;         } /* Hexadecimal використовує 16 символів: 0-9, а-f. Напр.: 00 (0%) ff (100%) */ 
```

### Селектор ідентифікатора (#X)
```html
<h2 id="title">Привіт, я Mango.</h2>
```

```css 
/* Застосовується до тегу з id = title */
#title {
  color: skyblue;
}
```

### Селектор класу (.X)
```html
<h2 class="title">Привіт, я Mango.</h2>
<p class="text">
  Вітаю вас на моїй особистій сторінці. Тут можна подивитися
  <a class="link" href="">проєкти</a>.
</p>

<h2>Цей заголовок не буде стилізовано</h2>
```

```css 
/* Застосовується до всіх тегів з класом title */
.title {
  color: skyblue;
}

/* Застосовується до всіх тегів із класом text */
.text {
  color: brown;
}

/* Застосовується до всіх тегів з класом link */
.link {
	color: tomato;
}
```

Snake Case  -  number_of_donuts
Camel Case  -  numberOfDonuts
Pascal Case  -  NumberOfDonuts
Kebab Case  -  number-of-donuts
**ʼВАЖЛИВО** В імені класу використовуються лише Kebab Case

### Селектор для нащадків (X Y)
```html
<ul class="social-links">
  <li><a href="">Twitter</a></li>c
</ul>
```

```css
/* Застосовується до посилань, які лежать усередині неупорядкованих списків */
ul a {
  color: tomato;
}

/* Застосовується лише до посилань, що лежать усередині тега з класом social-links */
.social-links a {
  color: tomato;
}

/* Застосовується лише до заголовків з класом title, що лежать усередині тега з класом club-list */
.club-list .title {
  color: #4caf50;
}
```

### Селектор для дочірніх елем. (X > Y)

«**Дітьми**» або «**дочірніми елементами**» в HTML називаються елементи, що безпосередньо вкладені в «батьківський» елемент. Елементи, що знаходяться на 2-му і глибших рівнях вкладеності, «дітьми» не є — це діти дітей, тобто «**нащадки**».
```html
<ul class="menu">
  <li>
    Комп'ютери та комплектуючі
    <ul class="submenu">
      <li>Процесори</li>
      <li>Монітори</li>
      <li>Відеокарти</li>
    </ul>
  </li>
  <li>
    Побутова техніка
    <ul class="submenu">
      <li>Холодильники</li>
      <li>Телевізори</li>
      <li>Пральні машини</li>
    </ul>
  </li>
</ul>
```

```css
/* ✅ вибирає лише ті `<li>`, які є дітьми (перша вкладеність) у списку `ul.menu`. */
.menu > li {
  border: 1px solid tomato;
}
```

### Селектори стану (X:state)
States (псевдокласси):
	- [:hover](https://developer.mozilla.org/ru/docs/Web/CSS/:hover) - активується, коли курсор миші знаходиться в межах елемента
	- [:active](https://css.in.ua/css/selector/activev) - активується, коли навести курсор миші + клік (в основному для посилань та кнопок)
	- [:focus]() - Активується, коли елемент (посилання, кнопка, поле форми) отримує фокус (при натисканні мишкою або при навігації по сторінці (клавішею `Tab`).
```html
<p>
  Відмінну шпаргалку за тегами можна знайти
  <a class="link" href="https://htmlreference.io">за посиланням</a>.
</p>

<ul class="social-links">
  <li><a class="link" href="https://twitter.com">Twitter</a></li>
</ul>
```

```css
.link {
  color: teal;
}

/* активується, коли курсор миші знаходиться в межах елемента */
.link:hover {
  color: tomato;
}

.social-links .link {
  color: teal;
}

/* активується, коли курсор миші знаходиться в межах елемента */
/* або елемент активований клавішею `Tab` */
.social-links .link:hover,v
.social-links .link:focus {
  color: tomato;
}
```

### Cпецифічність
![[Pasted image 20241014144556.png]]

```css
/* Специфічність - 0 0 0 1 */
a {
  color: green;
}

/* Специфічність - 0 0 1 0 */
.post-link {
  color: orange;
}

/* Специфічність - 0 0 1 1 */
a .post-link {  // <a href="#">   <span class="post-link">This is a link</span>   </a>
  color: orange;
}

/* Специфічність - 0 0 1 1 */
a.post-link {  // <a href="#" class="post-link">  This is a link  </a>
  color: blue;
}

/* Специфічність - 0 0 2 0 */
.post > .post-link {
  color: red;
}

/* ✅ Специфічність - 0 0 2 1 */
.post > a.post-link {
  color: brown;
}
```

Насильно підняти Специфічність можна за допомогою `!important`
Єдиний прийнятний випадок використання `!important` це якщо немає прямого доступу до файлу зі стилями, наприклад, стиль з бібліотеки.
```css
p {
  color: orange !important;
}

p#text-id.text {
  color: blue;
}
```

### Inherit
Значення `inherit` повідомляє браузеру, що елементу необхідно успадкувати значення властивості від батьківського елемента.
Але для посилань (тег 'а') зазвичай використовується ключове слово `currentColor`

### Font
`font-weight: 400;` Ключові слова прив'язані до цифр,  `normal` — це `400`, а `bold` — `700`.
`text-decoration: none | underline | line-through | overline`
`text-transform: none | uppercase | lowercase | capitalize`
`text-align: left | right | center | justify`
`line-height: множник | 24px | відсотки | normal | inherit` ІНТЕРЛІНЬЯЖ  -  висота рядка
`letter-spacing: 5px | normal | inherit`
`text-indent: значення | відсотки | inherit`
`text-shadow: 2px(зміщення по x) 2px(зміщення по y) 4px(радіус розмиття) #212121(колір)`

```css
.text {
  font-size: 16px;
  line-height: 1.5; /* ІНТЕРЛІНЬЯЖ (знач 24рх) визначений множником від розміру шрифту: 16 * 1.5 = 24 */
}
```

[**Google Fonts**](https://fonts.google.com/) — це сховище з безліччю безкоштовних шрифтів.
![[Pasted image 20241014165339.png]]

Усі відомі людству символи (літери, математичні знаки тощо) 
зібрані та описані стандартом **Unicode**, у якому кожен символ 
має ім'я (наприклад, «latin capital letter a») та код (code point) — число від `0` до `10FFFF`.

### Нормалізація стилів
```html
<head>
  <!-- Спочатку підключаємо віддалений нормалізатор -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/modern-normalize@2.0.0/modern-normalize.min.css">
  <!-- Потім ваші стилі -->
  <link rel="stylesheet" href="./css/styles.css" />
</head>
```