import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/l10n/app_localizations.dart';

void main() {
  group('Tr — русская локализация', () {
    late Tr tr;

    setUp(() {
      tr = Tr(const Locale('ru'));
    });

    test('appName', () {
      expect(tr.appName, '2 минуты');
    });

    test('навигация', () {
      expect(tr.navHome, 'Главная');
      expect(tr.navCatalog, 'Каталог');
      expect(tr.navSettings, 'Настройки');
    });

    test('auth', () {
      expect(tr.loginTitle, 'Логин');
      expect(tr.loginButton, 'Войти');
      expect(tr.registerTitle, 'Регистрация');
      expect(tr.registerButton, 'Зарегистрироваться');
      expect(tr.forgotPassword, 'Забыли пароль?');
      expect(tr.passwordHint, 'Пароль');
      expect(tr.fillAllFields, 'Заполните все поля');
      expect(tr.passwordsDontMatch, 'Пароли не совпадают');
      expect(tr.passwordTooShort, 'Пароль должен быть не менее 6 символов');
    });

    test('onboarding', () {
      expect(tr.nameTitle, 'Как вас зовут?');
      expect(tr.next, 'Далее');
      expect(tr.finalButton, 'Отлично');
    });

    test('проблемы', () {
      expect(tr.problemPosture, 'Проблемы с осанкой');
      expect(tr.problemNeck, 'Боли в шее');
      expect(tr.problemEyes, 'Усталость глаз');
      expect(tr.problemStress, 'Стресс и тревога');
    });

    test('workout', () {
      expect(tr.startWorkout, 'Начать тренировку');
      expect(tr.pause, 'пауза');
      expect(tr.continueWorkout, 'Продолжить');
      expect(tr.skipExercise, 'Пропустить упражнение');
      expect(tr.endWorkout, 'Закончить тренировку');
      expect(tr.workoutDoneTitle, 'Отлично!');
      expect(tr.goHome, 'На главную');
    });

    test('settings', () {
      expect(tr.settingsTitle, 'Настройки');
      expect(tr.settingsProgram, 'Моя программа');
      expect(tr.settingsNotif, 'Уведомления');
      expect(tr.settingsLang, 'Язык');
      expect(tr.settingsAppearance, 'Внешний вид');
    });

    test('appearance', () {
      expect(tr.themeSystem, 'Системная');
      expect(tr.themeLight, 'Светлая');
      expect(tr.themeDark, 'Тёмная');
      expect(tr.accentGreen, 'Зелёный');
      expect(tr.accentPink, 'Розовый');
    });

    test('premium', () {
      expect(tr.premiumTitle, 'Премиум');
      expect(tr.premiumBuy, 'Купить');
      expect(tr.premiumComingSoon, 'Скоро будет доступно');
    });

    test('weekdays', () {
      expect(tr.weekdaysShort.length, 7);
      expect(tr.weekdaysShort, ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']);
    });

    test('categoryTitle маппинг', () {
      expect(tr.categoryTitle('neck'), 'Шея');
      expect(tr.categoryTitle('shoulders_arms'), 'Плечи и руки');
      expect(tr.categoryTitle('back_lower'), 'Спина и поясница');
      expect(tr.categoryTitle('eyes'), 'Глаза');
      expect(tr.categoryTitle('relaxation'), 'Снятие напряжения');
      expect(tr.categoryTitle('attention_switch'), 'Переключение внимания');
      expect(
        tr.categoryTitle('emotional_balance'),
        'Эмоциональная стабилизация',
      );
    });

    test('categoryTitle для неизвестного id возвращает сам id', () {
      expect(tr.categoryTitle('unknown'), 'unknown');
    });

    test('durationSec', () {
      expect(tr.durationSec(40), 'Длительность: 40 сек');
    });

    test('emailSentBody', () {
      expect(
        tr.emailSentBody('test@test.com'),
        'На test@test.com отправлена ссылка для сброса пароля.',
      );
    });
  });

  group('Tr — английская локализация', () {
    late Tr tr;

    setUp(() {
      tr = Tr(const Locale('en'));
    });

    test('appName', () {
      expect(tr.appName, '2 минуты');
    });

    test('навигация', () {
      expect(tr.navHome, 'Home');
      expect(tr.navCatalog, 'Catalog');
      expect(tr.navSettings, 'Settings');
    });

    test('auth', () {
      expect(tr.loginTitle, 'Login');
      expect(tr.loginButton, 'Sign in');
      expect(tr.registerTitle, 'Sign up');
      expect(tr.forgotPassword, 'Forgot password?');
      expect(tr.passwordHint, 'Password');
      expect(tr.fillAllFields, 'Fill in all fields');
      expect(tr.passwordsDontMatch, "Passwords don't match");
    });

    test('settings', () {
      expect(tr.settingsTitle, 'Settings');
      expect(tr.settingsProgram, 'My program');
      expect(tr.settingsLang, 'Language');
    });

    test('appearance', () {
      expect(tr.themeSystem, 'System');
      expect(tr.themeLight, 'Light');
      expect(tr.themeDark, 'Dark');
      expect(tr.accentGreen, 'Green');
      expect(tr.accentPink, 'Pink');
    });

    test('weekdays', () {
      expect(tr.weekdaysShort, ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']);
    });

    test('category titles', () {
      expect(tr.categoryTitle('neck'), 'Neck');
      expect(tr.categoryTitle('shoulders_arms'), 'Shoulders & arms');
      expect(tr.categoryTitle('back_lower'), 'Back & lower back');
    });
  });

  group('_TrDelegate', () {
    test('поддерживает ru и en', () {
      expect(Tr.delegate.isSupported(const Locale('ru')), true);
      expect(Tr.delegate.isSupported(const Locale('en')), true);
    });

    test('не поддерживает другие локали', () {
      expect(Tr.delegate.isSupported(const Locale('de')), false);
      expect(Tr.delegate.isSupported(const Locale('fr')), false);
    });

    test('supportedLocales содержит ru и en', () {
      expect(Tr.supportedLocales.length, 2);
      expect(Tr.supportedLocales, contains(const Locale('ru')));
      expect(Tr.supportedLocales, contains(const Locale('en')));
    });
  });
}
