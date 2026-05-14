import 'package:sqflite/sqflite.dart';
import '../domain/exercise_models.dart';
import 'db/app_db.dart';
import 'db/mappers.dart';

/// Репозиторий упражнений на базе SQLite - основной источник данных в приложении.
/// Все методы асинхронные, так как обращаются к БД через sqflite.
/// Используется во всех экранах каталога, выбора и генерации тренировки.
/// При первом запуске заполняется данными из exercise_catalog.dart через seed().
class ExerciseSqliteRepository {
  final AppDb _db;
  const ExerciseSqliteRepository(this._db);

  /// Возвращает категории указанного типа из БД, отсортированные по порядку.
  /// @param type Тип здоровья (physical/mental)
  /// @return Список категорий
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

  /// Загружает упражнения из БД по ID категории, отсортированные по названию.
  /// @param categoryId ID категории
  /// @return Список упражнений
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

  /// Находит упражнение по уникальному идентификатору. Запрос с LIMIT 1.
  /// @param id Идентификатор упражнения.
  /// @return Упражнение или null, если не найдено.
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

  /// Проверяет, пуста ли таблица exercises. Используется при запуске в main()
  /// для определения необходимости первоначального заполнения БД данными каталога.
  /// @return true если в таблице 0 записей.
  Future<bool> isEmpty() async {
    final Database d = await _db.db;
    final res = await d.rawQuery('SELECT COUNT(*) AS cnt FROM exercises;');
    return ((res.first['cnt'] as int?) ?? 0) == 0;
  }

  /// Заполняет БД начальными данными из каталога. Все вставки выполняются
  /// в одной транзакции для атомарности. При конфликте ID обновляет существующую
  /// запись, а записи, удалённые из каталога, чистит из БД.
  /// @param categories Список категорий для вставки.
  /// @param exercises Список упражнений для вставки.
  Future<void> seed({
    required List<ExerciseCategory> categories,
    required List<Exercise> exercises,
  }) async {
    final Database d = await _db.db;
    await d.transaction((txn) async {
      for (final c in categories) {
        final values = categoryToMap(c);
        await txn.insert(
          'exercise_categories',
          values,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        await txn.update(
          'exercise_categories',
          values,
          where: 'id = ?',
          whereArgs: [c.id],
        );
      }
      for (final e in exercises) {
        final values = exerciseToMap(e);
        await txn.insert(
          'exercises',
          values,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        // На апдейте не перезаписываем default_duration_sec, чтобы
        // сохранить значение, которое пользователь изменил в каталоге.
        final updateValues = Map<String, Object?>.from(values)
          ..remove('default_duration_sec');
        await txn.update(
          'exercises',
          updateValues,
          where: 'id = ?',
          whereArgs: [e.id],
        );
      }

      await _deleteStaleCatalogRows(
        txn: txn,
        categoryIds: categories.map((c) => c.id).toSet(),
        exerciseIds: exercises.map((e) => e.id).toSet(),
      );
    });
  }

  Future<void> _deleteStaleCatalogRows({
    required Transaction txn,
    required Set<String> categoryIds,
    required Set<String> exerciseIds,
  }) async {
    await _deleteRowsNotIn(
      txn: txn,
      table: 'exercises',
      column: 'id',
      ids: exerciseIds,
    );
    await _deleteRowsNotIn(
      txn: txn,
      table: 'exercise_categories',
      column: 'id',
      ids: categoryIds,
    );
  }

  Future<void> _deleteRowsNotIn({
    required Transaction txn,
    required String table,
    required String column,
    required Set<String> ids,
  }) {
    if (ids.isEmpty) return txn.delete(table);
    final placeholders = List.filled(ids.length, '?').join(', ');
    return txn.delete(
      table,
      where: '$column NOT IN ($placeholders)',
      whereArgs: ids.toList(),
    );
  }

  /// Обновляет длительность упражнения в БД (перманентно).
  /// Используется при изменении длительности из каталога/избранного.
  Future<void> updateDuration(String id, int durationSec) async {
    final Database d = await _db.db;
    await d.update(
      'exercises',
      {'default_duration_sec': durationSec},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
