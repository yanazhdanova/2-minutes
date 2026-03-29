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

  static Future<void> setName(String name) async { (await SharedPreferences.getInstance()).setString(_keyName, name); }
  static Future<String?> getName() async => (await SharedPreferences.getInstance()).getString(_keyName);
  static Future<void> setOnboardingComplete(bool c) async { (await SharedPreferences.getInstance()).setBool(_keyOnboardingComplete, c); }
  static Future<bool> isOnboardingComplete() async => (await SharedPreferences.getInstance()).getBool(_keyOnboardingComplete) ?? false;
  static Future<void> setSelectedCategories(List<String> c) async { (await SharedPreferences.getInstance()).setStringList(_keyCategories, c); }
  static Future<List<String>> getSelectedCategories() async => (await SharedPreferences.getInstance()).getStringList(_keyCategories) ?? [];
  static Future<void> setNotifTimeRange({required int fromHour, required int fromMinute, required int toHour, required int toMinute}) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_keyNotifFromHour, fromHour); await p.setInt(_keyNotifFromMinute, fromMinute);
    await p.setInt(_keyNotifToHour, toHour); await p.setInt(_keyNotifToMinute, toMinute);
  }
  static Future<void> setNotifFrequency(String f) async { (await SharedPreferences.getInstance()).setString(_keyNotifFrequency, f); }
  static Future<void> clear() async { (await SharedPreferences.getInstance()).clear(); }
}