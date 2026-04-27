import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/exercises/data/db/mappers.dart';

void main() {
  group('healthTypeToDb / healthTypeFromDb', () {
    test('physical -> "physical"', () {
      expect(healthTypeToDb(HealthType.physical), 'physical');
    });

    test('mental -> "mental"', () {
      expect(healthTypeToDb(HealthType.mental), 'mental');
    });

    test('"physical" -> HealthType.physical', () {
      expect(healthTypeFromDb('physical'), HealthType.physical);
    });

    test('"mental" -> HealthType.mental', () {
      expect(healthTypeFromDb('mental'), HealthType.mental);
    });

    test('неизвестная строка -> HealthType.mental (fallback)', () {
      expect(healthTypeFromDb('unknown'), HealthType.mental);
    });
  });

  group('categoryToMap / categoryFromMap', () {
    test('round-trip для ExerciseCategory', () {
      const category = ExerciseCategory(
        id: 'neck',
        title: 'Шея',
        type: HealthType.physical,
        order: 1,
      );

      final map = categoryToMap(category);
      expect(map['id'], 'neck');
      expect(map['title'], 'Шея');
      expect(map['type'], 'physical');
      expect(map['ord'], 1);

      final restored = categoryFromMap(map);
      expect(restored.id, category.id);
      expect(restored.title, category.title);
      expect(restored.type, category.type);
      expect(restored.order, category.order);
    });

    test('categoryFromMap с отсутствующим ord -> 0', () {
      final map = {
        'id': 'test',
        'title': 'Test',
        'type': 'mental',
        'ord': null,
      };
      final cat = categoryFromMap(map);
      expect(cat.order, 0);
    });
  });

  group('exerciseToMap / exerciseFromMap', () {
    test('round-trip для Exercise', () {
      const exercise = Exercise(
        id: 'neck_01',
        categoryId: 'neck',
        type: HealthType.physical,
        title: 'Наклоны головы',
        description: 'Описание',
        defaultDurationSec: 40,
      );

      final map = exerciseToMap(exercise);
      expect(map['id'], 'neck_01');
      expect(map['category_id'], 'neck');
      expect(map['type'], 'physical');
      expect(map['title'], 'Наклоны головы');
      expect(map['description'], 'Описание');
      expect(map['default_duration_sec'], 40);

      final restored = exerciseFromMap(map);
      expect(restored.id, exercise.id);
      expect(restored.categoryId, exercise.categoryId);
      expect(restored.type, exercise.type);
      expect(restored.title, exercise.title);
      expect(restored.description, exercise.description);
      expect(restored.defaultDurationSec, exercise.defaultDurationSec);
    });

    test('mental exercise round-trip', () {
      const exercise = Exercise(
        id: 'relax_01',
        categoryId: 'relaxation',
        type: HealthType.mental,
        title: 'Дыхание',
        description: 'Описание',
        defaultDurationSec: 60,
      );

      final map = exerciseToMap(exercise);
      expect(map['type'], 'mental');

      final restored = exerciseFromMap(map);
      expect(restored.type, HealthType.mental);
    });
  });
}
