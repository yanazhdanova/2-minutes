import 'package:flutter/material.dart';
import 'features/onboarding/name_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Для отладки: всегда показываем онбординг
      // Когда отладка завершена, заменить на SplashScreen
      home: NameScreen(),
    );
  }
}

// TODO: Когда отладка завершена, использовать этот вариант:
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }