import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'end_of_the_workout_screen.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const EndOfTheWorkoutScreen(),
          ),
          child: const Text('Завершить'),
        ),
      ),
    );
  }
}

