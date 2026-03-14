import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../shared/widgets.dart';
import 'set_new_password_screen.dart';

class ResetPasswordCodeScreen extends StatelessWidget {
  const ResetPasswordCodeScreen({super.key});

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
                'На вашу почту был\nотправлен код',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 36),

              const AppTextField(
                hintText: 'Код',
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),

              OutlineButton(
                label: 'Далее',
                width: 260,
                onPressed: () => goToAndClear(context, const SetNewPasswordScreen()),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}