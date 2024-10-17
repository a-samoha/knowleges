
# HTML (HyperText Markup Language, мова розмітки гіпертексту)

**VSCode** - основний редактор
**Плагіни** для VSCode: 
- "prettier", 
- "Live server", 
- "Auto Save on Window Change"
- VSCode команди: 
	- `lorem10 + Tab` - створить масив тексту з 10 слів. 
	- `! + Enter` - створить скелет сторінки html
	- `ul>li*4>h3+p`  -  створить розмітку (дерево тегів описаних у формулі).

- Специфікація [HTML Living Standard (HTML5)](https://html.spec.whatwg.org/multipage/)  — головний документ, що описує стандарти, можливості та майбутній розвиток мови HTML.
- [Довідник HTML-тегів](https://htmlreference.io/) — довідник тегів, що зручно мати під рукою як шпаргалку, або на випадок роботи із специфічними тегами.
- [Code Guide](https://codeguide.co/) - Standards for developing consistent, flexible, and sustainable HTML and CSS.
- [Перевірити можливість вкладати теги:](https://caninclude.glitch.me/)
- Є [офіційна сторінка W3C](https://html.spec.whatwg.org/multipage/named-characters.html) та [сервіс від Toptal](https://www.toptal.com/designers/htmlarrows/symbols/), де можна знайти мнемоніку для будь-якого символу.
- [Squoosh](https://squoosh.app/) — зменшення ваги картинок .jpg (видалення зайвих даних, зменшення якості без втрат для зображення)
- [Валідатор коду HTML сторінки](https://validator.w3.org/nu/) — перевірка синтаксису (семантика НЕ перевіряється)

**СЕМАНТИКА**  -  правило використання тегів саме за їх призначенням


![[Pasted image 20241006213325.png]]

![[Pasted image 20241007211839.png]]

![[Pasted image 20241008212846.png]]

### Тег `<a>` (Посилання)
- використовуй, коли треба перезавантажити поточну сторінку, чи перейти на іншу
```html
<!-- "ЯКІР" - посилання яке веде у будь яке місце на ПОТОЧНІЙ сторінці -->
<a href="#">Lorem ipsum</a> <!-- символ "#" є заглушкою. Каже браузеру НЕ перезавантажуватись -->

<a href="https://goo.gl/maps/qBnEfK5AingPLZgb9" target="_self">PF Power Zone</a> <!-- "_self" каже перезавантижити в поточній вкладці -->

<a href="https://goo.gl/maps/qBnEfK5AingPLZgb9" target="_blank"> <!-- "_blank" каже відкрити в НОВІЙ вкладці -->
      <img 
	      src="https://ac.goit.global/fullstack/html-css-v2/module-1/autocheck/B031.jpg" 
	      alt="PF Power Zone. A modern gym equipped with treadmills." 
	      width="320">
	      Також тут може бути текст
</a>

<address>
  Call us: <a href="tel:+070174069900">+070174069900</a><br />
  Email us: <a href="mailto:fatnessescape@doit.com">fatnessescape@doit.com</a>
</address>

<a 
   href="https://ac.goit.global/fullstack/html-css-v2/module-1/autocheck/Build-Muscles.pdf" 
   download="build-muscles-plan">Download «Build Muscles» training plan</a>
```

### Тег `<button>` (Кнопка)
- використовуй, коли НЕ треба перезавантаження. Напр. відкрити модальне вікно
```html
<button type="submit" >Open Form</button> <!-- type="submit" іде по замовчуванню та каже, що треба надіслати дані на сервер-->
<button type="button" >Open Form</button> <!-- type="button" каже НЕ намагатись надіслати дані на сервер -->
```
