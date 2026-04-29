import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/app_scope.dart';
import '../../app/locale_controller.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';

/// Экран выбора языка приложения. Два варианта: русский и английский.
/// Каждый отображается как карточка (_Opt) с локализованным и нативным названием.
/// Текущий язык определяется через LocaleController.of(context).locale.languageCode.
/// При тапе - вызывает ctrl.setLocale(), что пересобирает MaterialApp с новой локалью.
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final ctrl = LocaleController.of(context);
    final code = ctrl.locale.languageCode;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),
              const SizedBox(height: 16),
              Text(
                t.langTitle,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 32),
              _Opt(
                title: t.langRussian,
                sub: 'Русский',
                sel: code == 'ru',
                onTap: () { ctrl.setLocale(const Locale('ru')); AppScope.of(context).userData.setLanguageCode('ru'); },
              ),
              const SizedBox(height: 12),
              _Opt(
                title: t.langEnglish,
                sub: 'English',
                sel: code == 'en',
                onTap: () { ctrl.setLocale(const Locale('en')); AppScope.of(context).userData.setLanguageCode('en'); },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Элемент выбора языка: заголовок (локализованный), подзаголовок (нативное название), индикатор check_circle/circle_outlined. При sel=true - акцентная подсветка.
class _Opt extends StatelessWidget {
  final String title;
  final String sub;
  final bool sel;
  final VoidCallback onTap;
  const _Opt({
    required this.title,
    required this.sub,
    required this.sel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: sel ? c.accentSurface : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: sel ? Border.all(color: c.accentLight, width: 1.5) : null,
        ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: sel ? c.accentLight : c.textPrimary,
                    ),
                  ),
                  if (title != sub) ...[
                    const SizedBox(height: 4),
                    Text(
                      sub,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            sel
                ? Icon(Icons.check_circle, color: c.accentLight, size: 24)
                : Icon(Icons.circle_outlined, color: c.border, size: 24),
          ],
        ),
      ),
    );
  }
}
