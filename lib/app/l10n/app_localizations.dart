import 'package:flutter/widgets.dart';

class Tr {
  final Locale locale;
  Tr(this.locale);

  static Tr of(BuildContext context) => Localizations.of<Tr>(context, Tr)!;
  static const LocalizationsDelegate<Tr> delegate = _TrDelegate();
  static const supportedLocales = [Locale('ru'), Locale('en')];

  bool get _isRu => locale.languageCode == 'ru';

  // ── Общее ──
  String get appName => '2 минуты';
  String get next => _isRu ? 'Далее' : 'Next';
  String get cancel => _isRu ? 'Отмена' : 'Cancel';
  String get done => _isRu ? 'Готово' : 'Done';
  String get save => _isRu ? 'Сохранить' : 'Save';
  String get video => _isRu ? 'Видео' : 'Video';

  // ── Nav ──
  String get navHome => _isRu ? 'Главная' : 'Home';
  String get navCatalog => _isRu ? 'Каталог' : 'Catalog';
  String get navSettings => _isRu ? 'Настройки' : 'Settings';

  // ── Auth ──
  String get loginTitle => _isRu ? 'Логин' : 'Login';
  String get emailHint => 'Email';
  String get passwordHint => _isRu ? 'Пароль' : 'Password';
  String get forgotPassword => _isRu ? 'Забыли пароль?' : 'Forgot password?';
  String get loginButton => _isRu ? 'Войти' : 'Sign in';
  String get registerLink => _isRu ? 'Регистрация' : 'Sign up';
  String get registerTitle => _isRu ? 'Регистрация' : 'Sign up';
  String get repeatPasswordHint =>
      _isRu ? 'Повторите пароль' : 'Repeat password';
  String get registerButton => _isRu ? 'Зарегистрироваться' : 'Sign up';
  String get alreadyHaveAccount =>
      _isRu ? 'Уже есть аккаунт' : 'Already have an account';
  String get resetPasswordTitle =>
      _isRu ? 'Восстановление\nпароля' : 'Reset\npassword';
  String get resetCodeTitle => _isRu
      ? 'На вашу почту был\nотправлен код'
      : 'A code was sent\nto your email';
  String get codeHint => _isRu ? 'Код' : 'Code';
  String get newPasswordTitle =>
      _isRu ? 'Придумайте\nновый пароль' : 'Create a\nnew password';
  String get newPasswordHint => _isRu ? 'Новый пароль' : 'New password';
  String get changePasswordButton =>
      _isRu ? 'Поменять пароль' : 'Change password';
  String get orDivider => _isRu ? 'или' : 'or';
  String get googleSignIn =>
      _isRu ? 'Войти через Google' : 'Sign in with Google';
  String get googleContinue =>
      _isRu ? 'Продолжить с Google' : 'Continue with Google';
  String get emailSentTitle => _isRu ? 'Письмо отправлено' : 'Email sent';
  String emailSentBody(String email) => _isRu
      ? 'На $email отправлена ссылка для сброса пароля.'
      : 'A password reset link was sent to $email.';
  String get backToLogin => _isRu ? 'Назад к логину' : 'Back to login';
  String get fillAllFields =>
      _isRu ? 'Заполните все поля' : 'Fill in all fields';
  String get passwordsDontMatch =>
      _isRu ? 'Пароли не совпадают' : "Passwords don't match";
  String get passwordTooShort => _isRu
      ? 'Пароль должен быть не менее 6 символов'
      : 'Password must be at least 6 characters';
  String get enterEmail => _isRu ? 'Введите email' : 'Enter email';

  // ── Onboarding ──
  String get nameTitle => _isRu ? 'Как вас зовут?' : "What's your name?";
  String get nameHint => _isRu ? 'Введите имя' : 'Enter name';
  String get categoriesTitle => _isRu
      ? 'Выберите, какие\nпроблемы хотите\nисправить'
      : 'Select problems\nyou want to fix';
  String get categoriesValidation => _isRu
      ? 'Выберите хотя бы одну категорию'
      : 'Select at least one category';
  String get notifTimeTitle => _isRu
      ? 'В какое время\nнапоминать о\nтренировке?'
      : 'What time should\nwe remind you\nabout workout?';
  String get notifFrom => _isRu ? 'От' : 'From';
  String get notifTo => _isRu ? 'До' : 'To';
  String get notifFreqTitle => _isRu
      ? 'Как часто\nприсылать\nуведомления?'
      : 'How often should\nwe send\nnotifications?';
  String get finalScreenTitle => _isRu
      ? 'Вы всегда можете\nпоменять параметры\nв разделе\n"Настройки"'
      : 'You can always\nchange settings\nin the Settings\nsection';
  String get finalButton => _isRu ? 'Отлично' : 'Great';

