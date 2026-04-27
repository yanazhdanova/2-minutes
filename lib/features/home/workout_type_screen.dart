import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/data/workout_generator.dart';
import '../exercises/data/prefs_service.dart';
import '../workout/exercise_screen.dart';
import 'exercises_choice.dart';

/**
Экран выбора типа тренировки. Два варианта:
1. «Быстрый старт» - автоматически подбирает 3 упражнения через WorkoutGenerator
   на основе проблемных зон из настроек пользователя и переходит на ExerciseScreen.
   Если упражнений нет - показывает SnackBar с ошибкой.
2. «Своя тренировка» - переходит на ExercisesChoiceScreen для ручного выбора 3 упражнений.
*/
class WorkoutTypeScreen extends StatelessWidget {
  const WorkoutTypeScreen({super.key});

  Future<void> _quickStart(BuildContext context) async {
    final scope = AppScope.of(context);
    final generator = WorkoutGenerator(scope.exerciseRepo);
    final problems =
        scope.prefs.selectedCategories; // список проблем из онбординга

    final exercises = await generator.generate(problems);

    if (exercises.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Tr.of(context).noExercises),
            backgroundColor: C(context).error,
          ),
        );
      }
      return;
    }

    if (context.mounted) {
      goToAndClear(context, ExerciseScreen(exercises: exercises));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),
              const Spacer(flex: 2),
              Text(
                t.workoutTypeTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 40),

              _TypeCard(
                icon: Icons.bolt,
                title: t.quickStartTitle,
                subtitle: t.quickStartSub,
                isAccent: true,
                onTap: () => _quickStart(context),
              ),

              const SizedBox(height: 16),

              _TypeCard(
                icon: Icons.tune,
                title: t.customWorkoutTitle,
                subtitle: t.customWorkoutSub,
                isAccent: false,
                onTap: () => goTo(context, const ExercisesChoiceScreen()),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

/** Карточка варианта тренировки с иконкой, заголовком и описанием. */
class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isAccent;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isAccent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isAccent ? c.accentSurface : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: isAccent
              ? Border.all(color: c.accentLight, width: 1.5)
              : null,
        ),

        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isAccent ? c.accent : c.border,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isAccent ? c.white : c.textSecondary,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isAccent ? c.accentLight : c.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: isAccent ? c.accentLight : c.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
