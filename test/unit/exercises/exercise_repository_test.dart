import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/exercises/data/exercise_repository.dart';
import 'package:two_mins/features/exercises/data/exercise_catalog.dart';

void main() {
  late ExerciseRepository repo;

  setUp(() {
    repo = const ExerciseRepository(
      categories: exerciseCategories,
      exercises: exercises,
    );
  });

  group('categoriesByType', () {
    test('возвращает только physical категории', () {
      final physical = repo.categoriesByType(HealthType.physical);

      expect(physical, isNotEmpty);
      for (final cat in physical) {
        expect(cat.type, HealthType.physical);
      }
    });

    test('возвращает только mental категории', () {
      final mental = repo.categoriesByType(HealthType.mental);

      expect(mental, isNotEmpty);
      for (final cat in mental) {
        expect(cat.type, HealthType.mental);
      }
    });

    test('physical категории отсортированы по order', () {
      final physical = repo.categoriesByType(HealthType.physical);

      for (int i = 1; i < physical.length; i++) {
        expect(physical[i].order, greaterThanOrEqualTo(physical[i - 1].order));
      }
    });

    test('mental категории отсортированы по order', () {
      final mental = repo.categoriesByType(HealthType.mental);

      for (int i = 1; i < mental.length; i++) {
        expect(mental[i].order, greaterThanOrEqualTo(mental[i - 1].order));
      }
    });

    test('physical содержит neck, shoulders_arms, back_lower, eyes', () {
      final ids = repo
          .categoriesByType(HealthType.physical)
          .map((c) => c.id)
          .toList();

      expect(ids, contains('neck'));
      expect(ids, contains('shoulders_arms'));
      expect(ids, contains('back_lower'));
      expect(ids, contains('eyes'));
    });

    test('mental содержит relaxation, attention_switch, emotional_balance', () {
      final ids = repo
          .categoriesByType(HealthType.mental)
          .map((c) => c.id)
          .toList();

      expect(ids, contains('relaxation'));
      expect(ids, contains('attention_switch'));
      expect(ids, contains('emotional_balance'));
    });
  });

  group('exercisesByCategory', () {
    test('возвращает упражнения для neck', () {
      final neckExercises = repo.exercisesByCategory('neck');

      expect(neckExercises, isNotEmpty);
      for (final e in neckExercises) {
        expect(e.categoryId, 'neck');
      }
    });

    test('возвращает упражнения для relaxation', () {
      final relaxExercises = repo.exercisesByCategory('relaxation');

      expect(relaxExercises, isNotEmpty);
      for (final e in relaxExercises) {
        expect(e.categoryId, 'relaxation');
      }
    });

    test('пустой результат для несуществующей категории', () {
      final result = repo.exercisesByCategory('nonexistent');
      expect(result, isEmpty);
    });

    test('каждая категория имеет хотя бы 1 упражнение', () {
      for (final cat in exerciseCategories) {
        final ex = repo.exercisesByCategory(cat.id);
        expect(ex, isNotEmpty, reason: '${cat.id} должна иметь упражнения');
      }
    });
  });

  group('exerciseById', () {
    test('возвращает упражнение по ID', () {
      final exercise = repo.exerciseById('neck_01');

      expect(exercise, isNotNull);
      expect(exercise!.id, 'neck_01');
      expect(exercise.title, 'Наклоны головы вправо и влево');
    });

    test('возвращает null для несуществующего ID', () {
      final exercise = repo.exerciseById('nonexistent');
      expect(exercise, isNull);
    });

    test('находит mental упражнение', () {
      final exercise = repo.exerciseById('relax_01');

      expect(exercise, isNotNull);
      expect(exercise!.type, HealthType.mental);
    });
  });

  group('пустой репозиторий', () {
    test('пустой список категорий и упражнений', () {
      const emptyRepo = ExerciseRepository(categories: [], exercises: []);

      expect(emptyRepo.categoriesByType(HealthType.physical), isEmpty);
      expect(emptyRepo.categoriesByType(HealthType.mental), isEmpty);
      expect(emptyRepo.exercisesByCategory('any'), isEmpty);
      expect(emptyRepo.exerciseById('any'), isNull);
    });
  });
}
