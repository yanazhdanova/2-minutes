import 'package:flutter/material.dart';
import '../app/app_theme.dart';
import '../app/l10n/app_localizations.dart';
import 'widgets.dart';

/// Полноэкранный overlay-туториал с иконкой, заголовком, описанием и кнопкой.
/// Показывается поверх текущего экрана при первом визите пользователя.
/// Затемняет фон и отображает карточку с информацией по центру.
class TutorialOverlay extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onDismiss;

  const TutorialOverlay({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: c.background,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: c.accentSurface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(icon, color: c.accentLight, size: 36),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading3.copyWith(
                        color: c.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      body,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.textSecondary,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: t.tutorialGotIt,
                      width: double.infinity,
                      onPressed: onDismiss,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
