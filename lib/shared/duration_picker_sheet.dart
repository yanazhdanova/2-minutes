import 'package:flutter/material.dart';
import '../app/app_theme.dart';
import '../app/l10n/app_localizations.dart';
import 'widgets.dart';

const int _minSec = 20;
const int _maxSec = 180;
const int _stepSec = 10;

/// Показывает modal bottom sheet с слайдером выбора длительности упражнения
/// в диапазоне 20–180 секунд с шагом 10. Возвращает выбранное значение
/// или null, если пользователь закрыл лист без сохранения.
Future<int?> showDurationPickerSheet(
  BuildContext context, {
  required int initial,
}) {
  final clamped = initial.clamp(_minSec, _maxSec);
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DurationPickerSheet(initial: clamped),
  );
}

class _DurationPickerSheet extends StatefulWidget {
  final int initial;
  const _DurationPickerSheet({required this.initial});
  @override
  State<_DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<_DurationPickerSheet> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = _snap(widget.initial);
  }

  int _snap(int v) {
    final stepped = (v / _stepSec).round() * _stepSec;
    return stepped.clamp(_minSec, _maxSec);
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.large),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.durationPickerTitle,
              style: AppTextStyles.heading3.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: 24),
            Text(
              t.durationSec(_value),
              style: AppTextStyles.heading2.copyWith(color: c.accentLight),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: c.accent,
                inactiveTrackColor: c.border,
                thumbColor: c.accent,
                overlayColor: c.accent.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _value.toDouble(),
                min: _minSec.toDouble(),
                max: _maxSec.toDouble(),
                divisions: (_maxSec - _minSec) ~/ _stepSec,
                label: '${_value}s',
                onChanged: (v) => setState(() => _value = _snap(v.round())),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: t.save,
              width: double.infinity,
              onPressed: () => Navigator.pop(context, _value),
            ),
          ],
        ),
      ),
    );
  }
}
