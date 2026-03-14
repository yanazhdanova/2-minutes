import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../shared/widgets.dart';
import 'physical_groups.dart';
import 'mental_groups.dart';

class CatalogMainScreen extends StatelessWidget {
  const CatalogMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

              const Center(
                child: Text('2 минуты', style: AppTextStyles.logo),
              ),

              const SizedBox(height: 32),

              Text('Каталог', style: AppTextStyles.heading2),

              const SizedBox(height: 8),

              Text(
                'Все упражнения по категориям',
                style: AppTextStyles.bodySmall,
              ),

              const SizedBox(height: 32),

              _CatalogCard(
                icon: Icons.fitness_center,
                title: 'Физические',
                subtitle: 'Разминка, растяжка, осанка',
                onTap: () => goTo(context, const PhysicalGroupsScreen()),
              ),

              const SizedBox(height: 16),

              _CatalogCard(
                icon: Icons.self_improvement,
                title: 'Ментальные',
                subtitle: 'Дыхание, концентрация, релаксация',
                onTap: () => goTo(context, const MentalGroupsScreen()),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CatalogCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppColors.accent,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}