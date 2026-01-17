import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'home_phys_mental_screen.dart';
import 'exercises_choice.dart';

class HomeCatalogMentalScreen extends StatelessWidget {
  const HomeCatalogMentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental catalog'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const HomePhysMentalScreen(),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const ExercisesChoiceScreen(),
          ),
          child: const Text('Случайная'),
        ),
      ),
    );
  }
}
