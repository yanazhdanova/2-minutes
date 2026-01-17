import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../home/home_main_screen.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToAndClear(
            context,
            const HomeMainScreen(),
          ),
          child: const Text('Далее'),
        ),
      ),
    );
  }
}
