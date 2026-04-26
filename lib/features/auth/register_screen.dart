import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'auth_service.dart';
import '../onboarding/name_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final t = Tr.of(context);
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError(t.fillAllFields);
      return;
    }
    if (password != confirm) {
      _showError(t.passwordsDontMatch);
      return;
    }
    if (password.length < 6) {
      _showError(t.passwordTooShort);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.register(email: email, password: password);
      if (mounted) goToReplace(context, const NameScreen());
    } on FirebaseAuthException catch (e) {
      if (mounted) _showError(_mapError(e.code));
    } catch (_) {
      if (mounted) _showError('Error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      await _auth.signInWithGoogle();
      if (mounted) goToAndClear(context, const NameScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'google-cancelled') return;
      if (mounted) _showError(_mapError(e.code));
    } catch (_) {
      if (mounted) _showError('Error');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: C(context).error),
    );
  }

  String _mapError(String code) => switch (code) {
    'email-already-in-use' => 'Email already in use',
    'weak-password' => 'Weak password',
    'invalid-email' => 'Invalid email',
    _ => 'Error: $code',
  };

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
              const AppHeader(),
              const Spacer(flex: 2),
              Text(
                t.registerTitle,
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 38,
                  color: c.textPrimary,
                ),
              ),

              const SizedBox(height: 32),
              AppTextField(
                controller: _emailCtrl,
                hintText: t.emailHint,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),
              AppTextField(
                controller: _passCtrl,
                hintText: t.passwordHint,
                obscureText: true,
              ),

              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmCtrl,
                hintText: t.repeatPasswordHint,
                obscureText: true,
              ),

              const SizedBox(height: 32),
              PrimaryButton(
                label: t.registerButton,
                width: 280,
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Divider(color: c.textPrimary.withOpacity(0.2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      t.orDivider,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.textPrimary.withOpacity(0.5),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Divider(color: c.textPrimary.withOpacity(0.2)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _isGoogleLoading ? null : _handleGoogle,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: c.textPrimary,
                    side: BorderSide(
                      color: c.textPrimary.withOpacity(0.3),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                    ),
                  ),

                  child: _isGoogleLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: c.textPrimary,
                          ),
                        )
                      : Text(
                          t.googleContinue,
                          style: AppTextStyles.buttonLarge.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                ),
              ),

              const Spacer(flex: 3),
              TextButton(
                onPressed: () => goToAndClear(context, const LoginScreen()),
                child: Text(
                  t.alreadyHaveAccount,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: c.accentLight,
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
