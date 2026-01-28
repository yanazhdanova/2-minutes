import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';
import 'features/exercises/data/db/app_db.dart';
import 'features/exercises/data/exercise_sqlite_repository.dart';
import 'features/exercises/data/exercise_catalog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = ExerciseSqliteRepository(AppDb.instance);

  if (await repo.isEmpty()) {
  await repo.seed(categories: exerciseCategories, exercises: exercises);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
