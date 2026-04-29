import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/home/exercises_choice.dart';
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
        const ExercisesChoiceScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ExercisesChoiceScreen — UI', () {
    testWidgets('показывает заголовок "Выберите упражнения"', (tester) async {
      await pumpScreen(tester);
      expect(find.textContaining('Выберите'), findsOneWidget);
    });

    testWidgets('показывает 3 слота', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Выбрать упражнение'), findsNWidgets(3));
    });

    testWidgets('показывает номера слотов 1, 2, 3', (tester) async {
      await pumpScreen(tester);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Начать"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Начать'), findsOneWidget);
    });

    testWidgets('кнопка "Начать" отключена пока не все слоты заполнены', (
      tester,
    ) async {
      await pumpScreen(tester);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('показывает иконки add_circle_outline для пустых слотов', (
      tester,
    ) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.add_circle_outline), findsNWidgets(3));
    });
  });
}
