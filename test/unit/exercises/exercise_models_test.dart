import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';

void main() {
  group('Exercise', () {
    test('создание с корректными данными', () {
      const exercise = Exercise(
        id: 'test_01',
        categoryId: 'neck',
        type: HealthType.physical,
        title: 'Тестовое упражнение',
        description: 'Описание тестового упражнения',
        defaultDurationSec: 40,
      );

      expect(exercise.id, 'test_01');
      expect(exercise.categoryId, 'neck');
      expect(exercise.type, HealthType.physical);
      expect(exercise.title, 'Тестовое упражнение');
      expect(exercise.description, 'Описание тестового упражнения');
      expect(exercise.defaultDurationSec, 40);
    });

    test('создание mental упражнения', () {
      const exercise = Exercise(
        id: 'relax_01',
        categoryId: 'relaxation',
        type: HealthType.mental,
        title: 'Медленное дыхание',
        description: 'Описание',
        defaultDurationSec: 60,
      );

      expect(exercise.type, HealthType.mental);
      expect(exercise.defaultDurationSec, 60);
    });

    test('immutability — @immutable аннотация', () {
      const e1 = Exercise(
        id: 'a',
        categoryId: 'b',
        type: HealthType.physical,
        title: 'T',
        description: 'D',
        defaultDurationSec: 30,
      );
      expect(e1.id, 'a');
    });
  });

  group('ExerciseCategory', () {
    test('создание с корректными данными', () {
      const category = ExerciseCategory(
        id: 'neck',
        title: 'Шея',
        type: HealthType.physical,
        order: 1,
      );

      expect(category.id, 'neck');
      expect(category.title, 'Шея');
      expect(category.type, HealthType.physical);
      expect(category.order, 1);
    });

    test('order по умолчанию = 0', () {
      const category = ExerciseCategory(
        id: 'test',
        title: 'Test',
        type: HealthType.mental,
      );
      expect(category.order, 0);
    });

    test('mental тип категории', () {
      const category = ExerciseCategory(
        id: 'relaxation',
        title: 'Снятие напряжения',
        type: HealthType.mental,
        order: 1,
      );
      expect(category.type, HealthType.mental);
    });
  });

  group('HealthType', () {
    test('имеет два значения', () {
      expect(HealthType.values.length, 2);
      expect(HealthType.values, contains(HealthType.physical));
      expect(HealthType.values, contains(HealthType.mental));
    });
  });
}