  // ── Проблемы ──
  String get problemPosture =>
      _isRu ? 'Проблемы с осанкой' : 'Posture problems';
  String get problemBack =>
      _isRu ? 'Боли в спине и пояснице' : 'Back & lower back pain';
  String get problemNeck => _isRu ? 'Боли в шее' : 'Neck pain';
  String get problemEyes => _isRu ? 'Усталость глаз' : 'Eye strain';
  String get problemStress => _isRu ? 'Стресс и тревога' : 'Stress & anxiety';
  String get problemFocus =>
      _isRu ? 'Трудности с концентрацией' : 'Difficulty focusing';
  String get problemEnergy => _isRu ? 'Нехватка энергии' : 'Low energy';
  String get problemSleep => _isRu ? 'Проблемы со сном' : 'Sleep problems';

  // ── Частота ──
  String get freqEvery30min => _isRu ? 'Каждые 30 минут' : 'Every 30 minutes';
  String get freqEveryHour => _isRu ? 'Каждый час' : 'Every hour';
  String get freqEvery2hours => _isRu ? 'Каждые 2 часа' : 'Every 2 hours';
  String get freqEvery4hours => _isRu ? 'Каждые 4 часа' : 'Every 4 hours';

  // ── Home ──
  String get greetingNight => _isRu ? 'Доброй ночи' : 'Good night';
  String get greetingMorning => _isRu ? 'Доброе утро' : 'Good morning';
  String get greetingAfternoon => _isRu ? 'Добрый день' : 'Good afternoon';
  String get greetingEvening => _isRu ? 'Добрый вечер' : 'Good evening';
  String get startWorkout => _isRu ? 'Начать тренировку' : 'Start workout';
  String get chooseExercisesTitle =>
      _isRu ? 'Выберите\nупражнения' : 'Choose\nexercises';
  String get chooseExerciseSlot =>
      _isRu ? 'Выбрать упражнение' : 'Choose exercise';
  String get startButton => _isRu ? 'Начать' : 'Start';
  String get chooseTypeTitle =>
      _isRu ? 'Выберите тип\nупражнения' : 'Choose exercise\ntype';
  String get typePhysical => _isRu ? 'Физическое' : 'Physical';
  String get typePhysicalSub =>
      _isRu ? 'Разминка, растяжка, осанка' : 'Warmup, stretching, posture';
  String get typeMental => _isRu ? 'Ментальное' : 'Mental';
  String get typeMentalSub =>
      _isRu ? 'Дыхание, концентрация' : 'Breathing, focus';
  String get typeRandom => _isRu ? 'Случайное' : 'Random';
  String get typeRandomSub =>
      _isRu ? 'Мы выберем за вас' : "We'll pick for you";
  String get randomExercise =>
      _isRu ? 'Случайное упражнение' : 'Random exercise';

  // ── Catalog ──
  String get catalogTitle => _isRu ? 'Каталог' : 'Catalog';
  String get catalogSubtitle =>
      _isRu ? 'Все упражнения по категориям' : 'All exercises by category';
  String get physicalTitle => _isRu ? 'Физические' : 'Physical';
  String get physicalSub =>
      _isRu ? 'Разминка, растяжка, осанка' : 'Warmup, stretching, posture';
  String get mentalTitle => _isRu ? 'Ментальные' : 'Mental';
  String get mentalSub => _isRu
      ? 'Дыхание, концентрация, релаксация'
      : 'Breathing, focus, relaxation';
  String get noCategories => _isRu ? 'Нет категорий' : 'No categories';
  String get noExercises => _isRu ? 'Нет упражнений' : 'No exercises';
  String get noExercisesInCategory => _isRu
      ? 'Нет упражнений в этой категории'
      : 'No exercises in this category';
  String durationSec(int sec) =>
      _isRu ? 'Длительность: $sec сек' : 'Duration: ${sec}s';

  // ── Workout ──
  String get pause => _isRu ? 'пауза' : 'pause';
  String get continueWorkout => _isRu ? 'Продолжить' : 'Continue';
  String get skipExercise => _isRu ? 'Пропустить упражнение' : 'Skip exercise';
  String get endWorkout => _isRu ? 'Закончить тренировку' : 'End workout';
  String get workoutDoneTitle => _isRu ? 'Отлично!' : 'Great!';
  String get workoutDoneSubtitle => _isRu
      ? 'Тренировка завершена.\nТак держать!'
      : 'Workout complete.\nKeep it up!';
  String get goHome => _isRu ? 'На главную' : 'Go home';

