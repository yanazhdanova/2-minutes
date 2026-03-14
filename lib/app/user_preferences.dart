import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyName = 'user_name';
  static const _keyOnboardingComplete = 'onboarding_complete';
  static const _keyCategories = 'selected_categories';
  static const _keyNotifFromHour = 'notif_from_hour';
  static const _keyNotifFromMinute = 'notif_from_minute';
  static const _keyNotifToHour = 'notif_to_hour';
  static const _keyNotifToMinute = 'notif_to_minute';
  static const _keyNotifFrequency = 'notif_frequency';

  static Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<void> setOnboardingComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingComplete, complete);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  static Future<void> setSelectedCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCategories, categories);
  }

  static Future<List<String>> getSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCategories) ?? [];
  }

  static Future<void> setNotifTimeRange({
    required int fromHour,
    required int fromMinute,
    required int toHour,
    required int toMinute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNotifFromHour, fromHour);
    await prefs.setInt(_keyNotifFromMinute, fromMinute);
    await prefs.setInt(_keyNotifToHour, toHour);
    await prefs.setInt(_keyNotifToMinute, toMinute);
  }

  static Future<Map<String, int>> getNotifTimeRange() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'fromHour': prefs.getInt(_keyNotifFromHour) ?? 9,
      'fromMinute': prefs.getInt(_keyNotifFromMinute) ?? 0,
      'toHour': prefs.getInt(_keyNotifToHour) ?? 21,
      'toMinute': prefs.getInt(_keyNotifToMinute) ?? 0,
    };
  }

  static Future<void> setNotifFrequency(String frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNotifFrequency, frequency);
  }

  static Future<String> getNotifFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNotifFrequency) ?? 'daily';
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}