import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../onboarding/name_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const NameScreen(),
              ),
              child: const Text('Регистрация'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => goToAndClear(
                context,
                const LoginScreen(),
              ),
              child: const Text('Уже есть аккаунт'),
            ),
          ],
        ),
      ),
    );
  }
}
