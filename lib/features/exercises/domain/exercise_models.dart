import 'package:flutter/foundation.dart';

enum HealthType { physical, mental }

@immutable
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
class Exercise {
  final String id;
  final String categoryId;
  final HealthType type;
  final String title;
  final String description;
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
