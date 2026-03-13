import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import 'final_screen.dart';

class NotifFreqScreen extends StatefulWidget {
  const NotifFreqScreen({super.key});

  @override
  State<NotifFreqScreen> createState() => _NotifFreqScreenState();
}

class _NotifFreqScreenState extends State<NotifFreqScreen> {
  String _selected = '01:00';

  final _options = ['00:30', '01:00', '02:00', '04:00'];

  Future<void> _next() async {
    await UserPreferences.setNotifFrequency(_selected);

    if (mounted) {
      goTo(context, const FinalScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '2 минуты',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const Spacer(flex: 2),

              const Text(
                'Как часто\nприсылать\nуведомления',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 32),

              // Выбор частоты
              GestureDetector(
                onTap: () => _showPicker(),
                child: Container(
                  width: 180,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _selected,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              SizedBox(
                width: 260,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(width: 1),
                  ),
                  onPressed: _next,
                  child: const Text('Далее'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _options.map((opt) {
            return ListTile(
              title: Text(
                'Каждые $opt',
                style: const TextStyle(fontSize: 18),
              ),
              trailing:
              _selected == opt ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _selected = opt);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}