import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/app/app_theme.dart';
import 'package:two_mins/app/theme_controller.dart';
import 'package:two_mins/features/exercises/data/prefs_service.dart';

void main() {
  late PrefsService prefs;
  late ThemeController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = PrefsService();
    await prefs.init();
    controller = ThemeController(prefs);
  });

  group('инициализация', () {
    test('по умолчанию ThemeMode.system', () {
      expect(controller.themeMode, ThemeMode.system);
    });

    test('по умолчанию AccentColor.green', () {
      expect(controller.accentColor, AccentColor.green);
    });

    test('загружает dark из prefs', () async {
      await prefs.setThemeMode('dark');
      final ctrl = ThemeController(prefs);
      expect(ctrl.themeMode, ThemeMode.dark);
    });

    test('загружает light из prefs', () async {
      await prefs.setThemeMode('light');
      final ctrl = ThemeController(prefs);
      expect(ctrl.themeMode, ThemeMode.light);
    });

    test('загружает pink accent из prefs', () async {
      await prefs.setAccentColor('pink');
      final ctrl = ThemeController(prefs);
      expect(ctrl.accentColor, AccentColor.pink);
    });

    test('неизвестная строка темы → system', () async {
      await prefs.setThemeMode('unknown');
      final ctrl = ThemeController(prefs);
      expect(ctrl.themeMode, ThemeMode.system);
    });

    test('неизвестная строка акцента → green', () async {
      await prefs.setAccentColor('blue');
      final ctrl = ThemeController(prefs);
      expect(ctrl.accentColor, AccentColor.green);
    });
  });

  group('setThemeMode', () {
    test('переключение на dark', () async {
      await controller.setThemeMode(ThemeMode.dark);

      expect(controller.themeMode, ThemeMode.dark);
      expect(prefs.themeMode, 'dark');
    });

    test('переключение на light', () async {
      await controller.setThemeMode(ThemeMode.light);

      expect(controller.themeMode, ThemeMode.light);
      expect(prefs.themeMode, 'light');
    });

    test('переключение на system', () async {
      await controller.setThemeMode(ThemeMode.dark);
      await controller.setThemeMode(ThemeMode.system);

      expect(controller.themeMode, ThemeMode.system);
      expect(prefs.themeMode, 'system');
    });

    test('не уведомляет при установке того же значения', () async {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.setThemeMode(ThemeMode.dark);
      expect(notifyCount, 1);

      await controller.setThemeMode(ThemeMode.dark);
      expect(notifyCount, 1);
    });

    test('уведомляет слушателей при изменении', () async {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.setThemeMode(ThemeMode.dark);
      expect(notifyCount, 1);

      await controller.setThemeMode(ThemeMode.light);
      expect(notifyCount, 2);
    });
  });

  group('setAccentColor', () {
    test('переключение на pink', () async {
      await controller.setAccentColor(AccentColor.pink);

      expect(controller.accentColor, AccentColor.pink);
      expect(prefs.accentColor, 'pink');
    });

    test('переключение обратно на green', () async {
      await controller.setAccentColor(AccentColor.pink);
      await controller.setAccentColor(AccentColor.green);

      expect(controller.accentColor, AccentColor.green);
      expect(prefs.accentColor, 'green');
    });

    test('не уведомляет при установке того же значения', () async {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.setAccentColor(AccentColor.pink);
      expect(notifyCount, 1);

      await controller.setAccentColor(AccentColor.pink);
      expect(notifyCount, 1);
    });

    test('уведомляет слушателей при изменении', () async {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.setAccentColor(AccentColor.pink);
      expect(notifyCount, 1);
    });
  });

  group('сохранение в PrefsService', () {
    test('themeMode сохраняется в prefs', () async {
      await controller.setThemeMode(ThemeMode.dark);
      expect(prefs.themeMode, 'dark');
    });

    test('accentColor сохраняется в prefs', () async {
      await controller.setAccentColor(AccentColor.pink);
      expect(prefs.accentColor, 'pink');
    });
  });
}
