# FocusTrack Móvil

Práctica Guiada 13 - IF0009 Desarrollo de Software IV (UCR, Sede del Atlántico).

## Primer uso

Este paquete contiene el código Dart, `pubspec.yaml`, pruebas y configuración.
Las carpetas nativas `android/` e `ios/` se generan con Flutter. Desde esta carpeta ejecute:

    flutter create --platforms=android,ios .
    flutter pub get
    flutter analyze
    flutter test
    flutter run

`flutter create .` NO sobrescribe `lib/main.dart` ni `pubspec.yaml` si ya existen
(si pregunta o reemplaza `test/widget_test.dart`, restáurelo desde este zip).
