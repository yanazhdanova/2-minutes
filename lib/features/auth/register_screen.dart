import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../shared/widgets.dart';
import '../onboarding/name_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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

              Text('Регистрация', style: AppTextStyles.heading1.copyWith(fontSize: 38)),

              const SizedBox(height: 32),

              const AppTextField(hintText: 'Email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const AppTextField(hintText: 'Пароль', obscureText: true),
              const SizedBox(height: 16),
              const AppTextField(hintText: 'Повторите пароль', obscureText: true),

              const SizedBox(height: 32),

              PrimaryButton(
                label: 'Зарегистрироваться',
                width: 280,
                onPressed: () => goToReplace(context, const NameScreen()),
              ),

              const Spacer(flex: 3),

              TextButton(
                onPressed: () => goToAndClear(context, const LoginScreen()),
                child: Text(
                  'Уже есть аккаунт',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}