import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../shared/widgets.dart';

class BuyPremiumScreen extends StatelessWidget {
  const BuyPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),

              const Spacer(flex: 2),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: AppColors.accent,
                  size: 44,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Премиум',
                style: AppTextStyles.heading1,
              ),

              const SizedBox(height: 16),

              Text(
                'Всего за \$1 в месяц вы можете\nубрать рекламу и получить\nдоступ ко всем упражнениям',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              PrimaryButton(
                label: 'Купить',
                width: double.infinity,
                height: 64,
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Скоро будет доступно'),
                      backgroundColor: AppColors.accent,
                    ),
                  );
                },
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}