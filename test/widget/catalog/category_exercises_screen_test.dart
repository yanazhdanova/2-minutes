import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/catalog/category_exercises_screen.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  const testExercises = [
    Exercise(
      id: 'ex_01',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Наклоны головы',
      description: 'Плавные наклоны головы вперёд-назад и в стороны',
      defaultDurationSec: 30,
    ),
    Exercise(
      id: 'ex_02',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Повороты шеи',
      description: 'Медленные повороты головы влево-вправо',
      defaultDurationSec: 25,
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    List<Exercise> exercises = testExercises,
  }) async {
    when(
      () => mockRepo.exercisesByCategory('neck'),
    ).thenAnswer((_) async => exercises);

    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(
        const CategoryExercisesScreen(categoryId: 'neck', title: 'Шея'),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CategoryExercisesScreen — UI', () {
    testWidgets('показывает заголовок категории', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Шея'), findsOneWidget);
    });

    testWidgets('показывает список упражнений', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Наклоны головы'), findsOneWidget);
      expect(find.text('Повороты шеи'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('показывает стрелки для раскрытия', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNWidgets(2));
    });
  });

  group('CategoryExercisesScreen — expand/collapse', () {
    testWidgets('тап на упражнение раскрывает детали', (tester) async {
      await pumpScreen(tester, exercises: [testExercises[0]]);

      await tester.tap(find.text('Наклоны головы'));
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedCrossFade), findsOneWidget);
      final crossFade = tester.widget<AnimatedCrossFade>(
        find.byType(AnimatedCrossFade),
      );
      expect(crossFade.crossFadeState, CrossFadeState.showSecond);
    });

    testWidgets('повторный тап сворачивает детали', (tester) async {
      await pumpScreen(tester, exercises: [testExercises[0]]);

      await tester.tap(find.text('Наклоны головы'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Наклоны головы'));
      await tester.pumpAndSettle();

      final crossFade = tester.widget<AnimatedCrossFade>(
        find.byType(AnimatedCrossFade),
      );
      expect(crossFade.crossFadeState, CrossFadeState.showFirst);
    });
  });

  group('CategoryExercisesScreen — пустой список', () {
    testWidgets('показывает сообщение когда нет упражнений', (tester) async {
      await pumpScreen(tester, exercises: []);
      expect(find.text('Нет упражнений в этой категории'), findsOneWidget);
    });
  });
}
