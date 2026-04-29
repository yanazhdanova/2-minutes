import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';
import 'home_catalog_phys.dart';
import 'home_catalog_mental.dart';
import 'home_favorites_screen.dart';

/// Экран выбора типа упражнения для ручной тренировки. Три варианта:
/// 1. «Физическое» - открывает HomeCatalogPhysScreen для выбора из физических категорий.
/// 2. «Ментальное» - открывает HomeCatalogMentalScreen для выбора из ментальных категорий.
/// 3. «Случайное» - загружает все упражнения обоих типов и возвращает случайное.
/// Все варианты возвращают выбранное Exercise через Navigator.pop(context, exercise).
class HomePhysMentalScreen extends StatelessWidget {
  const HomePhysMentalScreen({super.key});

  Future<void> _pickFromFavorites(BuildContext context) async {
    final scope = AppScope.of(context);
    final ids = scope.userData.favoriteIds;
    final list = <Exercise>[];
    for (final id in ids) {
      final ex = await scope.exerciseRepo.exerciseById(id);
      if (ex != null) list.add(ex);
    }
    if (!context.mounted) return;
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Tr.of(context).favoritesEmpty)),
      );
      return;
    }
    final r = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(
        builder: (_) => HomeFavoritesScreen(exercises: list),
      ),
    );
    if (r != null && context.mounted) Navigator.pop(context, r);
  }

  Future<void> _pickRandom(BuildContext context) async {
    final repo = AppScope.of(context).exerciseRepo;
    final all = <Exercise>[];
    for (final cat in [
      ...await repo.categoriesByType(HealthType.physical),
      ...await repo.categoriesByType(HealthType.mental),
    ]) {
      all.addAll(await repo.exercisesByCategory(cat.id));
    }
    if (all.isNotEmpty && context.mounted) {
      Navigator.pop(context, all[Random().nextInt(all.length)]);
    }
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
                t.chooseTypeTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 40),
              _Btn(
                icon: Icons.fitness_center,
                label: t.typePhysical,
                sub: t.typePhysicalSub,
                onTap: () async {
                  final r = await Navigator.push<Exercise>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeCatalogPhysScreen(),
                    ),
                  );
                  if (r != null && context.mounted) Navigator.pop(context, r);
                },
              ),
              const SizedBox(height: 16),
              _Btn(
                icon: Icons.self_improvement,
                label: t.typeMental,
                sub: t.typeMentalSub,
                onTap: () async {
                  final r = await Navigator.push<Exercise>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeCatalogMentalScreen(),
                    ),
                  );
                  if (r != null && context.mounted) Navigator.pop(context, r);
                },
              ),
              const SizedBox(height: 16),
              _Btn(
                icon: Icons.shuffle,
                label: t.typeRandom,
                sub: t.typeRandomSub,
                onTap: () => _pickRandom(context),
                outlined: true,
              ),
              const SizedBox(height: 16),
              _Btn(
                icon: Icons.favorite_border,
                label: t.typeFavorites,
                sub: t.typeFavoritesSub,
                onTap: () => _pickFromFavorites(context),
                outlined: true,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

/// Кнопка-карточка с иконкой, заголовком и подзаголовком для выбора типа упражнения.
class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;
  final bool outlined;
  const _Btn({
    required this.icon,
    required this.label,
    required this.sub,
    required this.onTap,
    this.outlined = false,
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
          color: outlined ? Colors.transparent : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: outlined
              ? Border.all(color: c.accentLight, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: outlined ? c.accentSurface : c.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: outlined ? c.accentLight : c.textSecondary,
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
                      color: outlined ? c.accentLight : c.textPrimary,
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
            Icon(
              Icons.chevron_right,
              color: outlined ? c.accentLight : c.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
