import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';
import 'home_favorites_screen.dart';

/// Каталог физических упражнений для выбора в тренировку. Загружает категории типа
/// HealthType.physical через FutureBuilder. Каждая категория отображается как
/// ExpansionTile (_CatTile), при раскрытии которого загружаются упражнения этой категории.
/// Сверху - плитка «Случайное упражнение» (_RandomTile), выбирающая случайное
/// из всех физических категорий. Выбранное упражнение возвращается через Navigator.pop.
class HomeCatalogPhysScreen extends StatelessWidget {
  const HomeCatalogPhysScreen({super.key});

  Future<void> _pickFromFavorites(BuildContext ctx) async {
    final scope = AppScope.of(ctx);
    final ids = scope.userData.favoriteIds;
    final list = <Exercise>[];
    for (final id in ids) {
      final ex = await scope.exerciseRepo.exerciseById(id);
      if (ex != null) list.add(ex);
    }
    if (!ctx.mounted) return;
    if (list.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(Tr.of(ctx).favoritesEmpty)),
      );
      return;
    }
    final r = await Navigator.push<Exercise>(
      ctx,
      MaterialPageRoute(
        builder: (_) => HomeFavoritesScreen(exercises: list),
      ),
    );
    if (r != null && ctx.mounted) Navigator.pop(ctx, r);
  }

  Future<void> _pickRandom(BuildContext ctx) async {
    final repo = AppScope.of(ctx).exerciseRepo;
    final all = <Exercise>[];
    for (final c in await repo.categoriesByType(HealthType.physical)) {
      all.addAll(await repo.exercisesByCategory(c.id));
    }
    if (all.isNotEmpty && ctx.mounted) {
      Navigator.pop(ctx, all[Random().nextInt(all.length)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;
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
                  t.physicalTitle,
                  style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<ExerciseCategory>>(
                future: repo.categoriesByType(HealthType.physical),
                builder: (ctx, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(color: c.accentLight),
                    );
                  }
                  final cats = snap.data ?? [];
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    children: [
                      _RandomTile(
                        label: t.randomExercise,
                        icon: Icons.shuffle,
                        onTap: () => _pickRandom(context),
                      ),
                      const SizedBox(height: 12),
                      _RandomTile(
                        label: t.favoritesTitle,
                        icon: Icons.favorite_border,
                        onTap: () => _pickFromFavorites(context),
                      ),
                      const SizedBox(height: 20),
                      for (final cat in cats) ...[
                        _CatTile(
                          cat: cat,
                          localTitle: t.categoryTitle(cat.id),
                          onPick: (e) => Navigator.pop(context, e),
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

/// Плитка «Случайное упражнение» / «Избранное» в верхней части каталога.
class _RandomTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _RandomTile({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.accentSurface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),

        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: c.white, size: 20),
            ),

            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(color: c.accentLight),
            ),
          ],
        ),
      ),
    );
  }
}

/// Раскрывающаяся плитка категории с загрузкой упражнений по запросу.
class _CatTile extends StatelessWidget {
  final ExerciseCategory cat;
  final String localTitle;
  final ValueChanged<Exercise> onPick;
  const _CatTile({
    required this.cat,
    required this.localTitle,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;
    final c = C(context);
    final t = Tr.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),

      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            localTitle,
            style: AppTextStyles.bodyLarge.copyWith(color: c.textPrimary),
          ),

          iconColor: c.textSecondary,
          collapsedIconColor: c.textSecondary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          children: [
            FutureBuilder<List<Exercise>>(
              future: repo.exercisesByCategory(cat.id),
              builder: (ctx, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: c.accentLight,
                        ),
                      ),
                    ),
                  );
                }

                final exs = snap.data ?? [];
                if (exs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      t.noExercises,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  );
                }

                return Column(
                  children: exs
                      .map(
                        (e) => InkWell(
                          onTap: () => onPick(e),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
