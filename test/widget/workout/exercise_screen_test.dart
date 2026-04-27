import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/workout/exercise_screen.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  const testExercises = [
    Exercise(
      id: 'test_01',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Первое упражнение',
      description: 'Описание первого упражнения',
      defaultDurationSec: 5,
    ),
    Exercise(
      id: 'test_02',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Второе упражнение',
      description: 'Описание второго упражнения',
      defaultDurationSec: 5,
    ),
    Exercise(
      id: 'test_03',
      categoryId: 'relaxation',
      type: HealthType.mental,
      title: 'Третье упражнение',
      description: 'Описание третьего упражнения',
      defaultDurationSec: 5,
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
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(
        ExerciseScreen(exercises: exercises),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pump();
  }

  group('ExerciseScreen — UI', () {
    testWidgets('показывает название текущего упражнения', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Первое упражнение'), findsOneWidget);
    });

    testWidgets('показывает описание текущего упражнения', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Описание первого упражнения'), findsOneWidget);
    });

    testWidgets('показывает таймер', (tester) async {
      await pumpScreen(tester);
      expect(find.textContaining('00:0'), findsOneWidget);
    });

    testWidgets('показывает кнопку "пауза"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('пауза'), findsOneWidget);
    });

    testWidgets('показывает кнопки -15 и +15', (tester) async {
      await pumpScreen(tester);
      expect(find.text('-15'), findsOneWidget);
      expect(find.text('+15'), findsOneWidget);
    });

    testWidgets('показывает кнопку heart', (tester) async {
      await pumpScreen(tester);
      expect(find.text('♡'), findsOneWidget);
    });

    testWidgets('показывает логотип', (tester) async {
      await pumpScreen(tester);
      expect(find.text('2 минуты'), findsOneWidget);
    });
  });

  group('ExerciseScreen — пауза', () {
    testWidgets('нажатие "пауза" показывает кнопки паузы', (tester) async {
      await pumpScreen(tester);

      final pauseFinder = find.text('пауза');
      expect(pauseFinder, findsOneWidget);
      await tester.tap(pauseFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Продолжить'), findsOneWidget);
      expect(find.text('Пропустить упражнение'), findsOneWidget);
      expect(find.text('Закончить тренировку'), findsOneWidget);
    });

    testWidgets('"Продолжить" возвращает к тренировке', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('пауза'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Продолжить'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('пауза'), findsOneWidget);
      expect(find.text('Продолжить'), findsNothing);
    });
  });

  group('ExerciseScreen — skip', () {
    testWidgets('"Пропустить упражнение" переходит к следующему', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(find.text('пауза'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Пропустить упражнение'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Второе упражнение'), findsOneWidget);
    });
  });

  group('ExerciseScreen — favorite', () {
    testWidgets('тап на heart переключает состояние', (tester) async {
      await pumpScreen(tester);

      final heartFinder = find.text('♡');
      expect(heartFinder, findsOneWidget);

      await tester.tap(heartFinder);
      await tester.pump();

      expect(heartFinder, findsOneWidget);
    });
  });
}
