# explainer
## HU
Ez az alkalmazás a 20. Neumann Nemzetközi Tehetségkutató Programtermék Versenyre készült.

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
