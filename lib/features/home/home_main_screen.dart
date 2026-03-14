import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../shared/widgets.dart';
import '../premium/buy_premium_screen.dart';
import 'exercises_choice.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await UserPreferences.getName();
    if (mounted) {
      setState(() {
        _userName = name ?? 'User';
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'Доброй ночи';
    if (hour < 12) return 'Доброе утро';
    if (hour < 18) return 'Добрый день';
    return 'Добрый вечер';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Row(
                children: [
                  PremiumIcon(
                    onTap: () => goTo(context, const BuyPremiumScreen()),
                  ),
                  const Expanded(
                    child: Text(
                      '2 минуты',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.logo,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const Spacer(flex: 2),

              Text(
                '$greeting,',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 4),
              Text(
                _userName,
                style: AppTextStyles.heading2,
              ),

              const Spacer(flex: 1),

              PrimaryButton(
                label: 'Начать тренировку',
                width: double.infinity,
                height: 64,
                onPressed: () => goTo(context, const ExercisesChoiceScreen()),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}