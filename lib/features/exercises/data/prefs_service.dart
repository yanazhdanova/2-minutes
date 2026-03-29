import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  bool get isOnboardingDone => _prefs.getBool(_keyOnboardingDone) ?? false;
  Future<void> setOnboardingDone(bool v) => _prefs.setBool(_keyOnboardingDone, v);

  String get userName => _prefs.getString(_keyUserName) ?? '';
  Future<void> setUserName(String n) => _prefs.setString(_keyUserName, n);

  List<String> get selectedCategories => _prefs.getStringList(_keyCategories) ?? [];
  Future<void> setSelectedCategories(List<String> c) => _prefs.setStringList(_keyCategories, c);

  String get notifFrom => _prefs.getString(_keyNotifFrom) ?? '09:00';
  String get notifTo => _prefs.getString(_keyNotifTo) ?? '21:00';
  Future<void> setNotifFrom(String t) => _prefs.setString(_keyNotifFrom, t);
  Future<void> setNotifTo(String t) => _prefs.setString(_keyNotifTo, t);

  String get notifFreq => _prefs.getString(_keyNotifFreq) ?? 'daily';
  Future<void> setNotifFreq(String f) => _prefs.setString(_keyNotifFreq, f);

  String get languageCode => _prefs.getString(_keyLanguageCode) ?? 'ru';
  Future<void> setLanguageCode(String code) => _prefs.setString(_keyLanguageCode, code);

  String get themeMode => _prefs.getString(_keyThemeMode) ?? 'system';
  Future<void> setThemeMode(String m) => _prefs.setString(_keyThemeMode, m);

  String get accentColor => _prefs.getString(_keyAccentColor) ?? 'green';
  Future<void> setAccentColor(String c) => _prefs.setString(_keyAccentColor, c);

  Future<void> clearAll() => _prefs.clear();
}