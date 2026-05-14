import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Сервис пользовательских данных на базе Firestore. Хранит профиль, избранное и статистику
/// в документе users/{uid}. Данные кэшируются в памяти (_cache) для синхронного доступа.
/// Сеттеры обновляют кэш мгновенно, а Firestore - асинхронно через merge-запись.
/// Firestore SDK автоматически кэширует данные локально для оффлайн-доступа.
///
/// Правила безопасности Firestore:
/// rules_version = '2';
/// service cloud.firestore {
/// match /databases/{database}/documents {
/// match /users/{userId} {
/// allow read, write: if request.auth != null && request.auth.uid == userId;
/// }
/// }
/// }
class UserDataService {
  /// Создаёт сервис. Принимает опциональные зависимости для тестирования.
  /// @param firestore экземпляр Firestore (по умолчанию `FirebaseFirestore.instance`).
  /// @param uidProvider функция, возвращающая uid текущего пользователя.
  UserDataService({
    FirebaseFirestore? firestore,
    String Function()? uidProvider,
    String Function()? emailProvider,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _uidProvider =
           uidProvider ?? (() => FirebaseAuth.instance.currentUser!.uid),
       _emailProvider =
           emailProvider ??
           (() => FirebaseAuth.instance.currentUser?.email ?? '');

  final FirebaseFirestore _firestore;
  final String Function() _uidProvider;
  final String Function() _emailProvider;
  Map<String, dynamic> _cache = {};
  bool _isNewUser = false;

  /// True если при последнем init() документа пользователя не было в Firestore
  /// (ни на сервере, ни в локальном кэше SDK) — значит, это первый вход.
  bool get isNewUser => _isNewUser;

  /// Ссылка на документ текущего пользователя в коллекции users.
  DocumentReference get _doc =>
      _firestore.collection('users').doc(_uidProvider());

  /// Дефолтные значения для нового пользователя.
  static Map<String, dynamic> get _defaults => {
    'userName': '',
    'gender': '',
    'selectedCategories': <String>[],
    'onboardingDone': false,
    'favoriteIds': <String>[],
    'stats': {
      'totalWorkouts': 0,
      'totalExercises': 0,
      'totalSeconds': 0,
      'streakDays': 0,
      'lastWorkoutDate': '',
    },
    'notifFrom': '09:00',
    'notifTo': '21:00',
    'notifFreq': '60',
    'notifDays': <int>[1, 2, 3, 4, 5, 6, 7],
    'themeMode': 'system',
    'accentColor': 'green',
    'languageCode': '',
    'exerciseCount': 3,
    'defaultExerciseDurationSec': 40,
  };

  /// Загружает документ пользователя из Firestore в кэш.
  /// Если документа нет - создаёт с дефолтными значениями.
  /// При сбое сети пробует локальный кэш Firestore SDK.
  /// Должен вызываться после успешной аутентификации.
  Future<void> init() async {
    debugPrint('[UserData] init() uid=${_uidProvider()}');

    // 1. Пробуем загрузить с сервера
    try {
      final snap = await _doc
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 10));
      debugPrint(
        '[UserData] server: exists=${snap.exists}, data=${snap.data()}',
      );
      if (snap.exists && snap.data() != null) {
        _cache = Map<String, dynamic>.from(snap.data()! as Map);
        _isNewUser = false;
        debugPrint(
          '[UserData] loaded from server: onboardingDone=$isOnboardingDone, userName=$userName',
        );
        return;
      }
      // Документа нет на сервере — новый пользователь
      debugPrint('[UserData] no document on server, creating defaults');
      _cache = _defaults;
      _isNewUser = true;
      _doc.set(_cache).ignore();
      return;
    } catch (e) {
      debugPrint('[UserData] server error: $e');
    }

    // 2. Фоллбэк: локальный кэш Firestore SDK
    try {
      final snap = await _doc.get(const GetOptions(source: Source.cache));
      debugPrint(
        '[UserData] cache: exists=${snap.exists}, data=${snap.data()}',
      );
      if (snap.exists && snap.data() != null) {
        _cache = Map<String, dynamic>.from(snap.data()! as Map);
        _isNewUser = false;
        debugPrint(
          '[UserData] loaded from cache: onboardingDone=$isOnboardingDone, userName=$userName',
        );
        return;
      }
    } catch (e) {
      debugPrint('[UserData] cache error: $e');
    }

    // 3. Ничего не удалось — дефолты (без записи в Firestore)
    debugPrint('[UserData] using defaults');
    if (_cache.isEmpty) _cache = _defaults;
  }

