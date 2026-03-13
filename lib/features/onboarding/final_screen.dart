import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../../app/main_tab_screen.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

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

              // верхний текст
              const Text(
                '2 минуты',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 3),

              // большой текст по центру, с ручными переносами как в макете
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Вы всегда можете\n'
                        'поменять\n'
                        'параметры в\n'
                        'разделе\n'
                        '“Настройки”',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 46),

              // кнопка "Отлично" (без серой заливки)
              SizedBox(
                width: 260,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(width: 1),
                    textStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => goToAndClear(
                    context,
                    const MainTabScreen(),
                  ),
                  child: const Text('Отлично'),
                ),
              ),

              const Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }
}

