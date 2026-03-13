import 'package:flutter/material.dart';
import '../../app/navigation.dart';
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

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 18),
              const Text(
                '2 минуты',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 2),

              const Text(
                'Логин',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 28),

              TextField(
                controller: _loginCtrl,
                decoration: _fieldDecoration(''),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: _fieldDecoration(''),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => goTo(context, const ResetPasswordScreen()),
                  child: const Text(
                    'Забыли пароль?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: 260,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,

                    ),
                  ),
                  onPressed: () => goToAndClear(context, const MainTabScreen()),
                  child: const Text('Войти'),
                ),
              ),

              const Spacer(flex: 3),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () => goToAndClear(context, const RegisterScreen()),
                child: const Text(
                  'Регистрация',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
