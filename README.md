# Gravity Falls · Archivo 03

Aplicación móvil desarrollada en Flutter para la Tarea 5 de Introducción al Desarrollo de Aplicaciones Móviles del ITLA.

La app presenta el mundo de *Gravity Falls* en español mediante seis áreas: portada, personajes, momentos con video integrado, información de la serie, un minijuego de exploración y una ficha de contacto.

## Funciones

- Portada con presentación de la serie, accesos rápidos y momentos destacados.
- Fichas interactivas de Dipper, Mabel y Stan con imagen, descripción y actor de voz.
- Tres momentos con sinopsis y reproductor de video integrado en la app. Los clips se cargan desde el canal oficial de Disney en YouTube y requieren conexión a internet.
- Información de la serie, su creador, año de estreno y temporadas.
- Minijuego de exploración: reúne tres páginas, evita a Bill y vuelve a la Cabaña del Misterio antes de que termine el tiempo.
- Sección de contacto con foto, nombre, matrícula y perfil de GitHub.

## Herramientas

- Flutter y Dart para la aplicación.
- Android Studio, Android SDK y Gradle para compilar el APK.
- `youtube_player_iframe` para reproducir los clips en una vista integrada.
- `url_launcher` para abrir el perfil de GitHub.

## Ejecutar en Android

1. Instala Flutter y configura Android Studio con el Android SDK.
2. Desde la carpeta del proyecto, ejecuta `flutter pub get`.
3. Conecta un dispositivo Android o inicia un emulador.
4. Ejecuta `flutter run`.

Para generar el APK de entrega:

```powershell
flutter build apk --release
```

El archivo se genera en `build/app/outputs/flutter-apk/app-release.apk`.

## Fuentes y créditos

- *Gravity Falls* y sus personajes son propiedad de Disney. Consulta los enlaces y créditos de imágenes y videos en [docs/RECURSOS.md](docs/RECURSOS.md).
- Este es un proyecto educativo de estudiante; no es una aplicación oficial de Disney.
