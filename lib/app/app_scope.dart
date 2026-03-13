import 'package:flutter/widgets.dart';
import '../features/exercises/data/exercise_sqlite_repository.dart';

class AppScope extends InheritedWidget {
  final ExerciseSqliteRepository exerciseRepo;

  const AppScope({
    super.key,
    required this.exerciseRepo,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      oldWidget.exerciseRepo != exerciseRepo;
}
