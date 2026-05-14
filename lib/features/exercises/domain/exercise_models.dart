import 'package:flutter/foundation.dart';

/// Тип здоровья: physical - физические упражнения (разминка, растяжка), mental - ментальные (дыхание, концентрация). Используется для фильтрации категорий и упражнений в каталоге.
enum HealthType { physical, mental }

@immutable
/// Категория упражнений (например, «Шея», «Глаза»). Иммутабельная.
/// Каждая категория принадлежит одному типу здоровья и имеет порядок отображения.
/// Используется для группировки упражнений в каталоге и при генерации тренировки.
class ExerciseCategory {

  final String id;
  final String title;
  final HealthType type;
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
  /// Название упражнения на русском.
  final String title;
  /// Текстовое описание техники выполнения на русском.
  final String description;
  /// Название упражнения на английском.
  final String titleEn;
  /// Описание техники выполнения на английском.
  final String descriptionEn;
  /// Длительность по умолчанию в секундах, используется таймером на ExerciseScreen.
  final int defaultDurationSec;
  const Exercise({
    required this.id,
    required this.categoryId,
    required this.type,
    required this.title,
    required this.description,
    this.titleEn = '',
    this.descriptionEn = '',
    required this.defaultDurationSec,
  });

  /// Возвращает локализованное название: английское для en, русское для остальных.
  String localizedTitle(String langCode) =>
      (langCode == 'en' && titleEn.isNotEmpty) ? titleEn : title;

  /// Возвращает локализованное описание: английское для en, русское для остальных.
  String localizedDescription(String langCode) =>
      (langCode == 'en' && descriptionEn.isNotEmpty) ? descriptionEn : description;
}
