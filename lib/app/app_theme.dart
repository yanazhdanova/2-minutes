import 'package:flutter/material.dart';

/// Варианты акцентного цвета приложения: зелёный (по умолчанию) и розовый. Используется в ResolvedColors для выбора палитры.
enum AccentColor { green, pink }

/// Набор из 12 цветов, полностью определяющих визуальную палитру приложения
/// для конкретной комбинации темы (светлая/тёмная) и акцента (green/pink).
/// Включает цвета фонов, поверхностей, текста трёх уровней, акцента в трёх
/// вариантах (основной, светлый, поверхностный), ошибки и белый.
/// Создаётся через фабрику [ResolvedColors.from] и передаётся вниз через [AppColorsProvider].
class ResolvedColors {
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color accent;
  final Color accentLight;
  final Color accentSurface;
  final Color error;
  final Color white;

  const ResolvedColors({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.accent,
    required this.accentLight,
    required this.accentSurface,
    required this.error,
    required this.white,
  });

  /// Фабрика, создающая палитру из 12 цветов на основе темы и акцента.
  /// Поддерживает 4 комбинации: dark+green, dark+pink, light+green, light+pink.
  /// Каждая комбинация содержит вручную подобранные hex-цвета для обеспечения
  /// достаточного контраста и визуальной гармонии.
  /// @param isDark true для тёмной темы, false для светлой.
  /// @param accentColor Акцентный цвет (green или pink).
  /// @return Экземпляр ResolvedColors с 12 цветами.
  factory ResolvedColors.from({
    required bool isDark,
    required AccentColor accentColor,
  }) {
    if (isDark) {
      switch (accentColor) {
        case AccentColor.green:
          return const ResolvedColors(
            background: Color(0xFF1A1A1E),
            surface: Color(0xFF26262C),
            surfaceLight: Color(0xFF2E2E36),
            border: Color(0xFF3C3C44),
            textPrimary: Color(0xFFEDE5D8),
            textSecondary: Color(0xFF9E968C),
            textHint: Color(0xFF6B6560),
            accent: Color(0xFF5BAF8A),
            accentLight: Color(0xFF6DC49D),
            accentSurface: Color(0xFF1E3A2D),
            error: Color(0xFFE06B6B),
            white: Color(0xFFFFFFFF),
          );
        case AccentColor.pink:
          return const ResolvedColors(
            background: Color(0xFF1C1A1C),
            surface: Color(0xFF282628),
            surfaceLight: Color(0xFF302E30),
            border: Color(0xFF3E3A3C),
            textPrimary: Color(0xFFEDE5DC),
            textSecondary: Color(0xFFA0968F),
            textHint: Color(0xFF6D6560),
            accent: Color(0xFFA85A68),
            accentLight: Color(0xFFE4A3AB),
            accentSurface: Color(0xFF322025),
            error: Color(0xFFE06B6B),
            white: Color(0xFFFFFFFF),
          );
      }
    } else {
      switch (accentColor) {
        case AccentColor.green:
          return const ResolvedColors(
            background: Color(0xFFFAF3E8),
            surface: Color(0xFFEDE5D8),
            surfaceLight: Color(0xFFF5EEE3),
            border: Color(0xFFD9CFBF),
            textPrimary: Color(0xFF3D3229),
            textSecondary: Color(0xFF7A6F63),
            textHint: Color(0xFFA89F94),
            accent: Color(0xFF2D5A45),
            accentLight: Color(0xFF3D7A5C),
            accentSurface: Color(0xFFD4E5DC),
            error: Color(0xFFB54A4A),
            white: Color(0xFFFFFFFF),
          );
        case AccentColor.pink:
          return const ResolvedColors(
            background: Color(0xFFFBF3F0),
            surface: Color(0xFFF0E5E1),
            surfaceLight: Color(0xFFF6EDEA),
            border: Color(0xFFDDD0CC),
            textPrimary: Color(0xFF3D2E2E),
            textSecondary: Color(0xFF7A6B68),
            textHint: Color(0xFFA89894),
            accent: Color(0xFFC9707F),
            accentLight: Color(0xFFD98C96),
            accentSurface: Color(0xFFF7E4E4),
            error: Color(0xFFB54A4A),
            white: Color(0xFFFFFFFF),
          );
      }
    }
  }
}

/// InheritedWidget для передачи [ResolvedColors] вниз по дереву виджетов.
/// Размещается в MaterialApp.builder, чтобы иметь доступ к реальной яркости
/// после применения themeMode. Всегда уведомляет зависимых при обновлении,
/// так как сравнение 12 полей дороже пересборки.
class AppColorsProvider extends InheritedWidget {
  final ResolvedColors colors;

