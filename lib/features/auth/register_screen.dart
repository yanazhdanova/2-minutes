import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../onboarding/name_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(children: [
            const AppHeader(),
            const Spacer(flex: 2),
            Text(t.registerTitle, style: AppTextStyles.heading1.copyWith(fontSize: 38, color: c.textPrimary)),
            const SizedBox(height: 32),
            AppTextField(hintText: t.emailHint, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            AppTextField(hintText: t.passwordHint, obscureText: true),
            const SizedBox(height: 16),
            AppTextField(hintText: t.repeatPasswordHint, obscureText: true),
            const SizedBox(height: 32),
            PrimaryButton(label: t.registerButton, width: 280, onPressed: () => goToReplace(context, const NameScreen())),
            const Spacer(flex: 3),
            TextButton(
              onPressed: () => goToAndClear(context, const LoginScreen()),
              child: Text(t.alreadyHaveAccount, style: AppTextStyles.bodyLarge.copyWith(color: c.accentLight, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}