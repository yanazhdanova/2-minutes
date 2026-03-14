import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';

class CategoryExercisesScreen extends StatefulWidget {
  final String categoryId;
  final String title;

  const CategoryExercisesScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<CategoryExercisesScreen> createState() => _CategoryExercisesScreenState();
}

class _CategoryExercisesScreenState extends State<CategoryExercisesScreen> {
  String? _expandedExerciseId;

  void _toggle(String id) {
    setState(() {
      _expandedExerciseId = (_expandedExerciseId == id) ? null : id;
    });
  }

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
              child: Text(widget.title, style: AppTextStyles.heading2),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: FutureBuilder<List<Exercise>>(
                future: repo.exercisesByCategory(widget.categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Нет упражнений в этой категории',
                        style: AppTextStyles.bodySmall,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final e = items[i];
                      final isExpanded = _expandedExerciseId == e.id;

                      return _ExerciseCard(
                        exercise: e,
                        isExpanded: isExpanded,
                        onTap: () => _toggle(e.id),
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

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final bool isExpanded;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.exercise,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isExpanded ? AppColors.accentSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: isExpanded
              ? Border.all(color: AppColors.accent, width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isExpanded ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: isExpanded ? AppColors.accent : AppColors.textSecondary,
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
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            color: AppColors.textSecondary,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Видео',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      exercise.description,
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Длительность: ${exercise.defaultDurationSec} сек',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
              sizeCurve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }
}