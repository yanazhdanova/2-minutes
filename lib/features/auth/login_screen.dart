import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../shared/widgets.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';
import '../../app/main_tab_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
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

              const Spacer(flex: 2),

              Text('Логин', style: AppTextStyles.heading1),

              const SizedBox(height: 32),

              AppTextField(
                controller: _loginCtrl,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passCtrl,
                hintText: 'Пароль',
                obscureText: true,
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => goTo(context, const ResetPasswordScreen()),
                  child: Text(
                    'Забыли пароль?',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                label: 'Войти',
                width: 260,
                onPressed: () => goToAndClear(context, const MainTabScreen()),
              ),

              const Spacer(flex: 3),

              TextButton(
                onPressed: () => goToAndClear(context, const RegisterScreen()),
                child: Text(
                  'Регистрация',
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