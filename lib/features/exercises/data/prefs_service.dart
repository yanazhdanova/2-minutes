import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для сохранения данных онбординга и пользовательских настроек.
class PrefsService {
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyUserName = 'user_name';
  static const _keyCategories = 'selected_categories';
  static const _keyNotifFrom = 'notif_from';
  static const _keyNotifTo = 'notif_to';
  static const _keyNotifFreq = 'notif_freq';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Онбординг ──
  bool get isOnboardingDone => _prefs.getBool(_keyOnboardingDone) ?? false;
  Future<void> setOnboardingDone(bool v) => _prefs.setBool(_keyOnboardingDone, v);

  // ── Имя ──
  String get userName => _prefs.getString(_keyUserName) ?? '';
  Future<void> setUserName(String n) => _prefs.setString(_keyUserName, n);

  // ── Категории ──
  List<String> get selectedCategories => _prefs.getStringList(_keyCategories) ?? [];
  Future<void> setSelectedCategories(List<String> c) => _prefs.setStringList(_keyCategories, c);

  // ── Время уведомлений ──
  String get notifFrom => _prefs.getString(_keyNotifFrom) ?? '09:00';
  String get notifTo => _prefs.getString(_keyNotifTo) ?? '21:00';
  Future<void> setNotifFrom(String t) => _prefs.setString(_keyNotifFrom, t);
  Future<void> setNotifTo(String t) => _prefs.setString(_keyNotifTo, t);

  // ── Частота ──
  String get notifFreq => _prefs.getString(_keyNotifFreq) ?? 'daily';
  Future<void> setNotifFreq(String f) => _prefs.setString(_keyNotifFreq, f);

  Future<void> clearAll() => _prefs.clear();
}