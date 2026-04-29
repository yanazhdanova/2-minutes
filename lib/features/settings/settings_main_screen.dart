import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../app/theme_controller.dart';
import '../../app/locale_controller.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../exercises/data/notification_service.dart';
import 'program_settings_screen.dart';
import 'notif_settings_screen.dart';
import 'language_settings_screen.dart';
import 'appearance_settings_screen.dart';
import '../premium/buy_premium_screen.dart';

/// Главный экран настроек (вкладка «Настройки»). Вверху - блок профиля
/// (аватар, имя, email, кнопка «Выйти»), ниже - 5 пунктов меню (_Item).
class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final userData = AppScope.of(context).userData;
    final name = userData.userName;
    final email = userData.email;

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

              const SizedBox(height: 24),

              // ── Блок профиля ──
              _ProfileBlock(name: name, email: email, c: c, t: t),

              const SizedBox(height: 24),
              Text(
                t.settingsTitle,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _Item(
                      icon: Icons.calendar_today_outlined,
                      title: t.settingsProgram,
                      onTap: () => goTo(context, const ProgramSettingsScreen()),
                    ),

                    const SizedBox(height: 12),
                    _Item(
                      icon: Icons.notifications_outlined,
                      title: t.settingsNotif,
                      onTap: () => goTo(context, const NotifSettingsScreen()),
                    ),

                    const SizedBox(height: 12),
                    _Item(
                      icon: Icons.language,
                      title: t.settingsLang,
                      onTap: () =>
                          goTo(context, const LanguageSettingsScreen()),
                    ),

                    const SizedBox(height: 12),
                    _Item(
                      icon: Icons.palette_outlined,
                      title: t.settingsAppearance,
                      onTap: () =>
                          goTo(context, const AppearanceSettingsScreen()),
                    ),

                    const SizedBox(height: 12),
                    _Item(
                      icon: Icons.workspace_premium_outlined,
                      title: t.settingsPremium,
                      onTap: () => goTo(context, const BuyPremiumScreen()),
                      isAccent: true,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Блок профиля пользователя: аватар, имя, email и кнопка «Выйти».
class _ProfileBlock extends StatelessWidget {
  final String name;
  final String email;
  final ResolvedColors c;
  final Tr t;
  const _ProfileBlock({
    required this.name,
    required this.email,
    required this.c,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          // Аватар
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: c.accentSurface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: name.isNotEmpty
                ? Text(
                    name[0].toUpperCase(),
                    style: AppTextStyles.heading2.copyWith(
                      color: c.accentLight,
                    ),
                  )
                : Icon(Icons.person, color: c.accentLight, size: 28),
          ),

          const SizedBox(width: 16),

          // Имя + email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: c.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Кнопка «Выйти»
          SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: () => _confirmLogout(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: c.error,
                side: BorderSide(color: c.error, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                t.logoutButton,
                style: AppTextStyles.button.copyWith(color: c.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text(
          t.logoutConfirmTitle,
          style: AppTextStyles.bodyLarge.copyWith(color: c.textPrimary),
        ),
        content: Text(
          t.logoutConfirmText,
          style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              t.logoutCancel,
              style: AppTextStyles.button.copyWith(color: c.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await NotificationService.instance.cancelAll();
              await AuthService().logout();
              if (context.mounted) {
                final themeCtrl = ThemeController.of(context);
                final localeCtrl = LocaleController.of(context);
                await themeCtrl.setThemeMode(ThemeMode.system);
                await themeCtrl.setAccentColor(AccentColor.green);
                await localeCtrl.setLocale(LocaleController.deviceLocale());
                if (context.mounted) goToAndClear(context, const LoginScreen());
              }
            },
            child: Text(
              t.logoutButton,
              style: AppTextStyles.button.copyWith(color: c.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Элемент меню настроек: иконка в контейнере, заголовок и стрелка вправо. При isAccent=true применяется акцентная подсветка фона и текста.
class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isAccent;
  const _Item({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: isAccent ? c.accentSurface : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),

        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isAccent ? c.accent : c.border,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Icon(
                icon,
                color: isAccent ? c.white : c.textSecondary,
                size: 20,
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isAccent ? c.accentLight : c.textPrimary,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: isAccent ? c.accentLight : c.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
