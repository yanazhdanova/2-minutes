import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../home/home_main_screen.dart';

class BuyPremiumScreen extends StatelessWidget {
  const BuyPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goToReplace(
            context,
            const HomeMainScreen(),
          ),
        ),
      ),
      body: const Center(
        child: Text('BuyPremiumScreen'),
      ),
    );
  }
}

