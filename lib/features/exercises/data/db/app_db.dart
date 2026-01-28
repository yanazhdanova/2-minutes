import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDb {
  static final AppDb instance = AppDb._();
  AppDb._();

  static const _dbName = 'two_minutes.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get db async {
    final existing = _db;
    if (existing != null) return existing;

    final basePath = await getDatabasesPath();
    final path = p.join(basePath, _dbName);

    final database = await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (d) async {
        await d.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (d, version) async {
        await _createSchema(d);
      },
    );

    _db = database;
    return database;
  }

  Future<void> _createSchema(Database d) async {
    await d.execute('''
      CREATE TABLE exercise_categories (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        type TEXT NOT NULL,        -- 'physical' / 'mental'
        ord INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await d.execute('''
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        type TEXT NOT NULL,        -- 'physical' / 'mental'
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        default_duration_sec INTEGER NOT NULL,
        FOREIGN KEY(category_id) REFERENCES exercise_categories(id)
          ON UPDATE CASCADE
          ON DELETE RESTRICT
      );
    ''');

    await d.execute('CREATE INDEX idx_exercises_category ON exercises(category_id);');
    await d.execute('CREATE INDEX idx_exercises_type ON exercises(type);');
  }

  Future<void> close() async {
    final d = _db;
    _db = null;
    if (d != null) await d.close();
  }
}
