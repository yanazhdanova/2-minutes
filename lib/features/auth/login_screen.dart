import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../app/user_preferences.dart';
import '../../shared/widgets.dart';
import 'auth_service.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';
import '../../app/main_tab_screen.dart';
import '../onboarding/name_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final t = Tr.of(context);
    final email = _loginCtrl.text.trim();
    final password = _passCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      _showError(t.fillAllFields);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.login(email: email, password: password);
      if (mounted) await _navigateAfterAuth();
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
      if (mounted) await _navigateAfterAuth();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'google-cancelled') return;
      if (mounted) _showError(_mapError(e.code));
    } catch (_) {
      if (mounted) _showError('Error');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _navigateAfterAuth() async {
    final done = await UserPreferences.isOnboardingComplete();
    if (!mounted) return;
    done
        ? goToAndClear(context, const MainTabScreen())
        : goToAndClear(context, const NameScreen());
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: C(context).error),
    );
  }

  String _mapError(String code) => switch (code) {
    'user-not-found' => 'User not found',
    'wrong-password' => 'Wrong password',
    'invalid-email' => 'Invalid email',
    'user-disabled' => 'Account disabled',
    'too-many-requests' => 'Too many attempts',
    'invalid-credential' => 'Invalid email or password',
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
                t.loginTitle,
                style: AppTextStyles.heading1.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 32),
              AppTextField(
                controller: _loginCtrl,
                hintText: t.emailHint,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),
              AppTextField(
                controller: _passCtrl,
                hintText: t.passwordHint,
                obscureText: true,
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => goTo(context, const ResetPasswordScreen()),
                  child: Text(
                    t.forgotPassword,
                    style: AppTextStyles.label.copyWith(
                      color: c.accentLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              PrimaryButton(
                label: t.loginButton,
                width: 260,
                isLoading: _isLoading,
                onPressed: _handleLogin,
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
                          t.googleSignIn,
                          style: AppTextStyles.buttonLarge.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                ),
              ),

              const Spacer(flex: 3),
              TextButton(
                onPressed: () => goToAndClear(context, const RegisterScreen()),
                child: Text(
                  t.registerLink,
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
