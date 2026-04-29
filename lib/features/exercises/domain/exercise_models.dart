import 'package:flutter/foundation.dart';

/// Тип здоровья: physical - физические упражнения (разминка, растяжка), mental - ментальные (дыхание, концентрация). Используется для фильтрации категорий и упражнений в каталоге.
enum HealthType { physical, mental }

@immutable
/// Категория упражнений (например, «Шея», «Глаза»). Иммутабельная.
/// Каждая категория принадлежит одному типу здоровья и имеет порядок отображения.
/// Используется для группировки упражнений в каталоге и при генерации тренировки.
class ExerciseCategory {
  /// Уникальный идентификатор категории (neck, eyes, relaxation и др.).
  final String id;
  /// Название категории на русском (для БД; для UI используется Tr.categoryTitle).
  final String title;
  /// Тип здоровья, к которому относится категория.
  final HealthType type;
  /// Порядок отображения в списке (по возрастанию).
  final int order;
  const ExerciseCategory({
    required this.id,
    required this.title,
    required this.type,
    this.order = 0,
  });
}

@immutable
/// Упражнение с названием, описанием, длительностью и привязкой к категории.
/// Иммутабельное. Хранится в SQLite таблице exercises.
/// Используется на экранах каталога, выбора упражнений и выполнения тренировки.
class Exercise {
  /// Уникальный идентификатор упражнения.
  final String id;
  /// ID категории, к которой принадлежит упражнение (FK - exercise_categories.id).
  final String categoryId;
  /// Тип здоровья (дублирует тип категории для ускорения запросов).
  final HealthType type;
  /// Название упражнения, отображаемое в UI.
  final String title;
  /// Текстовое описание техники выполнения.
  final String description;
  /// Длительность по умолчанию в секундах, используется таймером на ExerciseScreen.
  final int defaultDurationSec;
  const Exercise({
    required this.id,
    required this.categoryId,
    required this.type,
    required this.title,
    required this.description,
    required this.defaultDurationSec,
  });
}
