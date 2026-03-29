import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
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
  void dispose() { _loginCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              const AppHeader(),
              const Spacer(flex: 2),
              Text(t.loginTitle, style: AppTextStyles.heading1.copyWith(color: c.textPrimary)),
              const SizedBox(height: 32),
              AppTextField(controller: _loginCtrl, hintText: t.emailHint, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              AppTextField(controller: _passCtrl, hintText: t.passwordHint, obscureText: true),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => goTo(context, const ResetPasswordScreen()),
                  child: Text(t.forgotPassword, style: AppTextStyles.label.copyWith(color: c.accentLight, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: t.loginButton, width: 260, onPressed: () => goToAndClear(context, const MainTabScreen())),
              const Spacer(flex: 3),
              TextButton(
                onPressed: () => goToAndClear(context, const RegisterScreen()),
                child: Text(t.registerLink, style: AppTextStyles.bodyLarge.copyWith(color: c.accentLight, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}