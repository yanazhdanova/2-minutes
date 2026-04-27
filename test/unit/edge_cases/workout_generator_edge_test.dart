import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/exercises/data/workout_generator.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(HealthType.physical);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
  });

  group('WorkoutGenerator — edge cases', () {
    test('generate с пустыми problems возвращает пустой список', () async {
      final gen = WorkoutGenerator(mockRepo);
      final result = await gen.generate([]);
      expect(result, isEmpty);
    });

    test('generate с одним упражнением в категории', () async {
      const categories = [
        ExerciseCategory(
          id: 'neck',
          type: HealthType.physical,
          title: 'Шея',
          order: 0,
        ),
      ];
      const exercises = [
        Exercise(
          id: 'ex_01',
          categoryId: 'neck',
          type: HealthType.physical,
          title: 'Единственное',
          description: 'Описание',
          defaultDurationSec: 30,
        ),
      ];

      when(
        () => mockRepo.categoriesByType(HealthType.physical),
      ).thenAnswer((_) async => categories);
      when(
        () => mockRepo.exercisesByCategory('neck'),
      ).thenAnswer((_) async => exercises);

      final gen = WorkoutGenerator(mockRepo);
      final result = await gen.generate(['neck']);
      expect(result, isNotEmpty);
      expect(result.first.id, 'ex_01');
    });

    test('generate с неизвестной проблемой → пустой список', () async {
      final gen = WorkoutGenerator(mockRepo);
      final result = await gen.generate(['nonexistent_problem']);
      expect(result, isEmpty);
    });

    test('generate с несколькими problems объединяет категории', () async {
      const neckCat = ExerciseCategory(
        id: 'neck',
        type: HealthType.physical,
        title: 'Шея',
        order: 0,
      );
      const eyesCat = ExerciseCategory(
        id: 'eyes',
        type: HealthType.physical,
        title: 'Глаза',
        order: 1,
      );
      const neckEx = Exercise(
        id: 'neck_01',
        categoryId: 'neck',
        type: HealthType.physical,
        title: 'Наклоны',
        description: 'Описание',
        defaultDurationSec: 30,
      );
      const eyesEx = Exercise(
        id: 'eyes_01',
        categoryId: 'eyes',
        type: HealthType.physical,
        title: 'Гимнастика глаз',
        description: 'Описание',
        defaultDurationSec: 30,
      );

      when(
        () => mockRepo.categoriesByType(any()),
      ).thenAnswer((_) async => [neckCat, eyesCat]);
      when(
        () => mockRepo.exercisesByCategory('neck'),
      ).thenAnswer((_) async => [neckEx]);
      when(
        () => mockRepo.exercisesByCategory('eyes'),
      ).thenAnswer((_) async => [eyesEx]);

      final gen = WorkoutGenerator(mockRepo);
      final result = await gen.generate(['neck', 'eyes']);

      expect(result.length, 2);
      final ids = result.map((e) => e.id).toSet();
      expect(ids, containsAll(['neck_01', 'eyes_01']));
    });
  });
}
