import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';

/// Экран выбора упражнения из избранного для ручной тренировки.
/// Отображает список избранных упражнений как тапабельные строки.
/// При тапе возвращает выбранное Exercise через Navigator.pop.
/// Используется из HomePhysMentalScreen, HomeCatalogPhysScreen, HomeCatalogMentalScreen.
class HomeFavoritesScreen extends StatelessWidget {
  final List<Exercise> exercises;
  const HomeFavoritesScreen({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.favoritesTitle,
                  style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                itemCount: exercises.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (ctx, i) {
                  final e = exercises[i];
                  return InkWell(
                    onTap: () => Navigator.pop(context, e),
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
                                  e.title,
                                  style: AppTextStyles.body.copyWith(
                                    color: c.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  e.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: c.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: c.accentSurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add,
                              color: c.accentLight,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
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
