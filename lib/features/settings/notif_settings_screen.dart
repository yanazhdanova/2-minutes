import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/data/notification_service.dart';

/**
Экран настроек уведомлений. Три секции:
1. Время - два блока «От» и «До» (_TimeBox), по тапу открывается CupertinoDatePicker.
2. Частота - блок с текстом «Каждые N ч M мин», по тапу открывается CupertinoPicker (часы + минуты).
3. Дни недели - 7 тоглящихся кнопок (минимум 1 день выбран).
Кнопка «Сохранить» появляется при изменениях (_changed). При сохранении: обновляет
PrefsService, перепланирует расписание через NotificationService.scheduleFromPrefs(),
показывает SnackBar «Сохранено». Начальные значения считываются из PrefsService в didChangeDependencies.
*/
class NotifSettingsScreen extends StatefulWidget {
  const NotifSettingsScreen({super.key});
  @override
  State<NotifSettingsScreen> createState() => _NotifSettingsScreenState();
}

class _NotifSettingsScreenState extends State<NotifSettingsScreen> {
  late String _from;
  late String _to;
  late int _freqMinutes;
  late Set<int> _days;
  bool _changed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final prefs = AppScope.of(context).prefs;
    _from = prefs.notifFrom;
    _to = prefs.notifTo;
    _freqMinutes = int.tryParse(prefs.notifFreq) ?? 60;
    _days = prefs.notifDays.toSet();
    if (_days.isEmpty) _days = {1, 2, 3, 4, 5, 6, 7};
  }

  int get _freqHours => _freqMinutes ~/ 60;
  int get _freqMins => _freqMinutes % 60;

  String _formatFreq(Tr t) {
    final h = _freqHours;
    final m = _freqMins;
    if (h > 0 && m > 0) return '$h ${t.hoursShort} $m ${t.minutesShort}';
    if (h > 0) return '$h ${t.hoursShort}';
    return '$m ${t.minutesShort}';
  }

  void _showTimePicker({
    required String initial,
    required ValueChanged<String> onChanged,
  }) {
    final c = C(context);
    final t = Tr.of(context);
    final parts = initial.split(':');
    DateTime temp = DateTime(
      2024,
      1,
      1,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      t.cancel,
                      style: AppTextStyles.button.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onChanged(
                        '${temp.hour.toString().padLeft(2, '0')}:${temp.minute.toString().padLeft(2, '0')}',
                      );
                      Navigator.pop(ctx);
                    },
                    child: Text(
                      t.done,
                      style: AppTextStyles.button.copyWith(
                        color: c.accentLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      fontSize: 22,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: temp,
                  use24hFormat: true,
                  minuteInterval: 5,
                  onDateTimeChanged: (v) => temp = v,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFreqPicker() {
    final c = C(context);
    final t = Tr.of(context);
    int tempH = _freqHours;
    int tempM = _freqMins;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) => Container(
            height: 320,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          t.cancel,
                          style: AppTextStyles.button.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          final total = tempH * 60 + tempM;
                          setState(() {
                            _freqMinutes = total < 5 ? 5 : total;
                            _changed = true;
                          });
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          t.done,
                          style: AppTextStyles.button.copyWith(
                            color: c.accentLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: tempH,
                          ),
                          itemExtent: 40,
                          onSelectedItemChanged: (i) {
                            tempH = i;
                            setModalState(() {});
                          },

                          children: List.generate(
                            13,
                            (i) => Center(
                              child: Text(
                                '$i ${t.hoursShort}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: c.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: tempH == 0
                                ? (tempM ~/ 5 - 1).clamp(0, 10)
                                : tempM ~/ 5,
                          ),
                          itemExtent: 40,
                          onSelectedItemChanged: (i) {
                            tempM = tempH == 0 ? (i + 1) * 5 : i * 5;
                            setModalState(() {});
                          },
                          children: tempH == 0
                              ? List.generate(
                                  11,
                                  (i) => Center(
                                    child: Text(
                                      '${(i + 1) * 5} ${t.minutesShort}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: c.textPrimary,
                                      ),
                                    ),
                                  ),
                                )
                              : List.generate(
                                  12,
                                  (i) => Center(
                                    child: Text(
                                      '${i * 5} ${t.minutesShort}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: c.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleDay(int day) {
    setState(() {
      if (_days.contains(day)) {
        if (_days.length > 1) _days.remove(day);
      } else {
        _days.add(day);
      }
      _changed = true;
    });
  }

  Future<void> _save() async {
    final prefs = AppScope.of(context).prefs;
    await prefs.setNotifFrom(_from);
    await prefs.setNotifTo(_to);
    await prefs.setNotifFreq('$_freqMinutes');
    await prefs.setNotifDays(_days.toList()..sort());

    await NotificationService.instance.scheduleFromPrefs(prefs);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Tr.of(context).savedMessage),
          backgroundColor: C(context).accent,
        ),
      );
      setState(() => _changed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final dayLabels = t.weekdaysShort;

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
                t.settingsNotif,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 32),

              Text(
                t.notifTimeSection,
                style: AppTextStyles.label.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _TimeBox(
                      label: t.notifFrom,
                      value: _from,
                      onTap: () => _showTimePicker(
                        initial: _from,
                        onChanged: (v) => setState(() {
                          _from = v;
                          _changed = true;
                        }),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '—',
                      style: AppTextStyles.heading3.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ),

                  Expanded(
                    child: _TimeBox(
                      label: t.notifTo,
                      value: _to,
                      onTap: () => _showTimePicker(
                        initial: _to,
                        onChanged: (v) => setState(() {
                          _to = v;
                          _changed = true;
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                t.notifFreqSection,
                style: AppTextStyles.label.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _showFreqPicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${t.everyLabel} ',
                        style: AppTextStyles.body.copyWith(
                          color: c.textSecondary,
                        ),
                      ),

                      Text(
                        _formatFreq(t),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: c.accentLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),
                      Icon(Icons.edit_outlined, color: c.textHint, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                t.notifDaysLabel,
                style: AppTextStyles.label.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final day = i + 1;
                  final sel = _days.contains(day);
                  return GestureDetector(
                    onTap: () => _toggleDay(day),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: sel ? c.accent : c.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dayLabels[i],
                        style: AppTextStyles.label.copyWith(
                          color: sel ? c.white : c.textSecondary,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(),

              if (_changed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: PrimaryButton(
                    label: t.save,
                    width: double.infinity,
                    onPressed: _save,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/** Виджет отображения времени: метка сверху (От/До) и значение HH:mm в контейнере. При тапе вызывает onTap для открытия пикера. */
class _TimeBox extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _TimeBox({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading3.copyWith(color: c.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
