import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'name_screen.dart';
import 'notif_time_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const NameScreen(),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const NotifTimeScreen(),
          ),
          child: const Text('Далее'),
        ),
      ),
    );
  }
}

