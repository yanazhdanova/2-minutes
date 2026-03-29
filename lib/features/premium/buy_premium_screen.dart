import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';

class BuyPremiumScreen extends StatelessWidget {
  const BuyPremiumScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = C(context); final t = Tr.of(context);
    return Scaffold(backgroundColor: c.background, body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal), child: Column(children: [
      AppHeader(onBack: () => Navigator.pop(context)),
      const Spacer(flex: 2),
      Container(width: 80, height: 80, decoration: BoxDecoration(color: c.accentSurface, borderRadius: BorderRadius.circular(20)),
          child: Icon(Icons.workspace_premium, color: c.accentLight, size: 44)),
      const SizedBox(height: 32),
      Text(t.premiumTitle, style: AppTextStyles.heading1.copyWith(color: c.textPrimary)),
      const SizedBox(height: 16),
      Text(t.premiumDescription, textAlign: TextAlign.center, style: AppTextStyles.body.copyWith(color: c.textSecondary, height: 1.5)),
      const SizedBox(height: 40),
      PrimaryButton(label: t.premiumBuy, width: double.infinity, height: 64, onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.premiumComingSoon), backgroundColor: c.accent));
      }),
      const Spacer(flex: 3),
    ]))));
  }
}