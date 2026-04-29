import 'package:flutter/material.dart';
import '../app/app_theme.dart';

/// Универсальный хедер приложения, используемый на всех экранах.
/// По центру отображает логотип «2 минуты» стилем AppTextStyles.logo.
/// Левая и правая зоны шириной 48 px обеспечивают симметрию:
/// - Если задан [onBack] - слева отображается IconButton со стрелкой назад.
/// - Иначе, если задан [leading] - слева показывается произвольный виджет.
/// - Иначе - слева пустой SizedBox(width: 48) для сохранения отступа.
/// - Справа аналогично: [trailing] или пустой SizedBox(width: 48).
/// Сверху добавляется отступ 18 px (Padding.top) для визуального отделения от SafeArea.
/// @param onBack коллбэк кнопки «назад»; при null кнопка не показывается.
/// @param leading виджет слева вместо кнопки назад (игнорируется, если onBack != null).
/// @param trailing виджет справа (например, PremiumIcon).
class AppHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final Widget? leading;
  final Widget? trailing;
  const AppHeader({super.key, this.onBack, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: Icon(Icons.arrow_back, color: c.textPrimary),
              onPressed: onBack,
            )
          else if (leading != null)
            leading!
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              '2 минуты',
              textAlign: TextAlign.center,
              style: AppTextStyles.logo.copyWith(color: c.textPrimary),
            ),
          ),
          if (trailing != null) trailing! else const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// Основная кнопка действия (CTA). Фон - акцентный цвет (c.accent), текст - белый.
/// Используется для главных действий: «Купить», «Сохранить», «Продолжить», «Начать».
/// При [isLoading] = true кнопка становится disabled (onPressed игнорируется),
/// а вместо текста показывается белый CircularProgressIndicator (24×24, strokeWidth: 2).
/// При disabled - фон полупрозрачный (accent.withOpacity(0.5)).
/// Скругление - AppRadius.extraLarge, elevation: 0 (плоский стиль).
/// @param label текст кнопки, отображается стилем AppTextStyles.buttonLarge.
/// @param onPressed коллбэк нажатия; null делает кнопку disabled.
/// @param width ширина кнопки; null - авторазмер, double.infinity - на всю ширину.
/// @param height высота кнопки, по умолчанию 56 px.
/// @param isLoading при true - блокирует нажатие и показывает спиннер.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final bool isLoading;
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 56,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.white,
          disabledBackgroundColor: c.accent.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          ),
        ),

        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: c.white,
                ),
              )
            : Text(
                label,
                style: AppTextStyles.buttonLarge.copyWith(color: c.white),
              ),
      ),
    );
  }
}

/// Вторичная кнопка действия. Фон - c.surface (нейтральный), текст - c.textPrimary.
/// Используется для альтернативных действий рядом с PrimaryButton,
/// например «Пропустить» или «Отмена». Не имеет состояния загрузки.
/// Скругление - AppRadius.extraLarge, elevation: 0.
/// @param label текст кнопки, отображается стилем AppTextStyles.buttonLarge.
/// @param onPressed коллбэк нажатия; null делает кнопку disabled.
/// @param width ширина кнопки; null - авторазмер.
/// @param height высота кнопки, по умолчанию 56 px.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: c.surface,
          foregroundColor: c.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonLarge.copyWith(color: c.textPrimary),
        ),
      ),
    );
  }
}

/// Кнопка с контурной обводкой без заливки фона. Рамка и текст - c.accentLight,
/// ширина обводки 1.5 px. Используется для третичных действий или стилистического
/// разнообразия, например на экране завершения тренировки.
/// Скругление - AppRadius.extraLarge.
/// @param label текст кнопки, отображается стилем AppTextStyles.buttonLarge.
/// @param onPressed коллбэк нажатия; null делает кнопку disabled.
/// @param width ширина кнопки; null - авторазмер.
/// @param height высота кнопки, по умолчанию 56 px.
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  const OutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return SizedBox(
      width: width,
      height: height,

      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: c.accentLight,
          side: BorderSide(color: c.accentLight, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          ),
        ),

        child: Text(
          label,
          style: AppTextStyles.buttonLarge.copyWith(color: c.accentLight),
        ),
      ),
    );
  }
}

/// Стилизованное текстовое поле ввода, используемое на экранах авторизации и онбординга.
/// В обычном состоянии: заливка c.surface, без рамки (borderSide: none).
/// При фокусе: появляется рамка c.accentLight шириной 1.5 px.
/// Скругление - AppRadius.medium. Отступы контента: 20 px по горизонтали, 16 px по вертикали.
/// Текст ввода - стиль AppTextStyles.body цвета c.textPrimary.
/// @param controller контроллер текста; при null создаётся внутренний.
/// @param hintText подсказка, отображаемая при пустом поле.
/// @param obscureText скрытие текста (для паролей), по умолчанию false.
/// @param keyboardType тип клавиатуры (email, number и т.д.).
/// @param textAlign выравнивание текста, по умолчанию TextAlign.start.
/// @param textCapitalization режим капитализации, по умолчанию none.
/// @param autofocus автоматический фокус при появлении виджета, по умолчанию false.
/// @param onChanged коллбэк при изменении текста.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      onChanged: onChanged,
      style: AppTextStyles.body.copyWith(color: c.textPrimary),

      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: c.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: c.accentLight, width: 1.5),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}

/// Иконка премиум-подписки для размещения в trailing-зоне AppHeader.
/// Представляет собой контейнер 48×48 px с заливкой c.accentSurface и скруглением 14 px,
/// внутри - иконка Icons.workspace_premium (26 px) цвета c.accentLight.
/// При тапе вызывает [onTap], обычно - навигация на BuyPremiumScreen.
/// Используется на HomeMainScreen для быстрого доступа к экрану покупки.
/// @param onTap коллбэк нажатия; при null иконка не реагирует на тапы.
class PremiumIcon extends StatelessWidget {
  final VoidCallback? onTap;
  const PremiumIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: c.accentSurface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.workspace_premium, color: c.accentLight, size: 26),
      ),
    );
  }
}
