import 'package:flutter/widgets.dart';

/// Класс локализации приложения. Содержит все строки интерфейса для русской (ru)
/// и английской (en) локалей. Строки сгруппированы по разделам: общее, навигация,
/// авторизация, онбординг, проблемы, частота, главная, каталог, тренировка,
/// настройки, язык, оформление, категории упражнений, тип тренировки.
/// Выбор языка определяется геттером _isRu на основе текущей локали.
class Tr {
  /// Текущая локаль, определяющая язык строк.
  final Locale locale;
  Tr(this.locale);

  /// Получает экземпляр Tr из контекста через Localizations.of.
  /// Возвращает non-null благодаря гарантии наличия делегата _TrDelegate.
  /// @param context BuildContext вызывающего виджета.
  /// @return Экземпляр Tr для текущей локали.
  static Tr of(BuildContext context) => Localizations.of<Tr>(context, Tr)!;
  static const LocalizationsDelegate<Tr> delegate = _TrDelegate();
  static const supportedLocales = [Locale('en'), Locale('ru')];

  bool get _isRu => locale.languageCode == 'ru';

  // ── Плюрализация ──

  static String _pluralRu(int n, String one, String few, String many) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return one;
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) return few;
    return many;
  }

  String pluralExercises(int n) => _isRu
      ? '$n ${_pluralRu(n, 'упражнение', 'упражнения', 'упражнений')}'
      : '$n ${n == 1 ? 'exercise' : 'exercises'}';

  String formatDuration(int totalSeconds) {
    final min = totalSeconds ~/ 60;
    final sec = totalSeconds % 60;
    if (_isRu) {
      final minStr = min > 0
          ? '$min ${_pluralRu(min, 'минуту', 'минуты', 'минут')}'
          : '';
      final secStr = sec > 0
          ? '$sec ${_pluralRu(sec, 'секунду', 'секунды', 'секунд')}'
          : '';
      return [minStr, secStr].where((s) => s.isNotEmpty).join(' ');
    } else {
      final minStr = min > 0 ? '$min ${min == 1 ? 'minute' : 'minutes'}' : '';
      final secStr = sec > 0 ? '$sec ${sec == 1 ? 'second' : 'seconds'}' : '';
      return [minStr, secStr].where((s) => s.isNotEmpty).join(' ');
    }
  }

  // Общее
  String get appName => '2mins';
  String get next => _isRu ? 'Далее' : 'Next';
  String get cancel => _isRu ? 'Отмена' : 'Cancel';
  String get done => _isRu ? 'Готово' : 'Done';
  String get save => _isRu ? 'Сохранить' : 'Save';

  // Nav
  String get navHome => _isRu ? 'Главная' : 'Home';
  String get navCatalog => _isRu ? 'Каталог' : 'Catalog';
  String get navSettings => _isRu ? 'Настройки' : 'Settings';

  // Auth
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
  String get genderMale => _isRu ? 'Мужской' : 'Male';
  String get genderFemale => _isRu ? 'Женский' : 'Female';

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

  // Проблемы
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

  // Частота
  String get freqEvery30min => _isRu ? 'Каждые 30 минут' : 'Every 30 minutes';
  String get freqEveryHour => _isRu ? 'Каждый час' : 'Every hour';
  String get freqEvery2hours => _isRu ? 'Каждые 2 часа' : 'Every 2 hours';
  String get freqEvery4hours => _isRu ? 'Каждые 4 часа' : 'Every 4 hours';

  // Home
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
  String get typeFavorites => _isRu ? 'Из избранного' : 'From favorites';
  String get typeFavoritesSub =>
      _isRu ? 'Выбрать из сохранённых' : 'Pick from saved exercises';

  // Catalog
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
  String get durationPickerTitle =>
      _isRu ? 'Длительность упражнения' : 'Exercise duration';
  String get defaultExerciseDurationLabel =>
      _isRu ? 'Длительность упражнения' : 'Exercise duration';
  String get defaultExerciseDurationSub =>
      _isRu ? 'По умолчанию для тренировок' : 'Default for workouts';
  String get programCategoriesSection => _isRu ? 'Категории' : 'Categories';
  String durationShort(int sec) => _isRu ? '$sec сек' : '${sec}s';

  // Workout
  String get pause => _isRu ? 'пауза' : 'pause';
  String get continueWorkout => _isRu ? 'Продолжить' : 'Continue';
  String get skipExercise => _isRu ? 'Пропустить упражнение' : 'Skip exercise';
  String get endWorkout => _isRu ? 'Закончить тренировку' : 'End workout';
  String get workoutDoneTitle => _isRu ? 'Отлично!' : 'Great!';
  String get workoutDoneSubtitle => _isRu
      ? 'Тренировка завершена.\nТак держать!'
      : 'Workout complete.\nKeep it up!';
  String get goHome => _isRu ? 'На главную' : 'Go home';
  String get shareButton => _isRu ? 'Поделиться' : 'Share';
  String get shareCardTitle =>
      _isRu ? 'Тренировка завершена!' : 'Workout complete!';
  String shareCardResultPrefix(
    int exercises,
    String duration, {
    String gender = '',
  }) => _isRu
      ? 'Я ${gender == 'female' ? 'сделала' : 'сделал'} ${pluralExercises(exercises)} за $duration в приложении'
      : 'I did ${pluralExercises(exercises)} in $duration with';
  String shareCardResult(
    int exercises,
    String duration, {
    String gender = '',
  }) => '${shareCardResultPrefix(exercises, duration, gender: gender)} 2mins';

  // Settings
  String get settingsTitle => _isRu ? 'Настройки' : 'Settings';
  String get settingsProgram => _isRu ? 'Моя программа' : 'My program';
  String get settingsNotif => _isRu ? 'Уведомления' : 'Notifications';
  String get settingsLang => _isRu ? 'Язык' : 'Language';
  String get settingsAppearance => _isRu ? 'Внешний вид' : 'Appearance';
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

  // Language
  String get langTitle => _isRu ? 'Язык' : 'Language';
  String get langRussian => 'Русский';
  String get langEnglish => 'English';

  // Appearance
  String get appearanceTitle => _isRu ? 'Внешний вид' : 'Appearance';
  String get themeSection => _isRu ? 'Тема' : 'Theme';
  String get themeSystem => _isRu ? 'Системная' : 'System';
  String get themeLight => _isRu ? 'Светлая' : 'Light';
  String get themeDark => _isRu ? 'Тёмная' : 'Dark';
  String get accentSection => _isRu ? 'Акцент' : 'Accent';
  String get accentGreen => _isRu ? 'Зелёный' : 'Green';
  String get accentPink => _isRu ? 'Розовый' : 'Pink';
  String get appIconSection => _isRu ? 'Иконка приложения' : 'App icon';
  String get appIconMain => _isRu ? 'Основная' : 'Main';
  String get appIconAlt => _isRu ? 'Альтернативная' : 'Alternative';
  String get appIconChanged => _isRu ? 'Иконка изменена' : 'App icon changed';
  String get appIconChangeFailed =>
      _isRu ? 'Не удалось изменить иконку' : 'Could not change app icon';

  // Favorites
  String get favoritesTitle => _isRu ? 'Избранное' : 'Favorites';
  String get favoritesSub =>
      _isRu ? 'Ваши любимые упражнения' : 'Your favorite exercises';
  String get favoritesEmpty =>
      _isRu ? 'Пока нет избранных упражнений' : 'No favorite exercises yet';

  // Категории упражнений
  String get catNeck => _isRu ? 'Шея' : 'Neck';
  String get catShouldersArms => _isRu ? 'Плечи и руки' : 'Shoulders & arms';
  String get catBackLower => _isRu ? 'Спина и поясница' : 'Back & lower back';
  String get catEyes => _isRu ? 'Глаза' : 'Eyes';
  String get catRelaxation => _isRu ? 'Снятие напряжения' : 'Stress relief';
  String get catAttentionSwitch =>
      _isRu ? 'Переключение внимания' : 'Attention switch';
  String get catEmotionalBalance =>
      _isRu ? 'Эмоциональная стабилизация' : 'Emotional balance';
  String get catWristsHands => _isRu ? 'Кисти и запястья' : 'Wrists & hands';
  String get catLegsFeet => _isRu ? 'Ноги и стопы' : 'Legs & feet';
  String get catPostureAlignment => _isRu ? 'Осанка' : 'Posture';
  String get catBreathing => _isRu ? 'Дыхание' : 'Breathing';

  // Workout type
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
  String customWorkoutSubCount(int n) => _isRu
      ? 'Выберите $n упражнений самостоятельно'
      : 'Pick $n exercises yourself';

  // Tutorial
  String get tutorialGotIt => _isRu ? 'Понятно' : 'Got it';

  String get tutorialHomeTitle =>
      _isRu ? 'Программа готова!' : 'Your program is ready!';
  String get tutorialHomeBody => _isRu
      ? 'Мы подобрали упражнения под ваши цели.\nНажмите «Начать тренировку», чтобы попробовать.'
      : 'We picked exercises based on your goals.\nTap "Start workout" to try it out.';

  String get tutorialWorkoutTypeTitle =>
      _isRu ? 'Два режима тренировки' : 'Two workout modes';
  String get tutorialWorkoutTypeBody => _isRu
      ? '«Быстрый старт» автоматически подбирает упражнения на основе ваших проблемных зон.\n\n«Своя тренировка» — выбирайте упражнения вручную из каталога.'
      : '"Quick start" automatically picks exercises based on your problem areas.\n\n"Custom workout" — choose exercises manually from the catalog.';

  String get tutorialExerciseTitle =>
      _isRu ? 'Управление тренировкой' : 'Workout controls';
  String get tutorialExerciseBody => _isRu
      ? '−15 / +15 — перемотка таймера на 15 секунд.\n\nПауза — откроет меню с опциями: пропустить упражнение или завершить тренировку.\n\n♡ — добавить упражнение в избранное.\n\nНажмите на таймер, чтобы изменить длительность.'
      : '−15 / +15 — rewind the timer by 15 seconds.\n\nPause — opens a menu: skip exercise or end workout.\n\n♡ — add exercise to favorites.\n\nTap the timer to change duration.';

  String get tutorialCustomTitle =>
      _isRu ? 'Выберите упражнения' : 'Pick your exercises';
  String get tutorialCustomBody => _isRu
      ? 'Нажмите на пустой слот, чтобы открыть каталог и выбрать упражнение.\n\nЗаполните все слоты, чтобы начать тренировку.\n\nНажмите на длительность, чтобы изменить её для этой тренировки.'
      : 'Tap an empty slot to open the catalog and pick an exercise.\n\nFill all slots to start the workout.\n\nTap the duration to change it for this workout.';

  // Logout
  String get logoutButton => _isRu ? 'Выйти' : 'Log out';
  String get logoutConfirmTitle => _isRu ? 'Выйти из аккаунта?' : 'Log out?';
  String get logoutConfirmText =>
      _isRu ? 'Ваши данные сохранятся' : 'Your data will be saved';
  String get logoutCancel => _isRu ? 'Отмена' : 'Cancel';

  // Exercise count
  String get exerciseCountLabel =>
      _isRu ? 'Количество упражнений' : 'Number of exercises';
  String get exerciseCountSub =>
      _isRu ? 'В каждой тренировке' : 'Per workout session';
  String get exerciseCountTitle => _isRu
      ? 'Сколько упражнений\nв тренировке?'
      : 'How many exercises\nper workout?';
  String get exerciseCountOnboardingSub => _isRu
      ? 'Каждое упражнение длится ~40 секунд'
      : 'Each exercise lasts ~40 seconds';
  String approxDuration(int totalSec) {
    final min = totalSec ~/ 60;
    final sec = totalSec % 60;
    if (sec == 0) return '≈ $min ${_isRu ? "мин" : "min"}';
    return '≈ $min ${_isRu ? "мин" : "min"} $sec ${_isRu ? "сек" : "sec"}';
  }

  String get canChangeLater => _isRu
      ? 'Можно изменить позже в настройках'
      : 'You can change this later in settings';

  // Streak
  String streakText(int n) {
    if (!_isRu) return '$n day streak';
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return '$n день подряд';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
      return '$n дня подряд';
    }
    return '$n дней подряд';
  }

  // Notification frequency
  String get hoursShort => _isRu ? 'ч' : 'h';
  String get minutesShort => _isRu ? 'мин' : 'min';
  String get everyLabel => _isRu ? 'Каждые' : 'Every';
  String get tapToChange => _isRu ? 'Нажмите, чтобы изменить' : 'Tap to change';

  /// Возвращает локализованное название категории упражнений по её идентификатору.
  /// Если id не найден в маппинге - возвращает сам id как fallback.
  /// @param id Идентификатор категории (neck, shoulders_arms, back_lower и др.).
  /// @return Локализованное название категории.
  String categoryTitle(String id) => switch (id) {
    'neck' => catNeck,
    'shoulders_arms' => catShouldersArms,
    'back_lower' => catBackLower,
    'eyes' => catEyes,
    'relaxation' => catRelaxation,
    'attention_switch' => catAttentionSwitch,
    'emotional_balance' => catEmotionalBalance,
    'wrists_hands' => catWristsHands,
    'legs_feet' => catLegsFeet,
    'posture_alignment' => catPostureAlignment,
    'breathing' => catBreathing,
    _ => id,
  };
}

/// Делегат для загрузки локализации Tr. Поддерживает локали 'ru' и 'en'.
/// Загрузка синхронна - просто создаёт экземпляр Tr с переданной локалью.
/// Не перезагружается при hot-reload (shouldReload возвращает false).
class _TrDelegate extends LocalizationsDelegate<Tr> {
  const _TrDelegate();
  @override
  bool isSupported(Locale locale) => ['ru', 'en'].contains(locale.languageCode);
  @override
  Future<Tr> load(Locale locale) async => Tr(locale);
  @override
  bool shouldReload(_TrDelegate old) => false;
}
