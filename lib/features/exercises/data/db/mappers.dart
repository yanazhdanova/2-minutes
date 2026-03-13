import '../../domain/exercise_models.dart';

String healthTypeToDb(HealthType t) => t == HealthType.physical ? 'physical' : 'mental';

HealthType healthTypeFromDb(String s) =>
    (s == 'physical') ? HealthType.physical : HealthType.mental;

Map<String, Object?> categoryToMap(ExerciseCategory c) => {
  'id': c.id,
  'title': c.title,
  'type': healthTypeToDb(c.type),
  'ord': c.order,
};

ExerciseCategory categoryFromMap(Map<String, Object?> m) => ExerciseCategory(
  id: m['id'] as String,
  title: m['title'] as String,
  type: healthTypeFromDb(m['type'] as String),
  order: (m['ord'] as int?) ?? 0,
);

Map<String, Object?> exerciseToMap(Exercise e) => {
  'id': e.id,
  'category_id': e.categoryId,
  'type': healthTypeToDb(e.type),
  'title': e.title,
  'description': e.description,
  'default_duration_sec': e.defaultDurationSec,
};

Exercise exerciseFromMap(Map<String, Object?> m) => Exercise(
  id: m['id'] as String,
  categoryId: m['category_id'] as String,
  type: healthTypeFromDb(m['type'] as String),
  title: m['title'] as String,
  description: m['description'] as String,
  defaultDurationSec: (m['default_duration_sec'] as int),
);
