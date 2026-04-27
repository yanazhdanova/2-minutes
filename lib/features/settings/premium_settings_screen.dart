import 'package:flutter/material.dart';

/**
Заглушка экрана настроек премиум-подписки. Доступен из SettingsMainScreen
по тапу на пункт «Платная версия». На данный момент экран не содержит
функциональности - отображает стандартный AppBar с заголовком «Платная версия»,
кнопкой назад (Navigator.pop) и текст-заглушку «PremiumSettingsScreen» по центру.
В будущем здесь будет отображаться статус подписки и управление ею.
*/
class PremiumSettingsScreen extends StatelessWidget {
  const PremiumSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Платная версия'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('PremiumSettingsScreen')),
    );
  }
}
