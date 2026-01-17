import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'categories_screen.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Name')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const CategoriesScreen(),
          ),
          child: const Text('Далее'),
        ),
      ),
    );
  }
}
