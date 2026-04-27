import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/exercise_models.dart';
import 'exercise_sqlite_repository.dart';

/**
Маппинг проблема → категории упражнений. Ключ - идентификатор проблемной зоны
(совпадает с выбором на экране онбординга), значение - список ID категорий,
из которых будут подбираться упражнения. Одна проблема может маппиться
на несколько категорий (например, posture → neck + shoulders_arms + back_lower).
*/
const _problemToCategories = <String, List<String>>{
  'posture': ['neck', 'shoulders_arms', 'back_lower'],
  'back': ['back_lower'],
  'neck': ['neck'],
  'eyes': ['eyes'],
  'stress': ['relaxation', 'emotional_balance'],
  'focus': ['attention_switch'],
  'energy': ['shoulders_arms', 'relaxation'],
  'sleep': ['relaxation', 'emotional_balance'],
};

const _keyLastWorkout = 'last_workout_ids';

/**
Генератор тренировки. Подбирает до 3 упражнений на основе выбранных проблемных зон
пользователя. Алгоритм: маппит проблемы - категории, собирает пул упражнений,
приоритизирует те, которых не было в прошлой тренировке (хранятся в SharedPreferences),
перемешивает случайным образом и берёт первые 3. Сохраняет ID выбранных упражнений
для дедупликации в следующий раз.
*/
class WorkoutGenerator {
  final ExerciseSqliteRepository _repo;
  final Random _rng = Random();

  WorkoutGenerator(this._repo);

  /**
  Генерирует тренировку из до 3 упражнений.
  Алгоритм:
  1. Маппит selectedProblems → множество ID категорий через _problemToCategories.
  2. Загружает все упражнения из этих категорий через репозиторий.
  3. Разделяет пул на «свежие» (не использовались в прошлой тренировке) и «использованные».
  4. Перемешивает оба списка случайным образом и заполняет результат:
     сначала из свежих, затем из использованных - до 3 штук.
  5. Сохраняет ID выбранных упражнений в SharedPreferences для дедупликации.
  @param selectedProblems Список выбранных проблем (ключи из _problemToCategories, например ['neck', 'stress']).
  @return Список из 0–3 упражнений. Пустой, если проблемы не маппятся на категории или пул пуст.
  */
  Future<List<Exercise>> generate(List<String> selectedProblems) async {
    final categoryIds = <String>{};
    for (final problem in selectedProblems) {
      final cats = _problemToCategories[problem];
      if (cats != null) categoryIds.addAll(cats);
    }

    if (categoryIds.isEmpty) return [];

    final pool = <Exercise>[];
    for (final catId in categoryIds) {
      pool.addAll(await _repo.exercisesByCategory(catId));
    }

    if (pool.isEmpty) return [];
    final lastIds = await _getLastWorkoutIds();

    final fresh = pool.where((e) => !lastIds.contains(e.id)).toList();
    final used = pool.where((e) => lastIds.contains(e.id)).toList();

    final result = <Exercise>[];
    fresh.shuffle(_rng);
    used.shuffle(_rng);

    for (final e in fresh) {
      if (result.length >= 3) break;
      result.add(e);
    }
    for (final e in used) {
      if (result.length >= 3) break;
      result.add(e);
    }

    await _saveLastWorkoutIds(result.map((e) => e.id).toList());

    return result;
  }

  Future<List<String>> _getLastWorkoutIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyLastWorkout) ?? [];
  }

  Future<void> _saveLastWorkoutIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyLastWorkout, ids);
  }
}