  /// Записывает поля в Firestore через merge, не перезаписывая документ целиком.
  /// Fire-and-forget: кэш уже обновлён до вызова, поэтому не ждём завершения записи.
  void _write(Map<String, dynamic> fields) {
    try {
      _doc.set(fields, SetOptions(merge: true)).ignore();
    } catch (_) {}
  }

  // ── Email ──

  /// Email текущего пользователя из FirebaseAuth.
  String get email => _emailProvider();

  // ── Имя пользователя ──

  /// Имя пользователя из кэша. Пустая строка по умолчанию.
  String get userName => (_cache['userName'] as String?) ?? '';

  /// Обновляет имя пользователя в кэше и Firestore.
  Future<void> setUserName(String n) async {
    _cache['userName'] = n;
    _write({'userName': n});
  }

  // ── Пол ──

  String get gender => (_cache['gender'] as String?) ?? '';

  void setGender(String v) {
    _cache['gender'] = v;
    _write({'gender': v});
  }

  // ── Онбординг ──

  /// Завершён ли онбординг (false по умолчанию).
  bool get isOnboardingDone => (_cache['onboardingDone'] as bool?) ?? false;

  /// Отмечает онбординг как завершённый или нет.
  Future<void> setOnboardingDone(bool v) async {
    _cache['onboardingDone'] = v;
    _write({'onboardingDone': v});
  }

  // ── Выбранные категории ──

  /// Список идентификаторов выбранных проблемных зон. Пустой по умолчанию.
  List<String> get selectedCategories =>
      List<String>.from((_cache['selectedCategories'] as List?) ?? []);

  /// Сохраняет список выбранных проблемных зон.
  Future<void> setSelectedCategories(List<String> c) async {
    _cache['selectedCategories'] = c;
    _write({'selectedCategories': c});
  }

  // ── Избранное ──

  /// Список идентификаторов избранных упражнений. Пустой по умолчанию.
  List<String> get favoriteIds =>
      List<String>.from((_cache['favoriteIds'] as List?) ?? []);

  /// Проверяет, находится ли упражнение в избранном.
  bool isFavorite(String exerciseId) => favoriteIds.contains(exerciseId);

  /// Переключает состояние избранного для упражнения.
  /// @param exerciseId Идентификатор упражнения.
  /// @return Новое состояние: true если добавлено, false если удалено.
  Future<bool> toggleFavorite(String exerciseId) async {
    final list = favoriteIds;
    final wasPresent = list.remove(exerciseId);
    if (!wasPresent) list.add(exerciseId);
    _cache['favoriteIds'] = list;
    _write({'favoriteIds': list});
    return !wasPresent;
  }

  /// Удаляет упражнение из избранного. Если его там нет - ничего не делает.
  Future<void> removeFavorite(String exerciseId) async {
    final list = favoriteIds;
    if (list.remove(exerciseId)) {
      _cache['favoriteIds'] = list;
      _write({'favoriteIds': list});
    }
  }

  // ── Настройки уведомлений ──

  String get notifFrom => (_cache['notifFrom'] as String?) ?? '09:00';
  String get notifTo => (_cache['notifTo'] as String?) ?? '21:00';
  String get notifFreq => (_cache['notifFreq'] as String?) ?? '60';

  List<int> get notifDays {
    final list = _cache['notifDays'];
    if (list == null) return [1, 2, 3, 4, 5, 6, 7];
    return (list as List).map((e) => (e as num).toInt()).toList();
  }

  void setNotifFrom(String v) {
    _cache['notifFrom'] = v;
    _write({'notifFrom': v});
  }

  void setNotifTo(String v) {
    _cache['notifTo'] = v;
    _write({'notifTo': v});
  }

  void setNotifFreq(String v) {
    _cache['notifFreq'] = v;
    _write({'notifFreq': v});
  }

  void setNotifDays(List<int> v) {
    _cache['notifDays'] = v;
    _write({'notifDays': v});
  }

  // ── Настройки оформления ──

