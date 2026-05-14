import 'dart:async';

import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../app/main_tab_screen.dart';
import '../../shared/language_picker_button.dart';
import '../../shared/widgets.dart';
import '../../features/exercises/data/notification_service.dart';

/// Пятый и финальный экран онбординга. Показывает иконку-галочку и информирует,
/// что настройки можно изменить позже. При нажатии «Отлично» выполняет:
/// 1. Отмечает онбординг завершённым (UserPreferences.setOnboardingComplete).
/// 2. Запрашивает разрешение на уведомления (NotificationService.requestPermission).
/// 3. Планирует расписание уведомлений (NotificationService.scheduleFromPrefs).
/// 4. Переходит на MainTabScreen, очищая весь стек навигации.
class FinalScreen extends StatefulWidget {
  final Future<bool> Function()? requestPermission;
  final Future<void> Function()? scheduleNotifications;

  const FinalScreen({
    super.key,
    this.requestPermission,
    this.scheduleNotifications,
  });

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  bool _isCompleting = false;

  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);

    final scope = AppScope.of(context);
    final nav = Navigator.of(context);

    await scope.userData.setOnboardingDone(true);
    await scope.prefs.setOnboardingDone(true);

    try {
      await (widget.requestPermission?.call() ??
          NotificationService.instance.requestPermission());
    } catch (e, st) {
      debugPrint('Notification permission request failed: $e\n$st');
    }

    unawaited(
      (widget.scheduleNotifications?.call() ??
              NotificationService.instance.scheduleFromPrefs(scope.prefs))
          .catchError((Object e, StackTrace st) {
            debugPrint('Notification scheduling failed: $e\n$st');
          }),
    );

    if (!mounted) return;
    nav.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainTabScreen()),
      (_) => false,
    );
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
              const AppHeader(trailing: LanguagePickerButton()),
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
                isLoading: _isCompleting,
                onPressed: _completeOnboarding,
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
