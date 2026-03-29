import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import 'program_settings_screen.dart';
import 'notif_settings_screen.dart';
import 'language_settings_screen.dart';
import 'appearance_settings_screen.dart';
import '../premium/buy_premium_screen.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = C(context); final t = Tr.of(context);
    return Scaffold(backgroundColor: c.background, body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 18), Center(child: Text(t.appName, style: AppTextStyles.logo.copyWith(color: c.textPrimary))),
      const SizedBox(height: 32), Text(t.settingsTitle, style: AppTextStyles.heading2.copyWith(color: c.textPrimary)),
      const SizedBox(height: 24),
      _Item(icon: Icons.calendar_today_outlined, title: t.settingsProgram, onTap: () => goTo(context, const ProgramSettingsScreen())),
      const SizedBox(height: 12),
      _Item(icon: Icons.notifications_outlined, title: t.settingsNotif, onTap: () => goTo(context, const NotifSettingsScreen())),
      const SizedBox(height: 12),
      _Item(icon: Icons.language, title: t.settingsLang, onTap: () => goTo(context, const LanguageSettingsScreen())),
      const SizedBox(height: 12),
      _Item(icon: Icons.palette_outlined, title: t.settingsAppearance, onTap: () => goTo(context, const AppearanceSettingsScreen())),
      const SizedBox(height: 12),
      _Item(icon: Icons.workspace_premium_outlined, title: t.settingsPremium, onTap: () => goTo(context, const BuyPremiumScreen()), isAccent: true),
      const Spacer(),
    ]))));
  }
}

class _Item extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap; final bool isAccent;
  const _Item({required this.icon, required this.title, required this.onTap, this.isAccent = false});
  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: isAccent ? c.accentSurface : c.surface, borderRadius: BorderRadius.circular(AppRadius.medium)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: isAccent ? c.accent : c.border, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: isAccent ? c.white : c.textSecondary, size: 20)),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: AppTextStyles.bodyLarge.copyWith(color: isAccent ? c.accentLight : c.textPrimary))),
              Icon(Icons.chevron_right, color: isAccent ? c.accentLight : c.textSecondary),
            ])));
  }
}