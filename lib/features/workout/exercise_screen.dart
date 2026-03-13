import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/navigation.dart';
import '../exercises/domain/exercise_models.dart';
import 'end_of_the_workout_screen.dart';

/// Экран выполнения упражнения с таймером обратного отсчёта.
class ExerciseScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const ExerciseScreen({super.key, required this.exercises});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late int _totalSeconds;
  int _currentIndex = 0;
  bool _isPaused = false;
  bool _isFavorite = false;

  Exercise get _exercise => widget.exercises[_currentIndex];

  @override
  void initState() {
    super.initState();
    _totalSeconds = _exercise.defaultDurationSec;
    _initTimer();
  }

  void _initTimer() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalSeconds),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        _onExerciseDone();
      }
    });
    _controller.forward();
    _isPaused = false;
  }

  void _togglePause() {
    setState(() {
      if (_isPaused) {
        _controller.forward();
      } else {
        _controller.stop();
      }
      _isPaused = !_isPaused;
    });
  }

  /// Отматывает таймер на delta секунд.
  /// delta > 0: добавить время (отмотать назад)
  /// delta < 0: убрать время (перемотать вперёд)
  void _adjustTime(int delta) {
    setState(() {
      final currentRemaining = _remainingSeconds;
      final newRemaining = (currentRemaining + delta).clamp(1, _totalSeconds);

      _controller.stop();

      // Пересчитываем progress на основе нового оставшегося времени
      final progress = 1.0 - (newRemaining / _totalSeconds);

      _controller.value = progress.clamp(0.0, 1.0);

      if (!_isPaused) _controller.forward();
    });
  }

  int get _remainingSeconds =>
      (_totalSeconds * (1.0 - _controller.value)).ceil();

  String get _timeString {
    final s = _remainingSeconds;
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _onExerciseDone() {
    if (_currentIndex >= widget.exercises.length - 1) {
      goToAndClear(context, const EndOfTheWorkoutScreen());
    } else {
      _controller.dispose();
      _currentIndex++;
      _totalSeconds = _exercise.defaultDurationSec;
      _initTimer();
      setState(() {});
    }
  }

  void _skipExercise() {
    _controller.stop();
    _onExerciseDone();
  }

  void _endWorkout() {
    _controller.stop();
    goToAndClear(context, const EndOfTheWorkoutScreen());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 18),

                  // Шапка
                  const Text(
                    '2 минуты',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Таймер
                  Text(
                    _timeString,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Круговой индикатор
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: _TimerPainter(
                        progress: _controller.value,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            _exercise.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Описание
                  if (!_isPaused)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _exercise.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const Spacer(flex: 1),

                  // ── Кнопки: активное состояние ──
                  if (!_isPaused) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _RoundButton(
                          label: '-15 сек',
                          onTap: () => _adjustTime(15), // Отмотать назад = добавить время
                        ),
                        _RoundButton(
                          label: 'пауза',
                          onTap: _togglePause,
                        ),
                        _RoundButton(
                          label: '+15 сек',
                          onTap: () => _adjustTime(-15), // Перемотать вперёд = убрать время
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _RoundButton(
                      label: 'избр',
                      onTap: () =>
                          setState(() => _isFavorite = !_isFavorite),
                      isSmall: true,
                      filled: _isFavorite,
                    ),
                  ],

                  // ── Кнопки: состояние паузы ──
                  if (_isPaused) ...[
                    _PauseButton(
                      label: 'продолжить',
                      onTap: _togglePause,
                    ),
                    const SizedBox(height: 12),
                    _PauseButton(
                      label: 'пропустить упражнение',
                      onTap: _skipExercise,
                    ),
                    const SizedBox(height: 12),
                    _PauseButton(
                      label: 'закончить тренировку',
                      onTap: _endWorkout,
                      isDestructive: true,
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Круглая кнопка ──

class _RoundButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSmall;
  final bool filled;

  const _RoundButton({
    required this.label,
    required this.onTap,
    this.isSmall = false,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmall ? 56.0 : 70.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? Colors.grey.shade500 : Colors.grey.shade300,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmall ? 11 : 12,
            fontWeight: FontWeight.w500,
            color: filled ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ── Кнопка в состоянии паузы ──

class _PauseButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _PauseButton({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(
            color: isDestructive ? Colors.red.shade300 : Colors.grey.shade400,
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ── CustomPainter для кругового таймера ──

class _TimerPainter extends CustomPainter {
  final double progress;

  _TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 8.0;

    // Фон
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Прогресс (оставшееся время)
    final progressPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * (1.0 - progress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerPainter old) => old.progress != progress;
}