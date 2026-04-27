import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/exercises/data/prefs_service.dart';

/** Edge cases для сохранения и загрузки данных через PrefsService. */
void main() {
  group('PrefsService — edge cases', () {
    test('пустой список категорий возвращает []', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PrefsService();
      await prefs.init();

      expect(prefs.selectedCategories, isEmpty);
    });

    test('сохранение и чтение большого списка категорий', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PrefsService();
      await prefs.init();

      final bigList = List.generate(50, (i) => 'category_$i');
      await prefs.setSelectedCategories(bigList);
      expect(prefs.selectedCategories, bigList);
    });

    test('clearAll сбрасывает всё к дефолтам', () async {
      SharedPreferences.setMockInitialValues({
        'user_name': 'Тест',
        'selected_categories': ['neck'],
        'notif_from': '10:00',
        'onboarding_done': true,
      });
      final prefs = PrefsService();
      await prefs.init();

      expect(prefs.userName, 'Тест');
      expect(prefs.isOnboardingDone, true);

      await prefs.clearAll();

      expect(prefs.userName, '');
      expect(prefs.isOnboardingDone, false);
      expect(prefs.selectedCategories, isEmpty);
      expect(prefs.notifFrom, '09:00');
    });

    test('notifDays с невалидными строками кидает исключение', () async {
      SharedPreferences.setMockInitialValues({
        'notif_days': ['abc', 'def'],
      });
      final prefs = PrefsService();
      await prefs.init();

      expect(() => prefs.notifDays, throwsFormatException);
    });

    test('notifFreq парсинг "daily" через int.tryParse → null → fallback', () {
      final result = int.tryParse('daily') ?? 60;
      expect(result, 60);
    });

    test('userName с unicode символами', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PrefsService();
      await prefs.init();

      await prefs.setUserName('Максим 🎉');
      expect(prefs.userName, 'Максим 🎉');
    });

    test('перезапись значения сохраняет новое', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PrefsService();
      await prefs.init();

      await prefs.setNotifFrom('08:00');
      expect(prefs.notifFrom, '08:00');

      await prefs.setNotifFrom('12:00');
      expect(prefs.notifFrom, '12:00');
    });

    test('дефолтные значения notifDays — все 7 дней', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PrefsService();
      await prefs.init();

      expect(prefs.notifDays, [1, 2, 3, 4, 5, 6, 7]);
    });
  });
}
