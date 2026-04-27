import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/onboarding/categories_screen.dart';
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
        const CategoriesScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CategoriesScreen — UI', () {
    testWidgets('показывает заголовок', (tester) async {
      await pumpScreen(tester);
      expect(find.textContaining('Выберите'), findsOneWidget);
    });

    testWidgets('показывает первые видимые проблемы', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Проблемы с осанкой'), findsOneWidget);
      expect(find.text('Боли в спине и пояснице'), findsOneWidget);
      expect(find.text('Боли в шее'), findsOneWidget);
      expect(find.text('Усталость глаз'), findsOneWidget);
    });

    testWidgets('показывает остальные проблемы при скролле', (tester) async {
      await pumpScreen(tester);

      await tester.scrollUntilVisible(
        find.text('Проблемы со сном'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Проблемы со сном'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Далее"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Далее'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('CategoriesScreen — выбор', () {
    testWidgets('тап на проблему выделяет её (показывает check)', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Боли в шее'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('повторный тап снимает выделение', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Боли в шее'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(find.text('Боли в шее'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('можно выбрать несколько проблем', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Боли в шее'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Усталость глаз'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });
  });

  group('CategoriesScreen — валидация', () {
    testWidgets('"Далее" без выбора → SnackBar с валидацией', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Далее'));
      await tester.pumpAndSettle();

      expect(find.text('Выберите хотя бы одну категорию'), findsOneWidget);
    });
  });
}
