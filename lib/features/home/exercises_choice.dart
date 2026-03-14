import 'package:flutter/material.dart';
import 'package:two_mins/app/app_theme.dart';
import 'package:two_mins/app/navigation.dart';
import 'package:two_mins/app/main_tab_screen.dart';
import 'package:two_mins/shared/widgets.dart';
import 'package:two_mins/features/exercises/domain/exercise_models.dart';
import 'package:two_mins/features/workout/exercise_screen.dart';
import 'package:two_mins/features/home/home_phys_mental_screen.dart';

class ExercisesChoiceScreen extends StatefulWidget {
  const ExercisesChoiceScreen({super.key});

  @override
  State<ExercisesChoiceScreen> createState() => _ExercisesChoiceScreenState();
}

class _ExercisesChoiceScreenState extends State<ExercisesChoiceScreen> {
  final List<Exercise?> _slots = [null, null, null];

  bool get _allSelected => _slots.every((e) => e != null);

  Future<void> _pickExercise(int slotIndex) async {
    final Exercise? result = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(builder: (_) => const HomePhysMentalScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _slots[slotIndex] = result;
      });
    }
  }

  void _startWorkout() {
    final selected = _slots.whereType<Exercise>().toList();
    goToAndClear(
      context,
      ExerciseScreen(exercises: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              AppHeader(
                onBack: () => goToAndClear(context, const MainTabScreen()),
              ),

              const SizedBox(height: 24),

              Text(
                'Выберите\nупражнения',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 32),

              for (int i = 0; i < 3; i++) ...[
                _ExerciseSlot(
                  index: i + 1,
                  exercise: _slots[i],
                  onTap: () => _pickExercise(i),
                ),
                const SizedBox(height: 16),
              ],

              const Spacer(),

              PrimaryButton(
                label: 'Начать',
                width: double.infinity,
                onPressed: _allSelected ? _startWorkout : null,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseSlot extends StatelessWidget {
  final int index;
  final Exercise? exercise;
  final VoidCallback onTap;

  const _ExerciseSlot({
    required this.index,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = exercise != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: isSelected
              ? Border.all(color: AppColors.accent, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.border,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                isSelected ? exercise!.title : 'Выбрать упражнение',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              color: isSelected ? AppColors.accent : AppColors.textHint,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}