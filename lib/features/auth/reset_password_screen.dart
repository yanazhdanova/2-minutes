import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../shared/widgets.dart';
import 'reset_password_code_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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

              Text(
                'Восстановление\nпароля',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 36),

              const AppTextField(
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 32),

              OutlineButton(
                label: 'Далее',
                width: 260,
                onPressed: () => goTo(context, const ResetPasswordCodeScreen()),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}