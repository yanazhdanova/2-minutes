import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../app/l10n/app_localizations.dart';
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
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { final n = await UserPreferences.getName(); if (mounted) setState(() => _userName = n ?? 'User'); }

  String _greeting(Tr t) { final h = DateTime.now().hour; if (h < 6) return t.greetingNight; if (h < 12) return t.greetingMorning; if (h < 18) return t.greetingAfternoon; return t.greetingEvening; }

  @override
  Widget build(BuildContext context) {
    final c = C(context); final t = Tr.of(context);
    return Scaffold(backgroundColor: c.background, body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal), child: Column(children: [
      const SizedBox(height: 18),
      Row(children: [PremiumIcon(onTap: () => goTo(context, const BuyPremiumScreen())), Expanded(child: Text(t.appName, textAlign: TextAlign.center, style: AppTextStyles.logo.copyWith(color: c.textPrimary))), const SizedBox(width: 48)]),
      const Spacer(flex: 2),
      Text('${_greeting(t)},', style: AppTextStyles.heading3.copyWith(color: c.textSecondary)),
      const SizedBox(height: 4),
      Text(_userName, style: AppTextStyles.heading2.copyWith(color: c.textPrimary)),
      const Spacer(flex: 1),
      PrimaryButton(label: t.startWorkout, width: double.infinity, height: 64, onPressed: () => goTo(context, const ExercisesChoiceScreen())),
      const Spacer(flex: 2),
    ]))));
  }
}