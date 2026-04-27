import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/home/workout_type_screen.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService({
      'selected_categories': ['neck', 'eyes'],
    });
    await tester.pumpWidget(
      wrapWithApp(
        const WorkoutTypeScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('WorkoutTypeScreen — UI', () {
    testWidgets('показывает заголовок', (tester) async {
      await pumpScreen(tester);
      expect(find.textContaining('Выберите тип'), findsOneWidget);
    });

    testWidgets('показывает карточку "Быстрый старт"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Быстрый старт'), findsOneWidget);
      expect(find.text('Тренировка подобрана под ваши задачи'), findsOneWidget);
    });

    testWidgets('показывает карточку "Своя тренировка"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Своя тренировка'), findsOneWidget);
      expect(find.text('Выберите 3 упражнения самостоятельно'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('показывает иконки bolt и tune', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.bolt), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });
  });
}
