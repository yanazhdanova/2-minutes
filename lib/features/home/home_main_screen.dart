import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../premium/buy_premium_screen.dart';
import 'rand_or_not_choice_screen.dart';

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 18),


              Row(
                children: [
                  const SizedBox(width: 56, height: 56), // симметрия справа
                  const Expanded(
                    child: Center(
                      child: Text(
                        '2 минуты',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => goTo(
                        context,
                        const BuyPremiumScreen(),
                      ),
                      icon: const Icon(
                        Icons.workspace_premium,
                        size: 40,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),



              Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Доброго времени суток,\n%имя%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: const BorderSide(width: 1),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () => goTo(
                        context,
                        const RandOrNotChoiceScreen(),
                      ),
                      child: const Text('Начать тренировку'),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
        ),
      ),
      ),
    );
  }
}
