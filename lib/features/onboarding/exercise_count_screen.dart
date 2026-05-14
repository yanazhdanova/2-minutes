import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/language_picker_button.dart';
import '../../shared/widgets.dart';
import 'notif_time_screen.dart';

/// Экран онбординга — выбор количества упражнений в тренировке (1–6)
/// и длительности упражнения по умолчанию.
/// Встраивается между CategoriesScreen и NotifTimeScreen.
class ExerciseCountScreen extends StatefulWidget {
  const ExerciseCountScreen({super.key});
  @override
  State<ExerciseCountScreen> createState() => _ExerciseCountScreenState();
}

class _ExerciseCountScreenState extends State<ExerciseCountScreen> {
  int _count = 3;
  int _durationSec = 40;

  Future<void> _next() async {
    final scope = AppScope.of(context);
    scope.userData.setExerciseCount(_count);
    scope.userData.setDefaultExerciseDurationSec(_durationSec);
    await scope.prefs.setExerciseCount(_count);
    if (mounted) goTo(context, const NotifTimeScreen());
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
                onBack: () => Navigator.pop(context),
                trailing: const LanguagePickerButton(),
              ),
              const Spacer(flex: 2),
              Text(
                t.exerciseCountTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                t.exerciseCountOnboardingSub,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: 40),

              _OnboardingControls(
                count: _count,
                durationSec: _durationSec,
                onCountChanged: (value) => setState(() => _count = value),
                onDurationChanged: (value) =>
                    setState(() => _durationSec = value),
              ),

              const SizedBox(height: 24),
              Text(
                t.approxDuration(_count * _durationSec),
                style: AppTextStyles.bodyLarge.copyWith(color: c.textSecondary),
              ),

              const Spacer(flex: 3),
              Text(
                t.canChangeLater,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(color: c.textHint),
              ),
              const SizedBox(height: 8),
              OutlineButton(label: t.next, width: 260, onPressed: _next),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingControls extends StatelessWidget {
  final int count;
  final int durationSec;
  final ValueChanged<int> onCountChanged;
  final ValueChanged<int> onDurationChanged;

  const _OnboardingControls({
    required this.count,
    required this.durationSec,
    required this.onCountChanged,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        children: [
          _StepperRow(
            label: t.exerciseCountLabel,
            value: '$count',
            canDecrease: count > 1,
            canIncrease: count < 6,
            onDecrease: () => onCountChanged(count - 1),
            onIncrease: () => onCountChanged(count + 1),
          ),
          Divider(color: c.border, height: 1),
          _StepperRow(
            label: t.defaultExerciseDurationLabel,
            value: t.durationShort(durationSec),
            canDecrease: durationSec > 20,
            canIncrease: durationSec < 180,
            onDecrease: () => onDurationChanged(durationSec - 10),
            onIncrease: () => onDurationChanged(durationSec + 10),
          ),
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String label;
  final String value;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _StepperRow({
    required this.label,
    required this.value,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(color: c.textPrimary),
            ),
          ),
          _CounterButton(
            icon: Icons.remove,
            enabled: canDecrease,
            onTap: onDecrease,
            c: c,
          ),
          SizedBox(
            width: 84,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading3.copyWith(color: c.accentLight),
            ),
          ),
          _CounterButton(
            icon: Icons.add,
            enabled: canIncrease,
            onTap: onIncrease,
            c: c,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final ResolvedColors c;
  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? c.accentSurface : c.surface,
          borderRadius: BorderRadius.circular(12),
          border: enabled ? Border.all(color: c.accentLight, width: 1.5) : null,
        ),
        child: Icon(
          icon,
          color: enabled ? c.accentLight : c.textHint,
          size: 24,
        ),
      ),
    );
  }
}
