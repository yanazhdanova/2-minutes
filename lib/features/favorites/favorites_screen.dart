import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';
import '../workout/exercise_screen.dart';

/// Экран избранных упражнений. Загружает ID из PrefsService.favoriteIds,
/// затем получает полные Exercise через exerciseRepo.exerciseById.
/// Карточки с AnimatedCrossFade (expand/collapse) аналогично CategoryExercisesScreen.
/// Позволяет удалять упражнения из избранного и начинать тренировку из списка.
/// Пустое состояние показывает текст favoritesEmpty.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Exercise> _favorites = [];
  bool _loading = true;
  String? _expandedId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final scope = AppScope.of(context);
    final ids = scope.userData.favoriteIds;
    final list = <Exercise>[];
    for (final id in ids) {
      final ex = await scope.exerciseRepo.exerciseById(id);
      if (ex != null) list.add(ex);
    }
    if (mounted) setState(() { _favorites = list; _loading = false; });
  }

  Future<void> _remove(String exerciseId) async {
    final userData = AppScope.of(context).userData;
    await userData.removeFavorite(exerciseId);
    if (mounted) {
      setState(() {
        _favorites.removeWhere((e) => e.id == exerciseId);
        if (_expandedId == exerciseId) _expandedId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                t.favoritesTitle,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildBody(c, t)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ResolvedColors c, Tr t) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: c.accentLight),
      );
    }

    if (_favorites.isEmpty) {
      return Center(
        child: Text(
          t.favoritesEmpty,
          style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            itemCount: _favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final e = _favorites[i];
              final exp = _expandedId == e.id;
              return InkWell(
                onTap: () =>
                    setState(() => _expandedId = exp ? null : e.id),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: exp ? c.accentSurface : c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: exp
                        ? Border.all(color: c.accentLight, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.title,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: exp ? c.accentLight : c.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  t.categoryTitle(e.categoryId),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: c.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _remove(e.id),
                            child: Icon(
                              Icons.favorite,
                              color: c.error,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedRotation(
                            turns: exp ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: exp ? c.accentLight : c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: c.border,
                                  borderRadius: BorderRadius.circular(AppRadius.small),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_circle_outline, color: c.textSecondary, size: 48),
                                    const SizedBox(height: 8),
                                    Text(t.video, style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                e.description,
                                style: AppTextStyles.body.copyWith(
                                  color: c.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                t.durationSec(e.defaultDurationSec),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        crossFadeState: exp
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                        sizeCurve: Curves.easeOut,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: PrimaryButton(
            label: t.startWorkout,
            width: double.infinity,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExerciseScreen(exercises: _favorites),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
