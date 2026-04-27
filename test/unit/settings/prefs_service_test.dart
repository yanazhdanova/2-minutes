import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/exercises/data/prefs_service.dart';

void main() {
  late PrefsService prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = PrefsService();
    await prefs.init();
  });

  group('onboarding', () {
    test('по умолчанию onboarding не завершён', () {
      expect(prefs.isOnboardingDone, false);
    });

    test('сохранение/загрузка onboarding done', () async {
      await prefs.setOnboardingDone(true);
      expect(prefs.isOnboardingDone, true);
    });
  });

  group('userName', () {
    test('по умолчанию пустая строка', () {
      expect(prefs.userName, '');
    });

    test('сохранение/загрузка имени', () async {
      await prefs.setUserName('Анна');
      expect(prefs.userName, 'Анна');
    });

    test('перезапись имени', () async {
      await prefs.setUserName('Анна');
      await prefs.setUserName('Мария');
      expect(prefs.userName, 'Мария');
    });
  });

  group('selectedCategories', () {
    test('по умолчанию пустой список', () {
      expect(prefs.selectedCategories, isEmpty);
    });

    test('сохранение/загрузка категорий', () async {
      await prefs.setSelectedCategories(['posture', 'neck', 'stress']);
      expect(prefs.selectedCategories, ['posture', 'neck', 'stress']);
    });

    test('перезапись категорий', () async {
      await prefs.setSelectedCategories(['posture']);
      await prefs.setSelectedCategories(['neck', 'eyes']);
      expect(prefs.selectedCategories, ['neck', 'eyes']);
    });
  });

  group('notification time', () {
    test('по умолчанию from = 09:00', () {
      expect(prefs.notifFrom, '09:00');
    });

    test('по умолчанию to = 21:00', () {
      expect(prefs.notifTo, '21:00');
    });

    test('сохранение/загрузка notifFrom', () async {
      await prefs.setNotifFrom('08:30');
      expect(prefs.notifFrom, '08:30');
    });

    test('сохранение/загрузка notifTo', () async {
      await prefs.setNotifTo('22:00');
      expect(prefs.notifTo, '22:00');
    });
  });

  group('notification frequency', () {
    test('по умолчанию "daily"', () {
      expect(prefs.notifFreq, 'daily');
    });

    test('сохранение/загрузка частоты', () async {
      await prefs.setNotifFreq('60');
      expect(prefs.notifFreq, '60');
    });

    test('сохранение минутной частоты', () async {
      await prefs.setNotifFreq('30');
      expect(prefs.notifFreq, '30');
    });
  });

  group('notification days', () {
    test('по умолчанию все 7 дней', () {
      expect(prefs.notifDays, [1, 2, 3, 4, 5, 6, 7]);
    });

    test('сохранение/загрузка дней', () async {
      await prefs.setNotifDays([1, 3, 5]);
      expect(prefs.notifDays, [1, 3, 5]);
    });

    test('один день', () async {
      await prefs.setNotifDays([1]);
      expect(prefs.notifDays, [1]);
    });
  });

  group('language', () {
    test('по умолчанию "ru"', () {
      expect(prefs.languageCode, 'ru');
    });

    test('сохранение/загрузка языка en', () async {
      await prefs.setLanguageCode('en');
      expect(prefs.languageCode, 'en');
    });

    test('переключение обратно на ru', () async {
      await prefs.setLanguageCode('en');
      await prefs.setLanguageCode('ru');
      expect(prefs.languageCode, 'ru');
    });
  });

  group('theme', () {
    test('по умолчанию "system"', () {
      expect(prefs.themeMode, 'system');
    });

    test('сохранение/загрузка dark', () async {
      await prefs.setThemeMode('dark');
      expect(prefs.themeMode, 'dark');
    });

    test('сохранение/загрузка light', () async {
      await prefs.setThemeMode('light');
      expect(prefs.themeMode, 'light');
    });
  });

  group('accent color', () {
    test('по умолчанию "green"', () {
      expect(prefs.accentColor, 'green');
    });

    test('сохранение/загрузка pink', () async {
      await prefs.setAccentColor('pink');
      expect(prefs.accentColor, 'pink');
    });

    test('переключение обратно на green', () async {
      await prefs.setAccentColor('pink');
      await prefs.setAccentColor('green');
      expect(prefs.accentColor, 'green');
    });
  });

  group('clearAll', () {
    test('очищает все данные', () async {
      await prefs.setUserName('Тест');
      await prefs.setSelectedCategories(['posture']);
      await prefs.setOnboardingDone(true);
      await prefs.setLanguageCode('en');
      await prefs.setThemeMode('dark');
      await prefs.setAccentColor('pink');

      await prefs.clearAll();

      expect(prefs.userName, '');
      expect(prefs.selectedCategories, isEmpty);
      expect(prefs.isOnboardingDone, false);
      expect(prefs.languageCode, 'ru');
      expect(prefs.themeMode, 'system');
      expect(prefs.accentColor, 'green');
    });
  });

  group('значения по умолчанию при пустых preferences', () {
    test('все значения возвращают defaults', () {
      expect(prefs.isOnboardingDone, false);
      expect(prefs.userName, '');
      expect(prefs.selectedCategories, isEmpty);
      expect(prefs.notifFrom, '09:00');
      expect(prefs.notifTo, '21:00');
      expect(prefs.notifFreq, 'daily');
      expect(prefs.notifDays, [1, 2, 3, 4, 5, 6, 7]);
      expect(prefs.languageCode, 'ru');
      expect(prefs.themeMode, 'system');
      expect(prefs.accentColor, 'green');
    });
  });

  group('инициализация с существующими данными', () {
    test('загружает сохранённые значения', () async {
      SharedPreferences.setMockInitialValues({
        'user_name': 'Сохранённое имя',
        'selected_categories': ['neck', 'eyes'],
        'language_code': 'en',
        'theme_mode': 'dark',
        'accent_color': 'pink',
      });

      final loadedPrefs = PrefsService();
      await loadedPrefs.init();

      expect(loadedPrefs.userName, 'Сохранённое имя');
      expect(loadedPrefs.selectedCategories, ['neck', 'eyes']);
      expect(loadedPrefs.languageCode, 'en');
      expect(loadedPrefs.themeMode, 'dark');
      expect(loadedPrefs.accentColor, 'pink');
    });
  });
}
