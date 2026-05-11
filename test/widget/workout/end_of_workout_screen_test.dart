import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/workout/end_of_the_workout_screen.dart';
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
        const EndOfTheWorkoutScreen(exerciseCount: 3, durationSeconds: 120),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('EndOfTheWorkoutScreen — UI', () {
    testWidgets('показывает "Отлично!"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Отлично!'), findsOneWidget);
    });

    testWidgets('показывает подзаголовок', (tester) async {
      await pumpScreen(tester);
      expect(find.textContaining('Тренировка завершена'), findsWidgets);
    });

    testWidgets('показывает кнопку "На главную"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('На главную'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Поделиться"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Поделиться'), findsOneWidget);
    });

    testWidgets('показывает иконку check_circle', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });

    testWidgets('показывает логотип', (tester) async {
      await pumpScreen(tester);
      expect(find.text('2mins'), findsWidgets);
    });
  });
}
