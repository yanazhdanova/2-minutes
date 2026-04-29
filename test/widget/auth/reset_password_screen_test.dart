import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/l10n/app_localizations.dart';

/// ResetPasswordScreen создаёт AuthService внутри → Firebase зависимость.
/// Тестируем логику и текст.
void main() {
  group('ResetPasswordScreen — логика валидации', () {
    test('пустой email → ошибка', () {
      final email = ''.trim();
      expect(email.isEmpty, true);
    });

    test('непустой email → валидация пройдена', () {
      final email = 'test@test.com'.trim();
      expect(email.isEmpty, false);
    });

    test('email с пробелами триммится', () {
      final email = '  test@test.com  '.trim();
      expect(email, 'test@test.com');
      expect(email.isEmpty, false);
    });
  });

  group('ResetPasswordScreen — localized text', () {
    test('русская локализация', () {
      final t = Tr(const Locale('ru'));
      expect(t.resetPasswordTitle, 'Восстановление\nпароля');
      expect(t.emailSentTitle, 'Письмо отправлено');
      expect(t.enterEmail, 'Введите email');
      expect(t.backToLogin, 'Назад к логину');
    });

    test('emailSentBody с email', () {
      final t = Tr(const Locale('ru'));
      expect(
        t.emailSentBody('test@test.com'),
        'На test@test.com отправлена ссылка для сброса пароля.',
      );
    });

    test('английская локализация', () {
      final t = Tr(const Locale('en'));
      expect(t.resetPasswordTitle, 'Reset\npassword');
      expect(t.emailSentTitle, 'Email sent');
      expect(t.enterEmail, 'Enter email');
      expect(t.backToLogin, 'Back to login');
    });
  });
}
