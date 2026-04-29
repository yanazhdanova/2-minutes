import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../../app/app_scope.dart';
import 'final_screen.dart';

/// Четвёртый экран онбординга - настройка частоты уведомлений и выбор дней недели.
/// Частота выбирается через CupertinoPicker (часы + минуты) в bottom sheet,
/// минимум 5 минут. Дни недели - 7 тоглящихся кнопок (минимум 1 день).
/// По умолчанию: 1 час, все 7 дней. При нажатии «Далее» сохраняет через
/// PrefsService (notifFreq в минутах, notifDays как список) и переходит на FinalScreen.
class NotifFreqScreen extends StatefulWidget {
  const NotifFreqScreen({super.key});
  @override
  State<NotifFreqScreen> createState() => _NotifFreqScreenState();
}

class _NotifFreqScreenState extends State<NotifFreqScreen> {
  int _hours = 1;
  int _minutes = 0;
  final Set<int> _days = {1, 2, 3, 4, 5, 6, 7};

  int get _totalMinutes => _hours * 60 + _minutes;

  String _formatInterval(Tr t) {
    if (_hours > 0 && _minutes > 0) {
      return '$_hours ${t.hoursShort} $_minutes ${t.minutesShort}';
    }
    if (_hours > 0) return '$_hours ${t.hoursShort}';
    return '$_minutes ${t.minutesShort}';
  }

  void _showPicker() {
    final c = C(context);
    final t = Tr.of(context);
    int tempH = _hours;
    int tempM = _minutes;

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
                          if (total < 5) {
                            tempH = 0;
                            tempM = 5;
                          }
                          setState(() {
                            _hours = tempH;
                            _minutes = tempM;
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
        if (_days.length > 1) _days.remove(day); // минимум 1 день
      } else {
        _days.add(day);
      }
    });
  }

  Future<void> _next() async {
    final scope = AppScope.of(context);
    final sortedDays = _days.toList()..sort();
    scope.userData.setNotifFreq('$_totalMinutes');
    scope.userData.setNotifDays(sortedDays);
    await scope.prefs.setNotifFreq('$_totalMinutes');
    await scope.prefs.setNotifDays(sortedDays);
    if (mounted) goTo(context, const FinalScreen());
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
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),
              const Spacer(flex: 2),

              Text(
                t.notifFreqTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 40),

              Text(
                t.everyLabel,
                style: AppTextStyles.label.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _showPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: c.accentSurface,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(color: c.accentLight, width: 1.5),
                  ),
                  child: Text(
                    _formatInterval(t),
                    style: AppTextStyles.heading3.copyWith(
                      color: c.accentLight,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Text(
                t.tapToChange,
                style: AppTextStyles.bodySmall.copyWith(color: c.textHint),
              ),

              const SizedBox(height: 36),

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

              const Spacer(flex: 3),
              OutlineButton(label: t.next, width: 260, onPressed: _next),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
