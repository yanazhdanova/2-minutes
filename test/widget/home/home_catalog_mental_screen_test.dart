import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/home/home_catalog_mental.dart';
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

  const testExercises = [
    Exercise(
      id: 'ex_m01',
      categoryId: 'relaxation',
      type: HealthType.mental,
      title: 'Глубокое дыхание',
      description: 'Медленное глубокое дыхание',
      defaultDurationSec: 60,
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
    when(
      () => mockRepo.categoriesByType(HealthType.mental),
    ).thenAnswer((_) async => testCategories);
    when(
      () => mockRepo.exercisesByCategory(any()),
    ).thenAnswer((_) async => testExercises);
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(
        const HomeCatalogMentalScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HomeCatalogMentalScreen — UI', () {
    testWidgets('показывает заголовок "Ментальные"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Ментальные'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Случайное упражнение"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Случайное упражнение'), findsOneWidget);
    });

    testWidgets('показывает иконку shuffle', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
    });

    testWidgets('показывает категории как ExpansionTile', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Снятие напряжения'), findsOneWidget);
      expect(find.text('Переключение внимания'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('HomeCatalogMentalScreen — expansion', () {
    testWidgets('тап на категорию раскрывает упражнения', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Снятие напряжения'));
      await tester.pumpAndSettle();

      expect(find.text('Глубокое дыхание'), findsOneWidget);
    });
  });
}
