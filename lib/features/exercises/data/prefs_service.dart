import 'package:shared_preferences/shared_preferences.dart';

/**
Сервис настроек - обёртка над SharedPreferences для всех пользовательских параметров.
В отличие от UserPreferences (статический, создаёт экземпляр SP при каждом вызове),
PrefsService кэширует экземпляр SharedPreferences после init() и предоставляет
синхронные геттеры для чтения. Используется в runtime через AppScope.
Хранит: онбординг, имя, категории, уведомления (время/частота/дни), язык, тему, акцент.
*/
class PrefsService {
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyUserName = 'user_name';
  static const _keyCategories = 'selected_categories';
  static const _keyNotifFrom = 'notif_from';
  static const _keyNotifTo = 'notif_to';
  static const _keyNotifFreq = 'notif_freq';
  static const _keyLanguageCode = 'language_code';
  static const _keyThemeMode = 'theme_mode';
  static const _keyAccentColor = 'accent_color';

  late final SharedPreferences _prefs;

  /**
  Инициализирует SharedPreferences. Должен быть вызван один раз в main()
  до любого обращения к геттерам, иначе late-поле _prefs бросит ошибку.
  */
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  /** Завершён ли онбординг (false по умолчанию). */
  bool get isOnboardingDone => _prefs.getBool(_keyOnboardingDone) ?? false;
  /** Отмечает онбординг как завершённый или нет. */
  Future<void> setOnboardingDone(bool v) =>
      _prefs.setBool(_keyOnboardingDone, v);

  /** Имя пользователя, отображаемое в приветствии на главном экране (пустая строка по умолчанию). */
  String get userName => _prefs.getString(_keyUserName) ?? '';
  /** Сохраняет имя пользователя. */
  Future<void> setUserName(String n) => _prefs.setString(_keyUserName, n);

  /** Список идентификаторов выбранных проблемных зон (posture, back, neck и др.). Пустой по умолчанию. */
  List<String> get selectedCategories =>
      _prefs.getStringList(_keyCategories) ?? [];
  /** Сохраняет список выбранных проблемных зон. */
  Future<void> setSelectedCategories(List<String> c) =>
      _prefs.setStringList(_keyCategories, c);

  /** Время начала уведомлений в формате HH:mm (09:00 по умолчанию). */
  String get notifFrom => _prefs.getString(_keyNotifFrom) ?? '09:00';
  /** Время окончания уведомлений в формате HH:mm (21:00 по умолчанию). */
  String get notifTo => _prefs.getString(_keyNotifTo) ?? '21:00';
  /** Сохраняет время начала уведомлений. */
  Future<void> setNotifFrom(String t) => _prefs.setString(_keyNotifFrom, t);
  /** Сохраняет время окончания уведомлений. */
  Future<void> setNotifTo(String t) => _prefs.setString(_keyNotifTo, t);

  /** Частота уведомлений в минутах как строка ('daily' по умолчанию). Парсится в int при расчёте расписания. */
  String get notifFreq => _prefs.getString(_keyNotifFreq) ?? 'daily';
  /** Сохраняет частоту уведомлений (количество минут как строка). */
  Future<void> setNotifFreq(String f) => _prefs.setString(_keyNotifFreq, f);

  /** Код языка приложения ('ru' по умолчанию). Используется LocaleController. */
  String get languageCode => _prefs.getString(_keyLanguageCode) ?? 'ru';
  /** Сохраняет код языка. */
  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_keyLanguageCode, code);

  /** Режим темы как строка: 'system', 'light' или 'dark' ('system' по умолчанию). Используется ThemeController. */
  String get themeMode => _prefs.getString(_keyThemeMode) ?? 'system';
  /** Сохраняет режим темы. */
  Future<void> setThemeMode(String m) => _prefs.setString(_keyThemeMode, m);

  /** Акцентный цвет как строка: 'green' или 'pink' ('green' по умолчанию). Используется ThemeController. */
  String get accentColor => _prefs.getString(_keyAccentColor) ?? 'green';
  /** Сохраняет акцентный цвет. */
  Future<void> setAccentColor(String c) => _prefs.setString(_keyAccentColor, c);

  /** Удаляет все ключи из SharedPreferences. Используется для сброса настроек. */
  Future<void> clearAll() => _prefs.clear();

  static const _keyNotifDays = 'notif_days';

  /**
  Дни недели для уведомлений (1=Пн, 2=Вт, ..., 7=Вс).
  Хранятся как List<String> в SharedPreferences, парсятся в int при чтении.
  По умолчанию - все 7 дней, если значение не задано.
  */
  List<int> get notifDays {
    final list = _prefs.getStringList(_keyNotifDays);
    if (list == null) return [1, 2, 3, 4, 5, 6, 7];
    return list.map(int.parse).toList();
  }

  /** Сохраняет дни недели для уведомлений. Конвертирует int в String для SharedPreferences. */
  Future<void> setNotifDays(List<int> days) =>
      _prefs.setStringList(_keyNotifDays, days.map((d) => '$d').toList());
}
