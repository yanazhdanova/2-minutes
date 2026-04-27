import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/app_theme.dart';

/** Edge cases для темы и цветов. */
void main() {
  group('ResolvedColors — edge cases', () {
    test('все 4 комбинации тем создаются без ошибок', () {
      for (final isDark in [false, true]) {
        for (final accent in AccentColor.values) {
          final colors = ResolvedColors.from(
            isDark: isDark,
            accentColor: accent,
          );
          expect(colors.background, isNotNull);
          expect(colors.surface, isNotNull);
          expect(colors.accent, isNotNull);
          expect(colors.accentLight, isNotNull);
          expect(colors.textPrimary, isNotNull);
          expect(colors.textSecondary, isNotNull);
        }
      }
    });

    test('светлая и тёмная тема имеют разные фоны', () {
      final light = ResolvedColors.from(
        isDark: false,
        accentColor: AccentColor.green,
      );
      final dark = ResolvedColors.from(
        isDark: true,
        accentColor: AccentColor.green,
      );
      expect(light.background, isNot(dark.background));
    });

    test('green и pink акценты имеют разные цвета', () {
      final green = ResolvedColors.from(
        isDark: false,
        accentColor: AccentColor.green,
      );
      final pink = ResolvedColors.from(
        isDark: false,
        accentColor: AccentColor.pink,
      );
      expect(green.accent, isNot(pink.accent));
    });
  });

  group('AccentColor — edge cases', () {
    test('enum values содержит green и pink', () {
      expect(AccentColor.values.length, 2);
      expect(AccentColor.values, contains(AccentColor.green));
      expect(AccentColor.values, contains(AccentColor.pink));
    });
  });

  group('AppTextStyles — constants', () {
    test('все стили имеют ненулевые размеры', () {
      expect(AppTextStyles.heading1.fontSize, isNotNull);
      expect(AppTextStyles.heading2.fontSize, isNotNull);
      expect(AppTextStyles.heading3.fontSize, isNotNull);
      expect(AppTextStyles.body.fontSize, isNotNull);
      expect(AppTextStyles.bodyLarge.fontSize, isNotNull);
      expect(AppTextStyles.bodySmall.fontSize, isNotNull);
      expect(AppTextStyles.button.fontSize, isNotNull);
      expect(AppTextStyles.label.fontSize, isNotNull);
    });
  });

  group('AppSpacing и AppRadius — constants', () {
    test('screenHorizontal > 0', () {
      expect(AppSpacing.screenHorizontal, greaterThan(0));
    });

    test('радиусы > 0', () {
      expect(AppRadius.small, greaterThan(0));
      expect(AppRadius.medium, greaterThan(0));
      expect(AppRadius.large, greaterThan(0));
    });
  });
}
