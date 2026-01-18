import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'reset_password_code_screen.dart';
import 'login_screen.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New password'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToAndClear(
            context,
            const LoginScreen(),
          ),
          child: const Text('Сохранить и войти'),
        ),
      ),
    );
  }
}

