# app_pasajero_ns

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Generar Hash

Para que nuevos developers puedan usar Facebook Login deben mostrar su hash mediante este código
https://gist.github.com/Adrek/05621dcab33b2f83a319acc19d63f56e

## Error nuevo en el gradle para version de 8.1.2

Ir a la dependencia y en la carpeta sms_autofill en su archivo build.gradle

agregar lo siguiente
android{
...
if (project.android.hasProperty("namespace")) {
namespace 'com.jaumard.smsautofill'
}

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    ...

}
lo mismo con flutter_phone

if (project.android.hasProperty("namespace")) {
namespace 'com.jaumard.flutterphonedirectcaller'
}

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
