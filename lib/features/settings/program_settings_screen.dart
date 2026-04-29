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
              const SizedBox(height: 24),

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

/// Модель проблемной зоны: идентификатор и локализованная метка.
class _P {
  final String id;
  final String label;
  _P(this.id, this.label);
}
