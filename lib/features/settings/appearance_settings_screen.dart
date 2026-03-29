import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/theme_controller.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final ctrl = ThemeController.of(context);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),
              const SizedBox(height: 16),
              Text(t.appearanceTitle, style: AppTextStyles.heading2.copyWith(color: c.textPrimary)),
              const SizedBox(height: 32),

              // ── Тема ──
              Text(t.themeSection, style: AppTextStyles.label.copyWith(color: c.textSecondary)),
              const SizedBox(height: 12),
              _ThemeOption(label: t.themeSystem, icon: Icons.brightness_auto_outlined, isSelected: ctrl.themeMode == ThemeMode.system, onTap: () => ctrl.setThemeMode(ThemeMode.system)),
              const SizedBox(height: 8),
              _ThemeOption(label: t.themeLight, icon: Icons.light_mode_outlined, isSelected: ctrl.themeMode == ThemeMode.light, onTap: () => ctrl.setThemeMode(ThemeMode.light)),
              const SizedBox(height: 8),
              _ThemeOption(label: t.themeDark, icon: Icons.dark_mode_outlined, isSelected: ctrl.themeMode == ThemeMode.dark, onTap: () => ctrl.setThemeMode(ThemeMode.dark)),

              const SizedBox(height: 32),

              // ── Акцент ──
              Text(t.accentSection, style: AppTextStyles.label.copyWith(color: c.textSecondary)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _AccentCircle(
                    color: const Color(0xFF2D5A45),
                    label: t.accentGreen,
                    isSelected: ctrl.accentColor == AccentColor.green,
                    onTap: () => ctrl.setAccentColor(AccentColor.green),
                  ),
                  const SizedBox(width: 16),
                  _AccentCircle(
                    color: const Color(0xFFC9707F),
                    label: t.accentPink,
                    isSelected: ctrl.accentColor == AccentColor.pink,
                    onTap: () => ctrl.setAccentColor(AccentColor.pink),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _ThemeOption({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? c.accentSurface : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: isSelected ? Border.all(color: c.accentLight, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isSelected ? c.accentLight : c.textSecondary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: isSelected ? c.accentLight : c.textPrimary))),
            if (isSelected) Icon(Icons.check_circle, color: c.accentLight, size: 22)
            else Icon(Icons.circle_outlined, color: c.border, size: 22),
          ],
        ),
      ),
    );
  }
}

class _AccentCircle extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _AccentCircle({required this.color, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: c.textPrimary, width: 3) : Border.all(color: c.border, width: 1.5),
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 24) : null,
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: isSelected ? c.textPrimary : c.textSecondary)),
        ],
      ),
    );
  }
}