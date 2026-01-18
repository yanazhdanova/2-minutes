import 'package:flutter/material.dart';

import '../../app/navigation.dart';
import 'reset_password_code_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  InputDecoration _fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade300,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
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


              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '2 минуты',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const Spacer(flex: 2),


              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Восстановление',
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'пароля',
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 36),


              TextField(decoration: _fieldDecoration()),

              const SizedBox(height: 28),


              SizedBox(
                width: 260,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => goTo(
                    context,
                    const ResetPasswordCodeScreen(),
                  ),
                  child: const Text('Далее'),
                ),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}