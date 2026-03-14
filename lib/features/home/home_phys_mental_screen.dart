import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';
import 'home_catalog_phys.dart';
import 'home_catalog_mental.dart';

class HomePhysMentalScreen extends StatelessWidget {
  const HomePhysMentalScreen({super.key});

  Future<void> _pickRandom(BuildContext context) async {
    final repo = AppScope.of(context).exerciseRepo;

    final physCats = await repo.categoriesByType(HealthType.physical);
    final mentCats = await repo.categoriesByType(HealthType.mental);
    final allCats = [...physCats, ...mentCats];

    final allExercises = <Exercise>[];
    for (final cat in allCats) {
      allExercises.addAll(await repo.exercisesByCategory(cat.id));
    }

    if (allExercises.isNotEmpty && context.mounted) {
      final random = allExercises[Random().nextInt(allExercises.length)];
      Navigator.pop(context, random);
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

              const Spacer(flex: 2),

              Text(
                'Выберите тип\nупражнения',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 40),

              _TypeButton(
                icon: Icons.fitness_center,
                label: 'Физическое',
                subtitle: 'Разминка, растяжка, осанка',
                onTap: () async {
                  final Exercise? result = await Navigator.push<Exercise>(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeCatalogPhysScreen()),
                  );
                  if (result != null && context.mounted) {
                    Navigator.pop(context, result);
                  }
                },
              ),

              const SizedBox(height: 16),

              _TypeButton(
                icon: Icons.self_improvement,
                label: 'Ментальное',
                subtitle: 'Дыхание, концентрация',
                onTap: () async {
                  final Exercise? result = await Navigator.push<Exercise>(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeCatalogMentalScreen()),
                  );
                  if (result != null && context.mounted) {
                    Navigator.pop(context, result);
                  }
                },
              ),

              const SizedBox(height: 16),

              _TypeButton(
                icon: Icons.shuffle,
                label: 'Случайное',
                subtitle: 'Мы выберем за вас',
                onTap: () => _pickRandom(context),
                isOutlined: true,
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isOutlined;

  const _TypeButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: isOutlined
              ? Border.all(color: AppColors.accent, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isOutlined ? AppColors.accentSurface : AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isOutlined ? AppColors.accent : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isOutlined ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isOutlined ? AppColors.accent : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}