import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'workout_type_screen.dart';

/// Главный экран приложения (вкладка «Главная»). Загружает имя пользователя
/// из UserPreferences и отображает приветствие, зависящее от времени суток
/// (ночь < 6, утро < 12, день < 18, вечер). Содержит кнопку
/// «Начать тренировку», ведущую на WorkoutTypeScreen.
class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});
  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  String _greeting(Tr t) {
    final h = DateTime.now().hour;
    if (h < 6) return t.greetingNight;
    if (h < 12) return t.greetingMorning;
    if (h < 18) return t.greetingAfternoon;
    return t.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final scope = AppScope.of(context);
    final userName = scope.userData.userName.isNotEmpty
        ? scope.userData.userName
        : 'User';
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Center(
                child: Text(
                  t.appName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.logo.copyWith(color: c.textPrimary),
                ),
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: c.accentSurface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '\u{1F525} ${t.streakText(scope.userData.streakDays)}',
                  style: AppTextStyles.bodySmall.copyWith(color: c.accentLight),
                ),
              ),

              const Spacer(flex: 3),
              Text(
                '${_greeting(t)},',
                style: AppTextStyles.heading3.copyWith(color: c.textSecondary),
              ),

              const SizedBox(height: 8),
              Text(
                userName,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),

              const Spacer(flex: 3),
              PrimaryButton(
                label: t.startWorkout,
                width: double.infinity,
                height: 64,
                onPressed: () => goTo(context, const WorkoutTypeScreen()),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
