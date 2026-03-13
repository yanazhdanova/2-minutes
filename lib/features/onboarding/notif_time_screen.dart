import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import 'notif_freq_screen.dart';

class NotifTimeScreen extends StatefulWidget {
  const NotifTimeScreen({super.key});

  @override
  State<NotifTimeScreen> createState() => _NotifTimeScreenState();
}

class _NotifTimeScreenState extends State<NotifTimeScreen> {
  DateTime _fromTime = DateTime(2024, 1, 1, 9, 0);
  DateTime _toTime = DateTime(2024, 1, 1, 21, 0);

  void _showFromPicker() {
    _showTimePicker(
      initialTime: _fromTime,
      onChanged: (time) => setState(() => _fromTime = time),
    );
  }

  void _showToPicker() {
    _showTimePicker(
      initialTime: _toTime,
      onChanged: (time) => setState(() => _toTime = time),
    );
  }

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
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Кнопки отмена/готово
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Отмена'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Готово'),
                      onPressed: () {
                        onChanged(tempTime);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              // Пикер
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialTime,
                  use24hFormat: true,
                  minuteInterval: 5,
                  onDateTimeChanged: (time) => tempTime = time,
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
      appBar: AppBar(
        title: const Text('Время уведомлений'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            const Text(
              'В какое время напоминать о тренировке?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // От - До
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // От
                Column(
                  children: [
                    Text(
                      'От',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _showFromPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatTime(_fromTime),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 24),

                const Text(
                  '—',
                  style: TextStyle(fontSize: 24),
                ),

                const SizedBox(width: 24),

                // До
                Column(
                  children: [
                    Text(
                      'До',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _showToPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatTime(_toTime),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),

            // Кнопка "Далее"
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Далее',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}