import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'notif_time_screen.dart';

/// Экран онбординга — выбор количества упражнений в тренировке (1–6).
/// Встраивается между CategoriesScreen и NotifTimeScreen.
class ExerciseCountScreen extends StatefulWidget {
  const ExerciseCountScreen({super.key});
  @override
  State<ExerciseCountScreen> createState() => _ExerciseCountScreenState();
}

class _ExerciseCountScreenState extends State<ExerciseCountScreen> {
  int _count = 3;

  Future<void> _next() async {
    final scope = AppScope.of(context);
    scope.userData.setExerciseCount(_count);
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
              AppHeader(onBack: () => Navigator.pop(context)),
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
              const SizedBox(height: 48),

              // Счётчик
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CounterButton(
                    icon: Icons.remove,
                    enabled: _count > 1,
                    onTap: () => setState(() => _count--),
                    c: c,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      '$_count',
                      style: AppTextStyles.heading1.copyWith(color: c.accentLight),
                    ),
                  ),
                  _CounterButton(
                    icon: Icons.add,
                    enabled: _count < 6,
                    onTap: () => setState(() => _count++),
                    c: c,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                t.approxDuration(_count * 40),
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
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: enabled ? c.accentSurface : c.surface,
          borderRadius: BorderRadius.circular(14),
          border: enabled
              ? Border.all(color: c.accentLight, width: 1.5)
              : null,
        ),
        child: Icon(
          icon,
          color: enabled ? c.accentLight : c.textHint,
          size: 28,
        ),
      ),
    );
  }
}
