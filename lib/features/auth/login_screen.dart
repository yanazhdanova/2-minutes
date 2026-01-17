import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';
import '../home/home_main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => goTo(
                context,
                const ResetPasswordScreen(),
              ),
              child: const Text('Забыли пароль?'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToAndClear(
                context,
                const HomeMainScreen(),
              ),
              child: const Text('Войти'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => goToAndClear(
                context,
                const RegisterScreen(),
              ),
              child: const Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}
