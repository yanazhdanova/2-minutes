import 'package:flutter/widgets.dart';
import '../features/exercises/data/prefs_service.dart';

/**
Контроллер локали приложения. Управляет текущим языком (ru/en).
При создании считывает сохранённый languageCode из PrefsService.
При смене языка - сохраняет в PrefsService и уведомляет слушателей,
что приводит к пересборке MaterialApp с новой локалью через LocaleProvider.
*/
class LocaleController extends ChangeNotifier {
  final PrefsService _prefs;
  late Locale _locale;

  /**
  Создаёт контроллер, считывая текущий languageCode из [prefs].
  Если languageCode не сохранён - PrefsService возвращает 'ru' по умолчанию.
  */
  LocaleController(this._prefs) {
    _locale = Locale(_prefs.languageCode);
  }

  /** Текущая локаль приложения (Locale('ru') или Locale('en')). */
  Locale get locale => _locale;

  /**
  Меняет язык приложения. Если локаль не изменилась - ничего не делает.
  Сохраняет languageCode в SharedPreferences и вызывает notifyListeners(),
  что пересобирает MaterialApp с новыми локализованными строками.
  @param locale Новая локаль (например, Locale('en')).
  */
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs.setLanguageCode(locale.languageCode);
    notifyListeners();
  }

  /**
  Получает LocaleController из ближайшего LocaleProvider в дереве виджетов.
  @param context BuildContext вызывающего виджета.
  @return Экземпляр LocaleController.
  @throws AssertionError если LocaleProvider не найден.
  */
  static LocaleController of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
    assert(p != null, 'LocaleProvider not found');
    return p!.controller;
  }
}

/**
InheritedNotifier-обёртка для LocaleController.
Автоматически пересобирает зависимое поддерево при каждом notifyListeners()
контроллера (смена языка приложения).
*/
class LocaleProvider extends InheritedNotifier<LocaleController> {
  final LocaleController controller;
  const LocaleProvider({
    super.key,
    required this.controller,
    required super.child,
  }) : super(notifier: controller);
}
