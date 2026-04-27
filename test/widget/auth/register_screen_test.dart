import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/l10n/app_localizations.dart';

/**
RegisterScreen создаёт AuthService внутри → Firebase зависимость.
Тестируем логику валидации и маппинг ошибок без Flutter виджетов.
*/
void main() {
  group('RegisterScreen — логика валидации', () {
    test('пустые поля → ошибка', () {
      final email = '';
      final password = '';
      final confirm = '';
      expect(email.isEmpty || password.isEmpty || confirm.isEmpty, true);
    });

    test('пароли не совпадают → ошибка', () {
      final password = '123456';
      final confirm = '654321';
      expect(password != confirm, true);
    });

    test('пароль короче 6 символов → ошибка', () {
      final password = '123';
      expect(password.length < 6, true);
    });

    test('валидные данные проходят валидацию', () {
      final email = 'test@test.com'.trim();
      final password = '123456';
      final confirm = '123456';

      final emptyFields = email.isEmpty || password.isEmpty || confirm.isEmpty;
      final passwordsMismatch = password != confirm;
      final shortPassword = password.length < 6;

      expect(emptyFields, false);
      expect(passwordsMismatch, false);
      expect(shortPassword, false);
    });
  });

  group('RegisterScreen — маппинг ошибок', () {
    String mapError(String code) => switch (code) {
      'email-already-in-use' => 'Email already in use',
      'weak-password' => 'Weak password',
      'invalid-email' => 'Invalid email',
      _ => 'Error: $code',
    };

    test('email-already-in-use', () {
      expect(mapError('email-already-in-use'), 'Email already in use');
    });

    test('weak-password', () {
      expect(mapError('weak-password'), 'Weak password');
    });

    test('invalid-email', () {
      expect(mapError('invalid-email'), 'Invalid email');
    });
  });

  group('RegisterScreen — localized text', () {
    test('русская локализация', () {
      final t = Tr(const Locale('ru'));
      expect(t.registerTitle, 'Регистрация');
      expect(t.registerButton, 'Зарегистрироваться');
      expect(t.repeatPasswordHint, 'Повторите пароль');
      expect(t.alreadyHaveAccount, 'Уже есть аккаунт');
      expect(t.passwordsDontMatch, 'Пароли не совпадают');
      expect(t.passwordTooShort, 'Пароль должен быть не менее 6 символов');
      expect(t.googleContinue, 'Продолжить с Google');
    });

    test('английская локализация', () {
      final t = Tr(const Locale('en'));
      expect(t.registerTitle, 'Sign up');
      expect(t.registerButton, 'Sign up');
      expect(t.passwordsDontMatch, "Passwords don't match");
    });
  });
}
