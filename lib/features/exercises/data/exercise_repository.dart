import '../domain/exercise_models.dart';

class ExerciseRepository {
  final List<ExerciseCategory> categories;
  final List<Exercise> exercises;

  const ExerciseRepository({
    required this.categories,
    required this.exercises,
  });

  List<ExerciseCategory> categoriesByType(HealthType type) {
    final list = categories.where((c) => c.type == type).toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  List<Exercise> exercisesByCategory(String categoryId) {
    return exercises.where((e) => e.categoryId == categoryId).toList();
  }

  Exercise? exerciseById(String id) {
    for (final e in exercises) {
      if (e.id == id) return e;
    }
    return null;
  }
}
