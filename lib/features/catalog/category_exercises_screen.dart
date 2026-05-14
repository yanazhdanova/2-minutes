import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../../shared/duration_picker_sheet.dart';
import '../exercises/domain/exercise_models.dart';

/// Экран списка упражнений конкретной категории. Загружает упражнения через FutureBuilder.
/// Каждое упражнение - тапабельная карточка: в свёрнутом состоянии
/// показывает только название, в раскрытом - описание и длительность.
/// Одновременно может быть раскрыта только одна карточка (tracked через _expandedId).
/// Открывается из PhysicalGroupsScreen или MentalGroupsScreen.
class CategoryExercisesScreen extends StatefulWidget {
  final String categoryId;
  final String title;
  const CategoryExercisesScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });
  @override
  State<CategoryExercisesScreen> createState() => _State();
}

class _State extends State<CategoryExercisesScreen> {
  String? _expandedId;
  final Map<String, bool> _favoriteState = {};
  Future<List<Exercise>>? _future;

  Future<void> _editDuration(Exercise e) async {
    final scope = AppScope.of(context);
    final result = await showDurationPickerSheet(
      context,
      initial: e.defaultDurationSec,
    );
    if (result != null && mounted) {
      await scope.exerciseRepo.updateDuration(e.id, result);
      if (!mounted) return;
      setState(() {
        _future = scope.exerciseRepo.exercisesByCategory(widget.categoryId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final repo = scope.exerciseRepo;
    final userData = scope.userData;
    _future ??= repo.exercisesByCategory(widget.categoryId);
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
                widget.title,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
            ),

            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<Exercise>>(
                future: _future,
                builder: (ctx, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(color: c.accentLight),
                    );
                  }

                  final items = snap.data ?? [];
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        t.noExercisesInCategory,
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
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final e = items[i];
                      final exp = _expandedId == e.id;
                      return InkWell(
                        onTap: () => setState(() {
                          _expandedId = exp ? null : e.id;
                          if (!exp) {
                            _favoriteState[e.id] = userData.isFavorite(e.id);
                          }
                        }),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: exp ? c.accentSurface : c.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                            border: Border.all(
                              color: exp ? c.accentLight : Colors.transparent,
                              width: 1.5,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.localizedTitle(t.locale.languageCode),
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: exp
                                            ? c.accentLight
                                            : c.textPrimary,
                                      ),
                                    ),
                                  ),

                                  AnimatedRotation(
                                    turns: exp ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeOutCubic,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: exp
                                          ? c.accentLight
                                          : c.textSecondary,
                                    ),
                                  ),
                                ],
                              ),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                reverseDuration: const Duration(
                                  milliseconds: 240,
                                ),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                layoutBuilder:
                                    (currentChild, previousChildren) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ...previousChildren,
                                          ?currentChild,
                                        ],
                                      );
                                    },
                                transitionBuilder: (child, animation) {
                                  return ClipRect(
                                    child: SizeTransition(
                                      sizeFactor: animation,
                                      axisAlignment: -1,
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    ),
                                  );
                                },
                                child: exp
                                    ? _ExerciseDetails(
                                        key: ValueKey('details-${e.id}'),
                                        exercise: e,
                                        colors: c,
                                        translations: t,
                                        isFavorite:
                                            _favoriteState[e.id] ?? false,
                                        onEditDuration: () => _editDuration(e),
                                        onToggleFavorite: () async {
                                          final result = await userData
                                              .toggleFavorite(e.id);
                                          setState(
                                            () => _favoriteState[e.id] = result,
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(
                                        key: ValueKey('collapsed'),
                                      ),
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

class _ExerciseDetails extends StatelessWidget {
  final Exercise exercise;
  final ResolvedColors colors;
  final Tr translations;
  final bool isFavorite;
  final VoidCallback onEditDuration;
  final Future<void> Function() onToggleFavorite;

  const _ExerciseDetails({
    super.key,
    required this.exercise,
    required this.colors,
    required this.translations,
    required this.isFavorite,
    required this.onEditDuration,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final c = colors;
    final t = translations;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.localizedDescription(t.locale.languageCode),
            style: AppTextStyles.body.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onEditDuration,
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t.durationSec(exercise.defaultDurationSec),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.edit, size: 14, color: c.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onToggleFavorite,
            child: Row(
              children: [
                Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? c.error : c.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  t.favoritesTitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isFavorite ? c.error : c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
