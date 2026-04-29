import '../../domain/exercise_models.dart';

/// Конвертирует HealthType в строку для хранения в SQLite столбце type.
/// @param t Тип здоровья.
/// @return 'physical' или 'mental'.
String healthTypeToDb(HealthType t) =>
    t == HealthType.physical ? 'physical' : 'mental';
/// Конвертирует строку из SQLite столбца type обратно в HealthType.
/// @param s Строка из БД ('physical' или 'mental').
/// @return Соответствующее значение HealthType.
HealthType healthTypeFromDb(String s) =>
    (s == 'physical') ? HealthType.physical : HealthType.mental;
/// Конвертирует ExerciseCategory в Map для вставки в таблицу exercise_categories.
/// Поле order маппится в 'ord' (order - зарезервированное слово SQL).
/// @param c Категория упражнений.
/// @return Map с ключами id, title, type, ord.
Map<String, Object?> categoryToMap(ExerciseCategory c) => {
  'id': c.id,
  'title': c.title,
  'type': healthTypeToDb(c.type),
  'ord': c.order,
};

/// Создаёт ExerciseCategory из Map, полученного из SQLite-запроса.
/// Поле 'ord' маппится в order (0 по умолчанию, если null).
/// @param m Строка результата запроса.
/// @return Экземпляр ExerciseCategory.
ExerciseCategory categoryFromMap(Map<String, Object?> m) => ExerciseCategory(
  id: m['id'] as String,
  title: m['title'] as String,
  type: healthTypeFromDb(m['type'] as String),
  order: (m['ord'] as int?) ?? 0,
);

/// Конвертирует Exercise в Map для вставки в таблицу exercises.
/// categoryId маппится в 'category_id', defaultDurationSec - в 'default_duration_sec'.
/// @param e Упражнение.
/// @return Map с ключами id, category_id, type, title, description, default_duration_sec.
Map<String, Object?> exerciseToMap(Exercise e) => {
  'id': e.id,
  'category_id': e.categoryId,
  'type': healthTypeToDb(e.type),
  'title': e.title,
  'description': e.description,
  'default_duration_sec': e.defaultDurationSec,
};

/// Создаёт Exercise из Map, полученного из SQLite-запроса.
/// 'category_id' маппится в categoryId, 'default_duration_sec' - в defaultDurationSec.
/// @param m Строка результата запроса.
/// @return Экземпляр Exercise.
Exercise exerciseFromMap(Map<String, Object?> m) => Exercise(
  id: m['id'] as String,
  categoryId: m['category_id'] as String,
  type: healthTypeFromDb(m['type'] as String),
  title: m['title'] as String,
  description: m['description'] as String,
  defaultDurationSec: (m['default_duration_sec'] as int),
);
