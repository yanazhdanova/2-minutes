import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/catalog/mental_groups.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  const testCategories = [
    ExerciseCategory(
      id: 'relaxation',
      type: HealthType.mental,
      title: 'Снятие напряжения',
      order: 0,
    ),
    ExerciseCategory(
      id: 'attention_switch',
      type: HealthType.mental,
      title: 'Переключение внимания',
      order: 1,
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
    when(
      () => mockRepo.categoriesByType(HealthType.mental),
    ).thenAnswer((_) async => testCategories);
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(
        const MentalGroupsScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('MentalGroupsScreen — UI', () {
    testWidgets('показывает заголовок "Ментальные"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Ментальные'), findsOneWidget);
    });

    testWidgets('показывает список категорий', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Снятие напряжения'), findsOneWidget);
      expect(find.text('Переключение внимания'), findsOneWidget);
    });

    testWidgets('показывает chevron_right для каждой категории', (
      tester,
    ) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('MentalGroupsScreen — пустой список', () {
    testWidgets('показывает "Нет категорий" когда список пуст', (tester) async {
      when(
        () => mockRepo.categoriesByType(HealthType.mental),
      ).thenAnswer((_) async => []);

      final prefs = await createTestPrefsService();
      await tester.pumpWidget(
        wrapWithApp(
          const MentalGroupsScreen(),
          prefs: prefs,
          exerciseRepo: mockRepo,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Нет категорий'), findsOneWidget);
    });
  });
}
