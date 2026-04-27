import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/catalog/physical_groups.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  const testCategories = [
    ExerciseCategory(
      id: 'neck',
      type: HealthType.physical,
      title: 'Шея',
      order: 0,
    ),
    ExerciseCategory(
      id: 'back_lower',
      type: HealthType.physical,
      title: 'Спина и поясница',
      order: 1,
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
    when(
      () => mockRepo.categoriesByType(HealthType.physical),
    ).thenAnswer((_) async => testCategories);
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(
        const PhysicalGroupsScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('PhysicalGroupsScreen — UI', () {
    testWidgets('показывает заголовок "Физические"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Физические'), findsOneWidget);
    });

    testWidgets('показывает список категорий', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Шея'), findsOneWidget);
      expect(find.text('Спина и поясница'), findsOneWidget);
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

  group('PhysicalGroupsScreen — пустой список', () {
    testWidgets('показывает "Нет категорий" когда список пуст', (tester) async {
      when(
        () => mockRepo.categoriesByType(HealthType.physical),
      ).thenAnswer((_) async => []);

      final prefs = await createTestPrefsService();
      await tester.pumpWidget(
        wrapWithApp(
          const PhysicalGroupsScreen(),
          prefs: prefs,
          exerciseRepo: mockRepo,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Нет категорий'), findsOneWidget);
    });
  });

  group('PhysicalGroupsScreen — навигация', () {
    testWidgets('тап на категорию навигирует на CategoryExercisesScreen', (
      tester,
    ) async {
      when(
        () => mockRepo.exercisesByCategory('neck'),
      ).thenAnswer((_) async => []);

      await pumpScreen(tester);

      await tester.tap(find.text('Шея'));
      await tester.pumpAndSettle();

      expect(find.byType(PhysicalGroupsScreen), findsNothing);
    });
  });
}
