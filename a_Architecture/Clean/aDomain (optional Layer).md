Відповідає на питання "**Що** робить арр?":
- Це називається Business logic
- Оскільки сама Business logic додатку змінюється рідко, а її фактична реалізація може змінюватись дуже часто (напр.: "Отримати дані про погоду" це Business logic, а **Як** її отримувати, з інтернету, чи з бд на телефоні, чи яка ліба буде для цього використана) то Domain Layer не має нічого знати про реалізації (ні про data ні про presentation)
- тобто, Domain Layer має бути jvm модулем який нічого ні про кого не знає (НЕ містить залежностей від Android, Data, Presentation)