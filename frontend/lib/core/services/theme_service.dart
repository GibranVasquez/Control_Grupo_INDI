import 'package:flutter/material.dart';

class ThemeService {
  static final ValueNotifier<ThemeMode> modeNotifier = ValueNotifier(ThemeMode.light);

  static ThemeMode get mode => modeNotifier.value;

  static void toggle() {
    modeNotifier.value = modeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static void setMode(ThemeMode m) {
    modeNotifier.value = m;
  }
}
