import 'package:flutter/material.dart';
import '../../app/main_tab_screen.dart';
import '../../app/navigation.dart';


class EndOfTheWorkoutScreen extends StatelessWidget {
  const EndOfTheWorkoutScreen({super.key});

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

              const Text(
                '2 минуты',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 4),


              const Text(
                'Тренировка\nзакончена!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w500,
                  height: 1.05,
                ),
              ),

              const SizedBox(height: 22),


              const Text(
                'Все упражнения выполнены!\nВы восхитительны',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => goToAndClear(
                    context,
                    const MainTabScreen(),
                  ),
                  child: const Text(
                    'На главную',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 7),
            ],
          ),
        ),
      ),
    );
  }
}
