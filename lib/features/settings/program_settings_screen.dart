import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';

/// Экран настройки программы тренировок. Аналогичен CategoriesScreen из онбординга,
/// но для уже авторизованного пользователя. Показывает 8 проблемных зон с тоглящимися
/// карточками. Начальный выбор загружается из PrefsService.selectedCategories.
/// Кнопка «Сохранить» появляется при изменениях. Валидация: минимум 1 выбранная проблема.
/// При сохранении обновляет PrefsService и показывает SnackBar «Сохранено».
class ProgramSettingsScreen extends StatefulWidget {
  const ProgramSettingsScreen({super.key});
  @override
  State<ProgramSettingsScreen> createState() => _ProgramSettingsScreenState();
}

class _ProgramSettingsScreenState extends State<ProgramSettingsScreen> {
  late Set<String> _selected;
  late int _exerciseCount;
  late int _defaultDurationSec;
  bool _changed = false;

  List<_P> _problems(Tr t) => [
    _P('posture', t.problemPosture),
    _P('back', t.problemBack),
    _P('neck', t.problemNeck),
    _P('eyes', t.problemEyes),
    _P('stress', t.problemStress),
    _P('focus', t.problemFocus),
    _P('energy', t.problemEnergy),
    _P('sleep', t.problemSleep),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = AppScope.of(context).userData;
    _selected = userData.selectedCategories.toSet();
    _exerciseCount = userData.exerciseCount;
    _defaultDurationSec = userData.defaultExerciseDurationSec;
  }

  void _toggle(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
      _changed = true;
    });
  }

  Future<void> _save() async {
    final t = Tr.of(context);
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.categoriesValidation),
          backgroundColor: C(context).error,
        ),
      );
      return;
    }

    final userData = AppScope.of(context).userData;
    await userData.setSelectedCategories(_selected.toList());
    userData.setExerciseCount(_exerciseCount);
    userData.setDefaultExerciseDurationSec(_defaultDurationSec);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.savedMessage),
          backgroundColor: C(context).accent,
        ),
      );
      setState(() => _changed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final problems = _problems(t);

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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.settingsProgram,
                  style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
                ),
              ),

              const SizedBox(height: 24),

              _ProgramControls(
                exerciseCount: _exerciseCount,
                durationSec: _defaultDurationSec,
                onExerciseCountChanged: (value) => setState(() {
                  _exerciseCount = value;
                  _changed = true;
                }),
                onDurationChanged: (value) => setState(() {
                  _defaultDurationSec = value;
                  _changed = true;
                }),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider(color: c.border, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      t.programCategoriesSection,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: c.border, thickness: 1)),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.programSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: problems.length,
                  itemBuilder: (context, i) {
                    final p = problems[i];
                    final sel = _selected.contains(p.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        onTap: () => _toggle(p.id),

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),

                          decoration: BoxDecoration(
                            color: sel ? c.accentSurface : c.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                            border: sel
                                ? Border.all(color: c.accentLight, width: 1.5)
                                : null,
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.label,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: sel ? c.accentLight : c.textPrimary,
                                  ),
                                ),
                              ),

                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: sel ? c.accent : c.border,
                                  borderRadius: BorderRadius.circular(6),
                                ),

                                child: sel
                                    ? Icon(
                                        Icons.check,
                                        size: 16,
                                        color: c.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_changed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: PrimaryButton(
                    label: t.save,
                    width: double.infinity,
                    onPressed: _save,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramControls extends StatelessWidget {
  final int exerciseCount;
  final int durationSec;
  final ValueChanged<int> onExerciseCountChanged;
  final ValueChanged<int> onDurationChanged;

  const _ProgramControls({
    required this.exerciseCount,
    required this.durationSec,
    required this.onExerciseCountChanged,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        children: [
          _StepperRow(
            label: t.exerciseCountLabel,
            subLabel: t.exerciseCountSub,
            value: '$exerciseCount',
            canDecrease: exerciseCount > 1,
            canIncrease: exerciseCount < 6,
            onDecrease: () => onExerciseCountChanged(exerciseCount - 1),
            onIncrease: () => onExerciseCountChanged(exerciseCount + 1),
          ),
          Divider(color: c.border, height: 1),
          _StepperRow(
            label: t.defaultExerciseDurationLabel,
            subLabel: t.defaultExerciseDurationSub,
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
  final String subLabel;
  final String value;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _StepperRow({
    required this.label,
    required this.subLabel,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyLarge.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  subLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _CounterButton(
            icon: Icons.remove,
            enabled: canDecrease,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 76,
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

  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? c.accentSurface : c.border,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: enabled ? c.accentLight : c.textHint,
          size: 20,
        ),
      ),
    );
  }
}

/// Модель проблемной зоны: идентификатор и локализованная метка.
class _P {
  final String id;
  final String label;
  _P(this.id, this.label);
}
