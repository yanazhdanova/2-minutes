import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/settings/settings_main_screen.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(
        const SettingsMainScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SettingsMainScreen — UI', () {
    testWidgets('показывает заголовок "Настройки"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Настройки'), findsOneWidget);
    });

    testWidgets('показывает пункт "Моя программа"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Моя программа'), findsOneWidget);
    });

    testWidgets('показывает пункт "Уведомления"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Уведомления'), findsOneWidget);
    });

    testWidgets('показывает пункт "Язык"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Язык'), findsOneWidget);
    });

    testWidgets('показывает пункт "Внешний вид"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Внешний вид'), findsOneWidget);
    });

    testWidgets('показывает пункт "Платная версия"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Платная версия'), findsOneWidget);
    });

    testWidgets('показывает 5 пунктов меню', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(5));
    });
  });

  group('SettingsMainScreen — навигация', () {
    testWidgets('"Моя программа" → ProgramSettingsScreen', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Моя программа'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Выберите проблемы'), findsOneWidget);
    });

    testWidgets('"Язык" → LanguageSettingsScreen', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Язык'));
      await tester.pumpAndSettle();

      expect(find.text('Русский'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('"Внешний вид" → AppearanceSettingsScreen', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Внешний вид'));
      await tester.pumpAndSettle();

      expect(find.text('Системная'), findsOneWidget);
      expect(find.text('Светлая'), findsOneWidget);
      expect(find.text('Тёмная'), findsOneWidget);
    });

    testWidgets('"Платная версия" → BuyPremiumScreen', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Платная версия'));
      await tester.pumpAndSettle();

      expect(find.text('Премиум'), findsOneWidget);
    });
  });
}
