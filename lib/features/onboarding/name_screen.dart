import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'categories_screen.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

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

              const Spacer(flex: 3),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Введи свое имя',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              TextField(
                decoration: _fieldDecoration(),
              ),

              const SizedBox(height: 36),

              SizedBox(
                width: 260,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(width: 1),
                  ),
                  onPressed: () => goTo(
                    context,
                    const CategoriesScreen(),
                  ),
                  child: const Text('Далее'),
                ),
              ),

              const Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }
}
