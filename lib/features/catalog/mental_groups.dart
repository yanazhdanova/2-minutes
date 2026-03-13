import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../../app/app_scope.dart';
import '../exercises/domain/exercise_models.dart';
import 'category_exercises_screen.dart';

class MentalGroupsScreen extends StatelessWidget {
  const MentalGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental groups'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<ExerciseCategory>>(
        future: repo.categoriesByType(HealthType.mental),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(child: Text('Нет категорий'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = categories[index];

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade200,
                title: Text(category.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => goTo(
                  context,
                  CategoryExercisesScreen(
                    categoryId: category.id,
                    title: category.title,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
