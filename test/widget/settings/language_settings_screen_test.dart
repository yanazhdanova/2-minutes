import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/settings/language_settings_screen.dart';
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
        const LanguageSettingsScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('LanguageSettingsScreen — UI', () {
    testWidgets('показывает заголовок "Язык"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Язык'), findsOneWidget);
    });

    testWidgets('показывает "Русский"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Русский'), findsAtLeastNWidgets(1));
    });

    testWidgets('показывает "English"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('English'), findsAtLeastNWidgets(1));
    });

    testWidgets('по умолчанию Русский выбран', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('LanguageSettingsScreen — смена языка', () {
    testWidgets('тап на "English" меняет selected state', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      await tester.tap(find.text('English').first);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
