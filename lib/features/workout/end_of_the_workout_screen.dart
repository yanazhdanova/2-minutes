import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../home/home_main_screen.dart';

class EndOfTheWorkoutScreen extends StatelessWidget {
  const EndOfTheWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout finished')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToAndClear(
            context,
            const HomeMainScreen(),
          ),
          child: const Text('На главную'),
        ),
      ),
    );
  }
}
