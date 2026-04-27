import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/home/home_main_screen.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({'user_name': 'Тестовый'});
    mockRepo = MockExerciseSqliteRepository();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService({
      'user_name': 'Тестовый',
      'selected_categories': ['neck', 'eyes'],
    });
    await tester.pumpWidget(
      wrapWithApp(const HomeMainScreen(), prefs: prefs, exerciseRepo: mockRepo),
    );
    await tester.pumpAndSettle();
  }

  group('HomeMainScreen — UI', () {
    testWidgets('показывает логотип "2 минуты"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('2 минуты'), findsOneWidget);
    });

    testWidgets('показывает приветствие по времени суток', (tester) async {
      await pumpScreen(tester);

      final hour = DateTime.now().hour;
      if (hour < 6) {
        expect(find.textContaining('Доброй ночи'), findsOneWidget);
      } else if (hour < 12) {
        expect(find.textContaining('Доброе утро'), findsOneWidget);
      } else if (hour < 18) {
        expect(find.textContaining('Добрый день'), findsOneWidget);
      } else {
        expect(find.textContaining('Добрый вечер'), findsOneWidget);
      }
    });

    testWidgets('показывает кнопку "Начать тренировку"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Начать тренировку'), findsOneWidget);
    });

    testWidgets('показывает Premium icon', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });
  });

  group('HomeMainScreen — навигация', () {
    testWidgets('"Начать тренировку" → навигирует на WorkoutTypeScreen', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Начать тренировку'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Выберите тип'), findsOneWidget);
    });

    testWidgets('Premium icon → навигирует на BuyPremiumScreen', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(find.byIcon(Icons.workspace_premium));
      await tester.pumpAndSettle();

      expect(find.text('Премиум'), findsOneWidget);
    });
  });
}
