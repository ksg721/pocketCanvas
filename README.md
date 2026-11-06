# Pocket Canvas

A small Flutter/Dart drawing app for Android and other Flutter platforms.

## Requirements checklist

- **At least one screen:** Complete. The app has a home screen and a drawing screen.
- **User input:** Complete. Users tap buttons and draw with touch or mouse gestures.
- **Display changes after input:** Complete. Strokes appear on the canvas, and colors,
  brush sizes, eraser mode, undo, and clear update the display.
- **Display a picture:** Complete. The drawing screen includes an illustrated picture
  background with a sun and hills.
- **Custom app icon:** Complete. Android uses the Pocket Canvas canvas-and-brush icon
  in `android/app/src/main/res/drawable/ic_pocket_canvas.xml`.
- **Local storage:** Complete. Save and Load store drawing strokes on the device using
  local preferences, and saved work is restored when the drawing screen opens.
- **PNG export:** Complete. The canvas can be rendered as a PNG and shared or saved
  through the device share sheet.
- **Gallery:** Complete. Saved drawings appear in a gallery where they can be opened,
  renamed, or deleted.

## Stretch challenge

Complete: the app incorporates two screens. Tapping **Start drawing** navigates from
the home screen to the drawing screen.

## Run the app

1. Open this folder in Android Studio or VS Code.
2. Select an Android emulator or connected Android phone.
3. Run `flutter pub get`.
4. Run `flutter run`.

The Android application label is **Pocket Canvas** and its launcher icon is configured
in `android/app/src/main/AndroidManifest.xml`.
