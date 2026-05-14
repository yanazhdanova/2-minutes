import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/main_tab_screen.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../../shared/tutorial_overlay.dart';
import '../../shared/duration_picker_sheet.dart';
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
  late List<Exercise?> _slots;
  final Map<String, int> _sessionDurations = {};
  bool get _allSelected => _slots.every((e) => e != null);
  bool _showTutorial = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = AppScope.of(context).prefs;
      if (!prefs.tutorialCustomSeen) {
        setState(() => _showTutorial = true);
      }
    });
  }

  void _dismissTutorial() {
    AppScope.of(context).prefs.setTutorialCustomSeen();
    setState(() => _showTutorial = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final count = AppScope.of(context).userData.exerciseCount;
    if (!_initialized) {
      _slots = List.filled(count, null);
      _initialized = true;
    }
  }

  bool _initialized = false;

  Future<void> _pick(int i) async {
    final Exercise? r = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(builder: (_) => const HomePhysMentalScreen()),
    );
    if (r != null && mounted) {
      setState(() {
        _slots[i] = r;
        _sessionDurations.putIfAbsent(
          r.id,
          () => AppScope.of(context).userData.defaultExerciseDurationSec,
        );
      });
    }
  }

  Future<void> _editDuration(Exercise ex) async {
    final current =
        _sessionDurations[ex.id] ??
        AppScope.of(context).userData.defaultExerciseDurationSec;
    final result = await showDurationPickerSheet(context, initial: current);
    if (result != null && mounted) {
      setState(() => _sessionDurations[ex.id] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final defaultDuration = AppScope.of(
      context,
    ).userData.defaultExerciseDurationSec;
    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          SafeArea(
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
                    style: AppTextStyles.heading2.copyWith(
                      color: c.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 32),
                  for (int i = 0; i < _slots.length; i++) ...[
                    _Slot(
                      index: i + 1,
                      exercise: _slots[i],
                      placeholder: t.chooseExerciseSlot,
                      durationSec: _slots[i] == null
                          ? null
                          : (_sessionDurations[_slots[i]!.id] ??
                                defaultDuration),
                      onTap: () => _pick(i),
                      onDurationTap: _slots[i] == null
                          ? null
                          : () => _editDuration(_slots[i]!),
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
                              sessionDurations: Map.of(_sessionDurations),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          if (_showTutorial)
            TutorialOverlay(
              icon: Icons.touch_app,
              title: t.tutorialCustomTitle,
              body: t.tutorialCustomBody,
              onDismiss: _dismissTutorial,
            ),
        ],
      ),
    );
  }
}

/// Слот упражнения: отображает номер, название выбранного упражнения или плейсхолдер.
class _Slot extends StatelessWidget {
  final int index;
  final Exercise? exercise;
  final String placeholder;
  final int? durationSec;
  final VoidCallback onTap;
  final VoidCallback? onDurationTap;
  const _Slot({
    required this.index,
    required this.exercise,
    required this.placeholder,
    required this.durationSec,
    required this.onTap,
    required this.onDurationTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
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
                  fontWeight: FontWeight.w700,
                  color: sel ? c.white : c.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Text(
                sel
                    ? exercise!.localizedTitle(t.locale.languageCode)
                    : placeholder,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: sel ? c.accentLight : c.textSecondary,
                ),
              ),
            ),

            if (sel && durationSec != null) ...[
              InkWell(
                onTap: onDurationTap,
                borderRadius: BorderRadius.circular(AppRadius.small),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    '${durationSec}s',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: c.accentLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],

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
