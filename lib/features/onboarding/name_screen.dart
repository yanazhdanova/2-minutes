import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'categories_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});
  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => setState(() => _isValid = _controller.text.trim().isNotEmpty),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    await UserPreferences.setName(name);
    if (mounted) goTo(context, const CategoriesScreen());
  }

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
              const AppHeader(),
              const Spacer(flex: 2),
              Text(
                t.nameTitle,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading3.copyWith(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: t.nameHint,
                  hintStyle: AppTextStyles.heading3.copyWith(color: c.textHint),
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
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                label: t.next,
                width: double.infinity,
                onPressed: _isValid ? _continue : null,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
