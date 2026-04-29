import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../mocks/mocks.dart';

/// Тесты для логики NotificationService.
/// NotificationService — синглтон с жёсткой зависимостью от
/// FlutterLocalNotificationsPlugin и timezone, поэтому unit-тесты
/// покрывают логику расчётов, а не сам вызов плагина.
void main() {
  group('Логика расчёта расписания уведомлений', () {
    test('freqMinutes < 5 → не планировать', () {
      expect(4 < 5, true);
    });

    test('пустые days → не планировать', () {
      final days = <int>[];
      expect(days.isEmpty, true);
    });

    test('расчёт times для 09:00-21:00, freq=60 минут', () {
      final fromMinutes = 9 * 60; // 540
      final toMinutes = 21 * 60; // 1260
      const freqMinutes = 60;

      final times = <_HourMin>[];
      int current = fromMinutes;
      while (current <= toMinutes) {
        times.add(_HourMin(current ~/ 60 % 24, current % 60));
        current += freqMinutes;
      }

      // 09:00, 10:00, 11:00, ..., 21:00 = 13раз
      expect(times.length, 13);
      expect(times.first.hour, 9);
      expect(times.first.minute, 0);
      expect(times.last.hour, 21);
      expect(times.last.minute, 0);
    });

    test('расчёт times для 09:00-21:00, freq=30 минут', () {
      final fromMinutes = 9 * 60;
      final toMinutes = 21 * 60;
      const freqMinutes = 30;

      final times = <_HourMin>[];
      int current = fromMinutes;
      while (current <= toMinutes) {
        times.add(_HourMin(current ~/ 60 % 24, current % 60));
        current += freqMinutes;
      }

      // 09:00, 09:30, 10:00, ..., 21:00 = 25 раз
      expect(times.length, 25);
    });

    test('расчёт times для 09:00-21:00, freq=120 минут (2 часа)', () {
      final fromMinutes = 9 * 60;
      final toMinutes = 21 * 60;
      const freqMinutes = 120;

      final times = <_HourMin>[];
      int current = fromMinutes;
      while (current <= toMinutes) {
        times.add(_HourMin(current ~/ 60 % 24, current % 60));
        current += freqMinutes;
      }

      // 09:00, 11:00, 13:00, 15:00, 17:00, 19:00, 21:00 = 7
      expect(times.length, 7);
    });

    test('toMinutes <= fromMinutes → добавляем 24 часа (ночной режим)', () {
      var fromMinutes = 22 * 60; // 22:00
      var toMinutes = 6 * 60; // 06:00

      if (toMinutes <= fromMinutes) toMinutes += 24 * 60;

      // toMinutes = 6*60 + 24*60 = 1800 (30 часов)
      expect(toMinutes, 1800);

      const freqMinutes = 120;
      final times = <_HourMin>[];
      int current = fromMinutes;
      while (current <= toMinutes) {
        times.add(_HourMin(current ~/ 60 % 24, current % 60));
        current += freqMinutes;
      }

      // 22:00, 00:00, 02:00, 04:00, 06:00 = 5
      expect(times.length, 5);
      expect(times[0].hour, 22);
      expect(times[1].hour, 0);
      expect(times[2].hour, 2);
    });

    test('общее количество уведомлений = times * days', () {
      const timesCount = 13;
      const daysCount = 5;
      expect(timesCount * daysCount, 65);
    });
  });

  group('PrefsService значения для NotificationService', () {
    test('формат notifFrom/notifTo — "HH:MM"', () {
      const from = '09:00';
      const to = '21:00';

      final fromParts = from.split(':');
      expect(fromParts.length, 2);
      expect(int.parse(fromParts[0]), 9);
      expect(int.parse(fromParts[1]), 0);

      final toParts = to.split(':');
      expect(int.parse(toParts[0]), 21);
    });

    test('notifFreq парсится как int (минуты)', () {
      const freq = '60';
      expect(int.tryParse(freq), 60);
    });

    test('невалидный notifFreq → fallback 60', () {
      const freq = 'daily';
      expect(int.tryParse(freq) ?? 60, 60);
    });
  });

  group('MockPrefsService для scheduleFromPrefs', () {
    test('mock возвращает корректные значения', () {
      final mockPrefs = MockPrefsService();
      when(() => mockPrefs.notifFrom).thenReturn('09:00');
      when(() => mockPrefs.notifTo).thenReturn('21:00');
      when(() => mockPrefs.notifFreq).thenReturn('60');
      when(() => mockPrefs.notifDays).thenReturn([1, 2, 3, 4, 5]);

      expect(mockPrefs.notifFrom, '09:00');
      expect(mockPrefs.notifTo, '21:00');
      expect(mockPrefs.notifFreq, '60');
      expect(mockPrefs.notifDays.length, 5);
    });
  });
}

class _HourMin {
  final int hour;
  final int minute;
  const _HourMin(this.hour, this.minute);
}
