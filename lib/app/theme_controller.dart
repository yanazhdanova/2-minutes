import 'package:flutter/material.dart';
import '../features/exercises/data/prefs_service.dart';
import 'app_theme.dart';

/// Контроллер темы приложения. Управляет двумя настройками:
/// 1. Режим темы (ThemeMode): system, light, dark.
/// 2. Акцентный цвет (AccentColor): green, pink.
/// При создании считывает сохранённые значения из PrefsService.
/// При изменении - сохраняет в PrefsService и вызывает notifyListeners(),
/// что пересобирает MaterialApp через ThemeProvider (InheritedNotifier).
class ThemeController extends ChangeNotifier {
  final PrefsService _prefs;
  late ThemeMode _themeMode;
  late AccentColor _accentColor;

  /// Создаёт контроллер, считывая текущие настройки темы и акцента из [prefs].
  /// Если значения отсутствуют или невалидны - fallback на system и green.
  ThemeController(this._prefs) {
    _themeMode = _parseMode(_prefs.themeMode);
    _accentColor = _parseAccent(_prefs.accentColor);
  }

  /// Текущий режим темы: system, light или dark.
  ThemeMode get themeMode => _themeMode;
  /// Текущий акцентный цвет: green или pink.
  AccentColor get accentColor => _accentColor;

  /// Определяет, тёмная ли тема сейчас активна.
  /// Для ThemeMode.system - проверяет платформенную яркость через MediaQuery.
  /// Для light/dark - возвращает соответствующее значение напрямую.
  /// @param context BuildContext для доступа к MediaQuery при system-режиме.
  /// @return true если тёмная тема активна.
  bool isDark(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Устанавливает режим темы. Если значение не изменилось - ничего не делает.
  /// Сохраняет выбор в SharedPreferences через PrefsService и уведомляет слушателей.
  /// @param mode Новый режим темы (system, light, dark).
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setThemeMode(_modeToStr(mode));
    notifyListeners();
  }

  /// Устанавливает акцентный цвет. Если значение не изменилось - ничего не делает.
  /// Сохраняет выбор в SharedPreferences через PrefsService и уведомляет слушателей,
  /// что приводит к пересборке MaterialApp с новой палитрой ResolvedColors.
  /// @param color Новый акцентный цвет (green или pink).
  Future<void> setAccentColor(AccentColor color) async {
    if (_accentColor == color) return;
    _accentColor = color;
    await _prefs.setAccentColor(_accentToStr(color));
    notifyListeners();
  }

  static ThemeMode _parseMode(String s) => switch (s) {
    'dark' => ThemeMode.dark,
    'light' => ThemeMode.light,
    _ => ThemeMode.system,
  };
  static String _modeToStr(ThemeMode m) => switch (m) {
    ThemeMode.dark => 'dark',
    ThemeMode.light => 'light',
    _ => 'system',
  };
  static AccentColor _parseAccent(String s) =>
      s == 'pink' ? AccentColor.pink : AccentColor.green;
  static String _accentToStr(AccentColor c) =>
      c == AccentColor.pink ? 'pink' : 'green';

  /// Получает ThemeController из ближайшего ThemeProvider в дереве виджетов.
  /// @param context BuildContext вызывающего виджета.
  /// @return Экземпляр ThemeController.
  /// @throws AssertionError если ThemeProvider не найден.
  static ThemeController of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(p != null, 'ThemeProvider not found');
    return p!.controller;
  }
}

/// InheritedNotifier-обёртка для ThemeController.
/// Автоматически пересобирает зависимое поддерево при каждом notifyListeners()
/// контроллера (смена режима темы или акцентного цвета).
class ThemeProvider extends InheritedNotifier<ThemeController> {
  final ThemeController controller;
  const ThemeProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(notifier: controller);
}