  // ── Settings ──
  String get settingsTitle => _isRu ? 'Настройки' : 'Settings';
  String get settingsProgram => _isRu ? 'Моя программа' : 'My program';
  String get settingsNotif => _isRu ? 'Уведомления' : 'Notifications';
  String get settingsLang => _isRu ? 'Язык' : 'Language';
  String get settingsAppearance => _isRu ? 'Внешний вид' : 'Appearance';
  String get settingsPremium => _isRu ? 'Платная версия' : 'Premium';
  String get programSubtitle => _isRu
      ? 'Выберите проблемы, которые хотите решать'
      : 'Select problems you want to address';
  String get savedMessage => _isRu ? 'Сохранено' : 'Saved';
  String get notifTimeSection =>
      _isRu ? 'Время уведомлений' : 'Notification time';
  String get notifFreqSection => _isRu ? 'Частота' : 'Frequency';
  String get notifDaysLabel => _isRu ? 'Дни недели' : 'Days of the week';
  List<String> get weekdaysShort => _isRu
      ? ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
      : ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  // ── Language ──
  String get langTitle => _isRu ? 'Язык' : 'Language';
  String get langRussian => 'Русский';
  String get langEnglish => 'English';

  // ── Appearance ──
  String get appearanceTitle => _isRu ? 'Внешний вид' : 'Appearance';
  String get themeSection => _isRu ? 'Тема' : 'Theme';
  String get themeSystem => _isRu ? 'Системная' : 'System';
  String get themeLight => _isRu ? 'Светлая' : 'Light';
  String get themeDark => _isRu ? 'Тёмная' : 'Dark';
  String get accentSection => _isRu ? 'Акцент' : 'Accent';
  String get accentGreen => _isRu ? 'Зелёный' : 'Green';
  String get accentPink => _isRu ? 'Розовый' : 'Pink';

  // ── Premium ──
  String get premiumTitle => _isRu ? 'Премиум' : 'Premium';
  String get premiumDescription => _isRu
      ? 'Всего за \$1 в месяц вы можете\nубрать рекламу и получить\nдоступ ко всем упражнениям'
      : 'For just \$1/month you can\nremove ads and unlock\nall exercises';
  String get premiumBuy => _isRu ? 'Купить' : 'Buy';
  String get premiumComingSoon =>
      _isRu ? 'Скоро будет доступно' : 'Coming soon';

  // ── Категории упражнений ──
  String get catNeck => _isRu ? 'Шея' : 'Neck';
  String get catShouldersArms => _isRu ? 'Плечи и руки' : 'Shoulders & arms';
  String get catBackLower => _isRu ? 'Спина и поясница' : 'Back & lower back';
  String get catEyes => _isRu ? 'Глаза' : 'Eyes';
  String get catRelaxation => _isRu ? 'Снятие напряжения' : 'Stress relief';
  String get catAttentionSwitch =>
      _isRu ? 'Переключение внимания' : 'Attention switch';
  String get catEmotionalBalance =>
      _isRu ? 'Эмоциональная стабилизация' : 'Emotional balance';

  // ── Workout type ──
  String get workoutTypeTitle =>
      _isRu ? 'Выберите тип\nтренировки' : 'Choose workout\ntype';
  String get quickStartTitle => _isRu ? 'Быстрый старт' : 'Quick start';
  String get quickStartSub => _isRu
      ? 'Тренировка подобрана под ваши задачи'
      : 'Workout matched to your goals';
  String get customWorkoutTitle => _isRu ? 'Своя тренировка' : 'Custom workout';
  String get customWorkoutSub => _isRu
      ? 'Выберите 3 упражнения самостоятельно'
      : 'Pick 3 exercises yourself';

  // ── Notification frequency ──
  String get hoursShort => _isRu ? 'ч' : 'h';
  String get minutesShort => _isRu ? 'мин' : 'min';
  String get everyLabel => _isRu ? 'Каждые' : 'Every';
  String get tapToChange => _isRu ? 'Нажмите, чтобы изменить' : 'Tap to change';

  String categoryTitle(String id) => switch (id) {
    'neck' => catNeck,
    'shoulders_arms' => catShouldersArms,
    'back_lower' => catBackLower,
    'eyes' => catEyes,
    'relaxation' => catRelaxation,
    'attention_switch' => catAttentionSwitch,
    'emotional_balance' => catEmotionalBalance,
    _ => id,
  };
}

class _TrDelegate extends LocalizationsDelegate<Tr> {
  const _TrDelegate();
  @override
  bool isSupported(Locale locale) => ['ru', 'en'].contains(locale.languageCode);
  @override
  Future<Tr> load(Locale locale) async => Tr(locale);
  @override
  bool shouldReload(_TrDelegate old) => false;
}
