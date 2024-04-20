
[10 Developer options you NEED to enable on your Android!](https://www.google.com/search?q=become+a+developer+android+device&client=ubuntu&hs=Dz3&channel=fs&sxsrf=AB5stBisQEz8ioZ3RaVFH3uGgJa5wn-dWg%3A1691333302133&ei=trLPZLPiB7eowPAPoeab-Ag&ved=0ahUKEwizla7Fo8iAAxU3FBAIHSHzBo8Q4dUDCA4&uact=5&oq=become+a+developer+android+device&gs_lp=Egxnd3Mtd2l6LXNlcnAiIWJlY29tZSBhIGRldmVsb3BlciBhbmRyb2lkIGRldmljZTIFECEYoAEyBRAhGKABMggQIRgWGB4YHUjtwQFQ8ARY6cABcAR4AZABBZgBswGgAaUoqgEFMjQuMja4AQPIAQD4AQGoAhTCAgoQABhHGNYEGLADwgIKEAAYigUYsAMYQ8ICBxAAGIoFGEPCAgUQABiABMICChAAGIAEGBQYhwLCAgYQABgWGB7CAgcQIxjqAhgnwgIQEAAYigUY6gIYtAIYQ9gBAcICBxAjGIoFGCfCAgQQIxgnwgILEC4YgAQYxwEY0QPCAgUQLhiABMICDRAuGIoFGMcBGNEDGEPCAgcQLhiKBRhDwgIcEC4YigUYxwEY0QMYQxiXBRjcBBjeBBjgBNgBAsICBxAAGIAEGArCAggQABiABBjLAcICCBAuGIAEGMsBwgIIEAAYFhgeGA_CAgoQIRgWGB4YDxgdwgIHECEYoAEYCuIDBBgAIEGIBgGQBgq6BgYIARABGAG6BgYIAhABGBQ&sclient=gws-wiz-serp#fpstate=ive&vld=cid:af829914,vid:zkVX040Hsj8,st:22)

На первом запуске студия предлагает настроить:
[Configure hardware acceleration for the Android Emulator](https://developer.android.com/studio/run/emulator-acceleration?utm_source=android-studio#vm-linux)

Если появляется ошибка:
"Waiting for all target devices to come online android studio"
- проверяем, что среди устройств появляется emulator-5554
- отменяем запуск, который ждет "устройство онлайн"
- запускаем (зеленый треугольник) арр на emulator-5554

["Performance is impacted. to disable check bootloader"](https://stackoverflow.com/questions/60388041/serial-console-enabled-performance-is-impacted-to-disable-check-bootloader)
- не пробовал это проделывать
