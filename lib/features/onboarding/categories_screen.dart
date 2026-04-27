import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'notif_time_screen.dart';

/**
Второй экран онбординга - выбор проблемных зон. Отображает 8 проблем (posture, back,
neck, eyes, stress, focus, energy, sleep) в виде тоглящихся карточек с чекбоксами.
Множественный выбор хранится в Set<String> _selected. Валидация: минимум 1 выбранная
проблема. При нажатии «Далее» сохраняет выбор через UserPreferences.setSelectedCategories()
и переходит на NotifTimeScreen.
*/
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final Set<String> _selected = {};

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

  void _toggle(String id) => setState(
    () => _selected.contains(id) ? _selected.remove(id) : _selected.add(id),
  );

  Future<void> _next() async {
    final t = Tr.of(context);
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.categoriesValidation),
          backgroundColor: C(context).accent,
        ),
      );
      return;
    }
    await UserPreferences.setSelectedCategories(_selected.toList());
    if (mounted) goTo(context, const NotifTimeScreen());
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
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.categoriesTitle,
                  style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
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
              OutlineButton(label: t.next, width: 260, onPressed: _next),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/** Модель проблемной зоны: идентификатор и локализованная метка. */
class _P {
  final String id;
  final String label;
  _P(this.id, this.label);
}
