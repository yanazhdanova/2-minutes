import 'package:sqflite/sqflite.dart';
import '../domain/exercise_models.dart';
import 'db/app_db.dart';
import 'db/mappers.dart';

class ExerciseSqliteRepository {
  final AppDb _db;

  const ExerciseSqliteRepository(this._db);

  Future<List<ExerciseCategory>> categoriesByType(HealthType type) async {
    final Database d = await _db.db;
    final rows = await d.query(
      'exercise_categories',
      where: 'type = ?',
      whereArgs: [healthTypeToDb(type)],
      orderBy: 'ord ASC',
    );
    return rows.map(categoryFromMap).toList();
  }

  Future<List<Exercise>> exercisesByCategory(String categoryId) async {
    final Database d = await _db.db;
    final rows = await d.query(
      'exercises',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'title ASC',
    );
    return rows.map(exerciseFromMap).toList();
  }

  Future<Exercise?> exerciseById(String id) async {
    final Database d = await _db.db;
    final rows = await d.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return exerciseFromMap(rows.first);
  }

  /// Проверка: пустая ли база (для сидинга)
  Future<bool> isEmpty() async {
    final Database d = await _db.db;
    final res = await d.rawQuery('SELECT COUNT(*) AS cnt FROM exercises;');
    final cnt = (res.first['cnt'] as int?) ?? 0;
    return cnt == 0;
  }

  /// Первичное заполнение (один раз)
  Future<void> seed({
    required List<ExerciseCategory> categories,
    required List<Exercise> exercises,
  }) async {
    final Database d = await _db.db;

    await d.transaction((txn) async {
      for (final c in categories) {
        await txn.insert(
          'exercise_categories',
          categoryToMap(c),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      for (final e in exercises) {
        await txn.insert(
          'exercises',
          exerciseToMap(e),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
