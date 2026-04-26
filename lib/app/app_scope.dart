import 'package:flutter/widgets.dart';
import '../features/exercises/data/exercise_sqlite_repository.dart';
import '../features/exercises/data/prefs_service.dart';

class AppScope extends InheritedWidget {
  final ExerciseSqliteRepository exerciseRepo;
  final PrefsService prefs;

  const AppScope({
    super.key,
    required this.exerciseRepo,
    required this.prefs,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope old) =>
      old.exerciseRepo != exerciseRepo || old.prefs != prefs;
}
