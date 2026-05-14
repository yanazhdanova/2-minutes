import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_theme.dart';
import '../app/l10n/app_localizations.dart';
import '../app/locale_controller.dart';

class LanguagePickerButton extends StatelessWidget {
  const LanguagePickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final code = LocaleController.of(context).locale.languageCode.toUpperCase();
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        tooltip: t.settingsLang,
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: c.textPrimary, size: 20),
            const SizedBox(height: 1),
            Text(
              code,
              style: AppTextStyles.label.copyWith(
                color: c.textPrimary,
                fontSize: 10,
                height: 1,
              ),
            ),
          ],
        ),
        onPressed: () => _showLanguagePicker(context),
      ),
    );
  }
}

void _showLanguagePicker(BuildContext context) {
  final c = C(context);
  final t = Tr.of(context);
  final currentCode = LocaleController.of(context).locale.languageCode;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),

      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.langTitle,
              style: AppTextStyles.bodyLarge.copyWith(color: c.textPrimary),
            ),

            const SizedBox(height: 12),
            _LanguageOption(
              title: t.langRussian,
              selected: currentCode == 'ru',
              onTap: () => _selectLanguage(context, sheetContext, 'ru'),
            ),

            const SizedBox(height: 8),
            _LanguageOption(
              title: t.langEnglish,
              selected: currentCode == 'en',
              onTap: () => _selectLanguage(context, sheetContext, 'en'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _selectLanguage(
  BuildContext context,
  BuildContext sheetContext,
  String code,
) async {
  Navigator.pop(sheetContext);
  final scope = AppScope.of(context);
  await LocaleController.of(context).setLocale(Locale(code));
  scope.userData.setLanguageCode(code);
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.selected,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? c.accentSurface : c.background,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: selected
              ? Border.all(color: c.accentLight, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: selected ? c.accentLight : c.textPrimary,
                ),
              ),
            ),

            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? c.accentLight : c.border,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
