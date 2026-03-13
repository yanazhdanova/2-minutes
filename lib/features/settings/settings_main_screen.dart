import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import 'program_settings_screen.dart';
import 'notif_settings_screen.dart';
import 'language_settings_screen.dart';
import 'appearance_settings_screen.dart';
import '../premium/buy_premium_screen.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  Widget _settingsItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

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

              const SizedBox(height: 36),

              _settingsItem(
                title: 'Моя программа',
                onTap: () => goTo(
                  context,
                  const ProgramSettingsScreen(),
                ),
              ),
              _settingsItem(
                title: 'Уведомления',
                onTap: () => goTo(
                  context,
                  const NotifSettingsScreen(),
                ),
              ),
              _settingsItem(
                title: 'Язык',
                onTap: () => goTo(
                  context,
                  const LanguageSettingsScreen(),
                ),
              ),
              _settingsItem(
                title: 'Внешний вид',
                onTap: () => goTo(
                  context,
                  const AppearanceSettingsScreen(),
                ),
              ),
              _settingsItem(
                title: 'Платная версия',
                onTap: () => goTo(
                  context,
                  const BuyPremiumScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
