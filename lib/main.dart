import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/app_theme.dart';
import 'app/app_scope.dart';
import 'app/locale_controller.dart';
import 'app/theme_controller.dart';
import 'app/l10n/app_localizations.dart';
import 'features/exercises/data/db/app_db.dart';
import 'features/exercises/data/exercise_catalog.dart';
import 'features/exercises/data/exercise_sqlite_repository.dart';
import 'features/exercises/data/prefs_service.dart';
import 'features/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/exercises/data/notification_service.dart';

/**
Точка входа приложения. Выполняет последовательную инициализацию:
1. Инициализирует Flutter-binding для доступа к нативным плагинам до запуска.
2. Подключает Firebase с платформо-специфичными настройками.
3. Инициализирует сервис локальных уведомлений (таймзоны, плагин).
4. Загружает пользовательские настройки из SharedPreferences через PrefsService.
5. Создаёт SQLite-репозиторий упражнений и при первом запуске заполняет БД каталогом.
6. Запускает MyApp с готовыми зависимостями.
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.init();
  final prefs = PrefsService();
  await prefs.init();
  final exerciseRepo = ExerciseSqliteRepository(AppDb.instance);

  if (await exerciseRepo.isEmpty()) {
    await exerciseRepo.seed(
      categories: exerciseCategories,
      exercises: exercises,
    );
  }

  runApp(
    MyApp(
      exerciseRepo: exerciseRepo,
      prefs: prefs,
      localeCtrl: LocaleController(prefs),
      themeCtrl: ThemeController(prefs),
    ),
  );
}

/**
Корневой виджет приложения. Собирает дерево провайдеров в следующем порядке:
ThemeProvider - LocaleProvider - AppScope - ListenableBuilder - MaterialApp.
ListenableBuilder слушает изменения ThemeController и LocaleController
одновременно и пересобирает MaterialApp при смене темы, акцента или языка.
AppColorsProvider оборачивает child MaterialApp через builder, чтобы
ResolvedColors учитывала реальную яркость (Brightness) после применения themeMode.
Стартовый экран - LoginScreen.
*/
class MyApp extends StatelessWidget {
  final ExerciseSqliteRepository exerciseRepo;
  final PrefsService prefs;
  final LocaleController localeCtrl;
  final ThemeController themeCtrl;

  const MyApp({
    super.key,
    required this.exerciseRepo,
    required this.prefs,
    required this.localeCtrl,
    required this.themeCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      controller: themeCtrl,
      child: LocaleProvider(
        controller: localeCtrl,
        child: AppScope(
          exerciseRepo: exerciseRepo,
          prefs: prefs,
          child: ListenableBuilder(
            listenable: Listenable.merge([themeCtrl, localeCtrl]),

            builder: (context, _) {
              final accent = themeCtrl.accentColor;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: themeCtrl.themeMode,
                theme: buildAppTheme(isDark: false, accentColor: accent),
                darkTheme: buildAppTheme(isDark: true, accentColor: accent),
                locale: localeCtrl.locale,
                supportedLocales: Tr.supportedLocales,
                localizationsDelegates: const [
                  Tr.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                builder: (context, child) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return AppColorsProvider(
                    colors: ResolvedColors.from(
                      isDark: isDark,
                      accentColor: accent,
                    ),
                    child: child!,
                  );
                },
                home: const LoginScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
