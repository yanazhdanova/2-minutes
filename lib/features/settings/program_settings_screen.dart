import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'settings_main_screen.dart';

class ProgramSettingsScreen extends StatelessWidget {
  const ProgramSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя программа'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(context, const SettingsMainScreen()),
        ),
      ),
      body: const Center(child: Text('ProgramSettingsScreen')),
    );
  }
}
