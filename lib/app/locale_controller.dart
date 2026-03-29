import 'package:flutter/widgets.dart';
import '../features/exercises/data/prefs_service.dart';

class LocaleController extends ChangeNotifier {
  final PrefsService _prefs;
  late Locale _locale;

  LocaleController(this._prefs) { _locale = Locale(_prefs.languageCode); }

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs.setLanguageCode(locale.languageCode);
    notifyListeners();
  }

  static LocaleController of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
    assert(p != null, 'LocaleProvider not found');
    return p!.controller;
  }
}

class LocaleProvider extends InheritedNotifier<LocaleController> {
  final LocaleController controller;
  const LocaleProvider({super.key, required this.controller, required super.child}) : super(notifier: controller);
}