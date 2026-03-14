import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../shared/widgets.dart';
import 'login_screen.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

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

              const Spacer(flex: 2),

              Text(
                'Придумайте\nновый пароль',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 36),

              const AppTextField(
                hintText: 'Новый пароль',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const AppTextField(
                hintText: 'Повторите пароль',
                obscureText: true,
              ),

              const SizedBox(height: 32),

              OutlineButton(
                label: 'Поменять пароль',
                width: 260,
                onPressed: () => goToAndClear(context, const LoginScreen()),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}