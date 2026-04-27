import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/l10n/app_localizations.dart';

/** Edge cases для локализации. */
void main() {
  group('Tr — edge cases', () {
    test('categoryTitle с неизвестным id возвращает сам id', () {
      final t = Tr(const Locale('ru'));
      expect(t.categoryTitle('unknown_cat'), 'unknown_cat');
    });

    test('categoryTitle с пустой строкой', () {
      final t = Tr(const Locale('ru'));
      expect(t.categoryTitle(''), '');
    });

    test('все 7 категорий переводятся для ru', () {
      final t = Tr(const Locale('ru'));
      final ids = [
        'neck',
        'shoulders_arms',
        'back_lower',
        'eyes',
        'relaxation',
        'attention_switch',
        'emotional_balance',
      ];
      for (final id in ids) {
        final title = t.categoryTitle(id);
        expect(
          title,
          isNot(equals(id)),
          reason: 'categoryTitle($id) should be localized',
        );
      }
    });

    test('все 7 категорий переводятся для en', () {
      final t = Tr(const Locale('en'));
      final ids = [
        'neck',
        'shoulders_arms',
        'back_lower',
        'eyes',
        'relaxation',
        'attention_switch',
        'emotional_balance',
      ];
      for (final id in ids) {
        final title = t.categoryTitle(id);
        expect(
          title,
          isNot(equals(id)),
          reason: 'categoryTitle($id) should be localized',
        );
      }
    });

    test('emailSentBody с пустым email', () {
      final t = Tr(const Locale('ru'));
      expect(t.emailSentBody(''), 'На  отправлена ссылка для сброса пароля.');
    });

    test('durationSec с 0', () {
      final t = Tr(const Locale('ru'));
      expect(t.durationSec(0), 'Длительность: 0 сек');
    });

    test('durationSec с большим числом', () {
      final t = Tr(const Locale('en'));
      expect(t.durationSec(3600), 'Duration: 3600s');
    });

    test('weekdaysShort содержит 7 элементов для обоих языков', () {
      expect(Tr(const Locale('ru')).weekdaysShort.length, 7);
      expect(Tr(const Locale('en')).weekdaysShort.length, 7);
    });

    test('supportedLocales содержит ru и en', () {
      expect(Tr.supportedLocales, contains(const Locale('ru')));
      expect(Tr.supportedLocales, contains(const Locale('en')));
      expect(Tr.supportedLocales.length, 2);
    });
  });
}
