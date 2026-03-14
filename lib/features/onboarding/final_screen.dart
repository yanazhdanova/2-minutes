import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../app/main_tab_screen.dart';
import '../../shared/widgets.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    await UserPreferences.setOnboardingComplete(true);

    if (context.mounted) {
      goToAndClear(context, const MainTabScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              const AppHeader(),

              const Spacer(flex: 3),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.accent,
                  size: 44,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Вы всегда можете\nпоменять параметры\nв разделе\n"Настройки"',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 48),

              PrimaryButton(
                label: 'Отлично',
                width: 260,
                onPressed: () => _finish(context),
              ),

              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}