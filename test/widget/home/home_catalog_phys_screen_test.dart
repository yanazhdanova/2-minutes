import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/home/home_catalog_phys.dart';
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

  const testExercises = [
    Exercise(
      id: 'ex_01',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Наклоны головы',
      description: 'Плавные наклоны',
      defaultDurationSec: 30,
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
    when(
      () => mockRepo.categoriesByType(HealthType.physical),
    ).thenAnswer((_) async => testCategories);
    when(
      () => mockRepo.exercisesByCategory(any()),
    ).thenAnswer((_) async => testExercises);
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(
        const HomeCatalogPhysScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HomeCatalogPhysScreen — UI', () {
    testWidgets('показывает заголовок "Физические"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Физические'), findsOneWidget);
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
      expect(find.text('Шея'), findsOneWidget);
      expect(find.text('Спина и поясница'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('HomeCatalogPhysScreen — expansion', () {
    testWidgets('тап на категорию раскрывает упражнения', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Шея'));
      await tester.pumpAndSettle();

      expect(find.text('Наклоны головы'), findsOneWidget);
    });
  });
}
