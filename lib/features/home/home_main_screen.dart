import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../premium/buy_premium_screen.dart';
import '../home/rand_or_not_choice_screen.dart';
import '../catalog/catalog_main_screen.dart';
import '../settings/settings_main_screen.dart';

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const BuyPremiumScreen(),
              ),
              child: const Text('Премиум'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const RandOrNotChoiceScreen(),
              ),
              child: const Text('Начать тренировку'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const CatalogMainScreen(),
              ),
              child: const Text('Каталог'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const SettingsMainScreen(),
              ),
              child: const Text('Настройки'),
            ),
          ],
        ),
      ),
    );
  }
}
