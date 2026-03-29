import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
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
            AppHeader(onBack: () => Navigator.pop(context)),
            const Spacer(flex: 2),
            Text(t.resetPasswordTitle, textAlign: TextAlign.center, style: AppTextStyles.heading2.copyWith(color: c.textPrimary)),
            const SizedBox(height: 36),
            AppTextField(hintText: t.emailHint, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 32),
            OutlineButton(label: t.next, width: 260, onPressed: () => goToAndClear(context, const LoginScreen())),
            const Spacer(flex: 4),
          ]),
        ),
      ),
    );
  }
}