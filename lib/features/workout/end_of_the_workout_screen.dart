import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/main_tab_screen.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';

class EndOfTheWorkoutScreen extends StatelessWidget {
  const EndOfTheWorkoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),

          child: Column(
            children: [
              const SizedBox(height: 18),
              Text(
                t.appName,
                style: AppTextStyles.logo.copyWith(color: c.textPrimary),
              ),

              const Spacer(flex: 3),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: c.accentSurface,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(Icons.check_circle, color: c.accentLight, size: 56),
              ),

              const SizedBox(height: 40),
              Text(
                t.workoutDoneTitle,
                style: AppTextStyles.heading1.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 16),
              Text(
                t.workoutDoneSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: c.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),
              PrimaryButton(
                label: t.goHome,
                width: double.infinity,
                height: 64,
                onPressed: () => goToAndClear(context, const MainTabScreen()),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
