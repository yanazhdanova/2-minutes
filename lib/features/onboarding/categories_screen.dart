import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../shared/widgets.dart';
import 'notif_time_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _problems = <_Problem>[
    _Problem('posture', 'Проблемы с осанкой'),
    _Problem('back', 'Боли в спине и пояснице'),
    _Problem('neck', 'Боли в шее'),
    _Problem('eyes', 'Усталость глаз'),
    _Problem('stress', 'Стресс и тревога'),
    _Problem('focus', 'Трудности с концентрацией'),
    _Problem('energy', 'Нехватка энергии'),
    _Problem('sleep', 'Проблемы со сном'),
  ];

  final Set<String> _selected = {};

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  Future<void> _next() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Выберите хотя бы одну категорию'),
          backgroundColor: AppColors.accent,
        ),
      );
      return;
    }

    await UserPreferences.setSelectedCategories(_selected.toList());

    if (mounted) {
      goTo(context, const NotifTimeScreen());
    }
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
              AppHeader(onBack: () => Navigator.pop(context)),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Выберите, какие\nпроблемы хотите\nисправить',
                  style: AppTextStyles.heading2,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount: _problems.length,
                  itemBuilder: (context, i) {
                    final p = _problems[i];
                    final isSelected = _selected.contains(p.id);

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
                            color: isSelected ? AppColors.accentSurface : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                            border: isSelected
                                ? Border.all(color: AppColors.accent, width: 1.5)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.label,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: isSelected
                                        ? AppColors.accent
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.accent : AppColors.border,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: isSelected
                                    ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.white,
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

              OutlineButton(
                label: 'Далее',
                width: 260,
                onPressed: _next,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Problem {
  final String id;
  final String label;
  _Problem(this.id, this.label);
}