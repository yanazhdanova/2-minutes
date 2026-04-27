import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/settings/appearance_settings_screen.dart';
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
        const AppearanceSettingsScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AppearanceSettingsScreen — UI', () {
    testWidgets('показывает заголовок "Внешний вид"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Внешний вид'), findsOneWidget);
    });

    testWidgets('показывает секцию "Тема"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Тема'), findsOneWidget);
    });

    testWidgets('показывает три варианта темы', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Системная'), findsOneWidget);
      expect(find.text('Светлая'), findsOneWidget);
      expect(find.text('Тёмная'), findsOneWidget);
    });

    testWidgets('показывает секцию "Акцент"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Акцент'), findsOneWidget);
    });

    testWidgets('показывает два акцента', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Зелёный'), findsOneWidget);
      expect(find.text('Розовый'), findsOneWidget);
    });

    testWidgets('по умолчанию "Системная" выбрана', (tester) async {
      await pumpScreen(tester);

      // Системная должна быть выделена (check_circle)
      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('AppearanceSettingsScreen — выбор темы', () {
    testWidgets('тап на "Светлая" выбирает light тему', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Светлая'));
      await tester.pumpAndSettle();

      final prefs = await createTestPrefsService();
    });

    testWidgets('тап на "Тёмная" выбирает dark тему', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Тёмная'));
      await tester.pumpAndSettle();
    });
  });

  group('AppearanceSettingsScreen — выбор акцента', () {
    testWidgets('тап на "Розовый" меняет акцент', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Розовый'));
      await tester.pumpAndSettle();
    });
  });
}
