import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/app/locale_controller.dart';
import 'package:two_mins/features/exercises/data/prefs_service.dart';

void main() {
  late PrefsService prefs;
  late LocaleController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = PrefsService();
    await prefs.init();
    controller = LocaleController(prefs);
  });

  group('инициализация', () {
    test('по умолчанию locale = ru', () {
      expect(controller.locale, const Locale('ru'));
    });

    test('загружает en из prefs', () async {
      await prefs.setLanguageCode('en');
      final ctrl = LocaleController(prefs);
      expect(ctrl.locale, const Locale('en'));
    });
  });

  group('setLocale', () {
    test('переключение на en', () async {
      await controller.setLocale(const Locale('en'));

      expect(controller.locale, const Locale('en'));
      expect(prefs.languageCode, 'en');
    });

    test('переключение обратно на ru', () async {
      await controller.setLocale(const Locale('en'));
      await controller.setLocale(const Locale('ru'));

      expect(controller.locale, const Locale('ru'));
      expect(prefs.languageCode, 'ru');
    });

    test('не уведомляет при установке той же локали', () async {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.setLocale(const Locale('ru'));
      expect(notifyCount, 0);
    });

    test('уведомляет слушателей при изменении', () async {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.setLocale(const Locale('en'));
      expect(notifyCount, 1);
    });

    test('сохраняет выбор в PrefsService', () async {
      await controller.setLocale(const Locale('en'));
      expect(prefs.languageCode, 'en');
    });
  });
}
