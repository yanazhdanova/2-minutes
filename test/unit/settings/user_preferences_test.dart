import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/app/user_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('UserPreferences', () {
    test('setName/getName — сохраняет и возвращает имя', () async {
      await UserPreferences.setName('Тест');
      final name = await UserPreferences.getName();
      expect(name, 'Тест');
    });

    test('getName возвращает null если не задано', () async {
      final name = await UserPreferences.getName();
      expect(name, isNull);
    });

    test('setOnboardingComplete/isOnboardingComplete', () async {
      expect(await UserPreferences.isOnboardingComplete(), false);

      await UserPreferences.setOnboardingComplete(true);
      expect(await UserPreferences.isOnboardingComplete(), true);
    });

    test('setSelectedCategories/getSelectedCategories', () async {
      expect(await UserPreferences.getSelectedCategories(), isEmpty);

      await UserPreferences.setSelectedCategories(['neck', 'eyes']);
      expect(await UserPreferences.getSelectedCategories(), ['neck', 'eyes']);
    });

    test('setNotifTimeRange сохраняет все 4 значения', () async {
      await UserPreferences.setNotifTimeRange(
        fromHour: 8,
        fromMinute: 30,
        toHour: 22,
        toMinute: 0,
      );

      final p = await SharedPreferences.getInstance();
      expect(p.getInt('notif_from_hour'), 8);
      expect(p.getInt('notif_from_minute'), 30);
      expect(p.getInt('notif_to_hour'), 22);
      expect(p.getInt('notif_to_minute'), 0);
    });

    test('setNotifFrequency', () async {
      await UserPreferences.setNotifFrequency('30');
      final p = await SharedPreferences.getInstance();
      expect(p.getString('notif_frequency'), '30');
    });

    test('clear очищает все данные', () async {
      await UserPreferences.setName('Тест');
      await UserPreferences.setOnboardingComplete(true);
      await UserPreferences.setSelectedCategories(['neck']);

      await UserPreferences.clear();

      expect(await UserPreferences.getName(), isNull);
      expect(await UserPreferences.isOnboardingComplete(), false);
      expect(await UserPreferences.getSelectedCategories(), isEmpty);
    });
  });
}
