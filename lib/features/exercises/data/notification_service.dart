import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter/foundation.dart';
import 'prefs_service.dart';

/// Singleton-сервис для планирования локальных уведомлений о тренировках.
/// Управляет жизненным циклом flutter_local_notifications: инициализация,
/// запрос разрешений, создание еженедельного расписания на основе настроек пользователя.
/// Таймзона определяется эвристически через _guessTimeZone() по текущему UTC-смещению.
class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Инициализирует сервис: загружает базу таймзон, определяет локальную зону,
  /// настраивает плагин уведомлений для Android и iOS. повторные
  /// вызовы игнорируются благодаря флагу _initialized. Вызывается в main().
  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_guessTimeZone()));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onTap,
    );

    _initialized = true;
  }

  /// Запрашивает разрешение на отправку уведомлений. На iOS запрашивает alert, badge, sound.
  /// На Android запрашивает notification permission (Android 13+).
  /// На других платформах возвращает true.
  /// @return true если разрешение получено.
  Future<bool> requestPermission() async {
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? true;
    }

    return true;
  }

  /// Планирует уведомления на основе настроек пользователя.
  /// Алгоритм:
  /// 1. Отменяет все ранее запланированные уведомления.
  /// 2. Парсит notifFrom/notifTo в минуты от полуночи, notifFreq в интервал в минутах.
  /// 3. Если диапазон пересекает полночь (to <= from) - прибавляет 24ч к to.
  /// 4. Генерирует список моментов времени с шагом freqMinutes в пределах диапазона.
  /// 5. Если выбраны все 7 дней, планирует ежедневные повторы по времени.
  /// Если выбрана часть дней - планирует еженедельные повторы для выбранных дней.
  /// Если freqMinutes < 5 или days пуст - ничего не планирует.
  /// @param prefs PrefsService с настройками уведомлений.
  Future<void> scheduleFromPrefs(PrefsService prefs) async {
    if (!_initialized) await init();
    await cancelAll();

    final plan = buildSchedulePlan(
      notifFrom: prefs.notifFrom,
      notifTo: prefs.notifTo,
      notifFreq: prefs.notifFreq,
      notifDays: prefs.notifDays,
    );

    for (final slot in plan) {
      await _scheduleAt(slot);
    }

    debugPrint('NotificationService: scheduled ${plan.length} notifications');
  }

  @visibleForTesting
  static List<NotificationScheduleSlot> buildSchedulePlan({
    required String notifFrom,
    required String notifTo,
    required String notifFreq,
    required List<int> notifDays,
  }) {
    final fromMinutes = _parseTimeToMinutes(notifFrom);
    var toMinutes = _parseTimeToMinutes(notifTo);
    final freqMinutes = int.tryParse(notifFreq) ?? 60;
    final days =
        notifDays
            .where((day) => day >= DateTime.monday && day <= DateTime.sunday)
            .toSet()
            .toList()
          ..sort();

    if (fromMinutes == null || toMinutes == null) return const [];
    if (freqMinutes < 5) return const [];
    if (days.isEmpty) return const [];
    if (toMinutes <= fromMinutes) toMinutes += 24 * 60;

    final times = <_HourMin>[];
    int current = fromMinutes;
    while (current <= toMinutes) {
      times.add(_HourMin(current ~/ 60 % 24, current % 60));
      current += freqMinutes;
    }

    final allDaysSelected = days.length == 7;
    var id = 0;
    if (allDaysSelected) {
      return [
        for (final time in times)
          NotificationScheduleSlot(
            id: id++,
            hour: time.hour,
            minute: time.minute,
            matchDateTimeComponents: DateTimeComponents.time,
          ),
      ];
    }

    return [
      for (final day in days)
        for (final time in times)
          NotificationScheduleSlot(
            id: id++,
            weekday: day,
            hour: time.hour,
            minute: time.minute,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          ),
    ];
  }

  static int? _parseTimeToMinutes(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return hour * 60 + minute;
  }

  /// Отменяет все ранее запланированные уведомления через плагин. Вызывается перед scheduleFromPrefs.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> _scheduleAt(NotificationScheduleSlot slot) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      slot.hour,
      slot.minute,
    );

    final weekday = slot.weekday;
    if (weekday != null) {
      while (scheduled.weekday != weekday) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
    }

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(Duration(days: weekday == null ? 1 : 7));
    }

    const androidDetails = AndroidNotificationDetails(
      'workout_reminders',
      'Напоминания о тренировке',
      channelDescription: 'Напоминания сделать разминку',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      slot.id,
      '2mins',
      _randomMessage(),
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: slot.matchDateTimeComponents,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  String _randomMessage() {
    const messages = [
      'Время размяться! Всего 2 минуты.',
      'Пора сделать перерыв и потренироваться!',
      'Ваше тело просит разминку!',
      'Маленькая тренировка — большая польза.',
      'Две минуты для здоровья!',
    ];
    return messages[DateTime.now().microsecond % messages.length];
  }

  void _onTap(NotificationResponse response) {
    debugPrint('NotificationService: notification tapped');
  }

  String _guessTimeZone() {
    final offset = DateTime.now().timeZoneOffset;
    if (offset.inHours == 3) return 'Europe/Moscow';
    if (offset.inHours == 2) return 'Europe/Tallinn';
    if (offset.inHours == 1) return 'Europe/London';
    if (offset.inHours == -5) return 'America/New_York';
    if (offset.inHours == -8) return 'America/Los_Angeles';
    return 'UTC';
  }
}

/// Вспомогательная структура: час и минута для расчёта расписания уведомлений.
class _HourMin {
  final int hour;
  final int minute;
  const _HourMin(this.hour, this.minute);
}

class NotificationScheduleSlot {
  final int id;
  final int? weekday;
  final int hour;
  final int minute;
  final DateTimeComponents matchDateTimeComponents;

  const NotificationScheduleSlot({
    required this.id,
    this.weekday,
    required this.hour,
    required this.minute,
    required this.matchDateTimeComponents,
  });
}
