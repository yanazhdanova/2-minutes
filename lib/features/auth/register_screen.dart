import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../onboarding/name_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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


              const Text(
                '2 минуты',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 2),


              const Align(

                child: Text(
                  'Регистрация',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w400,

                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// поля
              TextField(decoration: _fieldDecoration()),
              const SizedBox(height: 18),
              TextField(decoration: _fieldDecoration()),
              const SizedBox(height: 18),
              TextField(decoration: _fieldDecoration()),

              const SizedBox(height: 26),


              SizedBox(
                width: 260,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => goToReplace(
                    context,
                    const NameScreen(),
                  ),
                  child: const Text('Зарегистрироваться'),
                ),
              ),

              const Spacer(flex: 3),


              TextButton(
                onPressed: () => goToAndClear(
                  context,
                  const LoginScreen(),
                ),
                child: const Text(
                  'Уже есть аккаунт',
                  style: TextStyle(
                    fontSize: 20,
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