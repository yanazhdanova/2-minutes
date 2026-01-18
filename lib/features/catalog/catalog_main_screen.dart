import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../home/home_main_screen.dart';
import '../settings/settings_main_screen.dart';
import 'physical_groups.dart';
import 'mental_groups.dart';

class CatalogMainScreen extends StatelessWidget {
  const CatalogMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => goToAndClear(
                context,
                const HomeMainScreen(),
              ),
              child: const Text('Главная'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToAndClear(
                context,
                const SettingsMainScreen(),
              ),
              child: const Text('Настройки'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goTo(
                context,
                const PhysicalGroupsScreen(),
              ),
              child: const Text('Физические'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goTo(
                context,
                const MentalGroupsScreen(),
              ),
              child: const Text('Ментальные'),
            ),
          ],
        ),
      ),
    );
  }
}

