import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../exercises/domain/exercise_models.dart';

class HomeCatalogPhysScreen extends StatelessWidget {
  const HomeCatalogPhysScreen({super.key});

  Future<void> _pickRandom(BuildContext context) async {
    final repo = AppScope.of(context).exerciseRepo;
    final cats = await repo.categoriesByType(HealthType.physical);
    final all = <Exercise>[];
    for (final c in cats) {
      all.addAll(await repo.exercisesByCategory(c.id));
    }
    if (all.isNotEmpty && context.mounted) {
      Navigator.pop(context, all[Random().nextInt(all.length)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Физические'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<ExerciseCategory>>(
        future: repo.categoriesByType(HealthType.physical),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Кнопка "Случайное"
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade300,
                title: const Text('Случайное'),
                trailing: const Icon(Icons.shuffle),
                onTap: () => _pickRandom(context),
              ),
              const SizedBox(height: 12),

              // Категории с выпадающими списками
              for (final cat in categories) ...[
                _CategoryExpansionTile(
                  category: cat,
                  onExerciseSelected: (exercise) {
                    Navigator.pop(context, exercise);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryExpansionTile extends StatelessWidget {
  final ExerciseCategory category;
  final ValueChanged<Exercise> onExerciseSelected;

  const _CategoryExpansionTile({
    required this.category,
    required this.onExerciseSelected,
  });

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(category.title),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: [
          FutureBuilder<List<Exercise>>(
            future: repo.exercisesByCategory(category.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final exercises = snapshot.data ?? [];

              if (exercises.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Нет упражнений'),
                );
              }

              return Column(
                children: [
                  for (final exercise in exercises)
                    ListTile(
                      dense: true,
                      title: Text(exercise.title),
                      subtitle: Text(
                        exercise.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.add_circle_outline, size: 20),
                      onTap: () => onExerciseSelected(exercise),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}