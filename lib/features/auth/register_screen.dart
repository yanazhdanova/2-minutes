import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../app/theme_controller.dart';
import '../../app/locale_controller.dart';
import '../../shared/widgets.dart';
import 'auth_service.dart';
import '../onboarding/name_screen.dart';
import '../exercises/data/notification_service.dart';
import '../../app/main_tab_screen.dart';
import 'login_screen.dart';

/// Экран регистрации нового пользователя. Содержит поля email, пароль и подтверждение пароля,
/// кнопку «Зарегистрироваться» и «Продолжить с Google», ссылку на экран логина.
/// Валидация: все поля обязательны, пароли должны совпадать, минимум 6 символов.
/// После успешной регистрации переходит на NameScreen (начало онбординга).
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
      if (mounted) {
        final scope = AppScope.of(context);
        await scope.userData.init();
        if (mounted) await _syncSettings(scope);
        if (mounted) goToReplace(context, const NameScreen());
      }
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
      if (mounted) {
        final scope = AppScope.of(context);
        await scope.userData.init();
        if (mounted) await _syncSettings(scope);
        if (mounted) {
          scope.userData.isOnboardingDone
              ? goToAndClear(context, const MainTabScreen())
              : goToAndClear(context, const NameScreen());
        }
      }
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

  Future<void> _syncSettings(AppScope scope) async {
    final userData = scope.userData;
    final prefs = scope.prefs;
    final themeCtrl = ThemeController.of(context);
    final localeCtrl = LocaleController.of(context);

    final tm = userData.themeMode;
    await themeCtrl.setThemeMode(
      tm == 'dark' ? ThemeMode.dark : tm == 'light' ? ThemeMode.light : ThemeMode.system,
    );
    await themeCtrl.setAccentColor(
      userData.accentColor == 'pink' ? AccentColor.pink : AccentColor.green,
    );

    final lang = userData.languageCode;
    if (lang.isNotEmpty) {
      await localeCtrl.setLocale(Locale(lang));
    }

    await prefs.setNotifFrom(userData.notifFrom);
    await prefs.setNotifTo(userData.notifTo);
    await prefs.setNotifFreq(userData.notifFreq);
    await prefs.setNotifDays(userData.notifDays);

    if (userData.isOnboardingDone) {
      NotificationService.instance.scheduleFromPrefs(prefs);
    }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            children: [
              const AppHeader(),
              const SizedBox(height: 40),
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
                          t.googleContinue,
                          style: AppTextStyles.buttonLarge.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 48),
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
