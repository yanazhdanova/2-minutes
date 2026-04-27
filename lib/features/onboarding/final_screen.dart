import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../app/l10n/app_localizations.dart';
import '../../app/main_tab_screen.dart';
import '../../shared/widgets.dart';
import '../../features/exercises/data/notification_service.dart';
import '../../app/app_scope.dart';

/**
Пятый и финальный экран онбординга. Показывает иконку-галочку и информирует,
что настройки можно изменить позже. При нажатии «Отлично» выполняет:
1. Отмечает онбординг завершённым (UserPreferences.setOnboardingComplete).
2. Запрашивает разрешение на уведомления (NotificationService.requestPermission).
3. Планирует расписание уведомлений (NotificationService.scheduleFromPrefs).
4. Переходит на MainTabScreen, очищая весь стек навигации.
*/
class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});
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
              const AppHeader(),
              const Spacer(flex: 3),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: c.accentSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: c.accentLight,
                  size: 44,
                ),
              ),

              const SizedBox(height: 32),
              Text(
                t.finalScreenTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 48),
              PrimaryButton(
                label: t.finalButton,
                width: 260,
                onPressed: () async {
                  await UserPreferences.setOnboardingComplete(true);
                  await NotificationService.instance.requestPermission();
                  if (context.mounted) {
                    final prefs = AppScope.of(context).prefs;
                    await NotificationService.instance.scheduleFromPrefs(prefs);
                    goToAndClear(context, const MainTabScreen());
                  }
                },
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
