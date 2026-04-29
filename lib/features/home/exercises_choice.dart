import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/main_tab_screen.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';
import '../workout/exercise_screen.dart';
import 'home_phys_mental_screen.dart';

/// Экран ручного выбора 3 упражнений для тренировки. Содержит три слота (_Slot),
/// каждый из которых при тапе открывает HomePhysMentalScreen через Navigator.push
/// и ожидает возврата выбранного Exercise. Кнопка «Начать» активируется только
/// когда все 3 слота заполнены. При нажатии переходит на ExerciseScreen с выбранными упражнениями.
class ExercisesChoiceScreen extends StatefulWidget {
  const ExercisesChoiceScreen({super.key});
  @override
  State<ExercisesChoiceScreen> createState() => _ExercisesChoiceScreenState();
}

class _ExercisesChoiceScreenState extends State<ExercisesChoiceScreen> {
  final List<Exercise?> _slots = [null, null, null];
  bool get _allSelected => _slots.every((e) => e != null);

  Future<void> _pick(int i) async {
    final Exercise? r = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(builder: (_) => const HomePhysMentalScreen()),
    );
    if (r != null && mounted) setState(() => _slots[i] = r);
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
              AppHeader(
                onBack: () => goToAndClear(context, const MainTabScreen()),
              ),

              const SizedBox(height: 24),
              Text(
                t.chooseExercisesTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 32),
              for (int i = 0; i < 3; i++) ...[
                _Slot(
                  index: i + 1,
                  exercise: _slots[i],
                  placeholder: t.chooseExerciseSlot,
                  onTap: () => _pick(i),
                ),

                const SizedBox(height: 16),
              ],
              const Spacer(),
              PrimaryButton(
                label: t.startButton,
                width: double.infinity,
                onPressed: _allSelected
                    ? () => goToAndClear(
                        context,
                        ExerciseScreen(
                          exercises: _slots.whereType<Exercise>().toList(),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Слот упражнения: отображает номер, название выбранного упражнения или плейсхолдер.
class _Slot extends StatelessWidget {
  final int index;
  final Exercise? exercise;
  final String placeholder;
  final VoidCallback onTap;
  const _Slot({
    required this.index,
    required this.exercise,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final sel = exercise != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: sel ? c.accentSurface : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: sel ? Border.all(color: c.accentLight, width: 1.5) : null,
        ),

        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: sel ? c.accent : c.border,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: sel ? c.white : c.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Text(
                sel ? exercise!.title : placeholder,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: sel ? c.accentLight : c.textSecondary,
                ),
              ),
            ),

            Icon(
              sel ? Icons.check_circle : Icons.add_circle_outline,
              color: sel ? c.accentLight : c.textHint,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
