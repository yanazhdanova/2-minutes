import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../home/home_main_screen.dart';
import '../catalog/catalog_main_screen.dart';
import 'program_settings_screen.dart';
import 'notif_settings_screen.dart';
import 'language_settings_screen.dart';
import 'appearance_settings_screen.dart';
import 'premium_settings_screen.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: SingleChildScrollView(
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
                  const CatalogMainScreen(),
                ),
                child: const Text('Каталог'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => goTo(
                  context,
                  const ProgramSettingsScreen(),
                ),
                child: const Text('Моя программа'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => goTo(
                  context,
                  const NotifSettingsScreen(),
                ),
                child: const Text('Уведомления'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => goTo(
                  context,
                  const LanguageSettingsScreen(),
                ),
                child: const Text('Язык'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => goTo(
                  context,
                  const AppearanceSettingsScreen(),
                ),
                child: const Text('Внешний вид'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => goTo(
                  context,
                  const PremiumSettingsScreen(),
                ),
                child: const Text('Платная версия'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
