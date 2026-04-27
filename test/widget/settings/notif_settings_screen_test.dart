import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/settings/notif_settings_screen.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    Map<String, Object> initialPrefs = const {},
  }) async {
    final prefs = await createTestPrefsService(initialPrefs);
    await tester.pumpWidget(
      wrapWithApp(
        const NotifSettingsScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('NotifSettingsScreen — UI', () {
    testWidgets('показывает заголовок "Уведомления"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Уведомления'), findsOneWidget);
    });

    testWidgets('показывает секцию "Время уведомлений"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Время уведомлений'), findsOneWidget);
    });

    testWidgets('показывает секцию "Частота"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Частота'), findsOneWidget);
    });

    testWidgets('показывает секцию "Дни недели"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Дни недели'), findsOneWidget);
    });

    testWidgets('показывает метки "От" и "До"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('От'), findsOneWidget);
      expect(find.text('До'), findsOneWidget);
    });

    testWidgets('показывает значения времени по умолчанию', (tester) async {
      await pumpScreen(tester);
      expect(find.text('09:00'), findsOneWidget);
      expect(find.text('21:00'), findsOneWidget);
    });

    testWidgets('показывает все 7 дней недели', (tester) async {
      await pumpScreen(tester);
      for (final day in ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']) {
        expect(find.text(day), findsOneWidget);
      }
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('показывает частоту с "Каждые"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Каждые '), findsOneWidget);
    });
  });

  group('NotifSettingsScreen — взаимодействие', () {
    testWidgets('тап на день переключает его и показывает "Сохранить"', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.text('Сохранить'), findsNothing);

      await tester.tap(find.text('Пн'));
      await tester.pumpAndSettle();

      expect(find.text('Сохранить'), findsOneWidget);
    });

    testWidgets('загружает данные из prefs', (tester) async {
      await pumpScreen(
        tester,
        initialPrefs: {
          'notif_from': '10:00',
          'notif_to': '18:00',
          'notif_freq': '120',
          'notif_days': ['1', '3', '5'],
        },
      );

      expect(find.text('10:00'), findsOneWidget);
      expect(find.text('18:00'), findsOneWidget);
    });
  });
}
