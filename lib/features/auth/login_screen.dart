import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../app/theme_controller.dart';
import '../../app/locale_controller.dart';
import '../../shared/widgets.dart';
import 'auth_service.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';
import '../../app/main_tab_screen.dart';
import '../onboarding/name_screen.dart';
import '../exercises/data/notification_service.dart';

/// Экран входа в приложение. Содержит поля email и пароль, кнопки «Войти» и «Войти через Google»,
/// ссылки на сброс пароля и регистрацию. После успешной аутентификации проверяет,
/// завершён ли онбординг: если да - переходит на MainTabScreen, иначе - на NameScreen.
/// Ошибки Firebase отображаются через SnackBar с маппингом кодов в пользовательские сообщения.
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
    final scope = AppScope.of(context);
    await scope.userData.init();
    if (!mounted) return;
    await _syncSettings(scope);
    if (!mounted) return;
    scope.userData.isOnboardingDone
        ? goToAndClear(context, const MainTabScreen())
        : goToAndClear(context, const NameScreen());
  }

  Future<void> _syncSettings(AppScope scope) async {
    final userData = scope.userData;
    final prefs = scope.prefs;
    final themeCtrl = ThemeController.of(context);
    final localeCtrl = LocaleController.of(context);

    // Тема и акцент
    final tm = userData.themeMode;
    await themeCtrl.setThemeMode(
      tm == 'dark' ? ThemeMode.dark : tm == 'light' ? ThemeMode.light : ThemeMode.system,
    );
    await themeCtrl.setAccentColor(
      userData.accentColor == 'pink' ? AccentColor.pink : AccentColor.green,
    );

    // Язык
    final lang = userData.languageCode;
    if (lang.isNotEmpty) {
      await localeCtrl.setLocale(Locale(lang));
    }

    // Уведомления - синхронизация в PrefsService
    await prefs.setNotifFrom(userData.notifFrom);
    await prefs.setNotifTo(userData.notifTo);
    await prefs.setNotifFreq(userData.notifFreq);
    await prefs.setNotifDays(userData.notifDays);

    if (userData.isOnboardingDone) {
      NotificationService.instance.scheduleFromPrefs(prefs);
    }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            children: [
              const AppHeader(),
              const SizedBox(height: 40),
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
                    child: Divider(color: c.textPrimary.withValues(alpha: 0.2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      t.orDivider,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.textPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: c.textPrimary.withValues(alpha: 0.2)),
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
                      color: c.textPrimary.withValues(alpha: 0.3),
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

              const SizedBox(height: 48),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
