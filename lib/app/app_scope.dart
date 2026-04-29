import 'package:flutter/widgets.dart';
import '../features/exercises/data/exercise_sqlite_repository.dart';
import '../features/exercises/data/prefs_service.dart';
import '../features/user/user_data_service.dart';

/// Корневой InheritedWidget, предоставляющий доступ к глобальным зависимостям
/// (репозиторий упражнений, настройки устройства и данные пользователя) всему дереву виджетов.
/// Размещается в MyApp выше MaterialApp, чтобы быть доступным на любом экране.
/// Пересобирает зависимые виджеты только при смене ссылок на зависимости.
class AppScope extends InheritedWidget {
  /// SQLite-репозиторий для CRUD-операций с упражнениями и категориями.
  final ExerciseSqliteRepository exerciseRepo;
  /// Сервис настроек устройства (язык, тема, акцент, уведомления).
  final PrefsService prefs;
  /// Сервис пользовательских данных в Firestore (профиль, избранное, статистика).
  final UserDataService userData;

  const AppScope({
    super.key,
    required this.exerciseRepo,
    required this.prefs,
    required this.userData,
    required super.child,
  });

  /// Получает ближайший AppScope из контекста и подписывает виджет на обновления.
  /// @param context BuildContext вызывающего виджета.
  /// @return Экземпляр AppScope с exerciseRepo, prefs и userData.
  /// @throws AssertionError если AppScope не найден в дереве виджетов.
  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope old) =>
      old.exerciseRepo != exerciseRepo ||
      old.prefs != prefs ||
      old.userData != userData;
}
