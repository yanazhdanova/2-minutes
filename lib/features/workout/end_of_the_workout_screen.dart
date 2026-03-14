import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/main_tab_screen.dart';
import '../../shared/widgets.dart';

class EndOfTheWorkoutScreen extends StatelessWidget {
  const EndOfTheWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              const SizedBox(height: 18),

              const Text('2 минуты', style: AppTextStyles.logo),

              const Spacer(flex: 3),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.accentSurface,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.accent,
                  size: 56,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Отлично!',
                style: AppTextStyles.heading1,
              ),

              const SizedBox(height: 16),

              Text(
                'Тренировка завершена.\nТак держать!',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              PrimaryButton(
                label: 'На главную',
                width: double.infinity,
                height: 64,
                onPressed: () => goToAndClear(context, const MainTabScreen()),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}