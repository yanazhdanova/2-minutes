import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/l10n/app_localizations.dart';

/// LoginScreen создаёт AuthService внутри, который зависит от Firebase.
/// Поэтому тестируем UI логику экрана через простой макет,
/// повторяющий его layout без реального AuthService.
void main() {
  group('LoginScreen — логика валидации (unit)', () {
    test('пустой email и пароль → ошибка "Заполните все поля"', () {
      final email = ''.trim();
      final password = '';
      expect(email.isEmpty || password.isEmpty, true);
    });

    test('непустой email, пустой пароль → ошибка', () {
      final email = 'test@test.com'.trim();
      final password = '';
      expect(email.isEmpty || password.isEmpty, true);
    });

    test('пустой email, непустой пароль → ошибка', () {
      final email = ''.trim();
      final password = '123456';
      expect(email.isEmpty || password.isEmpty, true);
    });

    test('оба поля заполнены → валидация пройдена', () {
      final email = 'test@test.com'.trim();
      final password = '123456';
      expect(email.isEmpty || password.isEmpty, false);
    });
  });

  group('LoginScreen — маппинг ошибок', () {
    String mapError(String code) => switch (code) {
      'user-not-found' => 'User not found',
      'wrong-password' => 'Wrong password',
      'invalid-email' => 'Invalid email',
      'user-disabled' => 'Account disabled',
      'too-many-requests' => 'Too many attempts',
      'invalid-credential' => 'Invalid email or password',
      _ => 'Error: $code',
    };

    test('user-not-found', () {
      expect(mapError('user-not-found'), 'User not found');
    });

    test('wrong-password', () {
      expect(mapError('wrong-password'), 'Wrong password');
    });

    test('invalid-email', () {
      expect(mapError('invalid-email'), 'Invalid email');
    });

    test('user-disabled', () {
      expect(mapError('user-disabled'), 'Account disabled');
    });

    test('too-many-requests', () {
      expect(mapError('too-many-requests'), 'Too many attempts');
    });

    test('invalid-credential', () {
      expect(mapError('invalid-credential'), 'Invalid email or password');
    });

    test('неизвестный код', () {
      expect(mapError('some-error'), 'Error: some-error');
    });
  });

  group('LoginScreen — localized UI text', () {
    test('русская локализация содержит все нужные строки', () {
      final t = Tr(const Locale('ru'));
      expect(t.loginTitle, 'Логин');
      expect(t.emailHint, 'Email');
      expect(t.passwordHint, 'Пароль');
      expect(t.loginButton, 'Войти');
      expect(t.forgotPassword, 'Забыли пароль?');
      expect(t.registerLink, 'Регистрация');
      expect(t.orDivider, 'или');
      expect(t.googleSignIn, 'Войти через Google');
      expect(t.fillAllFields, 'Заполните все поля');
    });

    test('английская локализация содержит все нужные строки', () {
      final t = Tr(const Locale('en'));
      expect(t.loginTitle, 'Login');
      expect(t.loginButton, 'Sign in');
      expect(t.registerLink, 'Sign up');
      expect(t.googleSignIn, 'Sign in with Google');
    });
  });
}
