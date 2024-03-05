# explainer

## HU
Ez az alkalmazás a 20. Neumann Nemzetközi Tehetségkutató Programtermék Versenyre készült.

### Program célja
Az alkalmazás fő célja a diákok tanulási folyamatának megkönnyítése annyira, hogy egy nagyon kevés erőfeszítéssel is könnyen meg tudjanak tanulni egy anyagrészt.

Az applikáció egy szövegfelismerés technológiát használ, amely beolvassa a szöveget. Ezután a felhasználó kérdéseket tehet fel a beszkennelt szövegről, akár megkérheti az applikációt hogy foglalja össze a szöveget, vagy készítsen róla egy kvízt, aminek a segítségével könnyebben értelmezhető, és megtanulható lesz a tananyag.

Az alkalmazás beszélgető felületében beépített gombok vannak, amik megakadályozzák azt hogy a tanulóknak folyamatosan, minden egyes szkennelés után meg kelljen ismételjük önmagukat, így növelve a hatékonyságukat. Ezeket a gombokat a felhasználó nagyon egyszerűen tudja módosítani is saját tetszésére. Az egyik alapvető gomb például a "Kvíz" gomb, amely a beszkennelt szöveg alapján automatikusan kvízt készít a tanulónak, amivel ellenőrizheti a tudását.

### Használati utasítás
Első indítás esetén be kell jelentkezni az applikációba Google-t használva.

Más esetben az alkalmazás elindítása után (Explainer.apk) a kezdőlapon a kívánt szöveget lefotózzuk és kivágjuk, az “Ask questions!” gomb megnyomása után a megjelenő beszélgető ablakban tudunk az alkalmazásban kérdéseket feltenni.
A szövegdoboz felett megjelenő gombok a gyorsgombok. A legbaloldalibb gyorsgomb segítségével be tudunk szkennelni extra szöveget a beszélgetésbe. A többi gyorsgombot tudjuk módosítani.

Ha módosítani szeretnénk a gyorsgombokat, a kezdőlapon a jobb felső gomb megnyomásával megnyitjuk a beállítások fület, ahol az “Edit chat buttons” gomb segítségével megnyitjuk a gyorsgomb módosító ablakot.
Megnyomjuk annak a gombnak a nevét amit módosítani szeretnénk, és az ott megjelenő ablakban tudjuk módosítani a nevét és a parancsát.

Ha ki szeretnénk jelentkezni az alkalmazásból, a beállítások fülben a “Sign out” gombbal megtehetjük.

### Ahhoz, hogy futtassuk a kódot
Kliens oldalon
1. Létre kell hozni egy új Flutter projektet (https://docs.flutter.dev/tools/vs-code)
2. Be kell másolni minden fájlt és mappát a "client" nevű mappából az új Flutter projektbe.
3. Létre kell hozni Firebase-n egy új projektet és hozzá kell csatolni a Flutter projekthez. (FONTOS: ez a Flutter projekt csak akkor működik, ha Firebase-n aktiváltuk a "Blaze" csomagot.) ( https://firebase.google.com/docs/flutter/setup )
4. Futtatni kell a "flutter pub get" parancsot a konzolba
5. A .env-example fájlt ki kell tölteni (Itt kell megszerezni a GOOGLE_CLIENT_ID-t: https://developers.google.com/identity/oauth2/web/guides/get-google-api-clientid )
7. Első futtatás után be kell konfigurálni a SHA-1 kulcsokat a Firebase-n, ahhoz hogy működjön a bejelentkezés. (https://stackoverflow.com/questions/39144629/how-to-add-sha-1-to-android-application)

Szerver oldalon
1. Létre kell hozni egy új Firebase Function projektet ( https://firebase.google.com/docs/functions/get-started?gen=2nd )
2. Be kell másolni minden fájlt és mappát a "functions" nevű mappából az új Firebase Function projektbe.
3. A .env-example fájlt ki kell tölteni ( https://help.openai.com/en/articles/4936850-where-do-i-find-my-openai-api-key )
4. Deploy ( https://firebase.google.com/docs/functions/get-started?gen=2nd#deploy-functions-to-a-production-environment )

## EN
This application was made for the 20th Neumann Nemzetközi Tehetségkutató Programtermék Verseny.

### Purpose of the Program
The main purpose of the application is to facilitate the learning process for students so that they can easily learn a subject with minimal effort.

The application utilizes text recognition technology to scan text. Afterwards, the user can ask questions about the scanned text, request a summary of the text, or create a quiz from it to make the material more comprehensible and easier to learn.

The built-in buttons in the chat interface of the application prevent students from having to repeat themselves after each scan, thus increasing their efficiency. Users can easily customize these buttons according to their preferences. One fundamental button, for example, is the "Quiz" button, which automatically generates a quiz based on the scanned text for the student to test their knowledge.

### User Instructions
Upon first launch, users need to sign in to the application using Google.

Subsequently, after launching the application (Explainer.apk), on the home screen, users capture and crop the desired text, then press the "Ask questions!" button to ask questions in the chat window.
The buttons appearing above the text box are quick buttons. Using the leftmost quick button, users can scan additional text into the conversation. Other quick buttons can be customized.

To modify the quick buttons, users open the settings tab by pressing the top right button on the home screen, where they can open the button editor window with the "Edit chat buttons" button.
Pressing the name of the button they want to modify, users can change its name and command in the window that appears.

To log out of the application, users can use the "Sign out" button in the settings tab.

### To run the code
Client-side
1. You need to create a new Flutter project (https://docs.flutter.dev/tools/vs-code)
2. Copy all files and folders from the "client" directory into the new Flutter project.
3. You need to create a new project on Firebase and attach it to the Flutter project. (IMPORTANT: This Flutter project only works if you have activated the "Blaze" package on Firebase.) (https://firebase.google.com/docs/flutter/setup)
4. Run the "flutter pub get" command in the console.
5. Fill out the .env-example file (Here you need to obtain the GOOGLE_CLIENT_ID: https://developers.google.com/identity/oauth2/web/guides/get-google-api-clientid)
6. After the first run, you need to configure the SHA-1 keys on Firebase for the login to work. (https://stackoverflow.com/questions/39144629/how-to-add-sha-1-to-android-application)

Server-side
1. You need to create a new Firebase Function project (https://firebase.google.com/docs/functions/get-started?gen=2nd)
2. Copy all files and folders from the "functions" directory into the new Firebase Function project.
3. Deploy (https://firebase.google.com/docs/functions/get-started?gen=2nd#deploy-functions-to-a-production-environment)
