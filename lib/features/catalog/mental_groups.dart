import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';
import 'category_exercises_screen.dart';

/// Экран списка категорий ментальных упражнений (вкладка «Каталог» - «Ментальные»).
/// Загружает категории типа HealthType.mental через FutureBuilder. Каждая категория -
/// тапабельная карточка со стрелкой, при нажатии открывает CategoryExercisesScreen
/// с локализованным заголовком. Показывает пустое состояние, если категорий нет.
class MentalGroupsScreen extends StatelessWidget {
  const MentalGroupsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: AppHeader(onBack: () => Navigator.pop(context)),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: Text(
                t.mentalTitle,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
            ),

            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<ExerciseCategory>>(
                future: repo.categoriesByType(HealthType.mental),
                builder: (ctx, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(color: c.accentLight),
                    );
                  }

                  final cats = snap.data ?? [];
                  if (cats.isEmpty) {
                    return Center(
                      child: Text(
                        t.noCategories,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    itemCount: cats.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final cat = cats[i];
                      return InkWell(
                        onTap: () => goTo(
                          context,
                          CategoryExercisesScreen(
                            categoryId: cat.id,
                            title: t.categoryTitle(cat.id),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  t.categoryTitle(cat.id),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: c.textPrimary,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: c.textSecondary),
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
