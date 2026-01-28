import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'catalog_main_screen.dart';


class MentalGroupsScreen extends StatelessWidget {
  const MentalGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental groups'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>(),
          /*
          onPressed: () => goTo(
            context,
            const MentalExercisesScreen(),
          ),
           */
          child: const Text('Группа 1'),
        ),
      ),
    );
  }
}
