import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import 'program_settings_screen.dart';
import 'notif_settings_screen.dart';
import 'language_settings_screen.dart';
import 'appearance_settings_screen.dart';
import '../premium/buy_premium_screen.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

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

              Text('Настройки', style: AppTextStyles.heading2),

              const SizedBox(height: 24),

              _SettingsItem(
                icon: Icons.calendar_today_outlined,
                title: 'Моя программа',
                onTap: () => goTo(context, const ProgramSettingsScreen()),
              ),

              const SizedBox(height: 12),

              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Уведомления',
                onTap: () => goTo(context, const NotifSettingsScreen()),
              ),

              const SizedBox(height: 12),

              _SettingsItem(
                icon: Icons.language,
                title: 'Язык',
                onTap: () => goTo(context, const LanguageSettingsScreen()),
              ),

              const SizedBox(height: 12),

              _SettingsItem(
                icon: Icons.palette_outlined,
                title: 'Внешний вид',
                onTap: () => goTo(context, const AppearanceSettingsScreen()),
              ),

              const SizedBox(height: 12),

              _SettingsItem(
                icon: Icons.workspace_premium_outlined,
                title: 'Платная версия',
                onTap: () => goTo(context, const BuyPremiumScreen()),
                isAccent: true,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isAccent;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isAccent ? AppColors.accentSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isAccent ? AppColors.accent : AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isAccent ? AppColors.white : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isAccent ? AppColors.accent : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isAccent ? AppColors.accent : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}