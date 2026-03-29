import 'package:flutter/material.dart';
import '../features/exercises/data/prefs_service.dart';
import 'app_theme.dart';

class ThemeController extends ChangeNotifier {
  final PrefsService _prefs;
  late ThemeMode _themeMode;
  late AccentColor _accentColor;

  ThemeController(this._prefs) {
    _themeMode = _parseMode(_prefs.themeMode);
    _accentColor = _parseAccent(_prefs.accentColor);
  }

  ThemeMode get themeMode => _themeMode;
  AccentColor get accentColor => _accentColor;

  bool isDark(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setThemeMode(_modeToStr(mode));
    notifyListeners();
  }

  Future<void> setAccentColor(AccentColor color) async {
    if (_accentColor == color) return;
    _accentColor = color;
    await _prefs.setAccentColor(_accentToStr(color));
    notifyListeners();
  }

  static ThemeMode _parseMode(String s) => switch (s) { 'dark' => ThemeMode.dark, 'light' => ThemeMode.light, _ => ThemeMode.system };
  static String _modeToStr(ThemeMode m) => switch (m) { ThemeMode.dark => 'dark', ThemeMode.light => 'light', _ => 'system' };
  static AccentColor _parseAccent(String s) => s == 'pink' ? AccentColor.pink : AccentColor.green;
  static String _accentToStr(AccentColor c) => c == AccentColor.pink ? 'pink' : 'green';

  static ThemeController of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(p != null, 'ThemeProvider not found');
    return p!.controller;
  }
}

class ThemeProvider extends InheritedNotifier<ThemeController> {
  final ThemeController controller;
  const ThemeProvider({super.key, required this.controller, required super.child}) : super(notifier: controller);
}