import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'physical_groups.dart';

class PhysicalExercisesScreen extends StatelessWidget {
  const PhysicalExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical exercises'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const PhysicalGroupsScreen(),
          ),
        ),
      ),
      body: const Center(
        child: Text('PhysicalExercisesScreen'),
      ),
    );
  }
}

