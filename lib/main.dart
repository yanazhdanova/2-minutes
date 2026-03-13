import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';
import 'features/exercises/data/db/app_db.dart';
import 'features/exercises/data/exercise_sqlite_repository.dart';
import 'features/exercises/data/exercise_catalog.dart';
import 'app/app_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = ExerciseSqliteRepository(AppDb.instance);

  if (await repo.isEmpty()) {
    await repo.seed(categories: exerciseCategories, exercises: exercises);
  }

  runApp(MyApp(exerciseRepo: repo));
}

class MyApp extends StatelessWidget {
  final ExerciseSqliteRepository exerciseRepo;

  const MyApp({super.key, required this.exerciseRepo});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      exerciseRepo: exerciseRepo,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
