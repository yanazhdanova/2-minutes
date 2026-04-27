import 'package:flutter/widgets.dart';
import '../features/exercises/data/exercise_sqlite_repository.dart';
import '../features/exercises/data/prefs_service.dart';

/**
Корневой InheritedWidget, предоставляющий доступ к глобальным зависимостям
(репозиторий упражнений и сервис настроек) всему дереву виджетов.
Размещается в MyApp выше MaterialApp, чтобы быть доступным на любом экране.
Пересобирает зависимые виджеты только при смене ссылок на exerciseRepo или prefs.
*/
class AppScope extends InheritedWidget {
  /** SQLite-репозиторий для CRUD-операций с упражнениями и категориями. */
  final ExerciseSqliteRepository exerciseRepo;
  /** Сервис пользовательских настроек, обёрнутый поверх SharedPreferences. */
  final PrefsService prefs;

  const AppScope({
    super.key,
    required this.exerciseRepo,
    required this.prefs,
    required super.child,
  });

  /**
  Получает ближайший AppScope из контекста и подписывает виджет на обновления.
  @param context BuildContext вызывающего виджета.
  @return Экземпляр AppScope с exerciseRepo и prefs.
  @throws AssertionError если AppScope не найден в дереве виджетов.
  */
  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope old) =>
      old.exerciseRepo != exerciseRepo || old.prefs != prefs;
}
