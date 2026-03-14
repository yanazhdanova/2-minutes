import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../shared/widgets.dart';
import 'final_screen.dart';

class NotifFreqScreen extends StatefulWidget {
  const NotifFreqScreen({super.key});

  @override
  State<NotifFreqScreen> createState() => _NotifFreqScreenState();
}

class _NotifFreqScreenState extends State<NotifFreqScreen> {
  String _selected = '01:00';

  final _options = [
    ('00:30', 'Каждые 30 минут'),
    ('01:00', 'Каждый час'),
    ('02:00', 'Каждые 2 часа'),
    ('04:00', 'Каждые 4 часа'),
  ];

  Future<void> _next() async {
    await UserPreferences.setNotifFrequency(_selected);

    if (mounted) {
      goTo(context, const FinalScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),

              const Spacer(flex: 2),

              Text(
                'Как часто\nприсылать\nуведомления?',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 36),

              ...List.generate(_options.length, (i) {
                final opt = _options[i];
                final isSelected = _selected == opt.$1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    onTap: () => setState(() => _selected = opt.$1),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accentSurface : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: isSelected
                            ? Border.all(color: AppColors.accent, width: 1.5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt.$2,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.accent,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(flex: 3),

              OutlineButton(
                label: 'Далее',
                width: 260,
                onPressed: _next,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}