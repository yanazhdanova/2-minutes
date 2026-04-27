import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:two_mins/app/app_theme.dart';
import 'package:two_mins/app/app_scope.dart';
import 'package:two_mins/app/theme_controller.dart';
import 'package:two_mins/app/locale_controller.dart';
import 'package:two_mins/app/l10n/app_localizations.dart';
import 'package:two_mins/features/exercises/data/prefs_service.dart';
import 'package:two_mins/features/exercises/data/exercise_sqlite_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
Оборачивает виджет во все необходимые провайдеры для тестов.
@param prefs PrefsService, должен быть уже проинициализирован.
@param exerciseRepo ExerciseSqliteRepository (может быть мок).
@param locale начальная локаль (по умолчанию 'ru').
@param themeMode начальная тема (по умолчанию system).
@param accentColor начальный акцент (по умолчанию green).
*/
Widget wrapWithApp(
  Widget child, {
  required PrefsService prefs,
  required ExerciseSqliteRepository exerciseRepo,
  String locale = 'ru',
  ThemeMode themeMode = ThemeMode.light,
  AccentColor accentColor = AccentColor.green,
}) {
  final localeCtrl = LocaleController(prefs);
  final themeCtrl = ThemeController(prefs);

  return ThemeProvider(
    controller: themeCtrl,
    child: LocaleProvider(
      controller: localeCtrl,
      child: AppScope(
        exerciseRepo: exerciseRepo,
        prefs: prefs,
        child: MaterialApp(
          locale: Locale(locale),
          supportedLocales: Tr.supportedLocales,
          localizationsDelegates: const [
            Tr.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: buildAppTheme(isDark: false, accentColor: accentColor),
          darkTheme: buildAppTheme(isDark: true, accentColor: accentColor),
          themeMode: themeMode,
          builder: (context, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AppColorsProvider(
              colors: ResolvedColors.from(
                isDark: isDark,
                accentColor: accentColor,
              ),
              child: child!,
            );
          },
          home: child,
        ),
      ),
    ),
  );
}

/**
Минимальная обёртка только с AppColorsProvider для тестирования
виджетов, которым не нужен AppScope.
*/
Widget wrapWithTheme(
  Widget child, {
  bool isDark = false,
  AccentColor accentColor = AccentColor.green,
}) {
  final colors = ResolvedColors.from(isDark: isDark, accentColor: accentColor);
  return MaterialApp(
    locale: const Locale('ru'),
    supportedLocales: Tr.supportedLocales,
    localizationsDelegates: const [
      Tr.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: buildAppTheme(isDark: isDark, accentColor: accentColor),
    builder: (context, child) {
      return AppColorsProvider(colors: colors, child: child!);
    },
    home: child,
  );
}

/** Инициализирует SharedPreferences с пустыми значениями для тестов. */
Future<PrefsService> createTestPrefsService([
  Map<String, Object> initial = const {},
]) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = PrefsService();
  await prefs.init();
  return prefs;
}
