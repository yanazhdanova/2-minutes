import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'notif_freq_screen.dart';

/**
Третий экран онбординга - выбор временного диапазона уведомлений.
Показывает два блока «От» и «До» с текущим временем; по тапу открывается
CupertinoDatePicker в модальном bottom sheet (режим time, 24h формат, шаг 5 мин).
По умолчанию: 09:00–21:00. При нажатии «Далее» сохраняет через
UserPreferences.setNotifTimeRange() и переходит на NotifFreqScreen.
*/
class NotifTimeScreen extends StatefulWidget {
  const NotifTimeScreen({super.key});
  @override
  State<NotifTimeScreen> createState() => _NotifTimeScreenState();
}

class _NotifTimeScreenState extends State<NotifTimeScreen> {
  DateTime _fromTime = DateTime(0, 1, 1, 9, 0);
  DateTime _toTime = DateTime(0, 1, 1, 21, 0);

  void _showPicker({
    required DateTime initial,
    required ValueChanged<DateTime> onChanged,
  }) {
    final c = C(context);
    final t = Tr.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        DateTime temp = initial;
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                        onChanged(temp);
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
                    initialDateTime: initial,
                    use24hFormat: true,
                    minuteInterval: 5,
                    onDateTimeChanged: (t) => temp = t,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _next() async {
    await UserPreferences.setNotifTimeRange(
      fromHour: _fromTime.hour,
      fromMinute: _fromTime.minute,
      toHour: _toTime.hour,
      toMinute: _toTime.minute,
    );
    if (mounted) goTo(context, const NotifFreqScreen());
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
              AppHeader(onBack: () => Navigator.pop(context)),
              const Spacer(flex: 2),
              Text(
                t.notifTimeTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: c.textPrimary),
              ),

              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        t.notifFrom,
                        style: AppTextStyles.label.copyWith(
                          color: c.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _showPicker(
                          initial: _fromTime,
                          onChanged: (v) => setState(() => _fromTime = v),
                        ),

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                          ),

                          child: Text(
                            _fmt(_fromTime),
                            style: AppTextStyles.heading3.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '—',
                      style: AppTextStyles.heading3.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      Text(
                        t.notifTo,
                        style: AppTextStyles.label.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _showPicker(
                          initial: _toTime,
                          onChanged: (v) => setState(() => _toTime = v),
                        ),

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),

                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                          ),

                          child: Text(
                            _fmt(_toTime),
                            style: AppTextStyles.heading3.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
