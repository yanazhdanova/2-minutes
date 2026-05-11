import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/locale_controller.dart';
import '../../app/main_tab_screen.dart';
import '../../app/navigation.dart';
import '../../app/theme_controller.dart';
import '../exercises/data/notification_service.dart';
import '../onboarding/name_screen.dart';

/// Стабильный промежуточный экран после успешной авторизации.
/// Загружает профиль, применяет настройки пользователя и только после этого
/// открывает главный экран или онбординг, чтобы UI не перестраивался на глазах.
class PostAuthScreen extends StatefulWidget {
  const PostAuthScreen({super.key});

  @override
  State<PostAuthScreen> createState() => _PostAuthScreenState();
}

class _PostAuthScreenState extends State<PostAuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareAndNavigate();
    });
  }

  Future<void> _prepareAndNavigate() async {
    final scope = AppScope.of(context);
    await scope.userData.init();
    if (!mounted) return;

    await _syncSettings(scope);
    if (!mounted) return;

    final next = scope.userData.isOnboardingDone
        ? const MainTabScreen()
        : const NameScreen();
    goToAndClearFade(context, next);
  }

  Future<void> _syncSettings(AppScope scope) async {
    final userData = scope.userData;
    final prefs = scope.prefs;
    final themeCtrl = ThemeController.of(context);
    final localeCtrl = LocaleController.of(context);

    final themeMode = switch (userData.themeMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
    await themeCtrl.setThemeMode(themeMode);
    await themeCtrl.setAccentColor(
      userData.accentColor == 'pink' ? AccentColor.pink : AccentColor.green,
    );

    final languageCode = userData.languageCode;
    if (languageCode.isNotEmpty) {
      await localeCtrl.setLocale(Locale(languageCode));
    }

    await prefs.setNotifFrom(userData.notifFrom);
    await prefs.setNotifTo(userData.notifTo);
    await prefs.setNotifFreq(userData.notifFreq);
    await prefs.setNotifDays(userData.notifDays);

    if (userData.isOnboardingDone) {
      NotificationService.instance.scheduleFromPrefs(prefs).ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 160,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '2mins',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.logo.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: c.accentLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
