import 'package:flutter/material.dart';
import 'package:two_mins/features/auth/reset_password_code_screen.dart';
import '../../app/navigation.dart';
import 'login_screen.dart';
import 'reset_password_code_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToAndClear(
            context,
            const LoginScreen(),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const ResetPasswordCodeScreen(),
          ),
          child: const Text('Далее'),
        ),
      ),
    );
  }
}

