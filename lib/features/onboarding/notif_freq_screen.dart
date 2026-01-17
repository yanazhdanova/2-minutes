import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'notif_time_screen.dart';
import 'final_screen.dart';

class NotifFreqScreen extends StatelessWidget {
  const NotifFreqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification frequency'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const NotifTimeScreen(),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToReplace(
            context,
            const FinalScreen(),
          ),
          child: const Text('Далее'),
        ),
      ),
    );
  }
}