  String get themeMode => (_cache['themeMode'] as String?) ?? 'system';
  String get accentColor => (_cache['accentColor'] as String?) ?? 'green';
  String get languageCode => (_cache['languageCode'] as String?) ?? '';

  void setThemeMode(String v) {
    _cache['themeMode'] = v;
    _write({'themeMode': v});
  }

  void setAccentColor(String v) {
    _cache['accentColor'] = v;
    _write({'accentColor': v});
  }

  void setLanguageCode(String v) {
    _cache['languageCode'] = v;
    _write({'languageCode': v});
  }

  // ── Количество упражнений ──

  /// Количество упражнений в одной тренировке (1–6, по умолчанию 3).
  int get exerciseCount => (_cache['exerciseCount'] as int?) ?? 3;

  /// Обновляет количество упражнений в кэше и Firestore.
  void setExerciseCount(int v) {
    _cache['exerciseCount'] = v;
    _write({'exerciseCount': v});
  }

  /// Длительность упражнения по умолчанию для запускаемых тренировок.
  int get defaultExerciseDurationSec =>
      (_cache['defaultExerciseDurationSec'] as int?) ?? 40;

  /// Обновляет длительность упражнения по умолчанию в кэше и Firestore.
  void setDefaultExerciseDurationSec(int v) {
    _cache['defaultExerciseDurationSec'] = v;
    _write({'defaultExerciseDurationSec': v});
  }

  // ── Статистика ──

  Map<String, dynamic> get _stats => Map<String, dynamic>.from(
    (_cache['stats'] as Map?) ?? _defaults['stats']!,
  );

  /// Общее количество завершённых тренировок.
  int get totalWorkouts => (_stats['totalWorkouts'] as int?) ?? 0;

  /// Общее количество выполненных упражнений.
  int get totalExercises => (_stats['totalExercises'] as int?) ?? 0;

  /// Общее количество секунд тренировок.
  int get totalSeconds => (_stats['totalSeconds'] as int?) ?? 0;

  /// Текущий streak (дни подряд с тренировкой).
  int get streakDays => (_stats['streakDays'] as int?) ?? 0;

  /// Записывает результат тренировки. Обновляет счётчики и streak.
  /// Streak-логика учитывает нерабочие дни (notifDays):
  /// - lastWorkoutDate == сегодня → streak не меняется
  /// - Между lastWorkoutDate и сегодня нет пропущенных рабочих дней → streak++
  /// - Есть пропущенный рабочий день → streak = 1
  /// @param exerciseCount Количество упражнений в тренировке.
  /// @param durationSeconds Суммарная длительность тренировки в секундах.
  Future<void> recordWorkout({
    required int exerciseCount,
    required int durationSeconds,
    DateTime? now,
  }) async {
    final stats = _stats;
    final today = now ?? DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final lastDate = (stats['lastWorkoutDate'] as String?) ?? '';

    int streak = (stats['streakDays'] as int?) ?? 0;
    if (lastDate != todayStr) {
      if (lastDate.isNotEmpty) {
        final last = DateTime.tryParse(lastDate);
        if (last != null) {
          final workingDays = notifDays;
          bool missedWorkingDay = false;
          DateTime check = DateTime(
            last.year,
            last.month,
            last.day,
          ).add(const Duration(days: 1));
          final todayMidnight = DateTime(today.year, today.month, today.day);
          while (check.isBefore(todayMidnight)) {
            if (workingDays.contains(check.weekday)) {
              missedWorkingDay = true;
              break;
            }
            check = check.add(const Duration(days: 1));
          }
          if (missedWorkingDay) {
            streak = 1;
          } else {
            streak++;
          }
        } else {
          streak = 1;
        }
      } else {
        streak = 1;
      }
    }

    stats['totalWorkouts'] = ((stats['totalWorkouts'] as int?) ?? 0) + 1;
    stats['totalExercises'] =
        ((stats['totalExercises'] as int?) ?? 0) + exerciseCount;
    stats['totalSeconds'] =
        ((stats['totalSeconds'] as int?) ?? 0) + durationSeconds;
    stats['streakDays'] = streak;
    stats['lastWorkoutDate'] = todayStr;

    _cache['stats'] = stats;
    _write({'stats': stats});
  }

  /// Сбрасывает документ пользователя к дефолтным значениям.
  Future<void> clearAll() async {
    _cache = _defaults;
    await _doc.set(_cache);
  }
}
