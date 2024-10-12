#architecture

[Android Developers MAD Skills "Architecture"]([https://goo.gle/mad-architecture](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa2F0bGM3ZDRuRG05Z3pWbHZ0SlptUGNySmM4UXxBQ3Jtc0tsZG01TW01T2E0OV9sX2FReDF4Y1F6SWZ2NE1pQ24taVpURHhJTGdaWGJGUjlvOGtYb3J6cFlMSFBKaS1WUWZIVXRPM09LdmI3bFNZdUphUmJFWU1hbTN5bVZMbm1MaHFOdW05YkU2OVBpYjZoMy1DVQ&q=https%3A%2F%2Fgoo.gle%2Fmad-architecture&v=r5AseKQh2ZE))
[medium article](https://anmolsehgal.medium.com/clean-architecture-fef10b093ad0)

# Clean architecture
###### [[aPresentation (UI Layer)]]
- *The role of the UI Layer is to display the application data on the screen (**visual representation of the application state**).*
-  Whenever the data changes, either due to user interaction (like pressing a button) or external input (like a network response), 
	**the UI should update to reflect** those **changes**. 
- *The UI layer is the pipeline that **converts** application **data** changes **to a form that the UI can present** and then displays it.*

###### [[aDomain (optional Layer)]]
- The domain layer is responsible for **encapsulating** complex **business logic**.
		or simple business logic that is reused by multiple ViewModels.
- It **avoids code duplication**.
- It avoids large classes by allowing you to **split responsibilities**.
- To keep these classes simple and lightweight, each use case should only have responsibility over a single functionality, 
		and **they should not contain mutable data**. You should instead handle mutable data in your UI or data layers.

###### [[aData (Layer)]]
- **Determine how application data must be created, stored, and changed**.
-  You should **create a repository class for each different type of data**: 
		e.g. `MoviesRepository` and `PaymentsRepository`

###### General best practices
- Don't store data in app components.
- Persist as much relevant and fresh data as possible.
- Create well-defined boundaries of responsibility between various modules in your app.
- Focus on the unique core of your app so it stands out from other apps.
- Consider how to make each part of your app testable in isolation.

[[Patterns (MVVM, MVP, MVC)]]

[[Порождающие (Builder, Factory, Prototype, Singltone,)]]

[[Multi modules]]

сущность описывающая унарные оперции из БЛ зависит от репоз и передает данные на UI 
обработка- хранение актуального UI Strate

