import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../home/rand_or_not_choice_screen.dart';
import '../workout/exercise_screen.dart';
import '../home/home_phys_mental_screen.dart';

class ExercisesChoiceScreen extends StatelessWidget {
  const ExercisesChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises choice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToAndClear(
          context,
          const RandOrNotChoiceScreen(),
          ),
      ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => goToAndClear(
                context,
                const ExerciseScreen(),
              ),
              child: const Text('Начать'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goTo(
                context,
                const HomePhysMentalScreen(),
              ),
              child: const Text('1 упражнение'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goTo(
                context,
                const HomePhysMentalScreen(),
              ),
              child: const Text('2 упражнение'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goTo(
                context,
                const HomePhysMentalScreen(),
              ),
              child: const Text('3 упражнение'),
            ),
          ],
        ),
      ),
    );
  }
}

