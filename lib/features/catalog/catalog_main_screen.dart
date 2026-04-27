import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import 'physical_groups.dart';
import 'mental_groups.dart';

/**
Главный экран каталога (вкладка «Каталог»). Показывает заголовок, подзаголовок
и две карточки (_Card): «Физические» - PhysicalGroupsScreen, «Ментальные» - MentalGroupsScreen.
Каждая карточка содержит иконку, название и краткое описание типа упражнений.
*/
class CatalogMainScreen extends StatelessWidget {
  const CatalogMainScreen({super.key});
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Center(
                child: Text(
                  t.appName,
                  style: AppTextStyles.logo.copyWith(color: c.textPrimary),
                ),
              ),

              const SizedBox(height: 32),
              Text(
                t.catalogTitle,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 8),
              Text(
                t.catalogSubtitle,
                style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary),
              ),

              const SizedBox(height: 32),
              _Card(
                icon: Icons.fitness_center,
                title: t.physicalTitle,
                sub: t.physicalSub,
                onTap: () => goTo(context, const PhysicalGroupsScreen()),
              ),

              const SizedBox(height: 16),
              _Card(
                icon: Icons.self_improvement,
                title: t.mentalTitle,
                sub: t.mentalSub,
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

/** Карточка раздела каталога с иконкой, заголовком и описанием. */
class _Card extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;
  const _Card({
    required this.icon,
    required this.title,
    required this.sub,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),

        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.accentSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: c.accentLight, size: 28),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: c.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: c.textSecondary),
          ],
        ),
      ),
    );
  }
}
