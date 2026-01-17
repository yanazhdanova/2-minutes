import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'categories_screen.dart';
import 'notif_freq_screen.dart';

class NotifTimeScreen extends StatelessWidget {
  const NotifTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification time'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const CategoriesScreen(),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const NotifFreqScreen(),
          ),
          child: const Text('Далее'),
        ),
      ),
    );
  }
}
