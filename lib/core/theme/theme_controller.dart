import 'package:flutter/material.dart';

/// Central theme helper adhering strictly to system brightness.
/// Automatically detects if the operating system is in Light or Dark mode.
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  ThemeMode get themeMode => ThemeMode.system;

  /// Returns true if the device / operating system is currently in Dark Mode.
  bool isDarkMode(BuildContext context) {
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }
}
