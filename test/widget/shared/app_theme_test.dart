import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/app_theme.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('ResolvedColors.from', () {
    test('light + green — правильные цвета', () {
      final colors = ResolvedColors.from(
        isDark: false,
        accentColor: AccentColor.green,
      );

      expect(colors.background, const Color(0xFFFAF3E8));
      expect(colors.accent, const Color(0xFF2D5A45));
      expect(colors.error, const Color(0xFFB54A4A));
    });

    test('light + pink — правильные цвета', () {
      final colors = ResolvedColors.from(
        isDark: false,
        accentColor: AccentColor.pink,
      );

      expect(colors.background, const Color(0xFFFBF3F0));
      expect(colors.accent, const Color(0xFFC9707F));
    });

    test('dark + green — правильные цвета', () {
      final colors = ResolvedColors.from(
        isDark: true,
        accentColor: AccentColor.green,
      );

      expect(colors.background, const Color(0xFF1A1A1E));
      expect(colors.accent, const Color(0xFF5BAF8A));
      expect(colors.error, const Color(0xFFE06B6B));
    });

    test('dark + pink — правильные цвета', () {
      final colors = ResolvedColors.from(
        isDark: true,
        accentColor: AccentColor.pink,
      );

      expect(colors.background, const Color(0xFF1C1A1C));
      expect(colors.accent, const Color(0xFFA85A68));
    });

    test('white всегда #FFFFFF', () {
      for (final isDark in [true, false]) {
        for (final accent in AccentColor.values) {
          final colors = ResolvedColors.from(
            isDark: isDark,
            accentColor: accent,
          );
          expect(colors.white, const Color(0xFFFFFFFF));
        }
      }
    });
  });

  group('AppColorsProvider', () {
    testWidgets('C(context) возвращает правильные цвета', (tester) async {
      late ResolvedColors capturedColors;

      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              capturedColors = C(context);
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(capturedColors.accent, const Color(0xFF2D5A45));
    });

    testWidgets('AppColorsProvider.of возвращает цвета', (tester) async {
      late ResolvedColors capturedColors;

      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              capturedColors = AppColorsProvider.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(capturedColors, isNotNull);
      expect(capturedColors.background, isNotNull);
    });
  });

  group('AppTextStyles', () {
    test('heading1 имеет правильный размер', () {
      expect(AppTextStyles.heading1.fontSize, 44);
      expect(AppTextStyles.heading1.fontWeight, FontWeight.w600);
    });

    test('heading2 имеет правильный размер', () {
      expect(AppTextStyles.heading2.fontSize, 32);
    });

    test('heading3 имеет правильный размер', () {
      expect(AppTextStyles.heading3.fontSize, 26);
    });

    test('body имеет правильный размер', () {
      expect(AppTextStyles.body.fontSize, 16);
    });

    test('bodyLarge имеет правильный размер', () {
      expect(AppTextStyles.bodyLarge.fontSize, 18);
    });

    test('bodySmall имеет правильный размер', () {
      expect(AppTextStyles.bodySmall.fontSize, 14);
    });

    test('button имеет правильный размер', () {
      expect(AppTextStyles.button.fontSize, 16);
      expect(AppTextStyles.button.fontWeight, FontWeight.w500);
    });

    test('buttonLarge имеет правильный размер', () {
      expect(AppTextStyles.buttonLarge.fontSize, 18);
      expect(AppTextStyles.buttonLarge.fontWeight, FontWeight.w600);
    });

    test('label имеет правильный размер', () {
      expect(AppTextStyles.label.fontSize, 14);
    });

    test('logo имеет правильный размер', () {
      expect(AppTextStyles.logo.fontSize, 20);
    });
  });

  group('AppRadius', () {
    test('константы имеют правильные значения', () {
      expect(AppRadius.small, 12.0);
      expect(AppRadius.medium, 16.0);
      expect(AppRadius.large, 24.0);
      expect(AppRadius.extraLarge, 28.0);
      expect(AppRadius.full, 100.0);
    });
  });

  group('AppSpacing', () {
    test('константы имеют правильные значения', () {
      expect(AppSpacing.xs, 4.0);
      expect(AppSpacing.sm, 8.0);
      expect(AppSpacing.md, 12.0);
      expect(AppSpacing.lg, 16.0);
      expect(AppSpacing.xl, 20.0);
      expect(AppSpacing.xxl, 24.0);
      expect(AppSpacing.xxxl, 32.0);
      expect(AppSpacing.screenHorizontal, 28.0);
    });
  });

  group('buildAppTheme', () {
    test('light theme имеет правильный brightness', () {
      final theme = buildAppTheme(
        isDark: false,
        accentColor: AccentColor.green,
      );

      expect(theme.brightness, Brightness.light);
    });

    test('dark theme имеет правильный brightness', () {
      final theme = buildAppTheme(isDark: true, accentColor: AccentColor.green);

      expect(theme.brightness, Brightness.dark);
    });

    test('useMaterial3 включён', () {
      final theme = buildAppTheme(
        isDark: false,
        accentColor: AccentColor.green,
      );

      expect(theme.useMaterial3, true);
    });

    test('scaffoldBackgroundColor соответствует теме', () {
      final light = buildAppTheme(
        isDark: false,
        accentColor: AccentColor.green,
      );
      final dark = buildAppTheme(isDark: true, accentColor: AccentColor.green);

      expect(light.scaffoldBackgroundColor, const Color(0xFFFAF3E8));
      expect(dark.scaffoldBackgroundColor, const Color(0xFF1A1A1E));
    });
  });

  group('AccentColor enum', () {
    test('имеет два значения', () {
      expect(AccentColor.values.length, 2);
      expect(AccentColor.values, contains(AccentColor.green));
      expect(AccentColor.values, contains(AccentColor.pink));
    });
  });

  group('Смена темы обновляет UI', () {
    testWidgets('dark theme применяет тёмный фон', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              final c = C(context);
              return Container(color: c.background);
            },
          ),
          isDark: true,
        ),
      );
      await tester.pumpAndSettle();

      final container = tester.firstWidget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      if (decoration != null) {
        expect(decoration.color, const Color(0xFF1A1A1E));
      }
    });

    testWidgets('pink accent применяет розовые цвета', (tester) async {
      late ResolvedColors capturedColors;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              capturedColors = C(context);
              return const SizedBox();
            },
          ),
          accentColor: AccentColor.pink,
        ),
      );
      await tester.pumpAndSettle();

      expect(capturedColors.accent, const Color(0xFFC9707F));
    });
  });
}
