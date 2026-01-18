import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'reset_password_screen.dart';
import 'set_new_password_screen.dart';

class ResetPasswordCodeScreen extends StatelessWidget {
  const ResetPasswordCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToAndClear(
            context,
            const SetNewPasswordScreen(),
          ),
          child: const Text('Далее'),
        ),
      ),
    );
  }
}

