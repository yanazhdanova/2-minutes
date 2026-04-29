import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/exercises/data/exercise_catalog.dart';

/// Edge cases для моделей упражнений и каталога.
void main() {
  group('Exercise catalog — целостность данных', () {
    test('все упражнения ссылаются на существующие категории', () {
      final catIds = exerciseCategories.map((c) => c.id).toSet();
      for (final ex in exercises) {
        expect(
          catIds,
          contains(ex.categoryId),
          reason:
              'Exercise "${ex.id}" references unknown category "${ex.categoryId}"',
        );
      }
    });

    test('тип упражнения совпадает с типом категории', () {
      final catMap = {for (final c in exerciseCategories) c.id: c.type};
      for (final ex in exercises) {
        expect(
          ex.type,
          catMap[ex.categoryId],
          reason:
              'Exercise "${ex.id}" type ${ex.type} != category type ${catMap[ex.categoryId]}',
        );
      }
    });

    test('все id уникальны среди упражнений', () {
      final ids = exercises.map((e) => e.id).toList();
      expect(
        ids.toSet().length,
        ids.length,
        reason: 'Duplicate exercise IDs found',
      );
    });

    test('все id уникальны среди категорий', () {
      final ids = exerciseCategories.map((c) => c.id).toList();
      expect(
        ids.toSet().length,
        ids.length,
        reason: 'Duplicate category IDs found',
      );
    });

    test('все упражнения имеют непустой title и description', () {
      for (final ex in exercises) {
        expect(
          ex.title,
          isNotEmpty,
          reason: 'Exercise "${ex.id}" has empty title',
        );
        expect(
          ex.description,
          isNotEmpty,
          reason: 'Exercise "${ex.id}" has empty description',
        );
      }
    });

    test('все упражнения имеют defaultDurationSec > 0', () {
      for (final ex in exercises) {
        expect(
          ex.defaultDurationSec,
          greaterThan(0),
          reason: 'Exercise "${ex.id}" has non-positive duration',
        );
      }
    });

    test('все категории имеют непустой title', () {
      for (final cat in exerciseCategories) {
        expect(
          cat.title,
          isNotEmpty,
          reason: 'Category "${cat.id}" has empty title',
        );
      }
    });

    test('есть категории обоих типов', () {
      final physCats = exerciseCategories.where(
        (c) => c.type == HealthType.physical,
      );
      final mentCats = exerciseCategories.where(
        (c) => c.type == HealthType.mental,
      );
      expect(physCats, isNotEmpty, reason: 'No physical categories found');
      expect(mentCats, isNotEmpty, reason: 'No mental categories found');
    });
  });

  group('HealthType — edge cases', () {
    test('enum values содержит physical и mental', () {
      expect(HealthType.values.length, 2);
    });

    test('toString корректный', () {
      expect(HealthType.physical.name, 'physical');
      expect(HealthType.mental.name, 'mental');
    });
  });
}
