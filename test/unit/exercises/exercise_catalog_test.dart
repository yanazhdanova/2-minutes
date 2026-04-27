import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/exercises/data/exercise_catalog.dart';

void main() {
  group('exerciseCategories (каталог)', () {
    test('содержит 7 категорий', () {
      expect(exerciseCategories.length, 7);
    });

    test('4 physical категории', () {
      final physical = exerciseCategories.where(
        (c) => c.type == HealthType.physical,
      );
      expect(physical.length, 4);
    });

    test('3 mental категории', () {
      final mental = exerciseCategories.where(
        (c) => c.type == HealthType.mental,
      );
      expect(mental.length, 3);
    });

    test('все ID уникальны', () {
      final ids = exerciseCategories.map((c) => c.id).toSet();
      expect(ids.length, exerciseCategories.length);
    });

    test('все order > 0', () {
      for (final cat in exerciseCategories) {
        expect(cat.order, greaterThan(0), reason: '${cat.id} order = 0');
      }
    });
  });

  group('exercises (каталог)', () {
    test('содержит 24 упражнения', () {
      expect(exercises.length, 24);
    });

    test('все ID уникальны', () {
      final ids = exercises.map((e) => e.id).toSet();
      expect(ids.length, exercises.length);
    });

    test('все categoryId существуют в категориях', () {
      final catIds = exerciseCategories.map((c) => c.id).toSet();
      for (final ex in exercises) {
        expect(
          catIds,
          contains(ex.categoryId),
          reason: '${ex.id} → ${ex.categoryId} не существует',
        );
      }
    });

    test('все defaultDurationSec > 0', () {
      for (final ex in exercises) {
        expect(ex.defaultDurationSec, greaterThan(0));
      }
    });

    test('все упражнения имеют непустые title', () {
      for (final ex in exercises) {
        expect(ex.title, isNotEmpty, reason: '${ex.id} имеет пустой title');
      }
    });

    test('все упражнения имеют непустые description', () {
      for (final ex in exercises) {
        expect(
          ex.description,
          isNotEmpty,
          reason: '${ex.id} имеет пустой description',
        );
      }
    });

    test('тип упражнения соответствует типу категории', () {
      final catTypeMap = {for (final c in exerciseCategories) c.id: c.type};
      for (final ex in exercises) {
        expect(
          ex.type,
          catTypeMap[ex.categoryId],
          reason: '${ex.id} тип не совпадает с категорией ${ex.categoryId}',
        );
      }
    });
  });

  group('exerciseRepository (предварительно собранный)', () {
    test('создан корректно', () {
      expect(exerciseRepository, isNotNull);
      expect(exerciseRepository.categories, exerciseCategories);
      expect(exerciseRepository.exercises, exercises);
    });
  });
}
