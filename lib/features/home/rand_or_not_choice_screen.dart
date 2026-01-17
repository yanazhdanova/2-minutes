import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'home_main_screen.dart';
import 'exercises_choice.dart';

class RandOrNotChoiceScreen extends StatelessWidget {
  const RandOrNotChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout choice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const HomeMainScreen(),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const ExercisesChoiceScreen(),
              ),
              child: const Text('Выбрать упражнения'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const ExercisesChoiceScreen(),
              ),
              child: const Text('Случайные упражнения'),
            ),
          ],
        ),
      ),
    );
  }
}
