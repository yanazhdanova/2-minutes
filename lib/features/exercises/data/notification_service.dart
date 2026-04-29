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
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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

  /// Планирует еженедельные уведомления на основе настроек пользователя.
  /// Алгоритм:
  /// 1. Отменяет все ранее запланированные уведомления.
  /// 2. Парсит notifFrom/notifTo в минуты от полуночи, notifFreq в интервал в минутах.
  /// 3. Если диапазон пересекает полночь (to <= from) - прибавляет 24ч к to.
  /// 4. Генерирует список моментов времени с шагом freqMinutes в пределах диапазона.
  /// 5. Для каждого дня недели (notifDays) и каждого момента - планирует повторяющееся
  /// еженедельное уведомление через zonedSchedule с matchDateTimeComponents.dayOfWeekAndTime.
  /// Если freqMinutes < 5 или days пуст - ничего не планирует.
  /// @param prefs PrefsService с настройками уведомлений.
  Future<void> scheduleFromPrefs(PrefsService prefs) async {
    await cancelAll();

    final fromStr = prefs.notifFrom;
    final toStr = prefs.notifTo;
    final freqStr = prefs.notifFreq;
    final days = prefs.notifDays;

    final fromParts = fromStr.split(':');
    final toParts = toStr.split(':');
    final fromMinutes = int.parse(fromParts[0]) * 60 + int.parse(fromParts[1]);
    var toMinutes = int.parse(toParts[0]) * 60 + int.parse(toParts[1]);
    final freqMinutes = int.tryParse(freqStr) ?? 60;

    if (freqMinutes < 5) return;
    if (days.isEmpty) return;
    if (toMinutes <= fromMinutes) toMinutes += 24 * 60;

    final times = <_HourMin>[];
    int current = fromMinutes;
    while (current <= toMinutes) {
      times.add(_HourMin(current ~/ 60 % 24, current % 60));
      current += freqMinutes;
    }

    int id = 0;
    for (final day in days) {
      for (final time in times) {
        await _scheduleWeeklyAt(
          id: id,
          weekday: day,
          hour: time.hour,
          minute: time.minute,
        );
        id++;
      }
    }

    debugPrint(
      'NotificationService: scheduled $id notifications for ${days.length} days',
    );
  }

  /// Отменяет все ранее запланированные уведомления через плагин. Вызывается перед scheduleFromPrefs.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> _scheduleWeeklyAt({
    required int id,
    required int weekday,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
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
      id,
      '2 минуты',
      _randomMessage(),
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
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
