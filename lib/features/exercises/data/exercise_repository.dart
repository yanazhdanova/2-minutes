import '../domain/exercise_models.dart';

/// In-memory репозиторий упражнений. Хранит категории и упражнения в списках в памяти.
/// Не используется в production - заменён на ExerciseSqliteRepository.
/// Сохранён для тестирования и как fallback.
class ExerciseRepository {
  final List<ExerciseCategory> categories;
  final List<Exercise> exercises;
  const ExerciseRepository({required this.categories, required this.exercises});

  /// Возвращает категории указанного типа, отсортированные по порядку.
  /// @param type Тип здоровья (physical/mental)
  /// @return Список категорий
  List<ExerciseCategory> categoriesByType(HealthType type) {
    final list = categories.where((c) => c.type == type).toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  /// Возвращает все упражнения, принадлежащие указанной категории.
  /// @param categoryId Идентификатор категории (например, 'neck').
  /// @return Список упражнений (может быть пустым).
  List<Exercise> exercisesByCategory(String categoryId) =>
      exercises.where((e) => e.categoryId == categoryId).toList();
  /// Находит упражнение по его уникальному идентификатору.
  /// @param id Идентификатор упражнения.
  /// @return Упражнение или null, если не найдено.
  Exercise? exerciseById(String id) {
    for (final e in exercises) {
      if (e.id == id) return e;
    }
    return null;
  }
}
