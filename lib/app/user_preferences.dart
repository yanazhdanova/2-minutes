import 'package:shared_preferences/shared_preferences.dart';

/// Статический хелпер для чтения/записи пользовательских настроек через SharedPreferences.
/// Используется на экранах онбординга для сохранения имени, выбранных категорий,
/// временного диапазона и частоты уведомлений. Каждый метод самостоятельно
/// получает экземпляр SharedPreferences - подходит для редких вызовов (онбординг),
/// для частых операций используется PrefsService с кэшированным экземпляром.
class UserPreferences {
  static const _keyName = 'user_name';
  static const _keyOnboardingComplete = 'onboarding_complete';
  static const _keyCategories = 'selected_categories';
  static const _keyNotifFromHour = 'notif_from_hour';
  static const _keyNotifFromMinute = 'notif_from_minute';
  static const _keyNotifToHour = 'notif_to_hour';
  static const _keyNotifToMinute = 'notif_to_minute';
  static const _keyNotifFrequency = 'notif_frequency';

  /// Сохраняет имя пользователя, введённое на экране онбординга.
  /// @param name Имя пользователя (отображается на главном экране в приветствии).
  static Future<void> setName(String name) async {
    (await SharedPreferences.getInstance()).setString(_keyName, name);
  }

  /// Возвращает сохранённое имя пользователя.
  /// @return Имя или null, если пользователь ещё не прошёл онбординг.
  static Future<String?> getName() async =>
      (await SharedPreferences.getInstance()).getString(_keyName);
  /// Отмечает завершение онбординга. После этого LoginScreen направляет
  /// пользователя на MainTabScreen вместо NameScreen.
  /// @param c true если онбординг завершён.
  static Future<void> setOnboardingComplete(bool c) async {
    (await SharedPreferences.getInstance()).setBool(_keyOnboardingComplete, c);
  }

  /// Проверяет, завершён ли онбординг. Используется в LoginScreen._navigateAfterAuth()
  /// для выбора между MainTabScreen и NameScreen.
  /// @return true если онбординг завершён, false по умолчанию.
  static Future<bool> isOnboardingComplete() async =>
      (await SharedPreferences.getInstance()).getBool(_keyOnboardingComplete) ??
      false;
  /// Сохраняет список выбранных проблемных зон (posture, back, neck, eyes и др.).
  /// Используется WorkoutGenerator для автоподбора упражнений при быстром старте.
  /// @param c Список идентификаторов проблем.
  static Future<void> setSelectedCategories(List<String> c) async {
    (await SharedPreferences.getInstance()).setStringList(_keyCategories, c);
  }

  /// Возвращает список выбранных проблемных зон.
  /// @return Список идентификаторов проблем или пустой список, если ничего не выбрано.
  static Future<List<String>> getSelectedCategories() async =>
      (await SharedPreferences.getInstance()).getStringList(_keyCategories) ??
      [];
  /// Сохраняет временной диапазон для уведомлений.
  /// Значения хранятся как 4 отдельных int-ключа в SharedPreferences.
  /// @param fromHour Час начала (0-23).
  /// @param fromMinute Минута начала (0-59).
  /// @param toHour Час конца (0-23).
  /// @param toMinute Минута конца (0-59).
  static Future<void> setNotifTimeRange({
    required int fromHour,
    required int fromMinute,
    required int toHour,
    required int toMinute,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_keyNotifFromHour, fromHour);
    await p.setInt(_keyNotifFromMinute, fromMinute);
    await p.setInt(_keyNotifToHour, toHour);
    await p.setInt(_keyNotifToMinute, toMinute);
  }

  /// Сохраняет частоту уведомлений в виде строки с количеством минут.
  /// @param f Частота в минутах (например, "60" для уведомления каждый час).
  static Future<void> setNotifFrequency(String f) async {
    (await SharedPreferences.getInstance()).setString(_keyNotifFrequency, f);
  }

  /// Очищает все сохранённые настройки. Удаляет все ключи из SharedPreferences.
  static Future<void> clear() async {
    (await SharedPreferences.getInstance()).clear();
  }
}