  const AppColorsProvider({
    super.key,
    required this.colors,
    required super.child,
  });

  /// Получает [ResolvedColors] из ближайшего [AppColorsProvider] и подписывает виджет на обновления.
  /// @param context BuildContext вызывающего виджета.
  /// @return Текущая палитра цветов.
  /// @throws AssertionError если AppColorsProvider не найден.
  static ResolvedColors of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<AppColorsProvider>();
    assert(p != null, 'AppColorsProvider not found');
    return p!.colors;
  }

  @override
  bool updateShouldNotify(AppColorsProvider old) => true;
}

/// Сокращение для [AppColorsProvider.of] - быстрый доступ к цветам через C(context).
ResolvedColors C(BuildContext context) => AppColorsProvider.of(context);

/// Типографика приложения. Содержит все текстовые стили:
/// heading1 (44px) - основные заголовки экранов,
/// heading2 (32px) - подзаголовки и заголовки разделов,
/// heading3 (26px) - крупный текст в карточках,
/// body (16px) - основной текст,
/// bodyLarge (18px) - акцентированный текст списков,
/// bodySmall (14px) - второстепенный текст и описания,
/// button (16px) - текст обычных кнопок,
/// buttonLarge (18px) - текст крупных CTA-кнопок,
/// label (14px) - метки полей и секций,
/// logo (20px) - текст логотипа «2 минуты».
/// Цвет не задан - применяется через copyWith(color:) на месте использования.
class AppTextStyles {
  AppTextStyles._();
  static const heading1 = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  static const heading2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  static const heading3 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const logo = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
}

/// Стандартные радиусы скругления элементов:
/// small (12) - внутренние элементы, чекбоксы;
/// medium (16) - карточки, текстовые поля;
/// large (24) - крупные карточки;
/// extraLarge (28) - кнопки;
/// full (100) - полностью круглые элементы.
class AppRadius {
  AppRadius._();
  static const small = 12.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const extraLarge = 28.0;
  static const full = 100.0;
}

/// Стандартные отступы и интервалы. Шкала: xs(4), sm(8), md(12), lg(16), xl(20), xxl(24), xxxl(32).
/// screenHorizontal (28) - горизонтальные отступы экрана от краёв, используется во всех Scaffold.
class AppSpacing {
  AppSpacing._();
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const screenHorizontal = 28.0;
}

/// Создаёт полностью настроенную [ThemeData] для MaterialApp.
/// Конфигурирует: colorScheme, appBarTheme, bottomNavigationBarTheme,
/// elevatedButtonTheme, outlinedButtonTheme, textButtonTheme, inputDecorationTheme,
/// cardTheme, dividerTheme, progressIndicatorTheme и expansionTileTheme.
/// Все цвета берутся из [ResolvedColors], сгенерированной для данной комбинации isDark/accentColor.
/// Material3 включён. Elevation всех кнопок и карточек - 0 (flat-дизайн).
/// @param isDark true для тёмной темы, false для светлой.
/// @param accentColor Акцентный цвет (green или pink).
/// @return ThemeData, готовая для передачи в MaterialApp.theme или darkTheme.
ThemeData buildAppTheme({
  required bool isDark,
  required AccentColor accentColor,
}) {
  final c = ResolvedColors.from(isDark: isDark, accentColor: accentColor);

  return ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: c.background,
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: c.accent,
      onPrimary: c.white,
      secondary: c.surface,
      onSecondary: c.textPrimary,
      surface: c.background,
      onSurface: c.textPrimary,
      error: c.error,
      onError: c.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.logo.copyWith(color: c.textPrimary),
      iconTheme: IconThemeData(color: c.textPrimary),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: c.background,
      selectedItemColor: c.accentLight,
      unselectedItemColor: c.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: c.accent,
        foregroundColor: c.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.accentLight,
        side: BorderSide(color: c.accentLight, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.accentLight,
        textStyle: AppTextStyles.button,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: c.accentLight, width: 1.5),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: TextStyle(color: c.textHint, fontSize: 16),
    ),

    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),

    dividerTheme: DividerThemeData(color: c.border, thickness: 1),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accentLight),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: c.surface,
      collapsedBackgroundColor: c.surface,
      iconColor: c.textSecondary,
      collapsedIconColor: c.textSecondary,
      textColor: c.textPrimary,
      collapsedTextColor: c.textPrimary,
    ),
  );
}
