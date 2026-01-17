import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'settings_main_screen.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Внешний вид'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(context, const SettingsMainScreen()),
        ),
      ),
      body: const Center(child: Text('AppearanceSettingsScreen')),
    );
  }
}
