import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/exercises/data/workout_generator.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;
  late WorkoutGenerator generator;

  const neckExercises = [
    Exercise(
      id: 'neck_01',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Наклоны головы',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
    Exercise(
      id: 'neck_02',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Повороты головы',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
    Exercise(
      id: 'neck_03',
      categoryId: 'neck',
      type: HealthType.physical,
      title: 'Вытяжение шеи',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
  ];

  const backExercises = [
    Exercise(
      id: 'back_01',
      categoryId: 'back_lower',
      type: HealthType.physical,
      title: 'Потягивание',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
    Exercise(
      id: 'back_02',
      categoryId: 'back_lower',
      type: HealthType.physical,
      title: 'Наклон корпуса',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
    Exercise(
      id: 'back_03',
      categoryId: 'back_lower',
      type: HealthType.physical,
      title: 'Скручивание',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
  ];

  const shoulderExercises = [
    Exercise(
      id: 'sh_01',
      categoryId: 'shoulders_arms',
      type: HealthType.physical,
      title: 'Подъём плеч',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
  ];

  const relaxExercises = [
    Exercise(
      id: 'relax_01',
      categoryId: 'relaxation',
      type: HealthType.mental,
      title: 'Дыхание',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
    Exercise(
      id: 'relax_02',
      categoryId: 'relaxation',
      type: HealthType.mental,
      title: 'Расслабление',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
    Exercise(
      id: 'relax_03',
      categoryId: 'relaxation',
      type: HealthType.mental,
      title: 'Выдох',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
  ];

  const emotionExercises = [
    Exercise(
      id: 'emotion_01',
      categoryId: 'emotional_balance',
      type: HealthType.mental,
      title: 'Осознание',
      description: 'Описание',
      defaultDurationSec: 40,
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
    generator = WorkoutGenerator(mockRepo);

    when(
      () => mockRepo.exercisesByCategory('neck'),
    ).thenAnswer((_) async => neckExercises);
    when(
      () => mockRepo.exercisesByCategory('back_lower'),
    ).thenAnswer((_) async => backExercises);
    when(
      () => mockRepo.exercisesByCategory('shoulders_arms'),
    ).thenAnswer((_) async => shoulderExercises);
    when(
      () => mockRepo.exercisesByCategory('relaxation'),
    ).thenAnswer((_) async => relaxExercises);
    when(
      () => mockRepo.exercisesByCategory('emotional_balance'),
    ).thenAnswer((_) async => emotionExercises);
    when(
      () => mockRepo.exercisesByCategory('eyes'),
    ).thenAnswer((_) async => []);
    when(
      () => mockRepo.exercisesByCategory('attention_switch'),
    ).thenAnswer((_) async => []);
  });

  group('generate', () {
    test('генерирует 3 упражнения для проблемы neck', () async {
      final result = await generator.generate(['neck']);

      expect(result.length, 3);
    });

    test(
      'маппит проблему posture → neck, shoulders_arms, back_lower',
      () async {
        final result = await generator.generate(['posture']);

        expect(result, isNotEmpty);
        expect(result.length, 3);
      },
    );

    test('маппит проблему stress → relaxation, emotional_balance', () async {
      final result = await generator.generate(['stress']);

      expect(result, isNotEmpty);
      expect(result.length, 3);
    });

    test('пустой список проблем → пустой результат', () async {
      final result = await generator.generate([]);

      expect(result, isEmpty);
    });

    test('несуществующая проблема → пустой результат', () async {
      final result = await generator.generate(['nonexistent']);

      expect(result, isEmpty);
    });

    test('максимум 3 упражнения в результате', () async {
      final result = await generator.generate(['posture']);

      expect(result.length, lessThanOrEqualTo(3));
    });

    test('не повторяет упражнения из последней тренировки', () async {
      final first = await generator.generate(['neck']);
      expect(first.length, 3);
      final firstIds = first.map((e) => e.id).toSet();

      final second = await generator.generate(['neck']);
      expect(second.length, 3);
    });

    test('сохраняет ID последней тренировки в SharedPreferences', () async {
      final result = await generator.generate(['neck']);
      expect(result, isNotEmpty);

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('last_workout_ids');
      expect(saved, isNotNull);
      expect(saved!.length, result.length);
    });

    test('несколько проблем комбинируют категории', () async {
      final result = await generator.generate(['neck', 'stress']);

      expect(result, isNotEmpty);
      expect(result.length, 3);
    });

    test(
      'если все упражнения в категории были в прошлой тренировке — берёт из used',
      () async {
        when(() => mockRepo.exercisesByCategory('eyes')).thenAnswer(
          (_) async => [
            const Exercise(
              id: 'eyes_01',
              categoryId: 'eyes',
              type: HealthType.physical,
              title: 'Моргание',
              description: 'Описание',
              defaultDurationSec: 40,
            ),
          ],
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('last_workout_ids', ['eyes_01']);

        final result = await generator.generate(['eyes']);

        expect(result.length, 1);
        expect(result.first.id, 'eyes_01');
      },
    );
  });
}
