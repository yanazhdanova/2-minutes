import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'catalog_main_screen.dart';
import 'physical_exercises.dart';

class PhysicalGroupsScreen extends StatelessWidget {
  const PhysicalGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical groups'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const CatalogMainScreen(),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const PhysicalExercisesScreen(),
          ),
          child: const Text('Группа 1'),
        ),
      ),
    );
  }
}

