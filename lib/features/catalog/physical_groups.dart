import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';
import 'category_exercises_screen.dart';

class PhysicalGroupsScreen extends StatelessWidget {
  const PhysicalGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
              child: AppHeader(onBack: () => Navigator.pop(context)),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
              child: Text('Физические', style: AppTextStyles.heading2),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: FutureBuilder<List<ExerciseCategory>>(
                future: repo.categoriesByType(HealthType.physical),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }

                  final categories = snapshot.data ?? [];

                  if (categories.isEmpty) {
                    return Center(
                      child: Text('Нет категорий', style: AppTextStyles.bodySmall),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return InkWell(
                        onTap: () => goTo(
                          context,
                          CategoryExercisesScreen(
                            categoryId: category.id,
                            title: category.title,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  category.title,
                                  style: AppTextStyles.bodyLarge,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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