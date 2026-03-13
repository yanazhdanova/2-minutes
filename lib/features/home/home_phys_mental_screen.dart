import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../exercises/domain/exercise_models.dart';
import 'home_catalog_phys.dart';
import 'home_catalog_mental.dart';

class HomePhysMentalScreen extends StatelessWidget {
  const HomePhysMentalScreen({super.key});

  Future<void> _pickRandom(BuildContext context) async {
    final repo = AppScope.of(context).exerciseRepo;

    final physCats = await repo.categoriesByType(HealthType.physical);
    final mentCats = await repo.categoriesByType(HealthType.mental);
    final allCats = [...physCats, ...mentCats];

    final allExercises = <Exercise>[];
    for (final cat in allCats) {
      allExercises.addAll(await repo.exercisesByCategory(cat.id));
    }

    if (allExercises.isNotEmpty) {
      final random = allExercises[Random().nextInt(allExercises.length)];
      if (context.mounted) Navigator.pop(context, random);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical or Mental'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final Exercise? result = await Navigator.push<Exercise>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeCatalogPhysScreen(),
                  ),
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
              child: const Text('Физическое'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final Exercise? result = await Navigator.push<Exercise>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeCatalogMentalScreen(),
                  ),
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
              child: const Text('Ментальное'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _pickRandom(context),
              child: const Text('Случайное'),
            ),
          ],
        ),
      ),
    );
  }
}