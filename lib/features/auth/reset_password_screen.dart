import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'auth_service.dart';

/**
Экран сброса пароля. Два состояния:
1. Ввод email и кнопка «Далее» - отправляет письмо для сброса через Firebase.
2. Подтверждение отправки - показывает иконку письма, текст с email и кнопку «Назад к логину».
Переключение между состояниями через флаг _isSent.
*/
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;
  bool _isSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final t = Tr.of(context);
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showError(t.enterEmail);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.resetPassword(email: email);
      if (mounted) setState(() => _isSent = true);
    } on FirebaseAuthException catch (e) {
      if (mounted) _showError('Error: ${e.code}');
    } catch (_) {
      if (mounted) _showError('Error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: C(context).error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),
              const Spacer(flex: 2),

              if (!_isSent) ...[
                Text(
                  t.resetPasswordTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
                ),

                const SizedBox(height: 36),
                AppTextField(
                  controller: _emailCtrl,
                  hintText: t.emailHint,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 32),
                OutlineButton(
                  label: t.next,
                  width: 260,
                  onPressed: _isLoading ? null : _handleReset,
                ),
              ] else ...[
                Icon(
                  Icons.mark_email_read_outlined,
                  size: 64,
                  color: c.accentLight,
                ),

                const SizedBox(height: 24),
                Text(
                  t.emailSentTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    t.emailSentBody(_emailCtrl.text.trim()),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(color: c.textSecondary),
                  ),
                ),

                const SizedBox(height: 32),
                OutlineButton(
                  label: t.backToLogin,
                  width: 260,
                  onPressed: () => Navigator.pop(context),
                ),
              ],

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
