import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/exercise_models.dart';
import 'exercise_sqlite_repository.dart';


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

class WorkoutGenerator {
  final ExerciseSqliteRepository _repo;
  final Random _rng = Random();

  WorkoutGenerator(this._repo);

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
