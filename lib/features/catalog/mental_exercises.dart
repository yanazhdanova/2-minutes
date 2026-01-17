import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'mental_groups.dart';

class MentalExercisesScreen extends StatelessWidget {
  const MentalExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental exercises'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const MentalGroupsScreen(),
          ),
        ),
      ),
      body: const Center(
        child: Text('MentalExercisesScreen'),
      ),
    );
  }
}


