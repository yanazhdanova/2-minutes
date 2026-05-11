import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'categories_screen.dart';

/// Первый экран онбординга - ввод имени пользователя и выбор пола.
/// Содержит текстовое поле с автофокусом и капитализацией слов,
/// а также два варианта пола (мужской/женский) в горизонтальном ряду.
/// Кнопка «Далее» активируется только при непустом имени и выбранном поле.
/// При нажатии сохраняет данные через UserDataService и переходит на CategoriesScreen.
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});
  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _controller = TextEditingController();
  bool _isValid = false;
  String? _gender;

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

  bool get _canContinue => _isValid && _gender != null;

  Future<void> _continue() async {
    if (!_canContinue) return;
    final userData = AppScope.of(context).userData;
    await userData.setUserName(_controller.text.trim());
    userData.setGender(_gender!);
    if (mounted) goTo(context, const CategoriesScreen());
  }

  Widget _genderChip(String id, String label, ResolvedColors c) {
    final selected = _gender == id;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: () => setState(() => _gender = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? c.accentSurface : c.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: selected
                ? Border.all(color: c.accentLight, width: 1.5)
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: selected ? c.accentLight : c.textPrimary,
            ),
          ),
        ),
      ),
    );
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

              const SizedBox(height: 32),
              Row(
                children: [
                  _genderChip('male', t.genderMale, c),
                  const SizedBox(width: 12),
                  _genderChip('female', t.genderFemale, c),
                ],
              ),

              const Spacer(flex: 2),
              PrimaryButton(
                label: t.next,
                width: double.infinity,
                onPressed: _canContinue ? _continue : null,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
