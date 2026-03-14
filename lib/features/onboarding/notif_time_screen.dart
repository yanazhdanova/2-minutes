import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../shared/widgets.dart';
import 'notif_freq_screen.dart';

class NotifTimeScreen extends StatefulWidget {
  const NotifTimeScreen({super.key});

  @override
  State<NotifTimeScreen> createState() => _NotifTimeScreenState();
}

class _NotifTimeScreenState extends State<NotifTimeScreen> {
  DateTime _fromTime = DateTime(2024, 1, 1, 9, 0);
  DateTime _toTime = DateTime(2024, 1, 1, 21, 0);

  void _showTimePicker({
    required DateTime initialTime,
    required ValueChanged<DateTime> onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        DateTime tempTime = initialTime;
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.surface,
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
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Отмена',
                        style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onChanged(tempTime);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Готово',
                        style: AppTextStyles.button.copyWith(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: initialTime,
                    use24hFormat: true,
                    minuteInterval: 5,
                    onDateTimeChanged: (time) => tempTime = time,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _next() async {
    await UserPreferences.setNotifTimeRange(
      fromHour: _fromTime.hour,
      fromMinute: _fromTime.minute,
      toHour: _toTime.hour,
      toMinute: _toTime.minute,
    );

    if (mounted) {
      goTo(context, const NotifFreqScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              AppHeader(onBack: () => Navigator.pop(context)),

              const Spacer(flex: 2),

              Text(
                'В какое время\nнапоминать о\nтренировке?',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 48),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('От', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _showTimePicker(
                          initialTime: _fromTime,
                          onChanged: (time) => setState(() => _fromTime = time),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                          child: Text(
                            _formatTime(_fromTime),
                            style: AppTextStyles.heading3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('—', style: AppTextStyles.heading3),
                  ),
                  Column(
                    children: [
                      Text('До', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _showTimePicker(
                          initialTime: _toTime,
                          onChanged: (time) => setState(() => _toTime = time),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                          child: Text(
                            _formatTime(_toTime),
                            style: AppTextStyles.heading3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(flex: 3),

              OutlineButton(
                label: 'Далее',
                width: 260,
                onPressed: _next,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}