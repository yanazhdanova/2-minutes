import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/exercises/data/exercise_catalog.dart';

void main() {
  const physicalCategoryIds = {
    'neck',
    'shoulders_arms',
    'back_lower',
    'eyes',
    'wrists_hands',
    'legs_feet',
    'posture_alignment',
  };

  const mentalCategoryIds = {
    'relaxation',
    'attention_switch',
    'emotional_balance',
    'breathing',
  };

  group('exerciseCategories (каталог)', () {
    test('содержит ожидаемые physical категории', () {
      final physicalIds = exerciseCategories
          .where((c) => c.type == HealthType.physical)
          .map((c) => c.id)
          .toSet();

      expect(physicalIds, physicalCategoryIds);
    });

    test('содержит ожидаемые mental категории', () {
      final mentalIds = exerciseCategories
          .where((c) => c.type == HealthType.mental)
          .map((c) => c.id)
          .toSet();

      expect(mentalIds, mentalCategoryIds);
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

    test('order уникален внутри каждого типа', () {
      for (final type in HealthType.values) {
        final orders = exerciseCategories
            .where((c) => c.type == type)
            .map((c) => c.order)
            .toList();

        expect(orders.toSet().length, orders.length, reason: '$type');
      }
    });
  });

  group('exercises (каталог)', () {
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

    test('каждая категория содержит хотя бы одно упражнение', () {
      for (final category in exerciseCategories) {
        expect(
          exercises.where((e) => e.categoryId == category.id),
          isNotEmpty,
          reason: '${category.id} не содержит упражнений',
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
