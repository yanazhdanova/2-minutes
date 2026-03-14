import 'package:flutter/material.dart';
import 'app/app_theme.dart';
import 'app/app_scope.dart';
import 'features/exercises/data/db/app_db.dart';
import 'features/exercises/data/exercise_catalog.dart';
import 'features/exercises/data/exercise_sqlite_repository.dart';
import 'features/exercises/data/prefs_service.dart';
import 'features/auth/login_screen.dart';
import 'app/main_tab_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const _InitScreen(),
    );
  }
}

class _InitScreen extends StatefulWidget {
  const _InitScreen();

  @override
  State<_InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<_InitScreen> {
  late Future<_AppDependencies> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initApp();
  }

  Future<_AppDependencies> _initApp() async {
    final prefs = PrefsService();
    await prefs.init();

    final exerciseRepo = ExerciseSqliteRepository(AppDb.instance);

    if (await exerciseRepo.isEmpty()) {
      await exerciseRepo.seed(
        categories: exerciseCategories,
        exercises: exercises,
      );
    }

    return _AppDependencies(exerciseRepo: exerciseRepo, prefs: prefs);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AppDependencies>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: Text(
                '2 минуты',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'Ошибка: ${snapshot.error}',
                style: AppTextStyles.body,
              ),
            ),
          );
        }

        final deps = snapshot.data!;

        return AppScope(
          exerciseRepo: deps.exerciseRepo,
          prefs: deps.prefs,
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) {
                // Для отладки: начинаем с логина
                return const LoginScreen();
                // Для продакшена:
                // if (deps.prefs.isOnboardingDone) {
                //   return const MainTabScreen();
                // }
                // return const LoginScreen();
              },
            ),
          ),
        );
      },
    );
  }
}

class _AppDependencies {
  final ExerciseSqliteRepository exerciseRepo;
  final PrefsService prefs;

  _AppDependencies({required this.exerciseRepo, required this.prefs});
}