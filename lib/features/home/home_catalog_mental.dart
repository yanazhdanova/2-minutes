import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';

class HomeCatalogMentalScreen extends StatelessWidget {
  const HomeCatalogMentalScreen({super.key});

  Future<void> _pickRandom(BuildContext context) async {
    final repo = AppScope.of(context).exerciseRepo;
    final cats = await repo.categoriesByType(HealthType.mental);
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
              child: AppHeader(onBack: () => Navigator.pop(context)),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Ментальные', style: AppTextStyles.heading2),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<ExerciseCategory>>(
                future: repo.categoriesByType(HealthType.mental),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }
                  final categories = snapshot.data ?? [];

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                    children: [

                      InkWell(
                        onTap: () => _pickRandom(context),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.accentSurface,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.shuffle,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Случайное упражнение',
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.accent),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),


                      for (final cat in categories) ...[
                        _CategoryExpansionTile(
                          category: cat,
                          onExerciseSelected: (exercise) {
                            Navigator.pop(context, exercise);
                          },
                        ),
                        const SizedBox(height: 12),
                      ],

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            category.title,
            style: AppTextStyles.bodyLarge,
          ),
          iconColor: AppColors.textSecondary,
          collapsedIconColor: AppColors.textSecondary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          childrenPadding: const EdgeInsets.only(bottom: 12),
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
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  );
                }

                final exercises = snapshot.data ?? [];

                if (exercises.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Нет упражнений',
                      style: AppTextStyles.bodySmall,
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final exercise in exercises)
                      InkWell(
                        onTap: () => onExerciseSelected(exercise),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise.title,
                                      style: AppTextStyles.body,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      exercise.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.accentSurface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.accent,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}