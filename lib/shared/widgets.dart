import 'package:flutter/material.dart';
import '../app/app_theme.dart';

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
          disabledBackgroundColor: c.accent.withOpacity(0.5),
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
