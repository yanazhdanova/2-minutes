import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../home/exercises_choice.dart';
import 'home_catalog_phys.dart';
import 'home_catalog_mental.dart';

class HomePhysMentalScreen extends StatelessWidget {
  const HomePhysMentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical or Mental'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const ExercisesChoiceScreen(),
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
                const HomeCatalogPhysScreen(),
              ),
              child: const Text('Физическое'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const HomeCatalogMentalScreen(),
              ),
              child: const Text('Ментальное'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const ExercisesChoiceScreen(),
              ),
              child: const Text('Случайное'),
            ),
          ],
        ),
      ),
    );
  }
}

